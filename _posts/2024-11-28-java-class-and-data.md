---
title: "[Java] 클래스와 데이터"
date: 2024-11-28 10:00:44 +0900
categories: [Backend, Java]
tags: ["데이터", "클래스"]
tistory_url: https://yoon-ssi.tistory.com/129
render_with_liquid: false
---

Java 클래스(Java Class)는 객체를 찍어내는 설계도다. 데이터와 그 데이터를 다루는 메서드를 한데 묶어둔 것으로, Java의 모든 객체는 클래스를 바탕으로 만들어진다. 클래스에는 객체가 가질 특성(데이터)과 행동(메서드)을 정의한다.

---

### 1. 클래스를 이루는 것들

#### (1) 필드(Field): 데이터(속성)

- 클래스가 가지는 데이터로, 객체의 상태를 저장한다.
- 예: 이름, 나이, 점수 등.

#### (2) 메서드(Method): 동작(행동)

- 클래스가 할 수 있는 기능이다.
- 예: 데이터를 저장하거나 바꾸거나 출력하는 동작.

#### (3) 생성자(Constructor): 객체 초기화

- 객체가 만들어질 때 호출돼서 필드를 초기화한다.
- 이름은 클래스 이름과 같고, 반환 타입이 없다.

#### (4) 접근 제어자(Access Modifier)

- 클래스, 필드, 메서드에 어디서 접근할 수 있는지 정한다.
- public, private, protected, default가 있다.

---

### 2. Java 클래스의 구조

```
// 클래스 정의
public class Person {
    // 필드(속성)
    private String name;
    private int age;

    // 생성자: 객체 생성 시 호출
    public Person(String name, int age) {
        this.name = name; // this는 현재 객체를 참조
        this.age = age;
    }

    // 메서드: 데이터 출력
    public void displayInfo() {
        System.out.println("Name: " + name + ", Age: " + age);
    }

    // Getter(필드 값 반환)
    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }

    // Setter(필드 값 변경)
    public void setName(String name) {
        this.name = name;
    }

    public void setAge(int age) {
        this.age = age;
    }
}
```

---

### 3. 클래스와 데이터 사용 예제

```
public class Main {
    public static void main(String[] args) {
        // 객체 생성
        Person person = new Person("Alice", 25);

        // 메서드 호출
        person.displayInfo(); // 출력: Name: Alice, Age: 25

        // 데이터 변경
        person.setName("Bob");
        person.setAge(30);

        // 변경된 데이터 출력
        person.displayInfo(); // 출력: Name: Bob, Age: 30
    }
}
```

---

### 4. 알아둘 개념

#### (1) 캡슐화(Encapsulation)

- 데이터(필드)는 `private`로 막아서 밖에서 직접 건드리지 못하게 한다.
- 데이터를 읽거나 바꾸는 건 `public` 메서드를 통해서만 하게 만든다.

#### (2) 상속(Inheritance)

- 부모 클래스의 필드와 메서드를 자식 클래스에서 그대로 가져다 쓴다.
- 예: `class Student extends Person`.

#### (3) 다형성(Polymorphism)

- 같은 이름의 메서드가 상황에 따라 다르게 동작한다.
- 메서드 오버로딩(Overloading)과 오버라이딩(Overriding)이 여기에 해당한다.

#### (4) 추상화(Abstraction)

- 필요한 속성과 동작만 드러내고 세부 사항은 숨긴다.
- 추상 클래스(`abstract class`)와 인터페이스(`interface`)로 구현한다.

---

### 5. 데이터를 다루는 예제

배열로 데이터 처리하기

```java
public class ArrayExample {
    public static void main(String[] args) {
        Person[] people = {
            new Person("Alice", 25),
            new Person("Bob", 30),
            new Person("Charlie", 35)
        };

        for (Person person : people) {
            person.displayInfo(); // 각 객체의 정보 출력
        }
    }
}
```

리스트로 데이터 다루기

```java
import java.util.ArrayList;

public class ListExample {
    public static void main(String[] args) {
        ArrayList<Person> people = new ArrayList<>();

        people.add(new Person("Alice", 25));
        people.add(new Person("Bob", 30));

        for (Person person : people) {
            person.displayInfo();
        }
    }
}
```

---

정리하면 클래스는 데이터와 그 데이터를 처리하는 동작을 하나로 묶은 단위다. 여기에 캡슐화, 상속, 다형성을 잘 쓰면 코드를 재사용하고 확장하기가 훨씬 수월해진다.
