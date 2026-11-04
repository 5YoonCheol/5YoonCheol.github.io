---
title: "[알고리즘] Java 문자열·배열 기본 문제 풀이 모음: 투 포인터와 누적 계산"
date: 2024-10-08 02:00:00 +0900
categories: [Algorithm, Problem]
tags: ["java", "코테-대비", "투-포인터", "문자열", "배열", "피보나치"]
description: 코딩 테스트 초반에 나오는 문자열·배열 문제 여섯 개를 Java로 풀면서 공통 패턴을 정리한다. 양끝 투 포인터(문자열 뒤집기), 두 배열 투 포인터(정렬된 배열 합치기), 양방향 스캔(가장 가까운 문자 거리), 누적 상태(OX 점수, 피보나치), 중복 제거와 StringBuilder·Set 선택.
tistory_url: https://yoon-ssi.tistory.com/77
tistory_urls: [https://yoon-ssi.tistory.com/53, https://yoon-ssi.tistory.com/54, https://yoon-ssi.tistory.com/55, https://yoon-ssi.tistory.com/56, https://yoon-ssi.tistory.com/62, https://yoon-ssi.tistory.com/77]
redirect_from:
  - /posts/algorithm-reverse-string/
  - /posts/algorithm-remove-duplicate-chars/
  - /posts/algorithm-shortest-char-distance/
  - /posts/algorithm-fibonacci/
  - /posts/algorithm-ox-quiz-score/
  - /posts/algorithm-merge-arrays/
render_with_liquid: false
---

> 2026년 11월에 문자열 뒤집기, 중복 문자 제거, 특정 문자와의 최단 거리, 피보나치 수열, OX 점수 계산, 배열 합치기 여섯 글을 하나로 합쳐 다시 썼다. 옛 주소로 들어오면 이 글로 넘어온다.
{: .prompt-info }

코딩 테스트 앞부분에 나오는 문자열·배열 문제는 각각 따로 외울 게 아니라 몇 가지 패턴으로 묶인다. 양끝에서 좁혀 오는 투 포인터, 두 배열을 나란히 읽는 투 포인터, 왼쪽→오른쪽과 오른쪽→왼쪽 두 번 훑기, 상태 하나를 누적하며 한 번 훑기. 여섯 문제를 이 패턴으로 묶어서 정리한다.

---

### 1. 문자열 뒤집기: 양끝 투 포인터

가장 짧은 답은 `StringBuilder`다.

```java
public String reverse(String str) {
    return new StringBuilder(str).reverse().toString();
}
```

하지만 "알파벳만 뒤집고 특수문자는 자리에 둔다" 같은 변형이 나오면 직접 구현해야 한다. 왼쪽과 오른쪽 포인터를 양끝에서 출발시켜 교차할 때까지 교환한다.

```java
public String reverse(String str) {
    char[] chars = str.toCharArray();
    int lt = 0, rt = chars.length - 1;
    while (lt < rt) {
        char tmp = chars[lt];
        chars[lt] = chars[rt];
        chars[rt] = tmp;
        lt++;
        rt--;
    }
    return new String(chars);
}
```

`"abcde"`라면 a↔e → `ebcda`, b↔d → `edcba`, 그리고 lt와 rt가 2에서 만나 끝난다. 변형 문제는 교환 전에 조건을 붙이면 된다.

```java
// 알파벳만 뒤집기: 알파벳이 아닌 쪽 포인터는 그냥 지나간다
while (lt < rt) {
    if (!Character.isAlphabetic(chars[lt])) { lt++; continue; }
    if (!Character.isAlphabetic(chars[rt])) { rt--; continue; }
    // ... 교환
}
```

---

### 2. 중복 문자 제거: 순서를 지키는 Set

```java
public String removeDuplicates(String str) {
    StringBuilder sb = new StringBuilder();
    for (char c : str.toCharArray()) {
        if (sb.indexOf(String.valueOf(c)) == -1) {
            sb.append(c);
        }
    }
    return sb.toString();
}
```

`answer += c`처럼 `String`을 이어 붙이면 매번 새 문자열이 만들어져 O(n²)이 된다. `StringBuilder`를 쓴다. 다만 `indexOf`도 매번 앞을 훑으니 이 코드 역시 O(n²)이다. 길이가 길면 `LinkedHashSet`으로 순서를 지키면서 O(n)에 끝낸다.

```java
public String removeDuplicates(String str) {
    Set<Character> seen = new LinkedHashSet<>();
    for (char c : str.toCharArray()) {
        seen.add(c);   // 이미 있으면 무시된다
    }
    StringBuilder sb = new StringBuilder();
    seen.forEach(sb::append);
    return sb.toString();
}
```

대소문자를 구분하지 않으려면 넣기 전에 `Character.toLowerCase(c)`로 통일한다. `HashSet`은 순서를 보장하지 않으니 "처음 나온 순서대로"라는 조건이 있으면 꼭 `LinkedHashSet`이어야 한다.

---

### 3. 특정 문자와의 가장 짧은 거리: 양방향 스캔

`"helloworld"`에서 각 위치가 가장 가까운 `'o'`와 얼마나 떨어져 있는지 구하는 문제다. 모든 위치에서 양쪽을 다 찾으면 O(n²)이지만, 왼쪽에서 한 번, 오른쪽에서 한 번 훑으면 O(n)이다.

```java
public int[] shortestDistance(String str, char target) {
    int n = str.length();
    int[] dist = new int[n];
    int last = -n;                     // "아직 못 봤다"를 충분히 먼 값으로

    for (int i = 0; i < n; i++) {      // 왼쪽 → 오른쪽: 왼쪽에 있는 target 과의 거리
        if (str.charAt(i) == target) last = i;
        dist[i] = i - last;
    }
    last = 2 * n;
    for (int i = n - 1; i >= 0; i--) { // 오른쪽 → 왼쪽: 오른쪽 target 과의 거리와 비교해 작은 값
        if (str.charAt(i) == target) last = i;
        dist[i] = Math.min(dist[i], last - i);
    }
    return dist;                       // [4, 3, 2, 1, 0, 1, 0, 1, 2, 3]
}
```

첫 번째 패스는 "왼쪽에 있는 target까지", 두 번째 패스는 "오른쪽에 있는 target까지"를 구하고 작은 쪽을 택한다. "양쪽 중 가까운 것"을 묻는 문제는 대부분 이 두 번 훑기로 풀린다.

---

### 4. 정렬된 두 배열 합치기: 두 배열 투 포인터

오름차순 배열 `A = [1, 2, 3, 5]`, `B = [2, 4, 5, 8, 9]`를 합쳐 `[1, 2, 2, 3, 4, 5, 5, 8, 9]`를 만든다. 합치고 정렬하면 O((n+m) log(n+m))이지만, 이미 정렬돼 있으니 각 배열에 포인터를 하나씩 두고 작은 쪽을 꺼내면 O(n+m)이다.

```java
public List<Integer> merge(int[] a, int[] b) {
    List<Integer> result = new ArrayList<>(a.length + b.length);
    int p1 = 0, p2 = 0;
    while (p1 < a.length && p2 < b.length) {
        if (a[p1] <= b[p2]) result.add(a[p1++]);   // 같으면 a 를 먼저 (안정성)
        else                result.add(b[p2++]);
    }
    while (p1 < a.length) result.add(a[p1++]);     // 남은 쪽을 마저 붙인다
    while (p2 < b.length) result.add(b[p2++]);
    return result;
}
```

이 "두 정렬 목록을 하나로 합치기"가 병합 정렬의 핵심 단계다. 교집합·합집합 구하기, 두 정렬 리스트에서 k번째 원소 찾기도 같은 틀로 푼다.

---

### 5. OX 점수 계산: 상태 하나를 누적하며 한 번 훑기

맞으면 1점, 연속으로 맞으면 1, 2, 3점으로 올라가고 틀리면 0으로 돌아간다. `[1, 0, 1, 1, 1, 0, 1, 1, 0]`이면 `1 + 0 + 1 + 2 + 3 + 0 + 1 + 2 + 0 = 10`점이다.

```java
public int score(int[] answers) {
    int total = 0;
    int streak = 0;                  // 현재 연속 정답 수
    for (int a : answers) {
        streak = (a == 1) ? streak + 1 : 0;
        total += streak;
    }
    return total;
}
```

"직전 상태에 따라 현재 값이 정해진다"는 문제는 상태 변수 하나를 들고 한 번만 훑으면 된다. 연속 구간의 최대 길이, 최대 부분합(카데인)도 같은 모양이다.

---

### 6. 피보나치 수열: 이전 두 값만 기억하기

앞의 두 수를 더해 다음 수를 만든다. n개를 출력해야 하면 배열에 채운다.

```java
public int[] fibonacci(int n) {        // n >= 2
    int[] f = new int[n];
    f[0] = 1;
    f[1] = 1;
    for (int i = 2; i < n; i++) {
        f[i] = f[i - 1] + f[i - 2];
    }
    return f;
}
```

n번째 값 하나만 필요하면 배열도 필요 없다. 직전 두 값만 들고 간다.

```java
public long fibonacci(int n) {
    long prev = 1, curr = 1;
    for (int i = 2; i < n; i++) {
        long next = prev + curr;
        prev = curr;
        curr = next;
    }
    return curr;
}
```

두 가지를 조심한다. `int`는 47번째 항부터 넘치니 `long`을 쓰고, 그보다 크면 문제에서 주는 모듈러(`% 1_000_000_007`)를 매 단계 적용한다. 재귀로 짜면 같은 값을 반복 계산해 O(2ⁿ)이 되니, 재귀가 필요하면 메모이제이션을 붙인다.

---

### 7. 패턴으로 다시 보기

| 패턴 | 문제 | 시간 |
|---|---|---|
| 양끝 투 포인터 | 문자열 뒤집기, 회문 판별 | O(n) |
| 두 배열 투 포인터 | 정렬된 배열 합치기, 교집합 | O(n+m) |
| 양방향 스캔 | 가장 가까운 문자 거리 | O(n) |
| 상태 누적 한 번 훑기 | OX 점수, 피보나치, 최대 부분합 | O(n) |
| 순서 있는 집합 | 중복 제거 | O(n) |

그리고 Java에서 문자열을 반복문 안에서 `+`로 이어 붙이지 않는 것, 결과가 커질 수 있으면 `long`을 쓰는 것, 이 둘이 문제 유형과 상관없이 늘 걸리는 함정이다.
