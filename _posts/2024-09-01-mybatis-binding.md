---
title: "[MyBatis] 바인딩 ${}, #{}"
date: 2024-09-01 10:10:39 +0900
categories: [Backend, MyBatis]
tags: ["mybatis", "바인딩"]
tistory_url: https://yoon-ssi.tistory.com/39
render_with_liquid: false
---

MyBatis에서는 SQL 쿼리에 동적으로 값을 바인딩할 때 #{}와 ${}를 사용한다.

이 둘은 매우 비슷해 보이지만, 동작 방식과 보안 측면에서 중요한 차이가 있다.

---

### 1. #{}

- **설명**: #{}는 **PreparedStatement**의 **바인딩 파라미터**로 사용된다. MyBatis가 #{}를 만나면 해당 위치에 값이 삽입될 때 SQL 문을 미리 컴파일하고, 값이 바인딩될 때 이를 안전하게 처리한다.
- **보안**: SQL 인젝션 공격으로부터 안전하다. 사용자가 입력한 값이 SQL 문 내에서 적절히 이스케이프 처리되어 삽입되기 때문에, 악의적인 SQL 코드가 실행될 위험이 없다.
- **사용 예제**

```sql
<select id="getUser" parameterType="int" resultType="User">
  SELECT * FROM users WHERE id = #{id}
</select>
```

**동작 원리**: 위의 SQL에서 #{id}는 컴파일 시점에 ?로 대체되고, 실행 시점에 id 값이 ?에 바인딩된다.

### 2. ${}

- **설명**: ${}는 단순한 **문자열 치환**을 수행한다. MyBatis가 ${}를 만나면, 해당 위치에 파라미터 값을 그대로 삽입한다.   
  이 값은 SQL 문이 컴파일되기 전에 직접 삽입되므로, 문자열로 인식되어 그대로 SQL 문에 포함된다.
- **보안**: SQL 인젝션에 취약하다. 사용자가 입력한 값이 그대로 SQL 문에 삽입되기 때문에, 악의적인 SQL 코드가 포함될 수 있다. 사용할 때 주의가 필요하다!
- **사용 예제**

```sql
<select id="getUser" parameterType="string" resultType="User">
  SELECT * FROM users WHERE name = '${name}'
</select>
```

**동작 원리**: 위의 SQL에서 ${name}은 사용자의 입력 값으로 대체되어 SQL 문에 그대로 삽입된다.

예를 들어, 사용자가 John을 입력하면 SQL 문은 SELECT * FROM users WHERE name = 'John'으로 변경됩니다.

---

### 차이점 요약

- **#{}**: 파라미터 바인딩을 통해 안전하게 값을 SQL 문에 추가한다.   
  SQL 인젝션에 안전하며, 값은 ?로 치환된 후 바인딩된다.
- **${}**: 값을 그대로 SQL 문에 삽입한다. SQL 인젝션에 취약하며, 사용에 주의가 필요다.

---

### 사용 예제

**테이블 구조**: 예를 들어, 'users'라는 테이블이 있다고 가정해보자.

```sql
CREATE TABLE users (
  id INT PRIMARY KEY,
  name VARCHAR(100),
  age INT
);
```

**#{} 사용 예제**

```sql
<select id="getUserById" parameterType="int" resultType="User">
  SELECT * FROM users WHERE id = #{id}
</select>
```

**설명**: 사용자가 입력한 id 값을 안전하게 바인딩하여 SELECT 쿼리를 실행한다.

**${} 사용 예제**

```sql
<select id="getUserByName" parameterType="string" resultType="User">
  SELECT * FROM users WHERE name = '${name}'
</select>
```

**설명**: 사용자가 입력한 name 값을 그대로 SQL 쿼리에 삽입한다. 이 방법은 SQL 인젝션에 취약하므로, 사용자 입력에 대한 철저한 검증이 필요하다.

---

### 보안상의 권장 사항

일반적으로 SQL 인젝션을 방지하기 위해, 가능한 한 **#{}** 를 사용하고 **${}** 는 꼭 필요할 때만 사용하자!!

특히 동적으로 SQL 문을 구성해야 할 때는 사용자가 입력한 값이 SQL 문에 직접 삽입되는 것을 피하기 위해, 쿼리를 구성하는 논리를 잘 설계해야 한다.

MyBatis의 **#{}** 와 **${}** 의 올바른 사용법을 이해하고 적용해야만 애플리케이션의 보안과 안정성을 유지할 수 있다.
