---
title: "시간 복잡도란?"
date: 2024-10-09 09:09:51 +0900
categories: [Algorithm, Theory]
tags: ["시간복잡도"]
tistory_url: https://yoon-ssi.tistory.com/78
render_with_liquid: false
---

시간 복잡도(Time Complexity)는 알고리즘이 실행되는 데 걸리는 시간의 증가율을 나타내는 척도이다.

시간 복잡도를 분석함으로써 알고리즘이 입력 크기에 따라 얼마나 빠르게 실행되는지 평가할 수 있다.

시간 복잡도는 보통 빅 오 표기법(Big-O Notation)으로 표현되며, 입력 크기 n이 증가할 때 알고리즘의 실행 시간이 어떻게 증가하는지를 나타낸다.

오늘 포스팅에서는 일반적인 시간 복잡도 유형과 그 의미에 대해 알아보자.

---

### **O(1)** - 상수 시간(Constant Time)

- 알고리즘이 입력 크기에 관계없이 일정한 시간 내에 실행된다.
- 예: 배열의 첫 번째 원소에 접근하기

```java
public class ConstantTime {
    public static int getFirstElement(int[] arr) {
        return arr[0];
    }
}
```

### **O(log n)** - 로그 시간(Logarithmic Time)

- 입력 크기가 커질수록 실행 시간이 로그 함수처럼 느리게 증가한다.
- 주로 이진 탐색(Binary Search)과 같은 알고리즘이 해당된다.

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

### **O(n)** - 선형 시간(Linear Time)

- 입력 크기 n에 비례하여 실행 시간이 선형적으로 증가한다.
- 배열의 모든 요소를 하나씩 살펴보는 알고리즘이 대표적이다.

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

### **O(n log n)** - 로그 선형 시간(Log-Linear Time)

- 합병 정렬(Merge Sort)과 퀵 정렬(Quick Sort)과 같은 효율적인 정렬 알고리즘이 이 시간 복잡도를 가진다.
- 입력 크기가 증가함에 따라 n log n에 비례하여 실행 시간이 증가한다.
- 예시 : 합병 정렬

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

### **O(n²)** - 이차 시간(Quadratic Time)

- 이중 반복문을 사용하는 알고리즘이 이차 시간 복잡도를 가진다.
- 삽입 정렬(Insertion Sort), 선택 정렬(Selection Sort) 등의 정렬 알고리즘이 여기에 해당된다.
- 예시 : 버블 정렬

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

### **O(2ⁿ)** - 지수 시간(Exponential Time)

- 피보나치 수열을 재귀적으로 계산하는 알고리즘처럼 입력이 증가할수록 실행 시간이 매우 빠르게 증가한다.
- 예시 : 재귀 피보나치

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

### **O(n!)** - 팩토리얼 시간(Factorial Time)

- 매우 비효율적인 알고리즘으로, 순열이나 조합을 생성할 때 발생한다.
- 입력 크기가 작아도 실행 시간이 빠르게 증가하여 실용적이지 않다.
