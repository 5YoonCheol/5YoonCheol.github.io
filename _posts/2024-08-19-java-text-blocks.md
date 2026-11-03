---
title: "[Java] Text Blocks(텍스트 블록)?"
date: 2024-08-19 02:00:00 +0900
categories: [Backend, Java]
tags: ["java15", "text-blocks", "자바", "텍스트-블록"]
description: Java 15에 추가된 Text Blocks(텍스트 블록) 문법과 들여쓰기 처리, 이스케이프 감소 같은 특징을 예시와 함께 정리한다.
tistory_url: https://yoon-ssi.tistory.com/25
render_with_liquid: false
---

### Text Block (텍스트 블록)?

Java 15에서 정식으로 들어온 기능으로, 여러 줄짜리 문자열을 훨씬 쉽고 읽기 좋게 쓸 수 있게 해준다.

---

### 주요 특징

- 구문
  - 큰따옴표 세 개(`"""`)로 시작하고 끝난다.
  - 시작하는 `"""` 다음에는 반드시 줄을 바꿔야 한다.
- 들여쓰기 처리
  - 컴파일러가 불필요한 들여쓰기를 알아서 지워준다.
  - 문자열의 실제 내용만 남는다.
- 이스케이프 문자 감소
  - 예전 문자열에서 필요했던 `\n`, `\"` 같은 이스케이프 문자를 거의 안 써도 된다.
- 포맷팅
  - `String.format()`과 같이 쓸 수 있다.

---

### 예시 코드

```java
String json = """
        {
            "name": "John Doe",
            "age": 30,
            "city": "New York"
        }
        """;

System.out.println(json);
```

JSON 형식 문자열을 보기 좋게 써서 출력하는 예시다.

---

### 정리

줄바꿈과 들여쓰기가 그대로 유지돼서 HTML, XML, SQL 쿼리처럼 여러 줄짜리 문자열을 다룰 때 특히 편하다. 문자열을 이어 붙이다가 생기는 실수도 줄어든다.
