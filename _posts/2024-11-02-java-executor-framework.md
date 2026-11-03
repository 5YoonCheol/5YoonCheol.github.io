---
title: "[Java] Executor 프레임워크"
date: 2024-11-02 02:00:00 +0900
categories: [Backend, Java]
tags: ["executor", "java"]
tistory_url: https://yoon-ssi.tistory.com/102
render_with_liquid: false
---

스레드를 직접 new Thread()로 만들어 쓰다 보면 관리할 게 금방 많아진다. 이럴 때 쓰는 게 Java의 Executor 프레임워크다.

Executor 프레임워크는 스레드를 만들고, 관리하고, 실행하는 일을 대신 해주는 고수준 API다. 개발자가 스레드를 직접 만들고 종료할 필요 없이, 스레드 풀을 이용해서 스레드를 재사용하고 관리해준다. java.util.concurrent 패키지에 들어 있다.

---

### 주요 개념

#### 1. Executor 인터페이스

Executor 프레임워크의 가장 기본이 되는 인터페이스로, 작업(Runnable)을 어떻게 실행할지를 정의한다. 메서드는 execute(Runnable command) 하나뿐이고, 구현체에 따라 스레드를 새로 만들 수도, 스레드 풀에서 꺼내 쓸 수도 있다.

```java
Executor executor = new Executor() {
    @Override
    public void execute(Runnable command) {
        new Thread(command).start();
    }
};
```

#### 2. ExecutorService 인터페이스

Executor를 확장한 인터페이스로, 작업 실행뿐 아니라 스레드 풀 관리, 종료, 상태 확인까지 할 수 있다. 작업을 제출하고 결과를 기다리는 것도 여기서 한다.

자주 쓰는 메서드:

- submit(): Callable이나 Runnable 작업을 제출하고 Future를 돌려받는다. Future로 결과를 받거나 작업 상태를 확인한다.
- shutdown(): 새 작업은 더 받지 않고, 남은 작업이 끝나면 종료한다.
- shutdownNow(): 실행 중인 작업까지 바로 멈추려고 시도한다.
- invokeAll(): 여러 Callable을 동시에 실행하고, 전부 끝날 때까지 기다렸다가 결과를 돌려준다.
- invokeAny(): 여러 작업 중 제일 먼저 끝난 작업의 결과만 돌려준다.

```java
ExecutorService executorService = Executors.newFixedThreadPool(3);

executorService.submit(() -> {
    System.out.println("작업 실행 중...");
});

// 서비스 종료
executorService.shutdown();
```

#### 3. Executors 유틸리티 클래스

여러 종류의 스레드 풀을 만들어주는 정적 메서드를 모아둔 클래스다.

- newFixedThreadPool(int nThreads): 크기가 고정된 스레드 풀. 정해진 개수의 스레드만 유지하고, 다 차면 작업이 대기열에 쌓인다.
- newCachedThreadPool(): 필요하면 스레드를 새로 만들고, 한동안 안 쓰는 스레드는 정리한다. 짧은 작업을 많이 처리할 때 좋지만 스레드가 계속 늘어날 수 있어서 메모리를 신경 써야 한다.
- newSingleThreadExecutor(): 스레드 하나짜리 풀. 작업이 큐에 들어온 순서대로 하나씩 실행된다.
- newScheduledThreadPool(int corePoolSize): 일정 간격이나 특정 시간에 작업을 실행할 수 있는 풀.

```java
ExecutorService fixedThreadPool = Executors.newFixedThreadPool(3);
ExecutorService cachedThreadPool = Executors.newCachedThreadPool();
ExecutorService singleThreadExecutor = Executors.newSingleThreadExecutor();
ScheduledExecutorService scheduledThreadPool = Executors.newScheduledThreadPool(2);
```

---

### 스레드 풀(Thread Pool)

