---
title: "[MyBatis] 바인딩 ${}, #{}"
date: 2024-09-01 10:10:39 +0900
categories: [Backend, MyBatis]
tags: ["mybatis", "바인딩"]
tistory_url: https://yoon-ssi.tistory.com/39
render_with_liquid: false
---

MyBatis에서 SQL에 값을 넣을 때는 #{}와 ${}를 쓴다.

생긴 건 비슷한데 동작 방식이 다르고, 특히 보안 면에서 차이가 크다.

---

### 1. #{}

#{}는 PreparedStatement의 바인딩 파라미터로 처리된다. MyBatis는 #{} 자리를 ?로 바꿔서 SQL을 미리 컴파일해 두고, 실행할 때 값을 안전하게 바인딩한다.

입력값이 SQL 문법으로 해석되지 않고 값으로만 들어가기 때문에 SQL 인젝션에 안전하다.

```sql
<select id="getUser" parameterType="int" resultType="User">
  SELECT * FROM users WHERE id = #{id}
</select>
```

위 SQL에서 #{id}는 컴파일 시점에 ?로 바뀌고, 실행 시점에 id 값이 그 자리에 바인딩된다.

### 2. ${}

${}는 그냥 문자열 치환이다. MyBatis가 ${} 자리에 파라미터 값을 그대로 끼워 넣는다. SQL이 컴파일되기 전에 들어가기 때문에, 넣은 값이 SQL 문의 일부가 돼 버린다.

그래서 SQL 인젝션에 취약하다. 사용자가 입력한 값이 그대로 SQL에 들어가니 악의적인 SQL이 섞여 들어올 수 있다. 쓸 때 조심해야 한다!

```sql
<select id="getUser" parameterType="string" resultType="User">
  SELECT * FROM users WHERE name = '${name}'
</select>
```

위 SQL에서 ${name}은 입력값으로 그대로 바뀐다.

예를 들어 사용자가 John을 입력하면 SQL은 SELECT * FROM users WHERE name = 'John'이 된다.

---

### 차이점 요약

- #{}: 값을 ?로 치환한 뒤 바인딩한다. SQL 인젝션에 안전하다.
- ${}: 값을 SQL에 그대로 끼워 넣는다. SQL 인젝션에 취약하니 조심해서 써야 한다.

---

### 예제로 다시 보기

users 테이블이 이렇게 있다고 해보자.

```sql
CREATE TABLE users (
  id INT PRIMARY KEY,
  name VARCHAR(100),
  age INT
);
```

#{}를 쓰면 입력받은 id 값을 안전하게 바인딩해서 조회한다.

```sql
<select id="getUserById" parameterType="int" resultType="User">
  SELECT * FROM users WHERE id = #{id}
</select>
```

${}를 쓰면 입력받은 name 값이 그대로 SQL에 들어간다. SQL 인젝션에 취약하니 입력값을 철저하게 검증해야 한다.

```sql
<select id="getUserByName" parameterType="string" resultType="User">
  SELECT * FROM users WHERE name = '${name}'
</select>
```

---

### 결론은

SQL 인젝션을 막으려면 웬만하면 #{}를 쓰고, ${}는 꼭 필요할 때만 쓰자!!

특히 SQL을 동적으로 조립해야 할 때는 사용자 입력이 SQL에 바로 들어가지 않도록 쿼리 구성 로직을 잘 짜야 한다.
