---
title: "[알고리즘] 피보나치 수열"
date: 2024-09-17 07:07:54 +0900
categories: ["Algorithm"]
tags: ["java", "구현", "피보나치-수열"]
tistory_url: https://yoon-ssi.tistory.com/56
render_with_liquid: false
---

피보나치 수열이란 앞의 2개 수를 더한 합이 다음 숫자가 되는 수열이다.

이를 Java 코드로 구현하는 방법에 대해 알아보자.

---

총 항수 n(3 &lt;= n)을 를 입력받고 피보나치 수열을 출력해보자.

```java
import java.util.Scanner;

public class int[] example(int n){
	Scanner sc = new Scanner(System.in);

    n = sc.nextInt(); //입력받기

	int[] fibonacci = new int[n];

    fibonacci[0] = 1; // 0번째 항과 1번째 항은 항상 1이다.
    fibonacci[1] = 1;

    //n은 3이상이므로 2번째 항부터 반복시켜주자
    for(int i=2; i < n; i++){
    	fibonacci[i] = fibonacci[i-1] + fibonacci[i-2];
    }

    return fibonacci;
}
```

다음과 같이 간단하게 해결할 수 있다.
