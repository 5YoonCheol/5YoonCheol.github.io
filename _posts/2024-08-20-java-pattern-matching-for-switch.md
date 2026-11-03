---
title: "[Java] Pattern Matching for switch"
date: 2024-08-20 10:10:59 +0900
categories: ["Java"]
tags: ["pattern-matching", "switch", "자바", "패턴매칭"]
tistory_url: https://yoon-ssi.tistory.com/26
render_with_liquid: false
---

### **Java Pattern Matching (패턴 매칭) 이란?**

이 기능은 Java16에서 preview로 도입되었고, Java17에서 정식 기능으로 포함되었다.

패턴 매칭을 통한 switch문의 개선은 코드의 가독성을 향상하는데 도움을 줄 수 있다.

---

### **주요 특징**

- **타입 패턴**:
  - switch 문에서 직접 타입 검사와 캐스팅을 할 수 있다.
- **null 처리**:
  - switch 문에서 null 값을 직접 처리할 수 있다.
- **가드 조건**:
  - case 문에 추가적인 조건을 붙일 수 있다.
- **화살표 구문**:
  - -&gt;를 사용하여 간결한 switch 표현식을 작성할 수 있다.

---

### **예시 코드**

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

위의 코드를 살펴보자.

- 각 case에서 타입 패턴을 사용하여 객체의 타입을 검사하고 동시에 해당 타입의 변수로 캐스팅한다.
- null case를 직접 처리할 수 있다.
- -&gt; 화살표 구문을 사용하여 간결하게 표현했다.

추가 조건을 부여하는 가드 조건 예시도 살펴보자.

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

이 예시에서는 when 키워드를 사용하여 추가적인 조건을 지정했다.

패턴 매칭을 사용한 switch 문은 코드의 가독성을 높이고, 타입 관련 로직을 더 안전하고 간결하게 작성할 수 있게 해 준다.

---

### **정리**

기존 switch문은 Object 타입에 따른 분기처리가 불가능하다는 점,

null이 들어갈 경우 NullPointerException 오류가 발생한다는 점 등의 단점 때문에

사용하는 경우가 많지 않았다.

그러나 Pattern Matching을 통한 switch문의 개선으로 이전보다 활용도가 늘어났다고 생각하고 덕분에  
switch문을 활용하는 개발자들도 증가할 것 같다.
