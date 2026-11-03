---
title: "[MySql] MySql 인덱스의 원리와 올바른 설계 전략"
date: 2024-11-30 10:00:41 +0900
categories: ["MySql"]
tags: ["mysql", "인덱스"]
tistory_url: https://yoon-ssi.tistory.com/131
render_with_liquid: false
---

**인덱스(Index)는 빠른 데이터 검색의 열쇠이다. 하지만 과유불급!**  
오늘은 MySQL 인덱스의 원리와 설계 전략에 대해 알아보자.

### 1. 인덱스의 동작 원리

- MySQL은 **B-Tree** 기반의 인덱스를 주로 사용한다.
- 데이터는 계층적으로 정렬되어 검색 속도를 극대화한다.

### 2. 인덱스의 유형

- **Primary Index**: 기본 키(Primary Key)에 자동 생성.
- **Unique Index**: 중복을 허용하지 않는 유니크한 데이터.
- **Composite Index**: 여러 열(Column)을 결합한 인덱스.

### 3. 인덱스 설계 시 주의점

1. 자주 사용하는 열에 인덱스를 추가하자.
2. 읽기보다 쓰기가 많다면 인덱스 개수를 최소화하자.
3. **과도한 인덱스 사용은 성능 저하**를 유발할 수 있다.

### 4. 인덱스 관리 예제

```
-- 인덱스 생성
CREATE INDEX idx_name ON employees(name);

-- 인덱스 삭제
DROP INDEX idx_name ON employees;
```
