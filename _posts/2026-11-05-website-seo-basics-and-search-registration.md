---
title: "[SEO] 만든 사이트를 검색에 노출시키기: 메타 태그부터 검색 엔진 등록까지"
date: 2026-11-05 02:00:01 +0900
categories: [Frontend, SEO]
tags: [seo, sitemap, robots, open-graph, search-console]
---

사이트를 배포하고 나면 다음 고민은 "그래서 사람들이 어떻게 찾아오지?"다. 광고를 돌리지 않는 이상 대부분 검색을 타고 들어오는데, 검색 엔진은 사이트가 있다는 것만으로 알아서 잘 보여주지 않는다. 사이드 프로젝트 사이트를 검색에 올릴 때 챙겨야 할 것들을 순서대로 정리해보자. 프레임워크와 상관없이 적용되는 내용이다.

---

### 1. 검색 엔진이 사이트를 다루는 순서

크게 세 단계다.

1. 크롤링: 봇이 링크를 따라다니며 페이지를 가져간다.
2. 색인(인덱싱): 가져간 페이지를 분석해서 검색 DB에 넣는다.
3. 랭킹: 검색어가 들어오면 색인된 페이지 중에서 순서를 매겨 보여준다.

개발자가 직접 손댈 수 있는 건 1, 2번이다. 봇이 잘 가져가게 하고, 가져간 페이지를 제대로 이해하게 만드는 것. 랭킹은 그 다음 문제다.

---

### 2. 페이지마다 챙길 메타 태그

`<head>` 안에 들어가는 기본 태그들이다. 전체 페이지에 똑같은 값을 박아두는 경우가 많은데, 페이지마다 다르게 넣어야 의미가 있다.

```html
<head>
  <title>상품명 - 사이트 이름</title>
  <meta name="description" content="이 페이지가 무엇인지 한두 문장으로">
  <link rel="canonical" href="https://example.com/products/123">
  <meta name="robots" content="index, follow">
</head>
```

- `title`은 검색 결과의 제목이 된다. 페이지 고유 내용을 앞에, 사이트 이름을 뒤에 두는 게 보통이다.
- `description`은 검색 결과 아래 설명으로 쓰인다. 검색 엔진이 다른 문장을 골라 보여주기도 하지만, 없으면 아무 문장이나 잘라서 쓴다.
- `canonical`은 "이 내용의 대표 주소는 이거다"라고 알려준다. 쿼리 스트링이 붙은 주소, 끝에 슬래시가 있고 없는 주소, http와 https가 전부 다른 페이지로 잡히는 걸 막아준다. 목록 페이지에 필터와 정렬 파라미터가 많다면 특히 중요하다.
- `robots`는 색인 여부를 페이지 단위로 제어한다. 관리자 페이지나 검색 결과 페이지처럼 색인되면 곤란한 곳에 `noindex`를 건다.

---

### 3. SNS 공유용 Open Graph

링크를 메신저나 SNS에 붙였을 때 뜨는 미리보기 카드는 Open Graph 태그로 만들어진다. 검색 순위에 직접 영향을 주진 않지만, 공유될 때 모양이 깔끔해야 클릭이 나온다.

```html
<meta property="og:type" content="website">
<meta property="og:title" content="상품명 - 사이트 이름">
<meta property="og:description" content="한두 문장 설명">
<meta property="og:image" content="https://example.com/images/products/123-og.png">
<meta property="og:url" content="https://example.com/products/123">
<meta name="twitter:card" content="summary_large_image">
```

`og:image`는 절대 경로여야 하고, 가로로 긴 이미지(1200×630 정도)를 쓰면 대부분의 플랫폼에서 잘 나온다. 각 플랫폼에서 제공하는 미리보기 디버거로 실제 어떻게 보이는지 확인하는 게 좋다. 한 번 캐시되면 수정해도 바로 반영이 안 되니, 처음 공유하기 전에 확인하자.

---

### 4. robots.txt와 sitemap.xml

사이트 루트에 두는 두 파일이다.

**robots.txt**는 봇에게 어디를 돌아다녀도 되는지 알려준다.

```text
User-agent: *
Allow: /
Disallow: /admin/
Disallow: /api/

Sitemap: https://example.com/sitemap.xml
```

주의할 점은 robots.txt는 "크롤링하지 마"이지 "색인하지 마"가 아니라는 것이다. 다른 사이트에서 링크가 걸려 있으면 내용을 안 보고도 주소만 색인될 수 있다. 확실히 빼고 싶은 페이지는 `noindex` 메타 태그를 써야 한다.

