# 📋 Plan de Refactorización - Bounded Contexts

## 🎯 Objetivo
Alinear la estructura actual del proyecto con los **8 Bounded Contexts** definidos en el README del backend, aplicando Domain-Driven Design y Arquitectura Hexagonal.

---

## 📊 Estado Actual vs Estado Objetivo

### ✅ Estado Actual (3 módulos migrados)
```
src/main/java/com/mitoga/
├── estudiantes/          ⚠️ MEZCLA: Autenticación + Perfiles
│   ├── domain/
│   ├── application/
│   └── infrastructure/
├── archivos/             ⚠️ INFRAESTRUCTURA COMPARTIDA (no es BC)
│   ├── domain/
│   ├── application/
│   └── infrastructure/
├── notificaciones/       ✅ CORRECTO (BC Notificaciones)
│   ├── domain/
│   ├── application/
│   └── infrastructure/
└── shared/               ✅ CORRECTO (Shared Kernel)
    └── domain/
```

### 🎯 Estado Objetivo (8 Bounded Contexts)

```
src/main/java/com/mitoga/
├── autenticacion/        🆕 NUEVO - Separar de estudiantes
│   ├── domain/
│   │   ├── model/        (Usuario, Credenciales, Token)
│   │   ├── repository/   (UsuarioRepository, TokenRepository)
│   │   └── exception/
│   ├── application/
│   │   ├── port/
│   │   │   ├── input/    (RegistrarUsuarioUseCase, LoginUseCase, RefreshTokenUseCase)
│   │   │   └── output/   (UsuarioRepositoryPort, TokenRepositoryPort, EmailPort)
│   │   ├── service/      (RegistrarUsuarioService, LoginService)
│   │   └── command/      (RegistrarUsuarioCommand, LoginCommand)
│   └── infrastructure/
│       ├── persistence/  (UsuarioPersistenceAdapter, UsuarioJpaRepository)
│       ├── security/     (JwtTokenProvider, SecurityConfig)
│       └── web/          (AutenticacionController)
│
├── marketplace/          🆕 NUEVO - Catálogo de tutores
│   ├── domain/
│   │   ├── model/        (Tutor, Categoria, Especialidad, Busqueda)
│   │   ├── repository/   (TutorRepository, CategoriaRepository)
│   │   └── exception/
│   ├── application/
│   │   ├── port/
│   │   │   ├── input/    (BuscarTutoresUseCase, ListarCategoriasUseCase)
│   │   │   └── output/   (TutorRepositoryPort, BusquedaPort)
│   │   ├── service/      (BuscarTutoresService, FiltroService)
│   │   └── query/        (BuscarTutoresQuery, FiltrarPorCategoriaQuery)
│   └── infrastructure/
│       ├── persistence/  (TutorPersistenceAdapter, TutorJpaRepository)
│       ├── search/       (ElasticsearchAdapter - futuro)
│       └── web/          (MarketplaceController)
│
├── perfiles/             🆕 NUEVO - Separar de estudiantes
│   ├── domain/
│   │   ├── model/        (PerfilEstudiante, PerfilTutor, Experiencia, Educacion)
│   │   ├── repository/   (PerfilEstudianteRepository, PerfilTutorRepository)
│   │   └── exception/
│   ├── application/
│   │   ├── port/
│   │   │   ├── input/    (ActualizarPerfilUseCase, ObtenerPerfilUseCase)
│   │   │   └── output/   (PerfilRepositoryPort, ArchivoPort)
│   │   ├── service/      (ActualizarPerfilService, ValidacionPerfilService)
│   │   └── command/      (ActualizarPerfilEstudianteCommand, ActualizarPerfilTutorCommand)
│   └── infrastructure/
│       ├── persistence/  (PerfilPersistenceAdapter, PerfilJpaRepository)
│       └── web/          (PerfilesController)
│
├── reservas/             🆕 NUEVO - Agendamiento de sesiones
│   ├── domain/
│   │   ├── model/        (Reserva, Sesion, Disponibilidad, Estado)
│   │   ├── repository/   (ReservaRepository, DisponibilidadRepository)
│   │   └── exception/
│   ├── application/
│   │   ├── port/
│   │   │   ├── input/    (CrearReservaUseCase, ConfirmarReservaUseCase, CancelarReservaUseCase)
│   │   │   └── output/   (ReservaRepositoryPort, PagoPort, NotificacionPort)
│   │   ├── service/      (CrearReservaService, GestionReservasService)
│   │   └── command/      (CrearReservaCommand, ConfirmarReservaCommand)
│   └── infrastructure/
│       ├── persistence/  (ReservaPersistenceAdapter, ReservaJpaRepository)
│       ├── scheduler/    (RecordatoriosScheduler, LiberacionSlotsScheduler)
│       └── web/          (ReservasController)
│
├── pagos/                🆕 NUEVO - Procesamiento de pagos
│   ├── domain/
│   │   ├── model/        (Pago, Transaccion, MetodoPago, EstadoPago)
│   │   ├── repository/   (PagoRepository, TransaccionRepository)
│   │   └── exception/
│   ├── application/
│   │   ├── port/
│   │   │   ├── input/    (ProcesarPagoUseCase, ReembolsarPagoUseCase)
│   │   │   └── output/   (PagoRepositoryPort, StripePort, ReservaPort)
│   │   ├── service/      (ProcesarPagoService, ValidacionPagoService)
│   │   └── command/      (ProcesarPagoCommand, ReembolsarPagoCommand)
│   └── infrastructure/
│       ├── persistence/  (PagoPersistenceAdapter, PagoJpaRepository)
│       ├── payment/      (StripeAdapter, StripeWebhookHandler)
│       └── web/          (PagosController, WebhookController)
│
├── videollamadas/        🆕 NUEVO - Sesiones en vivo
│   ├── domain/
│   │   ├── model/        (Sala, Sesion, Participante, EstadoSala)
│   │   ├── repository/   (SalaRepository, SesionRepository)
│   │   └── exception/
│   ├── application/
│   │   ├── port/
│   │   │   ├── input/    (CrearSalaUseCase, UnirseASalaUseCase, FinalizarSalaUseCase)
│   │   │   └── output/   (SalaRepositoryPort, AgoraPort, ReservaPort)
│   │   ├── service/      (CrearSalaService, GestionSalasService)
│   │   └── command/      (CrearSalaCommand, UnirseASalaCommand)
│   └── infrastructure/
│       ├── persistence/  (SalaPersistenceAdapter, SalaJpaRepository)
│       ├── streaming/    (AgoraAdapter, AgoraTokenGenerator)
│       └── web/          (VideollamadasController)
│
├── notificaciones/       ✅ MANTENER - Ya migrado correctamente
│   ├── domain/
│   ├── application/
│   └── infrastructure/
│
├── admin/                🆕 NUEVO - Panel administrativo
│   ├── domain/
│   │   ├── model/        (Reporte, Estadistica, Dashboard, MetricaNegocio)
│   │   ├── repository/   (ReporteRepository, EstadisticaRepository)
│   │   └── exception/
│   ├── application/
│   │   ├── port/
│   │   │   ├── input/    (GenerarReporteUseCase, ObtenerEstadisticasUseCase)
│   │   │   └── output/   (ReporteRepositoryPort, AnalyticsPort)
│   │   ├── service/      (GenerarReporteService, EstadisticasService)
│   │   └── query/        (ObtenerReporteQuery, EstadisticasQuery)
│   └── infrastructure/
│       ├── persistence/  (ReportePersistenceAdapter, ReporteJpaRepository)
│       ├── analytics/    (GoogleAnalyticsAdapter - futuro)
│       └── web/          (AdminController)
│
└── shared/               ✅ EXPANDIR - Shared Kernel
    ├── domain/
    │   ├── valueobject/  (BaseEntity, Email, Telefono, Direccion, Dinero)
    │   ├── event/        (DomainEvent, EventPublisher)
    │   └── exception/    (DomainException, BusinessException)
    ├── application/
    │   └── dto/          (RegistroResponseDTO, ErrorResponse, PageResponse)
    └── infrastructure/
        ├── storage/      🔄 MOVER archivos/ aquí
        │   ├── port/     (StoragePort)
        │   ├── adapter/  (S3StorageAdapter, LocalStorageAdapter)
        │   └── model/    (Archivo, TipoArchivo, ProveedorStorage)
        ├── email/        (EmailPort, EmailAdapter)
        ├── cache/        (CachePort, RedisAdapter)
        └── config/       (OpenApiConfig, SecurityConfig, CorsConfig)
```

