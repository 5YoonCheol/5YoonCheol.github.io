---
title: "[Vue] DataTable 사용하기"
date: 2024-09-02 09:09:27 +0900
categories: [Frontend, Vue]
tags: ["datatable", "vue"]
tistory_url: https://yoon-ssi.tistory.com/40
render_with_liquid: false
---

Vue를 활용하여 표를 그려야하는 경우가 많은데, 오늘 포스팅에서는 Vuetify에서 제공하는 DataTable 컴포넌트를 사용하는 방법에 대해서 알아보자.

---

### 1. Vuetify 설치

Vuetify는 Vue.js를 위한 Material Design 컴포넌트 프레임워크로, 다양한 UI 컴포넌트를 제공한다. DataTable 컴포넌트도 그 중 하나다.

설치 방법은 2가지다.

**1. npm을 이용한 설치**

```bash
npm install vuetify
```

**2. Vue 프로젝트에 Vuetify** 추가

Vue CLI로 생성된 프로젝트의 경우, Vuetify를 쉽게 추가할 수 있다.

```bash
vue add vuetify
```

### 2. DataTable 기본 사용법

Vuetify가 설치된 후, DataTable 컴포넌트를 사용하여 데이터를 표 형식으로 표시할 수 있다.

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

- **&lt;v-data-table&gt;**: Vuetify에서 제공하는 DataTable 컴포넌트
- **headers**: 테이블의 헤더 정보를 담고 있는 배열. 각 헤더는 text, value, align, sortable 등의 속성을 가질 수 있다.
- **items**: 테이블에 표시할 데이터 배열
- **items-per-page**: 페이지당 표시할 항목의 수를 지정한다.
- **v-slot:top**: DataTable의 상단 영역에 추가적인 요소를 삽입할 수 있는 슬롯. 여기서는 검색 필드를 추가했다.
- **v-model="search"**: 검색 필드와 DataTable을 연동하여, 사용자가 입력한 검색어에 따라 테이블을 필터링한다.

### 4. 기능 확장

#### 1) **정렬 기능 추가**

기본적으로 sortable 속성을 true로 설정하면, 테이블의 헤더를 클릭하여 해당 열의 데이터를 정렬할 수 있다.

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

#### 2) **페이지네이션 기능**

기본적으로 Vuetify의 DataTable은 페이지네이션을 지원해준다. items-per-page 속성을 사용하여 한 페이지에 표시할 항목 수를 조정할 수 있다.

#### 3) **커스텀 셀 렌더링**

DataTable에서 특정 셀을 커스터마이징하고 싶은 경우, 슬롯을 활용할 수 있다.

```html
<template v-slot:item.name="{ item }">
  <v-chip>{{ item.name }}</v-chip>
</template>
```

위의 코드는 name 열의 데이터를 v-chip 컴포넌트로 감싸서 출력

### 5. 다른 옵션 및 기능

- **서버 사이드 처리**: 데이터가 매우 클 경우, 클라이언트 사이드에서 처리하는 대신 서버에서 페이징, 정렬, 검색을 수행하는 것이 좋다. 이 경우 @update:options 이벤트를 사용하여 서버와의 통신을 처리할 수 있다.
- **선택 기능**: 테이블에서 특정 행을 선택할 수 있는 기능을 제공하며, @select 이벤트를 통해 선택된 항목을 관리할 수 있다.

참고: Vuetify 공식 페이지

<https://vuetifyjs.com/en/components/data-tables/introduction/#components>
