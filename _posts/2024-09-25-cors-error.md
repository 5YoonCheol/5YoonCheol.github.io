---
title: "[ETC] CORS ERROR란?"
date: 2024-09-25 12:12:12 +0900
categories: [CS, Network]
tags: ["cors", "error"]
tistory_url: https://yoon-ssi.tistory.com/63
render_with_liquid: false
---

만든 API를 실제 화면에 붙여서 테스트해보면, 로컬에서는 잘 되는데 개발 서버에서는 CORS 에러가 나는 경우가 있다.

오늘은 CORS 에러가 뭔지 알아보자.

---

CORS(Cross-Origin Resource Sharing) 에러는 브라우저가 보안 때문에 내는 에러다. 한 도메인에서 돌고 있는 웹 애플리케이션이 다른 도메인의 리소스에 접근하려고 할 때 생긴다.

브라우저는 기본적으로 "동일 출처 정책(Same-Origin Policy)"을 따른다. 출처(프로토콜, 도메인, 포트)가 같은 요청만 허용하는 정책이다.

그래서 출처가 다른 리소스에 접근할 때 서버가 CORS를 명시적으로 허용해주지 않으면 CORS 에러가 난다.

### 1. 언제 나나

- 브라우저가 다른 도메인의 리소스에 접근하려고 할 때
- 서버가 CORS 헤더를 제대로 응답하지 않을 때

예를 들어 `http://example.com`에서 돌고 있는 웹 애플리케이션이 `http://another-domain.com/api`에서 데이터를 가져오려는데 서버가 CORS 허용 헤더를 안 보내면, 브라우저가 요청을 막고 CORS 에러를 띄운다.

### 2. 어떻게 동작하나

CORS는 서버가 "이 출처에서 오는 요청은 받아도 된다"고 브라우저에게 알려주는 방식이다. 서버가 응답에 `Access-Control-Allow-Origin` 헤더를 넣어줘야 한다.

- Preflight 요청: 브라우저는 POST, PUT, DELETE, PATCH 같은 복잡한 요청을 보내기 전에 OPTIONS 메서드로 '이 요청 보내도 돼?' 하고 먼저 물어본다. 이걸 preflight 요청이라고 한다. 서버가 올바른 CORS 헤더로 답해야 본 요청이 나간다.
- 단순 요청(Simple Request): GET, POST, HEAD 같은 요청은 preflight 없이 바로 갈 수 있다. 그래도 서버는 `Access-Control-Allow-Origin` 헤더를 제대로 돌려줘야 한다.

### 3. CORS 헤더

- `Access-Control-Allow-Origin`: 어떤 출처에서 접근할 수 있는지 적는다. `*`는 전부 허용이고, 특정 도메인만 허용하려면 그 도메인을 적는다.
- `Access-Control-Allow-Methods`: 허용할 HTTP 메서드(GET, POST, DELETE 등) 목록.
- `Access-Control-Allow-Headers`: 클라이언트가 요청에 쓸 수 있는 헤더 목록.
- `Access-Control-Allow-Credentials`: true면 브라우저가 쿠키나 인증 정보를 요청에 실어 보낼 수 있다.

### 4. 해결 방법

서버에서 CORS 설정을 추가한다. 응답에 CORS 헤더를 넣어서 클라이언트가 접근할 수 있게 해준다. Node.js/Express라면 이렇게 한다.

```javascript
app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "http://example.com");  // 특정 도메인 허용
  res.header("Access-Control-Allow-Methods", "GET,POST,PUT,DELETE");
  res.header("Access-Control-Allow-Headers", "Content-Type, Authorization");
  next();
});
```

프록시 서버를 쓴다. 클라이언트와 다른 도메인 사이에서 요청을 대신 전달해주는 프록시를 두면 동일 출처 정책을 피해갈 수 있다.

로컬 개발 환경에서는 브라우저 플러그인으로 CORS 정책을 꺼버릴 수도 있다. 다만 보안상 위험하니 실제 운영 환경에서는 쓰면 안 된다.

### 5. 주의할 점

CORS는 보안 설정이라 너무 느슨하게 열어두면 XSS(크로스 사이트 스크립팅)나 CSRF(Cross-Site Request Forgery) 공격에 취약해질 수 있다. 허용 범위는 필요한 만큼만 잡자.

개발하면서 자주 만나는 에러지만, 원리를 알고 서버에서 설정만 제대로 해주면 해결된다.
