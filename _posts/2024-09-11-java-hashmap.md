---
title: "[Java] HashMap 이란?"
date: 2024-09-11 02:00:00 +0900
categories: [Backend, Java]
tags: ["hashmap", "java"]
description: Java HashMap의 동작 원리와 특징, 자주 쓰는 메서드와 사용 예시를 정리한다.
tistory_url: https://yoon-ssi.tistory.com/50
render_with_liquid: false
---

### HashMap

#### 개요

HashMap은 키(key)와 값(value)을 한 쌍으로 저장하는 Map 인터페이스 구현체다. 키는 겹치면 안 되고, 키 하나에 값 하나가 붙는다.

내부적으로는 해싱(hashing)을 쓴다. 키를 해시 함수에 넣어 해시 코드를 만들고, 그 값으로 데이터를 어디에 저장할지 정하는 방식이다.

성질을 정리하면 이렇다.

- 키-값 쌍으로 저장한다.
- 키는 중복될 수 없지만 값은 중복돼도 된다.
- 순서를 보장하지 않는다. 넣은 순서와 상관없이 저장된다.
- null 키와 null 값을 넣을 수 있다.

#### 자주 쓰는 메서드

- `put(K key, V value)`: 키와 값을 넣는다. 이미 있는 키면 값을 새 값으로 바꾼다.
- `get(Object key)`: 키에 매핑된 값을 돌려준다. 키가 없으면 null.
- `remove(Object key)`: 해당 키의 키-값 쌍을 지운다.
- `containsKey(Object key)`: 그 키가 있는지 확인한다.
- `containsValue(Object value)`: 그 값이 있는지 확인한다.
- `size()`: 들어 있는 키-값 쌍 개수를 돌려준다.

Java로 써보면 이렇다.

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

삽입, 삭제, 검색 대부분이 평균 O(1)이다. 다만 해시 충돌이 많아지면 느려질 수 있다.

키로 값을 빨리 찾아야 하거나, 키 중복 없이 데이터를 담아야 할 때 쓰면 된다.
