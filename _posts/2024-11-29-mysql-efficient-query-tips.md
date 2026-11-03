---
title: "[MySql] MySql 효율적인 쿼리 작성을 위한 팁"
date: 2024-11-29 10:00:21 +0900
categories: [Database, MySQL]
tags: ["mysql"]
tistory_url: https://yoon-ssi.tistory.com/130
render_with_liquid: false
---

**효율적인 쿼리는 데이터베이스 성능의 핵심!**  
오늘은 MySQL에서 성능을 극대화할 수 있는 몇 가지 쿼리 최적화 팁을 알아보려고 한다.

---

1. **인덱스(Index) 활용**
   - WHERE, ORDER BY, GROUP BY에 사용되는 열은 적절한 인덱스를 설정하자.
   - EXPLAIN 명령어를 사용해 쿼리 실행 계획을 확인하자.
2. **JOIN 최적화**
   - 작은 테이블부터 큰 테이블로 JOIN을 수행하면 메모리 사용량을 줄일 수 있다.
   - `ON` 조건에 적합한 인덱스를 설정하자.
   - 서브쿼리 대신 JOIN을 사용하면 성능이 향상될 수 있다.

```sql
-- 서브쿼리
SELECT name FROM users WHERE id IN (SELECT user_id FROM orders);
```

```sql
-- JOIN 대체
SELECT u.name FROM users u JOIN orders o ON u.id = o.user_id;
```
