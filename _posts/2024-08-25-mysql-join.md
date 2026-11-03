---
title: "[MySql] JOIN이란?"
date: 2024-08-25 05:05:28 +0900
categories: [Database, MySQL]
tags: ["join", "mysql"]
tistory_url: https://yoon-ssi.tistory.com/32
render_with_liquid: false
---

MySQL의 JOIN은 두 개 이상의 테이블을 연결해서 데이터를 합칠 때 쓴다. 관련 있는 테이블의 데이터를 한 번에 조회할 수 있어서 쿼리를 짤 때 거의 빠지지 않는다.

---

### JOIN의 종류

자주 쓰는 JOIN은 이렇다.

1. INNER JOIN: 두 테이블에서 일치하는 레코드만 반환한다.
2. LEFT JOIN (LEFT OUTER JOIN): 왼쪽 테이블의 모든 레코드와, 오른쪽 테이블에서 일치하는 레코드를 반환한다. 일치하는 게 없으면 NULL이 들어간다.
3. RIGHT JOIN (RIGHT OUTER JOIN): 오른쪽 테이블의 모든 레코드와, 왼쪽 테이블에서 일치하는 레코드를 반환한다. 일치하는 게 없으면 NULL이 들어간다.
4. FULL JOIN (FULL OUTER JOIN): 양쪽 테이블의 레코드를 일치 여부와 상관없이 전부 반환한다. MySQL은 직접 지원하지 않아서 UNION으로 구현한다. (UNION은 웬만하면 안 쓰는 걸 추천한다.)
5. CROSS JOIN: 두 테이블의 가능한 모든 조합을 반환한다. 한 테이블의 각 행이 다른 테이블의 모든 행과 붙는다. 카티전 곱(곱집합)이다.

---

### JOIN 사용 예제

#### INNER JOIN

두 테이블에 공통된 값이 있는 행만 가져온다. employees와 departments를 붙여서 직원별 부서를 조회해보자.

```sql
SELECT employees.name, departments.department_name
FROM employees
INNER JOIN departments ON employees.department_id = departments.id;
```

직원 이름과 소속 부서 이름이 나온다. department_id가 양쪽에서 일치하는 행만 선택된다.

---

#### LEFT JOIN

왼쪽 테이블은 전부 가져오고, 오른쪽에 짝이 없으면 NULL로 채운다. 부서가 없는 직원까지 포함해서 모든 직원을 조회하려면 이렇게 쓴다.

```sql
SELECT employees.name, departments.department_name
FROM employees
LEFT JOIN departments ON employees.department_id = departments.id;
```

모든 직원이 나오고, 부서가 없는 직원은 department_name이 NULL이다.

---

#### RIGHT JOIN

반대로 오른쪽 테이블은 전부 가져오고, 왼쪽에 짝이 없으면 NULL로 채운다. 직원이 없는 부서까지 포함해서 모든 부서를 조회하려면 이렇게 쓴다.

```sql
SELECT employees.name, departments.department_name
FROM employees
RIGHT JOIN departments ON employees.department_id = departments.id;
```

모든 부서가 나오고, 직원이 없는 부서는 name이 NULL이다.

---

#### FULL JOIN

양쪽 테이블의 모든 행을 가져오고, 짝이 없는 쪽은 NULL로 채운다. MySQL에서는 바로 쓸 수 없어서 UNION으로 만든다.

```sql
SELECT employees.name, departments.department_name
FROM employees
LEFT JOIN departments ON employees.department_id = departments.id
UNION
SELECT employees.name, departments.department_name
FROM employees
RIGHT JOIN departments ON employees.department_id = departments.id;
```

LEFT JOIN과 RIGHT JOIN 결과를 합쳐서 양쪽 레코드를 모두 가져온다.

---

#### CROSS JOIN

가능한 모든 행 조합을 가져온다. 모든 직원과 모든 프로젝트의 조합을 보려면 이렇게 쓴다.

```sql
SELECT employees.name, projects.project_name
FROM employees
CROSS JOIN projects;
```

결과 행 수는 employees 행 수와 projects 행 수를 곱한 값이 된다.

---

여러 테이블에 흩어진 데이터를 엮어서 원하는 정보를 뽑으려면 JOIN을 쓸 수밖에 없다. 종류별로 어떤 행이 남는지만 확실히 알아두면 대부분의 조회는 해결된다.
