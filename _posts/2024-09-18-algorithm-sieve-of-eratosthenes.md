---
title: "[알고리즘] 소수 구하기 (에라토스테네스 체)"
date: 2024-09-18 10:10:33 +0900
categories: [Algorithm, Problem]
tags: ["java", "소수-구하기", "알고리즘", "에라토스테네스-체"]
tistory_url: https://yoon-ssi.tistory.com/57
render_with_liquid: false
---

오늘 포스팅에서는 '에라토스테네스 체' 를 통해 2이상의 자연수 n까지의 소수를 구하는 방법에 대해 알아보자.

에라토스테네스 체는

소수를 구하고자 하는 범위의 모든 자연수를 나열하고 앞에서부터 배수를 확인하여 없애는 방식이다.

걸러내는 방식이니 체라고 하는 듯 하다.

Java코드를 통해 구현해보자.

---

```java
public static int example(int n){
    int primeNum = 0;
    int[] ch = new int[n+1];

    for(int i = 2; i <= n; i++){ //2부터 n까지 반복
        if(ch[i] == 0){ //0인 경우 소수
            primeNum++; // primeNum 증가
            for(int j = i; j <= n; j=j+i){ //i부터 i의 배수는 걸러낸다.
                ch[j] = 1;
            }
        }
    }

    return primeNum;
}
```

위 코드의 ch는 미리 크기를 할당해주었기 때문에 기본적으로 모든 index에 0이 들어있으므로

배수는 1로 변경하여 걸러주었다.
