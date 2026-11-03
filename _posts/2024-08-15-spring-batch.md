---
title: "[Spring] Batch를 사용한 배치 프로그램 구현"
date: 2024-08-15 13:32:52 +0900
categories: [Backend, Spring]
tags: []
tistory_url: https://yoon-ssi.tistory.com/20
render_with_liquid: false
---

이번에는 Spring Batch로 매일 새벽 2시에 데이터를 처리하는 배치 프로그램을 만들어보려고 한다.

MyBatis를 썼고, DB는 MySQL을 썼다.

---

### 1. 프로젝트 설정

pom.xml에 spring-boot-starter-batch, mybatis-spring-boot-starter, mysql-connector-java 의존성을 추가한다.

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

매퍼 파일과 매퍼 인터페이스를 만든다. 여기서는 OrderMapper.xml과 OrderMapper 인터페이스를 쓴다.

OrderMapper.xml

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

매퍼에서 쓸 모델 클래스를 만든다.

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

MyBatis를 쓰는 Job과 Step을 설정한다.

- Job: 배치 작업 하나를 뜻한다. Step 여러 개로 이뤄질 수 있고, 배치 작업 전체 흐름을 정의한다.
- Step: Job 안의 한 단계다. 데이터를 읽고, 처리하고, 쓰는 과정을 정의하고, Reader, Processor, Writer로 구성된다.

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

매일 새벽 2시에 배치가 돌도록 스케줄을 건다.

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

application.properties에 MySQL과 MyBatis 설정을 넣는다.

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

`@SpringBootApplication`이 붙은 메인 클래스를 실행하면 된다.

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
