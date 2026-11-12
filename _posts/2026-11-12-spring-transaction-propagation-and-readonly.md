---
title: "[Spring] 트랜잭션 전파와 readOnly, 그리고 롤백이 안 되는 이유"
date: 2026-11-12 02:00:00 +0900
categories: [Backend, Spring]
tags: [spring, transactional, 트랜잭션, propagation, readonly, spring-실무-함정]
description: "@Transactional의 전파 속성(REQUIRED, REQUIRES_NEW, NESTED)이 실제로 커넥션과 롤백을 어떻게 다루는지 재현 예제로 본다. UnexpectedRollbackException이 나는 이유, REQUIRES_NEW가 커넥션 풀을 잠그는 조건, readOnly = true가 막는 것과 못 막는 것, 그리고 코드리뷰 체크리스트."
---

{% include series-nav.html series="spring-pitfalls" current=2 %}

[1편](/posts/spring-transactional-pitfalls/)에서는 "트랜잭션이 아예 안 걸리는" 경우를 봤다. 이번에는 트랜잭션이 분명히 걸렸는데 기대와 다르게 커밋되거나 롤백되는 경우다. 원인은 거의 전파 속성(propagation)이고, 여기에 `readOnly`까지 얽히면 "저장했는데 DB에 없다"는 증상으로 나타난다. 세 가지 상황을 재현하면서 하나씩 풀어 보자.

---

### 0. 전파 속성은 "이미 트랜잭션이 있을 때 어떻게 할까"를 정한다

`@Transactional`이 붙은 메서드가 호출될 때, 호출한 쪽에 이미 트랜잭션이 있을 수 있다. 전파 속성은 그때의 행동을 정한다.

| 속성 | 바깥 트랜잭션이 있을 때 | 없을 때 |
|---|---|---|
| `REQUIRED` (기본값) | 그 트랜잭션에 참여한다 | 새로 시작한다 |
| `REQUIRES_NEW` | 바깥을 잠시 멈추고 새 트랜잭션(새 커넥션)을 시작한다 | 새로 시작한다 |
| `NESTED` | 바깥 트랜잭션 안에 savepoint를 만든다 | 새로 시작한다 |
| `SUPPORTS` | 참여한다 | 트랜잭션 없이 실행한다 |
| `NOT_SUPPORTED` | 바깥을 멈추고 트랜잭션 없이 실행한다 | 트랜잭션 없이 실행한다 |
| `MANDATORY` | 참여한다 | 예외 |
| `NEVER` | 예외 | 트랜잭션 없이 실행한다 |

실무에서 마주치는 건 위의 세 줄이다. 그리고 함정은 전부 "참여한다"와 "새로 시작한다"의 차이에서 나온다. 참여하면 바깥과 운명을 같이 하고, 새로 시작하면 운명이 갈린다.

---

### 1. 참여한 트랜잭션은 혼자 롤백할 수 없다: UnexpectedRollbackException

#### 증상

회원 가입 때 쿠폰 발급이 실패해도 가입은 성공시키려고 예외를 잡았다. 그런데 가입까지 통째로 롤백되고, 로그에는 이런 예외가 남는다.

```
org.springframework.transaction.UnexpectedRollbackException:
Transaction silently rolled back because it has been marked as rollback-only
```

#### 재현

```java
@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;
    private final CouponService couponService;

    @Transactional
    public void signUp(SignUpRequest request) {
        memberRepository.save(request.toMember());
        try {
            couponService.issueWelcomeCoupon(request.email());
        } catch (RuntimeException e) {
            log.warn("쿠폰 발급 실패, 가입은 계속 진행한다", e);   // 이렇게 하면 될 줄 알았다
        }
    }
}

@Service
@RequiredArgsConstructor
public class CouponService {

    private final CouponRepository couponRepository;

    @Transactional   // 기본값 REQUIRED → signUp 의 트랜잭션에 참여한다
    public void issueWelcomeCoupon(String email) {
        couponRepository.save(Coupon.welcome(email));
        throw new IllegalStateException("쿠폰 재고 없음");
    }
}
```

테스트로 확인하면 가입이 남아 있지 않다.

```java
@SpringBootTest
class MemberServiceTest {

    @Test
    void 쿠폰_실패를_잡아도_가입이_롤백된다() {
        assertThatThrownBy(() -> memberService.signUp(new SignUpRequest("a@example.com")))
                .isInstanceOf(UnexpectedRollbackException.class);

        assertThat(memberRepository.findByEmail("a@example.com")).isEmpty();
    }
}
```

