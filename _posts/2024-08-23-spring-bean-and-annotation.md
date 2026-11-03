---
title: "[Spring] Bean과 Annotation"
date: 2024-08-23 02:00:00 +0900
categories: [Backend, Spring]
tags: ["annotation", "bean", "java", "spring", "빈", "스프링", "어노테이션", "자바"]
tistory_url: https://yoon-ssi.tistory.com/29
render_with_liquid: false
---

Spring을 쓰다 보면 Bean과 Annotation이라는 말을 정말 자주 보게 된다. Bean은 Spring이 관리하는 객체이고, Annotation은 그 객체를 어떻게 다룰지 알려주는 메타데이터다.

오늘은 이 두 개념을 정리해보자.

---

### 1. Bean

#### 1.1 Bean이란?

Bean은 자바 객체다. Spring에서는 특히 Spring IoC(Inversion of Control) 컨테이너가 관리하는 객체를 Bean이라고 부른다. 컨테이너가 만들고, 관리하고, 애플리케이션에서 필요할 때 주입해주는 객체라고 생각하면 된다.

#### 1.2 Bean의 생명주기

1. 생성: Spring 컨테이너가 Bean을 만든다.
2. 의존성 주입: 필요한 의존성을 넣어준다. `@Autowired` 같은 애노테이션으로 자동 주입할 수 있다.
3. 초기화: `@PostConstruct` 애노테이션이나 InitializingBean 인터페이스의 `afterPropertiesSet()` 메서드로 초기화 메서드를 지정할 수 있다.
4. 사용: 애플리케이션에서 Bean을 쓴다.
5. 소멸: 애플리케이션이 끝나거나 Bean이 더 필요 없으면 소멸된다. `@PreDestroy` 애노테이션이나 DisposableBean 인터페이스의 `destroy()` 메서드로 정리 작업을 할 수 있다.

#### 1.3 Bean 등록 방법

크게 두 가지다.

XML 파일로 등록하는 방법. 예전 방식으로, applicationContext.xml에 Bean 정의를 적는다.

```
<bean id="myBean" class="com.example.MyBean"/>
```

자바 설정 클래스와 애노테이션으로 등록하는 방법. 요즘은 대부분 이렇게 한다. `@Configuration` 클래스 안에 `@Bean` 메서드를 만든다.

```
@Configuration
public class AppConfig {
    @Bean
    public MyBean myBean() {
        return new MyBean();
    }
}
```

AppConfig가 Spring 설정 클래스가 되고, myBean 메서드가 MyBean 타입 Bean을 만들어 컨테이너에 등록한다.

---

### 2. Annotation

#### 2.1 Annotation이란?

자바에서 메타데이터를 붙이는 특수한 주석이다. 컴파일러에 정보를 주거나, 런타임에 어떤 동작을 하라고 알려줄 때 쓴다.

메서드, 클래스, 변수, 파라미터 등에 붙일 수 있고, 이걸로 코드 동작을 꽤 자유롭게 제어할 수 있다.

#### 2.2 Spring에서 자주 쓰는 Annotation

Spring은 Bean 관리나 애플리케이션 설정 대부분을 애노테이션으로 처리할 수 있게 해준다.

##### @Component, @Service, @Repository, @Controller

클래스에 붙이면 Spring 컨테이너에 Bean으로 자동 등록된다.

- `@Component`: 일반적인 Bean을 정의할 때 쓴다.
- `@Service`: 비즈니스 로직을 담은 서비스 클래스에 쓴다.
- `@Repository`: 데이터 접근 계층에 쓴다. 데이터베이스 예외를 Spring 예외로 바꿔주는 역할도 한다.
- `@Controller`: 웹 요청을 처리하는 컨트롤러 클래스에 쓴다.

##### @Autowired

컨테이너가 관리하는 Bean을 자동으로 주입할 때 쓴다. 생성자, 필드, 메서드에 붙일 수 있다. 서비스 클래스에 다른 서비스를 주입한다면 이렇게 쓴다.

```java
@Service
public class MyService {
    @Autowired
    private OtherService otherService;
}
```

##### @Configuration과 @Bean

- `@Configuration`: 자바 기반 설정 클래스를 만들 때 붙인다. 안에 `@Bean` 메서드를 넣어서 Bean을 등록한다.
- `@Bean`: 메서드에 붙이면 그 메서드가 반환하는 객체가 Bean으로 등록된다.

```java
@Configuration
public class MyConfig {
    @Bean
    public MyBean myBean() {
        return new MyBean();
    }
}
```

##### @Qualifier

같은 타입 Bean이 여러 개일 때 그중 하나를 골라서 주입하고 싶으면 쓴다. `@Autowired`와 같이 쓰고, 주입할 Bean 이름을 적어준다.

```java
@Autowired
@Qualifier("specificBean")
private MyBean myBean;
```

##### @Scope

Bean의 범위를 정한다. 기본은 싱글톤(Singleton)이고, `@Scope`로 바꿀 수 있다.

- singleton: Bean 인스턴스 하나를 공유한다. (기본값)
- prototype: 요청할 때마다 새 인스턴스를 만든다.
- request, session: 웹 애플리케이션에서 HTTP 요청마다, 세션마다 인스턴스를 만든다.

##### @PostConstruct와 @PreDestroy

- `@PostConstruct`: Bean 초기화가 끝난 뒤 호출할 메서드를 지정한다.
- `@PreDestroy`: Bean이 소멸되기 직전에 호출할 메서드를 지정한다.

```java
@Component
public class MyBean {
    @PostConstruct
    public void init() {
        System.out.println("Bean 초기화");
    }

    @PreDestroy
    public void destroy() {
        System.out.println("Bean 소멸");
    }
}
```

---

### 3. Bean과 Annotation은 같이 움직인다

Spring에서 Bean을 등록하고, 주입하고, 생명주기를 관리하는 일 대부분을 애노테이션으로 한다.

- Bean 등록: `@Component`, `@Service`, `@Repository`, `@Controller`로 등록하거나, `@Configuration` 클래스에 `@Bean` 메서드를 만들어 직접 등록한다.
- 의존성 주입: `@Autowired`와 `@Qualifier`로 필요한 Bean을 주입받는다.
- 생명주기 관리: `@PostConstruct`, `@PreDestroy`로 초기화와 소멸 시점에 할 일을 정한다.

예전에는 이걸 다 XML로 설정했는데, 애노테이션 덕분에 자바 코드 안에서 바로 설정할 수 있게 됐다.
