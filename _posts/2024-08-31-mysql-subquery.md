---
title: "[MySql] 서브쿼리 사용법"
date: 2024-08-31 11:11:57 +0900
categories: [Database, MySQL]
tags: ["mysql", "subquery", "서브쿼리"]
tistory_url: https://yoon-ssi.tistory.com/38
render_with_liquid: false
---

서브쿼리(Subquery)는 쿼리 안에 또 다른 쿼리를 넣어 쓰는 걸 말한다.

복잡한 쿼리를 좀 더 단순하게 쓰거나, 특정 조건에 맞는 데이터만 뽑아낼 때 유용하다.

---

### 서브쿼리 유형

1. 스칼라 서브쿼리: 값 하나를 돌려준다
2. 다중 행 서브쿼리: 여러 행을 돌려준다
3. 다중 열 서브쿼리: 여러 열을 돌려준다
4. 상관 서브쿼리: 바깥 쿼리의 값을 참조한다

---

### 어디에 쓸 수 있나

- SELECT 절: 결과에서 특정 값을 계산할 때
- FROM 절: 서브쿼리 결과를 테이블처럼 쓸 때
- WHERE 절: 조건으로 데이터를 거를 때
- HAVING 절: 그룹화한 데이터에 조건을 걸 때

---

### 예제

#### 1. WHERE 절에서 쓰기

제일 기본적인 사용법이다. 특정 조건을 만족하는 데이터만 거를 때 쓴다.

특정 고객이 주문한 상품들의 가격을 확인해보자.

```sql
SELECT product_name, price
FROM products
WHERE product_id IN (SELECT product_id FROM orders WHERE customer_id = 1);
```

orders 테이블에서 customer_id가 1인 product_id들을 서브쿼리로 가져오고, 그 product_id에 해당하는 상품 이름과 가격을 보여준다.

#### 2. SELECT 절에서 쓰기

SELECT 절 안에서 값을 계산할 때 쓴다.

고객별 총 주문 금액을 구해보자.

```sql
SELECT customer_id,
       (SELECT SUM(price) FROM orders WHERE orders.customer_id = customers.customer_id) AS total_spent
FROM customers;
```

customers 테이블의 고객마다 총 주문 금액을 계산해서 같이 보여준다.

#### 3. FROM 절에서 쓰기

서브쿼리 결과를 테이블처럼 FROM 절에 넣는다.

주문을 5번 이상 한 고객을 뽑아보자.

```sql
SELECT customer_id, total_orders
FROM (SELECT customer_id, COUNT(*) AS total_orders FROM orders GROUP BY customer_id) AS order_summary
WHERE total_orders >= 5;
```

서브쿼리에서 orders를 고객별로 묶어 주문 수를 세고, 그 결과를 order_summary라는 가상 테이블로 써서 5건 이상인 고객만 거른다.

#### 4. 상관 서브쿼리

서브쿼리가 바깥 쿼리의 값을 참조하는 경우다.

직원별로 처리한 주문의 평균 금액을 구해보자.

```sql
SELECT employee_id,
       (SELECT AVG(price) FROM orders WHERE orders.employee_id = employees.employee_id) AS avg_order_value
FROM employees;
```

employees 테이블의 직원마다 처리한 주문의 평균 금액을 계산한다. 서브쿼리 안에서 바깥 쿼리의 employees.employee_id를 참조하는 게 포인트다.

---

### 쓸 때 주의할 점!

1. 성능: 서브쿼리는 성능 문제를 일으킬 때가 있다. 특히 데이터가 많은 테이블에서 상관 서브쿼리를 쓸 때는 조심하자.
2. LIMIT: 서브쿼리 안에서 LIMIT으로 결과 개수를 제한할 수 있다.
3. 값 하나만 와야 할 때: 단일 값이 와야 하는 자리에 여러 행이나 열이 반환되지 않게 주의해야 한다.
