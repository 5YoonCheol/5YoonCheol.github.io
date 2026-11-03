---
title: "[Java] 추상화란?"
date: 2024-08-11 02:00:00 +0900
categories: [Backend, Java]
tags: ["abstract-class", "abstraction", "interface", "java", "자바", "추상화", "추상화란?"]
tistory_url: https://yoon-ssi.tistory.com/16
render_with_liquid: false
---

추상화(abstraction)는 객체 지향 프로그래밍의 핵심 개념 중 하나다. 쉽게 말하면 필요한 것만 밖으로 보여주고 자세한 내부 사정은 숨겨서, 복잡한 시스템을 다루기 쉽게 만드는 방법이다.

Java에서는 주로 추상 클래스와 인터페이스로 추상화를 구현한다.

---

### 추상 클래스 (Abstract Class)

`abstract` 키워드로 선언하고, 구현이 없는 추상 메서드를 하나 이상 가질 수 있다. 추상 클래스는 직접 인스턴스를 만들 수 없고, 상속받은 하위 클래스가 추상 메서드를 구현해야 한다.

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

코드를 보면

1. 추상 클래스 Animal
   - `abstract`로 선언했다.
   - 추상 메서드 makeSound가 있다. 구현이 없어서 하위 클래스가 반드시 구현해야 한다.
   - 일반 메서드 breathe도 있다. 이건 구현이 있어서 모든 하위 클래스에서 똑같이 동작한다.
2. 구체 클래스 Dog
   - Animal을 상속받는다.
   - makeSound를 구현했다. 여기서는 "멍!"을 출력한다.
   - breathe는 Animal에 있는 걸 그대로 쓴다.
3. main 메서드
   - Dog 객체를 만든다.
   - makeSound를 호출하면 "멍!"이 출력된다.
   - breathe를 호출하면 "동물은 숨을 쉰다."가 출력된다.

공통 동작(breathe)은 추상 클래스가 미리 정해두고, 개별 동작(makeSound)은 하위 클래스가 직접 정의하도록 강제하는 구조다.

---

### 인터페이스 (Interface)

인터페이스는 기본적으로 모든 메서드가 추상 메서드인, 구현 없는 메서드들의 묶음이다. Java 8부터는 디폴트 메서드와 정적 메서드도 넣을 수 있게 됐다.

클래스는 하나만 상속할 수 있지만 인터페이스는 여러 개를 구현할 수 있어서, 다중 상속 같은 효과를 낼 때 쓴다.

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

1. 인터페이스 Animal
   - 추상 메서드 makeSound가 있다. 구현하는 클래스에서 반드시 구현해야 한다.
   - 디폴트 메서드 breathe가 있다. 구현이 들어 있어서 이 인터페이스를 구현하는 모든 클래스에서 똑같이 동작한다. 디폴트 메서드는 Java 8에서 추가됐다.
2. 구체 클래스 Dog
   - Animal 인터페이스를 구현한다.
   - makeSound를 구현해서 "멍!"을 출력한다.
   - breathe는 인터페이스의 디폴트 구현을 그대로 쓴다.
3. main 메서드
   - Dog 객체를 만든다.
   - makeSound를 호출하면 "멍!"이 출력된다.
   - breathe를 호출하면 "동물은 숨을 쉰다."가 출력된다.

인터페이스로 특정 메서드 구현을 강제하면서, 디폴트 메서드로 공통 동작도 줄 수 있다. 한 클래스가 여러 인터페이스를 구현할 수 있다는 점이 추상 클래스와 다른 부분이다.

---

### 추상화를 쓰면 좋은 점

1. 공통 기능을 한 곳에 모아두고 상속으로 여러 클래스에서 재사용할 수 있다.
2. 세부 구현을 숨기고 필요한 부분만 드러내니 코드가 간결해지고 이해하기 쉬워진다. 유지보수도 편해진다.
3. 다형성(Polymorphism)을 쓸 수 있다. 서로 다른 객체를 같은 추상 클래스나 인터페이스 타입으로 다룰 수 있다.

결국 추상화는 시스템이 커져도 관리하고 확장하기 쉽게 만들어주는 장치라고 보면 된다.
