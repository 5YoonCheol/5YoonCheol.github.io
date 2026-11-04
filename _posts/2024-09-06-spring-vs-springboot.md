---
title: "[Spring & SpringBoot] Spring과 SpringBoot의 차이점, 그리고 프로젝트 시작하기"
date: 2024-09-06 02:00:00 +0900
categories: [Backend, Spring]
tags: ["spring", "springboot", "차이점", "자동-설정", "프로젝트-생성"]
description: Spring Framework와 Spring Boot가 각각 무엇을 맡는지, 자동 설정과 스타터가 실제로 하는 일, 그리고 start.spring.io로 프로젝트를 만들고 첫 실행까지 가는 과정을 정리한다.
tistory_url: https://yoon-ssi.tistory.com/45
tistory_urls: [https://yoon-ssi.tistory.com/2, https://yoon-ssi.tistory.com/45]
redirect_from:
  - /posts/springboot-project-setup/
render_with_liquid: false
---

> 2026년 11월에 "Spring과 SpringBoot의 차이점"과 "SpringBoot 프로젝트 생성" 두 글을 하나로 합쳐 다시 썼다. IntelliJ 화면 캡처는 버전마다 바뀌어서 start.spring.io 기준으로 바꿨다. 옛 주소로 들어오면 이 글로 넘어온다.
{: .prompt-info }

Spring과 Spring Boot는 둘 다 Java 개발에서 빠질 수 없는 프레임워크다. 이름도 비슷하고 서로 엮여 있긴 한데, 목적과 하는 일은 꽤 다르다. 둘의 차이를 정리하고, 그 차이가 실제로 프로젝트를 만들 때 어떻게 드러나는지까지 보자.

---

### 1. Spring Framework

Spring은 Java 애플리케이션 개발을 쉽고 깔끔하게 만들어주는 종합 프레임워크다. 핵심은 **DI(Dependency Injection, 의존성 주입)** 와 **AOP(Aspect-Oriented Programming, 관점 지향 프로그래밍)** 두 가지다.

여러 모듈로 이뤄져 있다.

- Spring Core: DI로 의존성을 관리한다. 객체 사이 결합도를 낮춰서 유연하게 설계할 수 있게 해준다.
- Spring MVC: 웹 애플리케이션을 MVC 구조로 만들 수 있게 해준다.
- Spring Security: 인증과 권한 관리를 담당한다.
- Spring Data: 데이터 접근을 추상화해서 DB 작업을 단순하게 만든다.
- Spring Batch: 대량 배치 작업을 처리한다.

문제는 설정이다. 순수 Spring으로 웹 애플리케이션을 하나 띄우려면 `DispatcherServlet` 등록, 뷰 리졸버, 데이터소스, 트랜잭션 매니저를 XML이나 Java 설정으로 직접 적어야 하고, 라이브러리 버전 궁합도 개발자가 맞춰야 한다. 그리고 WAR로 묶어서 따로 설치한 Tomcat에 올려야 실행된다.

---

### 2. Spring Boot

Spring Boot는 Spring 위에서 설정을 최소화해서 빨리 개발할 수 있게 해주는 프레임워크다. 한마디로 "Spring을 더 쉽게 쓰게 해주는 도구"다. Spring을 대체하는 게 아니라 Spring을 감싼 것이라서, Boot 안에서 돌아가는 건 결국 Spring이다.

- 자동 설정(Auto-Configuration): 클래스패스에 뭐가 있는지 보고 알아서 설정을 잡아준다. `spring-boot-starter-web`이 있으면 `DispatcherServlet`과 내장 Tomcat을, `spring-boot-starter-data-jpa`와 MySQL 드라이버가 있으면 데이터소스와 `EntityManagerFactory`를 만들어 준다. 내가 같은 타입의 빈을 직접 만들면 자동 설정은 물러난다(`@ConditionalOnMissingBean`).
- 스타터 패키지: `spring-boot-starter-*` 하나가 그 기능에 필요한 라이브러리 묶음과 서로 맞는 버전을 끌고 온다. 버전을 적지 않아도 되는 이유다.
- 내장 서버: Tomcat(기본), Jetty, Undertow가 의존성에 들어 있어서 `java -jar`로 바로 실행된다.
- 설정 파일 하나: `application.yml`(또는 `.properties`)의 키 이름만 알면 포트, DB 접속, 로깅 수준을 바꿀 수 있다.
- 운영 기능: Actuator를 붙이면 헬스 체크, 메트릭 엔드포인트가 따라온다.

대부분은 자동 설정이 처리해주니 최소한의 설정만으로 바로 시작할 수 있다. 물론 필요하면 직접 덮어쓰거나 바꿀 수도 있다.

---

### 3. 비교

| 특성 | Spring | Spring Boot |
| --- | --- | --- |
| 설정 | XML/Java 설정을 직접 작성 | 자동 설정, 필요한 것만 덮어씀 |
| 의존성 버전 | 개발자가 궁합을 맞춤 | 스타터와 BOM이 관리 |
| 프로젝트 시작 | 초기 설정에 시간이 걸림 | start.spring.io에서 1분 |
| 실행 | WAR를 외부 서버에 배포 | 내장 서버로 `java -jar` |
| 사용 편의성 | 유연하지만 설정이 복잡할 수 있음 | 간편하고 빠르게 개발 가능 |
| 주로 쓰는 곳 | 레거시, 세밀한 제어가 필요한 곳 | 신규 프로젝트 대부분, 마이크로서비스 |

정리하면 Spring은 기능이 넓고 깊은 대신 설정이 복잡할 수 있고, 그만큼 유연하다. Spring Boot는 그 복잡함을 덜어내서 빠르게 만들 수 있게 해준다. 지금 새로 시작하는 프로젝트라면 사실상 Boot가 기본이다.

---

### 4. 프로젝트 시작하기

차이를 알았으니 Boot 프로젝트를 실제로 만들어 보자. IntelliJ의 New Project 화면도 결국 아래 Spring Initializr를 감싼 것이라, 어느 쪽을 써도 결과는 같다.

#### 4.1. start.spring.io에서 생성

[https://start.spring.io](https://start.spring.io) 에서 고를 것은 다섯 가지다.

- Project: Gradle - Groovy 또는 Maven. 요즘 신규 프로젝트는 Gradle이 많다.
- Language: Java
- Spring Boot: 기본으로 선택된 최신 안정 버전(SNAPSHOT, M, RC가 붙지 않은 것)
- Project Metadata: Group은 보통 도메인 역순(`com.example`), Artifact가 프로젝트 이름이 된다. Java는 17 이상(Boot 3.x는 17이 최소).
- Dependencies: 처음이라면 `Spring Web`, `Lombok`, `Spring Boot DevTools` 정도. DB까지 붙이면 `Spring Data JPA`와 `MySQL Driver`.

GENERATE를 누르면 zip이 내려오고, 풀어서 IntelliJ에서 열면(또는 File → New → Project → Spring Boot에서 같은 항목을 고르면) 된다.

IntelliJ Community 에디션에는 Spring Boot 프로젝트 생성 메뉴가 없다. 이 경우 start.spring.io에서 받아서 `build.gradle`을 열면 된다.

#### 4.2. 생성된 구조

```
demo/
├── build.gradle                 # 의존성과 플러그인
├── settings.gradle
├── gradlew, gradlew.bat         # Gradle Wrapper. Gradle을 따로 설치할 필요 없다
└── src/
    ├── main/
    │   ├── java/com/example/demo/
    │   │   └── DemoApplication.java   # @SpringBootApplication 이 붙은 시작점
    │   └── resources/
    │       ├── application.properties # 설정 파일. yml 로 바꿔도 된다
    │       ├── static/                # 정적 파일 (js, css, 이미지)
    │       └── templates/             # 템플릿 (Thymeleaf 등)
    └── test/java/com/example/demo/
        └── DemoApplicationTests.java  # 컨텍스트가 뜨는지 확인하는 기본 테스트
```

`build.gradle`에서 스타터가 버전 없이 들어가 있는 것을 볼 수 있다.

```groovy
plugins {
    id 'java'
    id 'org.springframework.boot' version '3.4.0'
    id 'io.spring.dependency-management' version '1.1.6'
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
    compileOnly 'org.projectlombok:lombok'
    annotationProcessor 'org.projectlombok:lombok'
    developmentOnly 'org.springframework.boot:spring-boot-devtools'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
}
```

#### 4.3. 첫 실행

컨트롤러 하나를 만들고 실행해 보자.

```java
package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("/hello")
    public String hello() {
        return "hello";
    }
}
```

```bash
./gradlew bootRun
# 또는 IntelliJ에서 DemoApplication 의 main 실행
```

로그에 `Tomcat started on port 8080`이 보이면 `http://localhost:8080/hello`에서 `hello`가 나온다. 서버를 설치하지도, 서블릿을 등록하지도 않았는데 동작하는 이것이 2절에서 말한 자동 설정과 내장 서버다.

포트를 바꾸고 싶으면 `application.properties`에 한 줄 적는다.

```properties
server.port=8081
```

#### 4.4. 처음에 막히는 것들

- `java -version`이 17 미만이면 빌드가 안 된다. IntelliJ에서는 Project Structure → SDK도 같이 확인한다.
- JPA 스타터를 넣었는데 DB 접속 정보가 없으면 기동 시 `Failed to configure a DataSource` 오류가 난다. 데이터소스 설정을 넣거나, 아직 DB가 없으면 JPA 스타터를 빼고 시작한다.
- Lombok은 IntelliJ 설정의 Annotation Processing을 켜야 `@Getter` 같은 게 동작한다. 최신 버전은 기본으로 켜져 있다.

여기까지가 "Spring Boot가 Spring의 무엇을 대신해 주는가"를 손으로 확인하는 과정이다. 다음은 DB를 붙이는 단계인데, MyBatis를 쓴다면 [SpringBoot 프로젝트에서 MyBatis 설정하기](/posts/springboot-mybatis-setup/), JPA를 쓴다면 [JPA와 Hibernate를 통한 RDBMS 연계방법](/posts/jpa-hibernate-rdbms/) 글로 이어진다.
