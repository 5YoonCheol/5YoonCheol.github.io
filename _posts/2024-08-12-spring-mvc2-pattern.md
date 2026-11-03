---
title: "[Spring] MVC2 패턴이란?"
date: 2024-08-12 11:23:46 +0900
categories: [Backend, Spring]
tags: ["controller", "model", "mvc", "mvc패턴", "spring", "view", "모델", "뷰", "컨트롤러", "프레임워크"]
tistory_url: https://yoon-ssi.tistory.com/18
render_with_liquid: false
---

### MVC2 패턴?

MVC2(Model-View-Controller Version 2) 패턴은 Java EE(Enterprise Edition) 환경에서 쓰는, MVC 패턴을 좀 더 발전시킨 형태다. 규모가 큰 애플리케이션을 관리하기 쉽게 하려고 쓴다.

기존 MVC처럼 Model, View, Controller로 나누는 건 같지만, 구성 요소와 구조를 더해서 확장성과 유지보수성을 높였다.

요즘은 View를 Vue, Angular, React 같은 프론트 프레임워크로 구성하는 경우가 많으니 참고하자.

---

### 구성요소

- Model: 서버에서 데이터를 관리하고 처리한다. DB와 주고받는 부분과 비즈니스 로직이 여기 들어간다. Java에서는 주로 Spring Framework로 구성한다.
- View: 프론트엔드 프레임워크로 화면을 구성한다. Vue.js, React.js, Angular 등을 많이 쓴다.
- Controller: 서버에서 클라이언트 요청을 받아 처리하고 Model과 View를 이어준다. Spring MVC의 Controller가 이 역할이다.
- API 통신: 프론트엔드와 백엔드는 RESTful API나 GraphQL 등으로 데이터를 주고받는다.

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

이 예제에서 Spring Boot는 백엔드로서 DB와 주고받고 API로 데이터를 내준다.

Vue.js는 프론트엔드로서 화면을 그리고, Axios로 백엔드 API에서 데이터를 받아와 보여준다.

---

### 정리

요새는 프론트엔드와 백엔드가 나눠지고 점점 세분화되고 있기 때문에 개발자들의 역할도 많이 구분되어 있다.

MVC2 패턴에 프론트엔드 프레임워크를 붙이면 얻는 게 많지만, 그만큼 감수해야 할 것도 있다.

#### 장점

1. 유지보수: 프론트엔드와 백엔드가 확실히 나뉘어서 각자 따로 개발하고 고칠 수 있다.
2. 재사용: 프론트엔드와 백엔드 컴포넌트를 각각 따로 재사용할 수 있다.
3. 유연성: 여러 프론트엔드 프레임워크와 백엔드 기술을 골라서 조합할 수 있다.

#### 단점

1. 복잡해진다: 프론트와 백이 나뉘어 있으니 둘 다 이해하고 관리해야 한다. 작은 팀이나 혼자 개발하는 경우엔 부담이 될 수 있다.
2. 초기 설정: 개발 환경을 두 개 따로 설정하고 유지해야 해서 처음 세팅에 시간이 꽤 든다.
3. 연동 문제: API 호출 시 네트워크 지연이나 데이터 불일치 같은 문제가 생길 수 있고, 이걸 잡으려면 디버깅과 테스트가 더 필요하다.
4. 상태 관리: 프론트와 백 사이 상태를 맞추기 어렵다. 실시간으로 데이터를 동기화해야 한다면 더 그렇다.
5. 배울 게 많다: 프론트엔드 프레임워크(Vue.js, React.js, Angular 등)와 백엔드 프레임워크(Spring Boot 등)를 둘 다 배워야 해서 처음엔 진입 장벽이 높다.
6. 성능: API 호출이 늘어나는 만큼 네트워크 오버헤드가 생기고, 큰 애플리케이션에서는 성능 문제로 이어질 수 있다.

결국 장단점을 잘 따져보고, 프로젝트 규모나 팀 상황, 요구사항에 맞는 구조를 고르는 게 중요하다.
