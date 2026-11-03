---
title: "[MyBatis] <selectKey> 란?"
date: 2024-08-18 07:55:48 +0900
categories: ["MyBatis"]
tags: ["mybatis", "selectkey", "마이바티스", "키-값-가져오기"]
tistory_url: https://yoon-ssi.tistory.com/24
render_with_liquid: false
---

데이터베이스에 자동 생성된 키 값을 가져와 활용해야 하는 경우가 빈번하다.

주로 INSERT 작업에서 생성되는 키 값을 MyBatis의 &lt;selectKey&gt;를 사용하면 간편하게 가져올 수 있다.

---

### &lt;selectKey&gt;의 역할

&lt;selectKey&gt;는 INSERT 문을 실행하기 전에 또는 후에 특정 SQL 쿼리를 실행하여 자동 생성된 값을 조회하는 데 사용된다. 주로 다음과 같은 상황에서 활용된다:

1. **자동 증가 키 가져오기**: 데이터베이스에서 자동으로 증가하는 기본 키를 가져와야 할 때.
2. **시퀀스에서 값 조회하기**: 시퀀스를 사용하여 기본 키를 생성하고, 해당 값을 조회할 때.

---

### 사용 방법

&lt;selectKey&gt;를 사용하려면 다음과 같은 구조를 가진 SQL 매퍼 XML을 작성해야 한다:

1. **&lt;selectKey&gt; 정의**: 자동 생성된 값을 조회할 쿼리를 정의한다.
2. **&lt;insert&gt; 문**: 데이터를 삽입할 때 사용할 INSERT 문을 정의한다.

### 예제

다음 예제에서는 자동 생성된 기본 키를 가져오는 과정을 보여준다.

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

User 클래스의 id 필드에 저장된다.
