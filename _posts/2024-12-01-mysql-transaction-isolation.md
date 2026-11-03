---
title: "[MySql] MySql 트랜잭션과 격리 수준"
date: 2024-12-01 10:00:38 +0900
categories: [Database, MySQL]
tags: ["mysql", "격리수준", "트랜잭션"]
tistory_url: https://yoon-ssi.tistory.com/132
render_with_liquid: false
---

트랜잭션(Transaction)은 데이터 무결성을 지키는 핵심 장치다. 오늘은 MySQL 트랜잭션과 격리 수준(Isolation Level)을 짧게 정리해보자.

---

### 1. 트랜잭션의 4가지 속성(ACID)

- Atomicity(원자성): 작업이 전부 수행되거나, 아예 하나도 수행되지 않아야 한다.
- Consistency(일관성): 트랜잭션 전후로 데이터 상태가 일관돼야 한다.
- Isolation(격리성): 서로 다른 트랜잭션은 서로 간섭 없이 실행된다.
- Durability(지속성): 커밋된 데이터는 영구적으로 저장된다.

---

### 2. 격리 수준(Isolation Level)

- READ UNCOMMITTED: 다른 트랜잭션이 아직 커밋하지 않은 데이터도 읽는다(Dirty Read).
- READ COMMITTED: 커밋된 데이터만 읽는다.
- REPEATABLE READ: 한 트랜잭션 안에서 같은 데이터를 다시 읽어도 항상 같은 값이 보인다.
- SERIALIZABLE: 가장 엄격한 수준으로, 트랜잭션을 완전히 순서대로 실행하는 것처럼 처리한다.

---

### 3. 트랜잭션 사용 예제

1번 계좌에서 100을 빼고 2번 계좌에 100을 더하는 작업을 하나의 트랜잭션으로 묶은 예다.

```
START TRANSACTION;

-- 데이터 수정
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

-- 커밋
COMMIT;
```
