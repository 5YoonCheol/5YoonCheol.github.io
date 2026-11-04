---
title: "[Spring] @Transactional이 동작하지 않는 경우 정리"
date: 2026-11-03 02:00:00 +0900
categories: [Backend, Spring]
tags: [spring, transactional, aop, 트랜잭션, spring-실무-함정]
description: "@Transactional을 붙였는데 트랜잭션이 안 걸리거나 롤백이 안 되는 경우를 프록시 동작 기준으로 정리한다. 같은 클래스 내부 호출, private 메서드, Checked Exception, 예외 삼키기, rollback-only, 빈이 아닌 객체."
---

{% include series-nav.html series="spring-pitfalls" current=1 %}

`@Transactional`은 메서드에 붙이기만 하면 트랜잭션이 걸리는 것처럼 보인다. 그런데 분명 붙였는데 롤백이 안 되거나, 아예 트랜잭션이 시작되지 않는 경우가 있다. 대부분은 스프링이 트랜잭션을 거는 방식을 알면 이유가 보인다. 자주 헷갈리는 경우를 하나씩 정리해보자.

---

### 1. 먼저, 트랜잭션은 프록시가 건다

스프링은 `@Transactional`이 붙은 빈을 그대로 등록하지 않고, 그 빈을 감싼 프록시 객체를 만들어 등록한다. 외부에서 메서드를 호출하면 프록시가 먼저 호출을 받아 트랜잭션을 시작하고, 실제 객체의 메서드를 실행한 다음, 결과에 따라 커밋하거나 롤백한다.

```
호출자 → [프록시: 트랜잭션 시작] → 실제 객체.method() → [프록시: 커밋 또는 롤백]
```

아래에서 다룰 경우들은 거의 다 "호출이 프록시를 거치지 않았다"는 한 가지 원인에서 나온다.

---

### 2. 같은 클래스 안에서 호출하는 경우 (self-invocation)

가장 흔한 실수다.

```java
@Service
public class OrderService {

    public void placeOrder(OrderRequest request) {
        // ... 검증 로직
        saveOrder(request); // this.saveOrder() 호출
    }

    @Transactional
    public void saveOrder(OrderRequest request) {
        orderRepository.save(request.toEntity());
        stockRepository.decrease(request.getItemId(), request.getQuantity());
    }
}
```

외부에서 `placeOrder()`를 호출하면 프록시를 거치긴 하지만, `placeOrder()`에는 `@Transactional`이 없으니 트랜잭션 없이 실제 객체로 넘어간다. 그 안에서 부르는 `saveOrder()`는 `this.saveOrder()`, 즉 프록시가 아니라 실제 객체의 메서드를 직접 부르는 것이다. 그래서 `saveOrder()`에 붙인 `@Transactional`은 무시된다.

해결 방법은 몇 가지가 있다.

- 트랜잭션이 필요한 메서드를 별도의 빈으로 분리하고, 그 빈을 주입받아 호출한다. 가장 깔끔하다.
- 바깥 메서드(`placeOrder()`)에 `@Transactional`을 붙인다. 검증까지 트랜잭션에 포함돼도 괜찮다면 이게 제일 간단하다.

```java
@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderWriter orderWriter;

    public void placeOrder(OrderRequest request) {
        // ... 검증 로직
        orderWriter.save(request); // 다른 빈 → 프록시를 거친다
    }
}

@Component
@RequiredArgsConstructor
public class OrderWriter {

    private final OrderRepository orderRepository;
    private final StockRepository stockRepository;

    @Transactional
    public void save(OrderRequest request) {
        orderRepository.save(request.toEntity());
        stockRepository.decrease(request.getItemId(), request.getQuantity());
    }
}
```

---

### 3. public이 아닌 메서드

프록시는 외부에서 호출할 수 있는 메서드를 가로채는 방식이라, 기본 설정에서는 `private` 메서드에 붙인 `@Transactional`이 적용되지 않는다. `private`은 애초에 다른 빈에서 부를 수도 없으니 대부분 2번의 self-invocation과 같이 나타난다.

`protected`나 package-private 메서드는 스프링 버전에 따라 다르다. 스프링 6.0부터는 CGLIB 프록시에서 이런 메서드에도 적용되도록 바뀌었지만, 헷갈리지 않으려면 트랜잭션 경계가 되는 메서드는 `public`으로 두는 게 낫다.

---

### 4. Checked Exception은 롤백되지 않는다

스프링의 기본 롤백 규칙은 이렇다.

- `RuntimeException`과 `Error`가 던져지면 롤백한다.
- Checked Exception(`Exception`을 상속하지만 `RuntimeException`은 아닌 예외)이 던져지면 커밋한다.

