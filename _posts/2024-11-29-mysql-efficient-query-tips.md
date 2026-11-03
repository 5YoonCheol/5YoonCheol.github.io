---
title: "[MySql] MySql 효율적인 쿼리 작성을 위한 팁"
date: 2024-11-29 02:00:00 +0900
categories: [Database, MySQL]
tags: ["mysql"]
tistory_url: https://yoon-ssi.tistory.com/130
render_with_liquid: false
---

쿼리만 잘 짜도 데이터베이스 성능이 꽤 달라진다. 오늘은 MySQL 쿼리를 빠르게 만드는 팁 몇 가지를 정리해보려고 한다.

---

1. 인덱스(Index) 활용
   - WHERE, ORDER BY, GROUP BY에 쓰는 열에는 인덱스를 걸어두자.
   - EXPLAIN으로 쿼리 실행 계획을 확인하자.
2. JOIN 최적화
   - 작은 테이블부터 큰 테이블 순서로 JOIN하면 메모리를 덜 쓴다.
   - `ON` 조건에 맞는 인덱스를 걸어두자.
   - 서브쿼리 대신 JOIN을 쓰면 빨라지는 경우가 있다.

```sql
-- 서브쿼리
SELECT name FROM users WHERE id IN (SELECT user_id FROM orders);
```

```sql
-- JOIN 대체
SELECT u.name FROM users u JOIN orders o ON u.id = o.user_id;
```
