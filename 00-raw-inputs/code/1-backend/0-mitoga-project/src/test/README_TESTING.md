# 🧪 SUITE DE TESTS - MI-TOGA BACKEND

## 📋 Estructura de Tests

```
src/test/java/com/mitoga/
├── MitogaApplicationTests.java              # ✅ Test básico de contexto Spring
│
├── autenticacion/                            # BC Autenticación
│   ├── domain/
│   │   ├── model/
│   │   │   ├── UsuarioTest.java             # Unit tests del Aggregate Usuario
│   │   │   └── TokenTest.java               # Unit tests del Aggregate Token
│   │   └── service/
│   │       └── PasswordServiceTest.java     # Unit tests de Domain Services
│   ├── application/
│   │   └── usecase/
│   │       ├── RegistrarUsuarioUseCaseTest.java
│   │       ├── LoginUseCaseTest.java
│   │       └── RefreshTokenUseCaseTest.java
│   └── infrastructure/
│       ├── adapter/
│       │   ├── JwtTokenProviderTest.java
│       │   └── EmailAdapterTest.java
│       └── controller/
│           └── AutenticacionControllerTest.java
│
├── shared/                                   # BC Shared (Catálogos)
│   ├── domain/
│   │   └── catalogo/
│   │       └── CatalogoTest.java
│   └── application/
│       └── usecase/
│           └── ObtenerArbolCatalogoUseCaseTest.java
│
└── integration/                              # Integration Tests
    ├── AutenticacionIntegrationTest.java
    └── CatalogosIntegrationTest.java
```

## 🎯 Estrategia de Testing

### 1️⃣ **Unit Tests (Capa Domain)**
- **Objetivo**: Validar lógica de negocio en Aggregates y Value Objects
- **Framework**: JUnit 5 + AssertJ
- **Mocks**: Mockito para dependencias
- **Coverage Target**: >90%

**Ejemplo**:
```java
@Test
void debeCrearUsuarioConEmailYPasswordValidos() {
    // Given
    var email = "test@mitoga.com";
    var password = "SecurePass123!";
    var rol = RolUsuario.ESTUDIANTE;
    
    // When
    var usuario = Usuario.crear(email, password, rol);
    
    // Then
    assertThat(usuario.getEmail()).isEqualTo(email);
    assertThat(usuario.getRol()).isEqualTo(rol);
    assertThat(usuario.isEmailVerificado()).isFalse();
}
```

### 2️⃣ **Application Tests (Use Cases)**
- **Objetivo**: Validar orquestación de casos de uso
- **Patrón**: Arrange-Act-Assert (AAA)
- **Mocks**: Todos los ports (repositories, external services)
- **Coverage Target**: >85%

**Ejemplo**:
```java
@Test
void debeRegistrarUsuarioConExito() {
    // Arrange
    var command = new RegistrarUsuarioCommand(
        "test@mitoga.com", "Pass123!", "Juan", "Pérez", RolUsuario.ESTUDIANTE
    );
    when(usuarioRepository.existeEmail(any())).thenReturn(false);
    when(passwordEncoder.encode(any())).thenReturn("hashedPass");
    
    // Act
    var result = registrarUsuarioUseCase.handle(command);
    
    // Assert
    assertThat(result).isNotNull();
    verify(usuarioRepository).guardar(any(Usuario.class));
    verify(emailService).enviarCodigoVerificacion(any(), any());
}
```

### 3️⃣ **Integration Tests**
- **Objetivo**: Validar flujos end-to-end con BD real
- **Framework**: @SpringBootTest + Testcontainers
- **BD**: PostgreSQL en Docker
- **Coverage Target**: >75%

**Ejemplo**:
```java
@SpringBootTest
@Testcontainers
class AutenticacionIntegrationTest {
    
    @Container
    static PostgreSQLContainer<?> postgres = 
        new PostgreSQLContainer<>("postgres:16-alpine");
    
    @Test
    void debeRegistrarYAutenticarUsuario() {
        // Given: Registro
        var registroRequest = new RegistroRequest(...);
        var registroResponse = autenticacionController.registrar(registroRequest);
        
        // When: Login
        var loginRequest = new LoginRequest(...);
        var loginResponse = autenticacionController.login(loginRequest);
        
        // Then
        assertThat(loginResponse.getAccessToken()).isNotBlank();
    }
}
```

