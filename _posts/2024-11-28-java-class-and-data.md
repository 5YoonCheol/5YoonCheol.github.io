---
title: "[Java] 클래스와 데이터"
date: 2024-11-28 10:00:44 +0900
categories: ["Java"]
tags: ["데이터", "클래스"]
tistory_url: https://yoon-ssi.tistory.com/129
render_with_liquid: false
---

**Java 클래스(Java Class)**는 객체지향 프로그래밍(OOP)의 핵심 요소로, 데이터와 메서드를 함께 캡슐화한 설계도이다. Java에서 모든 객체는 클래스를 기반으로 생성되며, 클래스는 객체의 **특성(데이터)**과 **행동(메서드)**을 정의한다.

---

### 1. 클래스의 구성 요소

#### (1) **필드(Field)**: 데이터(속성)

- 클래스가 가지는 데이터를 나타내며, 객체의 상태를 저장한다.
- 예: 이름, 나이, 점수 등.

#### (2) **메서드(Method)**: 동작(행동)

- 클래스에서 수행할 수 있는 기능을 정의한다.
- 예: 데이터를 저장, 변경, 출력하는 동작.

#### (3) **생성자(Constructor)**: 객체 초기화

- 클래스의 객체가 생성될 때 호출되어 필드를 초기화한다.
- 생성자는 클래스 이름과 동일하며, 반환 타입이 없다.

#### (4) **접근 제어자(Access Modifier)**

- 클래스, 필드, 메서드의 접근 범위를 제어한다.
- 주요 제어자: public, private, protected, default.

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

### 4. 주요 개념과 특징

#### (1) **캡슐화(Encapsulation)**

- 데이터(필드)는 `private`로 보호하며, 외부에서 직접 접근하지 못하게 합니다.
- 메서드(`public`)를 통해서만 데이터를 읽거나 수정할 수 있도록 설계합니다.

#### (2) **상속(Inheritance)**

- 기존 클래스(부모 클래스)의 필드와 메서드를 새로운 클래스(자식 클래스)에서 재사용.
- 예: `class Student extends Person`.

#### (3) **다형성(Polymorphism)**

- 같은 이름의 메서드가 다양한 형태로 동작.
- 메서드 오버로딩(Overloading) 및 오버라이딩(Overriding) 포함.

#### (4) **추상화(Abstraction)**

- 중요한 속성과 동작만 노출하고, 불필요한 세부 사항은 숨김.
- 추상 클래스(`abstract class`)와 인터페이스(`interface`)를 통해 구현.

---

### 5. 데이터와 관련된 클래스 활용

**배열 데이터 처리**

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

**데이터 리스트 사용**

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

### 결론

Java 클래스는 데이터를 저장하고 이를 처리하는 동작을 캡슐화하여 객체지향 프로그래밍의 기본 단위로 활용된다.

캡슐화, 상속, 다형성과 같은 원칙을 활용하면 복잡한 시스템을 설계할 때 높은 재사용성과 확장성을 확보할 수 있다.
