---
title: "[Java] 객체 지향 설계 원칙"
date: 2024-11-03 10:00:50 +0900
categories: [Backend, Java]
tags: ["java", "객체-지향", "설계-원칙"]
tistory_url: https://yoon-ssi.tistory.com/103
render_with_liquid: false
---

객체 지향 설계 원칙은 코드를 재사용하기 쉽고, 바꾸기 쉽고, 유지보수하기 쉽게 만들기 위한 가이드라인이다. 대표적인 게 SOLID 원칙이고, 그 외에도 몇 가지 원칙이 더 있다.

이 원칙들은 객체 사이의 관계를 분명하게 정리하고, 코드를 모듈 단위로 나눠서 복잡도를 낮추는 데 목적이 있다.

---

### SOLID 원칙

객체 지향 설계의 기본 원칙 5가지의 앞 글자를 딴 말이다. 이걸 지키면 확장하기 쉽고 유지보수하기 쉬운 코드를 만들 수 있다.

#### 1. 단일 책임 원칙 (Single Responsibility Principle, SRP)

> 클래스는 하나의 책임만 가져야 한다.

클래스 하나는 기능 하나만 맡아야 한다는 원칙이다. 다르게 말하면 클래스가 바뀌어야 하는 이유는 딱 하나여야 한다. 여러 역할을 떠안은 클래스는 코드가 복잡해지고, 하나를 고치면 다른 기능까지 영향을 받는다.

예) 학생 정보를 관리하는 시스템에서 학생 클래스는 이름, 나이, 학번 같은 속성만 맡아야 한다. 성적 계산 메서드까지 학생 클래스에 넣으면 SRP 위반이다.

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

> 확장에는 열려 있어야 하고, 수정에는 닫혀 있어야 한다.

기존 코드를 고치지 않고도 기능을 늘릴 수 있게 설계하라는 원칙이다. 기능을 추가할 때는 기존 코드를 건드리는 대신 새 클래스를 만들어서 확장한다.

예) 쇼핑몰에 고정 할인과 추가 할인 정책이 있다면, 할인 정책 인터페이스를 하나 정의하고 정책마다 새 클래스로 구현한다.

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

> 상위 클래스의 인스턴스를 하위 클래스 객체로 치환하더라도 시스템이 정상적으로 작동해야 한다.

상속 관계에서 상위 클래스 인스턴스 자리에 하위 클래스 인스턴스를 넣어도 프로그램이 문제없이 돌아가야 한다는 원칙이다. 하위 클래스는 상위 클래스의 기능을 그대로 유지하거나 확장해야 하고, 기능을 제한하거나 의도와 다르게 바꾸면 안 된다.

예) 사각형과 정사각형을 생각해보자. 정사각형을 사각형의 하위 클래스로 만들 수는 있지만, 그러면 너비와 높이를 따로 설정하는 메서드를 제대로 쓸 수 없게 된다. 그래서 정사각형이 사각형을 상속하는 건 LSP 위반이다.

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

> 클라이언트는 자신이 사용하지 않는 메서드에 의존하지 않아야 한다.

인터페이스를 작고 구체적으로 나눠서, 클라이언트가 쓰지도 않는 메서드에 묶이지 않게 하라는 원칙이다. 거대한 인터페이스 하나를 만들면 구현하는 클래스가 필요 없는 메서드까지 구현해야 할 수 있다.

예) 물고기는 수영만 하고 새는 날기만 하는데, 둘 다 같은 동물 인터페이스에 수영과 날기가 다 들어 있으면 쓸데없는 의존성이 생긴다.

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

> 상위 모듈이 하위 모듈에 의존해서는 안 되며, 둘 다 추상화에 의존해야 한다.

상위 모듈과 하위 모듈이 서로 직접 의존하지 않고 둘 다 추상화에 의존하게 하라는 원칙이다. 객체 간 결합도가 낮아져서 코드를 바꾸거나 재사용하기 쉬워진다.

예) 메시지 전송 기능을 만들 때 특정 전송 방식에 묶이지 않도록 추상화를 거쳐 구현한다.

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

### 그 밖의 객체 지향 설계 원칙

#### 1. 캡슐화 (Encapsulation)

객체의 데이터를 밖에서 직접 건드리지 못하게 숨기고, 필요하면 메서드를 통해서만 접근하게 한다. 데이터가 엉뚱하게 바뀌는 걸 막고 객체 내부 구현을 보호할 수 있다.

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

같은 타입이지만 구현이 다른 객체들을 같은 방식으로 다룰 수 있는 능력이다. 인터페이스나 상속으로 여러 객체를 똑같이 처리할 수 있으니 확장하기 쉽고 유연해진다.

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

필요한 부분만 드러내고 복잡한 구현은 숨기는 거다. 세부 사항을 감추고 핵심만 보이게 해서 코드를 읽고 고치기 쉽게 만든다.

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

밖에서 굳이 알 필요 없는 정보에 접근하지 못하게 막아서, 객체 상태를 지키고 외부 영향을 줄이는 개념이다. 필드에 접근 제어자를 걸어 직접 접근을 막고, 필요한 정보는 메서드로 내준다.

---

### 정리

결국 이 원칙들은 응집도는 높이고 결합도는 낮춰서, 코드가 커져도 고치고 늘리기 쉽게 만들자는 얘기다. 지켜두면 버그가 생길 여지도 줄고, 큰 애플리케이션에서도 구조가 덜 무너진다.
