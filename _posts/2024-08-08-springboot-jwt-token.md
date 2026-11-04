---
title: "[SpringBoot] JWT Token 생성"
date: 2024-08-08 02:00:00 +0900
categories: [Backend, Spring]
tags: ["jwt", "springboot", "token", "스프링", "스프링부트", "토큰생성"]
description: JWT의 헤더·페이로드·서명 구조를 살펴보고 Spring Boot에서 의존성 추가부터 토큰 생성까지 구현하는 과정을 정리한다.
tistory_url: https://yoon-ssi.tistory.com/13
render_with_liquid: false
---

> 2026년 11월에 jjwt 0.12.x 기준으로 고쳤다. 처음에 쓴 0.9.1은 Java 9 이상에서 `javax.xml.bind` 오류가 나고, `setSubject`·`parseClaimsJws` 같은 메서드도 0.12에서 deprecated 됐다.
{: .prompt-info }

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

JWT 토큰을 만들려면 jjwt 라이브러리가 필요하다. 0.10부터는 API(`jjwt-api`), 구현(`jjwt-impl`), JSON 처리(`jjwt-jackson`) 세 모듈로 나뉘어 있어서 셋을 함께 넣는다. pom.xml이나 build.gradle에 의존성을 추가한다.

```xml
<!-- pom.xml -->
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.12.6</version>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.12.6</version>
    <scope>runtime</scope>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-jackson</artifactId>
    <version>0.12.6</version>
    <scope>runtime</scope>
</dependency>
```

```groovy
// build.gradle
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter'
    implementation 'io.jsonwebtoken:jjwt-api:0.12.6'
    runtimeOnly 'io.jsonwebtoken:jjwt-impl:0.12.6'
    runtimeOnly 'io.jsonwebtoken:jjwt-jackson:0.12.6'
}
```

#### 2. JWT 유틸리티 클래스 만들기

```java
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

@Component
public class JwtTokenUtil {
    private final SecretKey secretKey;
    private final long expirationTime = 86_400_000L; // 1일 (밀리초 단위)

    // 비밀 키는 코드에 적지 않고 설정(환경 변수)에서 읽는다. HS256은 32바이트 이상이어야 한다
    public JwtTokenUtil(@Value("${jwt.secret}") String secret) {
        this.secretKey = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
    }

    // 토큰 생성 메서드
    public String generateToken(String username) {
        Date now = new Date();
        return Jwts.builder()
                .subject(username)
                .issuedAt(now)
                .expiration(new Date(now.getTime() + expirationTime))
                .signWith(secretKey) // 키 길이에 맞는 HMAC 알고리즘을 자동으로 고른다
                .compact();
    }

    // 토큰에서 사용자 이름 추출 메서드
    public String getUsernameFromToken(String token) {
        return getClaimsFromToken(token).getSubject();
    }

    // 토큰 유효성 검증 메서드. 서명이 틀리거나 만료되면 파싱 단계에서 예외가 난다
    public boolean validateToken(String token) {
        try {
            getClaimsFromToken(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }

    // 토큰에서 클레임 추출 메서드
    private Claims getClaimsFromToken(String token) {
        return Jwts.parser()
                .verifyWith(secretKey)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }
}
```

0.9 시절과 달라진 점을 정리하면 이렇다.

- `setSubject()`, `setExpiration()`처럼 `set`이 붙던 메서드가 `subject()`, `expiration()`으로 바뀌었다.
- `signWith(SignatureAlgorithm.HS512, "문자열")`은 사라졌다. 문자열 대신 `SecretKey` 객체를 넘기고, 알고리즘은 키 길이로 자동 결정된다. 짧은 문자열을 키로 쓰면 `WeakKeyException`이 난다.
- 파서는 `Jwts.parser().verifyWith(key).build()`로 만들고, `parseClaimsJws()` 대신 `parseSignedClaims()`, `getBody()` 대신 `getPayload()`를 쓴다.
- 만료된 토큰은 `getExpiration()`을 비교할 필요 없이 파싱 시점에 `ExpiredJwtException`이 난다.

비밀 키는 `application.yml`에 직접 적기보다 환경 변수로 넣는다.

```yaml
jwt:
  secret: ${JWT_SECRET}
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
