# HUT-000-INFRA-01: Setup Proyecto Backend Spring Boot con Java 21

## 📌 IDENTIFICACIÓN

> **ID:** `HUT-000-INFRA-01`  
> **Tipo:** `INFRA` (Infraestructura)  
> **HU Origen:** Fundacional (habilita todas las HUs del sistema)  
> **Bounded Context:** `Shared Kernel` (transversal a todos los BCs)  
> **Módulo:** Setup & Infraestructura Base  
> **Sprint:** Sprint 0 (Setup)  
> **Story Points Técnicos:** **5 SP** (2-3 días por desarrollador senior)  
> **Prioridad:** **CRÍTICA** (bloquea todo el desarrollo)  
> **Fecha Creación:** 2025-11-08  
> **Versión:** 1.2 (Integración HashiCorp Vault)

---

## 🎯 HISTORIA TÉCNICA

**Como** Backend Developer Senior con experiencia en DDD y Hexagonal Architecture,  
**Quiero** Configurar un proyecto Spring Boot 3.4.x con Java 21 LTS siguiendo arquitectura hexagonal (Ports & Adapters) y Domain-Driven Design (DDD) con 8 Bounded Contexts,  
**Para** Establecer la base técnica enterprise-grade del backend de MI-TOGA con PostgreSQL 16, separación estricta de capas, modelado del dominio rico, y Shared Kernel con building blocks DDD (Entity, ValueObject, AggregateRoot, DomainEvent, DomainException).

---

## 💼 Valor Técnico

**Impacto en arquitectura:**
- Establece arquitectura hexagonal (Ports & Adapters) con separación clara de responsabilidades
- Implementa Domain-Driven Design (DDD) con bounded contexts por módulo de negocio
- Define capas arquitectónicas: Domain (núcleo), Application (orquestación), Infrastructure (adaptadores)
- Configura conexión a PostgreSQL con JPA/Hibernate siguiendo patrón Repository
- Modela el dominio rico con Entities, Aggregates, Value Objects y Domain Events

**Habilitador de negocio:**
- Fundamento técnico para implementar todas las HUs con lenguaje ubicuo del dominio
- Bounded Contexts alineados con módulos de negocio (Autenticación, Reservas, Pagos, etc.)
- Garantiza escalabilidad y evolución independiente de cada contexto
- Permite desarrollo paralelo por módulos sin conflictos (bajo acoplamiento)

**Beneficios:**
- ✅ Arquitectura Hexagonal: Independencia del framework, testeabilidad, inversión de dependencias
- ✅ Domain-Driven Design: Alineación código-negocio, lenguaje ubicuo, modelo rico
- ✅ Bounded Contexts: Cada módulo es autónomo con su propio modelo de dominio
- ✅ Java 21 LTS: Records para Value Objects, Pattern Matching, Virtual Threads
- ✅ Monolito modular: Simplicidad operacional con preparación para microservicios futuros

---

## 📋 Especificaciones Técnicas

### Stack Tecnológico

**Core:**
- **Java:** 21 LTS (Amazon Corretto / OpenJDK)
- **Spring Boot:** 3.4.0 (última versión estable)
- **Build Tool:** Gradle 8.10 con Kotlin DSL
- **Base de Datos:** PostgreSQL 16.x
- **Cache/Rate Limiting:** Redis 7.x
- **Email:** SMTP (Gmail)
- **Secrets Management:** HashiCorp Vault (gestión centralizada de credenciales)

**Dependencias principales:**
```gradle
dependencies {
    // Spring Boot Starters
    implementation 'org.springframework.boot:spring-boot-starter-web'
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
    implementation 'org.springframework.boot:spring-boot-starter-security'
    implementation 'org.springframework.boot:spring-boot-starter-validation'
    implementation 'org.springframework.boot:spring-boot-starter-actuator'
    implementation 'org.springframework.boot:spring-boot-starter-mail'
    
    // Redis para cache y rate limiting
    implementation 'org.springframework.boot:spring-boot-starter-data-redis'
    implementation 'io.lettuce:lettuce-core:6.3.2.RELEASE'
    
    // HashiCorp Vault para gestión de secrets
    implementation 'org.springframework.cloud:spring-cloud-starter-vault-config:4.1.3'
    
    // Base de datos
    implementation 'org.postgresql:postgresql:42.7.3'
    implementation 'org.flywaydb:flyway-core:10.17.0'
    implementation 'org.flywaydb:flyway-database-postgresql:10.17.0'
    
    // Utilidades
    implementation 'org.projectlombok:lombok:1.18.34'
    annotationProcessor 'org.projectlombok:lombok:1.18.34'
    implementation 'org.mapstruct:mapstruct:1.5.5.Final'
    annotationProcessor 'org.mapstruct:mapstruct-processor:1.5.5.Final'
    
    // Documentación API
    implementation 'org.springdoc:springdoc-openapi-starter-webmvc-ui:2.6.0'
    
    // Testing
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
    testImplementation 'org.springframework.security:spring-security-test'
    testImplementation 'org.testcontainers:postgresql:1.19.8'
    testImplementation 'org.testcontainers:junit-jupiter:1.19.8'
}
```

### Estructura del Proyecto (Arquitectura Hexagonal + DDD)

```
mitoga-backend/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── mitoga/
│   │   │           ├── MitogaApplication.java
│   │   │           │
│   │   │           ├── shared/                    # Shared Kernel (DDD)
│   │   │           │   ├── domain/
│   │   │           │   │   ├── AggregateRoot.java
│   │   │           │   │   ├── Entity.java
│   │   │           │   │   ├── ValueObject.java
│   │   │           │   │   ├── DomainEvent.java
│   │   │           │   │   └── DomainException.java
│   │   │           │   ├── application/
│   │   │           │   │   ├── UseCase.java         # Port (interface)
│   │   │           │   │   ├── Query.java
│   │   │           │   │   ├── Command.java
│   │   │           │   │   └── EventPublisher.java  # Port
│   │   │           │   ├── infrastructure/
│   │   │           │   │   ├── persistence/
│   │   │           │   │   │   └── BaseRepository.java
│   │   │           │   │   ├── security/
│   │   │           │   │   │   ├── SecurityConfig.java
│   │   │           │   │   │   └── JwtTokenProvider.java
│   │   │           │   │   └── web/
│   │   │           │   │       ├── GlobalExceptionHandler.java
│   │   │           │   │       ├── ApiResponse.java
│   │   │           │   │       └── PageResponse.java
│   │   │           │   └── config/
│   │   │           │       ├── DatabaseConfig.java
│   │   │           │       ├── FlywayConfig.java
│   │   │           │       └── OpenApiConfig.java
│   │   │           │
│   │   │           ├── autenticacion/             # Bounded Context 1
│   │   │           │   ├── domain/                # DOMAIN LAYER (núcleo hexágono)
│   │   │           │   │   ├── model/             # Aggregates & Entities
│   │   │           │   │   │   ├── Usuario.java   # Aggregate Root
│   │   │           │   │   │   ├── UsuarioId.java # Value Object (ID)
│   │   │           │   │   │   ├── Email.java     # Value Object
│   │   │           │   │   │   ├── Password.java  # Value Object
│   │   │           │   │   │   └── RolUsuario.java # Enum
│   │   │           │   │   ├── repository/        # Ports (interfaces)
│   │   │           │   │   │   └── UsuarioRepository.java
│   │   │           │   │   ├── service/           # Domain Services
│   │   │           │   │   │   ├── AutenticacionDomainService.java
│   │   │           │   │   │   └── PasswordHashService.java  # Port
│   │   │           │   │   └── event/             # Domain Events
│   │   │           │   │       ├── UsuarioRegistrado.java
│   │   │           │   │       └── UsuarioAutenticado.java
│   │   │           │   │
│   │   │           │   ├── application/           # APPLICATION LAYER (casos de uso)
│   │   │           │   │   ├── port/              # Input Ports (casos de uso)
│   │   │           │   │   │   ├── in/
│   │   │           │   │   │   │   ├── RegistrarUsuarioUseCase.java
│   │   │           │   │   │   │   └── LoginUseCase.java
│   │   │           │   │   │   └── out/           # Output Ports (para infra)
│   │   │           │   │   │       ├── UsuarioPersistencePort.java
│   │   │           │   │   │       └── EmailNotificationPort.java
│   │   │           │   │   ├── usecase/           # Implementación casos de uso
│   │   │           │   │   │   ├── RegistrarUsuarioService.java
│   │   │           │   │   │   └── LoginService.java
│   │   │           │   │   └── dto/               # DTOs (anti-corruption layer)
│   │   │           │   │       ├── RegistroUsuarioCommand.java
│   │   │           │   │       ├── LoginCommand.java
│   │   │           │   │       └── UsuarioResponse.java
│   │   │           │   │
│   │   │           │   └── infrastructure/        # INFRASTRUCTURE LAYER (adaptadores)
│   │   │           │       ├── adapter/
│   │   │           │       │   ├── in/            # Input Adapters (driving)
│   │   │           │       │   │   └── web/
│   │   │           │       │   │       ├── AutenticacionController.java
│   │   │           │       │   │       └── mapper/
│   │   │           │       │   │           └── UsuarioWebMapper.java
│   │   │           │       │   └── out/           # Output Adapters (driven)
│   │   │           │       │       ├── persistence/
│   │   │           │       │       │   ├── UsuarioJpaEntity.java
│   │   │           │       │       │   ├── UsuarioJpaRepository.java
│   │   │           │       │       │   ├── UsuarioPersistenceAdapter.java
│   │   │           │       │       │   └── mapper/
│   │   │           │       │       │       └── UsuarioPersistenceMapper.java
│   │   │           │       │       └── email/
│   │   │           │       │           └── EmailNotificationAdapter.java
│   │   │           │       └── config/
│   │   │           │           └── AutenticacionConfig.java
│   │   │           │
│   │   │           ├── marketplace/               # Bounded Context 2
│   │   │           │   ├── domain/
│   │   │           │   │   ├── model/             # Tutor (Aggregate), Categoria (VO)
│   │   │           │   │   ├── repository/
│   │   │           │   │   └── service/
│   │   │           │   ├── application/
│   │   │           │   │   ├── port/
│   │   │           │   │   ├── usecase/
│   │   │           │   │   └── dto/
│   │   │           │   └── infrastructure/
│   │   │           │       └── adapter/
│   │   │           │
│   │   │           ├── perfiles/                  # Bounded Context 3
│   │   │           │   ├── domain/
│   │   │           │   ├── application/
│   │   │           │   └── infrastructure/
│   │   │           │
│   │   │           ├── reservas/                  # Bounded Context 4
│   │   │           │   ├── domain/
│   │   │           │   │   ├── model/             # Reserva (Aggregate), Disponibilidad (VO)
│   │   │           │   │   ├── repository/
│   │   │           │   │   ├── service/
│   │   │           │   │   └── event/             # ReservaCreada, ReservaConfirmada
│   │   │           │   ├── application/
│   │   │           │   └── infrastructure/
│   │   │           │
│   │   │           ├── pagos/                     # Bounded Context 5
│   │   │           │   ├── domain/
│   │   │           │   │   ├── model/             # Pago (Aggregate), Monto (VO)
│   │   │           │   │   ├── repository/
│   │   │           │   │   └── service/           # PagosDomainService
│   │   │           │   ├── application/
│   │   │           │   │   └── port/
│   │   │           │   │       └── out/
│   │   │           │   │           └── StripePaymentPort.java
│   │   │           │   └── infrastructure/
│   │   │           │       └── adapter/
│   │   │           │           └── out/
│   │   │           │               └── stripe/
│   │   │           │                   └── StripePaymentAdapter.java
│   │   │           │
│   │   │           ├── videollamadas/             # Bounded Context 6
│   │   │           │   ├── domain/
│   │   │           │   ├── application/
│   │   │           │   └── infrastructure/
│   │   │           │       └── adapter/
│   │   │           │           └── out/
│   │   │           │               └── agora/
│   │   │           │
│   │   │           ├── notificaciones/            # Bounded Context 7
│   │   │           │   ├── domain/
│   │   │           │   ├── application/
│   │   │           │   └── infrastructure/
│   │   │           │
│   │   │           └── admin/                     # Bounded Context 8
│   │   │               ├── domain/
│   │   │               ├── application/
│   │   │               └── infrastructure/
│   │   │
│   │   └── resources/
│   │       ├── application.yml              # Único archivo de configuración
│   │       └── db/
│   │           └── migration/
│   │               └── V1__init_schema.sql
│   │
│   └── test/
│       └── java/
│           └── com/
│               └── mitoga/
│                   ├── architecture/
│                   │   ├── HexagonalArchitectureTest.java
│                   │   └── DddLayersTest.java
│                   └── [bounded-contexts]/
│
├── build.gradle.kts
├── settings.gradle.kts
├── gradle.properties
├── Dockerfile
├── docker-compose.yml
└── README.md
```