#### 원인

트랜잭션은 하나다. `issueWelcomeCoupon()`은 새 트랜잭션을 만든 게 아니라 `signUp()`의 트랜잭션에 참여했을 뿐이다. 그런데 프록시는 메서드마다 따로 붙어 있어서, 안쪽 프록시는 예외가 나가는 것을 보고 "롤백해야 한다"고 판단한다. 참여한 트랜잭션은 자기가 직접 롤백할 수 없으니, 대신 트랜잭션 전체에 **rollback-only 표시**를 남긴다.

```
signUp 프록시: 트랜잭션 시작 (커넥션 A)
  └ issueWelcomeCoupon 프록시: 기존 트랜잭션에 참여
       └ 예외 발생 → 프록시: "참여 중이니 rollback-only 표시만"
  catch 로 예외를 잡음 → signUp 은 정상 종료
signUp 프록시: 커밋 시도 → rollback-only 표시 발견 → 롤백 + UnexpectedRollbackException
```

바깥에서 예외를 잡은 것은 바깥 메서드의 흐름만 바꿨을 뿐, 이미 찍힌 표시는 지워지지 않는다. 이 동작은 `AbstractPlatformTransactionManager`의 `globalRollbackOnParticipationFailure` 설정(기본 `true`)이 정한다. 끌 수도 있지만 "안쪽이 실패했는데 바깥은 커밋된다"는 더 위험한 상태가 되니 끄지 않는다.

#### 해결

의도가 "쿠폰은 실패해도 가입은 성공"이라면 두 작업은 운명을 같이 하면 안 된다. 즉 다른 트랜잭션이어야 한다.

```java
@Transactional(propagation = Propagation.REQUIRES_NEW)
public void issueWelcomeCoupon(String email) { ... }
```

또는 안쪽에서 예외를 던지지 않고 결과를 반환하게 바꾼다. 예외가 프록시를 통과하지 않으면 rollback-only 표시도 없다.

```java
@Transactional
public boolean issueWelcomeCoupon(String email) {
    try {
        couponRepository.save(Coupon.welcome(email));
        return true;
    } catch (CouponOutOfStockException e) {
        return false;   // 프록시는 정상 종료로 본다
    }
}
```

단, 두 번째 방법은 `couponRepository.save()`가 이미 실행한 INSERT는 그대로 남는다는 점을 알고 써야 한다. 같은 트랜잭션이니 커밋될 때 같이 들어간다.

---

### 2. REQUIRES_NEW는 커넥션을 하나 더 쓴다

1번의 해결책으로 `REQUIRES_NEW`를 썼다. 이제 쿠폰 실패와 가입이 분리됐다. 그런데 이게 두 번째 함정의 시작이다.

#### 2.1. 원자성이 깨진다

`REQUIRES_NEW`는 독립된 트랜잭션이라서 안쪽이 먼저 커밋된다. 그 뒤 바깥이 실패하면 안쪽은 되돌아오지 않는다.

```java
@Transactional
public void signUp(SignUpRequest request) {
    couponService.issueWelcomeCoupon(request.email());   // REQUIRES_NEW → 여기서 커밋 완료
    memberRepository.save(request.toMember());
    throw new IllegalStateException("가입 실패");           // 가입은 롤백, 쿠폰은 이미 발급됨
}
```

회원은 없는데 쿠폰만 남는다. `REQUIRES_NEW`를 쓰는 순간 "둘 중 하나만 성공할 수 있다"를 받아들인 것이고, 그래도 되는 작업에만 써야 한다. 로그 기록, 알림 발송 이력, 실패 이력 저장처럼 본 작업의 성패와 상관없이 남겨야 하는 것이 전형적이다.

#### 2.2. 커넥션 풀이 잠긴다

더 무서운 쪽이다. `REQUIRES_NEW`는 바깥 트랜잭션을 "멈추는" 것이지 끝내는 게 아니라서, 바깥의 커넥션은 반납되지 않은 채 안쪽이 새 커넥션을 받는다. 요청 하나가 커넥션 두 개를 잡는다.

```
요청 1: signUp (커넥션 A 보유) → issueWelcomeCoupon: 커넥션 B 대기
요청 2: signUp (커넥션 C 보유) → issueWelcomeCoupon: 커넥션 D 대기
...
요청 10: signUp (커넥션 J 보유) → issueWelcomeCoupon: 커넥션 K 대기
```

