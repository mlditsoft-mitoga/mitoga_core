# 🎓 MI-TOGA Backend - Plataforma de Tutorías en Línea

![Java](https://img.shields.io/badge/Java-21_LTS-orange?logo=openjdk)
![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.4.0-green?logo=springboot)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue?logo=postgresql)
![Redis](https://img.shields.io/badge/Redis-7-red?logo=redis)
![Gradle](https://img.shields.io/badge/Gradle-8.10-02303A?logo=gradle)

Backend del sistema MI-TOGA desarrollado con **Arquitectura Hexagonal (Ports & Adapters)**,**Monolito Modular** y **Domain-Driven Design (DDD)**.

---

## 📋 Tabla de Contenidos

- [Arquitectura](#-arquitectura)
- [Stack Tecnológico](#-stack-tecnológico)
- [Bounded Contexts](#-bounded-contexts)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Requisitos Previos](#-requisitos-previos)
- [Instalación y Ejecución](#-instalación-y-ejecución)
- [Configuración](#-configuración)
- [Documentación API](#-documentación-api)
- [Testing](#-testing)
- [Convenciones de Código](#-convenciones-de-código)

---

## 🏗️ Arquitectura

### Arquitectura Hexagonal (Ports & Adapters)

```
┌─────────────────────────────────────────────────────────────┐
│                     DRIVING SIDE (Input)                    │
│            REST Controllers, Message Listeners              │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      INPUT PORTS                            │
│                    (Use Cases)                              │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    HEXAGON CORE (Domain)                    │
│    Aggregates, Entities, Value Objects, Domain Events      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     OUTPUT PORTS                            │
│        (Repositories, External Services Interfaces)         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    DRIVEN SIDE (Output)                     │
│   JPA Adapters, HTTP Clients, Email, Stripe, Agora         │
└─────────────────────────────────────────────────────────────┘
```

### Reglas de Dependencia

✅ **Domain NO depende de NADA**  
✅ **Application depende SOLO de Domain**  
✅ **Infrastructure depende de Domain y Application**  
✅ **Flujo: INWARD ONLY** (desde afuera hacia el dominio)

---

## 🛠️ Stack Tecnológico

### Core
- **Java 21 LTS** (Records, Pattern Matching, Virtual Threads)
- **Spring Boot 3.4.0** (Web, Data JPA, Security, Actuator, Mail)
- **Gradle 8.10** con Kotlin DSL

### Base de Datos
- **PostgreSQL 16** (schemas por Bounded Context)
- **Flyway 10.17.0** (migraciones)
- **Hibernate/JPA** (ORM)

### Cache & Messaging
- **Redis 7** (cache, rate limiting)
- **Lettuce** (cliente Redis asíncrono)

### Seguridad
- **Spring Security 6** (JWT, BCrypt)
- **HashiCorp Vault** (gestión de secrets)
- **JJWT 0.12.6** (JSON Web Tokens)

### Documentación
- **SpringDoc OpenAPI 3** (Swagger UI)

### Testing
- **JUnit 5** (unit tests)
- **Testcontainers 1.19.8** (integration tests con PostgreSQL)
- **ArchUnit 1.3.0** (tests de arquitectura)

### Utilidades
- **MapStruct 1.5.5** (mapeo Entity↔DTO)
- ⚠️ **NO LOMBOK** en Domain Layer (rompe encapsulación DDD)

---

## 📦 Bounded Contexts

| BC                  | Estado | Descripción                                         | Puerto |
|---------------------|--------|-----------------------------------------------------|--------|
| **BC**              | **Estado** | **Funcionalidades**                                 | **Puerto** |
|---------------------|--------|-----------------------------------------------------|--------|
| **Autenticación** ✅✅ | 🟢 | COMPLETO: Domain, App, Infrastructure, Web + Security | 8082   |
| **Marketplace** 🔄   | 🟡 | Tutores, categorías, búsqueda                       | 8082   |
| **Perfiles** ⏳      | 🟡 | Información completa de estudiantes y tutores       | 8082   |
| **Reservas** ⏳      | ⚪ | Agendamiento de sesiones, confirmaciones            | 8082   |
| **Pagos** ⏳         | ⚪ | Integración Stripe, procesamiento de pagos          | 8082   |
| **Videollamadas** ⏳ | ⚪ | Integración Agora.io para sesiones en vivo          | 8082   |
| **Notificaciones** ⏳| ⚪ | Email, push, in-app notifications                   | 8082   |
| **Admin** ⏳         | ⚪ | Panel administrativo, reportes, estadísticas        | 8082   |

**Leyenda:** 🟢 Completo | 🟡 En progreso | ⚪ Pendiente

> **Nota:** Monolito modular en puerto 8082. Cada BC es independiente y podría extraerse como microservicio.

### BC Autenticación - Características Implementadas

✅ **Domain Layer (DDD puro, sin Lombok):**
- Usuario (Aggregate Root) con factory methods y validaciones
- Token (Entity) para refresh tokens con device tracking
- OAuthProvider (Entity) para vinculación con Google, Facebook, Microsoft, GitHub, Apple
- Repositories (Ports) para persistencia
- 5 excepciones de dominio específicas

✅ **Application Layer (Hexagonal):**
- 5 Use Cases (Input Ports): Registro, Login, RefreshToken, VerificarEmail, VincularOAuth
- 4 Output Ports: PasswordEncoder, JwtToken, Email, OAuthClient
- 5 Services que orquestan dominio e infraestructura
- 5 Commands (DTOs inmutables)
- 3 Response DTOs

✅ **Infrastructure Layer (COMPLETADO):**
- **Persistence:** 3 JPA Repositories + 3 Adapters (Usuario, Token, OAuthProvider)
- **Security:** JWT Token Provider (JJWT 0.12.x, HS512, access + refresh tokens)
- **Security:** BCrypt Password Adapter (strength 12, 4096 iterations)
- **Email:** Email Adapter con JavaMailSender (@Async, 5 HTML templates)
- **OAuth:** 5 OAuth Client Adapters (Google, Facebook, Microsoft, GitHub, Apple)

✅ **Web Layer (COMPLETADO):**
- **REST API:** AutenticacionController con 7 endpoints
  - POST /api/v1/auth/registro - Registrar usuario
  - POST /api/v1/auth/login - Login email/password
  - POST /api/v1/auth/refresh-token - Refrescar access token
  - POST /api/v1/auth/verificar-email - Verificar código 6 dígitos
  - POST /api/v1/auth/reenviar-codigo - Reenviar código verificación
  - POST /api/v1/auth/oauth/{provider}/login - Login con OAuth
  - POST /api/v1/auth/vincular-oauth - Vincular cuenta OAuth
- **DTOs:** 5 Request DTOs + 3 Response DTOs con validación Jakarta Validation
- **Exception Handler:** GlobalExceptionHandler (@RestControllerAdvice) para mapeo de excepciones
- **Security:** SecurityConfig con JWT Filter, CORS, endpoints públicos/protegidos
- **Security:** JwtAuthenticationFilter para autenticación basada en Bearer tokens

---

## 📂 Estructura del Proyecto

```
mitoga-backend/
├── src/
│   ├── main/
│   │   ├── java/com/mitoga/
│   │   │   ├── MitogaApplication.java          # Entry point
│   │   │   │
│   │   │   ├── shared/                          # Shared Kernel (DDD)
│   │   │   │   ├── domain/                      # Building blocks DDD
│   │   │   │   │   ├── valueobject/
│   │   │   │   │   │   ├── BaseEntity.java      # Entidad base con UUID y auditoría
│   │   │   │   │   │   ├── AggregateRoot.java   # Raíz de agregado
│   │   │   │   │   │   ├── ValueObject.java     # Value Object inmutable
│   │   │   │   │   │   └── DomainEvent.java     # Evento de dominio
│   │   │   │   │   └── exception/
│   │   │   │   │       └── DomainException.java # Excepción base de dominio
│   │   │   │   ├── application/                 # Ports compartidos
│   │   │   │   │   ├── UseCase.java             # Marker interface para Use Cases
│   │   │   │   │   ├── Command.java             # Marker interface para Commands
│   │   │   │   │   └── Query.java               # Marker interface para Queries
│   │   │   │   └── infrastructure/              # Config compartida
│   │   │   │       └── config/
│   │   │   │           ├── DatabaseConfig.java  # Configuración multi-schema PostgreSQL
│   │   │   │           ├── OpenApiConfig.java   # Swagger/OpenAPI documentation
│   │   │   │           ├── S3Config.java        # AWS S3 client configuration
│   │   │   │           ├── S3Properties.java    # S3 bucket properties
│   │   │   │           └── EmailProperties.java # SMTP email configuration
│   │   │   │
│   │   │   ├── autenticacion/                   # ✅ BC Autenticación (COMPLETO: Domain + Application)
│   │   │   │   ├── domain/
│   │   │   │   │   ├── model/                   # Entidades de dominio (SIN LOMBOK)
│   │   │   │   │   │   ├── Usuario.java         # Aggregate Root - Registro, login, verificación
│   │   │   │   │   │   ├── Token.java           # Entity - Refresh tokens con device tracking
│   │   │   │   │   │   └── OAuthProvider.java   # Entity - OAuth 2.0 providers (Google, Facebook, etc.)
│   │   │   │   │   ├── repository/              # Ports de persistencia
│   │   │   │   │   │   ├── UsuarioRepository.java
│   │   │   │   │   │   ├── TokenRepository.java
│   │   │   │   │   │   └── OAuthProviderRepository.java
│   │   │   │   │   └── exception/               # Excepciones de dominio
│   │   │   │   │       ├── AutenticacionException.java
│   │   │   │   │       ├── UsuarioYaExisteException.java
│   │   │   │   │       ├── CredencialesInvalidasException.java
│   │   │   │   │       ├── CuentaBloqueadaException.java
│   │   │   │   │       └── TokenInvalidoException.java
│   │   │   │   ├── application/
│   │   │   │   │   ├── command/                 # DTOs de entrada (Commands)
│   │   │   │   │   │   ├── RegistrarUsuarioCommand.java
│   │   │   │   │   │   ├── LoginCommand.java
│   │   │   │   │   │   ├── RefreshTokenCommand.java
│   │   │   │   │   │   ├── VerificarEmailCommand.java
│   │   │   │   │   │   └── VincularOAuthCommand.java
│   │   │   │   │   ├── port/
│   │   │   │   │   │   ├── input/               # Use Cases (Input Ports)
│   │   │   │   │   │   │   ├── RegistrarUsuarioUseCase.java
│   │   │   │   │   │   │   ├── LoginUseCase.java
│   │   │   │   │   │   │   ├── RefreshTokenUseCase.java
│   │   │   │   │   │   │   ├── VerificarEmailUseCase.java
│   │   │   │   │   │   │   ├── VincularOAuthUseCase.java
│   │   │   │   │   │   │   └── dto/             # Response DTOs
│   │   │   │   │   │   │       ├── AutenticacionResponse.java
│   │   │   │   │   │   │       ├── VerificacionResponse.java
│   │   │   │   │   │   │       └── VinculacionResponse.java
│   │   │   │   │   │   └── output/              # Output Ports (infraestructura)
│   │   │   │   │   │       ├── PasswordEncoderPort.java
│   │   │   │   │   │       ├── JwtTokenPort.java
│   │   │   │   │   │       ├── EmailPort.java
│   │   │   │   │   │       └── OAuthClientPort.java
│   │   │   │   │   └── service/                 # Implementación de Use Cases
│   │   │   │   │       ├── RegistrarUsuarioService.java
│   │   │   │   │       ├── LoginService.java
│   │   │   │   │       ├── RefreshTokenService.java
│   │   │   │   │       ├── VerificarEmailService.java
│   │   │   │   │       └── VincularOAuthService.java
│   │   │   │   └── infrastructure/              # ⏳ EN CONSTRUCCIÓN (FASE 1.5)
│   │   │   │       ├── persistence/
│   │   │   │       │   ├── adapter/             # Implementación de repositories
│   │   │   │       │   │   ├── UsuarioPersistenceAdapter.java
│   │   │   │       │   │   ├── TokenPersistenceAdapter.java
│   │   │   │       │   │   └── OAuthProviderPersistenceAdapter.java
│   │   │   │       │   └── jpa/
│   │   │   │       │       ├── UsuarioJpaRepository.java
│   │   │   │       │       ├── TokenJpaRepository.java
│   │   │   │       │       └── OAuthProviderJpaRepository.java
│   │   │   │       ├── security/                # Seguridad y OAuth
│   │   │   │       │   ├── JwtTokenProvider.java
│   │   │   │       │   ├── BCryptPasswordAdapter.java
│   │   │   │       │   ├── SecurityConfig.java
│   │   │   │       │   └── oauth/
│   │   │   │       │       ├── GoogleOAuthClient.java
│   │   │   │       │       ├── FacebookOAuthClient.java
│   │   │   │       │       ├── MicrosoftOAuthClient.java
│   │   │   │       │       ├── GitHubOAuthClient.java
│   │   │   │       │       └── AppleOAuthClient.java
│   │   │   │       ├── email/
│   │   │   │       │   └── EmailAdapter.java    # SMTP email sender
│   │   │   │       └── web/
│   │   │   │           ├── controller/
│   │   │   │           │   └── AutenticacionController.java
│   │   │   │           └── dto/
│   │   │   │               ├── RegistroRequest.java
│   │   │   │               ├── LoginRequest.java
│   │   │   │               └── VerificarEmailRequest.java
│   │   │   │
│   │   │   ├── marketplace/                     # 🔄 BC Marketplace (EN PROGRESO)
│   │   │   ├── perfiles/                        # ⏳ BC Perfiles (PENDIENTE)
│   │   │   ├── reservas/                        # ⏳ BC Reservas (PENDIENTE)
│   │   │   ├── pagos/                           # ⏳ BC Pagos (PENDIENTE)
│   │   │   ├── videollamadas/                   # ⏳ BC Videollamadas (PENDIENTE)
│   │   │   ├── notificaciones/                  # ⏳ BC Notificaciones (PENDIENTE)
│   │   │   └── admin/                           # ⏳ BC Admin (PENDIENTE)
│   │   │
│   │   └── resources/
│   │       ├── application.yml                  # Configuración única
│   │       └── db/migration/
│   │           └── V1__init_schema.sql          # Flyway migration
│   │
│   └── test/
│       └── java/com/mitoga/
│           └── architecture/
│               └── HexagonalArchitectureTest.java
│
├── build.gradle.kts                             # Dependencias Gradle
├── settings.gradle.kts
├── gradle.properties
├── Dockerfile
├── docker-compose.yml
└── README.md
```

---

## ✅ Requisitos Previos

- **Java 21 LTS** (Amazon Corretto o OpenJDK)
- **Gradle 8.10+** (o usar wrapper `./gradlew`)
- **PostgreSQL 16** (local o Docker)
- **Redis 7** (local o Docker)
- **HashiCorp Vault** (opcional para dev, requerido en prod)
- **Git**

---

## 🚀 Instalación y Ejecución

### 1. Clonar el repositorio

```bash
git clone https://github.com/mi-toga/backend.git
cd mitoga-backend
```

### 2. Configurar base de datos (PostgreSQL)

**Opción A: Docker Compose (recomendado para desarrollo)**

```bash
docker-compose up -d postgres redis
```

**Opción B: PostgreSQL local**

```sql
CREATE DATABASE mitogadb;
CREATE USER admin WITH ENCRYPTED PASSWORD 'admin';
GRANT ALL PRIVILEGES ON DATABASE mitogadb TO admin;
```

### 3. Configurar HashiCorp Vault (Opcional en dev)

**Para desarrollo, puedes desactivar Vault:**

```bash
# Editar src/main/resources/application.yml
spring:
  cloud:
    vault:
      enabled: false  # Cambiar a false

# Luego descomentar y configurar datasource directamente:
  datasource:
    url: jdbc:postgresql://localhost:5432/mitogadb
    username: admin
    password: admin
```

### 4. Ejecutar migraciones Flyway

```bash
./gradlew flywayMigrate
```

### 5. Ejecutar aplicación

```bash
./gradlew bootRun
```

O desde tu IDE (IntelliJ IDEA / Eclipse / VS Code):
- Run → `MitogaApplication.java`

### 6. Verificar funcionamiento

- **Health Check:** http://localhost:8082/api/v1/actuator/health
- **Swagger UI:** http://localhost:8082/api/v1/swagger-ui.html
- **API Docs JSON:** http://localhost:8082/api/v1/api-docs

---

## ⚙️ Configuración

### Variables de entorno (alternativa a Vault)

```bash
# Database
export DB_URL=jdbc:postgresql://localhost:5432/mitogadb
export DB_USERNAME=admin
export DB_PASSWORD=admin

# Redis
export REDIS_HOST=localhost
export REDIS_PORT=6379
export REDIS_PASSWORD=admin

# JWT
export JWT_SECRET=your-256-bit-secret-key-here
export JWT_EXPIRATION_MINUTES=480

# Email (Gmail SMTP)
export MAIL_HOST=smtp.gmail.com
export MAIL_PORT=587
export MAIL_USERNAME=noreply.mitoga@gmail.com
export MAIL_PASSWORD=your-app-password
```

### Perfiles de Spring Boot

```bash
# Development (verbose logging, H2 console, etc.)
./gradlew bootRun --args='--spring.profiles.active=dev'

# Production (optimized, security hardened)
./gradlew bootRun --args='--spring.profiles.active=prod'
```

---

## 📖 Documentación API

### Swagger UI (Interfaz interactiva)

Una vez ejecutada la aplicación, accede a:

👉 **http://localhost:8082/api/v1/swagger-ui.html**

Aquí puedes:
- ✅ Ver todos los endpoints disponibles
- ✅ Probar requests directamente desde el navegador
- ✅ Ver esquemas de DTOs (Request/Response)
- ✅ Autenticarte con JWT para probar endpoints protegidos

### Obtener JWT para pruebas

```bash
# 1. Registrar usuario (POST /api/v1/auth/registro)
curl -X POST http://localhost:8082/api/v1/auth/registro \
  -H "Content-Type: application/json" \
  -d '{
    "email": "estudiante@test.com",
    "password": "Test123!",
    "nombre": "Juan",
    "apellido": "Pérez",
    "rol": "ESTUDIANTE"
  }'

# 2. Login (POST /api/v1/auth/login)
curl -X POST http://localhost:8082/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "estudiante@test.com",
    "password": "Test123!"
  }'

# Respuesta:
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "...",
  "expiresIn": 480
}

# 3. Usar token en requests protegidos
curl -X GET http://localhost:8082/api/v1/perfiles/mi-perfil \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

---

## 🧪 Testing

### Tests Unitarios (Domain + Application)

```bash
./gradlew test
```

### Tests de Integración (con Testcontainers)

```bash
./gradlew integrationTest
```

### Tests de Arquitectura (ArchUnit)

```bash
./gradlew architectureTest
```

Valida que:
- ✅ Domain no depende de Infrastructure
- ✅ Application depende solo de Domain
- ✅ Nomenclatura de packages correcta
- ✅ Aggregates están en `domain/model`
- ✅ Use Cases en `application/usecase`

### Coverage Report

```bash
./gradlew jacocoTestReport
open build/reports/jacoco/test/html/index.html
```

---

## 📏 Convenciones de Código

### Nomenclatura

| Tipo                  | Convención                              | Ejemplo                          |
|-----------------------|-----------------------------------------|----------------------------------|
| **Aggregate Root**    | Sustantivo singular                     | `Usuario`, `Reserva`, `Pago`     |
| **Value Object**      | Sustantivo descriptivo                  | `Email`, `Monto`, `FechaHora`    |
| **Domain Event**      | Pasado perfecto                         | `UsuarioRegistrado`, `ReservaConfirmada` |
| **Use Case (Port)**   | Verbo infinitivo + `UseCase`            | `RegistrarUsuarioUseCase`        |
| **Service (Impl)**    | Verbo infinitivo + `Service`            | `RegistrarUsuarioService`        |
| **Repository (Port)** | Entidad + `Repository`                  | `UsuarioRepository`              |
| **Adapter (Impl)**    | Entidad + tipo + `Adapter`              | `UsuarioPersistenceAdapter`      |
| **Controller**        | BC + `Controller`                       | `AutenticacionController`        |
| **Command**           | Verbo imperativo + `Command`            | `RegistrarUsuarioCommand`        |
| **Query**             | Verbo búsqueda + `Query`                | `BuscarTutoresQuery`             |
| **DTO Response**      | Entidad + `Response`                    | `UsuarioResponse`                |
| **Exception**         | Concepto + `Exception`                  | `EmailInvalidoException`         |

### Principios SOLID

- **S**ingle Responsibility: Una clase, una responsabilidad
- **O**pen/Closed: Abierto extensión, cerrado modificación
- **L**iskov Substitution: Subtipos deben ser sustituibles por sus tipos base
- **I**nterface Segregation: Interfaces pequeñas y específicas
- **D**ependency Inversion: Depender de abstracciones, no de concreciones

### Clean Code

- ✅ Métodos pequeños (< 20 líneas)
- ✅ Nombres autoexplicativos (no comentarios obvios)
- ✅ Evitar `null` (usar `Optional<T>`)
- ✅ Inmutabilidad por defecto (Records, `final`)
- ✅ Fail Fast (validar pronto, lanzar excepciones)
- ✅ No usar setters en Domain (métodos de negocio)

---

## 🤝 Contribución

1. Fork del proyecto
2. Crear feature branch (`git checkout -b feature/nueva-funcionalidad`)
3. Commit con mensaje descriptivo (`git commit -m 'feat: agregar búsqueda avanzada de tutores'`)
4. Push al branch (`git push origin feature/nueva-funcionalidad`)
5. Crear Pull Request

### Commits Convencionales

- `feat:` Nueva funcionalidad
- `fix:` Corrección de bug
- `refactor:` Refactorización sin cambio funcional
- `test:` Agregar o corregir tests
- `docs:` Actualizar documentación
- `chore:` Tareas de mantenimiento

---

## 📄 Licencia

MIT License - Ver [LICENSE](LICENSE) para detalles.

---

## 👥 Equipo de Desarrollo

**MI-TOGA Development Team**  
📧 dev@mitoga.com  
🌐 https://mitoga.com

---

## 🙏 Agradecimientos

- **Eric Evans** por Domain-Driven Design
- **Alistair Cockburn** por Hexagonal Architecture
- **Robert C. Martin** por Clean Code y SOLID
- **Martin Fowler** por Patterns of Enterprise Application Architecture
- **Spring Team** por el excelente framework

---

**¡Feliz Coding! 🚀**
