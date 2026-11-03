---
title: "[JavaScript] undefined와 null의 차이"
date: 2024-09-22 02:02:06 +0900
categories: [Frontend, JavaScript]
tags: ["null", "undefined", "차이"]
tistory_url: https://yoon-ssi.tistory.com/61
render_with_liquid: false
---

JavaScript를 쓰다 보면 undefined와 null을 계속 만나게 된다. 둘 다 "값이 없다"는 뜻이지만 의미와 쓰임새가 조금 다르다. 오늘은 그 차이를 알아보자.

---

### undefined

변수를 선언만 하고 값을 넣지 않은 상태다. JavaScript에서 변수를 선언하고 아무 값도 할당하지 않으면 기본으로 undefined가 들어간다.

개발자가 넣는 게 아니라 자바스크립트 엔진이 자동으로 넣는 값이다. 그래서 일부러 쓰기보다는 "아직 값이 설정되지 않았다"는 상태를 나타낼 때 자연스럽게 생기는 경우가 많다.

```javascript
let x;
console.log(x);  // 출력: undefined (값이 할당되지 않음)
```

### null

일부러 "값이 없다"고 표시할 때 쓴다. 개발자가 "여기엔 아무 값도 없다"는 걸 직접 할당하는 거다.

```javascript
let y = null;
console.log(y);  // 출력: null (값이 없음을 명시적으로 설정)
```

---

### 차이 정리

| 구분 | undefined | null |
| --- | --- | --- |
| 타입 | undefined (원시 타입) | object (타입은 객체이지만 비어 있음) |
| 할당 여부 | 값이 할당되지 않은 변수에 자동 할당 | 프로그래머가 의도적으로 할당 |
| 용도 | 변수나 함수의 초기 상태를 나타냄 | 값이 없음을 명시적으로 표현 |
| 의도 | 주로 시스템에 의해 결정됨 | 개발자가 명시적으로 설정 |

### 타입 비교

값이 없다는 점은 같지만 타입이 다르다. 그래서 동등 연산자(`==`)로 비교하면 같다고 나오지만, 일치 연산자(`===`)로 비교하면 다르다고 나온다.

```javascript
console.log(undefined == null);  // 출력: true (동등)
console.log(undefined === null); // 출력: false (타입까지 비교, 일치하지 않음)
```

### 언제 보게 되나

undefined는 변수를 선언만 하고 값을 안 넣었을 때 나온다. 함수가 아무것도 return하지 않아도 undefined가 반환된다.

```javascript
function test() {}
console.log(test());  // 출력: undefined (return 값이 없으므로)
```

null은 개발자가 변수가 비어 있다는 걸 일부러 표시할 때 쓴다. 나중에 값을 채울 변수인데, 처음에는 "값 없음"이라고 분명히 해두고 싶을 때 넣는다.

```javascript
let person = null;  // 아직 값이 없지만, 값이 없음을 명시적으로 나타냄
```

### 요약

undefined는 값이 할당되지 않았을 때 JavaScript가 자동으로 넣는 값이고, null은 값이 없다는 걸 개발자가 직접 표시하는 값이다.
