---
title: "[Java] DTO와 VO 개념과 차이"
date: 2024-08-28 02:02:58 +0900
categories: [Backend, Java]
tags: ["dto", "java", "vo", "개념", "차이"]
tistory_url: https://yoon-ssi.tistory.com/35
render_with_liquid: false
---

Java에서 **DTO**(Data Transfer Object)와 **VO**(Value Object)는 객체지향 프로그래밍에서 자주 사용되는 개념으로, 데이터를 캡슐화하는 데 사용되지만 그 목적과 사용 방법이 다르다.

오늘 포스팅에서는 각 개념을 자세히 설명하고, 이들의 차이점에 대해 알아보자!!

---

### DTO (Data Transfer Object)

**DTO**는 주로 **데이터를 전송**하기 위해 설계된 객체이다. 데이터베이스나 서비스 레이어에서 데이터를 가져와서 다른 계층, 예를 들어 프레젠테이션 레이어나 클라이언트로 전달할 때 사용된다. DTO는 데이터의 전송에 최적화되어 있으며, 일반적으로 비즈니스 로직은 포함하지 않고 데이터를 단순히 담고 전달하는 역할만 한다.

- **기능과 특징:**
  - **데이터 전송의 용이성**: DTO는 데이터를 캡슐화하여 전송하기 쉽게 해 준다. 여러 필드의 데이터를 한꺼번에 그룹화하여 전송할 수 있다.
  - **엔티티와 분리**: 데이터베이스 엔티티와 1:1로 매핑될 수도 있지만, 보통은 여러 엔티티의 데이터를 조합하여 만들어지기도 한다. 엔티티는 주로 데이터베이스 구조를 반영하고, DTO는 전송에 적합한 구조로 설계된다.
  - **직렬화 가능**: 네트워크를 통해 데이터를 전송하거나 파일로 저장할 때 사용할 수 있도록 직렬화(Serialization)를 지원한다.
  - **단순한 구조**: getter와 setter 메서드 외에는 별다른 로직이 없으며, 필요한 데이터만 담고 있다.
- **실제 사용 예:**
  - REST API의 **응답 데이터**로 사용된다. 클라이언트가 요청한 데이터를 서버에서 처리한 후 DTO로 만들어 응답할 수 있다.
  - 프레젠테이션 레이어와 서비스 레이어 사이의 **데이터 전달**에 사용된다.
  - 다양한 계층 간 **데이터 변환**을 수행할 때 사용된다. 예를 들어, 데이터베이스에서 엔티티를 가져와서 화면에 표시할 때 그 데이터를 가공하여 DTO로 전달한다.

---

### VO (Value Object)

**VO**는 특정 값을 표현하는 객체로, **불변성**과 **동일성**이 중요한 개념이다. VO는 실제로 같은 값을 가지는 객체는 동일한 것으로 간주하며, 비즈니스 로직을 포함할 수 있다. 주로 값 자체의 의미와 관련된 로직을 포함하여, 값을 처리하거나 비교할 때 사용된다.

- **기능과 특징**
  - **불변성(Immutable)**: VO 객체는 생성된 이후에는 상태가 변경되지 않는다. 값이 변경되면 새로운 VO 객체를 생성한다. 이는 프로그램의 안정성과 예측 가능성을 높이는데 도움을 준다.
  - **값 비교**: VO는 객체의 참조가 아니라 **내부 값**을 기준으로 비교한다. 따라서 equals()와 hashCode() 메서드를 오버라이딩하여 값 비교를 수행한다.
  - **비즈니스 로직 포함**: VO는 특정 비즈니스 개념을 표현하며, 이와 관련된 로직을 포함할 수 있다. 예를 들어, 금액을 표현하는 Money VO는 금액의 합산, 비교 등의 로직을 가질 수 있다.
  - **도메인 모델의 일부분**: VO는 도메인 모델에서 중요한 역할을 하며, 값 자체의 의미를 강조하는 데 사용된다. 도메인 주도 설계(DDD)에서 특히 중요한 역할을 한다.
- **실제 사용 예**
  - **금액, 날짜, 시간** 같은 비즈니스 개념을 표현할 때 사용된다. 예를 들어, Money 객체는 금액을 표현하고, Date 객체는 특정 날짜를 표현한다.
  - **주소(Address), 좌표(Point)** 등도 VO로 사용된다. 주소를 표현하는 VO는 도시, 도로명, 우편번호 등 다양한 구성 요소를 포함하며, 각각의 구성 요소는 불변성을 가진다.
  - **복잡한 로직**을 간단하게 표현하기 위해 사용된다. 예를 들어, FullName VO는 이름과 성을 결합하여 하나의 전체 이름을 표현할 수 있다.

---

### DTO와 VO의 차이점

1. **목적의 차이**
   - **DTO**는 계층 간 **데이터 전송**을 목적으로 하며, 데이터 전송을 위한 단순한 구조체이다. DTO는 주로 데이터베이스 엔티티와 클라이언트 간의 데이터를 전송하는 데 사용된다.
   - **VO**는 특정 **값을 표현**하고, 그 값에 대한 비즈니스 로직을 포함하는 데 사용된다. VO는 도메인 모델에서 중요한 개념을 구현하는 데 중점을 둔다.
2. **불변성의 차이**
   - **DTO**는 불변성을 강제하지 않으며, 데이터를 전송하는 과정에서 수정될 수 있다.
   - **VO**는 불변성을 유지하며, 한 번 생성된 후에는 상태가 변경되지 않는다. 값이 바뀔 필요가 있다면 새로운 VO 객체를 생성해야 한다.
