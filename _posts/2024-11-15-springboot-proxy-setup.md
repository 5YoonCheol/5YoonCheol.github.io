---
title: "[SpringBoot] Proxy 설정 방법"
date: 2024-11-15 10:00:14 +0900
categories: ["Spring & SpringBoot"]
tags: ["proxy-설정", "spring"]
tistory_url: https://yoon-ssi.tistory.com/116
render_with_liquid: false
---

Spring Boot에서 Proxy 패턴은 외부 API 호출 시 클라이언트와 서버 간의 통신을 조절하고, 인증이나 로깅 등의 부가 기능을 추가하는 데 유용하다. Proxy 설정에는 Spring의 `RestTemplate` 또는 `WebClient`를 주로 사용하며, Spring에서의 기본적인 Proxy 설정 방법을 알아보자.

---

### 1. RestTemplate을 이용한 Proxy 설정

`RestTemplate`은 Spring에서 RESTful 웹 서비스를 호출할 때 유용한 HTTP 클라이언트이다.

Proxy를 설정하려면 `SimpleClientHttpRequestFactory`를 통해 `RestTemplate`에 Proxy 설정을 추가할 수 있습니다.

```
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

import java.net.InetSocketAddress;
import java.net.Proxy;

@Configuration
public class RestTemplateConfig {

    @Bean
    public RestTemplate restTemplate(RestTemplateBuilder builder) {
        // Proxy 설정
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        Proxy proxy = new Proxy(Proxy.Type.HTTP, new InetSocketAddress("proxyHost", proxyPort));
        factory.setProxy(proxy);

        return new RestTemplate(factory);
    }
}
```

위 코드에서 proxyHost와 proxyPort를 실제 프록시 서버의 호스트와 포트로 변경해주면 된다.

---

### 2. WebClient를 이용한 Proxy 설정

Spring WebFlux의 `WebClient`는 비동기 방식으로 REST API를 호출할 때 주로 사용되며, Proxy 설정도 가능하다.

```
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.netty.http.client.HttpClient;
import java.net.InetSocketAddress;
import java.net.Proxy;
import io.netty.handler.proxy.HttpProxyHandler;

@Configuration
public class WebClientConfig {

    @Bean
    public WebClient webClient() {
        // Proxy 설정
        HttpClient httpClient = HttpClient.create()
                .proxy(proxy -> proxy.type(Proxy.Type.HTTP)
                        .address(new InetSocketAddress("proxyHost", proxyPort))
                        .handler(new HttpProxyHandler(new InetSocketAddress("proxyHost", proxyPort))));

        return WebClient.builder()
                .clientConnector(new ReactorClientHttpConnector(httpClient))
                .build();
    }
}
```

여기서도 `proxyHost`와 `proxyPort`를 실제 프록시 서버 정보로 대체하면 된다.

### Proxy 패턴 활용 예시

Proxy 설정을 통해 API 호출 시 통신을 제어하고 부가 기능을 추가할 수 있다. 예를 들어, 인증이 필요한 외부 API의 경우, 헤더에 인증 토큰을 추가하여 통신을 안전하게 관리할 수 있다.
