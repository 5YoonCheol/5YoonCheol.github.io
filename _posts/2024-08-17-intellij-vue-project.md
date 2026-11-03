---
title: "[Vue] 인텔리제이 Vue 프로젝트 생성하기"
date: 2024-08-17 02:00:00 +0900
categories: [Frontend, Vue]
tags: ["intellij", "vue", "뷰", "인텔리제이", "프로젝트-생성"]
tistory_url: https://yoon-ssi.tistory.com/23
render_with_liquid: false
---

요즘은 BackEnd와 FrontEnd 프로젝트를 나눠서 작업하는 경우가 많다. 이번에는 JavaScript 프레임워크인 Vue.js 프로젝트를 IntelliJ에서 만드는 방법을 정리해보려 한다.

---

### IntelliJ IDEA에서 Vue.js 프로젝트 만들기

1. IntelliJ IDEA를 실행한다.
2. 초기 화면에서 "Create New Project"를 누른다.
3. 왼쪽 메뉴에서 "JavaScript"를 고르고 "Vue.js"를 선택한다. 이 옵션이 안 보이면 "Node.js"를 선택하고 Vue.js를 설치해서 설정한다.
4. 프로젝트 이름을 입력하고, 저장할 디렉토리를 고른다.
5. 세부 설정을 확인한다.
   - Node.js가 설치돼 있는지 확인하고, 맞는 Node.js 버전을 고른다.
   - Vue CLI를 자동으로 설치하는 옵션이 있으면 체크한다. 설치가 끝나면 Vue.js 템플릿을 쓸 수 있다.
6. "Create" 버튼을 누른다. IntelliJ IDEA가 필요한 패키지를 알아서 설치하고 기본 Vue.js 프로젝트 구조를 만들어준다.
7. 프로젝트가 만들어지면 왼쪽 프로젝트 탐색기에서 src/, public/, node_modules/ 같은 디렉토리가 생겼는지 확인한다.
8. 하단 패널에서 "Terminal"을 열고 아래 명령어로 개발 서버를 띄운다.

```shell
npm run serve
```

서버가 뜨면 기본적으로 `http://localhost:8080`에서 애플리케이션을 볼 수 있다.

이제 src/ 디렉토리에서 Vue 컴포넌트를 작성하면서 개발하면 된다. App.vue에서 기본 컴포넌트를 고치거나, components/ 디렉토리에 새 컴포넌트를 추가하면 된다.

프로젝트 생성은 간단하다!