**Explicación de la estructura:**

**Arquitectura Hexagonal (Ports & Adapters):**
- **Domain (centro del hexágono):** Lógica de negocio pura, sin dependencias externas
- **Ports (interfaces):** Contratos que el dominio expone (input) o necesita (output)
- **Adapters (periferia):** Implementaciones concretas de los ports
  - **Input Adapters (driving):** REST controllers, GraphQL, Message listeners
  - **Output Adapters (driven):** JPA repositories, HTTP clients, Email senders

**Domain-Driven Design (DDD):**
- **Bounded Contexts:** Cada módulo es un contexto delimitado con su propio modelo
- **Aggregates:** Clusters de objetos tratados como unidad (ej: Usuario, Reserva, Pago)
- **Entities:** Objetos con identidad (ej: Usuario, Tutor)
- **Value Objects:** Objetos sin identidad definidos por sus atributos (ej: Email, Monto, UsuarioId)
- **Domain Events:** Eventos de negocio (ej: UsuarioRegistrado, ReservaConfirmada)
- **Domain Services:** Lógica que no pertenece a una entidad específica
- **Repositories (ports):** Interfaces para persistencia definidas en el dominio
- **Shared Kernel:** Código compartido entre bounded contexts

**Capas por Bounded Context:**
- `domain/` — Núcleo del hexágono (Aggregates, Entities, VOs, Domain Services, Ports)
- `application/` — Casos de uso que orquestan el dominio (Commands, Queries, DTOs)
- `infrastructure/` — Adaptadores concretos (REST, JPA, Stripe, Agora, SendGrid)

### Configuración Base

**application.yml (Único archivo - Gestión con HashiCorp Vault):**
```yaml
spring:
  application:
    name: mitoga-backend
  
  # Configuración HashiCorp Vault para gestión centralizada de secrets
  cloud:
    vault:
      enabled: ${CONFIG_VAULT_ENABLED:true}
      uri: http://192.168.18.38:8300
      authentication: approle
      app-role:
        role-id: 2437e31a-1c9e-65a6-04ae-21423aab39d9
        secret-id: 97b7fdd9-0bc4-c2e2-637b-99f29a731fc5
        app-role-path: mitoga_approle
      kv:
        enabled: true
        backend: mitoga-secrets
        default-context: mitoga_project
      fail-fast: true
  
  datasource:
    # Valores obtenidos desde HashiCorp Vault en runtime
    url: ${secret.database.url}              # jdbc:postgresql://192.168.18.30:5432/mitogadb
    username: ${secret.database.username}     # admin
    password: ${secret.database.password}     # admin
    driver-class-name: ${secret.database.driver}  # org.postgresql.Driver
    hikari:
      maximum-pool-size: 10
      minimum-idle: 5
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000
  
  jpa:
    hibernate:
      ddl-auto: validate  # Flyway gestiona el schema
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQLDialect
        format_sql: true
        jdbc:
          batch_size: 20
        order_inserts: true
        order_updates: true
    show-sql: false
  
  flyway:
    enabled: true
    baseline-on-migrate: true
    locations: classpath:db/migration
    schemas: public
    validate-on-migrate: true
  
  # Configuración de email (valores desde Vault)
  mail:
    host: ${secret.mail_host}                # smtp.gmail.com
    port: ${secret.mail_port}                # 587
    username: ${secret.mail_username}         # noreply.mitoga@gmail.com
    password: ${secret.mail_password}         # app password
    protocol: ${secret.mail_protocol}         # smtp
    properties:
      mail:
        smtp:
          auth: true
          starttls:
            enable: true
            required: true
  
  # Configuración Redis (valores desde Vault)
  data:
    redis:
      host: ${secret.redis_host}              # 192.168.18.30
      port: ${secret.redis_port}              # 6379
      password: ${secret.redis_password}      # admin
      timeout: 2000ms
      lettuce:
        pool:
          max-active: 8
          max-idle: 8
          min-idle: 0
          max-wait: -1ms
  
  security:
    jwt:
      # JWT secrets gestionados por HashiCorp Vault
      secret: ${secret.jwt}                           # Primary JWT secret
      refresh-secret: ${secret.jwt_refresh_secret}    # Refresh token secret
      expiration-minutes: ${secret.jwt_expires_in_minutes}          # 480 min (8h)
      refresh-expiration-minutes: ${secret.jwt_expires_in_minutes_refresh}  # 485 min

server:
  port: ${secret.server.port:8082}  # Puerto desde Vault (default: 8082)
  servlet:
    context-path: /api/v1
  error:
    include-message: always
    include-stacktrace: never
  compression:
    enabled: true
    mime-types: application/json,application/xml,text/html,text/xml,text/plain

# Configuración Rate Limiting (Redis)
rate-limit:
  enabled: ${redis.rateLimitEnabled:false}
  default-limit: ${redis.rate-limit-default-limit:100}
  default-window-seconds: ${redis.rate-limit-default-window-seconds:60}

management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
  endpoint:
    health:
      show-details: when-authorized
  metrics:
    export:
      prometheus:
        enabled: true

logging:
  level:
    root: INFO
    com.mitoga: DEBUG
    org.springframework.web: DEBUG
    org.springframework.security: DEBUG
    org.hibernate.SQL: DEBUG
    org.hibernate.type.descriptor.sql.BasicBinder: TRACE
  pattern:
    console: "%d{yyyy-MM-dd HH:mm:ss} - %msg%n"
    file: "%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n"

springdoc:
  api-docs:
    path: /api-docs
  swagger-ui:
    path: /swagger-ui.html
    enabled: true
    operations-sorter: method
    tags-sorter: alpha
```

**Secrets almacenados en Vault (backend: mitoga-secrets, context: mitoga_project):**
```json
{
  "secret.database.url": "jdbc:postgresql://192.168.18.30:5432/mitogadb",
  "secret.database.username": "admin",
  "secret.database.password": "admin",
  "secret.database.driver": "org.postgresql.Driver",
  "secret.jwt": "b6a940428d09875e533038a8e10c128527a0526e08c4a45f94a4c148f3b890a9",
  "secret.jwt_refresh_secret": "a1b2c3d4e5f60718293a4b5c6d7e8f90123456789abcdef0123456789abcdef",
  "secret.jwt_expires_in_minutes": "480",
  "secret.jwt_expires_in_minutes_refresh": "485",
  "secret.mail_host": "smtp.gmail.com",
  "secret.mail_port": "587",
  "secret.mail_username": "noreply.mitoga@gmail.com",
  "secret.mail_password": "chey qrke vtgq vctp",
  "secret.mail_protocol": "smtp",
  "secret.redis_host": "192.168.18.30",
  "secret.redis_port": 6379,
  "secret.redis_password": "admin",
  "secret.server.port": "8082",
  "secret.port": "8081",
  "secret.server.port.apigateway": "8080",
  "redis.rateLimitEnabled": "false",
  "redis.rate-limit-default-limit": 100,
  "redis.rate-limit-default-window-seconds": 60
}
```

