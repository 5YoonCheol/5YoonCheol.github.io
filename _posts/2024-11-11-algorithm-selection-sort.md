---
title: "[알고리즘] 선택 정렬 (Selection Sort)"
date: 2024-11-11 10:10:01 +0900
categories: [Algorithm, Sort]
tags: ["선택-정렬", "알고리즘"]
tistory_url: https://yoon-ssi.tistory.com/112
render_with_liquid: false
---

선택 정렬은 배열에서 가장 작은 요소를 선택하여 맨 앞의 요소와 교환하는 과정을 반복하는 방식이다.

전체 배열에서 최소값을 찾아 앞쪽부터 하나씩 정렬해 나가는 방식이라 간단하다.

정렬할 데이터가 많을 경우에는 비효율적이다.

---

### 동작 과정

1. 배열에서 최소값을 찾아 첫 번째 요소와 교환한다.
2. 다음 단계에서는 두 번째 요소부터 끝까지의 최소값을 찾아 두 번째 요소와 교환한다.
3. 이러한 과정을 반복하여 배열이 모두 정렬될 때까지 진행한다.

---

### 구현코드

```java
public static void selectionSort(int[] arr) {
    int n = arr.length;
    for (int i = 0; i < n - 1; i++) {
        int minIdx = i;
        for (int j = i + 1; j < n; j++) {
            if (arr[j] < arr[minIdx]) {
                minIdx = j;
            }
        }
        // 최소값을 찾으면 현재 위치와 교환
        int temp = arr[minIdx];
        arr[minIdx] = arr[i];
        arr[i] = temp;
    }
}
```
