---
title: "[SpringBoot] SecurityConfig 설정에 따른 인증오류.."
date: 2024-07-31 18:30:04 +0900
categories: [TroubleShooting, Backend]
tags: ["401에러", "api", "security", "securityconfig", "springboot", "인증오류"]
tistory_url: https://yoon-ssi.tistory.com/4
render_with_liquid: false
---

**!!!! 문제 상황**

진행 중인 프로젝트에서 이미지 파일을 AWS 서버에 업로드하는 방식으로 바꾸게 되었다.   
SpringBoot 프로젝트는 현재 관리자 페이지 API와 Client-API가 분리되어 있지 않고 프로젝트 내에 패키지만 별도로 구성되어 있다.   

Client-API 패키지에 작업을 한 이미지 업로드 API를 관리자 페이지에서 사용하려고 하니.. 401 인증오류가 나는 것이었다!!

아니 대체 무엇 때문에...?   

*****문제 해결 방법**

우선.. 로컬환경에서 테스트 하는 도중 jwt 토큰 관련한 에러가 발생했다.

![[SpringBoot] SecurityConfig 설정에 따른 인증오류..](/assets/img/posts/springboot-securityconfig-auth-error/01.png)

아니 토큰 값이 안들어갔다고?!   

개발자 도구를 켜서 확인해보니 토큰정보가 Header에 들어가 있다..   
디버그 모드 실행 후 doFilter() 메서드를 확인해 보았다.   
다른 API를 호출할 때는 모두 토큰값이 확인되는데, 업로드 API를 호출할 때만 토큰 값이 비어있는 것을 확인하였다.   

확인해 보니 업로드 API 호출 시 Client의 토큰값을 조회하고 있는 것이 문제였다.

관리자 페이지의 API는 시작경로가 "/admin", Client API는 시작경로가 "/api"로 되어있었고   
이 시작경로가 어떻게 되어있냐에 따라 SecurityConfig.java 파일에서 분기처리를 해주고 있던 것이었다.

ex) Client

```sql
@Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http, AuthenticationConfiguration authenticationConfiguration) throws Exception {

        http.securityMatcher("/api/**")
                .authorizeHttpRequests(request -> {
                    request.requestMatchers("/example/**").permitAll()
                            .anyRequest().authenticated();
                });

        http.addFilterAfter(jwtAuthFilter(), LogoutFilter.class);
        return http.build();
    }
```

ex) 관리자

```sql
@Bean
    public SecurityFilterChain 관리자securityFilterChain(HttpSecurity http, AuthenticationConfiguration authenticationConfiguration) throws Exception {

        http.securityMatcher("/api/**")
                .authorizeHttpRequests(request -> {
                    request.requestMatchers("/example/**").permitAll()
                            .anyRequest().authenticated();
                });

        http.addFilterAfter(관리자jwtAuthFilter(), LogoutFilter.class);
        return http.build();
    }
```

**그래서 Client API 패키지에 업로드 API가 작업된 부분과 동일하게 관리자 API 패키지에도 생성해 주었고 API 시작경로를 변경해 주었다.**  
**이를 통해 정상적으로 이미지 업로드 방식을 변경하는데 성공!!**

![emoticon](/assets/img/posts/springboot-securityconfig-auth-error/02.gif)
