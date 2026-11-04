---
title: "[MySql] MySql 복제 설정으로 고가용성 확보하기"
date: 2024-12-03 02:00:00 +0900
categories: [Database, MySQL]
tags: ["mysql-복제", "replication", "gtid"]
description: MySQL 8.0.22 이후 바뀐 CHANGE REPLICATION SOURCE TO / START REPLICA 명령과 GTID 기반 복제 설정, 복제 유형과 운영 시 확인할 점을 정리한다.
tistory_url: https://yoon-ssi.tistory.com/134
render_with_liquid: false
---
> 2026년 11월에 다시 정리했다. 처음 쓸 때는 `CHANGE MASTER TO`, `START SLAVE` 문법으로 적었는데, MySQL 8.0.22부터 이 명령들이 `CHANGE REPLICATION SOURCE TO`, `START REPLICA`로 바뀌었고 8.4부터는 옛 문법이 아예 제거됐다. 지금 기준으로 다시 쓴다.
{: .prompt-info }

DB 서버가 한 대뿐이면 그 서버가 죽는 순간 서비스도 같이 멈춘다. 그래서 장애 복구와 읽기 부하 분산을 위해 복제를 쓴다. MySQL 복제(Replication)를 GTID 기준으로 설정하는 방법을 정리해보자.

### 1. MySQL 복제란?

소스(source) 서버의 변경 내용을 바이너리 로그로 남기고, 레플리카(replica) 서버가 그 로그를 받아 그대로 재실행해서 데이터를 맞추는 방식이다. 예전 문서에서는 마스터/슬레이브라고 불렀지만 MySQL 8.0.26부터 공식 용어가 소스/레플리카로 바뀌었고, `SHOW SLAVE STATUS` 같은 명령도 `SHOW REPLICA STATUS`로 바뀌었다. 8.4 이후 버전에서는 옛 명령이 동작하지 않으니 새로 설정할 때는 새 용어로 쓰는 게 맞다.

### 2. 복제 유형

- 비동기 복제: 소스가 레플리카의 응답을 기다리지 않는다. 기본값이고 가장 빠르지만, 소스가 죽는 순간 레플리카에 아직 전달되지 않은 트랜잭션은 잃을 수 있다.
- 반동기 복제: 레플리카 중 최소 하나가 로그를 받았다고 응답해야 커밋이 끝난다. `rpl_semi_sync_source` 플러그인으로 켠다. 트랜잭션 유실은 막아 주지만 커밋 지연이 조금 늘어난다.
- 그룹 복제(Group Replication): 여러 서버가 합의 프로토콜로 같은 트랜잭션 순서를 맞추는 방식이다. 자동 장애 조치까지 필요하면 InnoDB Cluster 쪽을 본다.

### 3. 위치 기준 vs GTID 기준

예전 방식은 바이너리 로그 파일 이름과 위치(`SOURCE_LOG_FILE`, `SOURCE_LOG_POS`)를 직접 지정했다. 소스를 교체하거나 레플리카를 다른 소스에 붙일 때 위치를 다시 계산해야 해서 실수가 잦다.

GTID(Global Transaction Identifier)는 트랜잭션마다 `서버UUID:번호` 형태의 전역 ID를 붙인다. 레플리카는 "내가 아직 받지 못한 GTID"를 스스로 알기 때문에 `SOURCE_AUTO_POSITION=1` 한 줄로 이어 붙일 수 있다. 새로 구성한다면 GTID를 쓰는 게 좋다.

### 4. 설정 방법

소스 서버 설정 (`my.cnf`)

```
[mysqld]
server-id=1
log-bin=mysql-bin
binlog_format=ROW
gtid_mode=ON
enforce_gtid_consistency=ON
```

레플리카 서버 설정

```
[mysqld]
server-id=2
relay_log=relay-bin
gtid_mode=ON
enforce_gtid_consistency=ON
read_only=ON
```

