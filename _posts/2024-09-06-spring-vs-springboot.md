---
title: "[Spring & SpringBoot] Spring과 SpringBoot의 차이점"
date: 2024-09-06 08:00:17 +0900
categories: ["Spring & SpringBoot"]
tags: ["spring", "springboot", "차이점", "특징"]
tistory_url: https://yoon-ssi.tistory.com/45
render_with_liquid: false
---

Spring과 Spring Boot는 Java 기반의 애플리케이션 개발을 위해 널리 사용되는 프레임워크이다.

이 둘은 밀접하게 연관되어 있지만, 각각의 목적과 기능이 다르다.

오늘 포스팅에서는 Spring과 Spring Boot의 차이점에 대해 자세히 설명해보려고 한다.

---

### 1. **Spring Framework**

- **핵심 개념**: Spring은 Java 애플리케이션의 개발을 단순화하고 효율적으로 만들기 위한 포괄적인 프레임워크이다.   
  Spring의 핵심 기능은 '**DI(Dependency Injection)**'와 '**AOP(Aspect-Oriented Programming)**'이다.  
  DI - 의존성 주입  
  AOP - 관점 지향 프로그래밍
- **구성 요소**:
  - **Spring Core**: DI를 통한 의존성 관리가 가능하며, 객체 간의 결합도를 낮추어 유연한 애플리케이션 설계를 도와준다.
  - **Spring MVC**: 웹 애플리케이션 개발을 위한 MVC 아키텍처를 제공한다.
  - **Spring Security**: 인증과 권한 관리를 위한 보안 프레임워크를 제공한다.
  - **Spring Data**: 데이터 접근을 위한 추상화를 제공하여 데이터베이스 작업을 단순화한다.
  - **Spring Batch**: 대규모 배치 작업을 처리하기 위한 기능을 제공한다.
- **설정 방식**:
  - Spring은 XML 또는 Java 클래스를 사용한 복잡한 설정이 필요하다. 개발자가 각 구성 요소를 직접 설정하고, 의존성을 관리해야 하므로 설정 과정이 다소 번거로울 수 있다.

---

### 2. **Spring Boot**

- **핵심 개념**: Spring Boot는 Spring Framework를 기반으로 하여 설정 과정을 최소화하고, 개발자가 신속하게 애플리케이션을 개발할 수 있도록 돕는 프레임워크이다. "**Spring을 더 쉽게 사용할 수 있게 해주는 도구**" 라고 볼 수 있다.
- **주요 기능**:
  - **Auto-Configuration(자동 설정)**: Spring Boot는 프로젝트의 의존성에 따라 자동으로 적절한 설정을 제공한다.   
    예를 들어, Spring Boot에 spring-boot-starter-web 의존성을 추가하면 자동으로 웹 서버가 구성된다.
  - **스타터 패키지**: Spring Boot는 다양한 스타터 패키지를 제공하여 특정 기능(예: spring-boot-starter-data-jpa, spring-boot-starter-security)을 쉽게 추가하고 사용할 수 있게 해준다.
  - **내장 서버**: Spring Boot는 Tomcat, Jetty, Undertow와 같은 내장 웹 서버를 제공하여 별도의 애플리케이션 서버 설정 없이 간편하게 웹 애플리케이션을 실행할 수 있다.
  - **간편한 설정**: Spring Boot는 application.properties 또는 application.yml 파일을 통해 애플리케이션의 설정을 간단하게 관리할 수 있다.
- **설정 방식**:
  - Spring Boot는 자동 설정(Auto-Configuration)을 통해 대부분의 설정을 자동으로 처리하므로, 개발자는 최소한의 설정만으로 애플리케이션을 빠르게 시작할 수 있다. 필요한 경우 개발자가 설정을 오버라이드하거나 커스터마이징할 수 있다.

---

### **비교 정리**

| **특성** | **Spring** | **Spring Boot** |
| --- | --- | --- |
| **설정** | 복잡한 XML/Java 설정 필요 | 자동 설정, 최소한의 설정 필요 |
| **프로젝트 시작** | 설정 작업이 많아 초기 설정 시간이 필요 | 스타터 패키지로 빠르게 프로젝트 시작 가능 |
| **내장 서버** | 별도의 서버 설정 필요 | 내장 서버 제공(Tomcat 등) |
| **사용 용이성** | 유연하나 설정이 복잡할 수 있음 | 간편하고 빠르게 애플리케이션 개발 가능 |
| **주요 사용 사례** | 다양한 Java 애플리케이션 | 마이크로서비스, 빠른 프로토타이핑 |

---

### 결론

Spring은 넓고 깊이 있는 프레임워크로서 다양한 기능을 제공하며, 복잡한 설정과 구성이 필요할 수 있지만, 유연성이 높다.

반면, Spring Boot는 이러한 Spring의 복잡성을 줄이고, 개발자가 빠르고 쉽게 애플리케이션을 개발할 수 있도록 도와준다. Spring Boot는 특히 마이크로서비스 아키텍처와 같은 환경에서 빠른 개발과 배포가 요구되는 경우에 유용하다.
