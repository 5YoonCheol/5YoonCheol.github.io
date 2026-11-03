---
title: "[Java] Math 클래스란?"
date: 2024-08-07 02:00:00 +0900
categories: [Backend, Java]
tags: ["class", "java", "math", "math.ceil()", "math.floor()", "math.round()", "수학", "연산", "자바"]
tistory_url: https://yoon-ssi.tistory.com/12
render_with_liquid: false
---

업무를 할 때 반올림하려고 round() 메서드를 자주 쓰는데, Math 클래스가 정확히 뭔지, 어떤 함수들이 있는지 궁금해져서 정리해보기로 했다.

Math 클래스는 Java 표준 라이브러리에 들어 있는 유틸리티 클래스다.

수학 연산에 필요한 메서드를 여러 가지 제공하고, `java.lang` 패키지에 속해 있어서 따로 import 없이 쓸 수 있다.

주요 메서드를 살펴보자.

---

### 주요 메서드

1. 기본 산술 연산
   - `abs(int a)`, `abs(double a)` 등: 절대값을 반환한다.
   - `max(int a, int b)`, `min(int a, int b)`: 두 값 중 큰 값 또는 작은 값을 반환한다.
2. 지수와 로그
   - `pow(double a, double b)`: a의 b제곱을 반환한다.
   - `sqrt(double a)`: a의 제곱근을 반환한다.
   - `exp(double a)`: 자연 상수 e의 a제곱을 반환한다.
   - `log(double a)`: 자연 로그를 반환한다.
   - `log10(double a)`: 밑이 10인 로그를 반환한다.
3. 삼각 함수
   - `sin(double a)`, `cos(double a)`, `tan(double a)`: 사인, 코사인, 탄젠트를 반환한다.
   - `asin(double a)`, `acos(double a)`, `atan(double a)`: 아크사인, 아크코사인, 아크탄젠트를 반환한다.
4. 반올림
   - `ceil(double a)`: 올림 값을 반환한다.
   - `floor(double a)`: 내림 값을 반환한다.
   - `round(float a)`, `round(double a)`: 반올림 값을 반환한다.
5. 난수 생성
   - `random()`: 0.0 이상 1.0 미만의 난수를 반환한다.

---

### 사용 예시

```java
public class MathExample {
    public static void main(String[] args) {
        // 절대값 구하기
        int absValue = Math.abs(-10);
        System.out.println("절대값: " + absValue);

        // 최대값, 최소값 구하기
        int maxValue = Math.max(5, 10);
        int minValue = Math.min(5, 10);
        System.out.println("최대값: " + maxValue);
        System.out.println("최소값: " + minValue);

        // 거듭제곱, 제곱근 구하기
        double power = Math.pow(2, 3);
        double squareRoot = Math.sqrt(16);
        System.out.println("2의 3제곱: " + power);
        System.out.println("16의 제곱근: " + squareRoot);

        // 삼각 함수 사용
        double sine = Math.sin(Math.PI / 2);
        System.out.println("sin(π/2): " + sine);

        // 올림, 내림, 반올림
        double value1 = 5.3;
        double value2 = 5.7;

        // 올림값 구하기
        double ceilValue1 = Math.ceil(value1);
        double ceilValue2 = Math.ceil(value2);
        System.out.println("ceil(" + value1 + "): " + ceilValue1);
        System.out.println("ceil(" + value2 + "): " + ceilValue2);

        // 내림값 구하기
        double floorValue1 = Math.floor(value1);
        double floorValue2 = Math.floor(value2);
        System.out.println("floor(" + value1 + "): " + floorValue1);
        System.out.println("floor(" + value2 + "): " + floorValue2);

        // 반올림값 구하기
        long roundValue1 = Math.round(value1);
        long roundValue2 = Math.round(value2);
        System.out.println("round(" + value1 + "): " + roundValue1);
        System.out.println("round(" + value2 + "): " + roundValue2);

        // float 값을 반올림할 때
        float value3 = 5.3f;
        float value4 = 5.7f;
        int roundValue3 = Math.round(value3);
        int roundValue4 = Math.round(value4);
        System.out.println("round(" + value3 + "f): " + roundValue3);
        System.out.println("round(" + value4 + "f): " + roundValue4);

        // 난수 생성
        double randomValue = Math.random();
        System.out.println("랜덤 값: " + randomValue);
    }
}
```

수학 연산을 간편하게 할 수 있게 도와주는 Math 클래스에 대해 알아보았다.
