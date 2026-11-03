---
title: "@RequestBody와 @RequestParam 어노테이션 역할과 차이점"
date: 2024-08-01 18:34:27 +0900
categories: ["Spring & SpringBoot"]
tags: ["annotation", "java", "requestbody", "requestparam", "spring", "springboot", "어노테이션"]
tistory_url: https://yoon-ssi.tistory.com/5
render_with_liquid: false
---

오늘 포스팅에서는 Spring Framework에서 자주 사용하는 어노테이션인   
**@RequestBody**와 **@RequestParam**의 역할과 차이점에 대해서 다뤄보려고 한다.

먼저 **@RequestBody**  
Http 요청의 Body 데이터를 Java 객체로 변환해주는 역할을 한다.

우리가 자주 사용하는 Method 방식 GET, POST, PUT, DELETE 중   
POST, PUT, DELETE 방식에서 주로 사용한다.

위의 3가지 방식으로 요청을 보낼 때는 주로 JSON 형태의 데이터를 많이 사용하는데

이를 우리가 미리 생성해둔 Java 객체로 변환해 준다.

예시를 보자.

```javascript
const params =
{
	"name" : "개발자 윤씨",
	"phoneNum" : "010-1234-5678",
    	"email" : "dev_oh@example.com"
};
```

이러한 JSON 형태의 데이터를 보낼 때 우리가 미리 선언해 둔 Java객체

```java
@Data
public class User {
	private String name;
    	private String phoneNum;
    	private String email;
}
```

User의 변수 name, phoneNum, email 값으로 변환시켜 주는 역할을 한다.

```java
@PostMapping("/users")
public ResponseEntity<User> createUser(@RequestBody User user) {
    // user 객체는 요청 본문에서 변환된 데이터
    userService.save(user);
    return new ResponseEntity<>(user, HttpStatus.CREATED);
}
```

다음은 **@RequestParam**

GET 요청 URL에 포함된 파라미터 혹은 POST 요청 방식의 FormData를 처리해 주는 역할을 한다.

예시를 보자.

```java
http://localhost:8080/users?name=개발자 윤씨&phoneNum=010-1234-5678
```

이러한 GET 방식 URL 요청이 들어왔을 때

```java
@GetMapping("/users")
public ResponseEntity<User> getUserById(@RequestParam(value = "name", required = false) String name, @RequestParam(value = "phoneNum") String phoneNum) {

    User user = userService.findById(id);
    return new ResponseEntity<>(user, HttpStatus.OK);
}
```

**@RequestParam** 어노테이션을 활용하여 필수 여부 등을 지정하고 URL파라미터를 메서드 파라미터로 바인딩해서 사용할 수 있다.

POST 방식의 FormData 예제도 살펴보자.

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Form</title>
</head>
<body>
    <form action="/submitForm" method="post">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name">
        <br>
        <label for="phoneNum">PhoneNumber:</label>
        <input type="text" id="phoneNum" name="phoneNum">
        <br>
        <button type="submit">Submit</button>
    </form>
</body>
</html>
```

Submit 버튼을 눌러 FormData를 전송했을 때 이를 처리하는 Spring Controller도 확인해 보자.

```java
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class UserController {

    @PostMapping("/submitForm")
    public ModelAndView submitForm(@RequestParam("name") String name, @RequestParam("phoneNum") String email) {
        // 폼에서 전달된 name과 phoneNum 사용하여 로직을 처리
        System.out.println("Name: " + name);
        System.out.println("PhoneNumber: " + phoneNum);

        // 데이터를 뷰로 전달하거나 다른 처리를 수행
        ModelAndView modelAndView = new ModelAndView("formResult");
        modelAndView.addObject("name", name);
        modelAndView.addObject("phoneNum", email);
        return modelAndView;
    }
}
```

FormData의 "name", "phoneNum" 값을 @RequestParam 어노테이션을 통해서 메서드 파라미터로 바인딩하고 로직을 수행한다.

**이제 두 어노테이션의 차이점에 대해 알아보자!**

**@RequestBody**는 HTTP 요청 본문에 포함된 데이터를 처리하고, 주로 구조화된 데이터(JSON, XML 등)를 Java 객체로 변환하는 데 사용된다.

**@RequestParam**는 URL 쿼리 파라미터나 폼 데이터를 처리하고, 간단한 데이터 타입이나 단일 값을 Java 메서드 파라미터로 바인딩하는 데 사용된다.

비슷하게 생겼지만 서로 다른 두 어노테이션의 역할과 차이를 이해하는데 도움이 되기를..!!
