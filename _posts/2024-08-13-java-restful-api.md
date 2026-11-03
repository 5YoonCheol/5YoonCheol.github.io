---
title: "[Java] Restful API 구현하기"
date: 2024-08-13 15:17:31 +0900
categories: [Backend, Java]
tags: ["api", "http", "java", "restful", "springboot", "메서드"]
tistory_url: https://yoon-ssi.tistory.com/19
render_with_liquid: false
---

웹 애플리케이션에서 서버와 클라이언트가 데이터를 주고받을 때 가장 많이 쓰는 방식이 RESTful API다.

이번 글에서는 Java와 Spring Boot로 RESTful API를 만드는 과정을 IntelliJ 기준으로 하나씩 따라가 보려고 한다. 데이터베이스는 MySQL을 썼다.

---

#### 1. RESTful API란?

REST(Representational State Transfer)는 HTTP를 기반으로 리소스를 다루고, 클라이언트와 서버 간의 상호작용을 단순하게 만들기 위한 아키텍처 스타일이다. 이 원칙을 따르는 API를 RESTful API라고 부르고, 주로 아래 HTTP 메서드를 쓴다.

- GET: 리소스 조회
- POST: 리소스 생성
- PUT: 리소스 수정
- DELETE: 리소스 삭제

---

#### 2. 프로젝트 설정

IntelliJ에서 프로젝트를 만들고 MySQL을 연결해보자.

2.1 IntelliJ에서 프로젝트 만들기

1. IntelliJ IDEA를 열고 'New Project'를 누른다.
2. 프로젝트 타입으로 'Spring Initializr'를 고르고 'Next'.
3. 이름, Group, Artifact 같은 메타데이터를 입력하고 'Next'.
4. Dependencies에서 'Spring Web', 'Spring Data JPA', 'MySQL Driver'를 고르고 'Next'.
5. 프로젝트 위치를 정하고 'Finish'를 누르면 Spring Boot 프로젝트가 만들어진다.

2.2 MySQL 데이터베이스 설정

로컬이든 원격 서버든 MySQL을 설치하고 데이터베이스를 하나 만든다. 여기서는 user_db라는 이름을 쓴다.

```sql
CREATE DATABASE user_db;
```

src/main/resources/application.properties에 DB 연결 설정을 넣는다.

```shell
spring.datasource.url=jdbc:mysql://localhost:3306/user_db
spring.datasource.username=your_mysql_username
spring.datasource.password=your_mysql_password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

---

#### 3. API 엔드포인트 만들기

간단하게 User 리소스를 관리하는 API를 만들어보자.

3.1 모델 클래스

User 엔터티를 정의한다. 이 클래스가 DB 테이블과 매핑된다.

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

3.2 Repository 인터페이스

User 엔터티의 CRUD를 처리할 UserRepository를 만든다.

```java
package com.example.demo.repository;

import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
}
```

3.3 컨트롤러

User 리소스용 엔드포인트를 제공하는 컨트롤러를 작성한다.

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

3.4 API 테스트

애플리케이션을 실행하면 로컬에서 API 서버가 뜬다. Postman 같은 API 클라이언트로 요청을 보내보면 된다.

- GET /api/users: 모든 사용자 조회
- GET /api/users/{id}: 특정 사용자 조회
- POST /api/users: 새로운 사용자 생성
- PUT /api/users/{id}: 특정 사용자 수정
- DELETE /api/users/{id}: 특정 사용자 삭제

---

#### 4. 마무리

여기까지 하면 기본적인 CRUD를 처리하는 API가 완성된다. 실제로 운영에 올리려면 이 구조 위에 보안, 데이터 검증, 로깅, 예외 처리 같은 것들을 더 붙여야 한다.
