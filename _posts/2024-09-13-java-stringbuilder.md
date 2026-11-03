---
title: "[Java] StringBuilder란?"
date: 2024-09-13 02:00:00 +0900
categories: [Backend, Java]
tags: ["java", "stringbuilder"]
tistory_url: https://yoon-ssi.tistory.com/52
render_with_liquid: false
---

### StringBuilder는 무엇일까?

StringBuilder는 Java에서 문자열을 다룰 때 쓰는 클래스로, java.lang 패키지에 들어 있다.

String과 가장 큰 차이는 StringBuilder가 가변적(mutable)이라는 점이다. 한 번 만든 뒤에도 문자열 길이나 내용을 바꿀 수 있다.

String은 불변 객체(immutable)라서 문자열을 바꿀 때마다 새 객체가 만들어진다. StringBuilder는 내부 버퍼에서 바로 고치기 때문에 새 객체를 만들 필요가 없다. 그래서 문자열을 여러 번 바꿔야 하는 경우라면 StringBuilder가 훨씬 빠르다.

---

### StringBuilder 사용 예시

주로 문자열을 덧붙이거나, 지우거나, 특정 위치에 끼워 넣을 때 쓴다.

자주 쓰는 메서드는 `append()`, `insert()`, `delete()`, `replace()`, `reverse()` 등이 있다. `append()`는 문자열 끝에 새 문자열을 붙이고, `insert()`는 원하는 위치에 문자열을 넣는다.

```java
StringBuilder sb = new StringBuilder("Hello");
sb.append(" World!"); // "Hello World!"가 됨
sb.insert(6, "Beautiful "); // "Hello Beautiful World!"가 됨
sb.delete(6, 16); // "Hello World!"로 돌아감
```

---

문자열을 자주 바꿔야 한다면 String 대신 StringBuilder를 쓰자.
