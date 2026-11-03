---
title: "[MySql] UNION이란?"
date: 2024-08-26 04:04:15 +0900
categories: [Database, MySQL]
tags: ["mysql", "union", "union-all"]
tistory_url: https://yoon-ssi.tistory.com/33
render_with_liquid: false
---

[이전 글](/posts/mysql-join/)에서 UNION은 웬만하면 쓰지 말자고 했는데, 오늘은 그 이유도 설명할 겸 UNION을 정리해보려 한다.

MySQL의 UNION은 SELECT 쿼리 두 개 이상의 결과를 하나로 합칠 때 쓴다. 각 쿼리 결과가 이어 붙어서 결과 집합 하나로 나온다.

---

### 기본 사용법

UNION은 기본적으로 중복된 행을 제거한다. 중복까지 전부 남기고 싶으면 UNION ALL을 쓴다.

```sql
SELECT name FROM employees
UNION
SELECT name FROM customers;
```

employees 테이블과 customers 테이블의 name을 중복 없이 모두 가져오는 쿼리다. 중복된 name도 다 보고 싶으면 UNION ALL로 바꾸면 된다.

```sql
SELECT name FROM employees
UNION ALL
SELECT name FROM customers;
```

---

### 쓰기 위한 조건

- SELECT 쿼리마다 열 개수가 같아야 한다.
- 같은 위치의 열끼리 데이터 타입이 같거나 호환돼야 한다.

한 쿼리는 열 두 개를, 다른 쿼리는 열 세 개를 반환한다면 UNION으로 합칠 수 없다.

---

### UNION과 JOIN의 차이

UNION은 결과 집합을 세로로(위아래로) 붙이고, JOIN은 두 테이블을 가로로(좌우로) 붙여서 관련 데이터를 연결한다.

---

### UNION을 잘 안 쓰는 이유

1. 성능: SELECT를 여러 번 실행한 다음 결과를 합쳐야 해서 데이터가 많으면 느려진다. 게다가 UNION은 중복 제거 연산까지 하니까 큰 데이터셋에서는 부담이 꽤 커진다.
2. 중복 처리: UNION은 기본으로 중복을 지우고, 중복이 필요하면 UNION ALL을 써야 한다. 이걸 헷갈리면 예상과 다른 결과가 나올 수 있다.
3. 쿼리 구조: 복잡한 비즈니스 로직은 JOIN으로 묶는 편이 더 직관적이다. JOIN은 테이블 간 관계를 기준으로 데이터를 합치니 쿼리를 읽기도 쉽다.
4. 대안: 하위 쿼리, 공통 테이블 표현식(CTE), 뷰(View) 같은 방법으로 복잡한 데이터를 더 효율적으로 처리할 수 있어서 UNION 대신 이쪽을 쓰는 경우가 많다.

---

UNION은 여러 쿼리 결과를 합칠 때 편하지만, 성능과 중복 처리 문제가 있어서 요즘은 JOIN, 하위 쿼리, CTE 같은 방법을 먼저 고려한다. 쓸 때는 데이터 양과 중복 여부를 한 번 따져보고 쓰자.
