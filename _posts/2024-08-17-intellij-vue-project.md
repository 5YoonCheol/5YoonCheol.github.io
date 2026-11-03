---
title: "[Vue] 인텔리제이 Vue 프로젝트 생성하기"
date: 2024-08-17 08:45:59 +0900
categories: ["Vue"]
tags: ["intellij", "vue", "뷰", "인텔리제이", "프로젝트-생성"]
tistory_url: https://yoon-ssi.tistory.com/23
render_with_liquid: false
---

요즘은 BackEnd와 FrontEnd 프로젝트를 구분해서 작업하는 경우가 일반적이다.   
JavaScript 프레임워크 중 하나인 Vue.js프로젝트를 생성하는 방법에 대해 포스팅하고자 한다.

---

### IntelliJ IDEA에서 Vue.js 프로젝트 생성하기

1. **IntelliJ IDEA를 열어준다**  
   IntelliJ IDEA를 실행한다.
2. **새 프로젝트를 생성해준다**  
   초기 화면에서 "Create New Project"를 클릭해준다.
3. **프로젝트 유형을 선택해준다**  
   왼쪽 메뉴에서 "JavaScript"를 선택한 후, "Vue.js" 옵션을 선택해준다. 이 옵션이 보이지 않으면 "Node.js"를 선택하고 Vue.js를 설치하고 설정해준다.
4. **프로젝트 설정을 해준다**
   - **프로젝트 이름**: 프로젝트의 이름을 입력해준다.
   - **프로젝트 위치**: 프로젝트를 저장할 디렉토리를 선택해준다.
5. **프로젝트 설정의 세부사항을 조정해준다**
   - **Node.js 설정**: Node.js가 설치되어 있는지 확인하고, 올바른 Node.js 버전을 선택해준다.
   - **Vue CLI 설치**: Vue CLI를 자동으로 설치할 수 있는 옵션이 제공되면 확인해준다. 설치가 완료되면 Vue.js 템플릿을 사용할 수 있다.
6. **프로젝트 생성을 완료해준다**  
   "Create" 버튼을 클릭하여 프로젝트 생성을 완료해준다. IntelliJ IDEA가 필요한 패키지를 자동으로 설치하고, 기본적인 Vue.js 프로젝트 구조를 생성해준다.
7. **프로젝트 구조를 확인해준다**  
   프로젝트가 생성되면, 왼쪽의 프로젝트 탐색기에서 src/, public/, node_modules/와 같은 디렉토리 구조를 확인해준다.
8. **개발 서버를 실행해준다**  
   IntelliJ IDEA의 하단 패널에서 "Terminal"을 열고, 다음 명령어를 입력하여 개발 서버를 실행해준다.

```shell
npm run serve
```

        서버가 시작되면, 기본적으로 http://localhost:8080에서 애플리케이션을 확인할 수 있다.

    9. **코드를 작성하고 개발을 진행해준다**  
        이제 src/ 디렉토리 내에서 Vue 컴포넌트를 작성하고, 애플리케이션을 개발해준다. App.vue 파일에서 기본 컴포넌트          를 수정하거나, 새로운 컴포넌트를 components/ 디렉토리에 추가해준다.

프로젝트 생성은 간단하다!
