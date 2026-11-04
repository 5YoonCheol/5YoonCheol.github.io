---
title: "[MyBatis] 동적 SQL 정리: if, choose, where, trim, foreach, CDATA"
date: 2024-08-10 02:00:00 +0900
categories: [Backend, MyBatis]
tags: ["mybatis", "동적-sql", "if", "choose", "foreach", "cdata"]
description: MyBatis 매퍼 XML에서 조건에 따라 SQL을 조립하는 동적 SQL 태그를 정리한다. if와 choose의 차이, WHERE 1=1을 없애는 where·trim, 목록 바인딩 foreach, 비교 연산자 오류를 막는 CDATA까지 예제로 본다.
tistory_url: https://yoon-ssi.tistory.com/7
tistory_urls: [https://yoon-ssi.tistory.com/7, https://yoon-ssi.tistory.com/8, https://yoon-ssi.tistory.com/15]
redirect_from:
  - /posts/mybatis-if-tag/
  - /posts/mybatis-choose-tag/
  - /posts/mybatis-cdata/
render_with_liquid: false
---

> 2026년 11월에 `<if>` 태그, `<choose>` 태그, CDATA 사용법 세 글을 하나로 합쳐 다시 썼다. 옛 주소로 들어오면 이 글로 넘어온다.
{: .prompt-info }

검색 화면처럼 입력한 조건만 골라서 `WHERE`에 넣어야 할 때, Java에서 문자열을 이어 붙이면 금방 지저분해진다. MyBatis는 매퍼 XML 안에서 조건에 따라 SQL을 조립하는 태그를 제공한다. 자주 쓰는 순서대로 정리해보자.

### 1. `<if>`: 조건이 참이면 붙인다

```xml
<select id="selectUsers" resultType="User">
    SELECT * FROM users
    WHERE 1=1
    <if test="name != null">
        AND name = #{name}
    </if>
    <if test="age != null">
        AND age = #{age}
    </if>
</select>
```

`test` 속성은 필수고, OGNL 표현식으로 평가된다. `name`만 들어오면 SQL은 `SELECT * FROM users WHERE 1=1 AND name = ?`가 된다. 조건이 여러 개 동시에 참이면 전부 붙는다.

문자열이 비어 있는 경우까지 걸러야 하면 `test="name != null and name != ''"`처럼 쓴다. 작은따옴표 안에 작은따옴표가 필요하면 `test` 전체를 작은따옴표로 감싸고 안에서 큰따옴표를 쓴다. 숫자 0과 빈 문자열이 OGNL에서 같게 비교되는 경우가 있으니 숫자 조건은 `!= null`만 쓰는 게 안전하다.

### 2. `<choose>`: 여러 조건 중 하나만 고른다

Java의 `switch`와 같다. 처음으로 참이 되는 `<when>` 하나만 붙고, 전부 거짓이면 `<otherwise>`가 붙는다.

```xml
<select id="findUserByCondition" resultType="User">
    SELECT * FROM users
    WHERE
    <choose>
        <when test="name != null">
            name = #{name}
        </when>
        <when test="age != null">
            age = #{age}
        </when>
        <otherwise>
            1 = 1
        </otherwise>
    </choose>
</select>
```

`<if>`와의 차이는 이것뿐이다.

- `<if>`는 조건을 하나씩 따로 평가해서 참인 조각을 전부 붙인다. "입력된 조건을 모두 AND로 건다"에 맞는다.
- `<choose>`는 위에서부터 보다가 처음 참인 것 하나만 붙인다. "검색 유형에 따라 조건을 하나만 고른다"에 맞는다.

### 3. `<where>`와 `<trim>`: `WHERE 1=1`을 없앤다

위 예제들의 `WHERE 1=1`은 "첫 조건 앞에 AND가 오면 문법 오류"를 피하려는 꼼수다. `<where>`를 쓰면 MyBatis가 알아서 처리한다. 안에 내용이 있을 때만 `WHERE`를 붙이고, 맨 앞의 `AND`나 `OR`를 지워 준다.

```xml
<select id="selectUsers" resultType="User">
    SELECT * FROM users
    <where>
        <if test="name != null">AND name = #{name}</if>
        <if test="age != null">AND age = #{age}</if>
    </where>
</select>
```

`<set>`은 `UPDATE`용으로 같은 일을 한다. 마지막 쉼표를 지워 준다.

```xml
<update id="updateUser">
    UPDATE users
    <set>
        <if test="name != null">name = #{name},</if>
        <if test="age != null">age = #{age},</if>
    </set>
    WHERE id = #{id}
</update>
```

둘 다 `<trim>`의 특수한 형태다. 앞뒤에 뭘 붙이고 뭘 지울지 직접 정할 수 있어서, 괄호로 묶은 OR 조건처럼 `<where>`가 못 다루는 모양은 `<trim>`으로 만든다.

```xml
<trim prefix="WHERE (" suffix=")" prefixOverrides="AND |OR ">
    <if test="name != null">OR name = #{name}</if>
    <if test="email != null">OR email = #{email}</if>
</trim>
```

### 4. `<foreach>`: 목록을 IN에 넣는다

```xml
<select id="selectByIds" resultType="User">
    SELECT * FROM users
    WHERE id IN
    <foreach collection="ids" item="id" open="(" separator="," close=")">
        #{id}
    </foreach>
</select>
```

`collection`에는 파라미터 이름을 적는다. 매퍼 메서드 파라미터가 하나뿐인 `List`면 `list`, 배열이면 `array`로 받지만, `@Param("ids")`를 붙여 이름을 주는 쪽이 읽기 쉽다. 빈 목록이 들어오면 `IN ()`이 되어 문법 오류가 나니 호출 전에 비었는지 확인하거나 `<if test="ids != null and !ids.isEmpty()">`로 감싼다.

### 5. CDATA: 비교 연산자 때문에 XML이 깨질 때

매퍼는 XML이라 `<`는 태그 시작으로 읽힌다. `WHERE price < 1000`을 그대로 쓰면 파싱 오류가 난다. `>`는 대체로 넘어가지만 `<`, `&`, `<=`는 반드시 처리해야 한다.

```xml
<!-- 연산자만 감싸기 -->
<select id="findCheapProducts" resultMap="ProductMap">
    SELECT product_name, price, status
    FROM product
    WHERE price <![CDATA[<]]> 1000
</select>

<!-- 쿼리 전체 감싸기 -->
<select id="findCheapProducts" resultMap="ProductMap">
    <![CDATA[
    SELECT product_name, price, status
    FROM product
    WHERE price < 1000
    ]]>
</select>
```

전체를 감쌀 때 주의할 점이 있다. CDATA 안은 문자 그대로 들어가므로 그 안에 `<if>` 같은 동적 태그를 넣으면 태그가 아니라 글자로 취급돼 동작하지 않는다. 동적 태그와 같이 쓸 때는 비교 연산자가 있는 조각만 감싼다.

```xml
<if test="maxPrice != null">
    AND price <![CDATA[<=]]> #{maxPrice}
</if>
```

CDATA 대신 XML 엔티티(`&lt;`, `&gt;`, `&amp;`)를 써도 된다. 짧은 조건에는 엔티티가, 긴 쿼리에는 CDATA가 읽기 편하다.

### 6. 정리

| 상황 | 태그 |
|---|---|
| 입력된 조건을 모두 AND로 | `<if>` 여러 개 + `<where>` |
| 조건 중 하나만 골라서 | `<choose>` / `<when>` / `<otherwise>` |
| 첫 AND·마지막 쉼표 처리 | `<where>`, `<set>`, 세밀하게는 `<trim>` |
| 목록을 IN에 | `<foreach>` |
| `<`, `<=`, `&`가 있는 SQL | `<![CDATA[ ]]>` 또는 `&lt;` |

값을 넣을 때는 항상 `#{}`를 쓴다. `${}`는 문자열을 그대로 끼워 넣어서 SQL Injection에 열려 있다. 두 바인딩의 차이와 `${}`가 꼭 필요한 경우는 [MyBatis 바인딩과 selectKey](/posts/mybatis-binding-and-selectkey/) 글에서 정리했다.
