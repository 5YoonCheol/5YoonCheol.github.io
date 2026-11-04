---
title: "[Spring] Batch를 사용한 배치 프로그램 구현"
date: 2024-08-15 02:00:00 +0900
categories: [Backend, Spring]
tags: ["spring-batch", "mybatis", "스케줄링"]
description: Spring Boot 3 / Spring Batch 5 기준으로 MyBatis Reader·Processor·Writer를 묶은 Job을 만들고 스케줄러로 매일 새벽 2시에 실행하는 과정을 정리한다.
tistory_url: https://yoon-ssi.tistory.com/20
render_with_liquid: false
---

> 2026년 11월에 Spring Boot 3.x / Spring Batch 5 기준으로 고쳤다. 처음 쓸 때 썼던 `JobBuilderFactory`, `StepBuilderFactory`는 Spring Batch 5에서 deprecated 되고 5.2에서 제거됐다. 지금은 `JobBuilder`, `StepBuilder`에 `JobRepository`와 `PlatformTransactionManager`를 직접 넘긴다.
{: .prompt-info }

이번에는 Spring Batch로 매일 새벽 2시에 데이터를 처리하는 배치 프로그램을 만들어보려고 한다.

MyBatis를 썼고, DB는 MySQL을 썼다. Spring Boot 3.x(Java 17 이상)를 기준으로 한다.

---

### 1. 프로젝트 설정

pom.xml에 spring-boot-starter-batch, mybatis-spring-boot-starter, mysql-connector-j 의존성을 추가한다. MyBatis 스타터는 Spring Boot 3에서는 3.0.x 이상을 써야 하고, MySQL 드라이버 artifactId는 `mysql-connector-java`에서 `mysql-connector-j`로 바뀌었다(버전은 Boot가 관리하므로 적지 않는다).

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-batch</artifactId>
    </dependency>
    <dependency>
        <groupId>org.mybatis.spring.boot</groupId>
        <artifactId>mybatis-spring-boot-starter</artifactId>
        <version>3.0.4</version>
    </dependency>
    <dependency>
        <groupId>com.mysql</groupId>
        <artifactId>mysql-connector-j</artifactId>
        <scope>runtime</scope>
    </dependency>
</dependencies>
```

---

### 2. MyBatis 설정

매퍼 파일과 매퍼 인터페이스를 만든다. 여기서는 OrderMapper.xml과 OrderMapper 인터페이스를 쓴다.

OrderMapper.xml

```xml
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

Spring Boot 3에서는 `@EnableBatchProcessing`을 붙이지 않는다. 붙이면 Boot의 배치 자동 설정이 꺼져서 `JobRepository` 같은 빈을 직접 만들어야 한다. 대신 Boot가 만들어 준 `JobRepository`와 `PlatformTransactionManager`를 생성자로 받아 `JobBuilder`, `StepBuilder`에 넘긴다.

```java
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.batch.MyBatisCursorItemReader;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.job.builder.JobBuilder;
import org.springframework.batch.core.repository.JobRepository;
import org.springframework.batch.core.step.builder.StepBuilder;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.batch.item.ItemWriter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.PlatformTransactionManager;

@Configuration
public class BatchConfig {

    private final JobRepository jobRepository;
    private final PlatformTransactionManager transactionManager;
    private final SqlSessionFactory sqlSessionFactory;
    private final OrderMapper orderMapper;

    public BatchConfig(JobRepository jobRepository,
                       PlatformTransactionManager transactionManager,
                       SqlSessionFactory sqlSessionFactory,
                       OrderMapper orderMapper) {
        this.jobRepository = jobRepository;
        this.transactionManager = transactionManager;
        this.sqlSessionFactory = sqlSessionFactory;
        this.orderMapper = orderMapper;
    }

    @Bean
    public Job exampleJob(Step exampleStep) {
        return new JobBuilder("exampleJob", jobRepository) // Job 이름과 JobRepository 지정
                .start(exampleStep) // 첫 번째 Step 지정
                .build();
    }

    @Bean
    public Step exampleStep() {
        return new StepBuilder("exampleStep", jobRepository) // Step 이름과 JobRepository 지정
                .<Order, Order>chunk(10, transactionManager) // 10건씩 묶어 한 트랜잭션으로 처리
                .reader(reader())
                .processor(processor())
                .writer(writer())
                .build();
    }

    @Bean
    public MyBatisCursorItemReader<Order> reader() {
        MyBatisCursorItemReader<Order> reader = new MyBatisCursorItemReader<>();
        reader.setSqlSessionFactory(sqlSessionFactory); // 없으면 실행 시 NPE가 난다
        reader.setQueryId("com.example.batch.mapper.OrderMapper.selectOrders"); // 매퍼 namespace + id
        return reader;
    }

    @Bean
    public ItemProcessor<Order, Order> processor() {
        return order -> {
            order.setOrderStatus("PROCESSED"); // 읽어온 Order의 상태를 "PROCESSED"로 변경
            return order;
        };
    }

    @Bean
    public ItemWriter<Order> writer() {
        // Spring Batch 5부터 Writer는 List 대신 Chunk<? extends Order>를 받는다. Iterable이라 forEach는 그대로 쓸 수 있다
        return chunk -> chunk.forEach(order ->
                orderMapper.updateOrderStatus(order.getOrderId(), order.getOrderStatus()));
    }
}
```

`chunk(10, transactionManager)`처럼 트랜잭션 매니저를 Step마다 넘기는 게 Batch 5의 큰 변화다. 데이터소스가 여러 개면 어느 트랜잭션으로 묶을지 Step에서 바로 보이게 된다.

---

### 5. 스케줄링 설정

매일 새벽 2시에 배치가 돌도록 스케줄을 건다. `JobParameters`에 매번 다른 값을 넣는 이유는, 같은 파라미터로 이미 성공한 Job은 Spring Batch가 다시 실행하지 않기 때문이다.

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

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/batchdb
spring.datasource.username=root
spring.datasource.password=yourpassword
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

mybatis.mapper-locations=classpath:mapper/*.xml
mybatis.configuration.map-underscore-to-camel-case=true

# Batch 메타 테이블(BATCH_JOB_INSTANCE 등) 자동 생성. Boot 2.5부터 키 이름에 jdbc가 들어갔다
spring.batch.jdbc.initialize-schema=always
# 애플리케이션이 뜰 때 Job을 자동 실행하지 않는다. 스케줄러로만 실행한다
spring.batch.job.enabled=false
```

`spring.batch.job.enabled`를 끄지 않으면 Boot가 기동 직후 등록된 Job을 한 번 실행한다. 스케줄러와 겹쳐서 새벽 2시 말고도 배포할 때마다 돌아가는 일이 생기니 꼭 꺼 둔다.

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
