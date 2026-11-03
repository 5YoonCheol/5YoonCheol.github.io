---
title: "[ETC] WS(Web Server)와 WAS(Web Application Server)의 차이"
date: 2024-09-07 02:00:00 +0900
categories: [CS, Network]
tags: ["was", "ws", "차이", "특징"]
tistory_url: https://yoon-ssi.tistory.com/46
render_with_liquid: false
---

Nginx랑 Tomcat은 둘 다 "서버"라고 부르는데 뭐가 다를까? 이번엔 WS(Web Server)와 WAS(Web Application Server)의 차이를 정리해보자.

둘 다 웹 애플리케이션을 서비스할 때 쓰는 서버 소프트웨어지만 맡는 일이 다르다.

---

### 1. Web Server (WS)

Web Server는 브라우저 같은 클라이언트에게서 HTTP 요청을 받아 정적 콘텐츠(HTML, CSS, 이미지 등)를 돌려주는 서버다. 이미 만들어져 있는 파일을 찾아서 그대로 내주는 게 주 업무다.

하는 일을 보면 이렇다.

- 정적 콘텐츠 제공: HTML, CSS, JavaScript 파일, 이미지, 비디오 같은 정적 리소스를 전달한다.
- HTTP 요청 처리: 요청을 받아서 거기에 맞는 응답(주로 정적 파일)을 돌려준다.
- 리버스 프록시: 요청을 WAS나 다른 서버로 넘겨주는 역할도 한다.

Apache HTTP Server, Nginx, Microsoft IIS가 대표적이다. 블로그나 포트폴리오 같은 간단한 사이트를 띄우거나, WAS 앞에 두고 정적 리소스는 직접 처리하면서 동적 요청만 WAS로 넘기는 용도로 많이 쓴다.

---

### 2. Web Application Server (WAS)

WAS는 동적 콘텐츠를 만들어서 내주는 서버다. 애플리케이션 로직을 실행하고, 필요하면 DB와 주고받아서 요청마다 다른 응답을 만들어낸다.

하는 일을 보면 이렇다.

- 동적 콘텐츠 생성: 요청에 따라 HTML, JSON, XML 같은 응답을 그때그때 만든다. 이 과정에서 DB를 조회하기도 한다.
- 비즈니스 로직 처리: 사용자 입력을 처리하거나 DB에서 데이터를 가져오는 등 애플리케이션의 핵심 로직을 실행한다.
- 세션 관리: 로그인 상태 유지처럼 사용자별 세션을 관리한다.
- 트랜잭션 관리: DB 트랜잭션을 관리해서 데이터 일관성을 지킨다.

Apache Tomcat, IBM WebSphere, Oracle WebLogic, JBoss가 대표적이다. 비즈니스 로직이 복잡한 대규모 웹 애플리케이션, 커머스, 포털 사이트 같은 곳에서 쓴다.

---

### 3. 비교

| 특성 | Web Server (WS) | Web Application Server (WAS) |
| --- | --- | --- |
| 기능 | 정적 콘텐츠(HTML, CSS, 이미지 등) 제공 | 동적 콘텐츠 생성, 비즈니스 로직 처리 |
| 주요 역할 | HTTP 요청을 받아 정적 파일 반환 | 동적 처리와 DB 연동 |
| 예시 | Apache HTTP Server, Nginx | Apache Tomcat, WebSphere, WebLogic |
| 사용 예 | 간단한 웹 사이트, WAS 앞단 프록시 | 대규모 웹 애플리케이션, 커머스 사이트 등 |
| 복잡도 | 상대적으로 단순 | 상대적으로 복잡 |

---

### 4. 요청이 들어오면

- WS: 클라이언트가 페이지를 요청하면 해당 정적 파일을 찾아서 그대로 돌려준다. 단순한 만큼 빠르게 처리하도록 만들어져 있다.
- WAS: 클라이언트가 데이터나 동적 페이지를 요청하면 비즈니스 로직을 돌리고, 필요한 데이터를 DB에서 가져와 콘텐츠를 만든 다음 응답한다.

---

그래서 실제로는 둘 중 하나만 쓰기보다 같이 쓰는 경우가 많다. 앞단의 Web Server가 정적 콘텐츠를 처리하고, 동적인 요청만 뒤의 WAS로 넘기는 구성이다.