### 4️⃣ **Controller Tests (REST API)**
- **Objetivo**: Validar contratos de API (request/response)
- **Framework**: MockMvc + @WebMvcTest
- **Mocks**: Use Cases
- **Coverage Target**: >80%

## 🚀 Comandos de Ejecución

### Ejecutar todos los tests
```powershell
.\gradlew.bat test --no-daemon
```

### Ejecutar tests de un BC específico
```powershell
.\gradlew.bat test --no-daemon --tests "com.mitoga.autenticacion.*"
```

### Ejecutar solo unit tests (excluir integration)
```powershell
.\gradlew.bat test --no-daemon --tests "*Test" --exclude-tags "integration"
```

### Ejecutar con coverage report
```powershell
.\gradlew.bat test jacocoTestReport --no-daemon
# Reporte en: build/reports/jacoco/test/html/index.html
```

## 📊 Quality Gates

| Métrica | Target | Crítico |
|---------|--------|---------|
| **Unit Test Coverage** | >90% | >80% |
| **Application Test Coverage** | >85% | >75% |
| **Integration Test Coverage** | >75% | >65% |
| **Overall Coverage** | >85% | >75% |
| **Test Success Rate** | 100% | 100% |

## 🔧 Configuración

### Dependencias de Testing (build.gradle)
```gradle
dependencies {
    // JUnit 5
    testImplementation 'org.junit.jupiter:junit-jupiter'
    
    // Mockito
    testImplementation 'org.mockito:mockito-core'
    testImplementation 'org.mockito:mockito-junit-jupiter'
    
    // AssertJ
    testImplementation 'org.assertj:assertj-core'
    
    // Spring Boot Test
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
    
    // Testcontainers
    testImplementation 'org.testcontainers:testcontainers'
    testImplementation 'org.testcontainers:postgresql'
    testImplementation 'org.testcontainers:junit-jupiter'
}
```

## 📝 Convenciones

### Nomenclatura
- **Unit Tests**: `[ClassName]Test.java`
- **Integration Tests**: `[Feature]IntegrationTest.java`
- **Test Methods**: `debe[Accion][Condicion]()` (español)
  - Ejemplo: `debeCrearUsuarioConEmailValido()`
  - Ejemplo: `debeLanzarExcepcionCuandoEmailDuplicado()`

### Estructura Given-When-Then
```java
@Test
void debeHacerAlgo() {
    // Given (Arrange)
    // ... preparar datos y mocks
    
    // When (Act)
    // ... ejecutar acción
    
    // Then (Assert)
    // ... verificar resultado
}
```

## 🏗️ Roadmap de Implementación

### Fase 1: Tests Básicos (ACTUAL) ✅
- [x] Test de contexto Spring
- [x] Estructura de carpetas
- [x] README de testing

### Fase 2: Domain Tests 🔄
- [ ] UsuarioTest
- [ ] TokenTest
- [ ] Value Objects (Email, Password, etc.)

### Fase 3: Application Tests
- [ ] RegistrarUsuarioUseCaseTest
- [ ] LoginUseCaseTest
- [ ] RefreshTokenUseCaseTest

### Fase 4: Integration Tests
- [ ] Configurar Testcontainers
- [ ] AutenticacionIntegrationTest
- [ ] CatalogosIntegrationTest

### Fase 5: Controller Tests
- [ ] AutenticacionControllerTest
- [ ] CatalogosControllerTest

## 📚 Referencias
- [JUnit 5 User Guide](https://junit.org/junit5/docs/current/user-guide/)
- [Testcontainers](https://testcontainers.com/)
- [AssertJ](https://assertj.github.io/doc/)
- [Spring Boot Testing](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.testing)

---

**Versión**: 1.0.0  
**Última Actualización**: 2025-11-15  
**Autor**: Backend Team - MI-TOGA