---

## 🔄 Mapeo de Migración

### 📦 Módulo `estudiantes` → Dividir en 2 BCs

#### 1️⃣ **estudiantes → autenticacion** (70% del código)
| Componente Actual | Destino | Acción |
|-------------------|---------|--------|
| `ProcesoRegistroEstudiante.java` | `autenticacion/domain/model/Usuario.java` | ✂️ Refactorizar |
| `EstudianteRegistroUseCase.java` | `autenticacion/application/port/input/RegistrarUsuarioUseCase.java` | ✂️ Renombrar |
| `IniciarRegistroCommand.java` | `autenticacion/application/command/RegistrarUsuarioCommand.java` | ✂️ Adaptar |
| `EstudianteRegistroController.java` | `autenticacion/infrastructure/web/AutenticacionController.java` | ✂️ Dividir |

#### 2️⃣ **estudiantes → perfiles** (30% del código)
| Componente Actual | Destino | Acción |
|-------------------|---------|--------|
| `ProcesoRegistroEstudiante.paso*` | `perfiles/domain/model/PerfilEstudiante.java` | ✂️ Extraer |
| `CompletarInformacionPersonalCommand.java` | `perfiles/application/command/ActualizarPerfilEstudianteCommand.java` | ✂️ Mover |

### 📦 Módulo `archivos` → Mover a Shared Infrastructure

