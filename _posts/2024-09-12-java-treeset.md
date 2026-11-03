---
title: "[Java] TreeSet 이란?"
date: 2024-09-12 07:07:10 +0900
categories: [Backend, Java]
tags: ["java", "treeset"]
tistory_url: https://yoon-ssi.tistory.com/51
render_with_liquid: false
---

### **TreeSet**

#### 개요

- **정의**: TreeSet은 NavigableSet 인터페이스의 구현체로, 이진 검색 트리인 레드-블랙 트리를 기반으로 한 정렬된 집합이다. 이 구조는 데이터가 자동으로 정렬된 상태로 유지되며, 중복된 요소를 허용하지 않는다.
- **내부 구조**: TreeSet은 레드-블랙 트리라는 자가 균형 이진 검색 트리 구조를 사용하여 데이터를 저장한다.
- **속성**:
  - 데이터는 정렬된 상태로 저장되며, 기본적으로 오름차순이다.
  - 중복된 요소를 허용하지 않는다.
  - null 값을 허용하지 않는다.

#### 주요 메서드

- **add(E e)**: 지정된 요소를 집합에 추가한다. 요소가 이미 존재하면 추가되지 않는다.
- **remove(Object o)**: 지정된 요소를 제거한다.
- **contains(Object o)**: 지정된 요소가 집합에 포함되어 있는지 확인한다.
- **size()**: TreeSet에 포함된 요소의 개수를 반환한다.
- **first()**: 집합의 첫 번째(가장 작은) 요소를 반환한다.
- **last()**: 집합의 마지막(가장 큰) 요소를 반환한다.
- **subSet(E fromElement, E toElement)**: 지정된 범위의 요소들을 포함하는 부분 집합을 반환한다.

#### Java에서의 구현 예시

```java
import java.util.TreeSet;

public class TreeSetExample {
    public static void main(String[] args) {
        TreeSet<Integer> set = new TreeSet<>();
        set.add(10);
        set.add(5);
        set.add(20);
        set.add(15);

        System.out.println(set); // 출력: [5, 10, 15, 20] (오름차순 정렬)
        System.out.println(set.first()); // 출력: 5
        System.out.println(set.last()); // 출력: 20

        set.remove(10);
        System.out.println(set); // 출력: [5, 15, 20]
    }
}
```

#### 특징

- **시간 복잡도**: 대부분의 연산(삽입, 삭제, 검색)에 대해 O(log n)의 시간 복잡도를 가진다.
- **적합한 사용 사례**: 요소들을 자동으로 정렬된 상태로 유지해야 하거나, 범위 검색을 수행해야 하는 경우.
