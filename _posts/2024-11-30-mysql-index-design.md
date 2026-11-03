---
title: "[MySql] MySql 인덱스의 원리와 올바른 설계 전략"
date: 2024-11-30 10:00:41 +0900
categories: [Database, MySQL]
tags: ["mysql", "인덱스"]
tistory_url: https://yoon-ssi.tistory.com/131
render_with_liquid: false
---

인덱스(Index)를 잘 걸면 조회가 확 빨라진다. 그렇다고 많이 건다고 좋은 것도 아니다. 오늘은 MySQL 인덱스가 어떻게 동작하는지, 설계할 때 뭘 신경 써야 하는지 정리해보자.

### 1. 동작 원리

- MySQL은 주로 B-Tree 기반 인덱스를 쓴다.
- 데이터를 계층적으로 정렬해 두기 때문에 검색이 빠르다.

### 2. 인덱스 종류

- Primary Index: 기본 키(Primary Key)에 자동으로 만들어진다.
- Unique Index: 중복을 허용하지 않는 값에 거는 인덱스.
- Composite Index: 여러 열(Column)을 묶은 인덱스.

### 3. 설계할 때 주의할 점

1. 자주 조회하는 열에 인덱스를 건다.
2. 읽기보다 쓰기가 많은 테이블이라면 인덱스 개수를 최소로 줄인다.
3. 인덱스를 너무 많이 걸면 오히려 성능이 떨어질 수 있다.

### 4. 인덱스 관리 예제

```
-- 인덱스 생성
CREATE INDEX idx_name ON employees(name);

-- 인덱스 삭제
DROP INDEX idx_name ON employees;
```
