---
title: "[알고리즘] 이분 검색 알고리즘 (Binary Search)"
date: 2024-11-26 10:00:19 +0900
categories: [Algorithm, Search]
tags: ["이분-검색-알고리즘"]
tistory_url: https://yoon-ssi.tistory.com/127
render_with_liquid: false
---

이분 검색(Binary Search)은 정렬된 배열에서 원하는 값을 빠르게 찾는 알고리즘이다.

탐색 범위를 계속 반으로 줄여 나가기 때문에 시간 복잡도가 O(log n)이다.

---

### 동작 원리

1. 배열이 정렬돼 있어야 한다
   - 정렬되지 않은 데이터에서는 쓸 수 없다.
2. 가운데 값을 고른다
   - 탐색 범위의 중간값을 고른다.
3. 값을 비교한다
   - 중간값과 찾는 값을 비교한다.
     - 같으면 찾은 거니까 인덱스를 반환한다.
     - 중간값이 더 작으면 오른쪽 절반에서 계속 찾는다.
     - 중간값이 더 크면 왼쪽 절반에서 계속 찾는다.
4. 반복하거나 재귀로 호출한다
   - 위 과정을 되풀이하면서 범위를 좁힌다.
5. 끝나는 조건
   - 값을 찾으면 인덱스를 반환하고, 범위가 비면 못 찾았다는 값을 반환한다.

---

### Java 코드: 반복문으로 구현

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
찾는 값: `13`

```
Target 13 found at index 5
```

---

### Java 코드: 재귀로 구현

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
찾는 값: `19`

```shell
Target 19 found at index 7
```

---

### 반복 vs 재귀

| 비교 항목 | 반복적 접근 | 재귀적 접근 |
| --- | --- | --- |
| 구현 난이도 | 간단하고 직관적 | 더 간결하나, 스택 오버플로우 위험 가능성 존재 |
| 성능 | 메모리 효율적 | 재귀 호출로 인한 약간의 메모리 사용 증가 |
| 사용 사례 | 배열 크기가 큰 경우 적합 | 간단한 논리와 코드 가독성이 중요한 경우 적합 |

---

정렬된 데이터에서 값을 찾는 거라면 이분 검색이 기본이다. 반복과 재귀 중에는 상황에 맞는 쪽을 고르면 되고, 트리 같은 더 복잡한 탐색 구조도 결국 이 아이디어에서 출발한다.
