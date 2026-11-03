---
title: "[Java] 객체 지향 설계 원칙"
date: 2024-11-03 10:00:50 +0900
categories: ["Java"]
tags: ["java", "객체-지향", "설계-원칙"]
tistory_url: https://yoon-ssi.tistory.com/103
render_with_liquid: false
---

Java의 객체 지향 설계 원칙은 코드의 재사용성, 유연성, 유지보수성을 높이기 위한 가이드라인이다. 대표적으로 **SOLID 원칙**과 **추가적인 객체 지향 설계 원칙**이 있다.

각각의 원칙은 객체 간의 관계를 명확하게 정의하고, 코드의 모듈화를 통해 복잡성을 줄이는 데 중요한 역할을 한다.

---

### SOLID 원칙

SOLID 원칙은 객체 지향 설계의 5가지 기본 원칙을 뜻하는 약어이다. 이 원칙들을 준수하면 **확장 가능**하고 **유지보수가 쉬운 소프트웨어**를 설계할 수 있다.

#### 1. 단일 책임 원칙 (Single Responsibility Principle, SRP)

> **클래스는 하나의 책임만 가져야 한다.**

단일 책임 원칙은 **하나의 클래스가 하나의 기능만 수행해야 한다는 것**이다. 즉, 클래스가 변경되는 이유는 단 하나의 이유여야 한다. 여러 역할을 담당하는 클래스는 코드가 복잡해지고, 변경할 때 다른 기능에도 영향을 미칠 수 있기 때문에 이 원칙을 따르는 것이 좋다.

예) 학생 정보를 관리하는 시스템에서 학생 클래스는 학생의 이름, 나이, 학번 같은 속성만 담당해야 한다. 만약 성적을 계산하는 메서드가 학생 클래스에 추가된다면 SRP를 위반하게 된다.

```java
class Student {
    private String name;
    private int age;
    // 단일 책임 원칙에 따라 학생 정보만 관리

    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }
}

class GradeCalculator {
    public double calculateGrade(double[] scores) {
        // 성적 계산 로직
    }
}
```

#### 2. 개방-폐쇄 원칙 (Open-Closed Principle, OCP)

> **확장에는 열려 있어야 하고, 수정에는 닫혀 있어야 한다.**

개방-폐쇄 원칙은 **기존 코드를 수정하지 않고 기능을 확장할 수 있도록 설계**해야 한다는 원칙이다. 즉, 기능을 추가하거나 확장하려면 기존 코드를 변경하지 않고 새로운 클래스를 작성하여 확장할 수 있어야 한다.

예) 할인 정책이 있는 쇼핑몰 시스템에서 고정 할인과 추가 할인 정책을 제공하려면 인터페이스를 정의하고 각각의 할인 정책을 새로운 클래스로 구현하는 방식이다.

```java
interface DiscountPolicy {
    double applyDiscount(double price);
}

class FixedDiscountPolicy implements DiscountPolicy {
    public double applyDiscount(double price) {
        return price - 10;
    }
}

class AdditionalDiscountPolicy implements DiscountPolicy {
    public double applyDiscount(double price) {
        return price * 0.9;
    }
}
```

#### 3. 리스코프 치환 원칙 (Liskov Substitution Principle, LSP)

> **상위 클래스의 인스턴스를 하위 클래스 객체로 치환하더라도 시스템이 정상적으로 작동해야 한다.**

리스코프 치환 원칙은 **상속 관계에서 상위 클래스의 인스턴스를 하위 클래스의 인스턴스로 교체해도 프로그램이 문제없이 작동해야 한다는 원칙**이다. 하위 클래스는 상위 클래스의 모든 기능을 그대로 유지하거나 확장해야 하며, 기존의 기능을 제한하거나 의도에 어긋나는 방식으로 변경해서는 안된다.

예) 사각형 클래스와 정사각형 클래스를 생각해보자. 정사각형은 사각형의 하위 클래스가 될 수 있지만, 이 경우 너비와 높이 값을 따로 설정하는 메서드가 제한될 수 있다. 따라서 정사각형이 사각형의 하위 클래스가 되는 것은 LSP 위반이다.

```java
class Rectangle {
    private int width;
    private int height;

    public void setWidth(int width) {
        this.width = width;
    }

    public void setHeight(int height) {
        this.height = height;
    }
}

class Square extends Rectangle {
    // 너비와 높이가 같은 정사각형은 Rectangle로 대체될 수 없으므로 LSP 위반 가능성
}
```

#### 4. 인터페이스 분리 원칙 (Interface Segregation Principle, ISP)

> **클라이언트는 자신이 사용하지 않는 메서드에 의존하지 않아야 한다.**

