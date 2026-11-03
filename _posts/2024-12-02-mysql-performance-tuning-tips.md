---
title: "[MySql] MySql 성능 튜닝을 위한 5가지 팁"
date: 2024-12-02 10:00:34 +0900
categories: [Database, MySQL]
tags: ["mysql", "성능-튜닝"]
tistory_url: https://yoon-ssi.tistory.com/133
render_with_liquid: false
---

**성능 튜닝은 데이터베이스 관리의 핵심이다.**  
MySQL의 성능을 개선하기 위한 기본 원칙 5가지를 알아보자.

---

### 1. 쿼리 최적화

- 불필요한 SELECT *를 피하고, 필요한 열만 명시하자.
- WHERE 조건에서 항상 인덱스를 활용하자.

### 2. 데이터베이스 구조 설계

- 정규화를 통해 중복 데이터를 제거하자.
- 필요한 경우, 읽기 성능을 위해 비정규화를 고려해보자.

### 3. 캐싱 활용

- MySQL Query Cache 또는 외부 캐시 도구(Redis, Memcached)를 활용하자.

### 4. 연결 관리

- 연결(Connection Pool)을 사용하여 자원을 효율적으로 관리하자.

### 5. 모니터링 도구

- MySQL의 `EXPLAIN`, `SHOW STATUS`, `SHOW PROCESSLIST` 명령어로 쿼리 성능을 모니터링하자.
