---
title: "[Java] StringBuilder란?"
date: 2024-09-13 11:11:31 +0900
categories: [Backend, Java]
tags: ["java", "stringbuilder"]
tistory_url: https://yoon-ssi.tistory.com/52
render_with_liquid: false
---

### StringBuilder는 무엇일까?

StringBuilder는 Java에서 문자열을 조작할 때 사용되는 클래스다.

이 클래스는 java.lang 패키지에 포함되어 있으며, 문자열의 길이나 내용을 변경할 수 있도록 설계되었다.

일반적인 String 클래스와 달리, StringBuilder는 가변적(mutable)이다.

즉, 문자열을 생성한 후에도 그 내용을 변경할 수 있다.

StringBuilder를 사용하면 여러 번의 문자열 변경 작업이 필요한 경우, 성능이 크게 향상된다.

String 클래스는 불변 객체(immutable)여서, 문자열이 변경될 때마다 새로운 객체가 생성된다.

반면, StringBuilder는 내부 버퍼를 사용하여 변경 작업을 수행하므로, 새로운 객체를 생성하지 않고도 문자열을 효율적으로 변경할 수 있다.

---

### StringBuilder 사용예시

StringBuilder는 주로 문자열을 추가하거나, 삭제하거나, 특정 위치에 삽입할 때 사용된다.

주요 메서드로는 append(), insert(), delete(), replace(), reverse() 등이 있다.

예를 들어, append() 메서드는 기존 문자열의 끝에 새로운 문자열을 추가할 때 사용되며, insert() 메서드는 특정 위치에 문자열을 삽입하는 데 사용된다.

```java
StringBuilder sb = new StringBuilder("Hello");
sb.append(" World!"); // "Hello World!"가 됨
sb.insert(6, "Beautiful "); // "Hello Beautiful World!"가 됨
sb.delete(6, 16); // "Hello World!"로 돌아감
```

---

### 결론

StringBuilder를 사용하면 String 클래스를 사용할 때 보다 문자열을 더욱 효율적으로 다룰 수 있다.
