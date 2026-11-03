---
title: "[알고리즘] 파라메트릭 서치(Parametric Search) 알고리즘"
date: 2024-11-27 10:00:19 +0900
categories: [Algorithm, Search]
tags: ["parametric-search"]
tistory_url: https://yoon-ssi.tistory.com/128
render_with_liquid: false
---

Parametric Search(파라메트릭 서치)는 이분 검색(Binary Search)을 응용해서 최적화 문제를 푸는 기법이다. 조건을 만족하는 값의 범위를 찾거나, 최댓값·최솟값을 구할 때 쓴다.

#### 기본 아이디어

1. 최적화 문제를 결정 문제로 바꾼다
   - "최댓값을 구하라"를 "이 값이 가능한가?"라는 결정 문제(Decision Problem)로 바꿔서 생각한다.
2. 이분 검색으로 범위를 좁힌다
   - 가능한 값의 범위를 반씩 줄여가면서 최적의 값을 찾는다.
3. 조건 함수를 만든다
   - 어떤 값이 조건을 만족하는지 판단하는 함수(결정 함수)가 있어야 한다.

---

### 어디에 쓰나

1. 최적의 분배
   - 예: 작업을 최소 시간 안에 나누는 문제(블루레이 디스크 분할 문제 등).
2. 최대/최소 경로
   - 그래프에서 조건을 만족하는 최소 또는 최대 경로 찾기.
3. 예산 분배
   - 예: 정해진 금액 안에서 최대 가치를 얻는 문제.

---

### 예제: 블루레이 디스크 분할 문제

#### 문제

- 강의 여러 개의 길이가 주어지고, 이걸 블루레이 M개에 나눠 담으려고 한다.
- 강의는 순서대로 담아야 하고, 블루레이 용량은 최소로 해야 한다.

#### 접근

1. 결정 문제로 바꾸기
   - 용량이 mid일 때 블루레이 M개로 나눠 담을 수 있는지 확인한다.
2. 이분 검색으로 최적 용량 찾기
   - 용량의 하한: 가장 긴 강의 길이
   - 용량의 상한: 모든 강의 길이의 합

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

1. canDivide 함수
   - 주어진 용량으로 강의를 블루레이 M개에 나눠 담을 수 있는지 확인한다.
   - 용량을 넘으면 새 블루레이를 시작하고, 블루레이 개수가 M을 넘으면 false를 반환한다.
2. findMinimumCapacity 함수
   - 가능한 최소 용량을 이분 검색으로 찾는다.
   - 조건을 만족하면 용량을 줄여보고, 만족하지 못하면 늘린다.
3. main 함수
   - 강의 길이와 블루레이 개수를 넣고 최적 용량을 계산한다.

---

### 시간 복잡도

- 결정 함수(canDivide): O(n) (n은 강의 개수)
- 이분 검색: O(log(sum)) (sum은 강의 길이의 합)
- 전체: O(n⋅log(sum))

---

핵심은 최적화 문제를 "이 값이면 되나?"라는 결정 문제로 바꾼 다음 이분 검색으로 답을 찾는 거다. 블루레이 문제 말고도 예산 분배나 최대/최소 경로 같은 문제에 그대로 응용할 수 있다.
