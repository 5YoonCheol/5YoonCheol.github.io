---
title: "[MySql] MySql 복제 설정으로 고가용성 확보하기"
date: 2024-12-03 10:00:43 +0900
categories: ["MySql"]
tags: ["mysql-복제"]
tistory_url: https://yoon-ssi.tistory.com/134
render_with_liquid: false
---

**데이터베이스 복제는 장애 복구와 읽기 부하 분산에 필수적입니다.**  
오늘은 MySQL 복제(Replication) 설정 방법과 활용 사례를 소개합니다.

### 1. MySQL 복제란?

- 데이터를 마스터 서버에서 슬레이브 서버로 동기화하여 고가용성을 제공합니다.

### 2. 복제 유형

- **비동기 복제**: 마스터가 슬레이브의 응답을 기다리지 않음.
- **반동기 복제**: 최소한 하나의 슬레이브에 쓰기가 완료되면 응답.
- **동기 복제**: 모든 슬레이브에 쓰기가 완료된 후 응답.

### 3. 설정 방법

1. 마스터 서버 설정

```
[mysqld]
 log-bin=mysql-bin
 server-id=1
```

2. 슬레이브 서버 설정

```
[mysqld]
 server-id=2
 replicate-do-db=example_db
```

3. 복제 시작

```sql
CHANGE MASTER TO MASTER_HOST='master_host', MASTER_USER='rep_user', MASTER_PASSWORD='password';
START SLAVE;
```

복제를 통해 데이터 안정성과 성능을 동시에 확보해보자.
