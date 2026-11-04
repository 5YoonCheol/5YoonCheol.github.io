---
title: "[MySql] 쿼리 튜닝 기본기: EXPLAIN 읽기부터 인덱스 설계까지"
date: 2024-12-02 02:00:00 +0900
categories: [Database, MySQL]
tags: ["mysql", "쿼리튜닝", "인덱스", "explain", "성능-튜닝"]
description: 느린 MySQL 쿼리를 찾고 고치는 순서를 정리한다. EXPLAIN 읽는 법, B-Tree 인덱스 동작, 복합 인덱스 순서와 커버링 인덱스, 쿼리 다시 쓰기, 서버 설정과 모니터링까지 다룬다.
tistory_url: https://yoon-ssi.tistory.com/133
tistory_urls: [https://yoon-ssi.tistory.com/84, https://yoon-ssi.tistory.com/130, https://yoon-ssi.tistory.com/131, https://yoon-ssi.tistory.com/133]
redirect_from:
  - /posts/query-tuning/
  - /posts/mysql-efficient-query-tips/
  - /posts/mysql-index-design/
  - /posts/mysql-performance-tuning-tips/
render_with_liquid: false
---

> 2026년 11월에 "쿼리튜닝?", "효율적인 쿼리 작성을 위한 팁", "인덱스의 원리와 올바른 설계 전략", "성능 튜닝을 위한 5가지 팁" 네 글을 하나로 합쳐 다시 썼다. 옛 주소로 들어오면 이 글로 넘어온다.
{: .prompt-info }

쿼리 튜닝은 결과는 그대로 두고 실행 시간과 CPU, 메모리, 디스크 I/O를 줄이는 작업이다. "인덱스 걸어라, SELECT * 쓰지 마라" 같은 팁은 많이 들었을 텐데, 실제로 느린 쿼리를 앞에 두면 어디서부터 봐야 할지 막막하다. 이 글은 그 순서를 정리한다. 느린 쿼리를 찾고, 실행 계획을 읽고, 인덱스를 고치고, 그래도 안 되면 쿼리와 구조를 바꾼다.

### 1. 느린 쿼리부터 찾는다

감으로 튜닝하지 않는다. 어떤 쿼리가 얼마나 자주, 얼마나 오래 도는지 먼저 본다.

```sql
-- 1초 넘게 걸리는 쿼리를 슬로우 로그에 남긴다
SET GLOBAL slow_query_log = ON;
SET GLOBAL long_query_time = 1;

-- 지금 돌고 있는 쿼리
SHOW FULL PROCESSLIST;

-- 누적 통계 (8.0, performance_schema)
SELECT digest_text, count_star, avg_timer_wait / 1e9 AS avg_ms, sum_rows_examined
FROM performance_schema.events_statements_summary_by_digest
ORDER BY sum_timer_wait DESC
LIMIT 10;
```

`sum_rows_examined`가 `sum_rows_sent`보다 압도적으로 크면 읽은 행 대부분을 버리는 쿼리다. 보통 인덱스가 없거나 못 타는 경우라 튜닝 효과가 가장 크다.

### 2. EXPLAIN 읽는 법

실행 계획은 옵티마이저가 고른 경로다. 테이블을 어떤 순서로, 어떤 방식으로 읽고, 어느 인덱스를 쓰는지 보여준다.

```sql
EXPLAIN
SELECT o.id, o.created_at
FROM orders o
WHERE o.user_id = 42 AND o.status = 'PAID'
ORDER BY o.created_at DESC
LIMIT 20;
```

볼 순서는 이렇다.

| 컬럼 | 뜻 | 이렇게 나오면 문제 |
|---|---|---|
| `type` | 접근 방식 | `ALL`(풀 스캔), `index`(인덱스 전체 스캔). 좋은 순서는 `const` > `eq_ref` > `ref` > `range` > `index` > `ALL` |
| `key` | 실제로 쓴 인덱스 | `NULL`이면 인덱스를 못 탔다 |
| `rows` | 읽을 것으로 예상한 행 수 | 결과 행 수보다 훨씬 크면 인덱스가 조건을 덜 거른다 |
| `filtered` | 조건으로 걸러지는 비율(%) | 낮으면 인덱스 뒤에서 WHERE로 버리는 행이 많다 |
| `Extra` | 추가 작업 | `Using filesort`, `Using temporary`는 정렬·그룹을 메모리나 디스크에서 따로 한다는 뜻. `Using index`는 커버링 인덱스로 좋은 신호 |

`EXPLAIN ANALYZE`(8.0.18 이상)를 쓰면 예상치가 아니라 실제 실행 시간과 읽은 행 수가 나온다. 예상 `rows`와 실제가 크게 다르면 통계가 낡은 것이니 `ANALYZE TABLE`을 돌린다.

### 3. 인덱스가 동작하는 방식

MySQL(InnoDB)의 인덱스는 B-Tree다. 키 값으로 정렬된 트리라서 "같다", "범위", "앞부분 일치(LIKE 'abc%')", "정렬"에 쓸 수 있다. 반대로 정렬 순서를 쓸 수 없는 조건에는 인덱스가 무력하다.

- `WHERE YEAR(created_at) = 2024` — 컬럼에 함수를 씌우면 못 탄다. `created_at >= '2024-01-01' AND created_at < '2025-01-01'`로 바꾼다.
- `WHERE phone LIKE '%1234'` — 앞에 와일드카드가 오면 못 탄다.
- `WHERE user_id = '42'` — 컬럼이 숫자인데 문자열을 넣으면 형변환이 일어나 못 탈 수 있다. 반대도 마찬가지다.

InnoDB에서는 기본 키가 클러스터드 인덱스라 데이터가 기본 키 순서로 저장된다. 보조 인덱스는 "인덱스 키 → 기본 키" 구조라서, 보조 인덱스로 찾은 뒤 기본 키로 한 번 더 찾아간다. 기본 키가 크면(UUID 문자열 등) 모든 보조 인덱스가 커지고 삽입도 느려진다.

### 4. 복합 인덱스는 순서가 전부다

`(user_id, status, created_at)` 인덱스는 전화번호부처럼 `user_id`로 정렬되고, 같은 `user_id` 안에서 `status`, 그 안에서 `created_at` 순으로 정렬돼 있다. 그래서

- `WHERE user_id = 42` — 탄다.
- `WHERE user_id = 42 AND status = 'PAID'` — 탄다.
- `WHERE status = 'PAID'` — 못 탄다. 맨 앞 컬럼이 빠졌다.
- `WHERE user_id = 42 AND created_at > ?` — `user_id`까지만 탄다. 중간 `status`가 비어서 `created_at`은 인덱스 안에서 걸러지지 않는다.
- `WHERE user_id = 42 AND status IN ('PAID','SHIPPED') ORDER BY created_at` — 8.0에서는 범위 뒤 정렬이 `Using filesort`가 될 수 있다.

컬럼 순서를 정하는 규칙은 "동등 조건(=) 컬럼을 앞에, 범위 조건(>, <, BETWEEN, LIKE 'x%')은 맨 뒤에 하나만". 범위 조건 뒤의 컬럼은 인덱스로 거르지 못한다. 동등 조건끼리는 값 종류가 많은(선택도가 높은) 컬럼을 앞에 두는 게 유리하지만, 더 중요한 건 자주 같이 쓰는 쿼리 패턴이다.

위 2절의 쿼리라면 `(user_id, status, created_at)` 인덱스 하나로 `WHERE`도 거르고 `ORDER BY created_at DESC LIMIT 20`도 정렬 없이 인덱스 순서대로 20건만 읽는다.

### 5. 커버링 인덱스

쿼리가 쓰는 컬럼이 전부 인덱스 안에 있으면 테이블(클러스터드 인덱스)까지 가지 않는다. `Extra`에 `Using index`로 나온다.

```sql
-- (user_id, status, created_at) 인덱스가 있고 SELECT 컬럼이 id, created_at 뿐이면
-- InnoDB 보조 인덱스에는 기본 키(id)가 항상 포함돼 있어서 테이블을 읽지 않는다
SELECT id, created_at FROM orders WHERE user_id = 42 AND status = 'PAID';
```

`SELECT *`를 피하라는 말의 진짜 이유가 이것이다. 필요한 컬럼만 적으면 커버링 인덱스가 될 가능성이 생기고, 네트워크로 보내는 양도 준다.

### 6. 쿼리 다시 쓰기

인덱스를 고쳐도 안 될 때 쿼리 형태를 바꾼다.

**서브쿼리 → JOIN.** 8.0 옵티마이저가 `IN (서브쿼리)`를 세미조인으로 잘 바꿔 주지만, 상관 서브쿼리(바깥 행마다 안쪽을 다시 실행)는 여전히 느리다.

```sql
-- 바깥 행마다 실행되는 상관 서브쿼리
SELECT u.name FROM users u
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.user_id = u.id AND o.status = 'PAID');

-- JOIN + GROUP BY 또는 세미조인 힌트로 바꿔서 실행 계획을 비교한다
SELECT DISTINCT u.name FROM users u JOIN orders o ON o.user_id = u.id WHERE o.status = 'PAID';
```

**JOIN 순서.** 옵티마이저가 보통 작은 쪽(조건으로 걸러서 행이 적은 쪽)을 먼저 읽는다. `ON` 컬럼에 인덱스가 없으면 안쪽 테이블을 행마다 풀 스캔하니, 조인 컬럼에는 인덱스가 있어야 한다.

**페이징.** `LIMIT 100000, 20`은 100,020행을 읽고 100,000행을 버린다. 마지막으로 본 키를 기억해서 `WHERE id < ? ORDER BY id DESC LIMIT 20`으로 바꾸면(키셋 페이징) 어느 페이지든 20행만 읽는다.

**집계.** `COUNT(*)`는 InnoDB에서 실제로 센다. 대략값이면 충분할 때는 `information_schema.tables.table_rows`나 별도 카운터 테이블을 쓴다.

### 7. 구조와 서버 설정

쿼리와 인덱스로 안 되면 구조를 본다.

- 정규화를 깨서(비정규화) 조인을 줄인다. 읽기가 압도적으로 많고 갱신이 드문 컬럼에만 한다.
- 큰 테이블은 날짜 기준 파티셔닝으로 필요한 구간만 읽게 한다. 단, 파티션 키가 `WHERE`에 없으면 모든 파티션을 읽어서 오히려 느려진다.
- 같은 쿼리를 반복한다면 결과를 Redis 같은 외부 캐시에 둔다. MySQL 자체 Query Cache는 8.0에서 제거됐다.
- 커넥션은 풀(HikariCP 등)로 재사용한다. 풀 크기는 CPU 코어 수의 두 배 정도에서 시작해 측정하면서 조정한다.
- `innodb_buffer_pool_size`는 데이터가 메모리에 올라오는 양을 정한다. 전용 DB 서버면 메모리의 50~70%를 준다.

### 8. 인덱스를 늘릴 때 생각할 것

인덱스는 공짜가 아니다. 인덱스 하나마다 `INSERT`, `UPDATE`, `DELETE`가 그 인덱스도 갱신해야 하고, 디스크와 버퍼 풀을 차지한다. 그래서

- 자주 쓰는 쿼리 패턴을 먼저 모으고, 그 패턴을 한 인덱스로 최대한 덮는다. `(a)`와 `(a, b)`가 있으면 `(a)`는 중복이다.
- 쓰기가 많은 테이블은 인덱스 수를 최소로 유지한다.
- 안 쓰는 인덱스는 지운다. `sys.schema_unused_indexes` 뷰에서 찾을 수 있다.

```sql
CREATE INDEX idx_orders_user_status_created ON orders (user_id, status, created_at);
DROP INDEX idx_orders_user ON orders;  -- (user_id)만 있는 인덱스는 위 인덱스에 포함되므로 제거
```

정리하면 순서는 이렇다. 슬로우 로그로 대상을 고르고, `EXPLAIN`으로 `type`·`key`·`rows`·`Extra`를 읽고, 복합 인덱스 순서와 커버링 여부를 맞추고, 그래도 안 되면 쿼리를 다시 쓰거나 구조를 바꾼다. 고친 뒤에는 `EXPLAIN ANALYZE`로 실제 수치가 줄었는지 확인하고 끝낸다.
