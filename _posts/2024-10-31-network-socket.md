---
title: "[네트워크] Socket(소켓)"
date: 2024-10-31 10:00:14 +0900
categories: ["네트워크"]
tags: ["socket", "소켓"]
tistory_url: https://yoon-ssi.tistory.com/100
render_with_liquid: false
---

소켓은 **네트워크 상에서 데이터를 주고받기 위한 양 끝단**을 의미하며, **서버와 클라이언트가 서로 데이터를 주고받을 수 있게 해주는 인터페이스**이다. 소켓을 통해 서로 다른 컴퓨터가 TCP/IP 프로토콜을 사용하여 네트워크를 통해 데이터를 송수신할 수 있다.

### 소켓의 구조와 역할

소켓은 **IP 주소와 포트 번호**를 결합한 형태로, 네트워크 상에서 특정 애플리케이션을 식별하는 데 사용된다.

- **IP 주소**: 네트워크에서 각 컴퓨터를 식별하는 주소이다.
- **포트 번호**: 컴퓨터 내의 특정 애플리케이션을 식별하는 번호로, 네트워크 상의 애플리케이션이 통신할 포트를 지정하여 서로 다른 프로그램을 구분한다.

소켓 통신은 클라이언트-서버 모델을 기반으로 하며, **서버는 소켓을 생성하고 특정 포트에서 클라이언트의 요청을 기다리고, 클라이언트는 서버에 소켓을 통해 연결하여 데이터를 주고받는 방식**으로 이루어진다.

---

### 소켓의 종류

소켓은 사용되는 프로토콜에 따라 크게 **TCP 소켓**과 **UDP 소켓**으로 나뉘어진다.

#### 1. TCP 소켓 (Stream Socket)

TCP 소켓은 **신뢰성 있는 데이터 전송을 보장하는 연결 지향형 소켓**이다. 이 소켓을 사용하면 통신 전에 연결을 설정하고, 데이터를 전송한 후 연결을 해제하는 절차가 이루어진다.

- **특징**: 데이터 전송의 신뢰성 보장, 흐름 제어, 데이터의 순서 보장, 오류 검출 및 재전송 기능이 있다.
- **예시**: 웹 서버에서 HTTP를 통해 데이터를 주고받는 경우 주로 TCP 소켓을 사용한다.

#### 2. UDP 소켓 (Datagram Socket)

UDP 소켓은 **데이터 전송 속도를 우선시하는 비연결형 소켓**이다. 연결을 설정하지 않고 데이터를 바로 전송하며, 수신 여부에 대한 확인 과정이 없다.

- **특징**: 연결 설정 없이 빠른 데이터 전송이 가능하지만, 신뢰성이나 순서 보장이 없다.
- **예시**: 실시간 스트리밍, 온라인 게임, VoIP 애플리케이션 등에서는 속도가 중요한 요소이므로 UDP 소켓을 많이 사용한다.

---

### 소켓 프로그래밍

소켓 프로그래밍은 소켓을 사용하여 **네트워크 애플리케이션을 구현하는 방법**을 의미한다. 서버와 클라이언트 간에 데이터를 주고받기 위해 각각의 프로그램에서 소켓을 생성하고, 다양한 소켓 함수들을 이용하여 데이터 송수신을 구현한다.

#### 1. 소켓 생성

소켓을 생성할 때는 네트워크의 프로토콜과 소켓 유형을 지정해야 한다.

#### 2. 서버 소켓 설정 (TCP 소켓 예시)

TCP 소켓을 이용한 서버 프로그램의 일반적인 흐름은 다음과 같다.

1. **소켓 생성**: 서버에서 사용할 소켓을 생성한다.
2. **바인딩 (Binding)**: 서버의 IP 주소와 포트 번호를 소켓에 할당한다.
3. **리스닝 (Listening)**: 클라이언트의 연결 요청을 기다린다.
4. **연결 수락 (Accepting)**: 클라이언트의 연결 요청을 수락하고 통신을 시작한다.
5. **데이터 송수신**: 클라이언트와 데이터를 주고받는다.
6. **연결 종료**: 통신이 끝나면 소켓을 종료한다.

