---
title: "[Java] Executor 프레임워크"
date: 2024-11-02 10:00:22 +0900
categories: ["Java"]
tags: ["executor", "java"]
tistory_url: https://yoon-ssi.tistory.com/102
render_with_liquid: false
---

Java의 **Executor 프레임워크**는 스레드 관리를 위한 고수준의 API를 제공하여 스레드 생성, 관리, 실행 등을 쉽게 수행할 수 있게 해주는 프레임워크이다. 멀티스레딩 작업을 효율적으로 처리하도록 설계되었으며, 개발자가 직접 스레드를 생성하거나 종료할 필요 없이 스레드 풀을 활용하여 스레드의 재사용과 최적화를 자동으로 관리해 준다.

java.util.concurrent 패키지에 포함되어 있다.

---

### Executor 프레임워크의 주요 개념

#### 1. Executor 인터페이스

Executor 인터페이스는 Java의 Executor 프레임워크에서 가장 기본이 되는 인터페이스로, **작업(Runnable)을 실행하는 방법을 정의**한다. execute(Runnable command) 메서드 하나만을 포함하며, 구현체에 따라 스레드를 생성하거나 스레드 풀에서 스레드를 가져와 작업을 실행한다.

```java
Executor executor = new Executor() {
    @Override
    public void execute(Runnable command) {
        new Thread(command).start();
    }
};
```

#### 2. ExecutorService 인터페이스

ExecutorService는 Executor의 하위 인터페이스로, 작업 실행 외에도 **스레드 풀 관리, 종료, 상태 확인 등의 기능**을 제공한다. 작업을 제출하고 결과를 기다리는 등의 동작을 관리할 수 있다.

**주요 메서드**

- submit(): Callable이나 Runnable 작업을 제출하고 Future 객체를 반환받아 결과를 얻거나 작업 상태를 추적할 수 있다.
- shutdown(): 스레드 풀이 더 이상 새로운 작업을 받지 않고 남은 작업이 모두 끝나면 종료된다.
- shutdownNow(): 현재 실행 중인 작업을 즉시 중단하려고 시도한다.
- invokeAll(): 여러 Callable 작업을 동시에 실행하고, 모든 작업이 완료될 때까지 기다린 후 결과를 반환한다.
- invokeAny(): 여러 작업 중 가장 먼저 완료된 작업의 결과만 반환한다.

```java
ExecutorService executorService = Executors.newFixedThreadPool(3);

executorService.submit(() -> {
    System.out.println("작업 실행 중...");
});

// 서비스 종료
executorService.shutdown();
```

#### 3. Executors 유틸리티 클래스

Executors 클래스는 다양한 유형의 스레드 풀을 생성할 수 있는 정적 메서드를 제공한다.

- **newFixedThreadPool(int nThreads)**: 고정 크기의 스레드 풀을 생성한다. 지정한 개수만큼 스레드를 유지하며, 스레드 풀이 가득 차면 대기열에 작업이 쌓인다.
- **newCachedThreadPool()**: 필요한 경우 새 스레드를 생성하고, 사용하지 않는 스레드는 일정 시간 후 제거된다. 많은 작업을 빠르게 처리할 때 유용하지만, 스레드 수가 동적으로 증가할 수 있어 메모리 사용량을 고려해야 한다.
- **newSingleThreadExecutor()**: 단일 스레드 풀을 생성한다. 작업이 순차적으로 실행되며, 작업 큐에 있는 작업들이 차례로 실행된다.
- **newScheduledThreadPool(int corePoolSize)**: 지정된 간격이나 특정 시간에 작업을 실행할 수 있는 스레드 풀이다.

```java
ExecutorService fixedThreadPool = Executors.newFixedThreadPool(3);
ExecutorService cachedThreadPool = Executors.newCachedThreadPool();
ExecutorService singleThreadExecutor = Executors.newSingleThreadExecutor();
ScheduledExecutorService scheduledThreadPool = Executors.newScheduledThreadPool(2);
```

---

### 스레드 풀(Thread Pool)

스레드 풀은 **미리 생성한 스레드들의 그룹**으로, 작업이 요청될 때마다 새로운 스레드를 생성하는 대신 **기존의 스레드를 재사용**하여 성능을 최적화한다. 스레드 풀을 사용하면 **자원 절약**과 **응답 속도 향상** 효과를 얻을 수 있다.

### Callable과 Future

- **Callable**: Runnable과 유사하지만, 반환값을 가질 수 있고, Exception을 발생시킬 수 있는 작업을 정의할 수 있다. call() 메서드를 통해 호출된다.
- **Future**: 비동기 작업의 결과를 저장하는 객체로, 작업 완료 여부를 확인하거나 결과를 가져올 수 있다.

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

### 주요 스레드 풀 유형과 사용 예시

#### 1. 고정 크기 스레드 풀 (newFixedThreadPool)

지정된 개수의 스레드만을 유지하며, 추가 작업이 들어오면 큐에 쌓아 순서대로 처리한다. 스레드 수가 고정되어 있어 예측 가능한 성능을 제공한다.

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

요청이 많을 경우 필요한 만큼의 스레드를 생성하고, 일정 시간 동안 사용되지 않으면 스레드를 종료시켜 자원을 관리한다. 작업 수가 동적으로 증가할 때 유용하지만, 요청이 급증하면 스레드 수가 증가할 수 있다.

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

단일 스레드로 구성된 스레드 풀로, 작업이 순차적으로 처리된다. 중요한 작업의 순서를 유지해야 할 때 유용하다.

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

지정된 시간 간격이나 특정 시점에 작업을 실행할 수 있도록 스케줄링 기능을 제공한다. ScheduledExecutorService를 사용하여 주기적으로 실행할 작업을 쉽게 설정할 수 있다.

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

### Executor 프레임워크의 장점

- **효율적인 자원 관리**: 스레드 풀이 스레드 수를 관리하여 자원을 절약하고, 과도한 스레드 생성으로 인한 메모리 부족 문제를 방지한다.
- **응답성 향상**: 스레드 풀에서 미리 생성된 스레드를 사용하여 작업을 빠르게 처리하고, 새로운 스레드 생성 시간 없이 즉시 실행할 수 있다.
- **코드 간소화**: 스레드 풀과 비동기 작업 처리를 쉽게 관리할 수 있어, 코드가 간결하고 유지보수가 쉬워진다.
- **스케줄링 기능 제공**: 일정 시간 간격이나 특정 시점에 실행하는 기능을 제공하여 반복적인 작업을 간단하게 구현할 수 있다.