`server-id`는 서버마다 달라야 하고, 레플리카에는 `read_only`를 켜서 실수로 직접 쓰는 일을 막는다. 특정 DB만 복제하려면 `replicate-do-db`를 쓰지만, 기본 DB를 바꾸고 다른 DB를 갱신하는 쿼리에서 동작이 헷갈리니 꼭 필요할 때만 쓴다.

소스에서 복제용 계정 만들기

```sql
CREATE USER 'rep_user'@'%' IDENTIFIED BY '비밀번호';
GRANT REPLICATION SLAVE ON *.* TO 'rep_user'@'%';
```

권한 이름 `REPLICATION SLAVE`는 아직 옛 이름이 그대로다.

초기 데이터 맞추기

이미 데이터가 있는 소스라면 레플리카에 같은 데이터를 먼저 복사해야 한다. 작은 DB라면 `mysqldump`로, 큰 DB라면 MySQL Shell의 `util.dumpInstance()`나 클론 플러그인을 쓴다.

```bash
mysqldump --all-databases --single-transaction --source-data=2 --set-gtid-purged=ON > full.sql
```

`--source-data`도 8.0.26부터 바뀐 옵션 이름이다(예전 이름은 `--master-data`). `--set-gtid-purged=ON`을 주면 덤프 안에 "여기까지의 GTID는 이미 반영됐다"는 정보가 함께 들어가서 레플리카가 그 다음부터 이어받는다.

복제 시작 (레플리카에서)

```sql
CHANGE REPLICATION SOURCE TO
  SOURCE_HOST='source_host',
  SOURCE_PORT=3306,
  SOURCE_USER='rep_user',
  SOURCE_PASSWORD='비밀번호',
  SOURCE_AUTO_POSITION=1,
  SOURCE_SSL=1;

START REPLICA;
```

GTID를 쓰지 않는다면 `SOURCE_AUTO_POSITION` 대신 `SOURCE_LOG_FILE='mysql-bin.000003', SOURCE_LOG_POS=1234`처럼 덤프 파일 머리에 적힌 위치를 넣는다.

### 5. 상태 확인

```sql
SHOW REPLICA STATUS\G
```

아래 값을 본다.

- `Replica_IO_Running`, `Replica_SQL_Running`이 둘 다 `Yes`여야 한다.
- `Seconds_Behind_Source`가 복제 지연(초)이다. 계속 커지면 레플리카 쪽 처리 속도가 못 따라가는 것이다.
- `Last_IO_Error`, `Last_SQL_Error`에 에러 내용이 남는다.
- `Retrieved_Gtid_Set`과 `Executed_Gtid_Set`을 비교하면 받았지만 아직 적용 안 된 트랜잭션을 알 수 있다.

레플리카 적용 속도가 문제라면 `replica_parallel_workers`를 늘려 여러 스레드로 재실행하게 할 수 있다(8.0.27부터 기본 4).

### 6. 운영할 때 신경 쓸 것

- 복제는 백업이 아니다. 소스에서 잘못 `DELETE`하면 레플리카에서도 똑같이 지워진다. 백업은 따로 받는다.
- 레플리카에서 읽기를 분산할 때는 복제 지연 때문에 방금 쓴 데이터가 안 보일 수 있다. 쓰고 바로 읽는 요청은 소스로 보낸다.
- 레플리카가 멈춘 채 오래 두면 소스의 바이너리 로그가 `binlog_expire_logs_seconds`(기본 30일) 뒤에 지워져서 이어 붙일 수 없게 된다.
- 장애 조치(failover)를 자동화하려면 Orchestrator, MySQL Router + InnoDB Cluster 같은 도구가 필요하다. 복제만으로는 소스가 죽었을 때 누가 새 소스가 될지 사람이 정해야 한다.

이렇게 해두면 소스에 문제가 생겨도 데이터가 남아 있고, 읽기 요청은 레플리카로 나눠 보낼 수 있다.
