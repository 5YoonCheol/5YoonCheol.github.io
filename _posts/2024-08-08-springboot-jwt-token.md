---
title: "[SpringBoot] JWT Token 생성"
date: 2024-08-08 22:52:27 +0900
categories: [Backend, Spring]
tags: ["jwt", "springboot", "token", "스프링", "스프링부트", "토큰생성"]
tistory_url: https://yoon-ssi.tistory.com/13
render_with_liquid: false
---

### JWT란?

JWT(JSON Web Token)는 사용자 인증이나 데이터 교환에 많이 쓰는 토큰이다. 세 부분으로 이뤄진 짧은 토큰으로, 클라이언트와 서버가 믿을 수 있는 정보를 주고받을 수 있게 해준다. 주로 로그인 같은 인증 시스템에서 쓴다.

---

### JWT의 구조

JWT는 세 부분으로 나뉜다.

1. 헤더 (Header): 토큰 유형과 사용한 알고리즘 정보가 들어 있다.
2. 페이로드 (Payload): 토큰에 담을 실제 데이터다. 사용자 정보나 만료 시간 같은 클레임이 들어간다.
3. 서명 (Signature): 토큰이 변조되지 않았는지 확인하는 부분이다. 헤더와 페이로드를 인코딩한 다음 비밀 키와 함께 해시 함수로 만든다.

---

### Spring Boot에서 JWT 토큰 만들기

#### 1. 의존성 추가

JWT 토큰을 만들려면 jjwt 라이브러리가 필요하다. pom.xml이나 build.gradle에 의존성을 추가한다.

```java
// pom.xml
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt</artifactId>
    <version>0.9.1</version>
</dependency>
```

```java
//build.gradle
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter'
    implementation 'io.jsonwebtoken:jjwt:0.9.1'
    // 다른 필요한 의존성 추가
}
```

#### 2. JWT 유틸리티 클래스 만들기

```java
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class JwtTokenUtil {
    private String secretKey = "mySecretKey"; // 비밀 키
    private long expirationTime = 86400000; // 1일 (밀리초 단위)

    // 토큰 생성 메서드
    public String generateToken(String username) {
        return Jwts.builder()
                .setSubject(username)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + expirationTime))
                .signWith(SignatureAlgorithm.HS512, secretKey)
                .compact();
    }

    // 토큰에서 사용자 이름 추출 메서드
    public String getUsernameFromToken(String token) {
        Claims claims = getClaimsFromToken(token);
        return claims.getSubject();
    }

    // 토큰 유효성 검증 메서드
    public boolean validateToken(String token) {
        Claims claims = getClaimsFromToken(token);
        return !claims.getExpiration().before(new Date());
    }

    // 토큰에서 클레임 추출 메서드
    private Claims getClaimsFromToken(String token) {
        return Jwts.parser()
                .setSigningKey(secretKey)
                .parseClaimsJws(token)
                .getBody();
    }
}
```

`@Component` 어노테이션을 쓰지 않는다면 JwtTokenUtil 클래스를 따로 스프링 빈으로 등록해줘야 한다.

#### 3. 서비스 클래스에서 토큰 만들기

```java
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserService {
    private final JwtTokenUtil jwtTokenUtil; // final 필드로 선언하여 생성자 주입

    public String login(String username, String password) {
        // 사용자 인증 로직 (예: DB 조회)
        if (username.equals("testUser") && password.equals("testPass")) {
            return jwtTokenUtil.generateToken(username);
        }
        return null;
    }

    public boolean validateToken(String token) {
        return jwtTokenUtil.validateToken(token);
    }

    public String getUsernameFromToken(String token) {
        return jwtTokenUtil.getUsernameFromToken(token);
    }
}
```

`@RequiredArgsConstructor` 어노테이션을 쓰지 않는다면 `@Autowired`를 쓰거나 생성자를 직접 만들어줘야 한다.

login 메서드에는 필요에 따라 로직을 더 붙이면 된다.

만든 토큰으로 접근 권한을 설정하거나, DB 조회 없이 사용자 정보를 꺼내 쓰는 등 여러 기능을 만들 수 있는데, 이건 나중에 따로 다뤄보겠다.
