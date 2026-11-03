---
title: "[Java] Stack(스택)과 Queue(큐)"
date: 2024-09-10 10:10:34 +0900
categories: [Backend, Java]
tags: ["java", "queue", "stack", "스택", "자바", "큐"]
tistory_url: https://yoon-ssi.tistory.com/49
render_with_liquid: false
---

Stack과 Queue는 제일 기본적인 자료구조다. 둘 다 데이터를 담아 두는 건 같은데, 넣고 빼는 순서가 정반대라 쓰이는 곳도 다르다.

---

### 1. Stack (스택)

#### 개념

Stack은 LIFO(Last In, First Out), 즉 나중에 들어온 게 먼저 나가는 구조다. 접시를 쌓아 올리고 맨 위부터 꺼내는 걸 떠올리면 된다. 브라우저의 뒤로 가기도 스택이다.

#### 주요 연산

- push(E item): 맨 위에 데이터를 넣는다.
- pop(): 맨 위 데이터를 꺼내서 돌려준다. 비어 있으면 EmptyStackException이 난다.
- peek(): 맨 위 데이터를 꺼내지 않고 보기만 한다.
- isEmpty(): 비어 있으면 true를 돌려준다.

#### Java에서는

java.util.Stack 클래스를 쓴다. Vector를 상속받아 만들어져 있고, push, pop 같은 기본 연산을 제공한다.

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

### 2. Queue (큐)

#### 개념

Queue는 FIFO(First In, First Out), 먼저 들어온 게 먼저 나가는 구조다. 은행 대기 줄이나 프린터 대기열을 생각하면 된다.

#### 주요 연산

- offer(E item): 맨 뒤에 데이터를 넣는다. 성공하면 true, 큐가 꽉 차 있으면 false를 돌려준다.
- poll(): 맨 앞 데이터를 꺼내서 돌려준다. 비어 있으면 null을 돌려준다.
- peek(): 맨 앞 데이터를 꺼내지 않고 보기만 한다. 비어 있으면 null을 돌려준다.
- isEmpty(): 비어 있으면 true를 돌려준다.

#### Java에서는

java.util.Queue 인터페이스로 쓰고, 구현체로는 보통 LinkedList나 ArrayDeque를 쓴다. 우선순위대로 꺼내는 PriorityQueue 같은 특수한 큐도 있다.

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

### 3. 비교

| 구분 | Stack | Queue |
| --- | --- | --- |
| 꺼내는 순서 | LIFO, 나중에 넣은 것부터 | FIFO, 먼저 넣은 것부터 |
| 주로 쓰는 곳 | 재귀 알고리즘, 뒤로 가기, 실행 취소 | 작업 대기열, 메시지 처리, BFS(너비 우선 탐색) |
