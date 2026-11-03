---
title: "[Trouble Shooting] Ajax 공통화 작업"
date: 2024-08-16 12:30:44 +0900
categories: [TroubleShooting, Frontend]
tags: ["ajax", "공통화", "문제해결", "처리방식", "커스터마이징"]
tistory_url: https://yoon-ssi.tistory.com/22
render_with_liquid: false
---

현재 운영 중인 서비스의 Front는 JSP 파일로 되어있다.

$.ajax를 통해 API 통신을 하고 있는데..   
외부 API 통신 중 시간이 오래 걸리는 항목들이 있어서   
사용자 편의성을 위해 로딩바를 추가하기로 결정하였다.

 Ajax의 옵션인 beforeSend, complete 콜백을 활용해서 로딩바를 보여주고, 숨기는 방식으로 구현하려고 했다.   
이 부분에서 이제 의문점이 생겼다.

**이렇게 작업하면 앞으로 로딩바를 추가하고 싶은 모든 API호출 함수에 beforeSend, complete 콜백을 활용해야 하는 것 아닌가??**

이를 간편하게 해결하는 방법이 없을까 고민하다가

**Ajax 호출 함수를 커스터마이징 해서 로딩바를 기본적으로 노출하고 선택적으로 로딩바를 숨기는 방식으로 변경하는 방법을 사용해 보기로 했다.**

변경 방법은 다음의 순서로 했다.

**1. app.js 파일에 ajax함수 커스터마이징**

**2. 로딩바 노출 옵션 추가**

**3. 기존의 ajax 호출방식 변경**

차례대로 설명해 보자면

1번 항목에서 새로운 ajax 호출 함수를 만들어주었다.

```javascript
//예시

const AJAX_POST = "post";
const AJAX_GET = "get";

const ajax = ({
	type = AJAX_GET,
    url = "example",
    contentType = "application/json",
    data = {},
    param = {},
    successCallback = () => {},
    beforeSendCallback = () => {},
    completeCallback = () => {},
    errorCallback = () => {}
} = {}) => {
	// POST, GET일 때 파라미터 세팅 설정
	if (type === AJAX_POST) {
        data = JSON.stringify(param);
    } else {
        data = param;
    }

	// $.ajax 호출
  	$.ajax({
        type: type,
        url: url,
        contentType: contentType,
        data: data,
        beforeSend: beforeSendCallback,
        success: successCallback,
        complete: completeCallback,
        error: errorCallback
    });  
};
```

2번 작업으로 해당 메서드에 로딩바 노출 옵션을 추가해 줬다.

또한 로딩바 영역을 id값을 통해 지정해 줘서 선택할 수 있도록 변경했다.

beforeSendCallback, completeCallback 메서드를 수정해서 로딩바 노출 옵션의 값을 통해   
로딩바를 제어할 수 있도록 했다.

```javascript
//예시

const AJAX_POST = "post";
const AJAX_GET = "get";

const ajax = ({
	type = AJAX_GET,
    url = "example",
    contentType = "application/json",
    data = {},
    param = {},
    successCallback = () => {},
    beforeSendCallback = () => {
    	if(showLoading){
        	$(loadingSelector).show();
        }
    },
    completeCallback = () => {
    	if(showLoading){
        	$(loadingSelector).hide();
        }
    },
    errorCallback = () => {},
    showLoading = true, //default 값을 true로 설정
    loadingSelector = '#loading-bar' //로딩바 영역 jQuery선택자
} = {}) => {
	// POST, GET일 때 파라미터 세팅 설정
	if (type === AJAX_POST) {
        data = JSON.stringify(param);
    } else {
        data = param;
    }

	// $.ajax 호출
  	$.ajax({
        type: type,
        url: url,
        contentType: contentType,
        data: data,
        beforeSend: beforeSendCallback,
        success: successCallback,
        complete: completeCallback,
        error: errorCallback
    });  
};
```

이렇게 ajax함수를 커스터마이징 하여 기존 $.ajax 호출을 ajax로 변경한 후 호출하도록 &lt;script&gt; 부분을 수정해 주었다.

Ajax 호출 시에 로딩바를 컨트롤할 수 있도록 변경했고,

앞으로 작업할 때에도 해당 함수를 재사용할 수 있도록 만들어주었다!!