스레드 풀은 미리 만들어 둔 스레드 묶음이다. 작업이 올 때마다 스레드를 새로 만드는 대신 있는 스레드를 재사용한다. 스레드를 만들고 없애는 비용을 아낄 수 있고, 응답도 빨라진다.

### Callable과 Future

- Callable: Runnable과 비슷하지만 반환값을 가질 수 있고 예외를 던질 수 있다. call() 메서드로 실행된다.
- Future: 비동기 작업의 결과를 담는 객체다. 작업이 끝났는지 확인하거나 결과를 꺼낼 수 있다.

```java
Callable<Integer> task = () -> {
    return 123;
};
Future<Integer> future = executorService.submit(task);

try {
    Integer result = future.get(); // 작업이 완료될 때까지 대기하고 결과를 반환
    System.out.println("결과: " + result);
} catch (InterruptedException | ExecutionException e) {
    e.printStackTrace();
}
```

---

### 스레드 풀 종류별 예시

#### 1. 고정 크기 스레드 풀 (newFixedThreadPool)

정해진 개수의 스레드만 두고, 넘치는 작업은 큐에 쌓아 순서대로 처리한다. 스레드 수가 고정이라 성능을 예측하기 쉽다.

```java
ExecutorService fixedThreadPool = Executors.newFixedThreadPool(3);

for (int i = 0; i < 5; i++) {
    fixedThreadPool.submit(() -> {
        System.out.println("작업 실행 중... " + Thread.currentThread().getName());
    });
}
fixedThreadPool.shutdown();
```

#### 2. 캐시된 스레드 풀 (newCachedThreadPool)

요청이 많으면 필요한 만큼 스레드를 만들고, 한동안 안 쓰면 정리한다. 작업량이 들쭉날쭉할 때 유용하지만, 요청이 확 몰리면 스레드도 확 늘어난다.

```java
ExecutorService cachedThreadPool = Executors.newCachedThreadPool();

for (int i = 0; i < 5; i++) {
    cachedThreadPool.submit(() -> {
        System.out.println("작업 실행 중... " + Thread.currentThread().getName());
    });
}
cachedThreadPool.shutdown();
```

#### 3. 단일 스레드 풀 (newSingleThreadExecutor)

스레드가 하나라 작업이 순서대로 처리된다. 작업 순서를 꼭 지켜야 할 때 쓴다.

```java
ExecutorService singleThreadExecutor = Executors.newSingleThreadExecutor();

singleThreadExecutor.submit(() -> {
    System.out.println("작업 1 실행 중...");
});

singleThreadExecutor.submit(() -> {
    System.out.println("작업 2 실행 중...");
});

singleThreadExecutor.shutdown();
```

#### 4. 스케줄링 스레드 풀 (newScheduledThreadPool)

일정 시간 뒤에 실행하거나 주기적으로 반복 실행할 수 있다. ScheduledExecutorService로 반복 작업을 쉽게 설정할 수 있다.

```java
ScheduledExecutorService scheduledThreadPool = Executors.newScheduledThreadPool(2);

// 일정 시간 후 작업 실행
scheduledThreadPool.schedule(() -> System.out.println("5초 후 실행"), 5, TimeUnit.SECONDS);

// 일정 간격으로 작업 실행
scheduledThreadPool.scheduleAtFixedRate(() -> System.out.println("주기적으로 실행"), 1, 3, TimeUnit.SECONDS);

// 스케줄링 서비스 종료
scheduledThreadPool.shutdown();
```

---

### 왜 쓰나

- 스레드 수를 풀이 관리해서 자원을 아끼고, 스레드를 과하게 만들다 메모리가 부족해지는 일을 막는다.
- 미리 만든 스레드를 쓰니 스레드 생성 시간 없이 바로 작업을 시작한다.
- 스레드 관리와 비동기 처리 코드가 간단해져서 유지보수하기 좋다.
- 예약 실행, 주기 실행을 간단하게 구현할 수 있다.
