---
title: "[MySql] LIKE 사용법"
date: 2024-08-24 02:00:00 +0900
categories: [Database, MySQL]
tags: ["like", "mysql", "sql", "쿼리"]
tistory_url: https://yoon-ssi.tistory.com/31
render_with_liquid: false
---

MySQL의 LIKE 연산자는 문자열에서 특정 패턴을 찾을 때 쓴다. 주로 WHERE 절에 붙여서 패턴에 맞는 레코드만 걸러낸다.

---

### 기본 사용법

와일드카드 두 개(`%`, `_`)로 패턴을 만든다.

- `%`는 0개 이상의 아무 문자를 뜻한다.
- `_`는 정확히 문자 하나를 뜻한다.

`LIKE 'a%'`는 'a'로 시작하는 모든 문자열을 찾고, `LIKE '_a%'`는 두 번째 문자가 'a'인 문자열을 찾는다.

---

### 예제

name 칼럼에서 'J'로 시작하는 레코드를 찾아보자.

```sql
SELECT * FROM users WHERE name LIKE 'J%';
```

users 테이블에서 name이 'J'로 시작하는 레코드가 전부 나온다.

'a'로 끝나는 이름을 찾고 싶으면 이렇게 쓴다.

```sql
SELECT * FROM users WHERE name LIKE '%a';
```

name이 'a'로 끝나는 레코드가 나온다.

---

### `_` 사용하기

문자 하나만 대신하려면 `_`를 쓴다.

세 글자 이름 중 가운데 글자가 'a'인 레코드를 찾으려면 이렇게 한다.

```sql
SELECT * FROM users WHERE name LIKE '_a_';
```

정확히 세 글자이면서 두 번째 글자가 'a'인 이름만 나온다.

---

### 대소문자 구분

MySQL의 LIKE는 기본적으로 대소문자를 구분하지 않는다. `LIKE 'j%'`는 'J'로 시작하는 것도, 'j'로 시작하는 것도 다 찾는다.

대소문자를 구분해야 한다면 BINARY 키워드를 붙이면 된다.

```sql
SELECT * FROM users WHERE name LIKE BINARY 'J%';
```

이러면 'J'로 시작하는 이름만 나오고 'j'로 시작하는 이름은 빠진다.

---

정리하면 `%`와 `_`만 알면 웬만한 패턴 검색은 다 되고, 대소문자를 가려야 할 때만 BINARY를 붙이면 된다.
