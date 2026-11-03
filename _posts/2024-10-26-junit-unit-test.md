---
title: "JUnit을 활용한 유닛 테스트"
date: 2024-10-26 02:00:00 +0900
categories: [Backend, Java]
tags: ["junit", "유닛-테스트"]
tistory_url: https://yoon-ssi.tistory.com/95
render_with_liquid: false
---

유닛 테스트는 메서드나 클래스 하나하나가 의도대로 동작하는지 확인하는 테스트다. 자바에서는 보통 JUnit으로 작성한다.

이번엔 JUnit으로 테스트를 작성하는 기본적인 방법을 정리해보자.

---

### 1. JUnit 설정

먼저 프로젝트에 JUnit 라이브러리를 추가해야 한다. 최신 버전은 JUnit 5이고, JUnit Jupiter라는 모듈을 쓴다.

#### Maven

pom.xml에 의존성을 추가한다.

```shell
<dependencies>
    <dependency>
        <groupId>org.junit.jupiter</groupId>
        <artifactId>junit-jupiter-api</artifactId>
        <version>5.7.1</version>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>org.junit.jupiter</groupId>
        <artifactId>junit-jupiter-engine</artifactId>
        <version>5.7.1</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```

#### Gradle

build.gradle에는 이렇게 추가한다.

```shell
testImplementation 'org.junit.jupiter:junit-jupiter-api:5.7.1'
testRuntimeOnly 'org.junit.jupiter:junit-jupiter-engine:5.7.1'
```

---

### 2. 기본 구조

테스트는 대략 이런 식으로 짠다.

1. 테스트 클래스: 테스트할 클래스마다 짝이 되는 테스트 클래스를 만든다.
2. 테스트 메서드: 확인하고 싶은 동작마다 테스트 메서드를 만든다.
3. 어노테이션: 테스트 메서드에는 @Test를 붙인다.

---

### 3. 예시

더하기와 0으로 나누기를 테스트해보자.

```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class CalculatorTest {

    // 테스트할 대상 메서드: 더하기 기능
    @Test
    public void testAddition() {
        Calculator calc = new Calculator();
        int result = calc.add(2, 3);
        // 기대 값과 실제 값이 일치하는지 검증
        assertEquals(5, result, "2 + 3은 5여야 한다");
    }

    // 나누기 기능 테스트 (예외 발생)
    @Test
    public void testDivisionByZero() {
        Calculator calc = new Calculator();
        // 예외가 발생하는지 검증
        assertThrows(ArithmeticException.class, () -> {
            calc.divide(10, 0);
        });
    }
}
```

---

### 4. 자주 쓰는 어노테이션

@Test가 붙은 메서드는 JUnit이 알아서 실행한다. 여기에 테스트 전후로 뭔가 해야 할 때 쓰는 어노테이션들이 있다.

@BeforeEach는 각 테스트 메서드가 돌기 전에 매번 실행된다. 테스트 환경을 준비할 때 쓴다.

```java
@BeforeEach
public void setUp() {
    // 테스트 실행 전 초기화 코드
}
```

@AfterEach는 각 테스트 메서드가 끝난 뒤에 매번 실행된다. 정리 작업에 쓴다.

```java
@AfterEach
public void tearDown() {
    // 테스트 실행 후 정리 코드
}
```

@BeforeAll은 모든 테스트가 돌기 전에 딱 한 번 실행된다. 공유 자원을 초기화할 때 쓴다.

```java
@BeforeAll
public static void init() {
    // 클래스 전체에서 한 번만 실행되는 초기화 코드
}
```

@AfterAll은 모든 테스트가 끝난 뒤에 한 번 실행된다.

```java
@AfterAll
public static void cleanup() {
    // 클래스 전체에서 한 번만 실행되는 정리 코드
}
```

---

### 5. Assertions (단언문)

테스트 결과를 확인하는 방법이다. 예상한 값과 실제 결과를 비교해서 테스트가 성공했는지 판단한다.

assertEquals(expected, actual)는 예상 값과 실제 값이 같은지 본다.

```java
assertEquals(5, calc.add(2, 3));
```

assertTrue(condition)는 조건이 참인지 본다.

```java
assertTrue(result > 0);
```

assertFalse(condition)는 조건이 거짓인지 본다.

```java
assertFalse(result < 0);
```

assertNull(object)는 객체가 null인지 본다.

```java
assertNull(someObject);
```

assertNotNull(object)는 객체가 null이 아닌지 본다.

```java
assertNotNull(someObject);
```

assertThrows(expectedException.class, executable)는 특정 예외가 발생하는지 본다.

```java
assertThrows(ArithmeticException.class, () -> calc.divide(10, 0));
```

---

### 6. 테스트 묶기

관련된 테스트들을 묶어서 한 번에 돌릴 수도 있다. 아래는 @Nested로 더하기 테스트와 나누기 테스트를 그룹으로 나눈 예시다.

```java
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Nested;
import static org.junit.jupiter.api.Assertions.*;

public class MathTestSuite {

    @Nested
    class AdditionTests {
        @Test
        void testPositiveNumbers() {
            assertEquals(5, new Calculator().add(2, 3));
        }

        @Test
        void testNegativeNumbers() {
            assertEquals(-1, new Calculator().add(-2, 1));
        }
    }

    @Nested
    class DivisionTests {
        @Test
        void testValidDivision() {
            assertEquals(5, new Calculator().divide(10, 2));
        }

        @Test
        void testDivisionByZero() {
            assertThrows(ArithmeticException.class, () -> new Calculator().divide(10, 0));
        }
    }
}
```

---

### 7. Mock으로 의존성 대신하기

테스트할 때 실제 객체 대신 가짜(Mock) 객체를 넣어야 할 때가 있다. DB나 외부 API처럼 테스트에서 직접 부르기 곤란한 의존성이 그렇다. 이럴 땐 Mockito 같은 라이브러리를 쓴다.

```java
import org.junit.jupiter.api.Test;
import static org.mockito.Mockito.*;

public class UserServiceTest {

    @Test
    public void testGetUserById() {
        // Mock 객체 생성
        UserRepository mockRepo = mock(UserRepository.class);

        // 리포지토리에서 특정 사용자를 반환하도록 설정
        when(mockRepo.findById(1L)).thenReturn(new User(1L, "John"));

        // 서비스에 Mock 객체를 주입
        UserService userService = new UserService(mockRepo);

        // 실제 테스트
        User user = userService.getUserById(1L);
        assertEquals("John", user.getName());
    }
}
```

---

### 8. 왜 쓰나

- 개발하면서 테스트를 자주 돌릴 수 있어서 피드백이 빠르다.
- 코드를 고친 뒤에 기존 기능이 깨지지 않았는지(리그레션) 바로 확인할 수 있다.
- 코드가 의도대로 동작한다는 걸 테스트로 보장할 수 있다.
