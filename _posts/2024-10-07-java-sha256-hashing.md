---
title: "[Java] SHA-256을 통한 단방향 암호화 구현하기"
date: 2024-10-07 02:00:00 +0900
categories: [Backend, Java]
tags: ["java", "sha-256", "단방향-암호화"]
tistory_url: https://yoon-ssi.tistory.com/76
render_with_liquid: false
---

SHA-256은 단방향 암호화 알고리즘인 SHA-2(Secure Hash Algorithm 2) 계열 중 하나로, 256비트(32바이트) 해시값을 만든다. 단방향이라는 건 입력값을 고정 길이 해시값으로 바꿀 수는 있어도, 그 해시값으로 원래 입력을 되돌릴 수는 없다는 뜻이다. 그래서 비밀번호 저장이나 데이터 무결성 검증에 많이 쓴다.

Java에서는 내장 라이브러리 `java.security.MessageDigest`로 간단하게 만들 수 있다.

---

### SHA-256 단방향 암호화 구현 예제

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

#### MessageDigest 객체 만들기

```java
MessageDigest digest = MessageDigest.getInstance("SHA-256");
```

- MessageDigest 클래스로 SHA-256 해시 함수 인스턴스를 만든다.
- `getInstance("SHA-256")`으로 SHA-256 알고리즘을 쓰겠다고 지정한다.

#### 입력값 해싱

```java
byte[] hash = digest.digest(input.getBytes("UTF-8"));
```

- 입력 문자열을 UTF-8로 인코딩한 다음 `digest()`로 해시를 계산한다.
- 결과는 32바이트(256비트) 해시값이 담긴 바이트 배열이다.

#### 바이트 배열을 16진수 문자열로 바꾸기

```java
StringBuilder hexString = new StringBuilder();
for (byte b : hash) {
    String hex = Integer.toHexString(0xff & b);
    if (hex.length() == 1) hexString.append('0');
    hexString.append(hex);
}
```

- 바이트 배열은 사람이 읽기 어려우니 16진수 문자열로 바꾼다.
- 바이트 하나를 2자리 16진수로 바꾸고, 1자리면 앞에 0을 붙인다.

#### 결과 출력

```java
System.out.println("원본 문자열: " + originalString);
System.out.println("SHA-256 해시 값: " + hashedString);
```

#### 실행 결과

```java
원본 문자열: Hello, SHA-256!
SHA-256 해시 값: 334d6eae14f8f4341a092329d3fdbd0cbb6c875014d283a69e169b6341f38b88
```

- "Hello, SHA-256!"이 SHA-256 해시값으로 바뀌었다.
- 같은 입력은 항상 같은 해시값이 나오지만, 해시값만 보고 원본을 알아낼 수는 없다.

---

### SHA-256의 특징

1. 단방향성: 한 번 해시한 값은 원래대로 되돌릴 수 없다. 그래서 비밀번호 저장이나 무결성 검증에 맞다.
2. 고정 길이: 입력이 얼마나 길든 결과는 항상 256비트(32바이트)다.
3. 충돌 회피: 해시 충돌은 서로 다른 입력이 같은 해시값을 만드는 경우를 말한다. SHA-256은 충돌 확률이 아주 낮아서 안전한 알고리즘으로 평가받는다.
4. 속도: 충분히 빠르다. 다만 비밀번호 저장에 쓸 때는 솔트(Salt)와 키 스트레칭을 같이 쓰는 게 안전하고, 이 용도로는 PBKDF2, bcrypt, scrypt 같은 알고리즘이 더 맞을 수 있다.

### 실무에서는

1. 비밀번호 저장
   - SHA-256을 그대로 쓰면 레인보우 테이블 공격에 약하다. 그래서 보통 솔트(Salt)를 붙여서 해싱한다.
   - 솔트는 비밀번호마다 다른 임의의 데이터를 붙여 해시를 만드는 방식이라, 같은 비밀번호라도 해시값이 달라진다.
2. 데이터 무결성 검증
   - 파일이나 메시지가 변조되지 않았는지 확인할 때도 쓴다. 파일을 내려받은 뒤 해시값을 비교해서 손상됐는지 확인하는 식이다.
