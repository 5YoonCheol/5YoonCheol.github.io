---
title: "[Java] HttpServletRequest를 통하여 Client IP 주소 가져오기"
date: 2024-08-05 02:00:00 +0900
categories: [Backend, Java]
tags: ["httpservletrequest", "ip주소", "java"]
description: HttpServletRequest의 getRemoteAddr()와 X-Forwarded-For 같은 프록시 헤더를 확인해 실제 클라이언트 IP를 가져오는 방법을 정리한다.
tistory_url: https://yoon-ssi.tistory.com/9
tistory_urls: [https://yoon-ssi.tistory.com/9, https://yoon-ssi.tistory.com/10]
redirect_from:
  - /posts/java-httpservletrequest-client-ip-2/
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

---

## **운영에서 이 코드가 함정이 되는 경우**

> 2026년 11월에 보강했다. 같은 내용의 글이 두 개 있어서 하나로 합치고, 헤더를 그대로 믿으면 생기는 문제를 추가했다.
{: .prompt-info }

위 코드는 "헤더가 있으면 그 값을 쓴다"는 전제라서, 그대로 운영에 올리면 두 가지 문제가 생긴다.

### 1. `X-Forwarded-For`는 누구나 보낼 수 있다

이 헤더는 프록시가 붙여 주는 값이지만, 클라이언트가 요청에 직접 넣어서 보낼 수도 있다. 로드 밸런서가 그 값을 지우지 않고 뒤에 자기 값을 덧붙이면 헤더는 이런 모양이 된다.

```
X-Forwarded-For: 1.2.3.4(조작값), 203.0.113.10(실제 클라이언트), 10.0.0.5(내부 프록시)
```

위 코드는 쉼표로 나뉜 첫 번째 값을 돌려주니 조작된 IP를 믿게 된다. 이 IP로 차단이나 로그인 제한을 걸면 쉽게 우회된다. 안전하게 쓰려면 "내가 믿는 프록시 수"만큼 뒤에서부터 세어 와야 한다. 프록시가 로드 밸런서 하나뿐이면 뒤에서 두 번째 값이 클라이언트다.

```java
private String getClientIp(HttpServletRequest request) {
    String forwarded = request.getHeader("X-Forwarded-For");
    if (forwarded == null || forwarded.isBlank()) {
        return request.getRemoteAddr();
    }
    String[] hops = forwarded.split(",");
    int trustedProxies = 1; // 로드 밸런서 한 대. 인프라 구성에 맞게 설정값으로 뺀다
    int index = Math.max(hops.length - 1 - trustedProxies, 0);
    return hops[index].trim();
}
```

`Proxy-Client-IP`, `WL-Proxy-Client-IP` 같은 헤더는 특정 WAS 제품에서만 쓰던 것이라 요즘 구성에서는 거의 오지 않는다. 쓰지 않는 헤더를 후보에 넣어 두면 그만큼 조작할 자리만 늘어나니 실제 프록시가 붙이는 헤더 하나만 본다.

### 2. Spring이 대신 처리하게 하는 쪽이 낫다

헤더를 직접 파싱하는 대신 Spring Boot 설정으로 `getRemoteAddr()`이 바로 클라이언트 IP를 돌려주게 할 수 있다.

```yaml
server:
  forward-headers-strategy: native   # Tomcat의 RemoteIpValve 사용
  tomcat:
    remoteip:
      internal-proxies: 10\.\d{1,3}\.\d{1,3}\.\d{1,3}   # 믿을 내부 프록시 대역
```

`native`로 두면 Tomcat이 `internal-proxies`에 해당하는 주소에서 온 `X-Forwarded-For`만 신뢰하고, 그 결과를 `getRemoteAddr()`에 넣어 준다. 이러면 애플리케이션 코드에서는 헤더를 신경 쓰지 않아도 되고, 프록시 구성이 바뀌어도 설정만 고치면 된다. 로드 밸런서가 `Forwarded` 표준 헤더(RFC 7239)를 쓰면 `framework` 전략과 `ForwardedHeaderFilter`를 쓴다.

정리하면, 개발 환경에서는 `getRemoteAddr()`로 충분하고, 운영에서는 "어느 프록시를 믿을지"를 정한 뒤 그 설정을 서버에 맡기는 게 가장 안전하다.

![emoticon](/assets/img/posts/java-httpservletrequest-client-ip/01.gif)
