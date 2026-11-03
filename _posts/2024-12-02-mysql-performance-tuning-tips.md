---
title: "[MySql] MySql 성능 튜닝을 위한 5가지 팁"
date: 2024-12-02 02:00:00 +0900
categories: [Database, MySQL]
tags: ["mysql", "성능-튜닝"]
tistory_url: https://yoon-ssi.tistory.com/133
render_with_liquid: false
---

MySQL 성능을 끌어올리려면 어디부터 봐야 할까. 기본적으로 챙겨야 할 원칙 다섯 가지를 정리해봤다.

---

### 1. 쿼리 최적화

- `SELECT *`는 피하고 필요한 열만 적자.
- WHERE 조건은 인덱스를 탈 수 있게 짜자.

### 2. 데이터베이스 구조 설계

- 정규화로 중복 데이터를 없애자.
- 읽기 성능이 중요하면 비정규화도 고려해보자.

### 3. 캐싱 활용

- MySQL Query Cache나 Redis, Memcached 같은 외부 캐시를 쓰자.

### 4. 연결 관리

- 커넥션 풀(Connection Pool)을 써서 연결을 재사용하자.

### 5. 모니터링

- `EXPLAIN`, `SHOW STATUS`, `SHOW PROCESSLIST`로 쿼리 성능을 확인하자.
