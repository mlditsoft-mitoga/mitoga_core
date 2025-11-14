# 🔧 Historias de Usuario Técnicas (HUTs) - MI-TOGA Backend

**Proyecto:** MI-TOGA - Plataforma de Tutorías Virtuales  
**Cliente:** ZENAPSES S.A.S  
**Technical Architect:** Technical User Stories Specialist - ZNS v2.0  
**Versión:** 1.0.0  
**Última actualización:** 2025-11-08

---

## 📋 Descripción

Este directorio contiene las **Historias de Usuario Técnicas (HUTs)** que descomponen las Historias de Usuario de negocio (HUs) en tareas implementables siguiendo **Clean Architecture** y mejores prácticas de ingeniería de software.

**Arquitectura:** Monolito modular con Spring Boot 3.4.x + Java 21 LTS + PostgreSQL 16

---

## 📊 Resumen Ejecutivo

| Métrica | Valor |
|---------|-------|
| **Total HUTs generadas** | 1 |
| **Story Points Técnicos** | 5 SP |
| **Módulos técnicos** | 8 + shared |
| **Stack principal** | Java 21, Spring Boot 3.4, PostgreSQL 16 |
| **Arquitectura** | Clean Architecture / Hexagonal |

---

## 🏗️ Estructura de Módulos

### Módulos de Dominio (8)

```
mitoga-backend/
├── 00-setup/                  # Configuración base proyecto ✅
├── 01-autenticacion/          # Auth, registro, login
├── 02-marketplace/            # Búsqueda tutores, filtros
├── 03-perfiles/              # Perfiles estudiantes/tutores
├── 04-reservas/              # Sistema de reservas
├── 05-pagos/                 # Integración Stripe
├── 06-videollamadas/         # Agora/Twilio video
├── 07-notificaciones/        # Email, push, SMS
└── 08-admin/                 # Panel administración
```

### Módulo Compartido (shared)
Contiene código reutilizable:
- **Domain:** Entity base, ValueObject, AggregateRoot, DomainEvent
- **Application:** UseCase interface, EventHandler
- **Infrastructure:** GlobalExceptionHandler, ApiResponse, BaseRepository
- **Config:** SecurityConfig, DatabaseConfig, OpenApiConfig

---

## 📦 Módulos Disponibles

| Módulo | HUTs | SP Técnicos | Estado |
|--------|------|-------------|--------|
| [00-setup](00-setup/) | 1 | 5 SP | ✅ Completo |
| [01-autenticacion](01-autenticacion/) | 0 | 0 SP | ⏸️ Pendiente |
| [02-marketplace](02-marketplace/) | 0 | 0 SP | ⏸️ Pendiente |
| [03-perfiles](03-perfiles/) | 0 | 0 SP | ⏸️ Pendiente |
| [04-reservas](04-reservas/) | 0 | 0 SP | ⏸️ Pendiente |
| [05-pagos](05-pagos/) | 0 | 0 SP | ⏸️ Pendiente |
| [06-videollamadas](06-videollamadas/) | 0 | 0 SP | ⏸️ Pendiente |
| [07-notificaciones](07-notificaciones/) | 0 | 0 SP | ⏸️ Pendiente |
| [08-admin](08-admin/) | 0 | 0 SP | ⏸️ Pendiente |
| **TOTAL** | **1** | **5 SP** | **1%** |

---

## 🎯 Tipos de HUTs

### HUT-DOM: Domain (Dominio)
Historias técnicas de capa de dominio:
- Entidades y agregados
- Value Objects
- Reglas de negocio puras
- Domain Events

**Características:**
- Sin dependencias a frameworks
- Lógica de negocio core
- 100% testeable con unit tests

### HUT-INFRA: Infrastructure (Infraestructura)
Historias técnicas de adaptadores:
- Repositorios JPA + PostgreSQL
- Clientes de APIs externas (Stripe, Agora, SendGrid)
- Servicios técnicos (email, storage, cache)
- Migraciones de base de datos (Flyway)

**Características:**
- Implementa interfaces del dominio
- Dependencias externas (DB, HTTP clients)
- Requiere tests de integración

### HUT-UC: Use Cases (Casos de Uso)
Historias técnicas de aplicación:
- Orquestación de lógica de negocio
- Commands y Queries (CQRS pattern)
- Validaciones de negocio
- Transaccionalidad

**Características:**
- Coordina dominio + infraestructura
- Sin lógica de negocio compleja
- Testeable con mocks

### HUT-API: API/Presentation (Presentación)
Historias técnicas de endpoints REST:
- Controllers REST con Spring Web
- DTOs Request/Response
- Validaciones de entrada (Bean Validation)
- Documentación OpenAPI/Swagger

**Características:**
- Mapeo DTOs ↔ Domain models
- Manejo códigos HTTP
- Tests E2E con MockMvc/TestRestTemplate

### HUT-SEC: Security (Seguridad)
Historias técnicas cross-cutting de seguridad:
- Autenticación JWT
- Autorización RBAC
- Cifrado de datos sensibles
- Audit logging

