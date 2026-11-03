---
title: "MyBatis <choose> 태그 사용법 및 <if> 태그와의 차이"
date: 2024-08-04 02:00:00 +0900
categories: [Backend, MyBatis]
tags: ["choose", "if", "mybatis", "사용법", "차이"]
tistory_url: https://yoon-ssi.tistory.com/8
render_with_liquid: false
---

MyBatis의 `<choose>` 태그는 SQL에서 여러 조건을 처리할 때 쓴다. `<if>` 태그와 비슷해 보이지만 차이가 있으니 상황에 맞게 골라 써보자!!

글 마지막에 `<if>` 태그와의 차이도 정리해 뒀으니 참고하자.

`<choose>` 태그는 Java의 switch와 비슷하게 동작한다. 안에 `<when>` 태그를 하나 이상 넣고, 필요하면 `<otherwise>` 태그를 넣는다.

예제를 보자.

```sql
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

`<when>` 태그에 붙는 test는 `<if>` 태그의 test처럼 조건을 적는 곳이다. 필수니까 빼먹지 말자!

위 예제는 이렇게 동작한다.

1. name이 null이 아니면: `name = #{name}` 조건을 쓴다.
2. name이 null이고 age가 null이 아니면: `age = #{age}` 조건을 쓴다.
3. name과 age가 둘 다 null이면: `1 = 1`(항상 참인 조건)을 쓴다.

여러 조건 중 딱 하나만 골라야 할 때 `<choose>`를 쓰면 좋다.

---

## `<if>`와 `<choose>`의 차이

- 조건 처리 방식
  - `<if>`는 조건을 하나씩 따로 평가해서 여러 조건이 동시에 참일 수 있다.
  - `<choose>`는 switch처럼 여러 조건 중 하나만 고른다.
- 동작
  - `<if>`는 조건이 참일 때마다 그 SQL 조각을 붙인다.
  - `<choose>`는 처음으로 참이 된 조건의 SQL 조각만 붙이고, 전부 거짓이면 `<otherwise>`의 SQL을 붙인다.
- 언제 쓰나
  - `<if>`는 여러 조건을 동시에 걸거나 조건을 전부 만족시키는 SQL을 짤 때 쓴다.
  - `<choose>`는 여러 조건 중 하나만 골라야 할 때 쓴다.
