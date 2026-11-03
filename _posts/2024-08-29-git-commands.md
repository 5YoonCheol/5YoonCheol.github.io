---
title: "[Git] Git 명령어 마스터하기!"
date: 2024-08-29 02:00:00 +0900
categories: [DevOps, Git]
tags: ["git", "명령어"]
tistory_url: https://yoon-ssi.tistory.com/36
render_with_liquid: false
---

Git은 개발하면서 매일 쓰는 버전 관리 도구다. 그런데 막상 자주 쓰는 명령어 몇 개만 손에 익어 있고, 나머지는 쓸 때마다 검색하게 된다.

그래서 자주 쓰는 Git 명령어들을 예제와 함께 한 번에 정리해봤다.

---

### 1. git init

새로운 Git 저장소를 초기화한다. 이 명령어를 사용하면 .git 디렉터리가 생성되어 현재 디렉터리를 Git 프로젝트로 변환한다.

```bash
mkdir my_project
cd my_project
git init
```

이 명령어를 실행하면 my_project 디렉터리가 Git 프로젝트로 변환된다.

### 2. git clone

원격 저장소를 로컬로 복제한다.

```bash
git clone https://github.com/user/repository.git
```

이 명령어를 실행하면 repository라는 디렉터리가 현재 디렉터리에 생성되고, 해당 디렉터리 안에 원격 저장소의 내용이 복제된다.

### 3. git add

변경된 파일을 스테이징 영역에 추가한다. Git은 스테이징 영역에 추가된 파일들만 커밋된다.

```bash
git add filename.txt
```

혹은 모든 변경 사항을 추가하려면

```bash
git add .
```

### 4. git commit

스테이징 영역에 있는 변경 사항을 커밋한다.

```bash
git commit -m "Initial commit"
```

이 명령어는 "Initial commit"이라는 메시지와 함께 변경 사항을 커밋한다.

### 5. git status

현재 작업 디렉터리의 상태를 확인한다. 수정된 파일, 스테이징된 파일 등을 보여준다.

```bash
git status
```

### 6. git log

프로젝트의 커밋 기록을 확인한다.

```bash
git log
```

커밋 히스토리를 확인할 수 있으며, 다양한 옵션을 사용해 로그를 커스터마이징 할 수 있다.

### 7. git branch

브랜치를 만들고, 지우고, 지금 어느 브랜치에 있는지 확인할 때 쓴다.

브랜치 목록 확인

```bash
git branch
```

새 브랜치 만들기

```bash
git branch new-feature
```

### 8. git checkout

브랜치를 전환하거나 특정 커밋으로 워킹 디렉터리를 전환할 때 사용한다.

```bash
git checkout new-feature
```

이 명령어는 new-feature 브랜치로 전환한다.

### 9. git merge

두 브랜치를 병합한다.

```bash
git checkout main
git merge new-feature
```

이 명령어는 main 브랜치에서 new-feature 브랜치의 변경 사항을 병합한다.

### 10. git pull

원격 저장소에서 최신 변경 사항을 가져와 로컬 브랜치에 병합한다.

```bash
git pull origin main
```

### 11. git push

로컬 브랜치의 커밋을 원격 저장소로 푸시한다.

```bash
git push origin main
```

### 12. git revert

이전 커밋을 되돌린다. 이 명령어는 기존의 커밋 기록을 유지한 채로 작업을 되돌려준다.

```bash
git revert HEAD
```

### 13. git reset

현재 브랜치의 HEAD를 이전 커밋으로 되돌린다. 소스 코드 변경 사항이 제거될 수 있어 주의가 필요하다.

```bash
git reset --hard HEAD~1
```

### 14. git stash

현재 작업 중인 내용을 임시로 저장하고 워킹 디렉터리를 비워준다. 추후에 작업을 다시 꺼내올 수 있다.

```bash
git stash
```

### 15. git tag

특정 커밋에 태그를 붙여 중요한 시점을 기록한다.

```bash
git tag v1.0.0
git push origin v1.0.0
```

---

이 중에서 commit, push, pull, merge는 정말 매일 쓰는 것들이라 손에 익혀 두는 게 좋다.