```java
@Transactional
public void register(MemberRequest request) throws IOException {
    memberRepository.save(request.toEntity());
    fileStorage.upload(request.getProfileImage()); // IOException 발생
}
```

`upload()`에서 `IOException`이 나도 회원 저장은 그대로 커밋된다. 예외가 났으니 당연히 롤백될 거라고 생각하기 쉬운 부분이다.

Checked Exception에도 롤백이 필요하면 `rollbackFor`로 지정한다.

```java
@Transactional(rollbackFor = Exception.class)
public void register(MemberRequest request) throws IOException {
    // ...
}
```

---

### 5. 예외를 잡아서 삼켜버리는 경우

프록시는 메서드 밖으로 예외가 던져졌는지를 보고 롤백을 결정한다. 메서드 안에서 `try-catch`로 예외를 잡고 끝내버리면 프록시 입장에서는 정상 종료라서 커밋한다.

```java
@Transactional
public void transfer(Long fromId, Long toId, long amount) {
    try {
        accountRepository.withdraw(fromId, amount);
        accountRepository.deposit(toId, amount);
    } catch (Exception e) {
        log.error("이체 실패", e); // 로그만 남기고 끝 → 커밋된다
    }
}
```

출금은 됐는데 입금에서 실패하면, 출금만 반영된 채 커밋된다. 예외를 잡아야 한다면 다시 던지거나, 직접 롤백 표시를 해야 한다.

```java
} catch (Exception e) {
    log.error("이체 실패", e);
    throw new TransferFailedException(e); // RuntimeException을 상속한 예외
}
```

---

### 6. 내부 트랜잭션의 예외를 바깥에서 잡는 경우

기본 전파 속성(`REQUIRED`)에서는 안쪽 메서드가 바깥 트랜잭션에 그대로 참여한다. 이때 안쪽에서 `RuntimeException`이 나면 트랜잭션 전체에 rollback-only 표시가 붙는다.

```java
@Transactional
public void signUp(MemberRequest request) {
    memberRepository.save(request.toEntity());
    try {
        couponService.issueWelcomeCoupon(request.getEmail()); // 내부에서 RuntimeException
    } catch (RuntimeException e) {
        log.warn("쿠폰 발급 실패, 가입은 계속 진행");
    }
}
```

바깥에서 예외를 잡았으니 가입은 커밋될 것 같지만, 이미 rollback-only 표시가 붙은 상태라 커밋 시점에 `UnexpectedRollbackException`이 나면서 전부 롤백된다.

쿠폰 발급 실패와 상관없이 가입은 성공시키고 싶다면, 안쪽 메서드를 `REQUIRES_NEW`로 분리해서 독립된 트랜잭션으로 돌려야 한다.

```java
@Transactional(propagation = Propagation.REQUIRES_NEW)
public void issueWelcomeCoupon(String email) {
    // ...
}
```

`REQUIRES_NEW`는 커넥션을 하나 더 쓰기 때문에, 트래픽이 몰리는 곳에서 남용하면 커넥션 풀이 부족해질 수 있다는 점은 같이 기억해두자.

---

### 7. 스프링 빈이 아닌 객체

`new`로 직접 만든 객체는 스프링이 관리하지 않으니 프록시도 없다. 당연한 얘기지만, 유틸 클래스나 테스트 코드에서 객체를 직접 생성해 호출하다가 놓치는 경우가 있다.

---

### 정리

| 상황 | 원인 | 대응 |
|------|------|------|
| 같은 클래스 내부 호출 | 프록시를 거치지 않음 | 빈 분리, 또는 바깥 메서드에 적용 |
| private 메서드 | 프록시가 가로챌 수 없음 | public 메서드에 적용 |
| Checked Exception | 기본 롤백 대상이 아님 | `rollbackFor` 지정 |
| 예외를 catch 후 종료 | 프록시가 예외를 못 봄 | 다시 던지기 |
| 내부 예외를 바깥에서 catch | rollback-only 표시 | `REQUIRES_NEW` 검토 |
| `new`로 만든 객체 | 스프링 빈이 아님 | 빈으로 주입받아 사용 |

`@Transactional`이 이상하게 동작한다 싶으면 "이 호출이 프록시를 거쳤나?"와 "예외가 메서드 밖으로 나갔나?" 두 가지부터 확인해보면 된다.

---

다음 편에서는 이 글 6번에서 잠깐 나온 전파 속성을 제대로 다룬다. `REQUIRES_NEW` 안에서 예외를 잡으면 어떻게 되는지, `readOnly = true`가 실제로 무엇을 막고 무엇을 못 막는지, 그리고 전파 속성이 커넥션 풀을 어떻게 잡아먹는지까지: **트랜잭션 전파와 readOnly, 그리고 롤백이 안 되는 이유** (11월 12일 게시 예정)
