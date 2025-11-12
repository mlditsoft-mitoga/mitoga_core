# Módulo 00: Setup & Infraestructura Base

## 📋 Descripción

Historias Técnicas (HUTs) fundacionales para establecer la infraestructura base del backend MI-TOGA.

**Objetivo:** Configurar el proyecto Spring Boot con Java 21, arquitectura hexagonal, Domain-Driven Design (DDD) y conexión a PostgreSQL.

---

## 📊 Resumen

| Métrica | Valor |
|---------|-------|
| **Total HUTs** | 1 |
| **Story Points Técnicos** | 5 SP |
| **Prioridad** | CRITICAL |
| **Sprint** | Sprint 0 (Setup) |

---

## 🎯 HUTs Incluidas

### HUT-000-INFRA-01: Setup Proyecto Backend Spring Boot con Java 21 (5 SP)

**Tipo:** INFRA  
**Estado:** ⏸️ Pendiente  
**Descripción:** Configurar proyecto Spring Boot 3.4.x con Java 21 LTS, arquitectura hexagonal (Ports & Adapters), Domain-Driven Design, PostgreSQL

**Arquitectura:**
- **Hexagonal (Ports & Adapters):** Separación dominio-infraestructura
- **Domain-Driven Design:** Bounded contexts, Aggregates, Value Objects, Domain Events
- **Monolito Modular:** 8 bounded contexts independientes

**Stack Tecnológico:**
- Java 21 LTS (Records, Pattern Matching, Virtual Threads)
- Spring Boot 3.4.0
- Gradle 8.10 con Kotlin DSL
- PostgreSQL 16.x
- Flyway 10.17.0 (migraciones DB)
- Docker + Docker Compose

**Bounded Contexts (DDD):**
```
mitoga-backend/
├── shared/              # Shared Kernel
├── autenticacion/       # BC 1: Gestión usuarios
├── marketplace/         # BC 2: Búsqueda tutores
├── perfiles/           # BC 3: Perfiles usuarios
├── reservas/           # BC 4: Sistema reservas
├── pagos/              # BC 5: Procesamiento pagos
├── videollamadas/      # BC 6: Sesiones video
├── notificaciones/     # BC 7: Comunicaciones
└── admin/              # BC 8: Administración
```

**Capas por Bounded Context (Hexagonal):**
- `domain/` — Núcleo hexágono (Aggregates, Entities, VOs, Ports, Domain Services)
- `application/` — Casos de uso (Commands, Queries, DTOs)
- `infrastructure/adapter/` — Adaptadores (REST, JPA, APIs externas)
  - `in/` — Input Adapters (Controllers)
  - `out/` — Output Adapters (Repositories, HTTP clients)

**Dependencias clave:**
- Spring Boot Starters (web, data-jpa, security, validation, actuator)
- PostgreSQL driver + Flyway
- Lombok + MapStruct
- SpringDoc OpenAPI (Swagger UI)
- Testcontainers (tests de integración)

**Bloquea a:**
- Todas las HUTs del sistema (fundamento técnico)

[Ver detalle completo →](HUT-000-INFRA-01-setup-proyecto-backend.md)

---

## 🏗️ Arquitectura

### Hexagonal Architecture (Ports & Adapters)

```
┌─────────────────────────────────────────────┐
│       INPUT ADAPTERS (Driving)              │
│  REST Controllers · GraphQL · MQ Listeners  │
└─────────────────────────────────────────────┘
              ↓ llama a
┌─────────────────────────────────────────────┐
│           INPUT PORTS (Use Cases)            │
│  Interfaces que expone el dominio            │
└─────────────────────────────────────────────┘
              ↓ implementados por
┌─────────────────────────────────────────────┐
│        APPLICATION LAYER (Orquestación)      │
│  Commands · Queries · DTOs                   │
└─────────────────────────────────────────────┘
              ↓ usa
┌─────────────────────────────────────────────┐
│   DOMAIN LAYER (Núcleo del Hexágono)        │
│  Aggregates · Entities · Value Objects      │
│  Domain Services · Business Rules           │
│  Output Ports (interfaces)                  │
└─────────────────────────────────────────────┘
              ↑ implementan
┌─────────────────────────────────────────────┐
│      OUTPUT ADAPTERS (Driven)               │
│  JPA Repos · HTTP Clients · Email Senders   │
└─────────────────────────────────────────────┘
```

