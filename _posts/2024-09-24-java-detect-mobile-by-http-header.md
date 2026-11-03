---
title: "[Java] HTTP 헤더를 통해 모바일 여부 판단하기"
date: 2024-09-24 02:00:00 +0900
categories: [Backend, Java]
tags: ["getheader()", "모바일여부"]
tistory_url: https://yoon-ssi.tistory.com/64
render_with_liquid: false
---

개발을 하다보면 모바일과 PC 환경을 구분해서 처리해야 하는 경우가 생긴다.

이 때, 모바일인지 여부를 알 수 있는 방법 중 하나인 HTTP 헤더를 통한 방법에 대해서 알아보자.

---

모바일 여부를 판단하는 방법 중 하나는 클라이언트가 보낸 HTTP 요청의 **User-Agent** 헤더를 확인하는 것이다. request.getHeader() 메서드를 통해 이 **User-Agent** 값을 받아 모바일 기기인지 여부를 판단할 수 있다.

### 1. **User-Agent 헤더란?**

- **User-Agent** 헤더는 클라이언트의 장치, 운영 체제, 브라우저 정보 등을 포함하고 있는 문자열이다. 이를 통해 서버는 사용자가 어떤 종류의 장치(모바일, 데스크탑 등)를 사용하고 있는지 알 수 있다.

### 2. **모바일 여부 판단 방법**

모바일 브라우저의 User-Agent는 대개 iPhone, Android, Mobile 같은 키워드를 포함한다. 따라서 이 키워드를 기반으로 모바일 여부를 판단할 수 있다.

### 3. **Java 예시 (서블릿)**

```javascript
import javax.servlet.http.HttpServletRequest;

public class UserAgentUtils {

    public static boolean isMobile(HttpServletRequest request) {
        String userAgent = request.getHeader("User-Agent");
        if (userAgent == null) {
            return false;
        }

        // 모바일 기기의 User-Agent에 흔히 포함되는 문자열
        String[] mobileKeywords = {"Mobile", "Android", "iPhone", "iPad", "iPod", "BlackBerry", "Windows Phone"};

        // User-Agent에 모바일 기기의 키워드가 포함되어 있는지 확인
        for (String keyword : mobileKeywords) {
            if (userAgent.contains(keyword)) {
                return true;
            }
        }
        return false;
    }
}
```

### 4. **설명**

- request.getHeader("User-Agent")를 통해 클라이언트의 User-Agent 값을 가져온다.
- 모바일 장치에서 자주 사용되는 Mobile, Android, iPhone 등의 키워드를 포함한 배열을 준비한다.
- User-Agent에 해당 키워드 중 하나라도 포함되어 있으면, 해당 요청이 모바일 기기에서 왔다고 판단하여 true를 반환한다.

### 5. **주의 사항**

- User-Agent는 클라이언트가 임의로 조작할 수 있기 때문에 100% 신뢰할 수 있는 방법은 아니다. 그러나 대부분의 경우에는 이 방법으로 모바일 여부를 충분히 판단할 수 있다.
- 태블릿 기기의 경우에도 iPad 같은 키워드가 포함될 수 있으므로 필요에 따라 별도의 처리가 필요할 수 있다.

****참고: PC 환경에서 개발자모드를 통해 모바일 환경으로 변경하는 경우에는 아래 코드를 통해 체크할 수 있다.**

```java
import javax.servlet.http.HttpServletRequest;

public class UserAgentUtils {

    public static boolean isMobile(HttpServletRequest request) {
        String userAgent = request.getHeader("User-Agent");
        if (userAgent == null) {
            return false;
        }

        if (userAgent.contains("Mobile") && userAgent.contains("Touch")){
        	return true; //실제 모바일 환경일 경우 터치기능이 가능하다.
        }else{
        	return false;
        }
    }
}
```
