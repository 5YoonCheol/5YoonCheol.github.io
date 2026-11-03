---
title: "[Java] AES-256을 이용한 양방향 암호화 구현"
date: 2024-10-04 07:07:07 +0900
categories: ["Java"]
tags: ["aes-256", "java", "양방향-암호화"]
tistory_url: https://yoon-ssi.tistory.com/73
render_with_liquid: false
---

Java에서는 javax.crypto 패키지를 사용하여 AES-256 암호화를 쉽게 구현할 수 있다.

AES-256을 사용하기 위해서는 비밀키(Secret Key)와 초기화 벡터(IV, Initialization Vector)가 필요하다.

**초기화 벡터**는 암호화를 더욱 안전하게 만들기 위해 사용되며, 동일한 평문도 암호화할 때마다 다른 암호문을 생성하는 역할을 한다.

---

#### 1. AES-256 암호화/복호화의 기본 개념

- **키(Secret Key)**: AES-256에서는 256비트(32바이트) 길이의 비밀 키를 사용한다.
- **초기화 벡터(IV)**: 암호화 모드가 CBC(Cipher Block Chaining)와 같은 블록 암호화 모드를 사용할 때 초기화 벡터가 필요하다. 일반적으로 16바이트 크기를 사용한다.
- **암호화/복호화 모드**: 보통 AES-256은 **CBC** 모드 또는 **GCM** 모드를 사용한다. CBC는 기본적으로 많이 사용되지만, GCM은 추가로 무결성 검사를 포함하여 보안을 강화할 수 있다.

#### 2. Java에서 AES-256 구현 방법

준비 사항

- Java 버전이 **Java 8** 이상이어야 하며, **JCE(Java Cryptography Extension) 무제한 정책 파일**을 설치하여 AES-256을 사용할 수 있도록 설정해야 한다. JDK 8 이후 버전에서는 기본적으로 지원된다.

```java
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.SecureRandom;
import java.util.Base64;

public class AES256Example {

    // 256비트(32바이트) AES 키를 생성하는 메소드
    public static SecretKey generateKey(int n) throws Exception {
        KeyGenerator keyGenerator = KeyGenerator.getInstance("AES");
        keyGenerator.init(n); // n은 키 크기, 256을 설정
        return keyGenerator.generateKey();
    }

    // 초기화 벡터(IV) 생성 메소드
    public static IvParameterSpec generateIv() {
        byte[] iv = new byte[16]; // AES 블록 크기는 16바이트
        new SecureRandom().nextBytes(iv);
        return new IvParameterSpec(iv);
    }

    // AES-256 암호화 메소드
    public static String encrypt(String algorithm, String input, SecretKey key, IvParameterSpec iv) throws Exception {
        Cipher cipher = Cipher.getInstance(algorithm); // CBC 모드와 패딩 적용
        cipher.init(Cipher.ENCRYPT_MODE, key, iv); // 암호화 모드로 초기화
        byte[] cipherText = cipher.doFinal(input.getBytes());
        return Base64.getEncoder().encodeToString(cipherText); // 암호문을 Base64로 인코딩하여 반환
    }

    // AES-256 복호화 메소드
    public static String decrypt(String algorithm, String cipherText, SecretKey key, IvParameterSpec iv) throws Exception {
        Cipher cipher = Cipher.getInstance(algorithm); // CBC 모드와 패딩 적용
        cipher.init(Cipher.DECRYPT_MODE, key, iv); // 복호화 모드로 초기화
        byte[] plainText = cipher.doFinal(Base64.getDecoder().decode(cipherText)); // Base64로 인코딩된 암호문을 디코딩 후 복호화
        return new String(plainText);
    }

    public static void main(String[] args) throws Exception {
        String algorithm = "AES/CBC/PKCS5Padding"; // AES-256 암호화 알고리즘 및 모드 설정
        String input = "Hello, AES-256 Encryption!"; // 암호화할 평문

        // 256비트 AES 키와 IV 생성
        SecretKey key = generateKey(256);
        IvParameterSpec iv = generateIv();

        // 암호화
        String cipherText = encrypt(algorithm, input, key, iv);
        System.out.println("암호화된 텍스트: " + cipherText);

        // 복호화
        String decryptedText = decrypt(algorithm, cipherText, key, iv);
        System.out.println("복호화된 텍스트: " + decryptedText);
    }
}
```

- **generateKey**: 256비트 AES 키를 생성하는 메소드이다. **KeyGenerator**를 사용하여 원하는 길이(256비트)의 비밀키를 생성한다.
- **generateIv**: 16바이트 길이의 초기화 벡터(IV)를 생성한다. 암호화할 때마다 새로 생성된 IV를 사용한다.
- **encrypt**: AES-256을 사용하여 평문을 암호화하는 메소드이다. 암호화된 결과는 **Base64**로 인코딩하여 반환된다. CBC 모드를 사용하며, 패딩 방식은 **PKCS5Padding**을 적용한다.
- **decrypt**: 암호화된 텍스트를 복호화하는 메소드이다. Base64로 인코딩된 암호문을 **디코딩**한 후 AES-256으로 복호화다.

**실행 결과**

- **암호화된 텍스트**: 입력된 평문이 암호화되어 출력된다. 같은 평문이라도 IV가 다르면 다른 암호문이 생성된다.
- **복호화된 텍스트**: 암호화된 텍스트가 복호화되어 원래의 평문으로 복원된다.

### 3. 중요한 보안 고려 사항

1. **키와 IV 관리**: 암호화에서 가장 중요한 부분은 **키와 IV**의 관리이다. 키와 IV는 안전한 방식으로 저장하고 전달해야 하며, 절대 노출되지 않도록 해야 한다.
2. **패딩 방식**: AES는 고정된 블록 크기(16바이트)로 데이터를 처리하기 때문에, 블록 크기보다 작은 데이터를 처리할 때는 **패딩**을 사용해야 한다. Java에서는 주로 **PKCS5Padding**을 사용한다.
3. **CBC 모드의 보안성**: CBC 모드는 일반적으로 안전하지만, 동일한 키와 IV로 여러 번 암호화를 수행하면 보안성이 약화될 수 있다. 따라서 **IV는 반드시 매번 새로 생성**되어야 하며, 암호문과 함께 전달된다.
4. **GCM 모드**: 보다 높은 보안을 위해 GCM 모드(AES/GCM/NoPadding)를 사용할 수 있다. GCM 모드는 무결성 검증 기능을 추가로 제공하므로, 보안을 강화할 수 있다.

### 4. 결론

AES-256을 사용한 양방향 암호화는 보안성이 매우 뛰어나며, Java의 javax.crypto 패키지를 사용하여 손쉽게 구현할 수 있다. 그러나 암호화 과정에서 사용되는 **키 관리**와 **IV 처리**에 신중해야 하며, 최신의 보안 표준을 따라 구현하는 것이 중요하다.
