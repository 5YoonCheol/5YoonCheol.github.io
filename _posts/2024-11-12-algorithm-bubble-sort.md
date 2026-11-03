---
title: "[알고리즘] 버블 정렬 (Bubble Sort)"
date: 2024-11-12 02:00:00 +0900
categories: [Algorithm, Sort]
tags: ["버블-정렬", "알고리즘"]
tistory_url: https://yoon-ssi.tistory.com/113
render_with_liquid: false
---

버블 정렬은 인접한 두 요소를 비교하여 크기가 맞지 않으면 서로 교환하는 방식으로 동작한다.

이렇게 하면 큰 값이 배열의 끝으로 "거품"처럼 이동하는 모습이라 해서 버블 정렬이라 부른다.

---

### 동작 과정

1. 배열의 첫 번째 요소부터 인접한 두 요소를 비교하여, 만약 앞 요소가 뒤 요소보다 크면 교환합니다.
2. 배열의 끝까지 반복하여 가장 큰 값이 맨 뒤로 이동하게 만듭니다.
3. 이런 과정을 배열의 크기만큼 반복하면서 정렬을 완성합니다.

---

### 구현 코드

```java
public static void bubbleSort(int[] arr){
	int n = arr.length;
    for (int i = 0; i < n-1; i++){
    	for(int j = 0; j < n-i-1; j++){
        	if(arr[j] > arr[j+1]){
            	//인접 요소 교환
                int temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
        }
    }
}
```
