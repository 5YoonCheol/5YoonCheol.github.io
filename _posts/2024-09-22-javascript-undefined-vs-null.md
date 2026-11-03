---
title: "[JavaScript] undefined와 null의 차이"
date: 2024-09-22 02:02:06 +0900
categories: ["ETC"]
tags: ["null", "undefined", "차이"]
tistory_url: https://yoon-ssi.tistory.com/61
render_with_liquid: false
---

오늘 포스팅에서는 JavaScript에서 자주 사용되는 **undefined**와 **null**의 차이에 대해 알아보자.

둘 다 "값이 없다" 라는 의미를 가지지만, 의미와 용도의 차이가 있다.

---

### **undefined**

- **정의**: undefined는 변수가 **선언되었지만 값이 할당되지 않은 상태**를 의미한다. JavaScript에서 변수를 선언만 하고 값을 할당하지 않으면 기본적으로 undefined가 할당된다.
- **자동 할당**: 자바스크립트 엔진이 **자동으로 할당**하는 값이다.
- **의도하지 않은 상태**: 프로그래머가 의도적으로 사용하기보다는, 변수에 값이 설정되지 않았음을 나타내는 상태를 표현할 때 많이 발생한다.

```javascript
let x;
console.log(x);  // 출력: undefined (값이 할당되지 않음)
```

### **null**

- **정의**: null은 **의도적으로 값이 없음을 명시**할 때 사용된다. 즉, 개발자가 "여기에 값이 없다는 것을 명시적으로 표현"할 때 사용한다.
- **의도된 상태**: 개발자가 변수에 "아무 값도 존재하지 않는다"는 것을 나타내기 위해 **명시적으로 할당**하는 값이다.

```javascript
let y = null;
console.log(y);  // 출력: null (값이 없음을 명시적으로 설정)
```

---

### **주요 차이점**

| **구분** | ***undefined*** | ***null*** |
| --- | --- | --- |
| **타입** | undefined (원시 타입) | object (타입은 객체이지만 비어 있음) |
| **할당 여부** | 값이 할당되지 않은 변수에 자동 할당 | 프로그래머가 의도적으로 할당 |
| **용도** | 변수나 함수의 초기 상태를 나타냄 | 값이 없음을 명시적으로 표현 |
| **의도** | 주로 시스템에 의해 결정됨 | 개발자가 명시적으로 설정 |

### **타입 비교**

undefined와 null은 값이 없다는 점에서 비슷하지만, **타입이 다르다**.

- **동등 연산자(==)**: null과 undefined는 **동등**하지만, **완전 일치하지는 않는다**.

```javascript
console.log(undefined == null);  // 출력: true (동등)
console.log(undefined === null); // 출력: false (타입까지 비교, 일치하지 않음)
```

### **사용 사례**

- undefined: 변수가 선언되었지만 값이 할당되지 않은 경우에 사용된다.   
  예를 들어, 함수에서 값을 반환하지 않으면 기본적으로 undefined가 반환된다.

```javascript
function test() {}
console.log(test());  // 출력: undefined (return 값이 없으므로)
```

- null: 프로그래머가 **의도적으로 변수가 비어 있음을 명시**할 때 사용된다.   
  예를 들어, 변수에 나중에 값이 할당될 것이지만, 초기 상태로 "값이 없음"을 명확히 할 때 null을 사용한다.

```javascript
let person = null;  // 아직 값이 없지만, 값이 없음을 명시적으로 나타냄
```

### **요약**

- **undefined**: 자바스크립트에서 변수에 값이 **할당되지 않았을 때 자동으로 할당되는 값**.
- **null**: 값이 없다는 것을 **개발자가 명시적으로 표현**하기 위해 사용하는 값.
