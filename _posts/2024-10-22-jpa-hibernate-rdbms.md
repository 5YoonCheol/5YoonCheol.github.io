---
title: "JPA와 Hibernate를 통한 RDBMS 연계방법"
date: 2024-10-22 11:11:30 +0900
categories: [Backend, JPA]
tags: ["hibernate", "jpa"]
tistory_url: https://yoon-ssi.tistory.com/91
render_with_liquid: false
---

JPA(Java Persistence API)와 Hibernate는 자바 애플리케이션에서 관계형 DB(RDBMS)를 쉽게 다룰 수 있게 해주는 ORM(Object-Relational Mapping) 기술이다. JPA는 자바 표준 인터페이스이고, Hibernate는 그 표준을 구현한 대표적인 프레임워크다. 이걸 쓰면 SQL을 직접 짜지 않아도 자바 객체와 DB 테이블을 자동으로 연결할 수 있다.

---

### JPA 기본 개념

JPA는 자바 객체를 DB 테이블에 매핑해서, 객체 지향과 관계형 DB 사이의 어긋남을 메워준다. 애플리케이션은 DB와 직접 대화하지 않고 JPA를 통해 객체로 데이터를 주고받는다.

#### 1. Entity

DB 테이블에 매핑되는 자바 클래스다. 클래스에 @Entity를 붙이고, 필드는 테이블 컬럼에 매핑된다.

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

#### 2. EntityManager

JPA에서 실제로 DB와 주고받는 주체다. 엔티티를 저장, 조회, 수정, 삭제할 때 EntityManager를 쓴다. 트랜잭션을 관리하고, SQL을 만들어 DB에 보내는 것도 이 녀석이 한다.

```java
EntityManager em = entityManagerFactory.createEntityManager();
em.getTransaction().begin();

// 새로운 엔티티 저장
User user = new User();
user.setName("Alice");
em.persist(user); // insert SQL을 실행

em.getTransaction().commit();
```

#### 3. JPQL(Java Persistence Query Language)

JPA는 JPQL이라는 객체 지향 쿼리 언어를 쓴다. SQL이랑 비슷하게 생겼지만 테이블이 아니라 엔티티를 대상으로 조회한다. 아래는 User 엔티티를 조회하는 JPQL이다.

```java
String jpql = "SELECT u FROM User u WHERE u.name = :name";
List<User> users = em.createQuery(jpql, User.class)
                     .setParameter("name", "Alice")
                     .getResultList();
```

---

### Hibernate가 하는 일

Hibernate는 JPA 구현체로, JPA에 정의된 기능이 실제로 돌아가게 만든다. 여기에 Hibernate만의 기능도 있어서 선택지와 성능 최적화 방법이 더 많다. 대표적인 걸 몇 개 보자.

#### 1. 캐싱

1차 캐시와 2차 캐시가 있다. 1차 캐시는 같은 트랜잭션 안에서 DB에서 가져온 엔티티를 메모리에 들고 있다가 재사용한다. 2차 캐시는 트랜잭션을 넘어서 엔티티를 캐싱해서 DB 부하를 줄인다.

#### 2. N+1 문제 대응

연관된 데이터를 조회할 때 생기는 N+1 문제를 줄이기 위해 fetch 전략을 제공한다. @OneToMany, @ManyToOne 같은 관계에 fetch 모드를 지정해서 필요한 데이터만 가져오게 할 수 있다.

```java
@OneToMany(fetch = FetchType.LAZY) // 지연 로딩으로 N+1 문제 방지
private List<Order> orders;
```

#### 3. DDL 자동 생성

애플리케이션이 뜰 때 엔티티 클래스를 보고 테이블을 자동으로 만들 수 있다. hibernate.hbm2ddl.auto 설정으로 켠다.

```java
hibernate.hbm2ddl.auto=update
```

update로 두면 엔티티가 바뀔 때마다 스키마를 자동으로 맞춰준다. 개발할 땐 편하지만 운영 환경에서는 조심해야 한다.

---

### JPA/Hibernate 연동 순서

1. 엔티티 클래스 작성: 자바 클래스에 @Entity를 붙여 엔티티로 만든다. 필드는 테이블 컬럼에 대응된다.
2. Persistence 설정: persistence.xml에 DB 연결 정보와 JPA 구현체(Hibernate)를 설정한다.

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

3. EntityManager 사용: EntityManager로 데이터를 넣고, 조회하고, 수정하고, 지운다. 트랜잭션도 EntityManager가 관리한다.

```java
EntityManager em = entityManagerFactory.createEntityManager();
em.getTransaction().begin();

User user = new User();
user.setName("Alice");
em.persist(user);  // 엔티티 저장

em.getTransaction().commit();
```

이렇게 하면 복잡한 SQL을 직접 쓰지 않고도 자바 객체와 DB를 연결할 수 있다. ORM 덕분에 DB 연동 코드가 훨씬 직관적이 되고 생산성도 올라간다.
