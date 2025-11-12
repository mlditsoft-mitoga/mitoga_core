# 🎓 MI-TOGA Backend - Plataforma de Tutorías en Línea

![Java](https://img.shields.io/badge/Java-21_LTS-orange?logo=openjdk)
![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.4.0-green?logo=springboot)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue?logo=postgresql)
![Redis](https://img.shields.io/badge/Redis-7-red?logo=redis)
![Gradle](https://img.shields.io/badge/Gradle-8.10-02303A?logo=gradle)

Backend del sistema MI-TOGA desarrollado con **Arquitectura Hexagonal (Ports & Adapters)** y **Domain-Driven Design (DDD)**.

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
- **Lombok 1.18.34** (reducción de boilerplate)
- **MapStruct 1.5.5** (mapeo Entity↔DTO)

---

## 📦 Bounded Contexts

| BC                  | Descripción                                         | Puerto |
|---------------------|-----------------------------------------------------|--------|
| **Autenticación**   | Registro, login, JWT, gestión de usuarios          | 8082   |
| **Marketplace**     | Tutores, categorías, búsqueda                       | 8082   |
| **Perfiles**        | Información completa de estudiantes y tutores       | 8082   |
| **Reservas**        | Agendamiento de sesiones, confirmaciones            | 8082   |
| **Pagos**           | Integración Stripe, procesamiento de pagos          | 8082   |
| **Videollamadas**   | Integración Agora.io para sesiones en vivo          | 8082   |
| **Notificaciones**  | Email, push, in-app notifications                   | 8082   |
| **Admin**           | Panel administrativo, reportes, estadísticas        | 8082   |

> **Nota:** Monolito modular en puerto 8082. Cada BC es independiente y podría extraerse como microservicio.

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
│   │   │   │   │   ├── Entity.java
│   │   │   │   │   ├── AggregateRoot.java
│   │   │   │   │   ├── ValueObject.java
│   │   │   │   │   ├── DomainEvent.java
│   │   │   │   │   └── DomainException.java
│   │   │   │   ├── application/                 # Ports
│   │   │   │   │   ├── UseCase.java
│   │   │   │   │   ├── Command.java
│   │   │   │   │   └── Query.java
│   │   │   │   └── infrastructure/              # Config compartida
│   │   │   │       └── config/
│   │   │   │           ├── DatabaseConfig.java
│   │   │   │           └── OpenApiConfig.java
│   │   │   │
│   │   │   ├── autenticacion/                   # BC Autenticación
│   │   │   │   ├── domain/
│   │   │   │   │   ├── model/                   # Usuario (Aggregate Root)
│   │   │   │   │   ├── repository/              # UsuarioRepository (Port)
│   │   │   │   │   └── service/
│   │   │   │   ├── application/
│   │   │   │   │   ├── port/in/                 # Use Cases (Input Ports)
│   │   │   │   │   ├── port/out/                # Persistence Ports
│   │   │   │   │   └── usecase/                 # Implementación
│   │   │   │   └── infrastructure/
│   │   │   │       └── adapter/
│   │   │   │           ├── in/web/              # REST Controllers
│   │   │   │           └── out/persistence/     # JPA Adapters
│   │   │   │
│   │   │   ├── marketplace/                     # BC Marketplace
│   │   │   ├── perfiles/                        # BC Perfiles
│   │   │   ├── reservas/                        # BC Reservas
│   │   │   ├── pagos/                           # BC Pagos
│   │   │   ├── videollamadas/                   # BC Videollamadas
│   │   │   ├── notificaciones/                  # BC Notificaciones
│   │   │   └── admin/                           # BC Admin
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
