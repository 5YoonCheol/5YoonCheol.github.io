---
title: "MyBatis <if> 태그 사용법"
date: 2024-08-03 02:00:00 +0900
categories: [Backend, MyBatis]
tags: ["if", "mybatis", "sql", "조건"]
tistory_url: https://yoon-ssi.tistory.com/7
render_with_liquid: false
---

MyBatis의 'if' 태그는 동적 SQL을 보다 간편하게 생성할 수 있도록 도와준다.   
그리 어렵지 않으니 바로 예제를 통해 알아보자!

**주의해야 할 점은 'if' 뒤에 붙는 test는 조건을 의미하고 필수로 적어주어야 한다!!**

```sql
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

위의 예제에서 'name' , 'age' 파라미터가 null이 아닌 경우에   
&lt;if&gt; 태그 안의 SQL이 포함된다.   

name = "홍길동" 이고 age = null 이라면  
예제의 SQL 문은 최종적으로

```sql
<select id="selectUsers" resultType="User">
    SELECT * FROM users
    WHERE 1=1
    AND name = "홍길동"
</select>
```

이러한 형태가 된다.