### HUT-PERF: Performance (Rendimiento)
Historias técnicas de optimización:
- Caching (Redis, Caffeine)
- Índices de base de datos
- Lazy loading / Eager fetching
- Query optimization

### HUT-TEST: Testing (Pruebas)
Historias técnicas de testing:
- Tests unitarios (JUnit 5)
- Tests de integración (Testcontainers)
- Tests E2E de API
- Tests de performance (JMeter, Gatling)

---

## 🔄 Flujo de Descomposición HU → HUT

### Ejemplo: HU-021 (Reservar sesión de tutoría)

**HU de Negocio (8 SP):**
> Como estudiante, quiero reservar una sesión con un tutor, para asegurar mi cupo.

**Descomposición en HUTs (12 SP técnicos):**

1. **HUT-021-DOM-01:** Entidad `Reserva` y validaciones (3 SP)
   - Entidad con estado (PENDIENTE, CONFIRMADA, CANCELADA)
   - Value Objects (FechaHoraReserva, DuracionSesion)
   - Reglas: no reservas duplicadas, tutor disponible

2. **HUT-021-INFRA-01:** Repositorio `ReservaRepository` (2 SP)
   - Interface en domain, implementación JPA en infra
   - Queries: findByEstudianteId, findByTutorId, findByFecha
   - Migración Flyway: tabla `reservas`

3. **HUT-021-INFRA-02:** Cliente API disponibilidad tutor (2 SP)
   - Consultar disponibilidad del tutor
   - Manejo de errores 503 Service Unavailable

4. **HUT-021-UC-01:** Caso de uso `ReservarSesionUseCase` (2 SP)
   - Validar disponibilidad tutor
   - Crear reserva en estado PENDIENTE
   - Emitir evento `ReservaCreada`
   - Transaccionalidad

5. **HUT-021-API-01:** `POST /api/v1/reservas` (2 SP)
   - DTO `CrearReservaRequest` con validaciones
   - DTO `ReservaResponse` con HATEOAS links
   - Swagger documentation
   - Status 201 Created

6. **HUT-021-TEST-01:** Tests E2E reservar sesión (1 SP)
   - Test happy path: reserva exitosa
   - Test error: tutor no disponible
   - Test error: datos inválidos

**Ratio conversión:** 8 SP negocio → 12 SP técnicos (factor 1.5x)

---

## 📐 Arquitectura Clean Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      CAPA PRESENTACIÓN                       │
│  Controllers REST · DTOs · Validación entrada · Swagger      │
│                                                               │
│  Ejemplo: ReservaController.java                             │
│  @PostMapping("/api/v1/reservas")                            │
│  ResponseEntity<ReservaResponse> crear(CrearReservaRequest)  │
└─────────────────────────────────────────────────────────────┘
                            ↓ depende de
┌─────────────────────────────────────────────────────────────┐
│                      CAPA APLICACIÓN                         │
│  Use Cases · Commands/Queries · Orquestación · DTOs         │
│                                                               │
│  Ejemplo: ReservarSesionUseCase.java                         │
│  ReservaDTO ejecutar(CrearReservaCommand command)            │
│  - Validar disponibilidad tutor                              │
│  - Crear reserva (domain)                                    │
│  - Persistir (repository)                                    │
│  - Emitir evento                                             │
└─────────────────────────────────────────────────────────────┘
                            ↓ depende de
┌─────────────────────────────────────────────────────────────┐
│                       CAPA DOMINIO                           │
│  Entities · Value Objects · Domain Services · Business Rules │
│                                                               │
│  Ejemplo: Reserva.java (entidad), ReservaRepository (port)   │
│  - Estado: PENDIENTE, CONFIRMADA, CANCELADA                  │
│  - Reglas: validar horarios, no overlap, tutor disponible    │
│  - Método: confirmar(), cancelar()                           │
└─────────────────────────────────────────────────────────────┘
                            ↑ implementa
