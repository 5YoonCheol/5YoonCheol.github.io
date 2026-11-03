---
title: "[Java] 추상화란?"
date: 2024-08-11 09:52:45 +0900
categories: ["Java"]
tags: ["abstract-class", "abstraction", "interface", "java", "자바", "추상화", "추상화란?"]
tistory_url: https://yoon-ssi.tistory.com/16
render_with_liquid: false
---

Java에서 추상화(abstraction)는 객체 지향 프로그래밍의 핵심 개념 중 하나로, 복잡한 시스템을 더 간단하고 이해하기 쉽게 만드는 방법이다.

추상화는 필요한 정보만을 노출하고, 불필요한 세부 사항은 숨기는 것을 의미한다.

Java에서 추상화는 주로 추상 클래스와 인터페이스를 통해 구현된다.

---

### **추상 클래스 (Abstract Class)**

추상 클래스는 abstract 키워드를 사용하여 선언하며, 하나 이상의 추상 메서드(구현되지 않은 메서드)를 포함할 수 있다. 추상 클래스는 직접 인스턴스를 생성할 수 없으며, 이를 상속한 하위 클래스가 추상 메서드를 구현해야 한다.

```java
abstract class Animal {
    // 추상 메서드 (구현 없음)
    abstract void makeSound();

    // 일반 메서드
    void breathe() {
        System.out.println("동물은 숨을 쉰다.");
    }
}

class Dog extends Animal {
    @Override
    void makeSound() {
        System.out.println("멍!");
    }
}

public class Main {
    public static void main(String[] args) {
        Dog dog = new Dog();
        dog.makeSound();  // "멍!"
        dog.breathe();    // "동물은 숨을 쉰다."
    }
}
```

1. **추상 클래스 Animal**:
   - abstract 키워드로 선언된 클래스이다.
   - makeSound라는 추상 메서드를 포함하고 있다. 이 메서드는 구현이 없으며, 하위 클래스에서 반드시 구현해야 한다.
   - breathe라는 일반 메서드를 포함하고 있다. 이 메서드는 구현이 있으며, 모든 하위 클래스에서 동일하게 동작한다.
2. **구체 클래스 Dog**:
   - Animal 클래스를 상속받는다.
   - makeSound 메서드를 구현한다. 여기서 "멍!"을 출력하도록 구현했다.
   - breathe 메서드는 Animal 클래스에서 구현된 대로 사용한다.
3. **메인 메서드**:
   - Dog 객체를 생성한다.
   - makeSound 메서드를 호출하면 "멍!"가 출력된다.
   - breathe 메서드를 호출하면 "동물은 숨을 쉰다."가 출력된다.

이 예시는 추상 클래스가 공통된 동작(예: breathe 메서드)을 정의하면서, 특정 동작(예: makeSound 메서드)을 하위 클래스에서 정의하도록 강제하는 방법을 보여준다.

---

### **인터페이스 (Interface)**

인터페이스는 모든 메서드가 기본적으로 추상적이며, 구현되지 않은 메서드의 집합이다.

Java 8 이후부터는 인터페이스에도 디폴트 메서드와 정적 메서드를 정의할 수 있다.

인터페이스는 다중 상속을 지원하기 위해 사용된다.

```java
interface Animal {
    void makeSound();
    default void breathe() {
        System.out.println("동물은 숨을 쉰다.");
    }
}

class Dog implements Animal {
    @Override
    public void makeSound() {
        System.out.println("멍!");
    }
}

public class Main {
    public static void main(String[] args) {
        Dog dog = new Dog();
        dog.makeSound();  // "멍!"
        dog.breathe();    // "동물은 숨을 쉰다."
    }
}
```

1. **인터페이스 Animal**:
   - makeSound라는 추상 메서드를 포함하고 있다. 이 메서드는 인터페이스를 구현하는 클래스에서 반드시 구현해야 한다.
   - breathe라는 디폴트 메서드를 포함하고 있다. 이 메서드는 구현이 있으며, 인터페이스를 구현하는 모든 클래스에서 동일하게 동작한다. 디폴트 메서드는 Java 8 이후에 추가된 기능이다.
2. **구체 클래스 Dog**:
   - Animal 인터페이스를 구현한다.
   - makeSound 메서드를 구현한다. 여기서 "멍!"을 출력하도록 구현했다.
   - breathe 메서드는 인터페이스에서 제공하는 디폴트 구현을 사용한다.
3. **메인 메서드**:
   - Dog 객체를 생성한다.
   - makeSound 메서드를 호출하면 "멍!"이 출력된다.
   - breathe 메서드를 호출하면 "동물은 숨을 쉰다."가 출력된다.

이 예시는 인터페이스가 어떻게 클래스에 특정 메서드를 구현하도록 강제하고, 디폴트 메서드를 통해 공통 동작을 제공하는지 보여준다. 인터페이스는 다중 상속을 지원하므로, 하나의 클래스가 여러 인터페이스를 구현할 수 있다는 장점이 있다.

---

### **추상화의 장점**

1. **코드 재사용성 증가**: 공통된 기능을 추상화하여 상속을 통해 여러 클래스에서 재사용할 수 있다.
2. **코드의 유지보수성 향상**: 불필요한 세부 사항을 숨기고 중요한 부분만을 노출함으로써 코드가 더 간결하고 이해하기 쉬워진다.
3. **다형성(Polymorphism) 지원**: 추상 클래스와 인터페이스를 사용하여 다양한 객체를 동일한 인터페이스로 다룰 수 있다.

추상화를 통해 복잡한 시스템을 더 쉽게 관리하고 확장할 수 있으며, 객체 지향 설계 원칙을 준수하여 견고하고 유연한 소프트웨어를 개발할 수 있다.
