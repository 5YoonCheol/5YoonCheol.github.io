---
title: "[Java] TreeSet 이란?"
date: 2024-09-12 07:07:10 +0900
categories: [Backend, Java]
tags: ["java", "treeset"]
tistory_url: https://yoon-ssi.tistory.com/51
render_with_liquid: false
---

### TreeSet

#### TreeSet이란

TreeSet은 값을 넣으면 알아서 정렬된 상태로 보관해주는 Set이다. NavigableSet 인터페이스의 구현체이고, 내부는 레드-블랙 트리(스스로 균형을 맞추는 이진 검색 트리)로 되어 있다.

성질은 이렇다.

- 데이터가 항상 정렬된 상태로 저장된다. 기본은 오름차순이다.
- Set이라 중복을 허용하지 않는다.
- null은 넣을 수 없다.

#### 자주 쓰는 메서드

- add(E e): 요소를 추가한다. 이미 있는 값이면 추가되지 않는다.
- remove(Object o): 요소를 제거한다.
- contains(Object o): 요소가 들어 있는지 확인한다.
- size(): 요소 개수를 돌려준다.
- first(): 첫 번째(가장 작은) 요소를 돌려준다.
- last(): 마지막(가장 큰) 요소를 돌려준다.
- subSet(E fromElement, E toElement): 지정한 범위의 요소만 담은 부분 집합을 돌려준다.

#### 예시

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

넣은 순서와 상관없이 출력은 오름차순으로 정렬돼서 나온다.

#### 정리

삽입, 삭제, 검색 모두 O(log n)이다. 데이터를 항상 정렬된 상태로 들고 있어야 하거나, 특정 범위의 값을 뽑아야 할 때 쓰기 좋다.
