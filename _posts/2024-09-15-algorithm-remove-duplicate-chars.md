---
title: "[알고리즘] 중복문자 제거하기"
date: 2024-09-15 02:00:00 +0900
categories: [Algorithm, Problem]
tags: ["java", "중복-문자-제거"]
tistory_url: https://yoon-ssi.tistory.com/54
render_with_liquid: false
---

문자열에서 중복 문자를 제거하는 방법에 대해서 알아보자.

---

### Contains 활용하기

contains() 메소드를 활용하여 중복문자를 제거할 수 있다.

```java
public String example(String str){
    String answer = "";

    char[] chars = str.toCharArray();

    for(char c : chars){
        if(!answer.contains(String.valueOf(c))){
            answer += c;
        }
    }

    return answer;
}
```

우선 answer라는 문자열을 선언해주었다.

그리고 example() 메소드의 파라미터로 받아온 str를 배열형태로 변경해준 뒤 반복문을 통해

answer가 해당 문자를 포함하고 있지 않을 경우 추가해주는 형태로 구현하였다.

**참고로 contains() 메소드는 대소문자를 구별하기 때문에 대소문자 구분없이 중복 문자를 제거하고 싶다면 아래와 같은 방법을 사용해보자!**

```java
public String example(String str){
    String answer = "";

    char[] chars = str.toCharArray();

    for(char c : chars){
        c = Character.toUpperCase(c);
        if(!answer.contains(String.valueOf(c))){
            answer += c;
        }
    }

    return answer;
}
```

위 코드에서는 반복문 내부에서 문자열의 **문자를 전부 대문자로 변경**한 후에  contains() 메소드를 통해 비교하는 방식으로 대소문자의 구분을 없앴다.

toUpperCase() 말고 toLowerCase()를 사용해도 무방하다.
