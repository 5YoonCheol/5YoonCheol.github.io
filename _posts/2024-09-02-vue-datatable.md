---
title: "[Vue] DataTable 사용하기"
date: 2024-09-02 02:00:00 +0900
categories: [Frontend, Vue]
tags: ["datatable", "vue"]
tistory_url: https://yoon-ssi.tistory.com/40
render_with_liquid: false
---

Vue로 화면을 만들다 보면 표를 그릴 일이 많다. 이번에는 Vuetify의 DataTable 컴포넌트 쓰는 법을 정리해보자.

---

### 1. Vuetify 설치

Vuetify는 Vue.js용 Material Design 컴포넌트 프레임워크다. 여러 UI 컴포넌트를 제공하는데 DataTable도 그중 하나다.

설치하는 방법은 두 가지다.

npm으로 설치

```bash
npm install vuetify
```

Vue CLI로 만든 프로젝트라면 이렇게 추가하면 된다.

```bash
vue add vuetify
```

### 2. DataTable 기본 사용법

설치가 끝나면 DataTable 컴포넌트로 데이터를 표로 보여줄 수 있다.

```html
<template>
  <v-container>
    <v-data-table
      :headers="headers"
      :items="items"
      :items-per-page="5"
      class="elevation-1"
    >
      <template v-slot:top>
        <v-text-field
          v-model="search"
          label="Search"
          class="mx-4"
        ></v-text-field>
      </template>
    </v-data-table>
  </v-container>
</template>

<script>
export default {
  data() {
    return {
      search: '',
      headers: [
        {
          text: 'Name',
          align: 'start',
          sortable: false,
          value: 'name',
        },
        { text: 'Age', value: 'age' },
        { text: 'Gender', value: 'gender' },
      ],
      items: [
        { name: 'John Doe', age: 30, gender: 'Male' },
        { name: 'Jane Smith', age: 25, gender: 'Female' },
        { name: 'Alice Johnson', age: 35, gender: 'Female' },
        { name: 'Mike Brown', age: 40, gender: 'Male' },
        { name: 'Emily White', age: 20, gender: 'Female' },
      ],
    };
  },
};
</script>
```

### 3. 코드 설명

- `<v-data-table>`: Vuetify의 DataTable 컴포넌트
- `headers`: 테이블 헤더 정보 배열. 헤더마다 text, value, align, sortable 같은 속성을 줄 수 있다.
- `items`: 테이블에 보여줄 데이터 배열
- `items-per-page`: 한 페이지에 보여줄 항목 수
- `v-slot:top`: 테이블 위쪽에 다른 요소를 넣을 수 있는 슬롯. 여기서는 검색 필드를 넣었다.
- `v-model="search"`: 검색 필드와 테이블을 연결해서, 입력한 검색어로 테이블을 필터링한다.

### 4. 기능 더 붙여보기

#### 1) 정렬

헤더에 sortable을 true로 주면 헤더를 클릭해서 그 열 기준으로 정렬할 수 있다.

```javascript
headers: [
  {
    text: 'Name',
    align: 'start',
    sortable: true, // 기본값이 true
    value: 'name',
  },
  { text: 'Age', value: 'age', sortable: true },
  { text: 'Gender', value: 'gender', sortable: true },
],
```

#### 2) 페이지네이션

DataTable은 기본으로 페이지네이션을 지원한다. `items-per-page`로 한 페이지에 몇 개를 보여줄지 정하면 된다.

#### 3) 셀 직접 그리기

특정 셀 모양을 바꾸고 싶으면 슬롯을 쓰면 된다.

```html
<template v-slot:item.name="{ item }">
  <v-chip>{{ item.name }}</v-chip>
</template>
```

name 열의 값을 v-chip 컴포넌트로 감싸서 보여주는 코드다.

### 5. 그 밖의 옵션

- 서버 사이드 처리: 데이터가 아주 많으면 클라이언트에서 처리하지 말고 서버에서 페이징, 정렬, 검색을 하는 게 낫다. 이때는 `@update:options` 이벤트로 서버와 통신하면 된다.
- 행 선택: 테이블에서 특정 행을 선택할 수 있고, `@select` 이벤트로 선택된 항목을 관리할 수 있다.

참고: Vuetify 공식 페이지

<https://vuetifyjs.com/en/components/data-tables/introduction/#components>