**build.gradle.kts:**
```kotlin
plugins {
    java
    id("org.springframework.boot") version "3.4.0"
    id("io.spring.dependency-management") version "1.1.6"
}

group = "com.mitoga"
version = "1.0.0-SNAPSHOT"

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

configurations {
    compileOnly {
        extendsFrom(configurations.annotationProcessor.get())
    }
}

repositories {
    mavenCentral()
}

dependencies {
    // Spring Boot Starters
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    implementation("org.springframework.boot:spring-boot-starter-security")
    implementation("org.springframework.boot:spring-boot-starter-validation")
    implementation("org.springframework.boot:spring-boot-starter-actuator")
    implementation("org.springframework.boot:spring-boot-starter-mail")
    
    // Redis para cache y rate limiting
    implementation("org.springframework.boot:spring-boot-starter-data-redis")
    implementation("io.lettuce:lettuce-core:6.3.2.RELEASE")
    
    // Spring Cloud Vault para gestión de secrets
    implementation("org.springframework.cloud:spring-cloud-starter-vault-config:4.1.3")
    
    // PostgreSQL
    runtimeOnly("org.postgresql:postgresql:42.7.3")
    
    // Flyway
    implementation("org.flywaydb:flyway-core:10.17.0")
    implementation("org.flywaydb:flyway-database-postgresql:10.17.0")
    
    // Lombok
    compileOnly("org.projectlombok:lombok:1.18.34")
    annotationProcessor("org.projectlombok:lombok:1.18.34")
    
    // MapStruct
    implementation("org.mapstruct:mapstruct:1.5.5.Final")
    annotationProcessor("org.mapstruct:mapstruct-processor:1.5.5.Final")
    
    // OpenAPI/Swagger
    implementation("org.springdoc:springdoc-openapi-starter-webmvc-ui:2.6.0")
    
    // JWT
    implementation("io.jsonwebtoken:jjwt-api:0.12.6")
    runtimeOnly("io.jsonwebtoken:jjwt-impl:0.12.6")
    runtimeOnly("io.jsonwebtoken:jjwt-jackson:0.12.6")
    
    // Testing
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("org.springframework.security:spring-security-test")
    testImplementation("org.testcontainers:postgresql:1.19.8")
    testImplementation("org.testcontainers:junit-jupiter:1.19.8")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

tasks.withType<Test> {
    useJUnitPlatform()
}

tasks.bootJar {
    archiveFileName.set("mitoga-backend.jar")
}
```

**docker-compose.yml (Desarrollo):**
```yaml
version: '3.8'

services:
  postgres:
    image: postgres:16-alpine
    container_name: mitoga-postgres
    environment:
      POSTGRES_DB: mitoga_dev
      POSTGRES_USER: mitoga_user
      POSTGRES_PASSWORD: mitoga_dev_pass
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U mitoga_user -d mitoga_dev"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - mitoga-network

  redis:
    image: redis:7-alpine
    container_name: mitoga-redis
    command: redis-server --requirepass admin
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "-a", "admin", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - mitoga-network

  pgadmin:
    image: dpage/pgadmin4:latest
    container_name: mitoga-pgadmin
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@mitoga.com
      PGADMIN_DEFAULT_PASSWORD: admin123
    ports:
      - "5050:80"
    depends_on:
      - postgres
    networks:
      - mitoga-network

volumes:
  postgres_data:
    driver: local
  redis_data:
    driver: local

networks:
  mitoga-network:
    driver: bridge
```

**Dockerfile (Multi-stage build):**
```dockerfile
# Stage 1: Build
FROM gradle:8.10-jdk21 AS builder

WORKDIR /app

# Copy Gradle files
COPY build.gradle.kts settings.gradle.kts gradle.properties ./
COPY gradle ./gradle

# Download dependencies (layer caching)
RUN gradle dependencies --no-daemon

# Copy source code
COPY src ./src

# Build application
RUN gradle bootJar --no-daemon

# Stage 2: Runtime
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 mitoga && \
    adduser -D -u 1001 -G mitoga mitoga

# Copy JAR from builder
COPY --from=builder /app/build/libs/mitoga-backend.jar ./app.jar

# Change ownership
RUN chown -R mitoga:mitoga /app

USER mitoga

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/api/v1/actuator/health || exit 1

EXPOSE 8080

ENTRYPOINT ["java", \
    "-XX:+UseG1GC", \
    "-XX:MaxRAMPercentage=75.0", \
    "-Djava.security.egd=file:/dev/./urandom", \
    "-jar", "app.jar"]
```

### Clases Base Compartidas (Shared Kernel DDD)

**shared/domain/Entity.java:**
```java
package com.mitoga.shared.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.Objects;

/**
 * Clase base para todas las entidades del dominio.
 * Sigue los principios de DDD: identidad única, ciclo de vida, igualdad basada en ID.
 */
@Getter
@Setter
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
public abstract class Entity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @LastModifiedDate
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @CreatedBy
    @Column(name = "created_by", updatable = false)
    private String createdBy;
    
    @LastModifiedBy
    @Column(name = "updated_by")
    private String updatedBy;
    
    @Version
    @Column(name = "version")
    private Long version;
    
    /**
     * Igualdad basada en identidad (DDD: dos entidades son iguales si tienen el mismo ID)
     */
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Entity entity = (Entity) o;
        return Objects.equals(id, entity.id);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
```

**shared/domain/ValueObject.java:**
```java
package com.mitoga.shared.domain;

import java.io.Serializable;

/**
 * Marker interface para Value Objects (DDD).
 * 
 * Características de un Value Object:
 * - Inmutable (sin setters)
 * - Igualdad basada en valores (equals/hashCode)
 * - Sin identidad propia
 * - Puede ser compartido
 * 
 * Ejemplos: Email, Monto, Direccion, DateRange, UsuarioId
 */
public interface ValueObject extends Serializable {
}
```

**shared/domain/AggregateRoot.java:**
```java
package com.mitoga.shared.domain;

import lombok.Getter;
import java.util.ArrayList;
import java.util.List;

/**
 * Clase base para Aggregate Roots (DDD).
 * 
 * Un Aggregate es un cluster de objetos del dominio tratados como unidad
 * para propósitos de cambios de datos. El Aggregate Root es la entidad
 * raíz que garantiza la consistencia del agregado.
 * 
 * Responsabilidades:
 * - Garantizar invariantes del agregado
 * - Exponer métodos de negocio (no setters)
 * - Emitir Domain Events
 * - Controlar acceso a entidades hijas
 */
@Getter
public abstract class AggregateRoot extends Entity {
    
    private final transient List<DomainEvent> domainEvents = new ArrayList<>();
    
    /**
     * Registra un evento de dominio para ser publicado.
     */
    protected void registerEvent(DomainEvent event) {
        this.domainEvents.add(event);
    }
    
    /**
     * Limpia los eventos después de ser publicados.
     */
    public void clearEvents() {
        this.domainEvents.clear();
    }
}
```

**shared/domain/DomainEvent.java:**
```java
package com.mitoga.shared.domain;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Interfaz base para eventos de dominio (DDD).
 * 
 * Los eventos de dominio representan algo que ha ocurrido en el dominio
 * que es de interés para otros bounded contexts o agregados.
 * 
 * Ejemplos: UsuarioRegistrado, ReservaConfirmada, PagoRealizado
 */
public interface DomainEvent {
    
    /**
     * ID único del evento
     */
    UUID getEventId();
    
    /**
     * Fecha y hora en que ocurrió el evento
     */
    LocalDateTime getOccurredOn();
    
    /**
     * Tipo del evento (para deserialización)
     */
    String getEventType();
}
```

**shared/domain/DomainException.java:**
```java
package com.mitoga.shared.domain;

/**
 * Excepción base para errores del dominio.
 * 
 * Representa violaciones de reglas de negocio o invariantes del dominio.
 * No debe contener lógica de infraestructura (HTTP, DB, etc.)
 */
public class DomainException extends RuntimeException {
    
    private final String errorCode;
    
    public DomainException(String message) {
        super(message);
        this.errorCode = "DOMAIN_ERROR";
    }
    
    public DomainException(String errorCode, String message) {
        super(message);
        this.errorCode = errorCode;
    }
    
    public DomainException(String errorCode, String message, Throwable cause) {
        super(message, cause);
        this.errorCode = errorCode;
    }
    
    public String getErrorCode() {
        return errorCode;
    }
}
```

**Ejemplo de Value Object (Email):**
```java
package com.mitoga.shared.domain;

import lombok.Value;
import java.util.regex.Pattern;

/**
 * Value Object para representar un email (DDD).
 * 
 * - Inmutable (@Value de Lombok)
 * - Validación en constructor
 * - Igualdad basada en valor
 */
@Value
public class Email implements ValueObject {
    
    private static final Pattern EMAIL_PATTERN = 
        Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    
    String value;
    
    public Email(String value) {
        if (value == null || value.isBlank()) {
            throw new DomainException("EMAIL_EMPTY", "El email no puede estar vacío");
        }
        if (!EMAIL_PATTERN.matcher(value).matches()) {
            throw new DomainException("EMAIL_INVALID", "Formato de email inválido: " + value);
        }
        this.value = value.toLowerCase().trim();
    }
    
    public static Email of(String value) {
        return new Email(value);
    }
    
    @Override
    public String toString() {
        return value;
    }
}
```

