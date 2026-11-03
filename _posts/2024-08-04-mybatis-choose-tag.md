---
title: "MyBatis <choose> 태그 사용법 및 <if> 태그와의 차이"
date: 2024-08-04 15:33:47 +0900
categories: [Backend, MyBatis]
tags: ["choose", "if", "mybatis", "사용법", "차이"]
tistory_url: https://yoon-ssi.tistory.com/8
render_with_liquid: false
---

MyBatis의 &lt;choose&gt; 태그는 SQL문의 여러 조건을 처리하기 위해 사용한다.  
&lt;if&gt; 태그와 비슷하다고 생각할 수 있지만 차이가 있으니 오늘 포스팅을 통해 상황에 맞게 사용해보자!!

포스팅 마지막에는 &lt;if&gt;태그와의 차이점 또한 정리할테니 참고해보자.

**&lt;choose&gt; 태그는 Java의 switch 와 유사하게 동작한다.**  
하나 이상의 &lt;when&gt; 태그와 필요에 따라 &lt;otherwise&gt; 태그를 포함할 수 있다.

예제를 살펴보자

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

**&lt;when&gt; 태그 뒤에 붙는 'test'는 &lt;if&gt;태그의 'test'와 동일하게 조건을 적어주는 부분이다. 필수이니 빼먹지 말자!**

위의 예제에서는 다음과 같은 상황을 처리한다.

1. **name**이 null이 아닌 경우: name = #{name} 조건을 사용한다.
2. **name**이 null이고 **age**가 null이 아닌 경우: age = #{age} 조건을 사용한다.
3. **name**과 **age**가 모두 null인 경우: 1 = 1 (항상 참인 조건)을 사용한다.

**&lt;choose&gt; 태그를 사용하기 좋은 상황?**

- &lt;choose&gt; 태그는 여러 조건 중 한 가지만 선택해야 할 때 유용하다.

---

## **&lt;if&gt;와 &lt;choose&gt; 주요 차이점**

- **조건 처리 방식**:
  - &lt;if&gt;는 각 조건을 개별적으로 평가하여 여러 조건이 동시에 참일 수 있다.
  - &lt;choose&gt;는 switch 문처럼 동작하여 여러 조건 중 하나만 선택한다.
- **기본 동작**:
  - &lt;if&gt;는 특정 조건이 참일 때마다 해당 SQL 조각을 추가합니다.
  - &lt;choose&gt;는 여러 조건 중 첫 번째로 참인 조건의 SQL 조각을 추가하고, 모든 조건이 거짓일 경우 &lt;otherwise&gt; 태그의 SQL을 추가한다.
- **사용 시나리오**:
  - &lt;if&gt;는 여러 조건을 동시에 처리하거나 여러 조건을 모두 만족시키는 SQL을 작성할 때 사용된다.
  - &lt;choose&gt;는 여러 조건 중 하나만 선택해야 하는 경우에 사용된다.
