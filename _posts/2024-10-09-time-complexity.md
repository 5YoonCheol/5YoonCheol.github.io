---
title: "시간 복잡도란?"
date: 2024-10-09 09:09:51 +0900
categories: [Algorithm, Theory]
tags: ["시간복잡도"]
tistory_url: https://yoon-ssi.tistory.com/78
render_with_liquid: false
---

시간 복잡도(Time Complexity)는 입력이 커질 때 알고리즘 실행 시간이 얼마나 빨리 늘어나는지를 나타내는 척도다.

이걸 따져보면 입력 크기에 따라 알고리즘이 얼마나 빠르게 도는지 가늠할 수 있다.

보통 빅 오 표기법(Big-O Notation)으로 쓰고, 입력 크기 n이 커질 때 실행 시간이 어떻게 늘어나는지를 표현한다.

오늘은 자주 보는 시간 복잡도 유형을 하나씩 알아보자.

---

### O(1) - 상수 시간(Constant Time)

- 입력 크기와 상관없이 항상 같은 시간이 걸린다.
- 예: 배열의 첫 번째 원소에 접근하기

```java
public class ConstantTime {
    public static int getFirstElement(int[] arr) {
        return arr[0];
    }
}
```

### O(log n) - 로그 시간(Logarithmic Time)

- 입력이 커져도 실행 시간은 로그 함수처럼 천천히 늘어난다.
- 이진 탐색(Binary Search)이 대표적이다.

```java
public class LogarithmicTime {
    public static int binarySearch(int[] arr, int target) {
        int left = 0, right = arr.length - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (arr[mid] == target) {
                return mid;
            } else if (arr[mid] < target) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
        return -1;
    }
}
```

### O(n) - 선형 시간(Linear Time)

- 입력 크기 n에 비례해서 실행 시간이 늘어난다.
- 배열 요소를 하나씩 전부 훑는 알고리즘이 대표적이다.

```java
public class LinearTime {
    public static int linearSearch(int[] arr, int target) {
        for (int i = 0; i < arr.length; i++) {
            if (arr[i] == target) {
                return i;
            }
        }
        return -1;
    }
}
```

### O(n log n) - 로그 선형 시간(Log-Linear Time)

- 합병 정렬(Merge Sort), 퀵 정렬(Quick Sort) 같은 빠른 정렬 알고리즘이 여기에 해당한다.
- 입력이 커지면 n log n에 비례해서 실행 시간이 늘어난다.
- 예시: 합병 정렬

```java
import java.util.Arrays;

public class LogLinearTime {
    public static int[] mergeSort(int[] arr) {
        if (arr.length <= 1) {
            return arr;
        }
        int mid = arr.length / 2;
        int[] left = mergeSort(Arrays.copyOfRange(arr, 0, mid));
        int[] right = mergeSort(Arrays.copyOfRange(arr, mid, arr.length));
        return merge(left, right);
    }

    private static int[] merge(int[] left, int[] right) {
        int[] result = new int[left.length + right.length];
        int i = 0, j = 0, k = 0;

        while (i < left.length && j < right.length) {
            if (left[i] < right[j]) {
                result[k++] = left[i++];
            } else {
                result[k++] = right[j++];
            }
        }
        while (i < left.length) {
            result[k++] = left[i++];
        }
        while (j < right.length) {
            result[k++] = right[j++];
        }
        return result;
    }
}
```

### O(n²) - 이차 시간(Quadratic Time)

- 반복문을 이중으로 돌리는 알고리즘이 보통 이렇다.
- 삽입 정렬(Insertion Sort), 선택 정렬(Selection Sort) 같은 정렬이 여기에 해당한다.
- 예시: 버블 정렬

```java
public class QuadraticTime {
    public static void bubbleSort(int[] arr) {
        int n = arr.length;
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                if (arr[j] > arr[j + 1]) {
                    int temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = temp;
                }
            }
        }
    }
}
```

### O(2ⁿ) - 지수 시간(Exponential Time)

- 피보나치 수열을 재귀로 계산하는 것처럼, 입력이 조금만 늘어도 실행 시간이 엄청 빠르게 늘어난다.
- 예시: 재귀 피보나치

```java
public class ExponentialTime {
    public static int fibonacci(int n) {
        if (n <= 1) {
            return n;
        }
        return fibonacci(n - 1) + fibonacci(n - 2);
    }
}
```

### O(n!) - 팩토리얼 시간(Factorial Time)

- 순열이나 조합을 전부 만들어볼 때 나오는, 아주 비효율적인 경우다.
- 입력이 작아도 실행 시간이 금방 폭발해서 실제로는 쓰기 어렵다.