┌─────────────────────────────────────────────────────────────┐
│                   CAPA INFRAESTRUCTURA                       │
│  Repositorios JPA · APIs externas · Email · Storage · Cache  │
│                                                               │
│  Ejemplo: ReservaRepositoryImpl.java (adapter)               │
│  - Mapeo ReservaEntity (JPA) ↔ Reserva (domain)             │
│  - Queries SQL optimizadas                                   │
│  - Manejo transacciones                                      │
└─────────────────────────────────────────────────────────────┘
```

**Principio clave:** Las dependencias apuntan hacia adentro (hacia el dominio).

---

## 🚀 Cómo Usar Este Backlog Técnico

### Para Desarrolladores Backend:

1. **Leer HUT asignada:**
   - Revisar especificaciones técnicas (modelos, APIs, queries)
   - Entender criterios de aceptación técnicos (Given-When-Then)
   - Verificar dependencias (librerías, otras HUTs)

2. **Implementar siguiendo la estructura:**
   - Comenzar por domain (sin dependencias)
   - Luego infrastructure (repositorios, clientes)
   - Después application (use cases)
   - Finalmente presentation (controllers)

3. **Validar Definition of Done:**
   - Tests unitarios pasan (>80% cobertura en domain)
   - Tests de integración pasan (Testcontainers)
   - Swagger actualizado
   - Code review aprobado

### Para Tech Leads:

1. **Secuenciar HUTs:**
   - Priorizar por dependencias (bottom-up: DOM → INFRA → UC → API)
   - Asignar según especialización del equipo
   - Balancear carga (SP por desarrollador)

2. **Revisar arquitectura:**
   - Verificar separación de capas
   - Validar que no hay dependencias invertidas
   - Asegurar que se siguen patrones de diseño

3. **Gestionar riesgos técnicos:**
   - Identificar integraciones complejas (Stripe, Agora)
   - Planificar spikes técnicos si es necesario
   - Monitorear deuda técnica

### Para QA Engineers:

1. **Preparar estrategia de testing:**
   - Tests unitarios (domain, use cases)
   - Tests de integración (repositories, API clients)
   - Tests E2E (API completa)
   - Tests de performance (endpoints críticos)

2. **Automatizar tests:**
   - Pipeline CI/CD con tests en cada commit
   - Cobertura mínima: 80% domain, 70% use cases
   - Reportes de cobertura con JaCoCo

---

## 🛠️ Stack Tecnológico Detallado

### Backend Core
- **Lenguaje:** Java 21 LTS (features: Records, Pattern Matching, Virtual Threads)
- **Framework:** Spring Boot 3.4.0
- **Build Tool:** Gradle 8.10 con Kotlin DSL
- **Arquitectura:** Clean Architecture (Hexagonal)

### Base de Datos
- **RDBMS:** PostgreSQL 16.x
- **ORM:** Hibernate 6.x (JPA)
- **Migraciones:** Flyway 10.17.0
- **Connection Pool:** HikariCP (default en Spring Boot)

### Seguridad
- **Authentication:** JWT (JSON Web Tokens) con `jjwt` library
- **Authorization:** Spring Security 6.x con RBAC
- **Password:** BCrypt hashing

### Testing
- **Unit Tests:** JUnit 5 + Mockito
- **Integration Tests:** Testcontainers (PostgreSQL)
- **E2E Tests:** MockMvc / TestRestTemplate
- **Coverage:** JaCoCo

### Documentación API
- **OpenAPI 3.0:** SpringDoc OpenAPI 2.6.0
- **Swagger UI:** Incluido en SpringDoc
- **Formato:** JSON en `/api/v1/api-docs`

### DevOps
- **Containerización:** Docker + Docker Compose
- **CI/CD:** (Por definir: GitHub Actions, GitLab CI, Jenkins)
- **Monitoring:** Spring Boot Actuator + Prometheus + Grafana

### Integraciones Externas
- **Pagos:** Stripe SDK (Java)
- **Videollamadas:** Agora.io SDK / Twilio Video API
- **Email:** SendGrid / AWS SES
- **Push Notifications:** Firebase Cloud Messaging
- **SMS:** Twilio

---

## 📈 Métricas de Calidad Técnica

| Métrica | Objetivo | Actual |
|---------|----------|--------|
| **Cobertura tests (domain)** | >80% | - |
| **Cobertura tests (use cases)** | >70% | - |
| **Cobertura tests (infrastructure)** | >60% | - |
| **Complejidad ciclomática** | <10 por método | - |
| **Deuda técnica (SonarQube)** | Rating A | - |
| **Vulnerabilidades (Snyk)** | 0 críticas | - |
| **Performance API** | <200ms p95 | - |

---

## 🔗 Referencias

### Documentación Técnica
- [Spring Boot 3.4 Reference](https://docs.spring.io/spring-boot/docs/3.4.0/reference/html/)
- [Spring Data JPA](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/)
- [Spring Security](https://docs.spring.io/spring-security/reference/)
- [PostgreSQL 16 Docs](https://www.postgresql.org/docs/16/)
- [Flyway Documentation](https://flywaydb.org/documentation/)

### Arquitectura
- [Clean Architecture - Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Hexagonal Architecture - Alistair Cockburn](https://alistair.cockburn.us/hexagonal-architecture/)
- [Domain-Driven Design - Eric Evans](https://www.domainlanguage.com/ddd/)

### Patrones de Diseño
- [Repository Pattern](https://martinfowler.com/eaaCatalog/repository.html)
- [Unit of Work](https://martinfowler.com/eaaCatalog/unitOfWork.html)
- [CQRS](https://martinfowler.com/bliki/CQRS.html)

### Metodología
- [Technical User Stories Prompt](../../02-agents/8.technical_user_stories/prompt-historias-usuario-tecnicas.md)
- [Plantilla HUT](../../02-agents/8.technical_user_stories/plantilla-hut.md)
- [Checklist Validación HUTs](../../02-agents/8.technical_user_stories/checklist-validacion-huts.md)

---

## 📞 Contacto

**Tech Lead:** [Por asignar]  
**Architects:** ZNS v2.0 - Technical User Stories Specialist  
**Repositorio:** [GitHub/GitLab URL]

---

**Última actualización:** 2025-11-08  
**Versión Backlog Técnico:** 1.0.0