**Flujo de una petición:**
```
1. REST Controller (Input Adapter)
   ↓ mapea DTO → Command
2. UseCase Interface (Input Port)
   ↓ invoca
3. UseCase Implementation (Application)
   ↓ usa
4. Aggregate Root (Domain)
   ↓ necesita persistencia
5. Repository Interface (Output Port - domain)
   ↓ implementado por
6. JPA Adapter (Output Adapter - infrastructure)
```

### Domain-Driven Design (DDD)

**Conceptos clave:**

**1. Bounded Context (Contexto Delimitado):**
- Cada módulo es un contexto con su propio modelo
- Lenguaje ubicuo específico del contexto
- Independencia entre contextos

**2. Aggregates (Agregados):**
```java
// Ejemplo: Reserva (Aggregate Root)
public class Reserva extends AggregateRoot {
    private ReservaId id;              // Identity
    private UsuarioId estudianteId;    // Reference to another Aggregate
    private TutorId tutorId;           // Reference to another Aggregate
    private DateRange fechaHora;       // Value Object
    private Monto precio;              // Value Object
    private EstadoReserva estado;      // Enum
    
    // Factory method
    public static Reserva crear(...) {
        // Validar invariantes
        // Crear instancia
        // Emitir evento
    }
    
    // Métodos de negocio (NO setters)
    public void confirmar() { ... }
    public void cancelar() { ... }
}
```

**3. Value Objects (Objetos de Valor):**
```java
// Ejemplo: Email (inmutable, sin identidad)
@Value
public class Email implements ValueObject {
    String value;
    
    public Email(String value) {
        // Validar formato
        this.value = value.toLowerCase().trim();
    }
}
```

**4. Domain Events (Eventos de Dominio):**
```java
// Ejemplo: ReservaConfirmada
@Value
public class ReservaConfirmada implements DomainEvent {
    UUID eventId;
    LocalDateTime occurredOn;
    ReservaId reservaId;
    
    @Override
    public String getEventType() {
        return "reserva.confirmada";
    }
}
```

### Principios

**Hexagonal:**
- **Inversión de Dependencias:** Dominio no depende de infraestructura
- **Ports:** Interfaces que definen contratos
- **Adapters:** Implementaciones concretas intercambiables
- **Testeabilidad:** Dominio testeable sin frameworks

**DDD:**
- **Lenguaje Ubicuo:** Código refleja lenguaje del negocio
- **Modelo Rico:** Entidades con comportamiento, no anémicas
- **Agregados:** Garantizan consistencia transaccional
- **Bounded Contexts:** Separación de responsabilidades

---

## 🚀 Cómo Empezar

