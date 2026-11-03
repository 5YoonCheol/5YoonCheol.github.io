---
title: "SQL Injection 이란?"
date: 2024-10-01 08:08:03 +0900
categories: [Security, Web]
tags: ["sql-injection", "sql-인젝션"]
tistory_url: https://yoon-ssi.tistory.com/70
render_with_liquid: false
---

SQL Injection(인젝션)은 공격자가 SQL 쿼리를 조작해서 데이터베이스에 몰래 접근하거나 데이터를 건드리는 공격이다.

보통 사용자가 입력한 값을 제대로 검증하지 않고 SQL 쿼리에 그대로 붙일 때 생긴다. 그러면 공격자가 원래 쿼리 말고 다른 명령까지 끼워 넣어 실행할 수 있게 된다.

---

### 어떻게 공격하나

핵심은 웹 애플리케이션이 사용자 입력을 안전하게 처리하지 않는다는 점이다.

로그인 페이지에서 아이디와 비밀번호를 확인하는 쿼리가 있다고 해보자.

```sql
SELECT * FROM users WHERE username = 'user' AND password = 'pass';
```

'user'라는 사용자와 'pass'라는 비밀번호가 맞는지 확인하는 쿼리다.

그런데 사용자가 이렇게 입력하면 어떻게 될까.

- username: `' OR 1=1 --`
- password: 무시됨

이 값을 쿼리에 그대로 넣으면 다음 쿼리가 만들어진다.

```sql
SELECT * FROM users WHERE username = '' OR 1=1 -- ' AND password = '무시됨';
```

`OR 1=1` 때문에 조건이 항상 참이 되고, 비밀번호 확인 없이 전체 사용자 목록이 반환된다. `--`는 SQL에서 주석이라 그 뒤는 전부 무시된다.

결국 비밀번호 없이 로그인하거나 데이터베이스에 접근할 수 있게 된다.

---

### 공격 유형

1. In-band SQL Injection (동일 채널 SQL 인젝션)
   - 가장 흔한 형태다. 공격자가 데이터를 직접 빼내거나 수정할 수 있다. 쿼리 결과를 웹 페이지에서 바로 볼 수 있는 경우가 여기에 해당한다.
2. Blind SQL Injection (블라인드 SQL 인젝션)
   - 응답으로 데이터를 직접 받을 수는 없지만, 조건문으로 데이터베이스 상태를 떠보는 방식이다. 참/거짓에 따라 응답이 달라지도록 쿼리를 짜서 원하는 정보를 추론한다.
3. Out-of-band SQL Injection (채널 분리 SQL 인젝션)
   - 웹 응답이 아니라 이메일이나 외부 서버로의 요청 같은 다른 경로로 결과를 받아내는 방식이다. 대상 네트워크 설정에 따라 쓰인다.

---

### 막는 방법

한 가지만으로는 부족하고 여러 방법을 같이 써야 한다.

1. Prepared Statements
   - 사용자 입력을 쿼리 문자열에 직접 붙이지 않고, 쿼리를 미리 만들어 둔 뒤 값만 변수로 넘긴다. PHP나 Java에서 Prepared Statement를 쓰면 쿼리와 데이터가 분리돼서 인젝션을 막을 수 있다.
2. ORM(Object-Relational Mapping)
   - ORM이 쿼리를 안전하게 만들어주니 SQL을 직접 쓸 일이 줄고, 그만큼 인젝션 위험도 줄어든다. Django ORM이나 Hibernate 같은 도구가 있다.
3. 입력값 검증
   - 사용자 입력은 반드시 거르거나 검증한다. 이메일이나 숫자 같은 값은 정규식으로 형식을 확인할 수 있다.
4. 최소 권한 원칙
   - DB 계정 권한을 필요한 만큼만 준다. 공격을 당하더라도 데이터베이스 전체가 망가지지 않게 하기 위해서다.
5. WAF(Web Application Firewall)
   - WAF로 SQL Injection 패턴을 실시간으로 잡아서 차단할 수 있다.