HikariCP 기본 풀 크기는 10이다. 동시에 요청 10개가 `signUp()`에 들어오면 커넥션 10개가 모두 바깥 트랜잭션에 잡힌 상태에서 안쪽이 11번째 커넥션을 기다린다. 아무도 반납하지 않으니 아무도 받지 못하고, `connectionTimeout`(기본 30초) 뒤에 전부 실패한다.

```
java.sql.SQLTransientConnectionException:
HikariPool-1 - Connection is not available, request timed out after 30000ms.
```

트래픽이 적을 때는 멀쩡하다가 몰리는 순간 전체가 멈추는 전형적인 운영 장애다. 재현하려면 풀을 작게 잡고 스레드를 풀 크기만큼 띄우면 된다.

```yaml
# 재현용 설정
spring:
  datasource:
    hikari:
      maximum-pool-size: 2
      connection-timeout: 3000
```

```java
@Test
void REQUIRES_NEW_는_풀_크기만큼_동시요청이_오면_잠긴다() throws Exception {
    ExecutorService pool = Executors.newFixedThreadPool(2);
    List<Future<?>> futures = new ArrayList<>();
    for (int i = 0; i < 2; i++) {
        String email = "u" + i + "@example.com";
        futures.add(pool.submit(() -> memberService.signUp(new SignUpRequest(email))));
    }
    for (Future<?> f : futures) {
        assertThatThrownBy(f::get)
                .hasCauseInstanceOf(CannotCreateTransactionException.class);  // 안쪽이 커넥션을 못 받는다
    }
}
```

#### 해결

- 안쪽 작업이 정말 독립 트랜잭션이어야 하는지 다시 본다. 대부분은 "실패해도 되는 부가 작업"이라서, 트랜잭션 밖으로 빼는 게 맞다. 바깥 트랜잭션이 커밋된 뒤에 실행하는 `@TransactionalEventListener(phase = AFTER_COMMIT)`가 이 용도다.
- 꼭 써야 한다면 바깥 트랜잭션을 짧게 만든다. 외부 API 호출, 파일 업로드처럼 DB와 상관없는 작업이 `@Transactional` 안에 있으면 그 시간 동안 커넥션 두 개가 묶인다.
- 풀 크기를 늘리는 건 미봉책이다. "동시 요청 수 × REQUIRES_NEW 깊이"만큼 필요해서 금방 다시 모자란다.

#### NESTED는 대안이 아니다

"바깥 안에서 부분 롤백"이라면 `NESTED`가 떠오른다. savepoint를 만들어 안쪽만 되돌리고, 안쪽 커밋은 바깥과 함께 되니 원자성도 지킨다. 그런데 JDBC(`DataSourceTransactionManager`, MyBatis)에서만 그렇다. JPA의 `JpaTransactionManager`는 기본적으로 지원하지 않는다.

```
org.springframework.transaction.NestedTransactionNotSupportedException:
JpaDialect does not support savepoints - check your JPA provider's capabilities
```

설정으로 켤 수는 있지만, savepoint는 DB만 되돌리고 영속성 컨텍스트(1차 캐시)는 되돌리지 않는다. 롤백된 엔티티가 영속 상태로 남아 다음 flush 때 다시 나간다. JPA를 쓴다면 `NESTED`는 없는 선택지로 두는 게 안전하다.

---

### 3. readOnly = true는 무엇을 막고 무엇을 못 막나

#### 증상

조회 메서드에 `readOnly = true`를 붙이는 건 좋은 습관이다. 그런데 이걸 붙인 메서드 안에서 "값을 하나만 고치는" 코드가 섞이면 증상이 둘로 갈린다. 어떤 때는 조용히 저장이 안 되고, 어떤 때는 예외가 난다.

```java
@Transactional(readOnly = true)
public MemberResponse getMember(Long id) {
    Member member = memberRepository.findById(id).orElseThrow();
    member.touchLastViewedAt();          // 더티 체킹으로 저장될 거라 기대
    return MemberResponse.from(member);
}
```

이 코드는 예외 없이 정상 종료되지만 `last_viewed_at`은 바뀌지 않는다. 테스트에서 같은 영속성 컨텍스트로 다시 읽으면 바뀐 것처럼 보여서 더 헷갈린다.

