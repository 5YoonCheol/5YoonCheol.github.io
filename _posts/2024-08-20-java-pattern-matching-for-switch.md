---
title: "[Java] Pattern Matching for switch"
date: 2024-08-20 02:00:00 +0900
categories: [Backend, Java]
tags: ["pattern-matching", "switch", "자바", "패턴매칭"]
tistory_url: https://yoon-ssi.tistory.com/26
render_with_liquid: false
---

### Java Pattern Matching (패턴 매칭)이란?

switch문에서 쓰는 패턴 매칭은 Java 16에서 preview로 들어왔고, Java 17에서 정식 기능이 됐다.

이걸 쓰면 switch문이 꽤 읽기 좋아진다.

---

### 주요 특징

- 타입 패턴: switch문 안에서 타입 검사와 캐스팅을 한 번에 할 수 있다.
- null 처리: switch문에서 null을 직접 처리할 수 있다.
- 가드 조건: case에 조건을 더 붙일 수 있다.
- 화살표 구문: `->`로 switch 표현식을 짧게 쓸 수 있다.

---

### 예시 코드

```java
public static String getStringValue(Object obj) {
    return switch (obj) {
        case Integer i -> String.format("int %d", i);
        case Long l -> String.format("long %d", l);
        case Double d -> String.format("double %f", d);
        case String s -> String.format("String %s", s);
        case null -> "null";
        default -> obj.toString();
    };
}
```

코드를 보면

- case마다 타입 패턴으로 객체 타입을 검사하면서 동시에 그 타입 변수로 캐스팅한다.
- null case를 직접 처리한다.
- `->` 화살표 구문으로 짧게 썼다.

조건을 더 붙이는 가드 조건 예시도 보자.

```java
public static String categorizeNumber(Integer number) {
    return switch (number) {
        case null -> "Unknown";
        case Integer i when i < 0 -> "Negative";
        case Integer i when i == 0 -> "Zero";
        case Integer i when i > 0 && i <= 100 -> "Small Positive";
        case Integer i when i > 100 -> "Large Positive";
        default -> "Unexpected";
    };
}
```

`when` 키워드로 조건을 추가했다.

타입에 따라 분기하는 로직을 더 안전하고 짧게 쓸 수 있게 된 셈이다.

---

### 정리

기존 switch문은 Object 타입에 따라 분기할 수 없고, null이 들어오면 NullPointerException이 나는 등의 단점 때문에 잘 안 쓰게 됐다.

그런데 Pattern Matching으로 switch문이 개선되면서 전보다 쓸 데가 많아졌다고 생각하고, 덕분에 switch문을 쓰는 개발자들도 늘어날 것 같다.