### Prerequisitos
- **Java 21 LTS** instalado ([Amazon Corretto](https://docs.aws.amazon.com/corretto/latest/corretto-21-ug/downloads-list.html) recomendado)
- **Docker Desktop** instalado y corriendo
- **Gradle 8.10+** (o usar Gradle Wrapper incluido)
- IDE con soporte Java 21 (IntelliJ IDEA 2024.x, Eclipse, VSCode con Java Extension Pack)

### Setup Inicial

**1. Levantar servicios Docker:**
```bash
cd mitoga-backend
docker-compose up -d
```

Esto levanta:
- PostgreSQL en `localhost:5432`
- PgAdmin en `http://localhost:5050`

**2. Verificar PostgreSQL:**
```bash
# Acceder a PgAdmin: http://localhost:5050
# Email: admin@mitoga.com
# Password: admin123

# O desde terminal:
docker exec -it mitoga-postgres psql -U mitoga_user -d mitoga_dev
```

**3. Compilar proyecto:**
```bash
./gradlew clean build
```

**4. Ejecutar aplicación:**
```bash
./gradlew bootRun

# O con perfil específico:
./gradlew bootRun --args='--spring.profiles.active=dev'
```

**5. Verificar que funciona:**
- Health check: http://localhost:8080/api/v1/actuator/health
- Swagger UI: http://localhost:8080/api/v1/swagger-ui.html
- Métricas: http://localhost:8080/api/v1/actuator/metrics

---

## 🧪 Testing

### Ejecutar todos los tests:
```bash
./gradlew test
```

### Tests de arquitectura:
```bash
./gradlew test --tests "com.mitoga.architecture.ArchitectureTest"
```

### Tests con cobertura:
```bash
./gradlew test jacocoTestReport
# Ver reporte en: build/reports/jacoco/test/html/index.html
```

---

## 📦 Build & Deploy

### Crear JAR ejecutable:
```bash
./gradlew bootJar
# Output: build/libs/mitoga-backend.jar
```

### Crear imagen Docker:
```bash
docker build -t mitoga-backend:1.0.0 .
```

### Ejecutar en Docker:
```bash
docker run -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=prod \
  -e DB_PASSWORD=secret \
  -e JWT_SECRET=super-secret-key \
  mitoga-backend:1.0.0
```

---

## 🔧 Configuración

### Perfiles disponibles:
- **dev:** Desarrollo local con logs detallados
- **test:** Tests automatizados (usa Testcontainers)
- **prod:** Producción con seguridad habilitada

### Variables de entorno:
```bash
# Base de datos
DB_PASSWORD=<password-postgres>

# Seguridad
JWT_SECRET=<clave-firma-jwt-256-bits>

# Opcional
SPRING_PROFILES_ACTIVE=dev
SERVER_PORT=8080
```

---

## 📚 Documentación Técnica

### API Documentation
- **Swagger UI:** http://localhost:8080/api/v1/swagger-ui.html
- **OpenAPI JSON:** http://localhost:8080/api/v1/api-docs

### Endpoints de Actuator
- `/actuator/health` — Estado de la aplicación
- `/actuator/info` — Información del build
- `/actuator/metrics` — Métricas de runtime
- `/actuator/prometheus` — Métricas formato Prometheus

### Base de Datos
- **Host:** localhost:5432
- **Database:** mitoga_dev
- **User:** mitoga_user
- **Password:** mitoga_dev_pass (dev only)
- **PgAdmin:** http://localhost:5050

---

## ⚠️ Troubleshooting

### Error: "Port 5432 already in use"
```bash
# Verificar si hay otro PostgreSQL corriendo
lsof -i :5432
# Detener el proceso o cambiar puerto en docker-compose.yml
```

### Error: "Cannot resolve symbol 'lombok'"
```bash
# Habilitar annotation processing en el IDE
# IntelliJ: Settings > Build > Compiler > Annotation Processors > Enable
```

### Error: "Flyway migration failed"
```bash
# Limpiar schema y reintentar
docker-compose down -v
docker-compose up -d
./gradlew flywayClean flywayMigrate
```

---

## 🔗 Referencias

- [Spring Boot 3.4 Docs](https://docs.spring.io/spring-boot/docs/3.4.0/reference/html/)
- [PostgreSQL 16 Docs](https://www.postgresql.org/docs/16/)
- [Gradle Docs](https://docs.gradle.org/current/userguide/userguide.html)

**Arquitectura Hexagonal:**
- [Hexagonal Architecture - Alistair Cockburn](https://alistair.cockburn.us/hexagonal-architecture/)
- [Ports and Adapters Pattern](https://herbertograca.com/2017/09/14/ports-adapters-architecture/)
- [Get Your Hands Dirty on Clean Architecture - Tom Hombergs](https://reflectoring.io/book/)

**Domain-Driven Design:**
- [Domain-Driven Design - Eric Evans](https://www.domainlanguage.com/ddd/)
- [Implementing Domain-Driven Design - Vaughn Vernon](https://vaughnvernon.com/iddd/)
- [DDD Reference](https://www.domainlanguage.com/ddd/reference/)
- [Aggregates - Martin Fowler](https://martinfowler.com/bliki/DDD_Aggregate.html)
- [Value Objects - Martin Fowler](https://martinfowler.com/bliki/ValueObject.html)

---

**Última actualización:** 2025-11-08  
**Versión:** 1.0.0
