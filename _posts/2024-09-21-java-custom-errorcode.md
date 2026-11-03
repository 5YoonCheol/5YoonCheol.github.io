---
title: "[Java] ErrorCode 커스텀하기"
date: 2024-09-21 08:08:42 +0900
categories: [Backend, Java]
tags: ["custom", "errorcode", "java", "커스텀에러"]
tistory_url: https://yoon-ssi.tistory.com/60
render_with_liquid: false
---

오늘은 Java에서 ErrorCode를 직접 정의해서 쓰는 방법을 알아보자.

ErrorCode를 직접 만들어 쓰면 애플리케이션에서 나는 오류를 관리하기 쉬워지고, 사용자도 무슨 에러인지 이해하기 쉬워진다.

기본 예외 클래스(Exception 또는 RuntimeException)를 상속받아 만들고, 여기에 우리가 정한 에러 코드와 에러 메시지를 담는다.

---

### 1. 커스텀 예외 클래스 만들기

Exception이나 RuntimeException을 상속받으면 된다. Exception을 상속하면 Checked Exception이 되고, RuntimeException을 상속하면 Unchecked Exception이 된다.

```java
public class CustomException extends Exception {
    private int errorCode;  // 에러 코드를 저장할 변수

    public CustomException(int errorCode, String message) {
        super(message);  // 예외 메시지를 부모 클래스에 전달
        this.errorCode = errorCode;  // 에러 코드 저장
    }

    public int getErrorCode() {
        return errorCode;  // 에러 코드를 반환하는 메서드
    }
}
```

CustomException은 에러 코드와 메시지를 받아서 갖고 있도록 만들었다. 예외가 났을 때 좀 더 구체적인 에러 코드를 같이 넘길 수 있다.

### 2. 커스텀 예외 사용하기

이제 실제로 예외를 던지고 잡아보자. try-catch에서 잡은 다음 에러 코드와 메시지를 출력하거나 로그로 남기면 된다.

```java
public class Main {
    public static void main(String[] args) {
        try {
            validateUserInput(0);  // 0은 유효하지 않은 값
        } catch (CustomException e) {
            System.out.println("Error Code: " + e.getErrorCode());
            System.out.println("Error Message: " + e.getMessage());
        }
    }

    public static void validateUserInput(int input) throws CustomException {
        if (input <= 0) {
            throw new CustomException(1001, "유효하지 않은 입력 값입니다.");  // 에러 코드와 메시지를 포함하여 예외를 발생시킴
        }
    }
}
```

출력 결과는 이렇다.

```shell
Error Code: 1001
Error Message: 유효하지 않은 입력 값입니다.
```

### 3. 에러 코드를 Enum으로 관리하기

에러 코드를 숫자나 문자열로 여기저기 흩어 두면 금방 엉킨다. Enum으로 모아두면 한곳에서 일관되게 정의할 수 있고 읽기도 편하다.

Enum으로 ErrorCode 정의

```java
public enum ErrorCode {
    INVALID_INPUT(1001, "유효하지 않은 입력 값입니다."),
    USER_NOT_FOUND(1002, "사용자를 찾을 수 없습니다.");

    private int code;
    private String message;

    ErrorCode(int code, String message) {
        this.code = code;
        this.message = message;
    }

    public int getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }
}

public class CustomException extends Exception {
    private ErrorCode errorCode;

    public CustomException(ErrorCode errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
    }

    public int getErrorCode() {
        return errorCode.getCode();
    }
}
```

Enum을 쓰는 커스텀 예외 발생과 처리

```java
public class Main {
    public static void main(String[] args) {
        try {
            validateUserInput(0);  // 유효하지 않은 값
        } catch (CustomException e) {
            System.out.println("Error Code: " + e.getErrorCode());
            System.out.println("Error Message: " + e.getMessage());
        }
    }

    public static void validateUserInput(int input) throws CustomException {
        if (input <= 0) {
            throw new CustomException(ErrorCode.INVALID_INPUT);  // Enum을 사용한 예외 처리
        }
    }
}
```

출력 결과는 이렇다.

```bash
Error Code: 1001
Error Message: 유효하지 않은 입력 값입니다.
```

### 4. 실제 프로젝트에서는

- 에러 코드를 Enum으로 정의해두면 코드마다 고유한 번호와 메시지를 붙일 수 있어서 에러를 일관되게 관리할 수 있다.
- 예외는 보통 로그 파일에 남겨서 디버깅할 때 본다. 커스텀 예외를 쓰면 구체적인 에러 코드와 메시지가 로그에 같이 남는다.
- Spring 같은 프레임워크에서는 전역 예외 처리를 만들어서 모든 예외를 한곳에서 처리하고, 사용자에게 알맞은 에러 응답을 돌려줄 수 있다.

---

커스텀 예외와 에러 코드를 만들어 두면 에러 원인을 더 빨리 파악할 수 있고, 사용자에게도 구체적인 정보를 줄 수 있다.
