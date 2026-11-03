---
title: "[Java] ErrorCode 커스텀하기"
date: 2024-09-21 08:08:42 +0900
categories: [Backend, Java]
tags: ["custom", "errorcode", "java", "커스텀에러"]
tistory_url: https://yoon-ssi.tistory.com/60
render_with_liquid: false
---

오늘 포스팅에서는 Java에서 ErrorCode를 커스터마이징하여 사용하는 방법에 대하여 알아보자.

ErrorCode를 커스텀하면 애플리케이션에서 발생하는 특정 오류들을 관리하기 쉬워지고

사용자가 Error를 이해하기 쉬워지는 장점이 있다.

기본 제공되는 예외 클래스(Exception 또는 RuntimeException)를 상속받아 만들며, 이를 통해 **사용자 정의 에러 코드**와 **에러 메시지**를 포함할 수 있다.

---

### 1. **커스텀 예외 클래스 만들기**

Java에서 예외 클래스를 커스텀하기 위해서는 Exception 또는 RuntimeException을 상속받아야 한다.

Exception을 상속하면 **Checked Exception**이 되고, RuntimeException을 상속하면 **Unchecked Exception**이 된다.

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

위 예시에서 CustomException 클래스는 기본적으로 에러 코드와 메시지를 받아 처리할 수 있도록 설계되었다.

이를 통해 발생한 예외에 대해 더 구체적인 에러 코드를 제공할 수 있다.

### 2. **커스텀 예외 사용하기**

커스텀 예외를 정의한 후, 실제로 예외를 발생시키고 처리하는 코드를 작성한다.

try-catch 블록에서 예외가 발생하면 해당 예외를 처리하고, 에러 코드와 메시지를 출력하거나 로그로 남길 수 있다.

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

출력 결과는 다음과 같다.

```shell
Error Code: 1001
Error Message: 유효하지 않은 입력 값입니다.
```

### 3. **에러 코드 관리 (Enum 사용)**

커스텀 예외에서 에러 코드를 더욱 효율적으로 관리하기 위해 **Enum**을 사용할 수 있다.

이렇게 하면 에러 코드를 일관되게 정의할 수 있으며, 가독성과 유지보수성을 향상시킬 수 있다.

**Enum을 통한 ErrorCode 관리**

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

**Enum을 활용한 커스텀 예외 발생 및 처리**

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

출력 결과는 다음과 같다.

```bash
Error Code: 1001
Error Message: 유효하지 않은 입력 값입니다.
```

### 4. **실제 프로젝트에서의 활용**

- **Enum을 통한 에러 코드 관리**: 에러 코드를 Enum으로 정의하면, 각 코드에 고유한 번호와 메시지를 부여할 수 있어 일관성 있는 에러 관리가 가능하다.
- **로그 기록**: 발생한 예외는 주로 로그 파일에 기록되어 디버깅 시 중요한 정보를 제공해준다. 커스텀 예외를 통해 구체적인 에러 코드와 메시지를 로그로 남길 수 있다.
- **전역 예외 처리**: 스프링(Spring) 프레임워크 같은 환경에서는 전역 예외 처리를 구현해 모든 예외를 중앙에서 관리하고, 사용자에게 적절한 에러 응답을 보낼 수 있다.

---

### 결론

Java에서 커스텀 예외를 만들고, 에러 코드를 정의함으로써 보다 세밀하고 직관적인 예외 처리가 가능하다.

이를 통해 에러의 원인을 보다 명확하게 파악할 수 있고, 사용자에게 구체적인 정보를 제공할 수 있어 시스템의 안정성과 가독성이 향상된다.
