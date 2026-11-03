---
title: "[Java] AES-256을 이용한 양방향 암호화 구현"
date: 2024-10-04 07:07:07 +0900
categories: [Backend, Java]
tags: ["aes-256", "java", "양방향-암호화"]
tistory_url: https://yoon-ssi.tistory.com/73
render_with_liquid: false
---

Java에서는 javax.crypto 패키지만 있으면 AES-256 암호화를 어렵지 않게 구현할 수 있다.

AES-256을 쓰려면 비밀키(Secret Key)와 초기화 벡터(IV, Initialization Vector)가 필요하다.

초기화 벡터는 같은 평문이라도 암호화할 때마다 다른 암호문이 나오게 해서 암호화를 더 안전하게 만들어준다.

---

#### 1. 기본 개념

- 키(Secret Key): AES-256은 256비트(32바이트) 길이의 비밀 키를 쓴다.
- 초기화 벡터(IV): CBC(Cipher Block Chaining) 같은 블록 암호화 모드를 쓸 때 필요하다. 보통 16바이트다.
- 암호화 모드: 보통 CBC나 GCM을 쓴다. CBC가 기본으로 많이 쓰이고, GCM은 무결성 검사까지 해줘서 더 안전하다.

#### 2. Java로 구현하기

Java 8 이상이어야 한다. 예전에는 JCE(Java Cryptography Extension) 무제한 정책 파일을 따로 설치해야 AES-256을 쓸 수 있었는데, JDK 8 이후 버전에서는 기본으로 지원된다.

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

메소드별로 보면 이렇다.

- generateKey: KeyGenerator로 256비트 AES 비밀키를 만든다.
- generateIv: 16바이트 IV를 만든다. 암호화할 때마다 새로 만든 IV를 쓴다.
- encrypt: 평문을 AES-256으로 암호화하고 결과를 Base64로 인코딩해서 돌려준다. CBC 모드에 패딩은 PKCS5Padding을 썼다.
- decrypt: Base64로 인코딩된 암호문을 디코딩한 다음 AES-256으로 복호화한다.

실행하면 먼저 암호화된 텍스트가 출력되는데, 같은 평문이라도 IV가 다르면 매번 다른 암호문이 나온다. 그다음 복호화된 텍스트로 원래 평문이 그대로 돌아오는 걸 확인할 수 있다.

### 3. 보안상 꼭 챙겨야 할 것

1. 키와 IV 관리: 암호화에서 제일 중요한 건 결국 키와 IV 관리다. 안전하게 저장하고 전달해야 하고, 절대 노출되면 안 된다.
2. 패딩: AES는 16바이트 블록 단위로 처리해서, 블록보다 작은 데이터는 패딩으로 채워야 한다. Java에서는 주로 PKCS5Padding을 쓴다.
3. CBC 모드와 IV: CBC는 보통 안전하지만, 같은 키와 IV로 여러 번 암호화하면 보안이 약해진다. 그래서 IV는 매번 새로 만들고 암호문과 같이 넘겨야 한다.
4. GCM 모드: 더 높은 보안이 필요하면 GCM 모드(AES/GCM/NoPadding)를 쓰면 된다. 무결성 검증까지 해준다.

---

AES-256 양방향 암호화는 보안성이 높고, javax.crypto로 금방 구현할 수 있다. 다만 키 관리와 IV 처리를 허술하게 하면 소용이 없으니 그 부분은 특히 신경 써서 구현해야 한다.
