---
title: "[알고리즘] 삽입 정렬 (Insertion Sort)"
date: 2024-11-13 02:00:00 +0900
categories: [Algorithm, Sort]
tags: ["선택-정렬", "알고리즘"]
tistory_url: https://yoon-ssi.tistory.com/114
render_with_liquid: false
---

삽입 정렬은 현재 정렬할 요소를 그 앞의 정렬된 부분과 비교하여 적절한 위치에 삽입하는 방식이다.

정렬된 부분이 점차 커지며, 새로운 요소를 앞에서부터 차례대로 삽입하여 정렬을 완성한다.

일반적으로 데이터가 거의 정렬되어 있을 때 효율적인 방식이다.

---

### 동작 과정

1. 두 번째 요소부터 시작하여 앞의 요소와 비교해 적절한 위치에 삽입한다.
2. 이를 반복하여 정렬된 배열의 범위를 한 단계씩 늘려가면서 진행한다.

---

### 구현 코드

```java
public static void insertionSort(int[] arr){
	int n = arr.length;
    for(int i = 1; i < n; i++){
    	int temp = arr[i];
        int j;
        for(j = i-1; j >= 0; j--){
            if(arr[j] > temp){
                arr[j+1] = arr[j];
            }else{
            	break;
            }
        }
        arr[j+1] = temp;
    }
}
```
