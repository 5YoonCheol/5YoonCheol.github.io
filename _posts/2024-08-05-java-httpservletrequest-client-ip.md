---
title: "[Java] HttpServletRequest를 통하여 Client IP 주소 가져오기"
date: 2024-08-05 22:05:41 +0900
categories: [Backend, Java]
tags: ["httpservletrequest", "ip주소", "java"]
tistory_url: https://yoon-ssi.tistory.com/9
render_with_liquid: false
---

## **HttpServletRequest?**

**HttpServletRequest**는 자바 서블릿 API에서 HTTP 요청 정보를 표현하는 인터페이스다.   
주로 클라이언트에서 서버로 전송되는 HTTP 요청을 처리할 때 사용된다.   
 **HttpServletRequest**를 이용하면 클라이언트가 전송한 데이터, 요청 메서드(GET, POST 등), 요청 URL, 헤더 정보 등을 쉽게 가져올 수 있다.

---

## **클라이언트 IP 주소 가져오기**

**HttpServletRequest**를 사용해서 클라이언트의 IP주소를 가져오기 위해서는 getRemoteAddr() 메서드를 사용하면 된다.

로컬이나 개발서버의 테스트 단계에서는 getRemoteAddr()메서드 하나로 대부분 정확한 IP주소를 가져올 수 있다.   
그러나, 실제 운영 단계에서는 프록시 서버, 로드 밸런싱을 활용하는 서버가 많다.  
**** 보안, 캐싱, 필터링, 부하 감소 등을 위해 사용한다**

때문에 실제 클라이언트의 IP주소를 얻기 위해서는 추가적인 헤더 정보를 확인해야 하는 경우가 있다.

추가 헤더 정보를 확인해서 클라이언트의 IP주소를 가져오는 예제를 살펴보자.

```java
private String getClientIp(HttpServletRequest request) {
    String[] headers = {
        "X-Forwarded-For",
        "Proxy-Client-IP",
        "WL-Proxy-Client-IP",
        "HTTP_CLIENT_IP",
        "HTTP_X_FORWARDED_FOR"
    };

    for (String header : headers) {
        String ip = request.getHeader(header);
        if (ip != null && !ip.isEmpty() && !"unknown".equalsIgnoreCase(ip)) {
            return ip;
        }
    }
    return request.getRemoteAddr();
}
```

추가적으로 체크해야할 헤더들을 배열에 저장하고, 반복문을 통해 간결하게 처리했다.   
IP주소를 체크하는 상황은 많으니 잘 활용해보자!!

![emoticon](/assets/img/posts/java-httpservletrequest-client-ip/01.gif)
