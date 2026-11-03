---
title: "[Java] 대표적인 Exception 종류와 해결방법"
date: 2024-09-20 08:08:00 +0900
categories: [Backend, Java]
tags: ["exception", "java"]
tistory_url: https://yoon-ssi.tistory.com/59
render_with_liquid: false
---

오늘 포스팅에서는 Java에서 발생하는 대표적인 예외(Exception)들과 해결방법에 대해서 알아보자.

---

### Exception 이란?

Java에서 예외(Exception)는 프로그램 실행 중 발생할 수 있는 오류 상황을 처리하기 위한 기법이다.

예외는 Exception 클래스를 상속하며, 일반적으로 크게 **Checked Exception**과 **Unchecked Exception**으로 나눌 수 있다.

---

### 1. **Checked Exception**

Checked Exception은 컴파일 시점에서 반드시 처리해야 하는 예외이다. 예외 처리 코드(try-catch 혹은 throws)가 없으면 컴파일 오류가 발생한다. 주로 외부 자원(파일, 네트워크 등)과의 작업 중에 발생한다.

**대표적인 Checked Exception**

- **IOException**: 입출력 작업 중 발생하는 예외로, 파일 읽기/쓰기, 네트워크 통신 등의 작업에서 발생할 수 있다.
- **SQLException**: 데이터베이스 관련 작업 중 발생하는 예외이다. SQL 쿼리 실행 중 오류가 발생할 때 throw된다.
- **ClassNotFoundException**: 특정 클래스를 찾지 못했을 때 발생하는 예외로, 주로 동적 클래스 로딩 시 사용된다.
- **FileNotFoundException**: 지정한 파일을 찾지 못할 때 발생하는 예외이다. IOException의 하위 클래스이다.
- **InterruptedException**: 스레드가 대기 상태에서 인터럽트되었을 때 발생하는 예외이다.

### 2. **Unchecked Exception (Runtime Exception)**

Unchecked Exception은 컴파일러가 예외 처리를 강제하지 않는 예외이다. 즉, 발생할 가능성이 있는 예외에 대해 명시적으로 처리하지 않아도 된다.

대부분의 RuntimeException은 프로그래밍 오류(논리 오류 또는 사용자 실수)로 인해 발생한다.

**대표적인 Unchecked Exception**

- **NullPointerException**: 참조 변수가 null일 때 해당 변수를 사용하려 하면 발생하는 예외이다.
- **ArrayIndexOutOfBoundsException**: 배열의 인덱스가 유효 범위를 벗어났을 때 발생하는 예외이다.
- **ArithmeticException**: 수학적 계산에서 오류가 발생했을 때 발생하는 예외이다. 예를 들어, 0으로 나누기를 시도할 때 발생한다.
- **IllegalArgumentException**: 메소드에 잘못된 인수가 전달될 때 발생하는 예외이다.
- **ClassCastException**: 객체를 잘못된 타입으로 캐스팅하려 할 때 발생하는 예외이다.
- **NumberFormatException**: 문자열을 숫자로 변환할 때 해당 문자열이 숫자 형식에 맞지 않으면 발생하는 예외이다.

### 3. **Error**

Error는 애플리케이션이 처리할 수 없는 심각한 문제를 나타낸다. 대부분 자바 프로그램 자체에서 해결할 수 없는 상황에서 발생하며, 예외 처리로 해결할 수 없다. 예를 들어 메모리 부족 등의 시스템 수준에서 발생하는 문제이다.

**대표적인 Error**

- **OutOfMemoryError**: JVM의 힙 메모리가 부족할 때 발생하는 오류이다.
- **StackOverflowError**: 메소드 호출이 너무 깊어져 스택이 넘칠 때 발생하는 오류이다. 주로 재귀 호출이 과도할 때 발생한니다.
- **VirtualMachineError**: JVM에서 심각한 문제가 발생했을 때 발생하는 오류로, 시스템 오류에 가깝다.

---

### 대표적인 예외들과 해결 방법

### 1. **IOException**

**발생 원인**: 파일 읽기/쓰기, 네트워크 통신 등의 입출력 작업에서 문제가 발생할 때.

**해결 방법**:

- 파일이나 네트워크 자원이 존재하는지, 권한이 있는지 확인한다.
- 파일이 정상적으로 닫히도록 finally 블록에서 자원을 해제한다.

```java
try {
    FileReader file = new FileReader("file.txt");
} catch (IOException e) {
    e.printStackTrace();  // 예외 발생 시 오류 로그를 출력
} finally {
    // 자원 해제
}
```

### 2. **SQLException**

**발생 원인**: 데이터베이스와의 연결 또는 SQL 쿼리 실행 중 오류 발생.

**해결 방법**:

- SQL 쿼리 문법을 확인하고, 올바른 데이터베이스 URL 및 자격 증명을 사용한다.
- 데이터베이스 연결이 올바르게 설정되어 있는지 확인한다.
- 자원을 사용한 후 close() 메서드를 통해 연결을 닫아 메모리 누수를 방지한다.

```java
try {
    Connection conn = DriverManager.getConnection(url, user, password);
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM users");
} catch (SQLException e) {
    e.printStackTrace();  // SQL 예외 발생 시 처리
} finally {
    // 자원 해제
}
```

### 3. **NullPointerException**

**발생 원인**: 참조 변수가 null인데 이를 사용하려 할 때 발생.

**해결 방법**:

- 객체가 null인지 먼저 확인한 후 접근한다.
- Optional 클래스를 활용하여 null을 안전하게 처리한다.

```java
String str = null;
if (str != null) {
    System.out.println(str.length());
} else {
    System.out.println("str은 null입니다.");
}
```

### 4. **ArrayIndexOutOfBoundsException**

**발생 원인**: 배열의 유효 범위를 벗어난 인덱스에 접근할 때 발생.

**해결 방법**:

- 배열의 인덱스가 유효한 범위 내에 있는지 체크한다.
- 배열의 길이를 확인한 후 접근한다.

```java
int[] arr = new int[5];
int index = 5;
if (index < arr.length) {
    System.out.println(arr[index]);
} else {
    System.out.println("인덱스가 범위를 벗어났습니다.");
}
```

### 5. **ArithmeticException**

**발생 원인**: 0으로 나누는 등의 잘못된 수학 연산이 발생할 때.

**해결 방법**:

- 나누기 연산 전에 분모가 0인지 확인한다.

```java
int a = 10;
int b = 0;
if (b != 0) {
    System.out.println(a / b);
} else {
    System.out.println("0으로 나눌 수 없습니다.");
}
```

### 6. **ClassCastException**

**발생 원인**: 잘못된 형 변환을 시도할 때 발생.

**해결 방법**:

- 형 변환 전에 객체의 타입을 확인한다.
- instanceof 연산자를 사용하여 올바른 타입인지 체크한다.

```java
Object obj = "Hello";
if (obj instanceof String) {
    String str = (String) obj;
    System.out.println(str);
} else {
    System.out.println("잘못된 형 변환입니다.");
}
```

### 7. **FileNotFoundException**

**발생 원인**: 지정한 파일을 찾을 수 없을 때 발생.

**해결 방법**:

- 파일 경로가 정확한지 확인한다.
- 파일이 존재하는지 확인하고, 파일에 접근할 권한이 있는지 점검한다.

```java
try {
    FileInputStream file = new FileInputStream("non_existent_file.txt");
} catch (FileNotFoundException e) {
    System.out.println("파일을 찾을 수 없습니다.");
}
```