**sitemap.xml**은 사이트에 어떤 페이지가 있는지 목록으로 알려준다. 링크를 따라가기 어려운 페이지(JS로만 이동하는 상세 페이지 등)가 있다면 특히 필요하다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://example.com/</loc>
    <lastmod>2026-11-01</lastmod>
  </url>
  <url>
    <loc>https://example.com/products/123</loc>
    <lastmod>2026-11-03</lastmod>
  </url>
</urlset>
```

페이지가 많으면 손으로 관리할 수 없으니 빌드 시점이나 배포 시점에 생성하게 만든다. 정적 사이트 생성기는 대부분 플러그인이 있고, 서버 애플리케이션이면 DB에서 목록을 뽑아 응답하는 엔드포인트 하나를 만들면 된다. `lastmod`는 실제로 바뀐 날짜를 넣어야 한다. 매번 오늘 날짜로 찍어내면 봇이 신뢰하지 않는다.

---

### 5. 구조화 데이터 (JSON-LD)

페이지가 "상품"인지 "글"인지 "FAQ"인지를 검색 엔진이 이해할 수 있는 형식으로 알려주는 것이다. schema.org 어휘를 JSON-LD로 `<head>`에 넣는다.

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Product",
  "name": "상품명",
  "image": "https://example.com/images/products/123.png",
  "description": "상품 설명",
  "brand": { "@type": "Brand", "name": "브랜드명" }
}
</script>
```

이걸 넣는다고 순위가 오르진 않지만, 검색 결과에 별점이나 가격 같은 부가 정보가 붙는 리치 결과의 대상이 될 수 있다. 검색 엔진에서 제공하는 리치 결과 테스트 도구로 문법이 맞는지 확인할 수 있다.

---

### 6. 검색 엔진에 직접 등록하기

여기까지 준비했으면 검색 엔진에 "내 사이트 여기 있다"고 알려줄 차례다. 기다리면 언젠가 봇이 오긴 하지만, 신규 사이트는 링크가 거의 없어서 그 언젠가가 꽤 길다.

**Google Search Console**
1. 사이트 소유권을 확인한다. DNS 레코드 추가, HTML 파일 업로드, 메타 태그 삽입 중 하나를 고르면 된다. 도메인 전체를 관리하려면 DNS 방식이 편하다.
2. Sitemaps 메뉴에 sitemap.xml 주소를 제출한다.
3. URL 검사 도구로 주요 페이지 몇 개의 색인을 직접 요청한다.

**네이버 서치어드바이저**
국내 트래픽이 중요하면 네이버도 따로 등록해야 한다. 흐름은 비슷하다. 사이트 등록 후 소유 확인, 사이트맵 제출, RSS가 있으면 RSS도 제출한다. 네이버는 자체 수집 로직이 있어서 구글에 뜬다고 네이버에 바로 뜨지는 않는다.

**Bing Webmaster Tools**
Search Console 계정으로 가져오기가 되니 몇 분이면 끝난다. 국내에서는 비중이 작지만 공짜로 되는 걸 안 할 이유가 없다.

---

### 7. 등록하고 나서 볼 것

등록 직후에는 아무것도 안 보인다. 며칠에서 몇 주 지나야 데이터가 쌓인다. 그동안 확인할 건 이렇다.

- 색인 생성 보고서에서 "제외됨"으로 분류된 페이지가 있는지. canonical 설정이 잘못됐거나 noindex가 의도치 않게 들어간 경우가 여기서 드러난다.
- 사이트맵이 정상적으로 읽혔는지. 형식 오류가 있으면 여기서 알려준다.
- 모바일 사용성이나 페이지 속도 경고. 검색 엔진은 모바일 화면을 기준으로 평가한다.

`site:example.com`으로 검색해보면 색인된 페이지를 대략 확인할 수 있다. 정확한 수치는 아니지만 "아예 안 잡히는지"는 바로 알 수 있다.

---

### 정리

| 단계 | 할 일 |
|------|------|
| 페이지 | title, description, canonical을 페이지마다 다르게 |
| 공유 | Open Graph 태그와 미리보기 이미지 |
| 사이트 | robots.txt, 자동 생성되는 sitemap.xml |
| 의미 | 페이지 종류에 맞는 JSON-LD |
| 등록 | Search Console, 서치어드바이저에 소유 확인 후 사이트맵 제출 |
| 이후 | 색인 보고서에서 제외된 페이지 확인 |

한 번 세팅해두면 그 다음은 페이지가 늘어날 때 사이트맵에 자동으로 들어가는지만 챙기면 된다. 검색 유입은 바로 오지 않지만, 기반이 없으면 아예 안 온다.
