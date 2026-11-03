---
title: "jQuery란?"
date: 2024-10-06 11:11:15 +0900
categories: [Frontend, JavaScript]
tags: ["jquery"]
tistory_url: https://yoon-ssi.tistory.com/75
render_with_liquid: false
---

jQuery는 2006년에 나온 JavaScript 라이브러리다. JavaScript를 더 쉽게 쓸 수 있게 해주는 기능을 모아둔 도구라고 보면 된다.

짧은 문법으로 HTML 요소를 찾고 바꾸고, 이벤트를 처리하고, 애니메이션과 Ajax 통신까지 할 수 있다. 무엇보다 브라우저마다 다르게 동작하던 문제를 jQuery가 대신 해결해줘서, 어느 브라우저에서나 똑같이 동작하는 코드를 쓸 수 있다는 게 당시엔 큰 장점이었다.

---

### 주요 기능

#### HTML/DOM 조작

CSS 선택자로 원하는 요소를 골라서 내용이나 속성, 스타일을 바꿀 수 있다.

```javascript
// 모든 <p> 태그의 텍스트를 변경
$("p").text("Hello, jQuery!");
```

#### 이벤트 처리

클릭, 키보드 입력 같은 이벤트 처리를 간단하게 붙일 수 있다.

```javascript
// 버튼 클릭 시 경고창 띄우기
$("#myButton").click(function() {
    alert("버튼이 클릭되었습니다.");
});
```

#### 애니메이션

위치, 크기, 투명도를 바꾸는 기본 애니메이션 효과를 제공해서 페이지에 움직임을 쉽게 줄 수 있다.

```javascript
// 요소를 서서히 나타나게 하기
$("#myDiv").fadeIn();
```

#### Ajax 통신

Ajax를 단순하게 만들어서 페이지를 새로 고치지 않고도 서버와 데이터를 주고받을 수 있다.

```javascript
// Ajax를 사용하여 서버로부터 데이터를 가져오기
$.ajax({
    url: "data.json",
    method: "GET",
    success: function(response) {
        console.log(response);
    },
    error: function() {
        alert("데이터를 가져오는 데 실패했습니다.");
    }
});
```

#### 브라우저 호환성

브라우저마다 다른 부분을 jQuery가 알아서 맞춰준다. 덕분에 개발자가 브라우저별 분기 처리를 복잡하게 짤 필요가 없었다.

---

### 장점

- 문법이 간단하다: 복잡한 JavaScript 코드를 짧고 직관적으로 쓸 수 있다.
- 브라우저 호환성: 브라우저 간 차이를 알아서 처리해준다.
- 플러그인: 커뮤니티에서 만든 플러그인이 많아서 웬만한 기능은 가져다 쓰면 된다.
- 애니메이션과 Ajax가 쉽다: 몇 줄이면 구현된다.

### 단점

- 성능: 요즘 브라우저에서는 순수 자바스크립트(Vanilla JS)가 더 빠르고 가볍다. 라이브러리 자체가 꽤 커서, 간단한 기능 하나 쓰려고 전체를 불러오는 건 낭비일 수 있다.
- 최신 프레임워크의 등장: React, Vue.js, Angular 같은 프레임워크가 나오면서 jQuery가 설 자리가 많이 줄었다. 특히 SPA(Single Page Application)를 만든다면 이런 프레임워크가 더 맞다.

---

### 지금은 얼마나 쓰나

초창기 웹 개발에서는 정말 인기가 많았고 수많은 사이트가 jQuery로 만들어졌다. 하지만 Vanilla JavaScript 자체가 좋아지고 React, Vue.js 같은 프레임워크가 대중화되면서 점점 덜 쓰는 추세다.

그래도 기존 레거시 시스템이나 간단한 웹 페이지에서는 여전히 많이 쓰고 있고, jQuery 기반 플러그인이나 UI 프레임워크도 아직 많다.
