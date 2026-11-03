---
title: "[MySql] 서브쿼리 사용법"
date: 2024-08-31 11:11:57 +0900
categories: [Database, MySQL]
tags: ["mysql", "subquery", "서브쿼리"]
tistory_url: https://yoon-ssi.tistory.com/38
render_with_liquid: false
---

MySQL에서 서브쿼리(Subquery)는 쿼리 내에서 다른 쿼리를 중첩하여 사용하는 것을 뜻한다.

서브쿼리는 주로 복잡한 쿼리를 단순화하거나, 특정 조건에 맞는 데이터를 추출할 때 유용하게 사용할 수 있다.

---

### 서브쿼리의 유형

1. **스칼라 서브쿼리**: 단일 값을 반환하는 서브쿼리
2. **다중 행 서브쿼리**: 여러 행을 반환하는 서브쿼리
3. **다중 열 서브쿼리**: 여러 열을 반환하는 서브쿼리
4. **상관 서브쿼리**: 외부 쿼리와 연관되어 있는 서브쿼리

---

### 서브쿼리의 위치

- **SELECT 절**: 반환된 결과에서 특정 값을 계산할 때 사용.
- **FROM 절**: 서브쿼리를 하나의 테이블처럼 사용.
- **WHERE 절**: 조건절로 사용하여 데이터 필터링.
- **HAVING 절**: 그룹화된 데이터에 대한 조건으로 사용.

---

### **예제

#### 1. WHERE 절에서 서브쿼리 사용

가장 기본적인 사용법으로, 특정 조건을 만족하는 데이터를 필터링할 때 사용한다.

**예제**: 특정 고객이 주문한 상품들의 가격을 확인하는 쿼리

```sql
SELECT product_name, price
FROM products
WHERE product_id IN (SELECT product_id FROM orders WHERE customer_id = 1);
```

**설명**: orders 테이블에서 customer_id가 1인 모든 product_id를 서브쿼리로 가져오고, 이 product_id들에 해당하는 products의 이름과 가격을 반환한다.

#### 2. SELECT 절에서 서브쿼리 사용

SELECT 절 내에서 특정 값을 계산할 때 사용한다.

**예제**: 각 고객이 주문한 총 금액을 확인하는 쿼리

```sql
SELECT customer_id,
       (SELECT SUM(price) FROM orders WHERE orders.customer_id = customers.customer_id) AS total_spent
FROM customers;
```

**설명**: customers 테이블의 각 고객에 대해, 해당 고객의 총 주문 금액을 계산하여 반환한다.

#### 3. FROM 절에서 서브쿼리 사용

서브쿼리를 마치 테이블처럼 취급하여 FROM 절에서 사용한다.

**예제**: 주문 수가 5개 이상인 고객들의 정보를 가져오는 쿼리

```sql
SELECT customer_id, total_orders
FROM (SELECT customer_id, COUNT(*) AS total_orders FROM orders GROUP BY customer_id) AS order_summary
WHERE total_orders >= 5;
```

**설명**: 서브쿼리에서 orders 테이블을 그룹화하여 고객별 주문 수를 계산하고, 이를 order_summary라는 가상 테이블로 사용하여 최종 결과를 필터링한다.

#### 4. 상관 서브쿼리

서브쿼리가 외부 쿼리의 값을 참조하여 동작하는 경우에 사용한다.

**예제**: 각 직원이 처리한 주문의 평균 금액을 조회하는 쿼리

```sql
SELECT employee_id,
       (SELECT AVG(price) FROM orders WHERE orders.employee_id = employees.employee_id) AS avg_order_value
FROM employees;
```

**설명**: employees 테이블의 각 직원에 대해, 해당 직원이 처리한 주문의 평균 금액을 계산하여 반환한다. 이때 서브쿼리는 외부 쿼리(employees.employee_id)의 값을 참조한다.

---

### 서브쿼리 사용 시 주의사항!

1. **성능 문제**: 서브쿼리는 때때로 성능 문제를 야기할 수 있다. 특히 큰 데이터셋에서 상관 서브쿼리를 사용할 때 주의가 필요하다.
2. **LIMIT 사용**: 서브쿼리 내에서 LIMIT 절을 사용하여 반환되는 결과를 제한할 수 있다.
3. **단일 값 반환**: 서브쿼리가 단일 값을 반환해야 하는 경우, 다중 행이나 열이 반환되지 않도록 주의해야 한다.
