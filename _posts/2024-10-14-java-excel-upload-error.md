---
title: "Java Excel 업로드 오류해결"
date: 2024-10-14 02:00:00 +0900
categories: [TroubleShooting, Backend]
tags: ["excel-upload"]
tistory_url: https://yoon-ssi.tistory.com/83
render_with_liquid: false
---

Java 엑셀 업로드 기능을 구현하던 중 에러를 맞이하게 되었다.

**pacjage should contain a content type [M1.13]**

엑셀 형식이 다르거나 파일이 손상된 경우

파일이 보안이 걸려있을 때 발생하는 에러였다.

코드상에서 XSSFWorkbook을 사용하는데 엑셀파일의 확장자가 xls인 경우에 발생하기도 한다.

이럴 때에는 xlsx 확장자만 처리할 수 있으니 확장자를 변경해보자.

필자의 경우는 파일에 보안이 걸려있어서 해당 에러가 발생하였고, 잠금을 해제한 후 다시 시도해보니 정상적으로 기능하였다.

엑셀파일을 읽을 수 없는 경우에 발생하는 경우가 많으니 엑셀 업로드 기능을 구현할 때 확인해보자.
