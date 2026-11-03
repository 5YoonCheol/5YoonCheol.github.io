---
title: "Form 전송 시 JSON타입 파라미터 매핑"
date: 2024-11-16 02:00:00 +0900
categories: [TroubleShooting, Backend]
tags: ["form", "post", "데이터"]
tistory_url: https://yoon-ssi.tistory.com/117
render_with_liquid: false
---

최근 엑셀 다운로드 기능을 추가하는 업무를 하다가 맞닥뜨린 문제이다.

검색폼에서 설정한 조건으로 조회한 데이터를 엑셀로 다운로드할 수 있게 하는 업무였는데,

form의 action 시에 검색조건 파라미터 값들이 전부 null로 들어가서 제대로 된 데이터를 뽑을 수가 없었다.

JSP 파일에서 작업했고, JSP의 기본 form 제출 방식은 `application/x-www-form-urlencoded` 형식이라 JSON 타입의 파라미터를 받으려면 form 데이터를 JavaScript로 JSON 형식으로 바꾸고 AJAX 요청으로 서버에 보내야 했다.

나는 JavaScript로 form 데이터를 JSON으로 바꾸는 방식으로 해결했는데,
구글링을 하다 보니 @ModelAttribute로 Form 데이터를 받는 방식도 있어서 알아보았다.

JSP 폼에서 바로 전송할 때 @RequestBody 대신 @ModelAttribute로 데이터를 받는 방법이다. @ModelAttribute는 `application/x-www-form-urlencoded` 형식으로 데이터를 보낼 때 쓰기 좋다.

먼저 예시 코드를 보자.

---

JSP 예시 코드

```
<form action="/submit" method="post">
    <input type="text" name="name" value="test">
    <input type="text" name="email" value="test@example.com">
    <button type="submit">Submit</button>
</form>
```

Controller 예시 코드

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

이렇게 하면 @ModelAttribute가 요청 파라미터를 FormData 객체에 자동으로 매핑해 준다.

---

### 장점과 주의 사항

- 장점: `@ModelAttribute`를 쓰면 요청 파라미터를 자바 객체에 알아서 바인딩해주니 매핑 코드가 짧아진다.
- 주의 사항: 파라미터 이름과 객체 필드 이름이 같아야 하고, 매핑할 객체에 기본 생성자와 setter가 있어야 한다.

form 데이터를 POST로 보낼 때 필요한 파라미터 값들을 이런 방식으로도 보낼 수 있다는 걸 알고 있으면 유용하지 않을까 생각한다.
