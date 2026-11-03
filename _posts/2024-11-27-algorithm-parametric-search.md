---
title: "[알고리즘] 파라메트릭 서치(Parametric Search) 알고리즘"
date: 2024-11-27 10:00:19 +0900
categories: ["Algorithm"]
tags: ["parametric-search"]
tistory_url: https://yoon-ssi.tistory.com/128
render_with_liquid: false
---

**Parametric Search(파라메트릭 서치)**는 최적화 문제를 해결하는 기법으로, 이분 검색(Binary Search)을 확장하여 사용한다. 일반적으로 특정 조건을 만족하는 값의 범위를 찾거나, 최대 또는 최소 값을 구하는 데 사용된다.

#### 주요 개념

1. **최적화 문제를 결정 문제로 변환**
   - 예: "최대값을 구하라" → "특정 값이 가능한가?"라는 **결정 문제(Decision Problem)**로 변환.
2. **이분 검색을 활용**
   - 가능한 값의 범위를 이분 검색으로 좁혀가며, 최적의 값을 탐색.
3. **조건 함수 작성**
   - 특정 조건을 만족하는지 여부를 판단하는 함수(결정 함수)가 필요.

---

### 사용 사례

1. **최적의 분배**
   - 예: 작업을 최소 시간 안에 나누는 문제(예: 블루레이 디스크 분할 문제).
2. **최대/최소 경로**
   - 그래프에서 특정 조건을 만족하는 최소 또는 최대 경로 찾기.
3. **예산 분배 문제**
   - 예: 특정 금액 내에서 최대 가치를 얻는 문제.

---

### 예제: 블루레이 디스크 분할 문제

#### 문제 설명

- 여러 강의의 길이가 주어졌을 때, 이를 **M개의 블루레이**에 나누어 담으려 한다.
- 각 블루레이에는 순서대로 강의를 담아야 하며, 블루레이의 용량을 최소화해야 한다.

#### 접근 방식

1. **결정 문제로 변환**
   - 특정 용량 mid가 주어졌을 때, M개의 블루레이로 나눌 수 있는지 확인.
2. **이분 검색으로 최적 용량 탐색**
   - 용량의 하한: 가장 긴 강의 길이.
   - 용량의 상한: 모든 강의 길이의 합.

---

### Java 코드: 블루레이 디스크 분할

```
public class ParametricSearch {

    // 결정 함수: 주어진 용량으로 M개의 블루레이에 강의를 담을 수 있는지 확인
    public static boolean canDivide(int[] lectures, int m, int capacity) {
        int count = 1; // 블루레이 개수
        int sum = 0; // 현재 블루레이에 담긴 강의 길이 합

        for (int lecture : lectures) {
            if (sum + lecture > capacity) {
                count++; // 새로운 블루레이 시작
                sum = lecture;

                if (count > m) {
                    return false; // 블루레이 개수 초과
                }
            } else {
                sum += lecture;
            }
        }

        return true;
    }

    // 파라메트릭 서치: 최소 블루레이 용량을 찾는 함수
    public static int findMinimumCapacity(int[] lectures, int m) {
        int left = 0; // 최소 용량 (가장 긴 강의)
        int right = 0; // 최대 용량 (모든 강의 길이 합)

        for (int lecture : lectures) {
            left = Math.max(left, lecture); // 가장 긴 강의 길이
            right += lecture; // 전체 강의 길이 합
        }

        int result = right; // 최소 용량

        while (left <= right) {
            int mid = left + (right - left) / 2;

            if (canDivide(lectures, m, mid)) {
                result = mid; // 가능한 경우, 용량을 줄여본다
                right = mid - 1;
            } else {
                left = mid + 1; // 불가능한 경우, 용량을 늘린다
            }
        }

        return result;
    }

    public static void main(String[] args) {
        int[] lectures = {10, 20, 30, 40, 50}; // 강의 길이
        int m = 3; // 블루레이 개수

        int minCapacity = findMinimumCapacity(lectures, m);
        System.out.println("Minimum capacity required: " + minCapacity);
    }
}
```

### 실행 결과

입력:

- 강의 길이: `{10, 20, 30, 40, 50}`
- 블루레이 개수: `3`

```swift
Minimum capacity required: 60
```

---

### 코드 설명

1. **canDivide 함수**
   - 특정 용량으로 강의를 M개의 블루레이에 나눌 수 있는지 확인한다.
   - 용량을 초과하면 새로운 블루레이를 시작하고, 블루레이 개수가 초과하면 false를 반환.
2. **findMinimumCapacity 함수**
   - 가능한 최소 용량을 이분 검색으로 찾는다.
   - 조건을 만족하면 용량을 줄여보고, 만족하지 않으면 용량을 늘린다.
3. **main 함수**
   - 강의와 블루레이 개수를 입력받아 최적의 용량을 계산한다.

---

### 시간 복잡도

- **결정 함수(canDivide)**: O(n) (n은 강의 개수).
- **이분 검색**: O(log⁡(sum)) (sum은 강의 길이의 합).
- **전체 시간 복잡도**: O(n⋅log⁡(sum)).

---

### 결론

파라메트릭 서치는 **최적화 문제를 결정 문제로 변환하여 이분 검색으로 해결**하는 접근 방식이다.

블루레이 분할 문제 외에도, 예산 분배 문제나 최대/최소 경로 탐색 등 다양한 문제에 적용할 수 있다.