인터페이스 분리 원칙은 **인터페이스를 구체적이고 작게 나누어, 클라이언트가 불필요한 메서드에 의존하지 않도록 하는 것**이다. 하나의 거대한 인터페이스를 정의하면, 이를 구현하는 클래스가 필요 없는 메서드까지 구현해야 할 수 있다.

예) 동물 인터페이스에서 물고기는 수영만 하고, 새는 날기만 할 수 있는데도 모두 같은 인터페이스에 포함되면 불필요한 의존성이 생긴다.

```java
interface Swimmable {
    void swim();
}

interface Flyable {
    void fly();
}

class Fish implements Swimmable {
    public void swim() {
        System.out.println("Fish is swimming.");
    }
}

class Bird implements Flyable {
    public void fly() {
        System.out.println("Bird is flying.");
    }
}
```

#### 5. 의존 역전 원칙 (Dependency Inversion Principle, DIP)

> **상위 모듈이 하위 모듈에 의존해서는 안 되며, 둘 다 추상화에 의존해야 한다.**

의존 역전 원칙은 **상위 모듈과 하위 모듈이 서로 독립적이며 추상화에 의존하도록 해야 한다**는 원칙이다. DIP를 통해 객체 간 결합도를 줄여 코드의 유연성과 재사용성을 높일 수 있다.

예) 메시지를 전송하는 기능을 구현할 때, 특정 메시지 전송 방식에 의존하지 않도록 추상화를 통해 메시지 전송 기능을 구현한다.

```java
interface MessageSender {
    void sendMessage(String message);
}

class EmailSender implements MessageSender {
    public void sendMessage(String message) {
        System.out.println("Email message sent: " + message);
    }
}

class NotificationService {
    private final MessageSender messageSender;

    public NotificationService(MessageSender messageSender) {
        this.messageSender = messageSender;
    }

    public void notify(String message) {
        messageSender.sendMessage(message);
    }
}

// 사용 예시
MessageSender emailSender = new EmailSender();
NotificationService service = new NotificationService(emailSender);
service.notify("Hello!");
```

---

### 추가적인 객체 지향 설계 원칙

#### 1. 캡슐화 (Encapsulation)

객체의 데이터를 외부에서 직접 접근하지 못하도록 **데이터를 은닉**하고, 필요한 경우 메서드를 통해 접근하도록 한다. 이를 통해 데이터의 무결성을 유지하고, 외부로부터 객체 내부 구현을 보호할 수 있다.

```java
class BankAccount {
    private double balance;

    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
        }
    }

    public double getBalance() {
        return balance;
    }
}
```

#### 2. 다형성 (Polymorphism)

다형성은 **같은 타입이지만 서로 다른 구현을 가진 객체를 동일한 방식으로 사용할 수 있는 능력**이다. 인터페이스나 상속을 통해 여러 객체를 동일한 방식으로 처리할 수 있어, 코드의 확장성과 유연성을 높인다.

```java
interface Shape {
    void draw();
}

class Circle implements Shape {
    public void draw() {
        System.out.println("Draw Circle");
    }
}

class Rectangle implements Shape {
    public void draw() {
        System.out.println("Draw Rectangle");
    }
}

public class Main {
    public static void main(String[] args) {
        Shape shape1 = new Circle();
        Shape shape2 = new Rectangle();

        shape1.draw(); // "Draw Circle"
        shape2.draw(); // "Draw Rectangle"
    }
}
```

#### 3. 추상화 (Abstraction)

추상화는 **필요한 부분만 노출하고 복잡한 구현은 숨기는 것**을 의미한다. 불필요한 세부 정보를 숨기고 핵심적인 부분만 강조하여 코드의 가독성과 유지보수성을 높인다.

```java
abstract class Animal {
    public abstract void sound();
}

class Dog extends Animal {
    public void sound() {
        System.out.println("Bark");
    }
}
```

#### 4. 정보 은닉 (Information Hiding)

정보 은닉은 **외부에서 불필요하게 접근할 수 있는 정보를 제한**하여, 객체의 무결성을 유지하고 외부로부터 영향을 최소화하도록 하는 개념이다. 데이터 필드에 접근 제어자를 사용해 직접 접근을 막고 메서드를 통해 필요한 정보를 제공하도록 한다.

---

### 객체 지향 설계 원칙의 중요성

Java의 객체 지향 설계 원칙은 코드를 구조화하여 **유지보수와 확장성을 높이고**, **재사용성을 증대시키며**, **응집도와 결합도를 적절하게 관리**함으로써 소프트웨어 개발의 복잡성을 줄인다.

이러한 원칙들은 코드 품질을 높이고 버그 발생 가능성을 줄이며, 대규모 애플리케이션에서도 효율적으로 적용할 수 있는 지침이 된다.
