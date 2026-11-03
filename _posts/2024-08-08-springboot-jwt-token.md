---
title: "[SpringBoot] JWT Token 생성"
date: 2024-08-08 22:52:27 +0900
categories: [Backend, Spring]
tags: ["jwt", "springboot", "token", "스프링", "스프링부트", "토큰생성"]
tistory_url: https://yoon-ssi.tistory.com/13
render_with_liquid: false
---

### **JWT란?**

JWT (JSON Web Token)은 사용자 인증과 데이터 교환을 위해 널리 사용된다. JWT는 세 부분으로 구성된 콤팩트한 토큰으로, 이를 통해 신뢰성 있는 정보 교환이 가능하다. JWT는 주로 사용자 인증 시스템에서 사용되며, 클라이언트와 서버 간에 데이터를 안전하게 전달하는 데 이용된다.

---

### **JWT의 구조**

JWT는 세 부분으로 나누어져 있다.

1. **헤더 (Header)**: 토큰의 유형과 사용된 알고리즘 정보를 담고 있다.
2. **페이로드 (Payload)**: 토큰에 담길 실제 데이터를 포함한다. 여기에는 사용자 정보나 만료 시간 등의 클레임이 포함될 수 있다.
3. **서명 (Signature)**: 토큰의 무결성을 확인하기 위한 부분이다. 헤더와 페이로드를 인코딩한 후, 비밀 키와 함께 해시 함수로 생성된다.

---

### **Spring Boot에서 JWT 토큰 생성 방법**

**1. 의존성 추가**

    pom.xml 파일 혹은 build.gradle에 필요한 의존성을 추가한다. JWT 토큰을 생성하려면 jjwt 라이브러리가 필요하다.

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

**2. JWT 유틸리티 클래스 생성**

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

@componenet 어노테이션을 사용하지 않는 경우 , JwtTokenUtil 클래스를 스프링 빈으로 등록해줘야 한다.

**3. 서비스 클래스에서 JWT 유틸리티 클래스를 사용하여 토큰 생성**

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

@RequiredArgsConstructor 어노테이션을 사용하지 않는 경우, @AutoWired 어노테이션 사용 혹은 생성자를 직접 만들어줘야 한다.

위의 예제의 login 메서드에서 필요에 따라 로직을 더 추가해 주면 된다.

생성된 token을 통해 접근 권한 설정, DB조회 없이 사용자 정보를 가져오기 등 여러 가지 기능을 구현할 수 있는데,

나중에 따로 다뤄보도록 하겠다.
