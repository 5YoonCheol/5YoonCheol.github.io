---
title: "[Java] DTO와 VO 개념과 차이"
date: 2024-08-28 02:02:58 +0900
categories: [Backend, Java]
tags: ["dto", "java", "vo", "개념", "차이"]
tistory_url: https://yoon-ssi.tistory.com/35
render_with_liquid: false
---

DTO(Data Transfer Object)와 VO(Value Object)는 둘 다 데이터를 담는 객체라서 헷갈리기 쉽다. 하지만 만드는 목적도 쓰는 방법도 다르다.

이번엔 각각이 뭔지, 그리고 뭐가 다른지 정리해보자!!

---

### DTO (Data Transfer Object)

DTO는 이름 그대로 데이터를 전달하려고 만든 객체다. DB나 서비스 레이어에서 가져온 데이터를 프레젠테이션 레이어나 클라이언트 같은 다른 계층으로 넘길 때 쓴다. 비즈니스 로직 없이 데이터를 담아서 옮기는 역할만 한다.

#### 특징

- 데이터를 묶어서 보내기 쉽다: 여러 필드를 한 덩어리로 묶어서 한 번에 전달할 수 있다.
- 엔티티와 분리된다: DB 엔티티와 1:1로 맞출 수도 있지만, 여러 엔티티의 데이터를 조합해서 만들기도 한다. 엔티티는 DB 구조를 반영하고, DTO는 전달하기 좋은 구조로 만든다.
- 직렬화할 수 있다: 네트워크로 보내거나 파일로 저장할 수 있게 직렬화(Serialization)를 지원한다.
- 구조가 단순하다: getter와 setter 말고는 별다른 로직 없이 필요한 데이터만 담는다.

#### 어디에 쓰나

- REST API의 응답 데이터. 클라이언트가 요청한 데이터를 서버에서 처리하고 DTO로 만들어 돌려준다.
- 프레젠테이션 레이어와 서비스 레이어 사이의 데이터 전달.
- 계층 간 데이터 변환. 예를 들어 DB에서 엔티티를 가져와 화면에 맞게 가공해서 DTO로 넘긴다.

---

### VO (Value Object)

VO는 어떤 값 하나를 표현하는 객체다. 핵심은 불변성과 값 기반의 동일성이다. 값이 같으면 같은 객체로 본다. 그리고 DTO와 달리 비즈니스 로직을 가질 수 있다. 주로 그 값의 의미와 관련된 로직, 예를 들어 값을 계산하거나 비교하는 로직이 들어간다.

#### 특징

- 불변(Immutable): 한 번 만들어지면 상태가 바뀌지 않는다. 값이 바뀌어야 하면 새 VO를 만든다. 덕분에 프로그램이 안정적이고 예측하기 쉬워진다.
- 값으로 비교: 참조가 아니라 안에 든 값으로 비교한다. 그래서 equals()와 hashCode()를 오버라이딩한다.
- 비즈니스 로직 포함: 특정 비즈니스 개념을 표현하면서 관련 로직을 가질 수 있다. 금액을 표현하는 Money VO라면 금액 더하기, 비교 같은 로직을 갖는 식이다.
- 도메인 모델의 일부: 도메인 모델에서 값 자체의 의미를 드러내는 데 쓴다. DDD(도메인 주도 설계)에서 특히 중요하게 다룬다.

#### 어디에 쓰나

- 금액, 날짜, 시간 같은 비즈니스 개념. Money 객체는 금액을, Date 객체는 날짜를 표현한다.
- 주소(Address), 좌표(Point). 주소 VO는 도시, 도로명, 우편번호 같은 요소를 담고, 각 요소는 바뀌지 않는다.
- 복잡한 걸 간단하게 표현할 때. 예를 들어 FullName VO로 이름과 성을 합친 전체 이름을 표현할 수 있다.

---

### DTO와 VO의 차이점

