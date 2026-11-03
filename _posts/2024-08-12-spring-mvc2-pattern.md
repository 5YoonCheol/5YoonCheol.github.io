---
title: "[Spring] MVC2 패턴이란?"
date: 2024-08-12 11:23:46 +0900
categories: ["Spring & SpringBoot"]
tags: ["controller", "model", "mvc", "mvc패턴", "spring", "view", "모델", "뷰", "컨트롤러", "프레임워크"]
tistory_url: https://yoon-ssi.tistory.com/18
render_with_liquid: false
---

### **MVC2 패턴?**

MVC2(Model-View-Controller Version 2) 패턴은 Java EE (Enterprise Edition) 환경에서 더 발전된 형태의 MVC 패턴으로, 더 큰 애플리케이션을 효과적으로 관리하기 위해 사용한다.

전통적인 MVC 패턴과 마찬가지로 Model, View, Controller로 나누어지지만, 추가적인 컴포넌트와 아키텍처를 포함하여 확장성과 유지보수성을 더욱 향상시킨다.

View는 프론트 프레임워크인 Vue, Angular, React 등을 활용하여 구성하는 경우가 많으니 참고하자.

---

### **구성요소**

- **Model**: 서버 측에서 데이터를 관리하고 처리한다.   
  데이터베이스와의 상호작용, 비즈니스 로직 등을 포함한다.   
  Java에서는 주로 Spring Framework를 사용하여 Model을 구성한다.
- **View**: 프론트엔드 프레임워크를 사용하여 사용자 인터페이스를 구성한다.   
  Vue.js, React.js, Angular 등이 주로 사용된다.
- **Controller**: 서버 측에서 클라이언트의 요청을 처리하고, Model과 View를 연결한다.   
  Spring MVC의 Controller가 이 역할을 수행한다.
- **API 통신**: 프론트엔드와 백엔드 간의 데이터 통신을 위해 RESTful API 또는 GraphQL 등을 사용한다.

---

**예시) Backend (Spring Boot)**

```java
// Model
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String email;
    // getters and setters
}

// Repository
@Repository
public interface UserRepository extends JpaRepository<User, Long> {}

// Service
@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
}

// Controller
@RestController
@RequestMapping("/api/users")
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping
    public List<User> getUsers() {
        return userService.getAllUsers();
    }
}
```

**예시) Frontend (Vue.js)**

```html
<!-- index.html -->
<!DOCTYPE html>
<html>
<head>
    <title>Vue.js와 Spring Boot</title>
    <script src="https://cdn.jsdelivr.net/npm/vue@2"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
</head>
<body>
    <div id="app">
        <h1>사용자 목록</h1>
        <ul>
            <li v-for="user in users" :key="user.id">{{ user.name }} - {{ user.email }}</li>
        </ul>
    </div>

    <script>
        new Vue({
            el: '#app',
            data: {
                users: []
            },
            created() {
                axios.get('/api/users')
                    .then(response => {
                        this.users = response.data;
                    })
                    .catch(error => {
                        console.error(error);
                    });
            }
        });
    </script>
</body>
</html>
```

이 예제에서 Spring Boot는 백엔드로서 데이터베이스와 상호작용하고 API를 통해 데이터를 제공한다.

Vue.js는 프론트엔드로서 사용자 인터페이스를 구성하고, Axios를 사용하여 백엔드 API로부터 데이터를 가져와 화면에 표시한다.

---

### **결론**

요새는 프론트엔드와 백엔드가 나눠지고 점점 세분화되고 있기 때문에 개발자들의 역할도 많이 구분되어 있다.

MVC2 패턴에서 프론트엔드 프레임워크를 사용하는 것은 현대 웹 애플리케이션 개발에서 많은 이점을 제공하지만, 그만큼 고려해야 할 단점도 존재한다.

#### **장점**

1. **유지보수성**: 프론트엔드와 백엔드를 명확히 분리하여 각각 독립적으로 개발 및 유지보수가 가능하다.
2. **재사용성**: 프론트엔드와 백엔드 컴포넌트를 독립적으로 재사용할 수 있다.
3. **유연성**: 다양한 프론트엔드 프레임워크와 백엔드 기술을 조합하여 사용할 수 있다.

#### **단점**

1. **복잡성 증가**: 프론트엔드와 백엔드가 분리되어 있기 때문에 두 부분을 모두 이해하고 관리해야 한다. 이는 특히 작은 팀이나 단일 개발자에게 부담이 될 수 있다.
2. **초기 설정 및 구성**: 프론트엔드와 백엔드를 각각 설정하고 구성하는 데 많은 시간이 소요될 수 있다. 두 개의 서로 다른 개발 환경을 설정하고 유지보수하는 데 필요한 지식과 노력이 필요하다.
3. **통합 문제**: 프론트엔드와 백엔드 간의 통신에서 문제가 발생할 수 있다. 예를 들어, API 호출 시 네트워크 지연이나 데이터 불일치 문제가 발생할 수 있으며, 이를 해결하기 위해 추가적인 디버깅과 테스트가 필요하다.
4. **데이터 일관성 문제**: 프론트엔드와 백엔드 간의 상태 관리가 어려울 수 있다. 특히 실시간 데이터 동기화가 필요한 경우, 두 시스템 간의 데이터 일관성을 유지하는 데 어려움이 있을 수 있다.
5. **학습 곡선**: 프론트엔드 프레임워크(Vue.js, React.js, Angular 등)와 백엔드 프레임워크(Spring Boot 등)를 모두 학습해야 하므로, 초보자에게는 학습 곡선이 가파를 수 있다.
6. **성능 문제**: 프론트엔드와 백엔드가 분리되어 있는 경우, API 호출로 인한 추가적인 네트워크 오버헤드가 발생할 수 있다. 이는 특히 대규모 애플리케이션에서 성능 문제로 이어질 수 있다.

이러한 장점과 단점을 잘 이해하고 적절한 방식을 택하는 것이 중요하다. 프로젝트의 규모, 팀의 역량, 요구사항 등을 종합적으로 고려하여 최적의 아키텍처를 선택하는 것이 좋다.