**shared/infrastructure/web/GlobalExceptionHandler.java:**
```java
package com.mitoga.shared.infrastructure.web;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidationExceptions(
            MethodArgumentNotValidException ex, WebRequest request) {
        
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        
        ErrorResponse errorResponse = ErrorResponse.builder()
                .timestamp(LocalDateTime.now())
                .status(HttpStatus.BAD_REQUEST.value())
                .error("Validation Failed")
                .message("Error en validación de campos")
                .errors(errors)
                .path(request.getDescription(false).replace("uri=", ""))
                .build();
        
        return ResponseEntity.badRequest().body(errorResponse);
    }
    
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGlobalException(
            Exception ex, WebRequest request) {
        
        log.error("Error no controlado", ex);
        
        ErrorResponse errorResponse = ErrorResponse.builder()
                .timestamp(LocalDateTime.now())
                .status(HttpStatus.INTERNAL_SERVER_ERROR.value())
                .error("Internal Server Error")
                .message("Ha ocurrido un error inesperado")
                .path(request.getDescription(false).replace("uri=", ""))
                .build();
        
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(errorResponse);
    }
}
```

**shared/infrastructure/web/ApiResponse.java:**
```java
package com.mitoga.shared.infrastructure.web;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiResponse<T> {
    private boolean success;
    private String message;
    private T data;
    private LocalDateTime timestamp;
    
    public static <T> ApiResponse<T> success(T data) {
        return ApiResponse.<T>builder()
                .success(true)
                .data(data)
                .timestamp(LocalDateTime.now())
                .build();
    }
    
    public static <T> ApiResponse<T> success(String message, T data) {
        return ApiResponse.<T>builder()
                .success(true)
                .message(message)
                .data(data)
                .timestamp(LocalDateTime.now())
                .build();
    }
}
```

---

## ✅ CRITERIOS DE ACEPTACIÓN TÉCNICOS (GIVEN-WHEN-THEN)

### Escenario 1: Proyecto se compila correctamente con Java 21
```gherkin
Given: El proyecto está configurado con Java 21 LTS y Spring Boot 3.4.0
  And: Todas las dependencias están declaradas en build.gradle.kts
  And: La estructura de paquetes sigue arquitectura hexagonal + DDD
When: Se ejecuta el comando `./gradlew clean build`
Then: 
  - El build completa exitosamente sin errores de compilación
  - Se genera el JAR ejecutable en `build/libs/mitoga-backend-0.0.1-SNAPSHOT.jar`
  - Todas las dependencias se resuelven correctamente (sin conflictos)
  - Los tests automáticos pasan (si existen)
  - El JAR es ejecutable: `java -jar build/libs/mitoga-backend-0.0.1-SNAPSHOT.jar`
  - El tamaño del JAR es ~60-80 MB (Spring Boot fat JAR)
```

### Escenario 2: Base de datos PostgreSQL se conecta exitosamente
```gherkin
Given: PostgreSQL 16 está corriendo en localhost:5432
  And: Existe la base de datos `mitoga_dev` con usuario `mitoga_user`
  And: HashiCorp Vault está configurado y accesible en http://192.168.18.38:8300
  And: Las credenciales de BD están almacenadas en Vault (backend: mitoga-secrets)
When: La aplicación inicia y obtiene credenciales desde Vault
Then:
  - La conexión a Vault se establece exitosamente con AppRole authentication
  - Las credenciales (url, username, password) se obtienen desde Vault en runtime
  - La conexión a PostgreSQL se establece exitosamente
  - El pool de conexiones HikariCP se inicializa con 10 conexiones máximo, 5 mínimo
  - Los logs confirman: "HikariPool-1 - Start completed"
  - No hay errores de autenticación ni timeout
  - La aplicación puede ejecutar queries (SELECT 1) exitosamente
  - El health check de datasource muestra "UP" en /actuator/health
```

### Escenario 3: Migraciones Flyway se ejecutan automáticamente
```gherkin
Given: La base de datos `mitoga_dev` está vacía (sin tablas)
  And: Existe el script de migración `V1__init_schema.sql` en resources/db/migration/
When: La aplicación inicia por primera vez con Flyway habilitado
Then:
  - Flyway ejecuta las migraciones en orden secuencial (V1, V2, ...)
  - Se crea la tabla de control `flyway_schema_history`
  - El schema version actual es V1
  - Los logs confirman: "Flyway X.X.X by Redgate - Migrating schema ... to version 1 - init schema"
  - Todas las tablas definidas en V1 existen (verificar con \dt en psql)
  - No hay errores de sintaxis SQL
  - En reinicios posteriores, Flyway detecta que V1 ya fue aplicada y no re-ejecuta
```

### Escenario 4: Endpoints de health (Actuator) responden correctamente
```gherkin
Given: La aplicación está corriendo en localhost:8080
  And: Spring Boot Actuator está configurado en application.yml
When: Se hace GET request a `/api/v1/actuator/health`
Then:
  - Responde con HTTP status 200 OK
  - El content-type es `application/json`
  - El body JSON contiene: `{"status": "UP"}`
  - El health check de PostgreSQL muestra "UP" con detalles de la base de datos
  - El tiempo de respuesta es < 100ms
  - El endpoint `/actuator/info` también responde (si configurado)
```

