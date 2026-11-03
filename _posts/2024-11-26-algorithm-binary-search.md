---
title: "[알고리즘] 이분 검색 알고리즘 (Binary Search)"
date: 2024-11-26 10:00:19 +0900
categories: ["Algorithm"]
tags: ["이분-검색-알고리즘"]
tistory_url: https://yoon-ssi.tistory.com/127
render_with_liquid: false
---

**이분 검색(Binary Search)**은 정렬된 배열에서 특정 값을 효율적으로 찾기 위한 알고리즘이다.

배열을 반복적으로 반으로 나누어 원하는 값을 탐색하므로 시간 복잡도가 O(log ⁡n)이다.

---

### 이분 검색 알고리즘의 동작 원리

1. **정렬된 배열을 전제 조건으로 사용**
   - 이분 검색은 데이터가 정렬된 상태여야 동작한다.
2. **중간값 선택**
   - 탐색 범위의 중간값을 선택한다.
3. **값 비교**
   - 중간값과 목표 값을 비교한다.
     - **같다면** 값을 찾은 것이므로 인덱스를 반환한다.
     - **작다면** 오른쪽 절반에서 탐색을 계속한다.
     - **크다면** 왼쪽 절반에서 탐색을 계속한다.
4. **반복 또는 재귀 호출**
   - 위 과정을 반복하거나 재귀적으로 호출하며 탐색 범위를 줄여 나간다.
5. **종료 조건**
   - 값이 발견되면 해당 인덱스를 반환하고, 탐색 범위가 비게 되면 검색 실패를 의미하는 값을 반환한다.

---

### 이분 검색 Java 코드: 반복적 접근

아래는 반복적인 방법으로 구현한 이분 검색 알고리즘이다.

```
public class BinarySearchIterative {

    // 이분 검색 메서드
    public static int binarySearch(int[] array, int target) {
        int left = 0; // 탐색 범위의 시작 인덱스
        int right = array.length - 1; // 탐색 범위의 끝 인덱스

        while (left <= right) {
            int mid = left + (right - left) / 2; // 중간값 계산 (오버플로우 방지)

            if (array[mid] == target) {
                return mid; // 값이 일치하면 인덱스 반환
            } else if (array[mid] < target) {
                left = mid + 1; // 오른쪽 절반으로 이동
            } else {
                right = mid - 1; // 왼쪽 절반으로 이동
            }
        }

        return -1; // 값을 찾지 못한 경우
    }

    public static void main(String[] args) {
        int[] sortedArray = {2, 3, 5, 7, 11, 13, 17, 19, 23}; // 정렬된 배열
        int target = 13; // 찾고자 하는 값

        int result = binarySearch(sortedArray, target);

        if (result != -1) {
            System.out.println("Target " + target + " found at index " + result);
        } else {
            System.out.println("Target " + target + " not found in the array.");
        }
    }
}
```

### 실행 결과

입력 배열: `{2, 3, 5, 7, 11, 13, 17, 19, 23}`  
찾고자 하는 값: `13`

```
Target 13 found at index 5
```

---

### 이분 검색 Java 코드: 재귀적 접근

재귀를 사용하는 방법은 다음과 같다.

```
public class BinarySearchRecursive {

    // 이분 검색 재귀 메서드
    public static int binarySearch(int[] array, int target, int left, int right) {
        if (left > right) {
            return -1; // 탐색 범위가 비어 있는 경우 값 없음
        }

        int mid = left + (right - left) / 2; // 중간값 계산

        if (array[mid] == target) {
            return mid; // 값이 일치하면 인덱스 반환
        } else if (array[mid] < target) {
            return binarySearch(array, target, mid + 1, right); // 오른쪽 절반 탐색
        } else {
            return binarySearch(array, target, left, mid - 1); // 왼쪽 절반 탐색
        }
    }

    public static void main(String[] args) {
        int[] sortedArray = {2, 3, 5, 7, 11, 13, 17, 19, 23}; // 정렬된 배열
        int target = 19; // 찾고자 하는 값

        int result = binarySearch(sortedArray, target, 0, sortedArray.length - 1);

        if (result != -1) {
            System.out.println("Target " + target + " found at index " + result);
        } else {
            System.out.println("Target " + target + " not found in the array.");
        }
    }
}
```

### 실행 결과

입력 배열: `{2, 3, 5, 7, 11, 13, 17, 19, 23}`  
찾고자 하는 값: `19`

```shell
Target 19 found at index 7
```

---

### 반복 접근 vs 재귀 접근

| **비교 항목** | **반복적 접근** | **재귀적 접근** |
| --- | --- | --- |
| **구현 난이도** | 간단하고 직관적 | 더 간결하나, 스택 오버플로우 위험 가능성 존재 |
| **성능** | 메모리 효율적 | 재귀 호출로 인한 약간의 메모리 사용 증가 |
| **사용 사례** | 배열 크기가 큰 경우 적합 | 간단한 논리와 코드 가독성이 중요한 경우 적합 |

---

### 결론

이분 검색은 정렬된 데이터를 빠르게 탐색하는 데 매우 유용하다.

재귀와 반복 중 필요한 상황에 맞는 방식을 선택하여 구현하면 된다.

더 높은 수준의 검색 알고리즘(예: 트리 구조 활용)이 필요한 경우 이분 검색이 그 기초가 된다.
