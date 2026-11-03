---
title: "[Java] SHA-256을 통한 단방향 암호화 구현하기"
date: 2024-10-07 07:07:05 +0900
categories: ["Java"]
tags: ["java", "sha-256", "단방향-암호화"]
tistory_url: https://yoon-ssi.tistory.com/76
render_with_liquid: false
---

**SHA-256**은 **단방향 암호화 알고리즘**인 **SHA-2(Secure Hash Algorithm 2)** 계열 중 하나로, 256비트(32바이트)의 해시값을 생성한다. 단방향 암호화는 입력값을 고정된 크기의 해시값으로 변환하지만, 이 값을 다시 원래의 입력값으로 복원할 수 없는 특성을 가진다. 따라서 주로 비밀번호 저장이나 데이터 무결성 검증에 많이 사용된다.

SHA-256은 Java의 내장 라이브러리인 java.security.MessageDigest를 사용하면 간단하게 처리할 수 있다.

---

**SHA-256을 통한 단방향 암호화 구현 예제**

```java
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SHA256Example {

    // 입력값을 SHA-256으로 해싱하는 메소드
    public static String hash(String input) {
        try {
            // SHA-256 해시 함수를 위한 MessageDigest 객체 생성
            MessageDigest digest = MessageDigest.getInstance("SHA-256");

            // 입력값의 바이트 배열을 해시 처리
            byte[] hash = digest.digest(input.getBytes("UTF-8"));

            // 해시된 바이트 배열을 16진수 문자열로 변환
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0'); // 한 자리일 경우 앞에 0 추가
                hexString.append(hex);
            }

            return hexString.toString(); // 16진수 문자열 반환
        } catch (Exception e) {
            throw new RuntimeException(e); // 오류 발생 시 처리
        }
    }

    public static void main(String[] args) {
        String originalString = "Hello, SHA-256!";

        // 입력값을 SHA-256 해시로 변환
        String hashedString = hash(originalString);

        // 결과 출력
        System.out.println("원본 문자열: " + originalString);
        System.out.println("SHA-256 해시 값: " + hashedString);
    }
}
```

**MessageDigest 객체 생성**

```java
MessageDigest digest = MessageDigest.getInstance("SHA-256");
```

- Java의 MessageDigest 클래스를 사용하여 SHA-256 해시 함수를 위한 인스턴스를 생성한다.
- getInstance("SHA-256")을 호출하여 **SHA-256** 알고리즘을 사용하도록 설정한다.

**입력값 해싱**

```java
byte[] hash = digest.digest(input.getBytes("UTF-8"));
```

- 입력 문자열을 **UTF-8**로 인코딩한 후, digest() 메소드를 통해 입력값의 해시를 계산한다.
- 결과는 32바이트(256비트)의 해시값을 포함하는 바이트 배열로 반환된다.

**바이트 배열을 16진수 문자열로 변환**

```java
StringBuilder hexString = new StringBuilder();
for (byte b : hash) {
    String hex = Integer.toHexString(0xff & b);
    if (hex.length() == 1) hexString.append('0');
    hexString.append(hex);
}
```

- 해시 결과는 바이트 배열로 반환되므로, 이를 사람이 읽을 수 있는 **16진수 문자열**로 변환한다.
- 각 바이트를 2자리의 16진수로 변환하며, 자릿수가 1자리일 경우 앞에 0을 추가한다.

**결과 출력**

```java
System.out.println("원본 문자열: " + originalString);
System.out.println("SHA-256 해시 값: " + hashedString);
```

**실행 결과**

```java
원본 문자열: Hello, SHA-256!
SHA-256 해시 값: 334d6eae14f8f4341a092329d3fdbd0cbb6c875014d283a69e169b6341f38b88
```

- Hello, SHA-256!이라는 입력 문자열이 **SHA-256 해시 값**으로 변환되었다.
- 같은 입력값은 항상 동일한 해시값을 반환하지만, 해시값만으로는 원본 데이터를 복구할 수 없다.

---

### SHA-256의 특징

1. **단방향성**: 한 번 해시된 값은 원래 값을 복원할 수 없다. 이 특징 때문에 **비밀번호 저장**이나 **무결성 검증**에 적합하다.
2. **고정된 길이**: 입력값의 길이에 상관없이 결과 해시값은 항상 256비트(32바이트)로 고정된다.
3. **충돌 회피**: **해시 충돌**이란 서로 다른 입력값이 동일한 해시값을 생성하는 경우를 의미한다. SHA-256은 매우 낮은 충돌 확률을 제공하여 안전한 알고리즘으로 평가받는다.
4. **속도**: SHA-256은 충분히 빠른 속도를 제공하지만, 비밀번호 저장에 사용할 경우 추가적인 **솔트**(Salt)와 **키 스트레칭** 기법을 사용하는 것이 안전하다. 이를 위해 **PBKDF2**, **bcrypt**, **scrypt** 등의 알고리즘이 더 적합할 수 있다.

### 실무에서의 SHA-256 사용

1. **비밀번호 저장**
   - SHA-256을 그대로 사용하면 **레인보우 테이블 공격**에 취약해질 수 있다. 이를 방지하기 위해 솔트(Salt)를 추가하여 해싱하는 것이 일반적이다.
   - **솔트**는 각 비밀번호마다 고유한 임의의 데이터를 추가해 해시를 생성하는 방식으로, 동일한 비밀번호라도 다른 해시값이 생성되도록 한다.
2. **데이터 무결성 검증**
   - 파일이나 메시지의 무결성을 검증할 때도 SHA-256을 사용한다. 예를 들어, 파일을 다운로드한 후 그 파일의 해시값을 비교해 손상 여부를 확인할 수 있다.
