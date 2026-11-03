---
title: "[네트워크] Socket(소켓)"
date: 2024-10-31 02:00:00 +0900
categories: [CS, Network]
tags: ["socket", "소켓"]
tistory_url: https://yoon-ssi.tistory.com/100
render_with_liquid: false
---

소켓은 네트워크에서 데이터를 주고받는 양쪽 끝을 말한다. 서버와 클라이언트가 서로 데이터를 주고받을 수 있게 해주는 창구라고 보면 된다. 서로 다른 컴퓨터가 소켓을 통해 TCP/IP로 데이터를 주고받는다.

### 소켓의 구조와 역할

소켓은 **IP 주소와 포트 번호**를 묶은 형태로, 네트워크에서 특정 애플리케이션을 찾아가는 데 쓰인다.

- IP 주소: 네트워크에서 컴퓨터 한 대를 가리키는 주소
- 포트 번호: 그 컴퓨터 안에서 어떤 프로그램인지 구분하는 번호

소켓 통신은 클라이언트-서버 모델로 돌아간다. 서버는 소켓을 만들고 특정 포트에서 요청을 기다리고, 클라이언트는 그 서버에 소켓으로 연결해서 데이터를 주고받는다.

---

### 소켓의 종류

어떤 프로토콜을 쓰느냐에 따라 크게 TCP 소켓과 UDP 소켓으로 나뉜다.

#### 1. TCP 소켓 (Stream Socket)

연결을 맺고 통신하는 소켓이다. 통신 전에 연결을 설정하고, 데이터를 보낸 다음 연결을 끊는 순서로 진행된다.

데이터가 빠짐없이 순서대로 도착하는 걸 보장하고, 흐름 제어와 오류 검출, 재전송까지 해준다. 웹 서버가 HTTP로 데이터를 주고받을 때 주로 이 TCP 소켓을 쓴다.

#### 2. UDP 소켓 (Datagram Socket)

연결 없이 바로 데이터를 던지는 소켓이다. 받았는지 확인하는 과정도 없다.

그만큼 빠르지만 데이터가 제대로, 순서대로 도착한다는 보장은 없다. 실시간 스트리밍, 온라인 게임, VoIP처럼 속도가 더 중요한 곳에서 많이 쓴다.

---

### 소켓 프로그래밍

소켓 프로그래밍은 소켓으로 네트워크 애플리케이션을 만드는 걸 말한다. 서버와 클라이언트 프로그램이 각자 소켓을 만들고, 소켓 함수들로 데이터를 주고받게 구현한다.

#### 1. 소켓 생성

소켓을 만들 때는 어떤 프로토콜과 소켓 유형을 쓸지 정해줘야 한다.

#### 2. 서버 소켓 설정 (TCP 소켓 예시)

TCP 서버 프로그램은 보통 이런 흐름으로 동작한다.

1. 소켓 생성: 서버에서 쓸 소켓을 만든다.
2. 바인딩 (Binding): 서버의 IP 주소와 포트 번호를 소켓에 붙인다.
3. 리스닝 (Listening): 클라이언트의 연결 요청을 기다린다.
4. 연결 수락 (Accepting): 요청이 오면 받아들이고 통신을 시작한다.
5. 데이터 송수신: 클라이언트와 데이터를 주고받는다.
6. 연결 종료: 다 끝나면 소켓을 닫는다.

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

클라이언트는 서버에 소켓으로 연결해서 데이터를 보내고 응답을 받는다. 흐름은 서버보다 단순하다.

1. 소켓 생성: 클라이언트에서 쓸 소켓을 만든다.
2. 연결 요청: 서버의 IP 주소와 포트 번호로 연결을 요청한다.
3. 데이터 송수신: 서버와 데이터를 주고받는다.
4. 연결 종료: 다 끝나면 소켓을 닫는다.

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

### 자주 쓰는 소켓 함수

- `socket()`: 새 소켓을 만든다.
- `bind()`: 소켓에 IP 주소와 포트 번호를 붙여서 서버 주소를 정한다.
- `listen()`: 클라이언트 연결을 기다리는 상태로 만든다.
- `accept()`: 클라이언트 연결을 받아들이고, 클라이언트 소켓과 주소를 돌려준다.
- `connect()`: 클라이언트가 서버에 연결을 요청한다.
- `send()` / `recv()`: 데이터를 보내고 받는다.
- `close()`: 소켓을 닫고 연결을 끊는다.

---

### 장점과 단점

좋은 점은 TCP/IP라는 표준 위에서 통신을 구현할 수 있다는 것이다. 웹 서버, 채팅, 게임 서버 등 쓰이는 곳도 많고, 신뢰성이 중요하면 TCP, 속도가 중요하면 UDP를 고르는 식으로 상황에 맞출 수 있다.

대신 신경 쓸 것도 있다.

- 네트워크 장애까지 포함해서 처리해야 할 예외 상황이 많아 코드가 복잡해지기 쉽다.
- TCP는 신뢰성을 위해 연결 설정과 추가 패킷 교환을 하기 때문에 그만큼 오버헤드가 생긴다.
- 네트워크에 직접 연결되는 만큼 보안 취약점이 생길 수 있어서, SSL/TLS 같은 보안 프로토콜을 따로 적용해야 한다.
