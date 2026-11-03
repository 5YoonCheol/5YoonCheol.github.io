---
title: "Form 전송 시 JSON타입 파라미터 매핑"
date: 2024-11-16 10:00:45 +0900
categories: [TroubleShooting, Backend]
tags: ["form", "post", "데이터"]
tistory_url: https://yoon-ssi.tistory.com/117
render_with_liquid: false
---

최근 엑셀 다운로드 기능을 추가하는 업무를 수행하던 도중 맞닥뜨린 문제이다.

검색폼을 통해 설정된 조건으로 조회한 데이터를 엑셀로 다운로드 할 수 있도록 기능을 제공하는 업무였는데,

form의 action 시에 검색조건 파라미터 값들이 전부 null로 들어가서 제대로 된 데이터를 추출할 수가 없었다.

JSP 파일에서 작업이 이루어졌고, JSP의 기본 form 제출 방식은 `application/x-www-form-urlencoded`형식이기 때문에 JSON타입의 파라미터를 받기 위해서는 form 태그의 데이터를 JavaScript를 통해 JSON 형식으로 변환하고 AJAX 요청을 사용하여 서버로 전송해야했다.

나의 경우는 위의 JavaScript를 통해 JSON 형식으로 form 데이터를 변환하는 방식으로 해결을 했는데  
구글링을 하던 중 @ModelAttribute를 사용하여 Form 데이터를 수신하는 방식도 있어서 알아보았다.

JSP 폼을 통해 직접 전송할 때 @RequestBody 대신 @ModelAttribute를 사용하여 데이터를 수신하는 방법이다. @ModelAttribute는 application/x-www-form-urlencoded 형식으로 데이터를 전송할 때 유용하게 사용할 수 있다.

먼저 예시 코드를 살펴보자.

---

**JSP 예시 코드**

```
<form action="/submit" method="post">
    <input type="text" name="name" value="test">
    <input type="text" name="email" value="test@example.com">
    <button type="submit">Submit</button>
</form>
```

**Controller 예시 코드**

```
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class FormController {

    @PostMapping("/submit")
    public String submitForm(@ModelAttribute FormData formData) {
        // formData를 이용한 로직 수행
        return "result";
    }

    public static class FormData {
        private String name;
        private String email;

        // Getters and Setters
    }
}
```

이 경우, @ModelAttribute는 요청 파라미터를 FormData 객체에 자동으로 매핑해 준다.

---

### 장점과 주의 사항

- **장점**: `@ModelAttribute`를 사용하면 요청 파라미터를 자바 객체에 매핑하는 코드가 단순해지고, 자동으로 바인딩되므로 코드가 간결해진다.
- **주의 사항**: 파라미터와 객체 필드의 이름이 일치해야 하며, 매핑할 객체에 기본 생성자와 세터 메서드가 있어야 한다.

form 데이터를 POST 방식으로 전송할 때, 필요한 파라미터 값들을 위의 방식을 활용하여 전송할 수 있다는 것을 알고 있으면 유용하지 않을까 생각한다.
