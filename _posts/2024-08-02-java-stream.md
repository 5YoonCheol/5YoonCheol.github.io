---
title: "Java Stream(스트림)은 무엇일까?"
date: 2024-08-02 02:00:00 +0900
categories: [Backend, Java]
tags: ["java", "stream", "선언형-프로그래밍", "스트림"]
description: Java Stream의 선언형 프로그래밍, 지연 연산, 병렬 처리 같은 특징과 filter·map·collect 사용 예시를 정리한다.
tistory_url: https://yoon-ssi.tistory.com/6
render_with_liquid: false
---

## Java Stream?

Stream은 Java 8에서 들어온 기능으로, 컬렉션 같은 데이터를 처리하고 다룰 때 쓴다.

Stream을 쓰면 데이터를 처리하는 과정을 파이프라인처럼 이어 붙일 수 있어서 코드가 읽기 쉬워지고 유지보수하기도 편해진다.

---

## Stream의 특징을 알아보자

### 1. 선언형 프로그래밍이 가능하다

filter(), map(), collect() 같은 메서드를 체이닝해서 쓸 수 있다. 명령형처럼 '어떻게' 할지를 적는 게 아니라 '무엇을' 할지를 표현하는 방식이다.

**ex) 상사가 부하직원에게 회원조회 API를 개발하라고 지시하는 상황**

- 명령형 : OO님, 회원의 아이디 값을 요청받아서 DB Select SQL을 날려서 회원 정보를 추출한 다음 User라는 객체에 정보를 담아서 return 해주는 방법으로 API를 만들어주세요.
- 선언형 : OO님, 회원 정보를 return 해주는 API를 만들어주세요.

명령형은 '어떻게'가 정해져 있어서 자율성이 떨어진다.
반면 선언형은 돌려주는 정보는 같아도 그걸 만드는 과정은 자유롭게 정할 수 있으니 재사용성이 좋다고 볼 수 있다.

### 2. Stream은 저장소가 아니다

스트림 자체가 데이터를 들고 있는 게 아니다. 데이터 소스에서 데이터를 읽어서 처리하는 역할만 한다.

### 3. 데이터 소스에서 뽑은 요소로 시퀀스를 만들어 처리한다

순서대로 처리한다. for문 같은 느낌(?)

### 4. Stream은 일회성이다

최종 연산을 하고 나면 그 Stream은 끝이다. 다시 쓰려면 Stream을 새로 만들어야 한다.

### 5. 병렬 처리를 지원한다

### 6. 중간 연산과 최종 연산이 있다

- 중간 연산 (Intermediate Operations): 스트림을 변환해서 새 스트림을 돌려준다. 그래서 계속 이어 붙일 수 있다.
  - filter, map, flatMap, sorted, distinct, limit, skip
- 최종 연산 (Terminal Operations): 스트림을 닫고 결과를 돌려주거나, 출력 같은 부수 효과를 일으킨다.
  - forEach, collect, reduce, count, findFirst, findAny, anyMatch, allMatch, noneMatch

---

## 중간 연산

### 1. filter

스트림의 각 요소에 대해 주어진 조건(predicate)을 검사하고, 조건을 만족하는 요소만을 포함하는 새로운 스트림을 반환한다.
특정 조건에 맞는 요소들을 필터링할 때 쓴다.

```java
List<String> list = Arrays.asList("apple", "banana", "cherry");
List<String> result = list.stream()
                          .filter(s -> s.startsWith("a"))
                          .collect(Collectors.toList());
// result: ["apple"]
```

### 2. map

스트림의 각 요소에 주어진 함수(function)를 적용하여 새로운 요소로 변환하고, 변환된 요소들로 구성된 새로운 스트림을 반환한다.
요소들을 변환할 때 쓴다.

```java
List<String> list = Arrays.asList("apple", "banana", "cherry");
List<Integer> result = list.stream()
                           .map(String::length)
                           .collect(Collectors.toList());
// result: [5, 6, 6]
```

### 3. flatMap

스트림의 각 요소에 주어진 함수(function)를 적용하여 스트림을 생성하고, 생성된 여러 스트림을 하나의 스트림으로 평면화한다.
중첩된 구조를 평면화할 때 쓴다.

```java
List<List<String>> list = Arrays.asList(
    Arrays.asList("apple", "banana"),
    Arrays.asList("cherry", "date")
);
List<String> result = list.stream()
                          .flatMap(Collection::stream)
                          .collect(Collectors.toList());
// result: ["apple", "banana", "cherry", "date"]
```

### 4. sorted

스트림의 요소들을 자연 순서(오름차순)나 제공된 비교자(comparator)에 따라 정렬하여 새로운 스트림을 반환한다.
요소들을 정렬할 때 쓴다.

```java
List<String> list = Arrays.asList("cherry", "banana", "apple");
List<String> result = list.stream()
                          .sorted()
                          .collect(Collectors.toList());
// result: ["apple", "banana", "cherry"]
```

### 5. distinct

스트림의 요소들 중 중복된 요소를 제거하여 고유한 요소들로 구성된 새로운 스트림을 반환한다.
중복을 제거할 때 쓴다.

```java
List<String> list = Arrays.asList("apple", "banana", "apple", "cherry");
List<String> result = list.stream()
                          .distinct()
                          .collect(Collectors.toList());
// result: ["apple", "banana", "cherry"]
```

### 6. limit

스트림의 처음 n개의 요소들만 포함하는 새로운 스트림을 반환한다.
요소의 개수를 제한할 때 쓴다.

