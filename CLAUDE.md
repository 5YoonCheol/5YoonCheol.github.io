# 블로그 작성 규칙

이 레포는 Jekyll + Chirpy 테마 기반 GitHub Pages 블로그다 (https://5yooncheol.github.io).

## 글 작성
- 글은 `_posts/YYYY-MM-DD-slug.md`에 만든다. slug는 영문 소문자와 하이픈만 쓴다.
- front matter 형식:
  ```yaml
  ---
  title: 글 제목
  date: YYYY-MM-DD 02:00:00 +0900
  categories: [대분류, 소분류]
  tags: [소문자-태그]
  ---
  ```
- 게시 시간은 블로그 이름(새벽 2시의 커밋)에 맞춰 항상 새벽 2시(`02:00:00 +0900`)로 쓴다. 같은 날 글이 여러 개면 초를 `02:00:01`, `02:00:02`처럼 올려 순서를 정한다.
- 본문은 한국어. 이미지는 `assets/img/posts/<slug>/`에 둔다.
- 초안은 `_drafts/`에 두면 배포되지 않는다.

## 게시 절차
- 새 글이나 수정은 브랜치를 만들어 PR로 올린다. 사용자가 PR을 머지하면 `main` 푸시로 자동 배포된다.
- 푸시 전 `bundle exec jekyll build`로 빌드가 되는지 확인한다.
