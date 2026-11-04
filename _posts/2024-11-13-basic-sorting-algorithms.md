---
title: "[알고리즘] 버블·선택·삽입 정렬 비교: 같은 배열로 돌려 보기"
date: 2024-11-13 02:00:00 +0900
categories: [Algorithm, Sort]
tags: ["버블-정렬", "선택-정렬", "삽입-정렬", "알고리즘", "정렬"]
description: O(n²) 기본 정렬 세 가지(버블, 선택, 삽입)를 같은 배열로 단계별로 돌려 보며 동작과 비교 횟수, 교환 횟수, 안정성 차이를 정리한다. 삽입 정렬이 실제 라이브러리에서 쓰이는 이유도 다룬다.
tistory_url: https://yoon-ssi.tistory.com/114
tistory_urls: [https://yoon-ssi.tistory.com/112, https://yoon-ssi.tistory.com/113, https://yoon-ssi.tistory.com/114]
redirect_from:
  - /posts/algorithm-bubble-sort/
  - /posts/algorithm-selection-sort/
  - /posts/algorithm-insertion-sort/
render_with_liquid: false
---

> 2026년 11월에 버블 정렬, 선택 정렬, 삽입 정렬 세 글을 하나로 합쳐 다시 썼다. 옛 주소로 들어오면 이 글로 넘어온다.
{: .prompt-info }

세 정렬 모두 시간 복잡도가 O(n²)이라 "느린 정렬"로 한데 묶이지만, 비교와 교환을 어디서 하느냐가 달라서 실제 동작과 쓰임새가 다르다. 같은 배열 `[5, 2, 4, 1, 3]`을 세 방식으로 정렬하면서 차이를 보자.

### 1. 버블 정렬 (Bubble Sort)

인접한 두 요소를 비교해서 순서가 틀리면 바꾼다. 한 바퀴 돌 때마다 가장 큰 값이 끝으로 "거품"처럼 밀려난다.

```java
public static void bubbleSort(int[] arr) {
    int n = arr.length;
    for (int i = 0; i < n - 1; i++) {
        boolean swapped = false;
        for (int j = 0; j < n - 1 - i; j++) {   // 뒤쪽 i개는 이미 자리를 잡았다
            if (arr[j] > arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
                swapped = true;
            }
        }
        if (!swapped) break;   // 한 바퀴 동안 교환이 없으면 이미 정렬된 상태
    }
}
```

`[5, 2, 4, 1, 3]`의 1바퀴: `5>2` 교환 → `[2,5,4,1,3]`, `5>4` 교환 → `[2,4,5,1,3]`, `5>1` 교환 → `[2,4,1,5,3]`, `5>3` 교환 → `[2,4,1,3,5]`. 가장 큰 5가 끝에 갔다. 2바퀴 뒤 `[2,1,3,4,5]`, 3바퀴 뒤 `[1,2,3,4,5]`, 4바퀴째는 교환이 없어서 `swapped` 체크로 끝난다.

`swapped` 플래그가 중요하다. 이게 있으면 이미 정렬된 배열은 한 바퀴(O(n))만에 끝나고, 없으면 무조건 n² 번 비교한다.

### 2. 선택 정렬 (Selection Sort)

남은 구간에서 최솟값을 찾아 맨 앞과 바꾼다. 한 바퀴에 교환은 딱 한 번이다.

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
        if (minIdx != i) {      // 최솟값이 이미 제자리면 교환하지 않는다
            int temp = arr[minIdx];
            arr[minIdx] = arr[i];
            arr[i] = temp;
        }
    }
}
```

`[5, 2, 4, 1, 3]`의 1바퀴: 전체에서 최솟값 1(인덱스 3)을 찾아 5와 교환 → `[1,2,4,5,3]`. 2바퀴: 인덱스 1부터 최솟값 2, 제자리 → 그대로. 3바퀴: 인덱스 2부터 최솟값 3을 4와 교환 → `[1,2,3,5,4]`. 4바퀴: 4와 5 교환 → `[1,2,3,4,5]`.

비교는 입력이 어떻든 항상 n(n-1)/2 번이라 이미 정렬된 배열에도 빨라지지 않는다. 대신 교환이 최대 n-1 번이라, 교환 비용이 비싼 상황(큰 객체를 배열에서 옮길 때)에는 버블보다 낫다.

### 3. 삽입 정렬 (Insertion Sort)

앞쪽을 "정렬된 구간"으로 두고, 다음 요소를 그 구간의 알맞은 자리에 끼워 넣는다. 카드를 한 장씩 손에 정리하는 방식이다.

```java
public static void insertionSort(int[] arr) {
    int n = arr.length;
    for (int i = 1; i < n; i++) {
        int key = arr[i];
        int j = i - 1;
        while (j >= 0 && arr[j] > key) {   // key보다 큰 값을 한 칸씩 뒤로 민다
            arr[j + 1] = arr[j];
            j--;
        }
        arr[j + 1] = key;                   // 빈 자리에 key를 넣는다
    }
}
```

`[5, 2, 4, 1, 3]`: i=1, key=2 → 5를 뒤로 밀고 삽입 `[2,5,4,1,3]`. i=2, key=4 → 5만 밀고 삽입 `[2,4,5,1,3]`. i=3, key=1 → 5,4,2를 밀고 맨 앞에 `[1,2,4,5,3]`. i=4, key=3 → 5,4를 밀고 삽입 `[1,2,3,4,5]`.

거의 정렬된 배열이면 `while`이 거의 돌지 않아서 O(n)에 가깝다. 이게 삽입 정렬의 가장 큰 장점이다.

### 4. 한눈에 비교

| | 버블 | 선택 | 삽입 |
|---|---|---|---|
| 최선 | O(n) (플래그 있을 때) | O(n²) | O(n) |
| 평균 / 최악 | O(n²) | O(n²) | O(n²) |
| 비교 횟수 | 많음 | 항상 n(n-1)/2 | 입력에 따라 다름 |
| 교환(쓰기) 횟수 | 많음 | 최대 n-1 | 밀기(shift)로 처리 |
| 안정 정렬 | 예 | 아니오 | 예 |
| 추가 메모리 | O(1) | O(1) | O(1) |
| 거의 정렬된 입력 | 빠름 | 느림 | 가장 빠름 |

안정 정렬은 같은 값의 원래 순서가 유지된다는 뜻이다. 선택 정렬은 멀리 있는 최솟값과 교환하면서 같은 값의 순서가 뒤집힐 수 있다. 예를 들어 `(점수, 이름)` 목록을 점수로만 정렬할 때 같은 점수끼리 이름 순서가 흐트러지면 안 되는 상황에서는 선택 정렬을 쓰면 안 된다.

### 5. 실제로는 어디에 쓰나

세 정렬 중 실무 코드에 남아 있는 건 삽입 정렬이다. Java의 `Arrays.sort()`는 원시 타입에는 Dual-Pivot Quicksort, 객체에는 TimSort를 쓰는데, 둘 다 구간이 작아지면(대략 47개 또는 32개 이하) 삽입 정렬로 바꾼다. 작은 배열에서는 재귀 호출 비용이 없는 삽입 정렬이 O(n log n) 정렬보다 실제로 빠르기 때문이다. TimSort는 "이미 정렬된 구간(run)"을 찾아 삽입 정렬로 늘린 뒤 병합하는 구조라, 삽입 정렬의 "거의 정렬된 입력에 강하다"는 성질을 그대로 활용한다.

버블 정렬과 선택 정렬은 동작을 이해하기 위한 교재용에 가깝다. 코딩 테스트에서 직접 구현할 일이 있다면 삽입 정렬을 기본으로 두고, n이 수천을 넘으면 `Arrays.sort()`나 `Collections.sort()`를 쓰면 된다.