```java
List<String> list = Arrays.asList("apple", "banana", "cherry", "date");
List<String> result = list.stream()
                          .limit(2)
                          .collect(Collectors.toList());
// result: ["apple", "banana"]
```

### 7. skip

스트림의 처음 n개의 요소들을 건너뛰고 나머지 요소들로 구성된 새로운 스트림을 반환한다.
특정 개수의 요소를 건너뛸 때 쓴다.

```java
List<String> list = Arrays.asList("apple", "banana", "cherry", "date");
List<String> result = list.stream()
                          .skip(2)
                          .collect(Collectors.toList());
// result: ["cherry", "date"]
```

## 최종 연산

### 1. forEach

스트림의 각 요소에 대해 주어진 동작을 수행한다. 이 메서드는 스트림의 요소를 반복(iterate)하는 데 사용된다.
요소들에 대해 부수 효과(side-effect)를 일으키는 작업을 수행할 때 쓴다.

```java
List<String> list = Arrays.asList("apple", "banana", "cherry");
list.stream().forEach(System.out::println);
// 출력: apple, banana, cherry (각 요소가 개별적으로 출력됨)
```

### 2. collect

스트림의 요소들을 수집하여 리스트, 세트, 맵 등의 다른 형태로 변환한다. 주로 Collectors 유틸리티 클래스를 사용한다.
스트림의 결과를 특정 컬렉션으로 변환할 때 쓴다.

```java
List<String> list = Arrays.asList("apple", "banana", "cherry");
List<String> result = list.stream().collect(Collectors.toList());
// result: ["apple", "banana", "cherry"]
```

### 3. reduce

스트림의 요소들을 결합하여 하나의 결과를 생성한다. 초기값과 결합 함수를 인수로 받는다.
스트림의 모든 요소를 결합하여 단일 결과를 도출할 때 쓴다.

```java
List<Integer> list = Arrays.asList(1, 2, 3, 4, 5);
int sum = list.stream().reduce(0, Integer::sum);
// sum: 15
```

### 4. count

스트림의 요소 개수를 반환한다.
스트림에 포함된 요소의 개수를 셀 때 쓴다.

```java
List<String> list = Arrays.asList("apple", "banana", "cherry");
long count = list.stream().count();
// count: 3
```

### 5. findFirst

스트림에서 첫 번째 요소를 반환한다. 요소가 없으면 빈 Optional을 반환한다.
스트림의 첫 번째 요소를 찾을 때 쓴다.

```java
List<String> list = Arrays.asList("apple", "banana", "cherry");
Optional<String> firstElement = list.stream().findFirst();
// firstElement: Optional[apple]
```

### 6. findAny

스트림에서 임의의 요소를 반환한다. 요소가 없으면 빈 Optional을 반환한다.
병렬 스트림에서 성능 최적화를 위해 임의의 요소를 찾을 때 쓴다.

```java
List<String> list = Arrays.asList("apple", "banana", "cherry");
Optional<String> anyElement = list.stream().findAny();
// anyElement: Optional[apple] (또는 다른 임의의 요소)
```

### 7. anyMatch

스트림의 어떤 요소라도 주어진 조건(predicate)을 만족하면 true를 반환한다.
스트림에 조건을 만족하는 요소가 하나라도 있는지 확인할 때 쓴다.

```java
List<String> list = Arrays.asList("apple", "banana", "cherry");
boolean hasApple = list.stream().anyMatch(s -> s.equals("apple"));
// hasApple: true
```

### 8. allMatch

스트림의 모든 요소가 주어진 조건(predicate)을 만족하면 true를 반환한다.
스트림의 모든 요소가 조건을 만족하는지 확인할 때 쓴다.

```java
List<String> list = Arrays.asList("apple", "banana", "cherry");
boolean allHaveA = list.stream().allMatch(s -> s.contains("a"));
// allHaveA: true
```

### 9. noneMatch

스트림의 모든 요소가 주어진 조건(predicate)을 만족하지 않으면 true를 반환한다.
스트림의 모든 요소가 조건을 만족하지 않는지 확인할 때 쓴다.

```java
List<String> list = Arrays.asList("apple", "banana", "cherry");
boolean noneStartWithZ = list.stream().noneMatch(s -> s.startsWith("z"));
// noneStartWithZ: true
```

---

## Stream 사용 예제

### 컬렉션에서 스트림 생성

```java
List<String> names = Arrays.asList("Alice", "Bob", "Charlie", "David", "Edward");

List<String> filteredNames = names.stream()
    .filter(name -> name.startsWith("A"))  // 이름이 "A"로 시작하는 항목 필터링
    .map(String::toUpperCase)              // 이름을 대문자로 변환
    .sorted()                              // 이름을 정렬
    .collect(Collectors.toList());         // 결과를 리스트로 수집

filteredNames.forEach(System.out::println);  // 결과 출력: ALICE
```

### 배열에서 스트림 생성

```java
int[] numbers = {1, 2, 3, 4, 5};

int sum = Arrays.stream(numbers)
    .filter(n -> n % 2 == 0)  // 짝수 필터링
    .sum();                   // 합계 계산

System.out.println(sum);  // 결과 출력: 6
```

### 파일에서 스트림 생성

```java
try (Stream<String> lines = Files.lines(Paths.get("example.txt"))) {
    long lineCount = lines.count();  // 파일의 줄 수 계산
    System.out.println(lineCount);
} catch (IOException e) {
    e.printStackTrace();
}
```
