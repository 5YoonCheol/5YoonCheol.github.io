---
title: "[MyBatis] 바인딩 #{}와 ${}의 차이, 그리고 selectKey로 생성 키 받기"
date: 2024-09-01 02:00:00 +0900
categories: [Backend, MyBatis]
tags: ["mybatis", "바인딩", "selectkey", "sql-injection", "usegeneratedkeys"]
description: MyBatis의 #{}는 PreparedStatement 바인딩, ${}는 문자열 치환이다. 둘의 차이와 ${}가 필요한 경우를 안전하게 쓰는 법, INSERT 뒤 자동 생성 키를 useGeneratedKeys와 selectKey로 받는 방법을 정리한다.
tistory_url: https://yoon-ssi.tistory.com/39
tistory_urls: [https://yoon-ssi.tistory.com/24, https://yoon-ssi.tistory.com/39]
redirect_from:
  - /posts/mybatis-binding/
  - /posts/mybatis-selectkey/
render_with_liquid: false
---

> 2026년 11월에 "바인딩 ${}, #{}"와 "selectKey란?" 두 글을 하나로 합쳐 다시 썼다. 옛 주소로 들어오면 이 글로 넘어온다.
{: .prompt-info }

MyBatis에서 SQL에 값을 넣는 방법은 `#{}`와 `${}` 두 가지다. 생긴 건 비슷한데 동작이 완전히 다르고, 그 차이가 그대로 보안 차이가 된다. 그리고 `INSERT` 뒤에 DB가 만든 키를 받아 오는 방법도 같이 정리한다. 둘 다 매퍼 XML을 쓰면 반드시 마주치는 내용이다.

### 1. `#{}`: PreparedStatement 바인딩

MyBatis는 `#{}` 자리를 `?`로 바꿔 SQL을 먼저 준비하고, 실행할 때 값을 파라미터로 바인딩한다.

```xml
<select id="getUser" resultType="User">
  SELECT * FROM users WHERE id = #{id}
</select>
```

실제로 DB에 가는 SQL은 `SELECT * FROM users WHERE id = ?`이고, 값은 따로 전달된다. 입력값이 SQL 문법으로 해석될 여지가 없어서 SQL Injection에 안전하다. 문자열이면 따옴표도 드라이버가 알아서 처리하니 `'#{name}'`처럼 따옴표를 직접 쓰지 않는다.

### 2. `${}`: 문자열 치환

`${}`는 값을 SQL 문자열에 그대로 끼워 넣는다. SQL이 준비되기 전에 들어가므로 값이 SQL의 일부가 된다.

```xml
<select id="getUserByName" resultType="User">
  SELECT * FROM users WHERE name = '${name}'
</select>
```

`name`에 `John`이 들어오면 `WHERE name = 'John'`이 되지만, `' OR '1'='1`이 들어오면 `WHERE name = '' OR '1'='1'`이 되어 모든 행이 나온다. 이게 SQL Injection이고, `${}`에 사용자 입력을 넣는 순간 열린다. SQL Injection 자체는 [SQL Injection 이란?](/posts/sql-injection/) 글에서 더 다뤘다.

### 3. 그래도 `${}`가 필요한 곳

`?`로 바인딩할 수 없는 자리가 있다. 테이블 이름, 컬럼 이름, `ORDER BY` 기준, `ASC/DESC`다. 이런 자리는 `${}`밖에 못 쓰는데, 그때는 값을 사용자 입력에서 바로 받지 말고 허용 목록으로 걸러서 넣는다.

```java
// 서비스 코드: 허용된 컬럼만 통과시킨다
private static final Set<String> SORTABLE = Set.of("created_at", "name", "price");

public List<User> list(String sortBy, boolean desc) {
    if (!SORTABLE.contains(sortBy)) {
        throw new IllegalArgumentException("정렬 불가 컬럼: " + sortBy);
    }
    return userMapper.list(sortBy, desc ? "DESC" : "ASC");
}
```

```xml
<select id="list" resultType="User">
  SELECT * FROM users ORDER BY ${sortBy} ${direction}
</select>
```

`LIKE` 검색은 `${}`가 필요 없다. `CONCAT('%', #{keyword}, '%')`로 쓰면 바인딩 그대로 된다.

### 4. 차이 정리

| | `#{}` | `${}` |
|---|---|---|
| 처리 방식 | `?`로 바꾼 뒤 바인딩 | 문자열 그대로 치환 |
| SQL Injection | 안전 | 취약 |
| 따옴표 | 자동 처리 | 직접 써야 함 |
| 쓸 수 있는 자리 | 값 | 값, 테이블·컬럼 이름, ORDER BY |
| 원칙 | 기본값 | 식별자에만, 허용 목록으로 검증 후 |

### 5. INSERT 뒤 생성된 키 받기

`AUTO_INCREMENT` 기본 키를 `INSERT` 직후에 써야 할 때가 많다. 주문을 넣고 바로 주문 상세를 넣는 경우가 대표적이다. 방법은 두 가지다.

**useGeneratedKeys (MySQL, PostgreSQL 등 JDBC `getGeneratedKeys` 지원 DB)**

```xml
<insert id="insertUser" useGeneratedKeys="true" keyProperty="id">
    INSERT INTO users (name, email) VALUES (#{name}, #{email})
</insert>
```

`INSERT`가 끝나면 생성된 키가 파라미터 객체의 `id` 필드에 들어간다. 쿼리를 하나 더 날리지 않으니 이쪽이 먼저다.

**selectKey (시퀀스를 쓰는 Oracle이나 키를 따로 조회해야 할 때)**

```xml
<insert id="insertUser">
    <selectKey keyProperty="id" resultType="long" order="AFTER">
        SELECT LAST_INSERT_ID()
    </selectKey>
    INSERT INTO users (name, email) VALUES (#{name}, #{email})
</insert>
```

`order="AFTER"`는 `INSERT` 뒤에 실행해 결과를 `id`에 넣고, `order="BEFORE"`는 먼저 실행해 그 값을 `INSERT`에 쓴다. Oracle 시퀀스가 후자다.

```xml
<insert id="insertUser">
    <selectKey keyProperty="id" resultType="long" order="BEFORE">
        SELECT users_seq.NEXTVAL FROM dual
    </selectKey>
    INSERT INTO users (id, name, email) VALUES (#{id}, #{name}, #{email})
</insert>
```

두 방법 모두 매퍼 메서드의 반환값은 영향받은 행 수이고, 키는 넘긴 객체에 채워진다.

```java
User user = new User("홍길동", "hong@example.com");
userMapper.insertUser(user);
Long newId = user.getId();   // 여기서 생성된 키를 쓴다
```

`LAST_INSERT_ID()`는 커넥션 단위로 값을 기억하므로 같은 트랜잭션(같은 커넥션) 안에서만 믿을 수 있다. 커넥션 풀 환경에서 `INSERT`와 `selectKey`가 다른 커넥션으로 나가면 엉뚱한 값이 오는데, MyBatis는 한 statement 안에서 같은 커넥션을 쓰니 위 형태라면 문제없다.

### 6. 정리

- 값은 항상 `#{}`. `${}`는 식별자에만, 그것도 허용 목록으로 거른 뒤에.
- 생성 키는 `useGeneratedKeys`가 기본, 시퀀스나 특수한 경우에만 `<selectKey>`.
- 동적으로 조건을 조립하는 `<if>`, `<choose>`, `<foreach>`는 [MyBatis 동적 SQL 정리](/posts/mybatis-dynamic-sql/) 글에 정리했다.
