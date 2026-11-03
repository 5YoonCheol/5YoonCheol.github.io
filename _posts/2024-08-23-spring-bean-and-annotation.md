---
title: "[Spring] Bean과 Annotation"
date: 2024-08-23 07:07:15 +0900
categories: [Backend, Spring]
tags: ["annotation", "bean", "java", "spring", "빈", "스프링", "어노테이션", "자바"]
tistory_url: https://yoon-ssi.tistory.com/29
render_with_liquid: false
---

Bean과 Annotation은 Java와 Spring 프레임워크에서 매우 중요한 개념으로, 객체의 관리와 메타데이터를 통해 다양한 기능을 제공하는 역할을 한다.

오늘 포스팅에서는 이 두 개념에 대해서 설명한다.

---

### 1. Bean

#### 1.1 Bean이란?

Bean은 자바 객체를 의미하며, 특히 Spring에서는 Spring IoC(Inversion of Control) 컨테이너에 의해 관리되는 객체를 가리킨다. 즉, Bean은 Spring 컨테이너가 생성하고, 관리하며, 애플리케이션이 필요로 할 때 주입되는 객체를 의미한다.

#### 1.2 Bean의 생명주기

Spring에서 Bean은 다음과 같은 생명주기를 가진다:

1. **생성**: Bean은 Spring 컨테이너에 의해 생성된다.
2. **의존성 주입**: 필요한 의존성이 주입된다. 이때 @Autowired 등의 애노테이션을 사용하여 의존성을 자동으로 주입할 수 있다.
3. **초기화**: Bean이 초기화된다. 초기화 메서드는 @PostConstruct 애노테이션이나 InitializingBean 인터페이스의 afterPropertiesSet() 메서드를 통해 지정할 수 있다.
4. **사용**: 애플리케이션에서 Bean이 사용된다.
5. **소멸**: 애플리케이션이 종료되거나 Bean이 더 이상 필요하지 않을 때, Bean이 소멸된다. 이때 @PreDestroy 애노테이션이나 DisposableBean 인터페이스의 destroy() 메서드를 통해 소멸 작업을 수행할 수 있다.

#### 1.3 Bean의 등록 방법

Spring에서 Bean을 등록하는 방법은 크게 두 가지가 있다:

- XML 파일을 사용한 등록: 예전 방식으로, applicationContext.xml 파일에 Bean 정의를 작성한다.

```
<bean id="myBean" class="com.example.MyBean"/>
```

- 자바 설정 파일과 애노테이션을 사용한 등록: 현재 가장 많이 사용되는 방식으로, @Configuration 클래스와 @Bean 애노테이션을 사용하여 등록한다.

```
@Configuration
public class AppConfig {
    @Bean
    public MyBean myBean() {
        return new MyBean();
    }
}
```

이 방식에서는 AppConfig 클래스가 Spring의 설정 클래스로 사용되며, myBean 메서드는 MyBean 타입의 Bean을 생성하고 Spring 컨테이너에 등록한다.

---

### 2. Annotation

#### 2.1 Annotation이란?

Annotation은 자바에서 메타데이터를 제공하는 역할을 하는 특수한 형태의 주석이다. 주로 컴파일러에게 정보를 제공하거나, 런타임에 특정 동작을 수행하도록 지시할 때 사용된다.

자바의 Annotation은 메서드, 클래스, 변수, 파라미터 등에 추가할 수 있으며, 이를 통해 코드의 동작을 유연하게 제어할 수 있다.

#### 2.2 Spring에서의 주요 Annotation

Spring 프레임워크에서는 다양한 Annotation을 통해 Bean의 관리와 애플리케이션 로직을 간편하게 설정할 수 있다.

1. **@Component, @Service, @Repository, @Controller**
   - 이들 애노테이션은 클래스에 붙여서 Spring 컨테이너에 자동으로 Bean으로 등록되게 한다.
   - @Component: 일반적인 Bean을 정의할 때 사용한다.
   - @Service: 비즈니스 로직을 담고 있는 서비스 클래스에 사용한다.
   - @Repository: 데이터 액세스 계층을 나타내며, 데이터베이스 예외를 Spring 예외로 변환하는 역할을 한다.
   - @Controller: 웹 애플리케이션에서 컨트롤러 클래스를 나타내며, 웹 요청을 처리한다.
2. **@Autowired**
   - Spring 컨테이너가 관리하는 Bean을 자동으로 주입할 때 사용한다. 생성자, 필드, 메서드에 붙일 수 있다.
   - 예를 들어, 서비스 클래스에 다른 서비스를 주입하고자 할 때 다음과 같이 사용한다:

```java
@Service
public class MyService {
    @Autowired
    private OtherService otherService;
}
```

3. **@Configuration과 @Bean**
   - @Configuration: 자바 기반의 Spring 설정 클래스를 정의할 때 사용한다. 이 클래스 내부에 @Bean 메서드를 포함하여 Spring 컨테이너에 Bean을 등록한다.
   - @Bean: 메서드에 붙여서 해당 메서드가 반환하는 객체를 Spring 컨테이너가 관리하는 Bean으로 등록한다.

```java
@Configuration
public class MyConfig {
    @Bean
    public MyBean myBean() {
        return new MyBean();
    }
}
```

4. **@Qualifier**

- 여러 Bean 중 특정 Bean을 주입하고자 할 때 사용한다. @Autowired와 함께 사용되며, 주입할 Bean의 이름을 명시할 수 있다.

```java
@Autowired
@Qualifier("specificBean")
private MyBean myBean;
```

5. **@Scope**

- Bean의 범위를 설정할 때 사용한다. 기본적으로 Spring의 Bean은 싱글톤(Singleton) 범위를 가지며, @Scope를 통해 다른 범위를 설정할 수 있다.
- 주요 스코프:
  - singleton: 하나의 Bean 인스턴스를 공유한다. (기본값)
  - prototype: 매번 새로운 인스턴스를 생성한다.
  - request, session: 웹 애플리케이션에서 각각의 HTTP 요청 또는 세션마다 Bean 인스턴스를 생성한다.

6. **@PostConstruct와 @PreDestroy**

- @PostConstruct: Bean의 초기화가 완료된 후 호출될 메서드를 지정한다.
- @PreDestroy: Bean이 소멸되기 전에 호출될 메서드를 지정한다.

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

### 3. Bean과 Annotation의 상호작용

Spring 프레임워크에서 Bean과 Annotation은 긴밀하게 상호작용한다. Annotation을 사용하면 Bean의 등록, 주입, 생명주기 관리 등 다양한 작업을 간편하게 처리할 수 있다.

- **Bean 등록**: @Component, @Service, @Repository, @Controller 등을 사용하여 Bean을 등록할 수 있다.   
  또는 @Configuration 클래스와 @Bean 메서드를 사용하여 수동으로 Bean을 등록할 수도 있다.
- **의존성 주입**: @Autowired와 @Qualifier를 사용하여 필요한 Bean을 자동으로 주입할 수 있다.
- **Bean의 생명주기 관리**: @PostConstruct, @PreDestroy를 사용하여 Bean의 초기화 및 소멸 시점을 제어할 수 있다.

이와 같은 방식으로, Spring에서는 Bean과 Annotation을 활용하여 객체를 관리하고, 애플리케이션의 구조를 단순화하며, 유지보수성을 높인다. Annotation 덕분에 XML 설정을 최소화하고, 자바 코드 내에서 직접 설정할 수 있어 개발의 생산성과 효율성을 크게 향상시킬 수 있다.
