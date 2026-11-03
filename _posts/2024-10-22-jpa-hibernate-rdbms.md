---
title: "JPA와 Hibernate를 통한 RDBMS 연계방법"
date: 2024-10-22 11:11:30 +0900
categories: ["ETC"]
tags: ["hibernate", "jpa"]
tistory_url: https://yoon-ssi.tistory.com/91
render_with_liquid: false
---

JPA(Java Persistence API)와 Hibernate는 자바 애플리케이션에서 관계형 데이터베이스(RDBMS)와 쉽게 연계할 수 있도록 도와주는 ORM(Object-Relational Mapping) 기술이다. JPA는 자바 표준 인터페이스고, Hibernate는 그 표준을 구현한 대표적인 프레임워크 중 하나이다. JPA와 Hibernate를 사용하면 SQL을 직접 작성하지 않고도 자바 객체와 데이터베이스 테이블 간의 매핑을 자동으로 처리할 수 있다.

---

### JPA의 기본 개념

JPA는 자바 객체를 데이터베이스 테이블에 매핑하여 객체 지향 프로그래밍과 관계형 데이터베이스 사이의 불일치를 해소하는 역할을 한다. 자바 애플리케이션은 데이터베이스와 직접 상호작용하는 것이 아니라, JPA를 통해 객체와 데이터를 주고받는다.

**1. Entity**: 데이터베이스의 테이블에 매핑되는 자바 클래스이다. 각 엔티티 클래스는 @Entity 애너테이션을 사용하여 선언하고, 필드는 테이블의 컬럼에 매핑된다.

```java
@Entity
public class User {
    @Id // 기본 키를 나타냄
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String email;
}
```

**2. EntityManager**: JPA에서 데이터베이스와 상호작용하는 주체이다. 엔티티 객체를 생성, 조회, 수정, 삭제할 때 EntityManager를 사용한다. JPA의 핵심 인터페이스 중 하나로, 트랜잭션을 관리하거나 SQL을 생성해서 데이터베이스에 전달하는 역할을 한다.

```java
EntityManager em = entityManagerFactory.createEntityManager();
em.getTransaction().begin();

// 새로운 엔티티 저장
User user = new User();
user.setName("Alice");
em.persist(user); // insert SQL을 실행

em.getTransaction().commit();
```

**3. JPQL(Java Persistence Query Language)**: JPA는 객체 지향적인 쿼리 언어인 JPQL을 사용한다. JPQL은 SQL과 유사하지만, 테이블이 아니라 엔티티를 대상으로 질의한다. 예를 들어, 아래 쿼리는 User 엔티티를 대상으로 하는 JPQL이다.

```java
String jpql = "SELECT u FROM User u WHERE u.name = :name";
List<User> users = em.createQuery(jpql, User.class)
                     .setParameter("name", "Alice")
                     .getResultList();
```

---

### Hibernate의 역할

Hibernate는 JPA의 구현체로, JPA가 제공하는 기능을 실제로 동작하게 만들어주는 프레임워크이다. JPA 표준 외에도 Hibernate만의 고유한 기능을 제공해서 더 많은 옵션과 성능 최적화를 지원한다. 대표적인 Hibernate의 기능을 몇 가지 알아보자.

**1. 캐싱**: Hibernate는 1차 캐시와 2차 캐시를 제공한다. 1차 캐시는 동일한 트랜잭션 내에서 데이터베이스에서 가져온 엔티티를 메모리에 저장해서 성능을 최적화한다. 2차 캐시는 여러 트랜잭션에 걸쳐 엔티티를 캐싱할 수 있고, 데이터베이스 부하를 줄일 수 있다.

**2. N+1 문제 해결**: Hibernate는 관계형 데이터에서 발생하는 N+1 문제를 해결하기 위한 fetch 전략을 제공한다. @OneToMany, @ManyToOne과 같은 관계를 정의할 때 fetch 모드를 설정해서, 필요한 데이터만 효율적으로 조회할 수 있다.

```java
@OneToMany(fetch = FetchType.LAZY) // 지연 로딩으로 N+1 문제 방지
private List<Order> orders;
```

**3. DDL 자동 생성**: Hibernate는 애플리케이션 시작 시 엔티티 클래스를 기반으로 데이터베이스 테이블을 자동으로 생성할 수 있다. 이를 위해 hibernate.hbm2ddl.auto 설정을 사용할 수 있다.

```java
hibernate.hbm2ddl.auto=update
```

이 설정은 엔티티 클래스의 변경사항에 따라 데이터베이스 스키마를 자동으로 갱신해 주는데, 개발 단계에서는 유용하지만, 운영 환경에서는 주의해야 한다.

---

### JPA/Hibernate 연계 과정

**1. 엔티티 클래스 작성**: 먼저, 자바 클래스에 @Entity 애너테이션을 붙여 엔티티로 정의한다. 각 클래스 필드는 테이블의 컬럼에 대응된다.

**2. Persistence 설정**: persistence.xml 파일에서 데이터베이스 연결 정보와 JPA 구현체(Hibernate)를 설정한다.

```shell
<persistence-unit name="myUnit">
    <provider>org.hibernate.jpa.HibernatePersistenceProvider</provider>
    <properties>
        <property name="javax.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/mydb"/>
        <property name="javax.persistence.jdbc.user" value="user"/>
        <property name="javax.persistence.jdbc.password" value="password"/>
        <property name="hibernate.dialect" value="org.hibernate.dialect.MySQLDialect"/>
    </properties>
</persistence-unit>
```

**3. EntityManager 사용**: EntityManager를 통해 데이터를 삽입, 조회, 수정, 삭제할 수 있다. 이때 트랜잭션 관리는 EntityManager가 담당한다.

```java
EntityManager em = entityManagerFactory.createEntityManager();
em.getTransaction().begin();

User user = new User();
user.setName("Alice");
em.persist(user);  // 엔티티 저장

em.getTransaction().commit();
```

이 과정을 통해 JPA와 Hibernate는 개발자가 복잡한 SQL을 직접 작성하지 않고도 자바 객체와 데이터베이스 간의 매핑을 자동화하고, 데이터 접근을 간소화해 줄 수 있다. ORM을 사용하면 데이터베이스와의 연동이 더 직관적이고 생산성이 높아진다.
