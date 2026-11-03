---
title: "[MySql] MySql 복제 설정으로 고가용성 확보하기"
date: 2024-12-03 02:00:00 +0900
categories: [Database, MySQL]
tags: ["mysql-복제"]
tistory_url: https://yoon-ssi.tistory.com/134
render_with_liquid: false
---

DB 서버가 한 대뿐이면 그 서버가 죽는 순간 서비스도 같이 멈춘다. 그래서 장애 복구와 읽기 부하 분산을 위해 복제를 쓴다. 오늘은 MySQL 복제(Replication)를 설정하는 방법을 정리해보자.

### 1. MySQL 복제란?

마스터 서버의 데이터를 슬레이브 서버로 동기화해서 고가용성을 확보하는 방법이다.

### 2. 복제 유형

- 비동기 복제: 마스터가 슬레이브의 응답을 기다리지 않는다.
- 반동기 복제: 슬레이브 중 최소 하나에 쓰기가 끝나면 응답한다.
- 동기 복제: 모든 슬레이브에 쓰기가 끝난 뒤에 응답한다.

### 3. 설정 방법

마스터 서버 설정

```
[mysqld]
 log-bin=mysql-bin
 server-id=1
```

슬레이브 서버 설정

```
[mysqld]
 server-id=2
 replicate-do-db=example_db
```

복제 시작

```sql
CHANGE MASTER TO MASTER_HOST='master_host', MASTER_USER='rep_user', MASTER_PASSWORD='password';
START SLAVE;
```

이렇게 해두면 마스터에 문제가 생겨도 데이터가 남아 있고, 읽기 요청은 슬레이브로 나눠 보낼 수 있다.
