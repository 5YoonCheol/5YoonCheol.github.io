---
title: "[Java] Stack(스택)과 Queue(큐)"
date: 2024-09-10 10:10:34 +0900
categories: [Backend, Java]
tags: ["java", "queue", "stack", "스택", "자바", "큐"]
tistory_url: https://yoon-ssi.tistory.com/49
render_with_liquid: false
---

Java에서 Stack과 Queue는 기본적인 자료구조로, 데이터를 저장하고 관리하는 방식이 다르다.

두 자료구조는 데이터를 삽입하고 삭제하는 규칙이 다르며, 각기 다른 상황에서 사용된다.

---

### 1. **Stack (스택)**

#### 개요

- **정의**: Stack은 LIFO(Last In, First Out) 원칙에 따라 데이터를 관리하는 자료구조이다. 가장 나중에 삽입된 데이터가 가장 먼저 삭제된다.
- **예시**: 접시 쌓기, 웹 브라우저의 뒤로 가기 기능

#### 주요 연산

- **push(E item)**: 스택의 맨 위에 데이터를 삽입한다.
- **pop()**: 스택의 맨 위에 있는 데이터를 제거하고 반환한다. 스택이 비어있을 경우 EmptyStackException을 던진다.
- **peek()**: 스택의 맨 위에 있는 데이터를 제거하지 않고 반환한다.
- **isEmpty()**: 스택이 비어있는지를 확인합니다. 비어있다면 true를 반환한다.

#### Java에서의 구현

- Java에서 Stack은 java.util.Stack 클래스를 사용하여 구현된다.
- Stack 클래스는 Vector 클래스를 상속받아 구현되며, 스택과 관련된 기본적인 연산(push, pop 등)을 제공한다.

```java
import java.util.Stack;

public class StackExample {
    public static void main(String[] args) {
        Stack<Integer> stack = new Stack<>();
        stack.push(10);
        stack.push(20);
        stack.push(30);

        System.out.println(stack.pop()); // 출력: 30
        System.out.println(stack.peek()); // 출력: 20
        System.out.println(stack.isEmpty()); // 출력: false
    }
}
```

---

### 2. **Queue (큐)**

#### 개요

- **정의**: Queue는 FIFO(First In, First Out) 원칙에 따라 데이터를 관리하는 자료구조이다. 가장 먼저 삽입된 데이터가 가장 먼저 삭제된다.
- **예시**: 은행 대기 줄, 프린터 대기열

#### 주요 연산

- **offer(E item)**: 큐의 끝에 데이터를 삽입한다. 성공적으로 삽입되면 true를 반환하며, 큐가 가득 차면 false를 반환한다.
- **poll()**: 큐의 맨 앞에 있는 데이터를 제거하고 반환한다. 큐가 비어있으면 null을 반환한다.
- **peek()**: 큐의 맨 앞에 있는 데이터를 제거하지 않고 반환한다. 큐가 비어있으면 null을 반환한다.
- **isEmpty()**: 큐가 비어있는지를 확인한다. 비어있다면 true를 반환한다.

#### Java에서의 구현

- Java에서 Queue는 java.util.Queue 인터페이스로 표현되며, 일반적으로 LinkedList 클래스 또는 ArrayDeque 클래스를 사용하여 구현된다.
- PriorityQueue와 같은 특수 큐 구현도 Java에서 제공된다.

```java
import java.util.LinkedList;
import java.util.Queue;

public class QueueExample {
    public static void main(String[] args) {
        Queue<Integer> queue = new LinkedList<>();
        queue.offer(10);
        queue.offer(20);
        queue.offer(30);

        System.out.println(queue.poll()); // 출력: 10
        System.out.println(queue.peek()); // 출력: 20
        System.out.println(queue.isEmpty()); // 출력: false
    }
}
```

---

### 3. **Stack과 Queue의 비교**

- **데이터 접근 방식**:
  - **Stack**: LIFO 방식. 나중에 삽입된 데이터가 먼저 처리됨.
  - **Queue**: FIFO 방식. 먼저 삽입된 데이터가 먼저 처리됨.
- **용도**:
  - **Stack**: 재귀적인 알고리즘, 웹 브라우저의 뒤로 가기, 실행 취소 기능 등.
  - **Queue**: 작업 대기열, 메시지 처리 시스템, BFS(너비 우선 탐색) 등.