| Componente Actual | Destino | Acción |
|-------------------|---------|--------|
| `archivos/domain/entity/Archivo.java` | `shared/infrastructure/storage/model/Archivo.java` | 📦 Mover |
| `archivos/domain/valueobject/*` | `shared/infrastructure/storage/model/*` | 📦 Mover |
| `archivos/domain/repository/ArchivoRepository.java` | `shared/infrastructure/storage/port/StoragePort.java` | 🔄 Renombrar |
| `archivos/application/usecase/FileUseCase.java` | `shared/infrastructure/storage/port/StoragePort.java` | 🔄 Convertir a Port |
| `archivos/infrastructure/persistence/*` | `shared/infrastructure/storage/adapter/S3StorageAdapter.java` | 🔄 Adaptar |

**Razón:** `archivos` no es un Bounded Context de negocio, es **infraestructura compartida** usada por múltiples BCs (Perfiles, Marketplace, Admin).

### 📦 Módulo `notificaciones` → Mantener
| Estado | Acción |
|--------|--------|
| ✅ Ya está correctamente estructurado como BC | ✨ Solo agregar Domain Events |

---

## 📋 Checklist de Refactorización

### 🚀 FASE 1: Separación de Autenticación (Prioridad ALTA)
- [ ] **1.1** Crear estructura de paquetes `autenticacion/`
  - [ ] `domain/model/Usuario.java` (Aggregate Root)
  - [ ] `domain/model/Credenciales.java` (Value Object)
  - [ ] `domain/model/Token.java` (Entity)
  - [ ] `domain/repository/UsuarioRepository.java` (Port)
  
- [ ] **1.2** Migrar Use Cases
  - [ ] `RegistrarUsuarioUseCase` (Port)
  - [ ] `LoginUseCase` (Port)
  - [ ] `RefreshTokenUseCase` (Port)
  - [ ] `RegistrarUsuarioService` (Implementación)
  - [ ] `LoginService` (Implementación)
  
