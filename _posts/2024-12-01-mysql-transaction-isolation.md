---
title: "[MySql] MySql 트랜잭션과 격리 수준"
date: 2024-12-01 10:00:38 +0900
categories: [Database, MySQL]
tags: ["mysql", "격리수준", "트랜잭션"]
tistory_url: https://yoon-ssi.tistory.com/132
render_with_liquid: false
---

**트랜잭션(Transaction)은 데이터 무결성을 위한 핵심 기술이다.**  
오늘은 MySQL 트랜잭션과 격리 수준(Isolation Level)에 대해 알아보자.

---

### 1. 트랜잭션의 4가지 속성(ACID)

- **Atomicity**: 모든 작업은 전부 수행되거나 전혀 수행되지 않아야 한다.
- **Consistency**: 트랜잭션 전후 데이터 상태가 일관되어야 한다.
- **Isolation**: 서로 다른 트랜잭션은 독립적으로 실행된다.
- **Durability**: 트랜잭션이 커밋되면 데이터는 영구적으로 저장된다.

---

### 2. 격리 수준(Isolation Level)

- **READ UNCOMMITTED**: 다른 트랜잭션의 미완료 데이터를 읽을 수 있음(Dirty Read).
- **READ COMMITTED**: 커밋된 데이터만 읽을 수 있음.
- **REPEATABLE READ**: 같은 트랜잭션에서 읽은 데이터가 항상 동일하게 보임.
- **SERIALIZABLE**: 가장 높은 수준, 완전한 직렬화.

---

### 3. 트랜잭션 사용 예제

```
START TRANSACTION;

-- 데이터 수정
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

-- 커밋
COMMIT;
```
