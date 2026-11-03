---
title: "[Java] Restful API 구현하기"
date: 2024-08-13 15:17:31 +0900
categories: ["Java"]
tags: ["api", "http", "java", "restful", "springboot", "메서드"]
tistory_url: https://yoon-ssi.tistory.com/19
render_with_liquid: false
---

RESTful API는 현대 웹 애플리케이션에서 서버와 클라이언트 간의 데이터 통신을 처리하는 핵심 요소 중 하나이다.

이번 포스팅에서는 Java와 Spring Boot를 사용해 RESTful API를 구현하는 방법을 IntelliJ를 기준으로 단계별로 설명하려고 한다. 데이터베이스는 MySQL을 사용했다.

---

#### 1. **RESTful API란?**

REST(Representational State Transfer)는 HTTP 프로토콜을 기반으로 리소스를 관리하고, 클라이언트와 서버 간의 상호작용을 단순화하기 위한 아키텍처 스타일이다. RESTful API는 이 REST 원칙을 따르는 API를 의미하며, 주로 다음과 같은 HTTP 메서드를 사용한다.

- **GET**: 리소스 조회
- **POST**: 리소스 생성
- **PUT**: 리소스 수정
- **DELETE**: 리소스 삭제

---

#### 2. **프로젝트 설정하기**

Spring Boot를 사용해 간단한 RESTful API를 구현하려면 IntelliJ에서 새로운 프로젝트를 생성하고 MySQL 데이터베이스를 연결해야 한다.

2.1 **IntelliJ에서 프로젝트 생성**

1. **IntelliJ IDEA를 실행**하고, 'New Project'를 클릭한다.
2. 프로젝트 타입으로 **'Spring Initializr'**를 선택하고 **'Next'**를 클릭한다.
3. 프로젝트 메타데이터(이름, Group, Artifact 등)를 입력하고 **'Next'**를 클릭한다.
4. **Dependencies** 섹션에서 **'Spring Web', 'Spring Data JPA', 'MySQL Driver'**를 선택하고 **'Next'**를 클릭한다.
5. 마지막으로 **프로젝트 위치**를 선택하고 **'Finish'**를 클릭하면 IntelliJ에서 새로운 Spring Boot 프로젝트가 생성된다.

2.2 **MySQL 데이터베이스 설정**

MySQL을 로컬 또는 원격 서버에 설치하고, 새로운 데이터베이스를 생성한다. 이 예제에서는 user_db라는 이름의 데이터베이스를 사용한다.

```sql
CREATE DATABASE user_db;
```

src/main/resources/application.properties 파일에 데이터베이스 연결 설정을 추가한다.

```shell
spring.datasource.url=jdbc:mysql://localhost:3306/user_db
spring.datasource.username=your_mysql_username
spring.datasource.password=your_mysql_password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

---

#### 3. **API 엔드포인트 구현하기**

이제 간단한 User 리소스를 관리하는 RESTful API를 구현한다.

3.1 **모델 클래스 생성**

User 엔터티를 정의한다. 이 클래스는 데이터베이스 테이블과 매핑된다.

```java
package com.example.demo.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Entity
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String email;

    // Getters and Setters
}
```

3.2 **Repository 인터페이스 생성**

User 엔터티에 대한 CRUD 작업을 처리하기 위해 UserRepository 인터페이스를 생성한다.

```java
package com.example.demo.repository;

import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
}
```

3.3 **컨트롤러 생성**

User 리소스를 관리하기 위한 RESTful 엔드포인트를 제공하는 컨트롤러를 작성한다.

```java
package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @GetMapping
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable Long id) {
        return userRepository.findById(id)
                .map(user -> ResponseEntity.ok().body(user))
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public User createUser(@RequestBody User user) {
        return userRepository.save(user);
    }

    @PutMapping("/{id}")
    public ResponseEntity<User> updateUser(@PathVariable Long id, @RequestBody User userDetails) {
        return userRepository.findById(id)
                .map(user -> {
                    user.setName(userDetails.getName());
                    user.setEmail(userDetails.getEmail());
                    User updatedUser = userRepository.save(user);
                    return ResponseEntity.ok().body(updatedUser);
                }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable Long id) {
        return userRepository.findById(id)
                .map(user -> {
                    userRepository.delete(user);
                    return ResponseEntity.ok().build();
                }).orElse(ResponseEntity.notFound().build());
    }
}
```

3.4 **API 테스트**

이제 Spring Boot 애플리케이션을 실행하면, API 서버가 로컬에서 실행된다. Postman 같은 API 클라이언트를 사용해 다양한 HTTP 요청을 테스트할 수 있다.

- GET /api/users: 모든 사용자 조회
- GET /api/users/{id}: 특정 사용자 조회
- POST /api/users: 새로운 사용자 생성
- PUT /api/users/{id}: 특정 사용자 수정
- DELETE /api/users/{id}: 특정 사용자 삭제

---

#### 4. **결론**

이제 기본적인 RESTful API를 Java와 Spring Boot를 사용해 구현하는 방법을 알게 되었다.

이 API는 CRUD 작업을 처리할 수 있으며, 실제 개발 환경에서는 이 구조를 확장해 다양한 기능을 추가할 수 있다.

예를 들어, 보안 강화, 데이터 검증, 로깅, 그리고 예외 처리를 추가하여 운영 환경에서 사용할 수 있도록 최적화할 수 있다.