3. **비즈니스 로직 포함 여부**
   - **DTO**는 비즈니스 로직을 포함하지 않고, 순수하게 데이터를 담고 전달하는 데 집중한다.
   - **VO**는 특정 값과 관련된 비즈니스 로직을 포함할 수 있으며, 값에 대한 연산이나 검증을 수행한다.
4. **사용되는 컨텍스트의 차이**
   - **DTO**는 주로 데이터의 이동과 변환이 필요한 서비스 계층이나 프레젠테이션 계층에서 사용된다.
   - **VO**는 도메인 모델에서 특정 비즈니스 개념을 표현하는 데 사용되며, 값 자체의 의미를 강조한다.
5. **데이터 구성의 차이**
   - **DTO**는 데이터 전송을 목적으로 하기 때문에 여러 엔티티의 데이터를 조합하거나, 특정 데이터만 선택적으로 포함할 수 있다.
   - **VO**는 도메인에서 일관된 개념을 나타내기 위해 정해진 구성 요소만 포함하며, 필요에 따라 특정 로직을 내장할 수 있다.

---

이론적인 설명만으로는 이해하기 힘들 수 있기 때문에 예시를 좀 더 살펴보자.

### 1. DTO (Data Transfer Object) 예시

**상황**: 온라인 쇼핑몰에서 상품 정보를 클라이언트로 전송해야 하는 상황.  
상품 정보를 담기 위해 DTO를 사용할 수 있다.

```java
public class ProductDTO {
    private String name;
    private double price;
    private String description;

    // 기본 생성자
    public ProductDTO() {}

    // 모든 필드를 사용하는 생성자
    public ProductDTO(String name, double price, String description) {
        this.name = name;
        this.price = price;
        this.description = description;
    }

    // Getter와 Setter
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
```

**설명**

- ProductDTO 클래스는 상품의 이름(name), 가격(price), 설명(description)과 같은 필드를 가진다.
- 이 클래스는 데이터를 단순히 전달하는 데 사용되며, 비즈니스 로직은 포함되지 않는다.
- 서비스 레이어나 컨트롤러에서 이 DTO를 생성하여 클라이언트에 전달하면, 클라이언트는 이 DTO를 사용해 상품 정보를 화면에 표시할 수 있다.

### 2. VO (Value Object) 예시

**상황**: 쇼핑몰에서 금액을 표현할 때 사용하는 VO를 정의한다. 이 VO는 금액의 합산, 비교 등의 기능을 가지고 있다.

```java
import java.math.BigDecimal;
import java.util.Objects;

public class Money {
    private final BigDecimal amount;

    // 생성자
    public Money(BigDecimal amount) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("금액은 null이거나 음수일 수 없습니다.");
        }
        this.amount = amount;
    }

    // 금액 더하기
    public Money add(Money other) {
        return new Money(this.amount.add(other.amount));
    }

    // 금액 비교
    public boolean isGreaterThan(Money other) {
        return this.amount.compareTo(other.amount) > 0;
    }

    // Getter
    public BigDecimal getAmount() {
        return amount;
    }

    // equals와 hashCode 메서드 오버라이딩
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Money money = (Money) o;
        return Objects.equals(amount, money.amount);
    }

    @Override
    public int hashCode() {
        return Objects.hash(amount);
    }

    @Override
    public String toString() {
        return "Money{" +
                "amount=" + amount +
                '}';
    }
}
```

**설명**

- Money 클래스는 금액을 표현하는 VO로, BigDecimal 타입의 amount 필드를 가진다.
- 생성자를 통해 VO가 생성된 후에는 그 값이 변경되지 않도록 불변성을 유지한다.
- 금액을 더하는 add() 메서드와 금액을 비교하는 isGreaterThan() 메서드와 같은 비즈니스 로직이 포함되어 있다.
- equals()와 hashCode() 메서드를 오버라이딩하여 VO의 동일성을 금액의 값으로 판단한다.
- Money VO는 도메인 모델에서 금액과 관련된 로직을 캡슐화하여, 이 VO를 사용하는 다른 코드에서는 금액 처리에 대한 복잡한 로직을 신경 쓸 필요 없이 간단하게 사용할 수 있다.

### DTO와 VO의 실제 사용 시나리오

- **DTO 사용 예시**: 쇼핑몰의 백엔드 서버가 REST API로 클라이언트에게 상품 정보를 제공할 때 ProductDTO를 사용하여 상품 데이터를 전송한다. 클라이언트는 이 데이터를 받아 UI에 표시한다.
- **VO 사용 예시**: 결제 모듈에서 Money VO를 사용하여 상품의 가격, 할인 금액, 세금 등을 처리하고, 최종 결제 금액을 계산한다. 이때 Money VO는 금액의 합산, 비교 등의 작업을 쉽게 처리할 수 있도록 도와준다.

---

### 요약

**DTO**와 **VO**는 각각의 목적과 사용 방식이 명확히 구분되며, 잘못 사용될 경우 시스템의 복잡성을 증가시키거나 코드의 명확성을 떨어뜨릴 수 있다.

**DTO**는 데이터를 간단히 전달하는 데 사용되고, **VO**는 특정 개념을 표현하고 비즈니스 로직을 처리하는 데 사용된다.

각 개념을 적절히 활용함으로써 코드의 유지보수성과 안정성을 높일 수 있다.