1. 목적
   - DTO는 계층 사이에서 데이터를 옮기는 게 목적이다. 그래서 단순한 구조체에 가깝고, 주로 DB 엔티티와 클라이언트 사이 데이터를 나르는 데 쓴다.
   - VO는 특정 값을 표현하고 그 값에 대한 로직을 담는 게 목적이다. 도메인 모델의 개념을 구현하는 데 무게가 있다.
2. 불변성
   - DTO는 불변일 필요가 없고, 전달 과정에서 값이 바뀔 수 있다.
   - VO는 불변이다. 한 번 만들면 상태가 안 바뀌고, 바꾸려면 새 VO를 만들어야 한다.
3. 비즈니스 로직
   - DTO는 로직 없이 데이터를 담고 전달하는 데만 집중한다.
   - VO는 값과 관련된 로직을 가질 수 있고, 값에 대한 연산이나 검증을 한다.
4. 쓰이는 곳
   - DTO는 데이터를 옮기고 변환해야 하는 서비스 계층, 프레젠테이션 계층에서 쓴다.
   - VO는 도메인 모델에서 비즈니스 개념을 표현할 때 쓴다.
5. 구성
   - DTO는 전달이 목적이라 여러 엔티티의 데이터를 섞거나 필요한 것만 골라 담을 수 있다.
   - VO는 도메인에서 일관된 개념을 나타내야 해서 정해진 구성 요소만 갖고, 필요하면 로직을 내장한다.

---

설명만 봐서는 감이 잘 안 올 수 있으니 예시로 보자.

### 1. DTO 예시

온라인 쇼핑몰에서 상품 정보를 클라이언트로 보내야 하는 상황이다. 상품 정보를 담을 DTO를 만든다.

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

ProductDTO는 상품 이름(name), 가격(price), 설명(description) 필드를 갖고 있다. 데이터를 전달하는 용도라 비즈니스 로직은 없다. 서비스 레이어나 컨트롤러에서 이 DTO를 만들어 클라이언트에 보내면, 클라이언트는 이걸로 상품 정보를 화면에 보여준다.

### 2. VO 예시

쇼핑몰에서 금액을 표현할 VO를 만들어보자. 이 VO는 금액 더하기, 비교 같은 기능을 갖는다.

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

- Money는 금액을 표현하는 VO로, BigDecimal 타입의 amount 필드를 갖는다.
- 생성자로 만들어진 뒤에는 값이 바뀌지 않는다(불변).
- 금액을 더하는 add(), 금액을 비교하는 isGreaterThan() 같은 비즈니스 로직이 들어 있다. add()도 기존 값을 바꾸지 않고 새 Money를 돌려준다.
- equals()와 hashCode()를 오버라이딩해서 금액 값이 같으면 같은 객체로 본다.
- 금액 관련 로직이 Money 안에 들어 있으니, Money를 쓰는 쪽 코드는 금액 처리를 신경 쓰지 않고 간단하게 쓸 수 있다.

### 실제로는 이렇게 쓴다

- DTO: 쇼핑몰 백엔드가 REST API로 상품 정보를 내줄 때 ProductDTO에 담아 보낸다. 클라이언트는 받은 데이터를 화면에 그린다.
- VO: 결제 모듈에서 Money VO로 상품 가격, 할인 금액, 세금을 다루고 최종 결제 금액을 계산한다. 더하기와 비교 같은 작업을 Money가 맡아준다.

---

### 정리

DTO와 VO는 목적과 쓰임새가 분명히 다르다. 섞어서 쓰면 시스템이 복잡해지고 코드가 무슨 의도인지 알기 어려워진다.

DTO는 데이터를 간단히 옮기는 데, VO는 어떤 개념을 표현하고 그와 관련된 로직을 처리하는 데 쓴다. 둘을 제자리에 맞게 쓰면 유지보수하기 좋고 안정적인 코드가 된다.
