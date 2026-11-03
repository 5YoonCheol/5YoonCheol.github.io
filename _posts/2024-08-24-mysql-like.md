---
title: "[MySql] LIKE 사용법"
date: 2024-08-24 06:06:07 +0900
categories: [Database, MySQL]
tags: ["like", "mysql", "sql", "쿼리"]
tistory_url: https://yoon-ssi.tistory.com/31
render_with_liquid: false
---

MySQL의 LIKE 연산자는 문자열에서 특정 패턴을 검색할 때 사용한다. 주로 WHERE 절과 함께 사용되며, 특정 패턴과 일치하는 레코드를 필터링한다.

---

### 기본 사용법

LIKE 연산자는 두 가지 와일드카드(%, _)를 사용하여 패턴을 정의한다.

- %는 0개 이상의 문자를 대체한다.
- _는 정확히 하나의 문자를 대체한다.

예를 들어, LIKE 'a%'는 'a'로 시작하는 모든 문자열을 찾고, LIKE '_a%'는 두 번째 문자가 'a'인 모든 문자열을 찾는다.

---

### 예제

다음 SQL 쿼리로 name 칼럼에서 'J'로 시작하는 모든 레코드를 검색할 수 있다.

```sql
SELECT * FROM users WHERE name LIKE 'J%';
```

이 쿼리는 users 테이블에서 name이 'J'로 시작하는 모든 레코드를 반환한다.

또한, 'a'로 끝나는 이름을 찾고 싶다면 다음과 같이 작성한다.

```sql
SELECT * FROM users WHERE name LIKE '%a';
```

이 경우, name이 'a'로 끝나는 모든 레코드가 반환된다.

---

### LIKE와 _의 사용

문자 하나만 대체하려면 _를 사용한다.

예를 들어, 세 글자로 구성된 이름 중 가운데 글자가 'a'인 레코드를 찾고자 할 때는 다음과 같이 한다.

```sql
SELECT * FROM users WHERE name LIKE '_a_';
```

이 쿼리는 정확히 세 글자로 구성된 이름 중 두 번째 글자가 'a'인 모든 레코드를 반환한다.

---

### 대소문자 구분

MySQL에서 LIKE는 기본적으로 대소문자를 구분하지 않는다. 예를 들어, LIKE 'j%'는 'J', 'j'로 시작하는 모든 문자열을 찾는다.

하지만 대소문자를 구분해야 한다면 BINARY 키워드를 사용할 수 있다.

```sql
SELECT * FROM users WHERE name LIKE BINARY 'J%';
```

이 쿼리는 'J'로 시작하는 이름만 반환하고, 'j'로 시작하는 이름은 제외한다.

---

### 결론

LIKE 연산자는 MySQL에서 문자열 검색 시 매우 유용하게 사용된다. % 와 _ 와일드카드를 통해 유연한 패턴 매칭을 할 수 있으며, 대소문자 구분이 필요할 때는 BINARY 키워드를 활용한다. 이를 통해 원하는 패턴의 데이터를 손쉽게 검색할 수 있다.
