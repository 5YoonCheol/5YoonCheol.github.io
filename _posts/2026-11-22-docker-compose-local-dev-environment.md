---
title: "[Docker] Docker Compose로 로컬 개발 환경 한 번에 띄우기"
date: 2026-11-22 02:00:00 +0900
categories: [DevOps, Container]
tags: [docker, docker-compose, mysql, redis, local-development]
render_with_liquid: false
---

백엔드 프로젝트를 새 PC에서 돌리려면 DB 설치하고, 캐시 서버 설치하고, 계정 만들고, 포트 맞추고, 초기 데이터 넣는 데 반나절이 간다. 팀원이 들어올 때마다 이걸 반복하고, "제 PC에서는 되는데요"의 절반은 이 환경 차이에서 나온다. Docker Compose는 이 과정을 YAML 파일 하나와 명령 하나로 줄여준다. 처음 세팅하는 과정과, 쓰다 보면 꼭 필요해지는 설정들을 정리해보자.

---

### 1. Compose가 해결하는 문제

Docker로 MySQL 하나 띄우는 건 `docker run` 한 줄이면 된다. 문제는 컨테이너가 둘 이상일 때다. MySQL과 Redis를 띄우고, 서로 통신하게 네트워크를 묶고, 데이터가 날아가지 않게 볼륨을 붙이고, 환경 변수를 넘기고, 순서를 맞춰 올리는 걸 매번 명령으로 치면 금방 외울 수 없는 길이가 된다.

Compose는 그 전체를 `compose.yaml` 파일에 선언해두고 `docker compose up` 한 번으로 올리는 도구다. 파일이 저장소에 들어가니 팀원 모두 같은 환경을 쓰게 되고, 환경 변경도 코드 리뷰를 거친다.

```text
compose.yaml ──→ docker compose up ──→ [mysql] [redis] (+ 네트워크, 볼륨)
                                           ↑
                        로컬에서 실행 중인 애플리케이션이 localhost로 접속
```

로컬 개발에서는 보통 애플리케이션은 IDE에서 직접 실행하고, DB나 캐시 같은 인프라만 Compose로 띄운다. 애플리케이션까지 컨테이너에 넣으면 코드 바꿀 때마다 이미지를 다시 빌드해야 해서 개발 속도가 떨어진다.

---

### 2. 가장 작은 compose.yaml

프로젝트 루트에 `compose.yaml`을 만든다. 예전 자료에는 `docker-compose.yml`로 나오는데, 둘 다 인식하지만 요즘은 `compose.yaml`이 기본이다.

```yaml
services:
  mysql:
    image: mysql:8.0
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: app
      MYSQL_USER: app
      MYSQL_PASSWORD: app
    volumes:
      - mysql-data:/var/lib/mysql

  redis:
    image: redis:7
    ports:
      - "6379:6379"

volumes:
  mysql-data:
```

`docker compose up -d`로 올리고, `docker compose down`으로 내린다. `-d`는 백그라운드 실행이다.

몇 가지만 짚어보면,

- `ports`는 `"호스트:컨테이너"`다. 왼쪽이 내 PC에서 접속할 포트. 로컬에 이미 MySQL이 설치돼 있어 3306이 쓰이고 있으면 `"3307:3306"`처럼 왼쪽만 바꾼다. 애플리케이션 설정도 3307로 맞춘다.
- `volumes`에 이름 붙인 볼륨(`mysql-data`)을 쓰면 컨테이너를 지워도 데이터는 남는다. 이걸 안 붙이면 `down` 할 때마다 DB가 초기화된다. 처음엔 그게 편할 수도 있지만, 테스트 데이터를 쌓아둔 다음엔 반드시 필요하다.
- 비밀번호를 YAML에 그대로 적었는데, 로컬 개발용이라 괜찮다. 이 파일은 로컬에서만 쓰고 운영에는 쓰지 않는다는 전제다.

---

### 3. 초기 스키마와 데이터 넣기

DB가 뜰 때 테이블과 기본 데이터가 같이 들어가 있으면 좋다. MySQL 공식 이미지는 `/docker-entrypoint-initdb.d/` 아래의 `.sql` 파일을 첫 실행 때 알파벳 순으로 실행해준다.

```yaml
services:
  mysql:
    image: mysql:8.0
    # ...
    volumes:
      - mysql-data:/var/lib/mysql
      - ./docker/mysql/init:/docker-entrypoint-initdb.d
```

```text
docker/mysql/init/
├── 01-schema.sql
└── 02-seed.sql
```

"첫 실행 때"라는 조건에 주의하자. 데이터 볼륨이 이미 있으면 초기화 스크립트는 다시 실행되지 않는다. 스키마를 바꿨는데 반영이 안 되면 `docker compose down -v`로 볼륨까지 지우고 다시 올려야 한다. `-v`는 데이터를 날리는 옵션이니 쌓아둔 데이터가 있으면 먼저 백업하자.

PostgreSQL 이미지도 같은 경로를 쓰고, 다른 이미지는 각자 문서에 비슷한 방식이 있다.

---

### 4. 뜰 때까지 기다리기

애플리케이션까지 Compose에 넣는 경우에 특히 중요한데, MySQL 컨테이너가 "시작됐다"와 "접속 가능하다"는 다르다. 컨테이너는 떴는데 MySQL이 아직 초기화 중이라 애플리케이션이 접속 실패로 죽는 일이 흔하다.

