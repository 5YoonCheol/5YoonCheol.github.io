---
title: "[MySql] DATE_FORMAT 함수"
date: 2024-08-30 12:12:57 +0900
categories: [Database, MySQL]
tags: ["date_format", "mysql", "날짜-포맷"]
tistory_url: https://yoon-ssi.tistory.com/37
render_with_liquid: false
---

오늘 포스팅에서는 쿼리문을 작성할 때 많이 사용하는 함수 DATE_FORMAT에 대해서 알아보려고 한다.

### **DATE_FORMAT 함수란?**

MySQL에서 DATE_FORMAT 함수는 날짜 또는 시간을 지정한 형식으로 변환하는 데 사용된다.

이 함수는 주로 날짜 형식을 사람들에게 읽기 쉽게 변경하거나 특정 형식의 문자열로 변환할 때 사용된다.

---

### **기본 문법**

```sql
DATE_FORMAT(date, format)
```

- **date**: 날짜 또는 시간 값을 나타내는 필드
- **format**: 날짜 또는 시간을 나타내는 문자열 형식. 이 형식은 다양한 서식 지시자들로 구성된다.

---

### **자주 사용되는 서식 지시자들**

- %Y: 4자리 연도 (예: 2024)
- %y: 2자리 연도 (예: 24)
- %m: 2자리 월 (예: 08)
- %c: 1~2자리 월 (예: 8)
- %d: 2자리 일 (예: 09)
- %e: 1~2자리 일 (예: 9)
- %H: 2자리 시간 (24시간 형식) (예: 14)
- %h: 2자리 시간 (12시간 형식) (예: 02)
- %i: 2자리 분 (예: 30)
- %s: 2자리 초 (예: 45)
- %p: AM 또는 PM 표시
- %W: 요일 이름 (예: Sunday)
- %a: 약식 요일 이름 (예: Sun)
- %M: 월 이름 (예: August)
- %b: 약식 월 이름 (예: Aug)

---

### 예제

- 날짜 형식을 YYYY-MM-DD로 변환

```sql
SELECT DATE_FORMAT(NOW(), '%Y-%m-%d') AS formatted_date;

결과: 2024-08-25
```

- 날짜를 DD/MM/YYYY 형식으로 변환

```sql
SELECT DATE_FORMAT(NOW(), '%d/%m/%Y') AS formatted_date;

결과: 25/08/2024
```

- 날짜와 시간을 DD-MM-YYYY HH:MM:SS 형식으로 변환

```sql
SELECT DATE_FORMAT(NOW(), '%d-%m-%Y %H:%i:%s') AS formatted_datetime;

결과: 25-08-2024 14:30:45
```

- 요일 이름과 시간을 포함한 형식으로 변환

```sql
SELECT DATE_FORMAT(NOW(), '%W, %M %e, %Y %h:%i %p') AS formatted_date;

결과: Sunday, August 25, 2024 02:30 PM
```

이와 같이 DATE_FORMAT 함수를 사용하면 날짜와 시간 데이터를 다양한 형식으로 변환할 수 있어, 원하는 형태로 데이터를 출력하거나 저장할 수 있다.
