---
title: "[ETC] CORS ERROR란?"
date: 2024-09-25 12:12:12 +0900
categories: [CS, Network]
tags: ["cors", "error"]
tistory_url: https://yoon-ssi.tistory.com/63
render_with_liquid: false
---

개발한 API를 실제 화면에서 테스트 해보려고 할 때, 로컬 환경에서는 정상적으로 동작하는데   
개발 서버에서 테스트 하는 경우 CORS 에러가 발생하는 경우가 있다.

오늘 포스팅에서는 CORS 에러가 무엇인지에 대해 알아보자.

---

CORS(Cross-Origin Resource Sharing) 에러는 웹 브라우저에서 보안 상의 이유로 발생하는 문제로, 웹 애플리케이션이 하나의 도메인에서 실행 중일 때 다른 도메인의 리소스에 접근하려 할 때 발생한다.

기본적으로 웹 브라우저는 "동일 출처 정책(Same-Origin Policy)"을 따르는데, 이는 보안상 같은 출처(프로토콜, 도메인, 포트)의 요청만을 허용하는 정책이다.

만약 출처가 다른 리소스에 접근하려는 경우, 서버에서 명시적으로 CORS를 허용하지 않으면 CORS 에러가 발생한다.

### 1. **CORS 에러가 발생하는 상황**

- 클라이언트(브라우저)가 다른 도메인의 리소스에 접근하려 할 때.
- 서버가 적절한 CORS 헤더를 응답하지 않을 때.

예를 들어, `http://example.com`에서 실행 중인 웹 애플리케이션이 `http://another-domain.com/api`의 데이터를 가져오려고 할 때, 서버에서 CORS를 허용하는 헤더를 보내지 않으면 브라우저가 요청을 차단하고 CORS 에러를 발생시킨다.

### 2. **CORS의 작동 방식**

CORS는 서버 측에서 브라우저가 다른 도메인의 리소스에 접근할 수 있도록 허용하는 방법이다. 이를 위해 서버는 Access-Control-Allow-Origin이라는 HTTP 헤더를 응답에 추가해줘야 한다.

- **Preflight Request**: 브라우저는 복잡한 요청(예: POST, PUT, DELETE, PATCH 등)을 하기 전에 **OPTIONS** 메서드를 사용하여 서버에 '이 요청을 보내도 되냐'고 묻는 **preflight 요청**을 보낸다. 서버가 올바른 CORS 헤더로 응답해야만 본 요청이 진행된다.
- **간단한 요청(Simple Request)**: GET, POST, HEAD와 같은 메서드는 preflight 요청 없이도 이루어질 수 있지만, 서버는 여전히 올바른 Access-Control-Allow-Origin 헤더로 응답해야 한다.

### 3. **CORS 헤더 설명**

- **Access-Control-Allow-Origin**: 어떤 출처에서 리소스를 접근할 수 있는지 명시. 예를 들어, *는 모든 출처를 허용하고, 특정 도메인만 허용하려면 해당 도메인을 명시해야 한다.
- **Access-Control-Allow-Methods**: 허용할 HTTP 메서드 (GET, POST, DELETE 등) 목록을 제공.
- **Access-Control-Allow-Headers**: 클라이언트가 요청에 사용할 수 있는 헤더들을 명시.
- **Access-Control-Allow-Credentials**: true로 설정하면 브라우저가 쿠키, 인증 정보 등을 요청에 포함할 수 있도록 허용.

### 4. **CORS 에러 해결 방법**

- **서버 측에서 CORS 설정 추가**: 서버에서 올바른 CORS 헤더를 응답에 추가하여 클라이언트가 접근할 수 있도록 설정.   

  예시 (Node.js/Express)

```javascript
app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "http://example.com");  // 특정 도메인 허용
  res.header("Access-Control-Allow-Methods", "GET,POST,PUT,DELETE");
  res.header("Access-Control-Allow-Headers", "Content-Type, Authorization");
  next();
});
```

- **프록시 서버 사용**: 클라이언트와 다른 도메인 간의 요청을 중개하는 프록시 서버를 설정하여 브라우저의 동일 출처 정책을 우회.
- **프론트엔드 개발 환경에서 CORS 우회**: 로컬 환경에서는 브라우저의 플러그인을 사용하여 CORS 정책을 비활성화할 수 있으나, 이는 보안에 취약하므로 실제 프로덕션 환경에서는 권장되지 않는다.

### 5. **주의할 점**

CORS는 보안 관련 사항이기 때문에 너무 널널하게 설정하면 크로스 사이트 스크립팅(XSS)이나 CSRF(Cross-Site Request Forgery) 공격에 취약해질 수 있다. 따라서 CORS 헤더 설정 시 주의해야 한다.

CORS는 웹 애플리케이션의 보안을 위한 중요한 메커니즘이지만, 개발 중에는 자주 발생하는 문제이기도 하다. 이를 제대로 이해하고 서버에서 적절한 설정을 해주면 해결할 수 있다.
