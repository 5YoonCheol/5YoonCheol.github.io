---
title: "[Java] HashMap 이란?"
date: 2024-09-11 11:11:04 +0900
categories: [Backend, Java]
tags: ["hashmap", "java"]
tistory_url: https://yoon-ssi.tistory.com/50
render_with_liquid: false
---

### **HashMap**

#### 개요

- **정의**: HashMap은 키(key)와 값(value) 쌍으로 데이터를 저장하는 Map 인터페이스의 구현체이다.  
  키는 고유해야 하며, 각 키는 하나의 값에 매핑된다.
- **내부 구조**: HashMap은 해싱(hashing) 기법을 사용하여 데이터를 저장한다.   
  해싱은 키를 해시 함수에 입력하여 해시 코드를 생성하고, 이를 기반으로 데이터가 저장될 위치를 결정하는 방법이다.
- **속성**
  - 키-값 쌍으로 데이터를 저장한다.
  - 키는 중복될 수 없지만, 값은 중복될 수 있다.
  - 순서가 보장되지 않으며, 삽입된 순서와 상관없이 데이터를 저장한다.
  - null 키와 null 값을 허용한다.

#### 주요 메서드

- **put(K key, V value)**: 키와 값을 추가한다. 만약 이미 존재하는 키라면, 기존 값을 새 값으로 대체한다.
- **get(Object key)**: 주어진 키에 매핑된 값을 반환한다. 키가 존재하지 않으면 null을 반환한다.
- **remove(Object key)**: 주어진 키에 매핑된 키-값 쌍을 제거한다.
- **containsKey(Object key)**: 특정 키가 존재하는지 확인한다.
- **containsValue(Object value)**: 특정 값이 존재하는지 확인한다.
- **size()**: HashMap에 있는 키-값 쌍의 개수를 반환한다.

**Java에서의 구현 예시**

```java
import java.util.HashMap;

public class HashMapExample {
    public static void main(String[] args) {
        HashMap<String, Integer> map = new HashMap<>();
        map.put("apple", 1);
        map.put("banana", 2);
        map.put("orange", 3);

        System.out.println(map.get("apple")); // 출력: 1
        System.out.println(map.containsKey("banana")); // 출력: true
        System.out.println(map.size()); // 출력: 3

        map.remove("orange");
        System.out.println(map.size()); // 출력: 2
    }
}
```

#### 특징

- **시간 복잡도**: 대부분의 연산(삽입, 삭제, 검색)에 대해 평균적으로 O(1)의 시간 복잡도를 가진다. 단, 해시 충돌이 많아질 경우 성능이 저하될 수 있다.
- **적합한 사용 사례**: 키를 통해 빠르게 값을 검색하거나, 중복 키 없이 데이터를 저장해야 하는 경우.
