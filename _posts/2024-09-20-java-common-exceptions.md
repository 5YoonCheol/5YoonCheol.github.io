---
title: "[Java] 대표적인 Exception 종류와 해결방법"
date: 2024-09-20 02:00:00 +0900
categories: [Backend, Java]
tags: ["exception", "java"]
tistory_url: https://yoon-ssi.tistory.com/59
render_with_liquid: false
---

개발하다 보면 매일같이 만나는 게 예외다. 이번엔 Java에서 자주 보는 예외들과 각각 어떻게 대처하면 되는지 정리해보자.

---

### Exception 이란?

예외(Exception)는 프로그램이 실행되는 도중에 생기는 오류 상황을 처리하기 위한 장치다.

예외 클래스는 Exception을 상속하고, 크게 **Checked Exception**과 **Unchecked Exception**으로 나뉜다. 여기에 예외는 아니지만 같이 알아두면 좋은 Error도 있다.

---

### 1. Checked Exception

컴파일 시점에 반드시 처리해야 하는 예외다. try-catch로 잡든 throws로 넘기든 뭔가 하지 않으면 컴파일 자체가 안 된다. 파일이나 네트워크처럼 외부 자원을 다룰 때 주로 나온다.

자주 보는 것들:

- IOException: 파일 읽기/쓰기, 네트워크 통신 같은 입출력 중에 문제가 생겼을 때
- SQLException: DB 작업 중, 예를 들어 SQL 실행하다 오류가 났을 때
- ClassNotFoundException: 클래스를 못 찾았을 때. 주로 클래스를 동적으로 로딩할 때 나온다
- FileNotFoundException: 지정한 파일이 없을 때. IOException의 하위 클래스다
- InterruptedException: 대기 중인 스레드가 인터럽트됐을 때

### 2. Unchecked Exception (Runtime Exception)

컴파일러가 처리를 강제하지 않는 예외다. 발생할 수 있어도 코드에서 꼭 잡아줄 필요는 없다.

대부분은 로직 실수나 잘못된 입력 같은 프로그래밍 오류 때문에 생긴다.

자주 보는 것들:

- NullPointerException: null인 참조 변수를 쓰려고 할 때
- ArrayIndexOutOfBoundsException: 배열 인덱스가 범위를 벗어났을 때
- ArithmeticException: 0으로 나누기처럼 계산이 잘못됐을 때
- IllegalArgumentException: 메소드에 잘못된 인자를 넘겼을 때
- ClassCastException: 객체를 맞지 않는 타입으로 캐스팅할 때
- NumberFormatException: 숫자 형식이 아닌 문자열을 숫자로 바꾸려 할 때

### 3. Error

Error는 애플리케이션이 감당할 수 없는 심각한 문제다. 메모리 부족처럼 시스템 수준에서 생기는 문제라서 예외 처리로 해결할 수 있는 성격이 아니다.

- OutOfMemoryError: JVM 힙 메모리가 부족할 때
- StackOverflowError: 메소드 호출이 너무 깊어져서 스택이 넘칠 때. 재귀를 잘못 짜면 자주 본다
- VirtualMachineError: JVM 자체에 심각한 문제가 생겼을 때

---

### 예외별 원인과 해결 방법

### 1. IOException

파일 읽기/쓰기나 네트워크 통신처럼 입출력하다가 문제가 생기면 발생한다.

파일이나 네트워크 자원이 실제로 있는지, 접근 권한은 있는지부터 확인하자. 그리고 finally 블록에서 자원을 해제해서 파일이 확실히 닫히게 해주는 게 좋다.

```java
try {
    FileReader file = new FileReader("file.txt");
} catch (IOException e) {
    e.printStackTrace();  // 예외 발생 시 오류 로그를 출력
} finally {
    // 자원 해제
}
```

### 2. SQLException

DB 연결이나 SQL 실행 중에 오류가 나면 발생한다.

SQL 문법이 맞는지, DB URL과 계정 정보가 맞는지, 연결 설정이 제대로 됐는지 확인해보자. 다 쓴 자원은 close()로 닫아줘야 메모리 누수가 안 생긴다.

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

### 3. NullPointerException

null인 참조 변수를 쓰려고 하면 발생한다. 아마 제일 많이 보는 예외일 거다.

객체를 쓰기 전에 null인지 먼저 확인하거나, Optional을 써서 null을 안전하게 다루면 된다.

```java
String str = null;
if (str != null) {
    System.out.println(str.length());
} else {
    System.out.println("str은 null입니다.");
}
```

### 4. ArrayIndexOutOfBoundsException

배열 범위를 벗어난 인덱스에 접근하면 발생한다.

인덱스가 배열 길이 안에 있는지 확인하고 접근하면 된다.

```java
int[] arr = new int[5];
int index = 5;
if (index < arr.length) {
    System.out.println(arr[index]);
} else {
    System.out.println("인덱스가 범위를 벗어났습니다.");
}
```

### 5. ArithmeticException

0으로 나누는 것처럼 잘못된 연산을 하면 발생한다.

나누기 전에 분모가 0인지 확인하자.

```java
int a = 10;
int b = 0;
if (b != 0) {
    System.out.println(a / b);
} else {
    System.out.println("0으로 나눌 수 없습니다.");
}
```

### 6. ClassCastException

타입이 맞지 않는 형 변환을 하면 발생한다.

캐스팅하기 전에 instanceof로 타입을 먼저 확인하면 된다.

```java
Object obj = "Hello";
if (obj instanceof String) {
    String str = (String) obj;
    System.out.println(str);
} else {
    System.out.println("잘못된 형 변환입니다.");
}
```

### 7. FileNotFoundException

지정한 파일을 찾을 수 없을 때 발생한다.

경로가 정확한지, 파일이 정말 있는지, 접근 권한은 있는지 확인해보자.

```java
try {
    FileInputStream file = new FileInputStream("non_existent_file.txt");
} catch (FileNotFoundException e) {
    System.out.println("파일을 찾을 수 없습니다.");
}
```
