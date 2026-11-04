---
title: "개인정보 마스킹: 개념, 분리보관, 그리고 MySQL 구현"
date: 2024-10-05 02:00:00 +0900
categories: [Security, Encryption]
tags: ["데이터-마스킹", "db-마스킹", "데이터-분리보관", "mysql", "개인정보"]
description: 민감한 데이터를 보호하는 두 축인 데이터 분리보관과 마스킹을 정리한다. 정적·동적·부분 마스킹의 차이, 암호화와의 차이, 그리고 MySQL에서 뷰·함수·역할 기반으로 마스킹을 구현하는 SQL 예제를 다룬다.
tistory_url: https://yoon-ssi.tistory.com/74
tistory_urls: [https://yoon-ssi.tistory.com/72, https://yoon-ssi.tistory.com/74]
redirect_from:
  - /posts/data-separation-and-db-masking/
  - /posts/mysql-data-masking/
render_with_liquid: false
---

> 2026년 11월에 "데이터 분리보관 및 DB 마스킹"과 "MySql 데이터 마스킹 처리 방법" 두 글을 하나로 합쳐 다시 썼다. 옛 주소로 들어오면 이 글로 넘어온다.
{: .prompt-info }

개인정보를 다루는 시스템이라면 "접근을 아예 막는다"와 "보더라도 알아볼 수 없게 한다" 두 가지를 같이 챙겨야 한다. 앞쪽이 데이터 분리보관이고 뒤쪽이 마스킹이다. 개념을 먼저 정리하고 MySQL에서 실제로 어떻게 구현하는지 본다.

### 1. 데이터 분리보관 (Data Segregation)

중요한 데이터를 일반 데이터와 따로 떼어서 보관하고, 그 데이터가 필요 없는 사용자나 시스템은 접근하지 못하게 한다.

- 물리적 분리: 서로 다른 서버나 DB에 저장한다. 결제 정보와 일반 회원 정보를 아예 다른 DB에 두는 식이다.
- 논리적 분리: 같은 DB 안이지만 스키마와 계정 권한으로 나눈다. 민감 컬럼이 있는 테이블은 별도 계정만 읽을 수 있게 한다.
- 네트워크 분리: 민감 데이터를 처리하는 시스템을 외부망과 떨어진 망에서 돌린다. 망분리라고 부르고, 업무망·외부망을 나누는 게 대표적이다.

분리해 두면 접근 통제가 명확해지고, 유출 사고가 나도 피해 범위가 나뉜 영역 안에서 끝난다.

### 2. 마스킹 (Data Masking)

민감한 값을 실제 값 대신 가린 값으로 보여 줘서, 권한 없는 사람이 데이터를 봐도 중요한 부분은 알 수 없게 한다. 주민등록번호, 카드 번호, 전화번호, 이메일이 대상이다.

언제 가리느냐로 나누면 두 가지다.

- 정적 마스킹 (Static): 원본을 복사해 가린 값으로 바꾼 DB를 따로 만든다. 운영 데이터를 테스트·개발 환경으로 가져올 때 쓴다. 원본은 남지 않는다.
- 동적 마스킹 (Dynamic): 원본은 그대로 두고 조회할 때 가려서 돌려준다. 같은 데이터를 권한에 따라 다르게 보여 줄 수 있다.

어떻게 가리느냐로 나누면 이렇다.

| 방식 | 예 |
|---|---|
| 부분 마스킹 | `010-1234-5678` → `010-****-5678`, `john.doe@example.com` → `jo****@example.com` |
| 완전 마스킹 | `900101-1234567` → `******-*******` |
| 날짜 마스킹 | `1990-01-01` → `1990-**-**` |
| 치환(난수·가명) | 이름을 `User4821`처럼 무관한 값으로 교체 |

마스킹은 암호화와 다르다. 암호화는 키가 있으면 원본으로 되돌릴 수 있지만, 마스킹은 되돌릴 수 없고 되돌릴 필요도 없는 자리에 쓴다. 저장할 때는 암호화, 보여 줄 때는 마스킹을 같이 쓰는 게 보통이다. 암호화 구현은 [AES-256 양방향 암호화](/posts/java-aes256-encryption/)와 [SHA-256 단방향 암호화](/posts/java-sha256-hashing/) 글에 정리했다.

### 3. MySQL에서 구현하기

MySQL Community 에디션에는 마스킹 기능이 따로 없다(Enterprise에는 `MASK_INNER` 같은 함수가 있다). 뷰, 함수, 권한을 조합해서 직접 만든다.

#### 3.1. 뷰로 동적 마스킹

```sql
CREATE VIEW masked_users AS
SELECT
    id,
    name,
    CONCAT(LEFT(ssn, 6), '-*******')                              AS ssn,
    CONCAT(LEFT(phone, 3), '-****-', RIGHT(phone, 4))             AS phone,
    CONCAT(LEFT(email, 2), '****', SUBSTRING(email, INSTR(email, '@'))) AS email
FROM users;
```

원본 테이블 `users`에는 권한을 주지 않고 `masked_users` 뷰에만 `SELECT`를 주면, 그 계정은 가린 값만 본다.

```sql
CREATE USER 'cs_agent'@'%' IDENTIFIED BY '...';
GRANT SELECT ON mydb.masked_users TO 'cs_agent'@'%';
-- mydb.users 에는 권한 없음
```

#### 3.2. 함수로 규칙 재사용

같은 마스킹 규칙을 여러 곳에서 쓰면 함수로 뺀다.

```sql
DELIMITER $$
CREATE FUNCTION mask_phone(phone VARCHAR(20)) RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF phone IS NULL OR CHAR_LENGTH(phone) < 7 THEN
        RETURN phone;
    END IF;
    RETURN CONCAT(LEFT(phone, 3), '-****-', RIGHT(phone, 4));
END$$
DELIMITER ;

SELECT id, mask_phone(phone) AS phone FROM users;
```

`DETERMINISTIC`을 붙여야 바이너리 로그 설정에 따라 함수 생성이 거부되는 일을 피할 수 있다. NULL과 짧은 값은 그대로 돌려주지 않으면 `RIGHT()`가 엉뚱한 결과를 낸다.

#### 3.3. 권한에 따라 다르게 보여 주기

```sql
SELECT
    id,
    name,
    IF(CURRENT_ROLE() = '`admin`@`%`', ssn, CONCAT(LEFT(ssn, 6), '-*******')) AS ssn
FROM users;
```

MySQL 8.0의 역할(`CREATE ROLE`)을 쓰면 계정이 아니라 역할 기준으로 분기할 수 있다. 다만 이 방식은 뷰 정의 안에 분기가 들어가므로, 애플리케이션 계층에서 권한에 따라 다른 뷰를 쓰게 하는 쪽이 관리하기 쉽다.

#### 3.4. 정적 마스킹: 테스트 DB 만들기

운영 데이터를 덤프해서 개발 환경에 넣기 전에 민감 컬럼을 덮어쓴다.

```sql
UPDATE users
SET phone = CONCAT(LEFT(phone, 3), '-****-', RIGHT(phone, 4)),
    email = CONCAT('user', id, '@example.com'),
    name  = CONCAT('User', id),
    ssn   = NULL;
```

주의할 점은 이 `UPDATE`를 운영 DB에서 실행하면 안 된다는 것이다. 반드시 복제본이나 덤프를 복원한 DB에서 돌린다. 이메일은 `id` 기준으로 치환해 유일성을 유지해야 `UNIQUE` 제약에 걸리지 않는다.

### 4. 운영할 때 신경 쓸 것

- 접근 제어가 먼저다. 마스킹 뷰를 만들어도 원본 테이블 권한이 남아 있으면 의미가 없다. `SHOW GRANTS`로 계정별 권한을 주기적으로 본다.
- 마스킹한 값으로 검색이 되는지 확인한다. 전화번호 뒷자리로 조회하는 기능이 있다면 뷰에서도 뒷자리는 남겨야 한다.
- 뷰와 함수는 조회할 때마다 계산이 들어간다. 대량 조회 화면이면 실행 계획을 보고, 필요하면 마스킹된 컬럼을 별도 테이블에 미리 만들어 둔다.
- 로그에도 마스킹을 적용한다. DB를 가려도 애플리케이션 로그에 원본이 찍히면 소용없다.
- 개인정보보호법, GDPR 같은 규제는 "가명처리"와 "암호화"를 구분해서 요구한다. 어떤 컬럼에 무엇을 적용했는지 목록으로 관리한다.

### 5. 정리

데이터 분리보관은 접근 자체를 막고, 마스킹은 보더라도 알아볼 수 없게 한다. 개인정보를 다룬다면 둘 다 필요하다. MySQL에서는 원본 테이블 권한을 닫고 마스킹 뷰에만 권한을 주는 것이 가장 단순하고 안전한 출발점이다.
