---
title: "[Spring & SpringBoot] Spring과 SpringBoot의 차이점"
date: 2024-09-06 08:00:17 +0900
categories: [Backend, Spring]
tags: ["spring", "springboot", "차이점", "특징"]
tistory_url: https://yoon-ssi.tistory.com/45
render_with_liquid: false
---

Spring과 Spring Boot는 둘 다 Java 개발에서 빠질 수 없는 프레임워크다. 이름도 비슷하고 서로 엮여 있긴 한데, 목적과 하는 일은 꽤 다르다.

이번엔 둘이 어떻게 다른지 정리해보려고 한다.

---

### 1. Spring Framework

Spring은 Java 애플리케이션 개발을 쉽고 깔끔하게 만들어주는 종합 프레임워크다. 핵심은 **DI(Dependency Injection, 의존성 주입)** 와 **AOP(Aspect-Oriented Programming, 관점 지향 프로그래밍)** 두 가지다.

여러 모듈로 이뤄져 있다.

- Spring Core: DI로 의존성을 관리한다. 객체 사이 결합도를 낮춰서 유연하게 설계할 수 있게 해준다.
- Spring MVC: 웹 애플리케이션을 MVC 구조로 만들 수 있게 해준다.
- Spring Security: 인증과 권한 관리를 담당한다.
- Spring Data: 데이터 접근을 추상화해서 DB 작업을 단순하게 만든다.
- Spring Batch: 대량 배치 작업을 처리한다.

문제는 설정이다. XML이나 Java 클래스로 설정을 꽤 많이 해줘야 하고, 구성 요소와 의존성을 개발자가 하나하나 챙겨야 해서 번거롭다.

---

### 2. Spring Boot

Spring Boot는 Spring 위에서 설정을 최소화해서 빨리 개발할 수 있게 해주는 프레임워크다. 한마디로 "Spring을 더 쉽게 쓰게 해주는 도구"다.

이런 기능들이 있다.

- 자동 설정(Auto-Configuration): 프로젝트 의존성을 보고 알아서 적절한 설정을 잡아준다. 예를 들어 spring-boot-starter-web을 추가하면 웹 서버가 자동으로 구성된다.
- 스타터 패키지: spring-boot-starter-data-jpa, spring-boot-starter-security처럼 기능별 스타터를 추가하기만 하면 바로 쓸 수 있다.
- 내장 서버: Tomcat, Jetty, Undertow가 내장돼 있어서 서버를 따로 설치하고 설정할 필요 없이 바로 실행된다.
- 간단한 설정 파일: application.properties나 application.yml 하나로 설정을 관리한다.

대부분은 자동 설정이 처리해주니 최소한의 설정만으로 바로 시작할 수 있다. 물론 필요하면 직접 덮어쓰거나 바꿀 수도 있다.

---

### 비교

| 특성 | Spring | Spring Boot |
| --- | --- | --- |
| 설정 | XML/Java 설정이 많이 필요 | 자동 설정, 최소한만 하면 됨 |
| 프로젝트 시작 | 초기 설정에 시간이 걸림 | 스타터로 빠르게 시작 |
| 내장 서버 | 서버를 따로 설정해야 함 | 내장 서버 제공(Tomcat 등) |
| 사용 편의성 | 유연하지만 설정이 복잡할 수 있음 | 간편하고 빠르게 개발 가능 |
| 주로 쓰는 곳 | 다양한 Java 애플리케이션 | 마이크로서비스, 빠른 프로토타이핑 |

---

정리하면 Spring은 기능이 넓고 깊은 대신 설정이 복잡할 수 있고, 그만큼 유연하다. Spring Boot는 그 복잡함을 덜어내서 빠르게 만들 수 있게 해준다. 그래서 마이크로서비스처럼 빨리 만들고 자주 배포해야 하는 환경에서 특히 많이 쓴다.
