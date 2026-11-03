---
title: "[알고리즘] 배열 합치기"
date: 2024-10-08 08:08:43 +0900
categories: [Algorithm, Problem]
tags: ["배열-합치기"]
tistory_url: https://yoon-ssi.tistory.com/77
render_with_liquid: false
---

오늘 포스팅에서는 배열 합치기에 대해서 알아보자.

2 Pointers 알고리즘을 통해 구현해보려고 하는데, 이는 단순히 반복문을 통해 배열을 합치는 것 보다

시간복잡도 측면에서 이점이 있다.

바로 예제를 통해서 확인해보자.

---

오름차순으로 정렬되어 있는 배열 2개 A, B가 있을 때

2개의 배열을 합쳐서 오름차순 하여라. (A, B의 원소는 int 범위 내에 있다.)

ex) A = [1, 2, 3, 5], B = [2, 4, 5, 8, 9] 라면

최종 배열은 C = [1, 2, 3, 4, 5, 5, 8, 9] 가 되어야 한다.

```java
public ArrayList<Integer> example(int[] arr, int[] arr2){
        // 2 Pointers 알고리즘
        ArrayList<Integer> answer = new ArrayList<>();
        int p1=0, p2=0;

        while(p1<arr.length && p2<arr2.length){
            if(arr[p1] < arr2[p2]){
                answer.add(arr[p1]);
                p1++;
            }else{
                answer.add(arr2[p2]);
                p2++;
            }
        }

        //p1이 남아있을 경우
        while(p1 < arr.length){
            answer.add(arr[p1]);
            p1++;
        }

        //p2가 남아있을 경우
        while(p2  <arr2.length){
            answer.add(arr2[p2]);
            p2++;
        }

        return answer;
    }
```

위의 코드를 해석해보자.

1. while문을 돌면서 p1혹은 p2의 값이 각 배열의 길이를 초과하는 순간 멈추게 된다.

2. 이미 오름차순 되어있는 배열 2개를 받았으므로 각 배열의 Index값을 비교하여 새로 선언한 answer에 추가 시켜준다.

3. 이후 값을 추가한 배열의 index를 증가시켜서 계속해서 비교한다.

4. 첫 번째 while문을 통과한 후 원소가 남아있는 배열의 값을 마저 추가해준다.
