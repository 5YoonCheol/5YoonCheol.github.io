---
title: "[MyBatis] <selectKey> 란?"
date: 2024-08-18 02:00:00 +0900
categories: [Backend, MyBatis]
tags: ["mybatis", "selectkey", "마이바티스", "키-값-가져오기"]
tistory_url: https://yoon-ssi.tistory.com/24
render_with_liquid: false
---

INSERT하고 나서 DB가 자동으로 만든 키 값을 바로 써야 할 때가 많다. MyBatis에서는 `<selectKey>`를 쓰면 그 값을 쉽게 가져올 수 있다.

---

### `<selectKey>`가 하는 일

INSERT 문 실행 전이나 후에 SQL을 하나 더 돌려서 자동 생성된 값을 조회한다. 주로 이럴 때 쓴다.

1. 자동 증가(auto increment)로 만들어진 기본 키를 가져올 때
2. 시퀀스로 기본 키를 만들고 그 값을 조회할 때

---

### 사용 방법

SQL 매퍼 XML에 두 가지를 적으면 된다.

1. `<selectKey>`: 자동 생성된 값을 조회할 쿼리
2. `<insert>`: 데이터를 넣을 INSERT 문

### 예제

자동 생성된 기본 키를 가져오는 예제다.

```sql
<mapper namespace="com.example.UserMapper">

    <!-- 데이터를 삽입하는 INSERT 문 -->
    <insert id="insertUser" parameterType="com.example.User">
    	<!-- 자동 생성된 키를 가져오는 <selectKey> 정의 -->
    	<selectKey keyProperty="id" resultType="int" order="AFTER">
        	SELECT LAST_INSERT_ID() AS id
    	</selectKey>

        INSERT INTO users (name, email)
        VALUES (#{name}, #{email})
    </insert>

</mapper>
```

```java
package com.example;

@Getter
@Setter
public class User {
    private Integer id;
    private String name;
    private String email;
}
```

INSERT가 끝나면 생성된 키 값이 User 클래스의 id 필드에 들어간다.
