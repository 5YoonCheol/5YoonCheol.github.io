---
title: "JUnit을 활용한 유닛 테스트"
date: 2024-10-26 11:11:48 +0900
categories: ["ETC"]
tags: ["junit", "유닛-테스트"]
tistory_url: https://yoon-ssi.tistory.com/95
render_with_liquid: false
---

JUnit을 활용한 유닛 테스트는 자바 애플리케이션에서 개별 메서드나 클래스의 동작이 의도한 대로 수행되는지 확인하기 위한 테스트를 작성하는 방식이다.

JUnit은 자바에서 널리 사용되는 테스트 프레임워크로, 단위 테스트를 쉽게 작성하고 실행할 수 있게 도와준다.

오늘 포스팅에서는 JUnit 테스트를 작성하는 기본적인 방법과 핵심 개념에 대해 알아보자.

---

### 1. **JUnit 설정**

JUnit을 사용하기 위해서는 프로젝트에 JUnit 라이브러리를 추가해야 한다.

최신 버전은 **JUnit 5**인데, JUnit Jupiter라는 모듈을 사용한다.

#### Maven 설정 예시

만약 Maven 프로젝트를 사용한다면, pom.xml 파일에 다음과 같이 의존성을 추가할 수 있다.

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

#### Gradle 설정 예시

Gradle을 사용하는 경우 build.gradle 파일에 다음과 같이 추가한다.

```shell
testImplementation 'org.junit.jupiter:junit-jupiter-api:5.7.1'
testRuntimeOnly 'org.junit.jupiter:junit-jupiter-engine:5.7.1'
```

---

### 2. **JUnit 테스트 기본 구조**

JUnit 테스트는 기본적으로 다음과 같은 구조로 작성된다.

1. **테스트 클래스**: 테스트하려는 클래스에 대응하는 클래스를 생성한다.
2. **테스트 메서드**: 개별 메서드를 테스트하기 위해 여러 테스트 메서드를 작성한다.
3. **어노테이션**: @Test 어노테이션을 사용해 테스트 메서드임을 명시한다.

---

### 3. **JUnit 테스트 예시**

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

### 4. **주요 JUnit 어노테이션**

- **@Test**: 테스트 메서드로 선언. 이 어노테이션이 붙은 메서드는 JUnit에 의해 자동으로 실행된다.
- **@BeforeEach**: 각 테스트 메서드가 실행되기 전에 호출되는 메서드. 주로 테스트 환경 설정에 사용한다.

```java
@BeforeEach
public void setUp() {
    // 테스트 실행 전 초기화 코드
}
```

- **@AfterEach**: 각 테스트 메서드 실행 후 호출되는 메서드. 테스트 후 정리 작업에 사용한다.

```java
@AfterEach
public void tearDown() {
    // 테스트 실행 후 정리 코드
}
```

- **@BeforeAll**: 모든 테스트가 실행되기 전에 한 번 실행. 주로 공유 자원 초기화에 사용한다.

```java
@BeforeAll
public static void init() {
    // 클래스 전체에서 한 번만 실행되는 초기화 코드
}
```

- **@AfterAll**: 모든 테스트가 끝난 후 한 번 실행한다.

```java
@AfterAll
public static void cleanup() {
    // 클래스 전체에서 한 번만 실행되는 정리 코드
}
```

---

### 5. **Assertions (단언문)**

JUnit 테스트에서 **Assertions**는 테스트 결과를 확인하는 방법이다.

예상된 값과 실제 결과를 비교해 테스트가 성공했는지 확인한다.

- **assertEquals(expected, actual)**: 예상 값과 실제 값이 같은지 확인.

```java
assertEquals(5, calc.add(2, 3));
```

- **assertTrue(condition)**: 조건이 참인지 확인.

```java
assertTrue(result > 0);
```

- **assertFalse(condition)**: 조건이 거짓인지 확인.

```java
assertFalse(result < 0);
```

- **assertNull(object)**: 객체가 null인지 확인.

```java
assertNull(someObject);
```

- **assertNotNull(object)**: 객체가 null이 아닌지 확인.

```java
assertNotNull(someObject);
```

- **assertThrows(expectedException.class, executable)**: 특정 예외가 발생하는지 확인.

```java
assertThrows(ArithmeticException.class, () -> calc.divide(10, 0));
```

---

### 6. **테스트 스위트(Test Suite)**

JUnit은 여러 테스트 클래스를 하나의 테스트 스위트로 묶어서 한 번에 실행할 수 있다.

이를 통해 관련된 테스트를 그룹화할 수 있다.

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

### 7. **Mocking과 의존성 주입 테스트**

때로는 유닛 테스트에서 실제 객체 대신 **Mock 객체**를 사용해 외부 의존성을 가짜로 처리해야 할 때가 있다.

이때는 **Mockito**와 같은 모킹 라이브러리를 사용할 수 있다.

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

### 8. **JUnit의 장점**

- **자동화된 테스트**: 개발 중 자주 테스트를 실행할 수 있어 빠르게 피드백을 받을 수 있음.
- **리그레션 방지**: 기존 기능에 문제가 생기지 않았는지 확인할 수 있음.
- **코드 품질 향상**: 단위 테스트를 통해 코드가 의도한 대로 작동하는지 보장할 수 있음.
