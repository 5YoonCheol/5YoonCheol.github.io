---
title: "[MySql] DATE_FORMAT 함수"
date: 2024-08-30 02:00:00 +0900
categories: [Database, MySQL]
tags: ["date_format", "mysql", "날짜-포맷"]
tistory_url: https://yoon-ssi.tistory.com/37
render_with_liquid: false
---

쿼리를 짜다 보면 날짜를 원하는 모양으로 바꿔야 할 때가 자주 있다. 그때 쓰는 함수가 DATE_FORMAT이다.

### DATE_FORMAT 함수란?

날짜나 시간을 지정한 형식의 문자열로 바꿔주는 MySQL 함수다. 날짜를 사람이 보기 편한 모양으로 바꾸거나, 특정 형식의 문자열이 필요할 때 쓴다.

---

### 기본 문법

```sql
DATE_FORMAT(date, format)
```

- date: 날짜나 시간 값이 들어 있는 필드
- format: 출력할 형식. 아래 서식 지시자들을 조합해서 만든다.

---

### 자주 쓰는 서식 지시자

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

YYYY-MM-DD 형식으로 바꾸기

```sql
SELECT DATE_FORMAT(NOW(), '%Y-%m-%d') AS formatted_date;

결과: 2024-08-25
```

DD/MM/YYYY 형식으로 바꾸기

```sql
SELECT DATE_FORMAT(NOW(), '%d/%m/%Y') AS formatted_date;

결과: 25/08/2024
```

DD-MM-YYYY HH:MM:SS 형식으로 바꾸기

```sql
SELECT DATE_FORMAT(NOW(), '%d-%m-%Y %H:%i:%s') AS formatted_datetime;

결과: 25-08-2024 14:30:45
```

요일 이름과 시간까지 넣어서 바꾸기

```sql
SELECT DATE_FORMAT(NOW(), '%W, %M %e, %Y %h:%i %p') AS formatted_date;

결과: Sunday, August 25, 2024 02:30 PM
```

서식 지시자만 조합하면 날짜를 거의 어떤 모양으로든 뽑을 수 있다.
