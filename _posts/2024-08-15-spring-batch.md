---
title: "[Spring] Batch를 사용한 배치 프로그램 구현"
date: 2024-08-15 13:32:52 +0900
categories: ["Spring & SpringBoot"]
tags: []
tistory_url: https://yoon-ssi.tistory.com/20
render_with_liquid: false
---

이번 포스팅에서는 Spring Batch를 사용하여 매일 새벽 2시에 데이터를 처리하는 배치 프로그램을 구현하는 방법에 대해서 설명해보려고 한다.

MyBatis를 사용했고 DataBase는 MySql을 사용했다.

---

### 1. 프로젝트 설정

MyBatis와 MySQL을 사용하기 위해 spring-boot-starter-batch, mybatis-spring-boot-starter, mysql-connector-java 의존성을 pom.xml에 추가한다.

```html
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-batch</artifactId>
    </dependency>
    <dependency>
        <groupId>org.mybatis.spring.boot</groupId>
        <artifactId>mybatis-spring-boot-starter</artifactId>
        <version>2.2.0</version>
    </dependency>
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
    </dependency>
</dependencies>
```

---

### 2. MyBatis 설정

MyBatis에서 사용할 매퍼 파일과 매퍼 인터페이스를 작성한다.

예를 들어, OrderMapper.xml과 OrderMapper 인터페이스를 설정한다.

OrderMapper .xml

```html
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
  PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="com.example.batch.mapper.OrderMapper">
    <select id="selectOrders" resultType="com.example.batch.model.Order">
        SELECT order_id, order_status FROM orders WHERE order_status = 'NEW'
    </select>

    <update id="updateOrderStatus">
        UPDATE orders SET order_status = #{status} WHERE order_id = #{orderId}
    </update>
</mapper>
```

OrderMapper.java

```java
package com.example.batch.mapper;

import com.example.batch.model.Order;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface OrderMapper {
    List<Order> selectOrders();
    void updateOrderStatus(Long orderId, String status);
}
```

---

### 3. 모델 클래스 작성

MyBatis 매퍼에서 사용하는 모델 클래스를 작성한다.

```java
package com.example.batch.model;

@Getter
@Setter
public class Order {
    private Long orderId;
    private String orderStatus;
}
```

---

### 4. Batch Job 설정

Spring Batch에서 MyBatis를 사용하는 Job과 Step을 설정한다.

- **Job**: 하나의 배치 작업을 나타내며, 여러 개의 Step으로 구성될 수 있다. Job은 실행되는 전체 배치 작업의 흐름을 정의한다.
- **Step**: Job 내의 하나의 단계로, 데이터를 읽고, 처리하고, 쓰는 과정을 정의한다. 하나의 Step은 Reader, Processor, Writer로 구성된다.

```java
@Configuration
@EnableBatchProcessing
public class BatchConfig {

    @Autowired
    private JobBuilderFactory jobBuilderFactory;

    @Autowired
    private StepBuilderFactory stepBuilderFactory;

    @Autowired
    private OrderMapper orderMapper;

    @Bean
    public Job exampleJob() {
        return jobBuilderFactory.get("exampleJob") // Job의 이름 지정
                .start(exampleStep()) // 첫 번째 Step 지정
                .build(); // Job 빌드
    }

    @Bean
    public Step exampleStep() {
        return stepBuilderFactory.get("exampleStep") // Strp 이름 지정
                .<Order, Order>chunk(10) // Chunk 크기를 10으로 설정(10개의 아이템을 처리한 후 Writer에게 전달)
                .reader(reader()) // 데이터를 읽어올 Reader를 지정
                .processor(processor()) // 데이터를 처리할 Processor를 지정
                .writer(writer()) // 데이터를 쓸 Writer를 지정
                .build(); // Step을 빌드
    }

    @Bean
    public MyBatisCursorItemReader<Order> reader() {
        MyBatisCursorItemReader<Order> reader = new MyBatisCursorItemReader<>();
        reader.setQueryId("com.example.batch.mapper.OrderMapper.selectOrders"); // MyBatis 매퍼에서 사용할 쿼리 ID를 지정
        return reader;
    }

    @Bean
    public ItemProcessor<Order, Order> processor() {
        return order -> {
            order.setOrderStatus("PROCESSED"); // 읽어온 Order의 상태를 "PROCESSED"로 변경
            return order; // 처리된 데이터를 반환
        };
    }

    @Bean
    public ItemWriter<Order> writer() {
        return items -> items.forEach(order -> orderMapper.updateOrderStatus(order.getOrderId(), order.getOrderStatus())); 데이터베이스의 Order 상태를 업데이트
    }
}
```

---

### 5. 스케줄링 설정

스케줄링을 설정하여 매일 새벽 2시에 배치 작업이 실행되도록 설정한다.

```java
import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

@Configuration
@EnableScheduling
public class BatchScheduler {

    @Autowired
    private JobLauncher jobLauncher;

    @Autowired
    private Job exampleJob;

    @Scheduled(cron = "0 0 2 * * ?")
    public void runBatchJob() throws Exception {
        jobLauncher.run(
            exampleJob,
            new JobParametersBuilder()
                .addLong("time", System.currentTimeMillis())
                .toJobParameters()
        );
    }
}
```

---

### 6. 데이터베이스 설정

application.properties 파일에 MySQL 데이터베이스와 MyBatis 설정을 추가한다.

```html
spring.datasource.url=jdbc:mysql://localhost:3306/batchdb
spring.datasource.username=root
spring.datasource.password=yourpassword
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

mybatis.mapper-locations=classpath:mapper/*.xml
mybatis.configuration.map-underscore-to-camel-case=true

spring.batch.initialize-schema=always
```

---

### 7. 메인 애플리케이션 실행

@SpringBootApplication이 있는 메인 클래스를 실행한다.

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class BatchApplication {
    public static void main(String[] args) {
        SpringApplication.run(BatchApplication.class, args);
    }
}
```