#### 원인: readOnly는 세 군데에 손을 댄다

`readOnly = true`는 "쓰기를 금지하는 스위치" 하나가 아니다. 세 층이 각자 반응한다.

**1) Hibernate: flush 모드가 MANUAL이 된다.** 트랜잭션이 끝날 때 flush를 하지 않는다. 그래서 더티 체킹으로 감지된 변경도, `persist()`로 쌓인 INSERT도 DB로 나가지 않는다. 예외도 없다. 대신 스냅샷을 만들지 않아서 메모리를 아끼고 더티 체킹 비용이 사라진다. 이게 `readOnly`를 붙이는 실제 이유다.

**2) Spring: 커넥션에 `setReadOnly(true)`를 건다.** JDBC 드라이버에 "이 커넥션은 읽기 전용"이라고 알린다. 이걸 어떻게 처리할지는 드라이버 몫이다.

**3) MySQL Connector/J: `SET SESSION TRANSACTION READ ONLY`를 보낸다.** MySQL 5.6.5 이상에서 이 상태로 쓰기를 시도하면 DB가 거부한다.

```
java.sql.SQLException: Cannot execute statement in a READ ONLY transaction.
```

그래서 증상이 둘로 갈린다. 더티 체킹이나 `persist()`처럼 flush 때 나가는 쓰기는 1번에서 조용히 사라진다. 반면 flush와 상관없이 즉시 나가는 쓰기는 3번에서 예외가 난다.

- `@GeneratedValue(strategy = IDENTITY)` 엔티티의 `save()`: ID를 받으려고 즉시 INSERT를 보낸다 → 예외
- `@Modifying` 벌크 쿼리, `JdbcTemplate`, MyBatis의 UPDATE: 즉시 실행 → 예외
- `@GeneratedValue(strategy = SEQUENCE)`나 UUID 엔티티의 `save()`: flush 때까지 미뤄진다 → 조용히 사라짐
- 더티 체킹: 조용히 사라짐

"readOnly인데 왜 저장이 되지?"의 반대도 있다. PostgreSQL이나 H2처럼 드라이버가 `setReadOnly`를 힌트로만 쓰는 조합에서는 3번이 없어서, `JdbcTemplate`으로 쓴 UPDATE가 그대로 들어간다. 즉 `readOnly`는 쓰기 방지 장치가 아니다. 쓰기 방지는 DB 계정 권한으로 한다.

#### 해결

- `readOnly` 메서드 안에서 상태를 바꾸지 않는다. "조회하면서 마지막 조회 시각 갱신" 같은 요구는 별도 쓰기 메서드로 빼거나, 이벤트로 넘긴다.
- 조회 메서드와 쓰기 메서드를 클래스 수준에서 나누면 실수가 줄어든다. `@Transactional(readOnly = true)`를 클래스에 붙이고 쓰기 메서드에만 `@Transactional`을 덧붙이는 방식이 흔하다.

```java
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class MemberService {

    public MemberResponse getMember(Long id) { ... }         // 읽기 전용

    @Transactional                                           // 메서드가 클래스 설정을 덮어쓴다
    public void changeNickname(Long id, String nickname) { ... }
}
```

#### 전파와 만나면 readOnly는 바깥을 따른다

`readOnly`는 트랜잭션의 속성이지 메서드의 속성이 아니다. `REQUIRED`로 참여하면 바깥 트랜잭션의 설정을 따른다.

```java
@Transactional                       // 읽기·쓰기 트랜잭션
public void process(Long id) {
    memberQuery.getMember(id);       // readOnly = true 지만 바깥에 참여 → 효과 없음
}
```

반대는 더 위험하다. 바깥이 `readOnly = true`인데 안쪽이 쓰기 메서드면, 안쪽은 읽기 전용 트랜잭션에 참여한다. MySQL이면 쓰기 시점에 예외가 나고, 다른 DB면 조용히 사라진다. Spring은 이 불일치를 기본적으로 검사하지 않는다(`validateExistingTransaction = false`). 켜면 `IllegalTransactionStateException`으로 바로 드러나니, 서비스가 서로를 많이 호출하는 구조라면 켜 두는 것도 방법이다.

```java
@Bean
public PlatformTransactionManager transactionManager(EntityManagerFactory emf) {
    JpaTransactionManager tm = new JpaTransactionManager(emf);
    tm.setValidateExistingTransaction(true);
    return tm;
}
```

