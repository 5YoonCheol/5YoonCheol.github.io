---
title: "[MySql] JOIN이란?"
date: 2024-08-25 05:05:28 +0900
categories: ["MySql"]
tags: ["join", "mysql"]
tistory_url: https://yoon-ssi.tistory.com/32
render_with_liquid: false
---

MySQL의 JOIN은 두 개 이상의 테이블을 서로 연결하여 데이터를 결합할 때 사용한다.

JOIN을 통해 관련 있는 테이블의 데이터를 한 번에 조회할 수 있으며, 이는 데이터베이스 쿼리에서 매우 중요한 기능이다.

---

### JOIN의 종류

MySQL에서 자주 사용되는 JOIN의 종류는 다음과 같다:

1. **INNER JOIN**: 두 테이블에서 일치하는 레코드만 반환한다.
2. **LEFT JOIN (또는 LEFT OUTER JOIN)**: 왼쪽 테이블의 모든 레코드와 오른쪽 테이블에서 일치하는 레코드를 반환한다. 일치하지 않는 경우에는 NULL 값을 반환한다.
3. **RIGHT JOIN (또는 RIGHT OUTER JOIN)**: 오른쪽 테이블의 모든 레코드와 왼쪽 테이블에서 일치하는 레코드를 반환한다. 일치하지 않는 경우에는 NULL 값을 반환한다.
4. **FULL JOIN (또는 FULL OUTER JOIN)**: 두 테이블에서 일치하는 레코드를 모두 반환하며, 일치하지 않는 레코드도 각각 반환한다. MySQL에서는 직접 지원하지 않지만, UNION을 사용하여 구현할 수 있다.  
   (UNION은 사용하지 않는 것을 추천한다.)
5. **CROSS JOIN**: 두 테이블의 모든 가능한 조합을 반환한다. 테이블의 각 행이 다른 테이블의 모든 행과 결합되며, 이는 일종의 카티전 곱(곱집합)을 의미한다.

---

### JOIN 사용 예제

#### INNER JOIN

INNER JOIN은 두 테이블에서 공통된 값을 가지는 행만 반환한다. 예를 들어, employees 테이블과 departments 테이블을 결합하여 각 직원이 속한 부서를 조회할 수 있다.

```sql
SELECT employees.name, departments.department_name
FROM employees
INNER JOIN departments ON employees.department_id = departments.id;
```

이 쿼리는 직원의 이름과 그들이 속한 부서의 이름을 반환한다. employees와 departments 테이블 간에 department_id가 일치하는 행만 선택된다.

---

#### LEFT JOIN

LEFT JOIN은 왼쪽 테이블의 모든 행을 반환하며, 오른쪽 테이블에서 일치하는 행이 없으면 NULL 값을 반환한다. 예를 들어, 모든 직원을 조회하되, 부서에 소속되지 않은 직원도 포함하려면 다음과 같이 작성한다.

```sql
SELECT employees.name, departments.department_name
FROM employees
LEFT JOIN departments ON employees.department_id = departments.id;
```

이 쿼리는 모든 직원을 반환하며, 부서가 없는 직원의 경우 department_name이 NULL로 표시된다.

---

#### RIGHT JOIN

RIGHT JOIN은 오른쪽 테이블의 모든 행을 반환하며, 왼쪽 테이블에서 일치하는 행이 없으면 NULL 값을 반환한다. 예를 들어, 모든 부서를 조회하되, 해당 부서에 직원이 없는 경우도 포함하려면 다음과 같이 작성한다.

```sql
SELECT employees.name, departments.department_name
FROM employees
RIGHT JOIN departments ON employees.department_id = departments.id;
```

이 쿼리는 모든 부서를 반환하며, 직원이 없는 부서의 경우 name이 NULL로 표시된다.

---

#### FULL JOIN

FULL JOIN은 두 테이블의 모든 행을 반환하며, 일치하지 않는 부분은 NULL로 채운다. MySQL에서 직접 사용할 수 없기 때문에 UNION을 사용하여 구현한다.

```sql
SELECT employees.name, departments.department_name
FROM employees
LEFT JOIN departments ON employees.department_id = departments.id
UNION
SELECT employees.name, departments.department_name
FROM employees
RIGHT JOIN departments ON employees.department_id = departments.id;
```

이 쿼리는 LEFT JOIN과 RIGHT JOIN의 결과를 결합하여, 두 테이블에서 모든 레코드를 반환한다.

---

#### CROSS JOIN

CROSS JOIN은 두 테이블의 모든 가능한 행 조합을 반환한다. 예를 들어, 모든 직원과 모든 프로젝트의 조합을 조회하려면 다음과 같이 작성한다.

```sql
SELECT employees.name, projects.project_name
FROM employees
CROSS JOIN projects;
```

이 쿼리는 각 직원과 각 프로젝트의 모든 조합을 반환한다. 이때 결과의 행 수는 employees와 projects의 행 수를 곱한 수와 같다.

---

### JOIN의 중요성

JOIN은 데이터베이스에서 여러 테이블에 분산된 데이터를 결합하여 유용한 정보를 얻는 데 필수적인 기능이다. 이를 통해 데이터를 효율적으로 조회하고, 다양한 조건에 맞는 데이터를 결합하여 복잡한 질의를 수행할 수 있다.

이처럼 MySQL의 JOIN은 데이터베이스 관리에서 매우 중요한 도구로, 데이터를 연결하고 결합하여 풍부한 정보를 제공하는 데 필수적이다.
