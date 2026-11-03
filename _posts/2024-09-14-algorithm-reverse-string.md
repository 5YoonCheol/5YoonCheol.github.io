---
title: "[알고리즘] 문자열 뒤집기"
date: 2024-09-14 02:00:00 +0900
categories: [Algorithm, Problem]
tags: ["java", "문자열-뒤집기"]
tistory_url: https://yoon-ssi.tistory.com/53
render_with_liquid: false
---

오늘 포스팅에서는 Java 코드를 통해 문자열을 뒤집는 방법에 대해 알아보자!

2가지 방법을 사용해서 문자열을 뒤집어보자.

---

### 1. StringBuilder 클래스 사용

StringBuilder를 사용하면 간단하게 문자열을 뒤집을 수 있다.

reverse() 메서드를 사용하는 방법이다.

```java
public String example(String str){

    StringBuilder sb = new StringBuilder(str);

    str = sb.reverse().toString();

    return str;
}
```

위의 예시와 같이 StringBuilder 클래스를 사용하면 간단하게 문자열을 뒤집을 수 있다.

하지만 전부 다 뒤집어 버리기 때문에 특정 문자만 뒤집는 등의 경우는 해결할 수 없다.

---

### 2. 짝을 맞춰 뒤집기

1번 방법의 reverse() 메서드를 직접 구현하는 방법인데, 이 방법을 사용하면 조건에 맞게 변형하여 사용할 수 있다.

```java
public String example(String str){
    char[] chars = str.toCharArray();
    int lt = 0;
    int rt = str.length()-1;

    while(lt < rt){
        char tmp = chars[lt];
        chars[lt] = chars[rt];
        chars[rt] = tmp;
        lt++;
        rt--;
    }

    return new String(chars);
}
```

toCharArray()를 통해 문자열을 배열형태로 바꿔준다.

lt, rt는 왼쪽 오른쪽!!

양 끝에서 점점 서로 다가오면서 교차되는 시점에 반복문을 멈추는 방식이다.

예를 들어

"abcde" 라는 문자열을 뒤집는다고 했을 때

0번째 인덱스인 "a"와 4번째 인덱스인 "e" 를 서로 바꿔주고 lt, rt를 각각 1씩 증가 감소 시킨다.

그러면 "ebcda"가 될 것이고

lt = 1, rt = 3이 될 것이다.

이러면 "b"와 "d"를 바꿔준다.

"edcba"가 될 것이고, lt와 rt는 둘다 2가 되기 때문에 while문이 끝나게 된다.

알파벳만 뒤집는다던지, 숫자만 뒤집는다던지 하는 경우에는 while문 안에 if()조건절을 추가해서 응용하면 되겠다.

---

### 결론

1번과 2번 두 가지 경우를 모두 알고 있어야 상황에 맞게 사용할 수 있으니 둘 다 알아두도록 하자!
