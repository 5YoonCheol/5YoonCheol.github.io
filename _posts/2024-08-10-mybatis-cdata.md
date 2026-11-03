---
title: "[MyBatis] CDATA 사용법"
date: 2024-08-10 03:14:18 +0900
categories: [Backend, MyBatis]
tags: ["cdata", "mybatis", "문자열치환"]
tistory_url: https://yoon-ssi.tistory.com/15
render_with_liquid: false
---

### **CDATA는 무엇인가?**

CDATA -&gt; Character Data  
문자열을 의미한다.

---

### **CDATA , 왜 사용하죠?**

쿼리문에서 특수문자, 비교연산자를 사용하는 경우가 있는데 이를 MyBatis에서 사용할 경우

오류가 나는 경우가 많다.

이 때문에 태그 안의 내용을 모두 문자열로 치환시켜 버리는 CDATA를 자주 사용한다.

예시

```sql
<select id="findAllProduct" resultMap="ProductMap">
	SELECT
    		PDCT_NAME
        	,PDCT_PRICE
        	,PDCT_STATUS
    	FROM TB_PRODUCT
    	WHERE PDCT_PRICE > 1000
</select>
```

해당 쿼리에서 비교연산자인 '&gt;' 가 닫힘 태그로 인식되어서 에러가 발생한다.

---

### **CDATA, 어떻게 사용하나요?**

사용 예시를 통해서 알아보자.

1. 비교연산자인 '&gt;'만 CDATA 태그로 감싸서 사용할 수 있다.

```sql
<select id="findAllProduct" resultMap="ProductMap">
	SELECT
    		PDCT_NAME
        	,PDCT_PRICE
        	,PDCT_STATUS
    	FROM TB_PRODUCT
    	WHERE PDCT_PRICE <![CDATA[>]]> 1000
</select>
```

2. 쿼리문 전체를 감싸서 사용할 수 있다.

```sql
<select id="findAllProduct" resultMap="ProductMap">
	<![CDATA[
	SELECT
    		PDCT_NAME
        	,PDCT_PRICE
        	,PDCT_STATUS
    	FROM TB_PRODUCT
    	WHERE PDCT_PRICE > 1000
    ]]>
</select>
```

3. 조건 태그에서 사용할 수 있다.

```sql
<select id="findAllProduct" resultMap="ProductMap">
	SELECT
    		PDCT_NAME
        	,PDCT_PRICE
        	,PDCT_STATUS
    	FROM TB_PRODUCT
    	WHERE 1=1
    	<if test='pdctName != null and pdctName != ""'>
    		<![CDATA[
        		AND PDCT_NAME = #{pdctName}
        	]]>
    	</if>
    	<if test='pdctPrice != 0'>
    		<![CDATA[
        		AND PDCT_PRICE > 1000
        	]]>
    	</if>
</select>
```
