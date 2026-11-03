---
title: "SpringBoot 프로젝트에서 MyBatis 설정하기"
date: 2024-07-30 17:47:38 +0900
categories: [Backend, MyBatis]
tags: ["mybatis", "springboot", "xml", "설정"]
tistory_url: https://yoon-ssi.tistory.com/3
render_with_liquid: false
---

오늘은 SpringBoot 프로젝트에서 MyBatis 사용을 위해 필요한 것들에 대해 포스팅 하려고 한다.

간단하게 순서를 정리해보자

1. 프로젝트에 MyBatis 의존성 추가하기

2. MyBatis 설정

3. MyBatis Mapper 인터페이스 생성

4. XML 파일 생성

위의 순서대로 차근차근 따라가면 MyBatis를 사용할 수 있다.

**1. 프로젝트에 MyBatis 의존성 추가하기**

pom.xml (Maven) 또는 build.gradle (Gradle) 파일에 MyBatis 관련 의존성을 추가해보자.

ex) pom.xml (Maven)

```bash
<dependencies>
    <!-- Spring Boot Starter Web -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <!-- Spring Boot Starter Data MyBatis -->
    <dependency>
        <groupId>org.mybatis.spring.boot</groupId>
        <artifactId>mybatis-spring-boot-starter</artifactId>
        <version>3.0.2</version>
    </dependency>

    <!-- MyBatis SqlSessionFactory -->
    <dependency>
        <groupId>org.mybatis</groupId>
        <artifactId>mybatis</artifactId>
        <version>3.5.10</version>
    </dependency>

    <!-- Database (for example) -->
    <dependency>
        <groupId>com.h2database</groupId>
        <artifactId>h2</artifactId>
        <scope>runtime</scope>
    </dependency>
</dependencies>
```

ex) build.gradle (Gradle)

```bash
dependencies {
    // Spring Boot Starter Web
    implementation 'org.springframework.boot:spring-boot-starter-web'

    // Spring Boot Starter Data MyBatis
    implementation 'org.mybatis.spring.boot:mybatis-spring-boot-starter:3.0.3'

    // MyBatis SqlSessionFactory
    implementation 'org.mybatis:mybatis:3.5.10'

    // Database (for example)
    runtimeOnly 'org.mariadb.jdbc:mariadb-java-client'
}
```

이런식으로 의존성을 추가해준다.

**의존성이 추가되지 않으면 어플리케이션이 실행되지 않거나 'ClassNotFoundException', 'BeanCeationException' 등의**

**오류가 발생할 수 있으니 꼭 추가하도록 하자!!**

**2. MyBatis 설정**

이제 어플리케이션 설정 파일에서 MyBatis 설정을 추가해보자.

application.properties :

```bash
# DataSource Configuration
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.username=sa
spring.datasource.password=password
spring.datasource.driver-class-name=org.h2.Driver

# MyBatis Configuration
mybatis.mapper-locations=classpath:mapper/**/*.xml
mybatis.type-aliases-package=com.example.demo.model
```

application.yml :

```bash
spring:
  datasource:
    url: jdbc:mysql://localhost
    username: user
    password: password
    driver-class-name: com.mysql.cj.jdbc.Driver

mybatis:
  mapper-locations: classpath:mapper/**/*.xml
  type-aliases-package: com.example.demo.model
```

**설정파일에 Database 설정이나 MyBatis 설정을 빼먹으면 'ConfigurationException', 'NoSuchBeanDefinitionException' 등의** **오류가 발생할 수 있다!!**

**3. MyBatis Mapper 인터페이스 생성**

이제 데이터베이스와 어플리케이션의 상호작용을 매핑해주는 Mapper 인터페이스를 생성해보자.

```java
@Mapper
public interface UserDao {
    User findUser(String userId, String password);

    User findUserById(String userId);
}
```

**역할**: Mapper 인터페이스는 SQL 쿼리와 Java 메서드를 매핑한다. 각 메서드는 SQL 쿼리 또는 호출할 SQL 문을 정의하는 XML 파일의 SQL 구문과 연결된다.

**4. XML 파일 생성**

이제 실행 될 SQL문을 작성하는 XML 파일을 생성해보자!

일반적으로 XML 파일은 'src/main/resources/mapper/' 경로에 생성한다.

ex)

```sql
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="Mapper Interface 경로">

    <select id="findUserById" parameterType="String" resultType="쿼리 수행 후 결과 Type">
        SELECT * FROM TB_USER WHERE USER_ID = #{userId}
    </select>

    <select id="findUser" parameterType="Object" resultType="쿼리 수행 후 결과 Type">
        SELECT * FROM TB_USER WHERE USER_ID = #{userId} AND PASSWORD = #{password}
    </select>

</mapper>
```

**XML 파일 작성 후에는 Mapper 인터페이스와 XML 파일의 네임스페이스가 일치하는지 확인해야한다!!**

순서대로 잘 따라왔다면 SpringBoot 프로젝트에서 MyBatis를 사용할 수 있을 것이다.

![emoticon](/assets/img/posts/springboot-mybatis-setup/01.gif)
