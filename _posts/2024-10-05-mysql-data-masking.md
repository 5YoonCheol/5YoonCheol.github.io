---
title: "[MySql] 데이터 마스킹 처리 방법"
date: 2024-10-05 09:09:17 +0900
categories: [Database, MySQL]
tags: ["masking", "mysql", "데이터-마스킹"]
tistory_url: https://yoon-ssi.tistory.com/74
render_with_liquid: false
---

데이터 마스킹은 개발이나 테스트 환경에서 실 데이터를 그대로 쓰지 않게 하고, 외부에서 접근할 때 민감한 정보가 노출되지 않게 하려고 쓴다.

MySQL에는 마스킹 기능이 따로 있지 않지만, SQL 쿼리, 함수, 뷰 같은 걸 조합해서 직접 만들 수 있다. 크게 동적 마스킹과 정적 마스킹으로 나뉜다.

---

### 1. MySQL에서 마스킹 구현하기

#### 1.1. 뷰(View)로 동적 마스킹

뷰를 만들어서 특정 열을 가린 상태로 돌려주게 할 수 있다. 동적 마스킹은 원본은 그대로 두고, 조회할 때마다 가린 값을 돌려주는 방식이다.

```sql
-- 예시: 주민등록번호 컬럼을 부분적으로 마스킹하는 뷰 생성
CREATE VIEW masked_users AS
SELECT
    id,
    name,
    CONCAT(LEFT(ssn, 6), '******') AS masked_ssn
FROM users;
```

users 테이블의 주민등록번호(ssn) 컬럼에서 앞 6자리만 남기고 나머지는 `******`로 가린다. 이제 masked_users 뷰로 조회하면 민감한 데이터가 가려진 채로 나온다.

```sql
SELECT * FROM masked_users;
```

#### 1.2. SQL 함수로 마스킹

사용자 정의 함수를 만들어서 정해진 패턴대로 가릴 수도 있다. 신용카드 번호나 전화번호를 마스킹하는 함수를 만들어보자.

```sql
-- 전화번호 마스킹 함수 예시
CREATE FUNCTION mask_phone(phone VARCHAR(15)) RETURNS VARCHAR(15)
BEGIN
    RETURN CONCAT(LEFT(phone, 3), '****', RIGHT(phone, 4));
END;
```

mask_phone 함수는 전화번호 가운데 4자리를 `****`로 바꿔서 돌려준다.

```sql
-- 함수 사용 예시
SELECT id, mask_phone(phone) FROM users;
```

#### 1.3. 정적 마스킹

정적 마스킹은 데이터를 아예 가린 값으로 바꿔서 저장하는 방식이다. 실제 데이터를 테스트 데이터로 써야 할 때 주로 쓴다.

전화번호를 바꾸는 쿼리는 이렇다.

```sql
-- 전화번호를 임의로 변경하여 정적 마스킹 처리
UPDATE users
SET phone = CONCAT(LEFT(phone, 3), '****', RIGHT(phone, 4));
```

users 테이블의 phone 열 일부를 가린 다음 그 값으로 UPDATE해버린다. 원래 값은 남지 않는다.

#### 1.4. 조건에 따라 다르게 마스킹

사용자 역할이나 권한에 따라 마스킹 여부를 다르게 할 수도 있다. 관리자는 실제 값을 보고, 일반 사용자는 가린 값을 보게 하는 식이다.

```sql
SELECT
    id,
    name,
    IF(user_role = 'admin', ssn, CONCAT(LEFT(ssn, 6), '******')) AS masked_ssn
FROM users;
```

user_role이 admin이면 실제 데이터를, 아니면 가린 데이터를 돌려준다.

---

### 2. 마스킹 방식

#### 2.1. 부분 마스킹

민감한 데이터의 일부만 가리고 나머지는 그대로 보여준다. 전화번호, 이메일, 주민등록번호에서 앞뒤 몇 자리만 남기고 가운데를 숨기는 식이다.

- 예: `john.doe@example.com` → `jo****@example.com`

```sql
SELECT
    CONCAT(LEFT(email, 2), '****', SUBSTRING(email, INSTR(email, '@'))) AS masked_email
FROM users;
```

#### 2.2. 완전 마스킹

데이터 전체를 다른 값이나 무작위 값으로 바꾼다. 테스트나 개발 환경에서 실 데이터 대신 쓸 때 주로 쓴다.

- 예: 주민등록번호 `123456-1234567` → `******-*******`

```sql
SELECT
    CONCAT(REPEAT('*', LENGTH(ssn) - 4), RIGHT(ssn, 4)) AS masked_ssn
FROM users;
```

#### 2.3. 난수로 바꾸기

민감한 데이터를 무작위 숫자나 문자열로 바꿔서 저장한다. 개인정보가 전혀 필요 없는 경우에 쓰기 좋다.

```sql
-- 랜덤으로 이름 대체
UPDATE users
SET name = CONCAT('User', FLOOR(1000 + RAND() * 9000));
```

---

### 3. 신경 써야 할 것들

1. 접근 제어: 민감한 정보에 접근할 수 있는 사용자를 제한하고, 원본을 볼 수 있는 사용자와 가린 데이터만 보는 사용자를 나눠야 한다. MySQL의 GRANT 명령어로 권한을 관리할 수 있다.
2. 규제 준수: GDPR, CCPA 같은 개인정보 보호법이 요구하는 수준을 맞추려면 민감한 정보를 암호화나 마스킹 같은 방법으로 보호해야 한다.
3. 성능: 뷰나 함수로 마스킹하면 조회할 때마다 계산이 들어가서 느려질 수 있다. 데이터가 많으면 성능도 같이 봐야 한다.
4. 암호화와의 차이: 마스킹은 데이터가 노출되지 않게 가리는 거고, 암호화는 권한 없는 사용자가 데이터를 풀어보지 못하게 보호하는 거다. 둘을 같이 쓰면 훨씬 안전하다.

---

실시간으로 가려서 보여주고 싶으면 동적 마스킹, 테스트용 데이터를 만들거나 원본을 아예 남기지 않아야 하면 정적 마스킹을 쓰면 된다. 어떤 걸 고를지는 보안 요구사항과 데이터 쓰임새에 맞춰 정하자.
