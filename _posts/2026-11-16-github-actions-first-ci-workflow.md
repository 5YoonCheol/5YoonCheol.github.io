---
title: "[CI/CD] GitHub Actions로 PR마다 테스트 자동 실행하기"
date: 2026-11-16 02:00:00 +0900
categories: [DevOps, CI-CD]
tags: [github-actions, ci, workflow, gradle, test-automation]
render_with_liquid: false
---

PR을 올리고 머지하기 전에 테스트를 돌리는 건 당연한 얘기지만, 손으로 하다 보면 결국 빼먹는다. 특히 AI 코딩 도구가 PR을 대신 열어주는 요즘은 사람이 매번 로컬에서 체크아웃해서 테스트를 돌릴 수가 없다. PR이 열리면 자동으로 테스트가 돌고, 결과가 PR 화면에 초록불이나 빨간불로 뜨게 만들어두면 머지 판단이 훨씬 쉬워진다. GitHub Actions로 이걸 처음부터 세팅하는 과정을 정리해보자. Java와 Gradle 프로젝트를 기준으로 하되, 다른 스택도 명령 몇 줄만 바꾸면 된다.

---

### 1. GitHub Actions의 구조

용어가 몇 개 있다. 처음에 이게 헷갈려서 YAML을 읽기 어렵다.

- 워크플로(workflow): `.github/workflows/` 아래 YAML 파일 하나. "언제, 무엇을 실행할지"의 단위다.
- 이벤트(on): 워크플로를 실행시키는 조건. `push`, `pull_request`, 스케줄, 수동 실행 등.
- 잡(job): 워크플로 안의 실행 단위. 각 잡은 별도의 가상 머신(러너)에서 돌아간다. 기본적으로 잡들은 병렬로 실행된다.
- 스텝(step): 잡 안의 순서 있는 명령들. 셸 명령을 직접 쓰거나(`run`), 누가 만들어둔 액션을 가져다 쓴다(`uses`).
- 액션(action): 재사용 가능한 스텝 묶음. 코드 체크아웃, JDK 설치, 캐시 같은 반복 작업은 거의 다 공개된 액션이 있다.

```text
워크플로 (yml 파일)
 └ on: pull_request
 └ jobs:
     └ test (ubuntu 러너)
         ├ step: 코드 체크아웃
         ├ step: JDK 설치
         └ step: ./gradlew test
```

---

### 2. 가장 작은 워크플로

`.github/workflows/test.yml`을 만든다. 파일 이름은 아무거나 괜찮다.

```yaml
name: Test

on:
  pull_request:
    branches: [main, develop]
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: '21'

      - run: chmod +x gradlew
      - run: ./gradlew test
```

이게 전부다. 이 파일을 커밋해서 올리면 다음 PR부터 자동으로 테스트가 돈다.

몇 가지 짚어보면,

- `on.pull_request.branches`는 "어느 브랜치로 향하는 PR인가"다. 작업 브랜치 → develop PR과 develop → main PR 모두 걸리게 두 개를 적었다.
- `push.branches: [main]`은 머지된 직후 main에서도 한 번 더 돌리기 위한 것이다. 머지 과정에서 뭔가 깨졌을 때 잡아준다.
- `actions/checkout`은 러너에 코드를 받아오는 액션이다. 이게 없으면 러너는 빈 디렉터리다.
- `setup-java`의 `distribution`은 JDK 배포판이다. Temurin이 무난하다.
- `chmod +x gradlew`는 Windows에서 커밋한 `gradlew`에 실행 권한이 없는 경우가 있어서 넣는다. 안 넣으면 "Permission denied"로 첫 실행에서 한 번은 당한다.

---

### 3. 캐시로 시간 줄이기

위 워크플로는 매번 Gradle 의존성을 처음부터 내려받는다. 프로젝트가 커지면 테스트보다 다운로드가 오래 걸린다. `setup-java`에 `cache` 옵션 한 줄을 추가하면 의존성을 캐시해준다.

```yaml
      - uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: '21'
          cache: gradle
```

Maven이면 `cache: maven`, Node면 `actions/setup-node`에 `cache: npm`을 쓴다. 캐시 키는 lock 파일이나 빌드 파일의 해시로 자동 생성되니 의존성이 바뀌면 알아서 갱신된다.

---

### 4. 테스트 결과를 보기 좋게

테스트가 실패하면 Actions 탭의 로그를 뒤져야 하는데, 수백 줄 중에서 실패한 테스트를 찾는 게 번거롭다. 두 가지 방법이 있다.

**테스트 리포트를 아티팩트로 올리기.** 실패했을 때만 리포트 디렉터리를 업로드해두면 다운로드해서 브라우저로 볼 수 있다.