#### 읽기 복제본 라우팅을 readOnly로 할 때

`readOnly` 트랜잭션은 레플리카로, 쓰기 트랜잭션은 소스로 보내는 구성이 흔하다. `AbstractRoutingDataSource`에서 `TransactionSynchronizationManager.isCurrentTransactionReadOnly()`를 보고 고르는 방식이다. 이게 동작하지 않고 전부 소스로 가는 경우가 있는데, 순서 때문이다.

트랜잭션 매니저는 **커넥션을 먼저 얻고 나서** readOnly 플래그를 동기화 매니저에 등록한다. 라우팅 데이터소스가 커넥션을 고르는 시점에는 플래그가 아직 없다. 그래서 실제 쿼리가 나갈 때까지 커넥션 획득을 미루는 `LazyConnectionDataSourceProxy`로 라우팅 데이터소스를 감싸야 한다.

```java
@Bean
public DataSource dataSource(DataSource routingDataSource) {
    return new LazyConnectionDataSourceProxy(routingDataSource);
}
```

이걸 빼먹으면 레플리카를 붙였는데 부하는 전부 소스로 간다. 설정 직후 소스와 레플리카의 쿼리 수를 꼭 비교해 본다.

---

### 정리

| 상황 | 실제로 일어나는 일 | 대응 |
|---|---|---|
| 참여한 안쪽 트랜잭션의 예외를 바깥에서 catch | rollback-only 표시로 전체 롤백, `UnexpectedRollbackException` | 운명을 분리하려면 `REQUIRES_NEW`, 아니면 예외 대신 결과 반환 |
| `REQUIRES_NEW` 뒤에 바깥이 실패 | 안쪽은 이미 커밋돼 남는다 | 성패가 독립이어도 되는 작업에만 사용 |
| `REQUIRES_NEW`에 동시 요청이 풀 크기만큼 | 요청마다 커넥션 2개, 풀 교착 | `AFTER_COMMIT` 이벤트로 트랜잭션 밖으로, 바깥 트랜잭션 짧게 |
| JPA에서 `NESTED` | `NestedTransactionNotSupportedException`, 켜도 1차 캐시는 안 되돌아감 | JPA에서는 쓰지 않는다 |
| `readOnly`에서 더티 체킹·`persist` | flush 안 함, 조용히 사라짐 | 쓰기 메서드 분리 |
| `readOnly`에서 즉시 쓰기(IDENTITY, 벌크, JDBC) | MySQL이면 `READ ONLY transaction` 예외, 다른 DB면 들어감 | 쓰기 방지는 DB 권한으로 |
| `readOnly` 메서드가 쓰기 트랜잭션에 참여 | readOnly 무시 | 트랜잭션 경계를 바깥에서 설계, 필요하면 `validateExistingTransaction` |
| 레플리카 라우팅이 안 됨 | 커넥션 획득이 플래그 등록보다 빠름 | `LazyConnectionDataSourceProxy` |

### 코드리뷰 체크리스트

- `@Transactional` 메서드 안의 `try-catch`가 다른 `@Transactional` 메서드 호출을 감싸고 있지 않은가.
- `REQUIRES_NEW`가 있다면, 그 작업이 바깥과 운명이 달라도 되는 작업인가. 그리고 바깥 트랜잭션 안에 외부 호출이 없는가.
- 조회 메서드에 `readOnly = true`가 있고, 그 안에서 엔티티 상태를 바꾸는 줄이 없는가.
- 클래스에 `readOnly = true`를 걸었다면 쓰기 메서드마다 `@Transactional`이 다시 붙어 있는가.
- 레플리카 라우팅을 쓴다면 `LazyConnectionDataSourceProxy`가 있는가.

전파 속성 문제는 로컬에서 재현이 어렵고 운영에서 트래픽이 몰릴 때 터진다. 그래서 코드를 읽을 때 "이 호출은 어느 트랜잭션에 참여하나, 커넥션을 몇 개 잡나"를 한 번 세어 보는 습관이 가장 싼 예방책이다.

---

다음 편은 트랜잭션에서 잠시 벗어나 빈 생명주기로 간다. `@PostConstruct`에서 자기 자신의 `@Transactional` 메서드를 불렀을 때, 생성자 주입 순환 참조, `@Lazy`로 덮었을 때 생기는 일을 다룬다.
