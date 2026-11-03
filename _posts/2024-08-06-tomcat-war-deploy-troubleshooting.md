---
title: "[톰캣] WAR 파일 배포 문제 해결"
date: 2024-08-06 23:04:42 +0900
categories: [TroubleShooting, Backend]
tags: ["tomcat(톰캣)", "war", "배포", "서버"]
tistory_url: https://yoon-ssi.tistory.com/11
render_with_liquid: false
---

요새는 Jenkins, GitLab CI/CD, Travis, Azure 등을 활용하여 배포하는 경우가 많은데   
아직 관련된 배포라인을 구성해 놓지 않은 상태에서   
원격서버에 WAR 파일을 수동배포해야 하는 상황이 닥쳤다...!

열심히 구글링을 하여 관련된 자료들을 검색했고   
순서를 정리해 보았다.

**1. 배포할 WAR파일 준비**

- IntelliJ를 사용한다면 상단 메뉴의 Build -&gt; Build Artifacts... -&gt; Build 를 통해 손쉽게 WAR파일을 만들 수 있다.

**2. Tomcat 배포 디렉토리에 WAR파일 복사**

- 일반적으로 Tomcat 디렉토리의 webapps 폴더에 war파일을 복사하여 배포한다.

**3. Tomcat 재시작 (선택사항)**

- 톰캣은 기본적으로 webapps 폴더에 새로운 war파일이 복사되면 자동으로 배포한다.
- server.xml 내부의 autoDeploy = true 로 설정되어져 있기 때문.

나의 경우 2번 항목부터 문제가 발생했다..

Tomcat 설정파일을 확인하지 않고 구글링한 정보대로 webapps 폴더 밑으로 war파일을 복사하였고

톰캣을 재시작 했는데 배포가 진행되지 않았다..

![emoticon](/assets/img/posts/tomcat-war-deploy-troubleshooting/01.png)

원인은 Tomcat의 server.xml의 태그 안의 appBase가 다른 경로로 되어있었기 때문이었다.  
WAR파일을 해당 경로에 복사해줘야 했다.

그 후 다시 시도..

실패...

Tomcat의 catalina.out 로그를 통해 확인해보니

SSL 인증을 위한 pem 파일이 설정파일에 지정된 위치에 존재하지 않았다.

pem 파일을 지정 위치로 옮겨주고 다시 시도!!

catalina.out 로그를 보니 war파일의 배치가 완료되었다고 나왔다!!

(나중에 알게 된 사실..) Tomcat Native가 설치되어 있지 않으면 pem파일을 그대로 사용할 수 없다고 하는데 문제없이 적용된 것을 보니 설치가 되어있었던 것 같다.  

test용 API를 호출해 보았는데.. 404에러 발생..  
war파일을 재배포 해보기도 하고

프로젝트의 Java 버전과 서버에 깔려있는 Java 버전을 비교해보기도 했지만

원인을 찾지 못하던 도중..

**Tomcat과 스프링부트 프로젝트의 호환이 맞지 않을수도 있다**는 포스팅을 발견..!

기존 톰캣은 Tomcat9 버전이었는데   
프로젝트의 Spring 버전은 6.x.x, SpringBoot 버전은 3.x.x 였다.   
Spring 내장 톰캣의 버전은 10버전인 것으로 확인!!

버전 업그레이드를 진행해보기로 했다.  

혹시 몰라 원격서버의 Tomcat은 11버전으로 설치해줬다.

이후 재시도.. 제발...!!   

**결과는 성공이었다!!!**

글로 적으니깐 정말 별거 아닌거 같은데.. 이걸 해결하기 위해 하루 업무시간을 모두 투자했던 것 같다..

그래도 실패로 끝나지 않아서 만족한다!

![emoticon](/assets/img/posts/tomcat-war-deploy-troubleshooting/02.gif)