`healthcheck`로 "접속 가능" 상태를 정의하고, 의존하는 쪽에서 `condition: service_healthy`로 기다리게 한다.

```yaml
services:
  mysql:
    image: mysql:8.0
    # ...
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-uroot", "-proot"]
      interval: 5s
      timeout: 3s
      retries: 10

  app:
    build: .
    depends_on:
      mysql:
        condition: service_healthy
```

`depends_on`만 쓰면 시작 순서만 보장하고 준비 상태는 안 본다. `condition: service_healthy`까지 써야 헬스체크가 통과한 뒤에 다음 컨테이너가 시작된다. 애플리케이션을 IDE에서 띄우는 구성이라도 헬스체크는 넣어두는 게 좋다. `docker compose ps`에서 `healthy`가 뜨는지 보면 접속해도 되는 상태인지 바로 안다.

---

### 5. 환경 변수 분리

비밀번호나 포트를 YAML에 하드코딩하면 사람마다 다른 설정이 필요할 때 파일이 갈라진다. `.env` 파일로 뺀다.

```text
# .env
MYSQL_PORT=3306
MYSQL_PASSWORD=app
```

```yaml
services:
  mysql:
    ports:
      - "${MYSQL_PORT:-3306}:3306"
    environment:
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
```

Compose는 같은 디렉터리의 `.env`를 자동으로 읽는다. `${MYSQL_PORT:-3306}`은 변수가 없으면 3306을 쓴다는 뜻이다. `.env`는 `.gitignore`에 넣고, 대신 `.env.example`을 커밋해서 어떤 변수가 필요한지 알려준다.

---

### 6. 가끔만 필요한 서비스

모니터링 도구나 메시지 큐처럼 평소엔 안 쓰고 특정 작업 때만 필요한 서비스가 있다. 매번 다 띄우면 PC가 무겁다. `profiles`로 묶어두면 평소에는 안 뜨고 명시할 때만 뜬다.

```yaml
services:
  mysql:
    # ... 항상 뜬다

  kafka:
    image: apache/kafka:3.8.0
    profiles: ["messaging"]
```

`docker compose up -d`는 mysql만 올리고, `docker compose --profile messaging up -d`는 kafka까지 올린다.

---

### 7. 자주 쓰는 명령

```bash
docker compose up -d            # 올리기 (백그라운드)
docker compose down             # 내리기 (볼륨은 유지)
docker compose down -v          # 내리고 볼륨까지 삭제 (데이터 초기화)
docker compose ps               # 상태 확인 (healthy 여부 포함)
docker compose logs -f mysql    # 특정 서비스 로그 따라가기
docker compose exec mysql mysql -uapp -papp app   # 컨테이너 안에서 명령 실행
docker compose pull             # 이미지 최신으로 받기
docker compose restart redis    # 특정 서비스만 재시작
```

`exec`는 자주 쓰게 된다. DB 클라이언트를 따로 설치하지 않아도 컨테이너 안의 mysql 클라이언트로 바로 접속할 수 있다.

---

### 8. 자주 만나는 문제

**포트 충돌.** "port is already allocated"가 나면 로컬에 같은 포트를 쓰는 프로세스가 있다. 호스트 쪽 포트를 바꾸거나 기존 프로세스를 내린다. 로컬에 직접 설치한 MySQL과 자주 충돌한다.

**데이터가 안 바뀐다.** 3번에서 말한 초기화 스크립트 문제다. 볼륨이 있으면 다시 실행되지 않는다.

**Apple Silicon에서 이미지가 없다.** 일부 이미지는 arm64 빌드가 없다. `platform: linux/amd64`를 서비스에 추가하면 에뮬레이션으로 돌아가는데 느리다. 가능하면 arm64를 지원하는 이미지나 태그를 찾는다. MySQL 8.0은 공식 이미지가 arm64를 지원한다.

**이미지 태그.** `mysql:latest`는 어느 날 메이저 버전이 바뀌어 전체가 깨질 수 있다. `mysql:8.0`처럼 최소 마이너 버전까지 고정한다. 운영 DB 버전과 맞추는 게 가장 좋다.

**느린 파일 I/O (macOS, Windows).** 호스트 디렉터리를 바인드 마운트하면 가상 머신을 거쳐서 느리다. DB 데이터는 이름 붙인 볼륨을 쓰고, 바인드 마운트는 초기화 스크립트처럼 읽기만 하는 것에 한정한다.

---

### 정리

| 요소 | 요령 |
|------|------|
| 파일 | `compose.yaml`, 저장소에 커밋 |
| 데이터 | 이름 붙인 볼륨, `down -v`는 초기화 |
| 초기화 | `/docker-entrypoint-initdb.d/`, 첫 실행에만 |
| 순서 | `healthcheck` + `depends_on: condition: service_healthy` |
| 설정 | `.env`로 분리, `.env.example` 커밋 |
| 선택 | `profiles`로 가끔 쓰는 서비스 분리 |
| 버전 | 이미지 태그 고정, 운영 버전과 맞추기 |

한 번 만들어두면 `git clone` 후 `docker compose up -d` 두 줄로 개발 환경이 끝난다. 새 팀원 온보딩이 빨라지는 건 물론이고, CI에서 같은 compose 파일로 테스트 DB를 띄울 수도 있어서 로컬과 CI 환경이 같아지는 효과도 있다.