### Escenario 5: Swagger UI está disponible y documenta APIs
```gherkin
Given: La aplicación está corriendo en localhost:8080
  And: SpringDoc OpenAPI está configurado en build.gradle.kts
When: Se accede a `http://localhost:8080/api/v1/swagger-ui.html` en el navegador
Then:
  - Se muestra la interfaz gráfica de Swagger UI
  - El título de la API es "MI-TOGA Backend API v1.0"
  - Se listan los endpoints disponibles (inicialmente solo /actuator/*)
  - La especificación OpenAPI 3.0 está disponible en `/api/v1/api-docs`
  - El JSON de OpenAPI es válido (puede parsearse)
  - Los schemas de DTOs están documentados (si existen)
```

### Escenario 6: Docker Compose levanta servicios correctamente
```gherkin
Given: Docker está instalado y el daemon está corriendo
  And: Existe el archivo docker-compose.yml en la raíz del proyecto
When: Se ejecuta el comando `docker-compose up -d`
Then:
  - El contenedor `mitoga-postgres` inicia exitosamente (status: Up)
  - El contenedor `mitoga-pgadmin` inicia exitosamente (status: Up)
  - PostgreSQL acepta conexiones en localhost:5432
  - PgAdmin está accesible en http://localhost:5050
  - Los health checks de los contenedores muestran "healthy"
  - Los volúmenes de datos persisten entre reinicios
  - Se puede conectar a PostgreSQL desde el host: `psql -h localhost -U mitoga_user -d mitoga_dev`
```

### Escenario 7: Estructura modular con 8 Bounded Contexts
```gherkin
Given: El proyecto sigue arquitectura DDD con Bounded Contexts
When: Se inspecciona la estructura de paquetes en src/main/java/com/mitoga/
Then:
  - Existen 8 carpetas de bounded contexts: autenticacion, marketplace, perfiles, reservas, pagos, videollamadas, notificaciones, admin
  - Cada bounded context tiene 3 subcarpetas: domain/, application/, infrastructure/
  - La carpeta `shared/` contiene el Shared Kernel con clases base (Entity, ValueObject, AggregateRoot, DomainEvent, DomainException)
  - La estructura domain/ contiene: model/, repository/, service/, event/
  - La estructura application/ contiene: port/in/, port/out/, usecase/, dto/
  - La estructura infrastructure/ contiene: adapter/in/, adapter/out/, config/
  - No hay dependencias circulares entre bounded contexts
```

### Escenario 8: Shared Kernel con building blocks DDD
```gherkin
Given: El Shared Kernel está implementado en src/main/java/com/mitoga/shared/domain/
When: Se compilan las clases base del dominio
Then:
  - Existe la clase abstracta `Entity<ID>` con equals/hashCode basados en ID
  - Existe la interfaz `ValueObject` (marker interface) para VOs inmutables
  - Existe la clase abstracta `AggregateRoot` que extiende Entity y maneja Domain Events
  - Existe la interfaz `DomainEvent` con métodos: getEventId(), getOccurredOn(), getEventType()
  - Existe la clase `DomainException` que extiende RuntimeException con errorCode y message
  - Todas las clases compilan sin errores
  - No tienen dependencias de frameworks (ni Spring, ni JPA) en el dominio
  - Los tests unitarios de estas clases pasan (si existen)
```

### Escenario 9: Tests de arquitectura con ArchUnit
```gherkin
Given: Está configurado ArchUnit en testImplementation
  And: Existen tests en src/test/java/com/mitoga/architecture/
When: Se ejecutan los tests de arquitectura: `./gradlew test --tests "*.architecture.*"`
Then:
  - El test `HexagonalArchitectureTest` pasa y valida:
    - Domain NO depende de Infrastructure (noClasses().that().resideInAPackage("..domain..").should().dependOnClassesThat().resideInAPackage("..infrastructure.."))
    - Domain NO depende de Application (noClasses().that().resideInAPackage("..domain..").should().dependOnClassesThat().resideInAPackage("..application.."))
    - Infrastructure SÍ puede depender de Domain
    - Application SÍ puede depender de Domain
  - El test `DddLayersTest` pasa y valida:
    - Repositories son interfaces en domain/repository/
    - Aggregates extienden AggregateRoot
    - Value Objects implementan ValueObject
    - Domain Events implementan DomainEvent
  - Todos los tests de arquitectura pasan (0 violations)
```

### Escenario 10: Dockerfile multi-stage funciona
```gherkin
Given: Existe un Dockerfile multi-stage en la raíz del proyecto
When: Se construye la imagen Docker: `docker build -t mitoga-backend:latest .`
Then:
  - El build completa exitosamente en < 5 minutos
  - La imagen final tiene tamaño optimizado (~200-300 MB, no >1 GB)
  - Stage 1 (builder) usa gradle:8.10-jdk21 para compilar
  - Stage 2 (runtime) usa eclipse-temurin:21-jre-alpine para ejecutar
  - El JAR está copiado en /app/mitoga-backend.jar
  - El ENTRYPOINT ejecuta: `java -jar /app/mitoga-backend.jar`
  - El contenedor expone el puerto 8080
  - Al ejecutar `docker run -p 8080:8080 mitoga-backend:latest`, la aplicación inicia exitosamente
```

### Escenario 11: HashiCorp Vault gestiona secrets correctamente
```gherkin
Given: HashiCorp Vault está corriendo en http://192.168.18.38:8300
  And: AppRole está configurado con role-id y secret-id válidos
  And: Secrets están almacenados en backend "mitoga-secrets" bajo contexto "mitoga_project"
When: La aplicación Spring Boot inicia con spring.cloud.vault.enabled=true
Then:
  - La aplicación se autentica exitosamente contra Vault usando AppRole
  - Los logs confirman: "Vault is in an initialized state"
  - Los secrets se obtienen desde Vault path: "mitoga-secrets/mitoga_project"
  - Las propiedades se resuelven dinámicamente desde Vault:
    * ${secret.database.url} = "jdbc:postgresql://192.168.18.30:5432/mitogadb"
    * ${secret.database.username} = "admin"
    * ${secret.database.password} = "admin"
    * ${secret.jwt} = "b6a940428d09875e533038a8e10c128527a0526e08c4a45f94a4c148f3b890a9"
    * ${secret.jwt_refresh_secret} = "a1b2c3d4e5f60718293a4b5c6d7e8f90123456789abcdef0123456789abcdef"
    * ${secret.mail_host} = "smtp.gmail.com"
    * ${secret.redis_host} = "192.168.18.30"
    * ${secret.server.port} = "8082"
  - No hay credenciales hardcodeadas en application.yml
  - Si Vault no está disponible y fail-fast=true, la aplicación NO inicia (falla rápido)
  - El health check de Vault en /actuator/health muestra "UP" cuando está disponible
```

### Escenario 12: Redis se conecta exitosamente para cache y rate limiting
```gherkin
Given: Redis 7 está corriendo en 192.168.18.30:6379
  And: Redis requiere password "admin"
  And: Las credenciales de Redis están en Vault (secret.redis_host, secret.redis_port, secret.redis_password)
When: La aplicación inicia y obtiene credenciales Redis desde Vault
Then:
  - La conexión a Redis se establece exitosamente
  - El pool de conexiones Lettuce se inicializa correctamente
  - Los logs confirman: "Lettuce initialized"
  - Se pueden realizar operaciones básicas: SET, GET, EXPIRE
  - El health check de Redis muestra "UP" en /actuator/health
  - Rate limiting está configurado (redis.rateLimitEnabled desde Vault)
  - Límites por defecto: 100 requests / 60 segundos (desde Vault)
```

---

## 📋 DEFINITION OF DONE (ENTERPRISE-GRADE TDD)

### ✅ Código Implementado

#### Proyecto & Configuración
- [ ] **Proyecto creado** con Spring Boot 3.4.0 + Java 21 LTS
- [ ] **build.gradle.kts configurado** con todas las dependencias necesarias (incluyendo Spring Cloud Vault Config 4.1.3)
- [ ] **settings.gradle.kts** configurado: `rootProject.name = "mitoga-backend"`
- [ ] **gradle.properties** con encoding UTF-8 y Java 21

#### Estructura (Hexagonal + DDD)
- [ ] **Shared Kernel implementado** con Entity, ValueObject, AggregateRoot, DomainEvent, DomainException
- [ ] **8 Bounded Contexts** creados: autenticacion, marketplace, perfiles, reservas, pagos, videollamadas, notificaciones, admin
- [ ] **Cada BC con estructura**: domain/, application/, infrastructure/
- [ ] **Ports base definidos**: UseCase, Command, Query, EventPublisher

#### Configuración Application
- [ ] **application.yml único** configurado con:
  - HashiCorp Vault integration (spring.cloud.vault.*)
  - Datasource (propiedades desde Vault: secret.database.*)
  - JWT secrets (desde Vault: secret.jwt, secret.jwt_refresh_secret)
  - Redis (desde Vault: secret.redis_host, secret.redis_port, secret.redis_password)
  - Email SMTP (desde Vault: secret.mail_*)
  - Server port (desde Vault: secret.server.port = 8082)
  - Rate limiting config (desde Vault: redis.rateLimitEnabled, redis.rate-limit-*)
  - Hikari connection pool
  - JPA/Hibernate
  - Flyway
  - Actuator endpoints
  - Logging levels
- [ ] **No hay archivos application-{profile}.yml** (configuración unificada)
- [ ] **Secrets gestionados 100% por HashiCorp Vault** (no hardcodeados)
- [ ] **22 secrets configurados en Vault:**
  - secret.database.url, username, password, driver
  - secret.jwt, jwt_refresh_secret, jwt_expires_in_minutes, jwt_expires_in_minutes_refresh
  - secret.mail_host, mail_port, mail_username, mail_password, mail_protocol
  - secret.redis_host, redis_port, redis_password
  - secret.server.port, port, server.port.apigateway
  - redis.rateLimitEnabled, rate-limit-default-limit, rate-limit-default-window-seconds

#### Seguridad & Web
- [ ] **GlobalExceptionHandler** implementado (DomainException, EntityNotFoundException, etc.)
- [ ] **ApiResponse<T>** wrapper creado
- [ ] **SecurityConfig** básico configurado
- [ ] **VaultConfig** configurado (AppRole authentication)
- [ ] **JWT configurado** con dual secrets (access + refresh tokens)

#### Base de Datos & Cache
- [ ] **Flyway configurado** en application.yml
- [ ] **V1__init_schema.sql** creado
- [ ] **DatabaseConfig** implementado si necesario
- [ ] **Credenciales DB almacenadas en Vault** (backend: mitoga-secrets, context: mitoga_project)
- [ ] **Redis configurado** para cache y rate limiting
- [ ] **Lettuce connection pool** configurado (max-active: 8, max-idle: 8)

#### Docker & DevOps
- [ ] **Dockerfile multi-stage** creado (builder + runtime)
- [ ] **docker-compose.yml** con PostgreSQL 16 + Redis 7 + PgAdmin
- [ ] **.env.example** creado con variables de entorno de referencia
- [ ] **.dockerignore** configurado

### 🧪 Testing (TDD Standards)

#### Unit Tests
- [ ] **Tests Shared Kernel**: EntityTest, AggregateRootTest, DomainExceptionTest
- [ ] **Coverage >90%** en domain (JaCoCo)
- [ ] **Sin mocks** en domain tests

#### Integration Tests
- [ ] **DatabaseIntegrationTest** con Testcontainers PostgreSQL 16
- [ ] **Test execution** < 30 segundos

#### Architecture Tests (ArchUnit)
- [ ] **HexagonalArchitectureTest**: Domain NO depende de Infrastructure/Application
- [ ] **DddLayersTest**: Repositories interfaces, Aggregates extienden AggregateRoot
- [ ] **0 violations** en todos los tests

#### Test Coverage
- [ ] **JaCoCo configurado** en build.gradle.kts
- [ ] **HTML report** generado en build/reports/jacoco/
- [ ] **Tests pasan**: `./gradlew test` exitoso

### 📝 Documentación

- [ ] **README.md completo** (descripción, stack, arquitectura, setup, comandos)
- [ ] **Javadoc** en clases públicas Shared Kernel
- [ ] **Swagger UI accesible** en /swagger-ui.html
- [ ] **ADR-001** creado (Hexagonal + DDD) si aplica

### 🔒 Seguridad

- [ ] **No passwords hardcoded** (env vars)
- [ ] **No API keys** en código
- [ ] **.env git-ignored**
- [ ] **Logging NO expone secrets**
- [ ] **CORS configurado**
- [ ] **Actuator protegido**

### 🚀 DevOps

- [ ] **Build CI configurado** (GitHub Actions/GitLab CI)
- [ ] **Tests en CI** en cada push
- [ ] **Docker image** construida en CI
- [ ] **Health checks** funcionan
- [ ] **Variables documentadas**

### ✅ Code Quality

- [ ] **Code review aprobado** por Tech Lead
- [ ] **SonarQube**: 0 bugs, 0 vulnerabilidades, deuda <5%
- [ ] **Checkstyle/SpotBugs** pasa
- [ ] **Complejidad** <10 por método
- [ ] **No código comentado**

### 🎯 Funcionalidad Verificada

- [ ] **Aplicación inicia**: `./gradlew bootRun` exitoso
- [ ] **Health check** GET /actuator/health → 200 OK
- [ ] **Swagger UI** carga correctamente
- [ ] **Docker Compose** levanta servicios
- [ ] **Flyway migra** V1 exitosamente
- [ ] **Build JAR** ejecutable funciona
- [ ] **Docker image** ejecutable funciona

### 📦 Entregables

- [ ] **Código committeado** en Git
- [ ] **Commits descriptivos** (conventional commits)
- [ ] **docker-compose.yml funcional**
- [ ] **Dockerfile optimizado** <300MB
- [ ] **.gitignore** configurado
- [ ] **Pull Request** creado y aprobado

---

## 📦 Dependencias Técnicas

### Dependencias previas
- ✅ Ninguna (HUT fundacional)

### Bloquea a
- ⏸️ Todas las HUTs del sistema (fundamento técnico)

### Dependencias externas
- **Java 21 LTS:** OpenJDK / Amazon Corretto / Eclipse Temurin
- **PostgreSQL 16:** Base de datos principal
- **Docker:** Para ejecutar servicios en contenedores
- **Gradle 8.10:** Build tool

---

## 📊 Estimación

**Story Points Técnicos:** 5 SP

**Desglose:**
- Setup proyecto Spring Boot: 1 SP
- Configuración PostgreSQL + Flyway: 1 SP
- Estructura modular (8 módulos): 2 SP
- Docker Compose + Dockerfile: 1 SP

**Tiempo estimado:** 2-3 días (1 desarrollador senior)

---

## 🎯 Notas de Implementación

### Orden de implementación
1. Crear proyecto base con Spring Initializr (Spring Boot 3.4.0, Java 21)
2. Configurar Gradle con Kotlin DSL y dependencias
3. Crear estructura de paquetes para 8 bounded contexts + shared kernel
4. Configurar `application.yml` con perfiles (dev/test/prod)
5. Implementar clases base en `shared` (Entity, ValueObject, AggregateRoot, DomainEvent, DomainException)
6. Crear interfaces base de Ports (UseCase, Command, Query, EventPublisher)
7. Configurar Flyway y crear migración inicial
8. Crear Docker Compose con PostgreSQL y PgAdmin
9. Crear Dockerfile multi-stage
10. Configurar OpenAPI/Swagger
11. Implementar tests de arquitectura (Hexagonal + DDD layers)
12. Verificar que el build, tests y Docker funcionen

### Principios de Arquitectura Hexagonal

**1. Inversión de Dependencias:**
- El dominio **NO** depende de infraestructura
- Infraestructura **SÍ** depende del dominio (implementa ports)
- Application orquesta dominio + puertos

**2. Ports (interfaces):**
- **Input Ports (driving):** Casos de uso que el dominio expone (ej: `RegistrarUsuarioUseCase`)
- **Output Ports (driven):** Servicios que el dominio necesita (ej: `UsuarioRepository`, `EmailSender`)

**3. Adapters (implementaciones):**
- **Input Adapters:** REST controllers, GraphQL resolvers, Message listeners
- **Output Adapters:** JPA repositories, HTTP clients, Email senders, File storage

**4. Flujo de datos:**
```
[REST Controller] → [UseCase Port] → [UseCase Service] → [Domain Model]
                                                       ↓
                                          [Output Port] → [Adapter]
```

**Ejemplo: Registro de Usuario**
```
AutenticacionController (Input Adapter)
    ↓ llama a
RegistrarUsuarioUseCase (Input Port - interface)
    ↓ implementada por
RegistrarUsuarioService (Application Service)
    ↓ usa
Usuario (Aggregate Root - Domain)
    ↓ persiste vía
UsuarioRepository (Output Port - interface)
    ↓ implementada por
UsuarioPersistenceAdapter (Output Adapter - JPA)
```

### Principios de Domain-Driven Design (DDD)

**1. Bounded Contexts (Contextos Delimitados):**
- Cada módulo (autenticacion, reservas, pagos) es un bounded context
- Tiene su propio **modelo de dominio independiente**
- **Lenguaje ubicuo** específico del contexto
- Comunicación entre contextos vía **Domain Events** o **Anti-Corruption Layer**

**2. Aggregates (Agregados):**
- Cluster de objetos tratados como unidad transaccional
- **Aggregate Root** controla acceso al agregado
- Garantiza **invariantes del agregado**
- Ejemplos: `Usuario`, `Reserva`, `Pago`

```java
// Ejemplo: Reserva (Aggregate Root)
public class Reserva extends AggregateRoot {
    private ReservaId id;
    private UsuarioId estudianteId;
    private TutorId tutorId;
    private DateRange fechaHora;  // Value Object
    private EstadoReserva estado;
    private Monto precio;  // Value Object
    
    // Constructor privado: fuerza uso de factory method
    private Reserva() {}
    
    // Factory method con validaciones (invariantes)
    public static Reserva crear(UsuarioId estudiante, TutorId tutor, 
                                 DateRange fecha, Monto precio) {
        validarDisponibilidad(fecha);
        validarPrecioMinimo(precio);
        
        Reserva reserva = new Reserva();
        reserva.id = ReservaId.generate();
        reserva.estudianteId = estudiante;
        reserva.tutorId = tutor;
        reserva.fechaHora = fecha;
        reserva.estado = EstadoReserva.PENDIENTE;
        reserva.precio = precio;
        
        // Emitir evento de dominio
        reserva.registerEvent(new ReservaCreada(reserva.id, estudiante, tutor));
        
        return reserva;
    }
    
    // Método de negocio (NO setter)
    public void confirmar() {
        if (this.estado != EstadoReserva.PENDIENTE) {
            throw new DomainException("Solo se pueden confirmar reservas pendientes");
        }
        this.estado = EstadoReserva.CONFIRMADA;
        this.registerEvent(new ReservaConfirmada(this.id));
    }
    
    // Encapsulación: no exponer setters
    public ReservaId getId() { return id; }
    public EstadoReserva getEstado() { return estado; }
}
```

**3. Entities vs Value Objects:**

**Entities (Entidades):**
- Tienen **identidad única** (ID)
- Mutable (pueden cambiar de estado)
- Igualdad basada en ID
- Ejemplos: Usuario, Tutor, Reserva

**Value Objects (Objetos de Valor):**
- **Sin identidad** (definidos por sus atributos)
- **Inmutables** (no pueden cambiar)
- Igualdad basada en valores
- Pueden ser compartidos
- Ejemplos: Email, Monto, DateRange, Direccion

```java
// Value Object: Monto
@Value  // Lombok: hace la clase inmutable
public class Monto implements ValueObject {
    BigDecimal valor;
    String moneda;
    
    public Monto(BigDecimal valor, String moneda) {
        if (valor == null || valor.compareTo(BigDecimal.ZERO) < 0) {
            throw new DomainException("Monto no puede ser negativo");
        }
        if (moneda == null || !moneda.matches("^[A-Z]{3}$")) {
            throw new DomainException("Moneda inválida");
        }
        this.valor = valor;
        this.moneda = moneda;
    }
    
    public Monto add(Monto otro) {
        if (!this.moneda.equals(otro.moneda)) {
            throw new DomainException("No se pueden sumar montos de diferente moneda");
        }
        return new Monto(this.valor.add(otro.valor), this.moneda);
    }
}
```

**4. Domain Events:**
- Representan algo que **ha ocurrido** en el dominio
- Inmutables
- Pasado gramatical (ej: `UsuarioRegistrado`, no `RegistrarUsuario`)
- Permiten **comunicación asíncrona** entre bounded contexts

```java
@Value
public class ReservaConfirmada implements DomainEvent {
    UUID eventId;
    LocalDateTime occurredOn;
    ReservaId reservaId;
    UsuarioId estudianteId;
    TutorId tutorId;
    
    public ReservaConfirmada(ReservaId reservaId, UsuarioId estudianteId, TutorId tutorId) {
        this.eventId = UUID.randomUUID();
        this.occurredOn = LocalDateTime.now();
        this.reservaId = reservaId;
        this.estudianteId = estudianteId;
        this.tutorId = tutorId;
    }
    
    @Override
    public String getEventType() {
        return "reserva.confirmada";
    }
}
```

**5. Domain Services:**
- Lógica de negocio que **no pertenece a una entidad específica**
- Operaciones que involucran múltiples agregados
- Sin estado (stateless)

```java
// Domain Service
@Service
public class DisponibilidadService {
    
    public boolean estaDisponible(TutorId tutorId, DateRange fechaHora) {
        // Lógica de negocio compleja que consulta múltiples agregados
        // NO pertenece ni a Tutor ni a Reserva
        return verificarHorarios(tutorId, fechaHora);
    }
}
```

**6. Repositories (Ports):**
- Interfaces definidas en el dominio
- Implementadas en infraestructura
- **Abstracción de persistencia**
- Solo para Aggregate Roots

```java
// Port (interface en domain/repository/)
public interface UsuarioRepository {
    Usuario findById(UsuarioId id);
    Usuario findByEmail(Email email);
    void save(Usuario usuario);
    void delete(UsuarioId id);
}

// Adapter (implementación en infrastructure/adapter/out/persistence/)
@Component
public class UsuarioPersistenceAdapter implements UsuarioRepository {
    
    private final UsuarioJpaRepository jpaRepository;
    private final UsuarioPersistenceMapper mapper;
    
    @Override
    public Usuario findById(UsuarioId id) {
        return jpaRepository.findById(id.getValue())
                .map(mapper::toDomain)
                .orElseThrow(() -> new UsuarioNotFoundException(id));
    }
    
    @Override
    public void save(Usuario usuario) {
        UsuarioJpaEntity entity = mapper.toEntity(usuario);
        jpaRepository.save(entity);
    }
}
```

### Separación Domain Model vs Persistence Model

**Importante:** No mezclar anotaciones JPA en el dominio

**Domain Model (dominio puro):**
```java
// domain/model/Usuario.java
public class Usuario extends AggregateRoot {
    private UsuarioId id;
    private Email email;
    private Password password;
    private RolUsuario rol;
    
    // Sin anotaciones JPA
    // Solo lógica de negocio
}
```

**Persistence Model (infraestructura):**
```java
// infrastructure/adapter/out/persistence/UsuarioJpaEntity.java
@Entity
@Table(name = "usuarios")
public class UsuarioJpaEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String email;
    
    @Column(nullable = false)
    private String passwordHash;
    
    @Enumerated(EnumType.STRING)
    private RolUsuario rol;
    
    // Mapper: Domain ↔ JPA Entity
}
```

### Anti-Corruption Layer (ACL)

Proteger el dominio de modelos externos:

```java
// infrastructure/adapter/out/stripe/StripePaymentAdapter.java
@Component
public class StripePaymentAdapter implements PaymentPort {
    
    private final StripeClient stripeClient;
    
    @Override
    public PagoResult procesarPago(Pago pago) {
        // Mapear Pago (dominio) → PaymentIntent (Stripe)
        PaymentIntentCreateParams params = PaymentIntentCreateParams.builder()
                .setAmount(pago.getMonto().getValor().longValue())
                .setCurrency(pago.getMonto().getMoneda().toLowerCase())
                .build();
        
        PaymentIntent intent = stripeClient.createPaymentIntent(params);
        
        // Mapear PaymentIntent (Stripe) → PagoResult (dominio)
        return mapToDomain(intent);
    }
}
```

### Patrón Repository (Port)
- Interfaces en `domain/repository/` (contrato del dominio)
- Implementaciones en `infrastructure/adapter/out/persistence/` (JPA)
- Separación entre entidades JPA (`*JpaEntity.java`) y modelos de dominio (`*.java`)
- Mapper entre domain ↔ persistence

### Tests de Arquitectura (ArchUnit)

```java
@AnalyzeClasses(packages = "com.mitoga")
public class HexagonalArchitectureTest {
    
    @ArchTest
    static final ArchRule domain_should_not_depend_on_infrastructure =
        noClasses()
            .that().resideInAPackage("..domain..")
            .should().dependOnClassesThat()
            .resideInAPackage("..infrastructure..");
    
    @ArchTest
    static final ArchRule domain_should_not_depend_on_spring =
        noClasses()
            .that().resideInAPackage("..domain..")
            .should().dependOnClassesThat()
            .resideInAPackage("org.springframework..");
}
```

---

## ⚠️ RIESGOS TÉCNICOS Y MITIGACIONES

### Riesgo 1: Complejidad de Arquitectura Hexagonal + DDD para Equipo Junior
**Probabilidad:** ALTA  
**Impacto:** ALTO  
**Descripción:** Arquitectura Hexagonal y DDD tienen curva de aprendizaje empinada. Equipo junior puede tener dificultades entendiendo Ports/Adapters, Aggregates, Value Objects, Domain Events.

**Mitigaciones:**
- ✅ **Training Session:** Sesión de 4-6 horas explicando Hexagonal Architecture y DDD táctico
- ✅ **Pair Programming:** Seniors mentorean juniors en primeras HUTs (HUT-001-DOM-01, HUT-001-INFRA-01)
- ✅ **Code Examples:** Shared Kernel con ejemplos completos y Javadoc extenso
- ✅ **ADR-001:** Architecture Decision Record documenta decisiones y alternativas
- ✅ **ArchUnit Tests:** Validan arquitectura automáticamente (evita violaciones accidentales)

### Riesgo 2: Separación Domain Model vs Persistence Model (Overhead de Mappers)
**Probabilidad:** MEDIA  
**Impacto:** MEDIO  
**Descripción:** Mantener dos modelos (Domain y JPA Entity) + mappers agrega código y esfuerzo. Riesgo de deuda técnica si mappers no se mantienen sincronizados.

**Mitigaciones:**
- ✅ **MapStruct:** Generación automática de mappers (reduce código manual)
- ✅ **Tests de Mappers:** Integration tests validan mapping bidireccional (toDomain/toEntity)
- ✅ **Clear Naming:** Convención: `Usuario` (domain), `UsuarioJpaEntity` (persistence), `UsuarioPersistenceMapper`
- ✅ **Documentación:** README explica beneficios (domain puro, tests sin BD, independencia JPA)
- ⚠️ **Aceptar Trade-off:** Más código, pero dominio limpio y testeable (decisión arquitectónica consciente)

### Riesgo 3: Performance con JPA y Lazy Loading en Aggregates Complejos
**Probabilidad:** MEDIA  
**Impacto:** ALTO (en producción)  
**Descripción:** Aggregates con múltiples entidades internas pueden causar N+1 queries si no se configuran correctamente fetch strategies en JPA.

**Mitigaciones:**
- ✅ **Fetch Strategies:** Configurar `@OneToMany(fetch = LAZY)` en relaciones no críticas
- ✅ **JOIN FETCH:** Usar JPQL con JOIN FETCH en queries que necesitan entidades relacionadas
- ✅ **DTOs para Queries:** CQRS pattern - queries complejas usan proyecciones SQL (no Aggregates)
- ✅ **Monitoring:** Configurar Hibernate statistics y log SQL queries en dev (`spring.jpa.show-sql=true`)
- ✅ **Performance Tests:** JMeter/Gatling tests detectan N+1 queries en stage/pre-prod

### Riesgo 4: Docker en Máquinas Windows de Desarrollo (WSL2, Networking)
**Probabilidad:** MEDIA  
**Impacto:** MEDIO  
**Descripción:** Docker Desktop en Windows puede tener issues con WSL2, networking (localhost vs host.docker.internal), performance lento.

**Mitigaciones:**
- ✅ **WSL2 Habilitado:** Asegurar que Docker usa WSL2 backend (no Hyper-V legacy)
- ✅ **Documentación:** README con troubleshooting para Windows (firewall, WSL2, networking)
- ✅ **Alternativa:** PostgreSQL local (sin Docker) para devs con problemas en Docker Windows
- ✅ **Host Networking:** `docker-compose.yml` usa `localhost` y ports mapping explícito (no `host.docker.internal`)
- ✅ **CI/CD en Linux:** Pipeline CI usa Linux (GitHub Actions/GitLab CI) - más confiable

### Riesgo 5: Java 21 LTS - Features Modernas No Familiares (Records, Pattern Matching, Virtual Threads)
**Probabilidad:** BAJA  
**Impacto:** BAJO  
**Descripción:** Java 21 tiene features nuevas (Records, Sealed Classes, Pattern Matching) que equipo puede no conocer.

**Mitigaciones:**
- ✅ **Code Examples:** Value Objects usan `@Value` (Lombok) o Records de Java 21
- ✅ **Training Material:** Links a JEP (JDK Enhancement Proposals) en README
- ✅ **Optional Features:** Virtual Threads opcionales (no obligatorio para MVP)
- ✅ **Fallback:** Si equipo no conoce Records, usar clases tradicionales con Lombok `@Data`
- ⚠️ **Bajo Riesgo:** Java 21 es mayormente backwards compatible con Java 17/11

### Riesgo 6: Flyway Migrations en Producción (Downtime, Rollback)
**Probabilidad:** BAJA  
**Impacto:** CRÍTICO (en prod)  
**Descripción:** Migrations mal escritas pueden causar downtime en producción, pérdida de datos, o imposibilidad de rollback.

**Mitigaciones:**
- ✅ **Blue-Green Deployment:** Deploy nueva versión en paralelo, switch DNS cuando esté lista
- ✅ **Backwards Compatible Migrations:** Nunca DROP column en mismo release (split en 2 releases)
- ✅ **Rollback Scripts:** Crear V*__rollback.sql para cada migración crítica (manual)
- ✅ **Testing en Staging:** Ejecutar migrations en staging con copia de datos prod (anonymized)
- ✅ **Database Backups:** Backup automático ANTES de cada migration en prod
- ✅ **Flyway Baseline:** Usar `baseline-on-migrate=true` para legacy databases

### Riesgo 7: Bounded Contexts Demasiado Granulares (Over-engineering)
**Probabilidad:** BAJA  
**Impacto:** MEDIO  
**Descripción:** 8 Bounded Contexts puede ser excesivo para MVP. Overhead de estructura sin beneficio real si contextos están vacíos.

**Mitigaciones:**
- ✅ **Implementación Incremental:** Comenzar con 2-3 BCs críticos (autenticacion, reservas, pagos)
- ✅ **Carpetas Vacías OK:** Tener estructura preparada sin código está bien (preparación futura)
- ✅ **Refactor Later:** Si BC resulta muy pequeño, merge con otro (decisión post-MVP)
- ⚠️ **Aceptar Trade-off:** Mejor preparar estructura ahora que refactorizar después (menor riesgo)

### Riesgo 8: Tests de Arquitectura (ArchUnit) Bloqueando Builds por False Positives
**Probabilidad:** BAJA  
**Impacto:** MEDIO  
**Descripción:** ArchUnit rules muy estrictas pueden generar false positives y bloquear builds legítimos.

**Mitigaciones:**
- ✅ **Empezar Simple:** 2-3 reglas básicas (domain no depende de infra, repositories interfaces)
- ✅ **Refinar Incrementalmente:** Agregar reglas según se descubren violaciones reales
- ✅ **Excepciones Documentadas:** `@ArchIgnore` para casos edge legítimos (con comentario explicativo)
- ✅ **Code Review:** Tech Lead revisa nuevas reglas ArchUnit antes de merge
- ⚠️ **Desactivar Temporalmente:** Si bloquea deploy urgente, comentar test (pero documentar en issue)

### Riesgo 9: Disponibilidad de HashiCorp Vault (Single Point of Failure)
**Probabilidad:** MEDIA  
**Impacto:** CRÍTICO  
**Descripción:** Si Vault no está disponible y fail-fast=true, la aplicación no inicia. Vault se convierte en un Single Point of Failure (SPOF) para el arranque de la aplicación.

**Mitigaciones:**
- ✅ **Vault HA Setup:** Configurar Vault en modo High Availability (3+ nodos con Raft/Consul backend)
- ✅ **Health Checks:** Monitoreo activo de Vault (Prometheus + alertas si Vault down)
- ✅ **Fallback Mechanism:** Para dev/local, permitir `CONFIG_VAULT_ENABLED=false` con secrets en application.yml (NO en prod)
- ✅ **Retry Logic:** Configurar spring.cloud.vault.fail-fast=false en dev para reintentos automáticos
- ✅ **Disaster Recovery:** Documentar procedimiento de restauración de Vault desde backups
- ✅ **Network Resilience:** Vault en red confiable (no internet público, VPN/private network)
- ⚠️ **Aceptar Trade-off:** Vault centralizado mejora seguridad pero requiere infraestructura robusta

---

## 📚 REFERENCIAS Y RECURSOS

### Arquitectura Hexagonal (Ports & Adapters)
- **Alistair Cockburn - Hexagonal Architecture (2005):** http://alistair.cockburn.us/Hexagonal+architecture
- **Tom Hombergs - Get Your Hands Dirty on Clean Architecture (2019):** Libro práctico con Spring Boot
- **Netflix TechBlog - Hexagonal Architecture:** https://netflixtechblog.com/ready-for-changes-with-hexagonal-architecture-b315ec967749

### Domain-Driven Design (DDD)
- **Eric Evans - Domain-Driven Design: Tackling Complexity (Blue Book):** El libro fundacional (2003)
- **Vaughn Vernon - Implementing Domain-Driven Design (Red Book):** Guía práctica de implementación (2013)
- **Vaughn Vernon - Domain-Driven Design Distilled:** Resumen ejecutivo para equipos (2016)
- **Martin Fowler - DDD Aggregate:** https://martinfowler.com/bliki/DDD_Aggregate.html
- **Eric Evans - DDD Reference (PDF gratuito):** Guía de referencia rápida de patrones

### Spring Boot & Java 21
- **Spring Boot 3.4 Reference Documentation:** https://docs.spring.io/spring-boot/docs/3.4.0/reference/html/
- **Spring Data JPA Reference:** https://docs.spring.io/spring-data/jpa/docs/current/reference/html/
- **Java 21 Release Notes:** https://openjdk.org/projects/jdk/21/
- **Baeldung - Spring Boot Tutorials:** https://www.baeldung.com/spring-boot

### Testing
- **Testcontainers Documentation:** https://testcontainers.com/
- **ArchUnit User Guide:** https://www.archunit.org/userguide/html/000_Index.html
- **JUnit 5 User Guide:** https://junit.org/junit5/docs/current/user-guide/

### Flyway & Database Migrations
- **Flyway Documentation:** https://flywaydb.org/documentation/
- **Martin Fowler - Evolutionary Database Design:** https://martinfowler.com/articles/evodb.html

### Docker & DevOps
- **Docker Best Practices:** https://docs.docker.com/develop/dev-best-practices/
- **Docker Compose Reference:** https://docs.docker.com/compose/compose-file/

### HashiCorp Vault & Secrets Management
- **HashiCorp Vault Documentation:** https://developer.hashicorp.com/vault/docs
- **Spring Cloud Vault Reference:** https://docs.spring.io/spring-cloud-vault/reference/
- **Vault AppRole Authentication:** https://developer.hashicorp.com/vault/docs/auth/approle
- **Vault KV Secrets Engine:** https://developer.hashicorp.com/vault/docs/secrets/kv
- **Best Practices for Vault:** https://developer.hashicorp.com/vault/tutorials/operations/production-hardening

---

## 📝 NOTAS FINALES

### Decisiones Arquitectónicas Clave

1. **Monolito Modular (no Microservicios inicialmente):**
   - **Razón:** Simplicidad operacional para MVP, un solo despliegue, un solo proceso
   - **Preparación futura:** Bounded Contexts independientes permiten extraer microservicios después

2. **Hexagonal Architecture + DDD:**
   - **Razón:** Dominio rico alineado con negocio, testeabilidad, independencia de frameworks
   - **Trade-off:** Más código (mappers, ports, adapters) pero mayor flexibilidad

3. **Java 21 LTS (no Java 17):**
   - **Razón:** Virtual Threads, Records, Pattern Matching - features modernas útiles
   - **Trade-off:** Equipo necesita familiarizarse, pero backwards compatible

4. **PostgreSQL 16 (no MySQL):**
   - **Razón:** Mejor soporte JSON, CTE, Window Functions, MVCC más robusto
   - **Trade-off:** Ninguno significativo

5. **Gradle con Kotlin DSL (no Maven, no Groovy):**
   - **Razón:** Kotlin DSL type-safe, mejor autocompletado IDE, más legible que Groovy
   - **Trade-off:** Sintaxis diferente a Maven (curva aprendizaje menor)

6. **HashiCorp Vault para Secrets (no variables de entorno):**
   - **Razón:** Gestión centralizada de credenciales, rotación automática, auditoría completa
   - **Trade-off:** Dependencia adicional (requiere infra Vault), pero mejora seguridad enterprise-grade
   - **application.yml único:** No profiles separados, configuración centralizada en Vault
   - **AppRole authentication:** Método seguro para apps (no tokens estáticos)
   - **22 secrets gestionados:** DB, JWT (dual: access + refresh), Redis, Email SMTP, Server ports, Rate limiting

### Configuración de Servicios Externos

**Base de Datos:**
- PostgreSQL 16 en `192.168.18.30:5432`
- Database: `mitogadb`
- Credenciales: `admin/admin` (almacenadas en Vault)

**Cache & Rate Limiting:**
- Redis 7 en `192.168.18.30:6379`
- Password: `admin` (almacenado en Vault)
- Rate Limiting: 100 requests / 60 segundos (configurable)

**Email SMTP:**
- Gmail SMTP: `smtp.gmail.com:587`
- Cuenta: `noreply.mitoga@gmail.com`
- App Password: `chey qrke vtgq vctp` (almacenado en Vault)

**HashiCorp Vault:**
- Vault Server: `http://192.168.18.38:8300`
- Backend: `mitoga-secrets`
- Context: `mitoga_project`
- Authentication: AppRole (role-id + secret-id)

### Próximos Pasos (Post Setup)

1. **HUT-001-DOM-01:** Implementar Aggregate `Usuario` con Value Objects (Email, Password)
2. **HUT-001-INFRA-01:** Implementar UsuarioRepository JPA con mapper domain/entity
3. **HUT-001-UC-01:** Implementar RegistrarUsuarioUseCase (Command pattern)
4. **HUT-001-API-01:** Implementar POST /api/v1/usuarios/registro (REST Controller)
5. **HUT-001-SEC-01:** Implementar hash password con BCrypt
6. **HUT-001-TEST-01:** Implementar tests E2E de registro de usuario

### Contacto Técnico

- **Tech Lead:** [Nombre] - [email@example.com]
- **Arquitecto de Soluciones:** [Nombre] - [email@example.com]
- **Repositorio:** https://github.com/mitoga/mitoga-backend
- **Wiki Técnica:** https://github.com/mitoga/mitoga-backend/wiki

---

**Versión del Documento:** 1.3  
**Última Actualización:** 2025-11-08  
**Autor:** Equipo Backend MI-TOGA  
**Revisado por:** Tech Lead Senior  

**Changelog:**
- **v1.3 (2025-11-08):** Configuración completa de secrets reales desde Vault (22 secrets), integración Redis para cache/rate-limiting, configuración Email SMTP, server port 8082
- **v1.2 (2025-11-08):** Integración HashiCorp Vault para gestión centralizada de secrets, application.yml único
- **v1.1 (2025-11-08):** Mejora enterprise-grade con estándares TDD, Given-When-Then detallados, riesgos técnicos
- **v1.0 (2025-11-08):** Versión inicial

---
    
    @ArchTest
    static final ArchRule aggregates_should_extend_aggregate_root =
        classes()
            .that().areAnnotatedWith(AggregateRoot.class)
            .should().beAssignableTo(AggregateRoot.class);
}
```

---

## ⚠️ Riesgos Técnicos

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| Incompatibilidad Java 21 con librerías | Baja | Alto | Verificar compatibilidad en documentación oficial |
| Problemas con Flyway en PostgreSQL 16 | Baja | Medio | Usar versión Flyway 10.17+ con soporte explícito |
| Complejidad estructura modular | Media | Medio | Empezar simple, refactorizar progresivamente |
| Performance de Hibernate | Media | Alto | Configurar batch inserts, lazy loading, índices apropiados |

---

## 🔗 Referencias

- [Spring Boot 3.4 Documentation](https://docs.spring.io/spring-boot/docs/3.4.0/reference/html/)
- [Java 21 Features](https://openjdk.org/projects/jdk/21/)
- [PostgreSQL 16 Documentation](https://www.postgresql.org/docs/16/)
- [Flyway Documentation](https://flywaydb.org/documentation/)

**Arquitectura Hexagonal:**
- [Hexagonal Architecture - Alistair Cockburn](https://alistair.cockburn.us/hexagonal-architecture/)
- [Ports and Adapters Pattern](https://herbertograca.com/2017/09/14/ports-adapters-architecture/)
- [Get Your Hands Dirty on Clean Architecture - Tom Hombergs](https://reflectoring.io/book/)

**Domain-Driven Design:**
- [Domain-Driven Design - Eric Evans (Blue Book)](https://www.domainlanguage.com/ddd/)
- [Implementing Domain-Driven Design - Vaughn Vernon (Red Book)](https://vaughnvernon.com/iddd/)
- [DDD Reference - Eric Evans](https://www.domainlanguage.com/ddd/reference/)
- [DDD Aggregates - Martin Fowler](https://martinfowler.com/bliki/DDD_Aggregate.html)
- [Value Objects - Martin Fowler](https://martinfowler.com/bliki/ValueObject.html)
- [Domain Events - Martin Fowler](https://martinfowler.com/eaaDev/DomainEvent.html)

**Patrones:**
- [Repository Pattern - Martin Fowler](https://martinfowler.com/eaaCatalog/repository.html)
- [Unit of Work - Martin Fowler](https://martinfowler.com/eaaCatalog/unitOfWork.html)
- [Anti-Corruption Layer - Microsoft](https://learn.microsoft.com/en-us/azure/architecture/patterns/anti-corruption-layer)

---

**Generado con:** ZNS v2.0 - Technical User Stories Architect  
**Versión HUT:** 1.0  
**Última actualización:** 2025-11-08