- [ ] **1.3** Crear Infraestructura
  - [ ] `UsuarioPersistenceAdapter.java`
  - [ ] `UsuarioJpaRepository.java`
  - [ ] `JwtTokenProvider.java`
  - [ ] `AutenticacionController.java`
  
- [ ] **1.4** Eliminar código migrado de `estudiantes/`

### 🚀 FASE 2: Separación de Perfiles (Prioridad ALTA)
- [ ] **2.1** Crear estructura `perfiles/`
  - [ ] `domain/model/PerfilEstudiante.java`
  - [ ] `domain/model/PerfilTutor.java`
  - [ ] `domain/model/Experiencia.java` (Value Object)
  - [ ] `domain/model/Educacion.java` (Value Object)
  
- [ ] **2.2** Migrar Use Cases
  - [ ] `ActualizarPerfilUseCase` (Port)
  - [ ] `ObtenerPerfilUseCase` (Port)
  - [ ] `ActualizarPerfilService` (Implementación)
  
- [ ] **2.3** Crear Infraestructura
  - [ ] `PerfilPersistenceAdapter.java`
  - [ ] `PerfilJpaRepository.java`
  - [ ] `PerfilesController.java`

### 🚀 FASE 3: Mover Archivos a Shared Infrastructure (Prioridad MEDIA)
- [ ] **3.1** Crear `shared/infrastructure/storage/`
  - [ ] `port/StoragePort.java` (interfaz)
  - [ ] `model/Archivo.java`
  - [ ] `model/TipoArchivo.java`
  - [ ] `adapter/S3StorageAdapter.java`
  
- [ ] **3.2** Actualizar dependencias
  - [ ] Cambiar imports en `perfiles/`
  - [ ] Cambiar imports en `marketplace/` (cuando se cree)
  - [ ] Eliminar paquete `archivos/`

### 🚀 FASE 4: Crear BC Marketplace (Prioridad ALTA)
- [ ] **4.1** Estructura completa
  - [ ] `domain/model/Tutor.java`
  - [ ] `domain/model/Categoria.java`
  - [ ] `domain/model/Especialidad.java`
  - [ ] `application/port/input/BuscarTutoresUseCase.java`
  - [ ] `application/service/BuscarTutoresService.java`
  - [ ] `infrastructure/persistence/TutorPersistenceAdapter.java`
  - [ ] `infrastructure/web/MarketplaceController.java`

### 🚀 FASE 5: Crear BC Reservas (Prioridad ALTA)
- [ ] **5.1** Estructura completa
  - [ ] `domain/model/Reserva.java`
  - [ ] `domain/model/Disponibilidad.java`
  - [ ] `application/port/input/CrearReservaUseCase.java`
  - [ ] `application/service/CrearReservaService.java`
  - [ ] `infrastructure/persistence/ReservaPersistenceAdapter.java`
  - [ ] `infrastructure/web/ReservasController.java`

### 🚀 FASE 6: Crear BC Pagos (Prioridad MEDIA)
- [ ] **6.1** Estructura completa
  - [ ] `domain/model/Pago.java`
  - [ ] `application/port/input/ProcesarPagoUseCase.java`
  - [ ] `infrastructure/payment/StripeAdapter.java`
  - [ ] `infrastructure/web/PagosController.java`

### 🚀 FASE 7: Crear BC Videollamadas (Prioridad BAJA)
- [ ] **7.1** Estructura completa
  - [ ] `domain/model/Sala.java`
  - [ ] `application/port/input/CrearSalaUseCase.java`
  - [ ] `infrastructure/streaming/AgoraAdapter.java`
  - [ ] `infrastructure/web/VideollamadasController.java`

### 🚀 FASE 8: Crear BC Admin (Prioridad BAJA)
- [ ] **8.1** Estructura completa
  - [ ] `domain/model/Reporte.java`
  - [ ] `application/port/input/GenerarReporteUseCase.java`
  - [ ] `infrastructure/persistence/ReportePersistenceAdapter.java`
  - [ ] `infrastructure/web/AdminController.java`