```yaml
      - run: ./gradlew test

      - uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: test-report
          path: build/reports/tests/test/
```

`if: failure()`는 앞 스텝이 실패한 경우에만 실행한다는 뜻이다. 성공했을 때 리포트는 필요 없으니 올리지 않는다.

**PR에 결과 요약을 남기기.** 테스트 결과 XML을 읽어서 PR 체크 화면에 어떤 테스트가 실패했는지 보여주는 액션들이 있다. 마켓플레이스에서 "test report"로 검색하면 여러 개가 나온다. 어떤 걸 쓰든 `if: always()`로 테스트가 실패해도 리포트 스텝은 실행되게 해야 한다. 안 그러면 실패했을 때 리포트가 안 나오는, 가장 필요할 때 없는 상황이 된다.

---

### 5. DB가 필요한 테스트

통합 테스트가 실제 DB를 붙여야 한다면 `services`로 러너 안에 컨테이너를 띄울 수 있다.

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: test
          MYSQL_DATABASE: app_test
        ports:
          - 3306:3306
        options: >-
          --health-cmd="mysqladmin ping -h localhost"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=5
    steps:
      - uses: actions/checkout@v4
      # ... JDK 설치
      - run: ./gradlew test
        env:
          SPRING_DATASOURCE_URL: jdbc:mysql://localhost:3306/app_test
          SPRING_DATASOURCE_USERNAME: root
          SPRING_DATASOURCE_PASSWORD: test
```

`options`의 헬스체크가 중요하다. 이게 없으면 MySQL이 뜨기 전에 테스트가 시작돼서 커넥션 실패로 죽는다. 헬스체크를 걸어두면 컨테이너가 준비될 때까지 기다린다.

테스트용 비밀번호 같은 건 그냥 YAML에 적어도 되지만, 진짜 비밀 정보(외부 API 키 등)는 저장소 Settings → Secrets에 넣고 `${{ secrets.이름 }}`으로 꺼내 쓴다. 로그에 찍히면 자동으로 마스킹된다.

---

### 6. 머지 전 필수 체크로 만들기

워크플로가 돌아도 그냥 실패 표시만 뜨고 머지는 된다. 테스트가 통과해야만 머지되게 하려면 브랜치 보호 규칙을 건다.

1. 저장소 Settings → Branches → Add branch ruleset (또는 Add rule)
2. 대상 브랜치에 `main` 지정
3. "Require status checks to pass before merging" 체크
4. 검색창에 잡 이름(`test`)을 입력해 추가

이제 테스트가 빨간불이면 머지 버튼이 비활성화된다. 혼자 하는 프로젝트라도 이걸 켜두면 "일단 머지하고 나중에 고치자"를 못 하게 막아줘서 좋다. 저장소 관리자는 우회할 수 있으니 "Do not allow bypassing" 옵션까지 켜야 진짜로 막힌다.

---

### 7. 자주 만나는 문제

**로컬에서는 되는데 CI에서만 실패한다.** 대부분 세 가지 중 하나다. 환경 변수가 CI에 없거나, 파일 경로의 대소문자가 다르거나(러너는 리눅스라 대소문자를 구분한다), 시간대가 다르다(러너는 UTC). 테스트가 `LocalDate.now()` 같은 걸 쓰고 있으면 시간대 문제를 의심하자.

**너무 오래 걸린다.** 캐시를 켰는지 확인하고, 그래도 느리면 테스트를 단위/통합으로 나눠 잡을 분리한다. 잡은 병렬로 돌아서 전체 시간이 줄어든다. 다만 러너 사용 시간은 잡마다 따로 계산되니 무료 한도를 쓰고 있다면 확인해야 한다.

**같은 PR에 커밋을 여러 번 올리면 워크플로가 중첩 실행된다.** 이전 실행을 자동 취소하려면 `concurrency`를 건다.

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

같은 브랜치에서 새 실행이 시작되면 진행 중인 이전 실행을 취소한다. 러너 시간도 아끼고 결과도 최신 커밋 기준으로만 남는다.

**액션 버전.** `actions/checkout@v4`처럼 메이저 버전으로 고정하는 게 보통이다. `@main`으로 쓰면 액션이 업데이트될 때 워크플로가 예고 없이 깨질 수 있다.

---

### 정리

최소 구성은 체크아웃, JDK 설치, 테스트 실행 세 스텝이면 된다. 거기에 캐시, 실패 시 리포트 업로드, 브랜치 보호 규칙까지 붙이면 혼자 하는 프로젝트에서 필요한 CI는 거의 다 갖춘 셈이다. 배포까지 자동화하는 건 그 다음 단계인데, 테스트가 자동으로 돌고 있다는 전제가 있어야 배포 자동화도 믿고 켤 수 있다.