```java
import java.io.*;
import java.net.*;

public class Server {
    public static void main(String[] args) {
        try {
            // 1. 서버 소켓 생성 (포트 번호 8080)
            ServerSocket serverSocket = new ServerSocket(8080);
            System.out.println("서버가 클라이언트의 연결을 기다리고 있습니다.");

            // 2. 클라이언트 연결 대기 및 수락
            Socket clientSocket = serverSocket.accept();
            System.out.println("클라이언트가 연결되었습니다: " + clientSocket.getInetAddress());

            // 3. 입력 스트림 및 출력 스트림 생성
            BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
            PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true);

            // 4. 클라이언트로부터 데이터 수신
            String receivedData = in.readLine();
            System.out.println("받은 데이터: " + receivedData);

            // 5. 클라이언트로 응답 전송
            out.println("Hello Client!");

            // 6. 소켓 종료
            in.close();
            out.close();
            clientSocket.close();
            serverSocket.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

#### 3. 클라이언트 소켓 설정 (TCP 소켓 예시)

클라이언트는 서버에 소켓을 통해 연결하고 데이터를 전송하거나 응답을 받을 수 있다. 기본적인 흐름은 다음과 같다.

1. **소켓 생성**: 클라이언트에서 사용할 소켓을 생성한다.
2. **연결 요청**: 서버의 IP 주소와 포트 번호로 연결 요청을 보낸다.
3. **데이터 송수신**: 서버와 데이터를 주고받는다.
4. **연결 종료**: 통신이 끝나면 소켓을 종료한다.

```java
import java.io.*;
import java.net.*;

public class Client {
    public static void main(String[] args) {
        try {
            // 1. 서버에 연결 (IP 주소와 포트 번호 사용)
            Socket socket = new Socket("127.0.0.1", 8080);

            // 2. 입력 스트림 및 출력 스트림 생성
            BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            PrintWriter out = new PrintWriter(socket.getOutputStream(), true);

            // 3. 서버로 데이터 전송
            out.println("Hello Server!");

            // 4. 서버로부터 데이터 수신
            String receivedData = in.readLine();
            System.out.println("받은 데이터: " + receivedData);

            // 5. 소켓 종료
            in.close();
            out.close();
            socket.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

---

### 소켓 함수의 주요 종류

1. **socket()**: 새로운 소켓을 생성한다.
2. **bind()**: 소켓에 IP 주소와 포트 번호를 연결하여 서버의 주소를 지정한다.
3. **listen()**: 클라이언트의 연결을 대기하는 상태로 만든다.
4. **accept()**: 클라이언트의 연결을 수락하고, 클라이언트 소켓과 주소를 반환한다.
5. **connect()**: 클라이언트가 서버에 연결 요청을 한다.
6. **send() / recv()**: 데이터를 송수신하는 함수이다.
7. **close()**: 소켓을 종료하고 연결을 닫는다.

---

### 소켓의 장점과 단점

#### 장점

- **표준화된 통신 방식**: TCP/IP 프로토콜을 사용하여 네트워크 표준에 따라 통신을 구현할 수 있다.
- **다양한 사용 가능성**: 웹 서버, 채팅 애플리케이션, 게임 서버 등 다양한 네트워크 애플리케이션에 사용된다.
- **유연성**: TCP와 UDP 소켓을 선택하여 신뢰성, 속도 등의 요구 사항에 따라 유연하게 통신 방식을 구성할 수 있다.

#### 단점

- **복잡성**: 서버-클라이언트 모델에서 네트워크 장애를 포함한 다양한 오류 처리가 필요하다.
- **오버헤드**: TCP 소켓의 경우 신뢰성을 보장하기 위한 추가적인 패킷 교환과 연결 설정이 있어 오버헤드가 발생할 수 있다.
- **보안 문제**: 소켓을 통해 네트워크에 직접적으로 연결되므로 보안 취약점이 발생할 가능성이 있으며, SSL/TLS 같은 보안 프로토콜을 별도로 적용해야 한다.