### 🚀 FASE 9: Validación Final
- [ ] **9.1** ArchUnit Rules
  - [ ] Validar dependencias entre BCs
  - [ ] Validar estructura hexagonal
  - [ ] Validar nomenclatura

- [ ] **9.2** Tests
  - [ ] Tests unitarios por BC
  - [ ] Tests de integración con Testcontainers
  - [ ] Coverage > 80%

- [ ] **9.3** Documentación
  - [ ] Context Map (relaciones entre BCs)
  - [ ] ADR por cada decisión arquitectónica
  - [ ] Actualizar README principal

---

## 🎯 Priorización

### 🔴 CRÍTICO (Semana 1-2)
1. **Autenticación** - Base de seguridad de toda la aplicación
2. **Perfiles** - Información básica de usuarios
3. **Marketplace** - Core del negocio (búsqueda de tutores)

### 🟡 IMPORTANTE (Semana 3-4)
4. **Reservas** - Agendamiento de sesiones
5. **Pagos** - Procesamiento de transacciones
6. **Shared Infrastructure** - Almacenamiento de archivos

### 🟢 COMPLEMENTARIO (Semana 5-6)
7. **Videollamadas** - Sesiones en vivo
8. **Admin** - Panel administrativo
9. **Notificaciones** - Mejorar con Domain Events

---

## 📐 Principios de Diseño

### ✅ DDD Tactical Patterns
- **Aggregates:** Cada BC tiene su Aggregate Root
- **Value Objects:** Inmutables, sin identidad
- **Domain Events:** Comunicación asíncrona entre BCs
- **Repositories:** Solo para Aggregates

### ✅ Hexagonal Architecture
- **Ports (Interfaces):** En `application/port/input` y `application/port/output`
- **Adapters (Implementaciones):** En `infrastructure/`
- **Domain Puro:** Sin dependencias a Spring, JPA, etc.

### ✅ Comunicación entre BCs
```java
// ❌ MAL: Dependencia directa entre BCs
reservas.application.service.CrearReservaService {
    @Autowired
    private PagoService pagoService; // ❌ Acoplamiento fuerte
}

// ✅ BIEN: Comunicación mediante Ports
reservas.application.port.output.PagoPort {
    Pago procesarPago(MontoReserva monto);
}

reservas.infrastructure.adapter.PagoAdapter implements PagoPort {
    // Llama al BC de Pagos vía REST/Events
}
```

---

## 🛠️ Herramientas de Soporte

### ArchUnit (Validación de Arquitectura)
```java
@ArchTest
static final ArchRule domain_no_depende_de_infrastructure =
    noClasses()
        .that().resideInAPackage("..domain..")
        .should().dependOnClassesThat()
        .resideInAPackage("..infrastructure..");
```

### Testcontainers (Tests de Integración)
```java
@Testcontainers
class AutenticacionIntegrationTest {
    @Container
    static PostgreSQLContainer<?> postgres = 
        new PostgreSQLContainer<>("postgres:16");
    
    @Test
    void debeRegistrarUsuarioCorrectamente() {
        // Test con BD real
    }
}
```

---

## 📊 Métricas de Éxito

| Métrica | Objetivo |
|---------|----------|
| **Cobertura de Tests** | > 80% |
| **Acoplamiento entre BCs** | 0 dependencias directas |
| **Compilación** | 0 errores, 0 warnings |
| **ArchUnit Rules** | 100% cumplimiento |
| **Documentación** | 1 ADR por decisión arquitectónica |

---

## 🚀 Siguiente Paso

**¿Deseas que comience con FASE 1: Separación del BC de Autenticación?**

Esto incluirá:
1. Crear estructura completa de `autenticacion/`
2. Migrar `Usuario` como Aggregate Root
3. Crear `RegistrarUsuarioUseCase` y `LoginUseCase`
4. Implementar `AutenticacionController`
5. Actualizar dependencias y eliminar código obsoleto de `estudiantes/`
