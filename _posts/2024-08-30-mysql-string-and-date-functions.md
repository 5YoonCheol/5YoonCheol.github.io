---
title: "[MySql] 문자열·날짜 함수 정리: LIKE, DATE_FORMAT, 그리고 인덱스를 타게 쓰는 법"
date: 2024-08-30 02:00:00 +0900
categories: [Database, MySQL]
tags: ["mysql", "like", "date_format", "문자열-함수", "날짜-함수"]
description: MySQL에서 자주 쓰는 문자열 함수(LIKE, CONCAT, SUBSTRING, REPLACE)와 날짜 함수(DATE_FORMAT, DATE_ADD, DATEDIFF, STR_TO_DATE)를 예제로 정리하고, WHERE 절에서 이 함수들이 인덱스를 못 타게 만드는 경우와 피하는 방법을 다룬다.
tistory_url: https://yoon-ssi.tistory.com/37
tistory_urls: [https://yoon-ssi.tistory.com/31, https://yoon-ssi.tistory.com/37]
redirect_from:
  - /posts/mysql-like/
  - /posts/mysql-date-format/
render_with_liquid: false
---

> 2026년 11월에 "LIKE 사용법"과 "DATE_FORMAT 함수" 두 글을 하나로 합치고, 같이 자주 쓰는 함수와 인덱스 주의점을 더했다. 옛 주소로 들어오면 이 글로 넘어온다.
{: .prompt-info }

쿼리를 짜다 보면 문자열을 패턴으로 찾고, 날짜를 원하는 모양으로 바꾸는 일이 제일 잦다. 자주 쓰는 함수를 예제로 정리하고, 마지막에 이 함수들을 `WHERE`에 쓸 때 인덱스가 무력해지는 경우를 본다. 함수 자체보다 그쪽이 실무에서 더 자주 문제가 된다.

### 1. LIKE: 패턴으로 찾기

와일드카드 두 개로 패턴을 만든다. `%`는 0개 이상의 아무 문자, `_`는 정확히 문자 하나다.

```sql
SELECT * FROM users WHERE name LIKE 'J%';     -- J로 시작
SELECT * FROM users WHERE name LIKE '%a';     -- a로 끝남
SELECT * FROM users WHERE name LIKE '_a_';    -- 세 글자이고 가운데가 a
SELECT * FROM users WHERE name LIKE '%kim%';  -- kim 포함
```

`%`나 `_` 자체를 찾아야 하면 이스케이프한다.

```sql
SELECT * FROM products WHERE code LIKE '50\%%';   -- "50%" 로 시작
SELECT * FROM products WHERE code LIKE '50#%%' ESCAPE '#';
```

**대소문자**: 컬럼의 콜레이션이 `_ci`(case-insensitive, 기본값 `utf8mb4_0900_ai_ci`)면 `LIKE 'j%'`가 `J`로 시작하는 값도 찾는다. 구분해야 하면 `BINARY`를 붙이거나 `_bin`/`_cs` 콜레이션을 쓴다.

```sql
SELECT * FROM users WHERE name LIKE BINARY 'J%';
```

**애플리케이션에서 넘길 때**: MyBatis나 JPA에서 검색어를 바인딩할 때는 패턴을 SQL 쪽에서 만든다. 검색어에 `%`가 들어오면 의도치 않은 전체 검색이 되니 필요하면 이스케이프한다.

```sql
SELECT * FROM users WHERE name LIKE CONCAT(#{keyword}, '%');
```

### 2. 자주 쓰는 문자열 함수

```sql
SELECT
    CONCAT(last_name, ' ', first_name)          AS full_name,     -- 이어 붙이기
    CONCAT_WS('-', '010', '1234', '5678')       AS phone,         -- 구분자로 이어 붙이기
    SUBSTRING(email, 1, INSTR(email, '@') - 1)  AS email_id,      -- @ 앞부분
    LEFT(ssn, 6)                                AS birth,         -- 왼쪽 6자
    RIGHT(phone, 4)                             AS phone_tail,    -- 오른쪽 4자
    REPLACE(phone, '-', '')                     AS phone_digits,  -- 치환
    TRIM(name)                                  AS trimmed,       -- 양쪽 공백 제거
    LPAD(seq, 6, '0')                           AS padded,        -- 000042
    CHAR_LENGTH(name)                           AS len,           -- 글자 수 (LENGTH 는 바이트 수)
    UPPER(code), LOWER(code)
FROM users;
```

한글은 `LENGTH()`가 바이트 수(utf8mb4에서 글자당 3바이트)를 돌려주니 글자 수는 `CHAR_LENGTH()`를 쓴다.

### 3. DATE_FORMAT: 날짜를 원하는 모양으로

```sql
DATE_FORMAT(date, format)
```

자주 쓰는 서식 지시자는 이렇다.

| 지시자 | 뜻 | 예 |
|---|---|---|
| `%Y` / `%y` | 4자리 / 2자리 연도 | 2024 / 24 |
| `%m` / `%c` | 2자리 / 1~2자리 월 | 08 / 8 |
| `%d` / `%e` | 2자리 / 1~2자리 일 | 09 / 9 |
| `%H` / `%h` | 24시간 / 12시간 | 14 / 02 |
| `%i` | 분 | 30 |
| `%s` | 초 | 45 |
| `%p` | AM/PM | PM |
| `%W` / `%a` | 요일 이름 / 약식 | Sunday / Sun |
| `%M` / `%b` | 월 이름 / 약식 | August / Aug |

```sql
SELECT DATE_FORMAT(NOW(), '%Y-%m-%d');              -- 2024-08-25
SELECT DATE_FORMAT(NOW(), '%d/%m/%Y');              -- 25/08/2024
SELECT DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s');     -- 2024-08-25 14:30:45
SELECT DATE_FORMAT(NOW(), '%W, %M %e, %Y %h:%i %p'); -- Sunday, August 25, 2024 02:30 PM
SELECT DATE_FORMAT(NOW(), '%Y-%m');                 -- 월별 집계용 2024-08
```

`%i`가 분이고 `%m`이 월이라는 것만 헷갈리지 않으면 된다. 반대로 문자열을 날짜로 바꿀 때는 `STR_TO_DATE('25/08/2024', '%d/%m/%Y')`를 쓴다.

### 4. 자주 쓰는 날짜 함수

```sql
SELECT
    NOW(), CURDATE(), CURTIME(),                       -- 현재 일시 / 날짜 / 시간
    DATE(created_at),                                  -- DATETIME 에서 날짜만
    DATE_ADD(created_at, INTERVAL 7 DAY),              -- 7일 뒤
    DATE_SUB(NOW(), INTERVAL 1 MONTH),                 -- 한 달 전
    DATEDIFF(NOW(), created_at),                       -- 일 수 차이
    TIMESTAMPDIFF(MINUTE, created_at, NOW()),          -- 분 단위 차이
    LAST_DAY(NOW()),                                   -- 이번 달 마지막 날
    YEAR(created_at), MONTH(created_at), DAYOFWEEK(created_at)
FROM orders;
```

시간대는 `SELECT @@session.time_zone`으로 확인한다. 서버가 UTC이고 애플리케이션이 KST면 `CONVERT_TZ(created_at, '+00:00', '+09:00')`로 바꾸거나, 커넥션 설정(`serverTimezone=Asia/Seoul`)을 맞춘다. 날짜 집계가 하루씩 어긋나면 대부분 이 문제다.

### 5. 함수를 WHERE에 쓰면 인덱스를 못 탄다

여기가 핵심이다. 컬럼에 함수를 씌워 비교하면 MySQL은 모든 행에 함수를 적용해 봐야 하므로 인덱스를 쓰지 못한다. 실행 계획에 `type: ALL`이 뜬다.

```sql
-- 인덱스를 못 탄다: 컬럼에 함수
SELECT * FROM orders WHERE DATE_FORMAT(created_at, '%Y-%m') = '2024-08';
SELECT * FROM orders WHERE DATE(created_at) = '2024-08-25';
SELECT * FROM orders WHERE YEAR(created_at) = 2024;
SELECT * FROM users  WHERE LOWER(email) = 'a@example.com';
SELECT * FROM users  WHERE name LIKE '%kim';        -- 앞에 % 가 오면 범위를 못 잡는다

-- 인덱스를 탄다: 컬럼은 그대로 두고 비교값을 범위로
SELECT * FROM orders WHERE created_at >= '2024-08-01' AND created_at < '2024-09-01';
SELECT * FROM orders WHERE created_at >= '2024-08-25' AND created_at < '2024-08-26';
SELECT * FROM users  WHERE email = 'a@example.com';  -- _ci 콜레이션이면 LOWER 가 필요 없다
SELECT * FROM users  WHERE name LIKE 'kim%';          -- 앞부분 일치는 범위 검색이 된다
```

날짜는 "그 달의 첫날 이상, 다음 달 첫날 미만"으로 쓰는 습관을 들이면 된다. `BETWEEN '2024-08-01' AND '2024-08-31'`은 8월 31일 00:00:00까지만 포함해서 그날 데이터가 빠지니 `<` 다음 달 첫날로 쓴다.

뒷부분 일치(`LIKE '%1234'`)가 꼭 필요하면 뒤집은 값을 저장한 컬럼에 인덱스를 걸거나(`REVERSE(phone)`), 전문 검색(FULLTEXT)이나 별도 검색 엔진을 고려한다. 8.0.13부터는 함수 기반 인덱스로 `CREATE INDEX idx ON users ((LOWER(email)))`처럼 표현식에 직접 인덱스를 걸 수도 있다.

### 6. 정리

- `LIKE`는 `%`, `_`, 이스케이프, 콜레이션만 알면 된다. 앞부분 일치만 인덱스를 탄다.
- `DATE_FORMAT`은 보여 줄 때 쓰고, 조건에는 쓰지 않는다. 조건은 범위로 쓴다.
- 함수를 `WHERE`의 컬럼 쪽에 씌우는 순간 풀 스캔이다. 비교값 쪽을 가공한다.
- 실행 계획 읽는 법과 인덱스 설계는 [쿼리 튜닝 기본기](/posts/mysql-query-tuning-basics/)에 정리했다.
