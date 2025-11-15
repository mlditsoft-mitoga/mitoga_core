# 📋 MAPEO DE MÓDULOS ACTUALES DEL BACKEND

## 📊 **ANÁLISIS DEL ESTADO ACTUAL**

### **🏗️ Estructura Actual (No Modular)**
```
com.mitoga/
├── MitogaApplication.java                     # Main Application
├── config/                                    # Configuraciones globales
├── application/
│   └── dto/                                   # DTOs mezclados
├── domain/
│   ├── entity/
│   │   ├── BaseEntity.java                    # Shared
│   │   ├── estudiante/ProcesoRegistroEstudiante.java
│   │   └── shared/Archivo.java                # Shared
│   ├── enums/                                 # Enums mezclados
│   ├── service/                               # Interfaces de dominio
│   └── repository/                            # Repositories mezclados
├── infrastructure/
│   ├── service/                               # Implementaciones
│   └── web/controller/                        # Controllers mezclados
└── shared/                                    # Algunos elementos shared
    ├── application/catalogo/                  # Catálogos (casi modular)
    ├── domain/catalogo/                       # Catálogos domain
    └── infrastructure/                        # Shared infrastructure
```

### **❌ PROBLEMAS IDENTIFICADOS:**

1. **📦 No hay separación por Bounded Contexts**
2. **🔗 Dependencias mezcladas** (estudiante + archivos + catálogos)
3. **📂 Packages por capas, no por dominio**
4. **⚠️ Violaciones DDD** (entidades mezcladas)

---

## 🎯 **MAPEO A ESTRUCTURA MODULAR**

### **MÓDULO 1: REGISTRO ESTUDIANTES (BC)**

**📂 Ubicación actual → Nueva:**
```java
// ACTUAL (Mezclado)
com.mitoga.domain.entity.estudiante.ProcesoRegistroEstudiante
com.mitoga.domain.service.EstudianteRegistroService
com.mitoga.infrastructure.web.controller.EstudianteRegistroController
com.mitoga.application.dto.request.RegistroEstudianteRequestDTO
com.mitoga.application.dto.response.RegistroResponseDTO

// NUEVO (Modular)
com.mitoga.estudiantes/                        # BC: Registro Estudiantes
├── domain/
│   ├── entity/
│   │   └── ProcesoRegistroEstudiante.java     # Aggregate Root
│   ├── valueobject/
│   │   ├── UsuarioId.java                     # Value Object
│   │   ├── EstadoProceso.java                 # Enum
│   │   └── TokenVerificacion.java             # Value Object
│   ├── repository/
│   │   └── ProcesoRegistroRepository.java     # Port (Interface)
│   ├── service/
│   │   └── RegistroValidationService.java     # Domain Service
│   └── event/
│       ├── RegistroIniciado.java              # Domain Event
│       ├── EmailVerificado.java               # Domain Event
│       └── RegistroCompletado.java            # Domain Event
├── application/
│   ├── usecase/
│   │   ├── IniciarRegistroUseCase.java        # Use Case
│   │   ├── VerificarEmailUseCase.java         # Use Case
│   │   ├── SubirDocumentoUseCase.java         # Use Case
│   │   └── FinalizarRegistroUseCase.java      # Use Case
│   ├── command/
│   │   ├── IniciarRegistroCommand.java        # Command
│   │   ├── VerificarEmailCommand.java         # Command
│   │   └── SubirDocumentoCommand.java         # Command
│   └── query/
│       └── ObtenerProcesoRegistroQuery.java   # Query
├── infrastructure/
│   ├── persistence/
│   │   ├── entity/ProcesoRegistroJpaEntity.java
│   │   ├── repository/ProcesoRegistroJpaRepository.java
│   │   └── adapter/ProcesoRegistroPersistenceAdapter.java
│   └── web/
│       ├── controller/RegistroEstudiantesController.java
│       └── dto/
│           ├── IniciarRegistroRequest.java
│           └── RegistroResponse.java
└── EstudiantesModuleConfiguration.java        # Spring Configuration
```

### **MÓDULO 2: GESTIÓN ARCHIVOS (BC)**

**📂 Ubicación actual → Nueva:**
```java
// ACTUAL (Mezclado en shared y domain)
com.mitoga.domain.entity.shared.Archivo
com.mitoga.domain.service.FileService
com.mitoga.infrastructure.service.FileServiceImpl
com.mitoga.infrastructure.web.controller.FileController

// NUEVO (Modular)
com.mitoga.archivos/                           # BC: Gestión Archivos
├── domain/
│   ├── entity/
│   │   └── Archivo.java                       # Aggregate Root
│   ├── valueobject/
│   │   ├── ArchivoId.java                     # Value Object
│   │   ├── TipoArchivo.java                   # Enum
│   │   ├── RutaStorage.java                   # Value Object
│   │   └── MetadataArchivo.java               # Value Object
│   ├── repository/
│   │   └── ArchivoRepository.java             # Port (Interface)
│   ├── service/
│   │   ├── StorageService.java                # Port (Interface)
│   │   └── ValidacionArchivoService.java      # Domain Service
│   └── event/
│       ├── ArchivoSubido.java                 # Domain Event
│       └── ArchivoEliminado.java              # Domain Event
├── application/
│   ├── usecase/
│   │   ├── SubirArchivoUseCase.java           # Use Case
│   │   ├── ObtenerArchivoUseCase.java         # Use Case
│   │   ├── GenerarUrlTemporalUseCase.java     # Use Case
│   │   └── EliminarArchivoUseCase.java        # Use Case
│   ├── command/
│   │   ├── SubirArchivoCommand.java           # Command
│   │   └── EliminarArchivoCommand.java        # Command
│   └── query/
│       └── ObtenerArchivoQuery.java           # Query
├── infrastructure/
│   ├── persistence/
│   │   └── adapter/ArchivoPersistenceAdapter.java
│   ├── storage/
│   │   └── adapter/S3StorageAdapter.java      # S3 Implementation
│   └── web/
│       ├── controller/ArchivosController.java
│       └── dto/
│           ├── SubirArchivoRequest.java
│           └── ArchivoResponse.java
└── ArchivosModuleConfiguration.java          # Spring Configuration
```

### **MÓDULO 3: NOTIFICACIONES (BC)**

**📂 Ubicación actual → Nueva:**
```java
// ACTUAL (Mezclado)
com.mitoga.domain.service.NotificationService
com.mitoga.infrastructure.service.NotificationServiceImpl
com.mitoga.infrastructure.web.controller.TestController (emails)

// NUEVO (Modular)
com.mitoga.notificaciones/                     # BC: Notificaciones
├── domain/
│   ├── entity/
│   │   └── Notificacion.java                  # Aggregate Root
│   ├── valueobject/
│   │   ├── NotificacionId.java                # Value Object
│   │   ├── Email.java                         # Value Object
│   │   ├── TipoNotificacion.java              # Enum
│   │   └── Template.java                      # Value Object
│   ├── repository/
│   │   └── NotificacionRepository.java        # Port (Interface)
│   ├── service/
│   │   ├── EmailService.java                  # Port (Interface)
│   │   └── TemplateService.java               # Domain Service
│   └── event/
│       ├── NotificacionEnviada.java           # Domain Event
│       └── EmailFallidoEvent.java             # Domain Event
├── application/
│   ├── usecase/
│   │   ├── EnviarEmailUseCase.java            # Use Case
│   │   ├── EnviarSMSUseCase.java              # Use Case
│   │   └── ReenviarNotificacionUseCase.java   # Use Case
│   ├── command/
│   │   ├── EnviarEmailCommand.java            # Command
│   │   └── EnviarSMSCommand.java              # Command
│   └── eventhandler/
│       ├── RegistroIniciadoHandler.java       # Event Handler
│       └── EmailVerificadoHandler.java        # Event Handler
├── infrastructure/
│   ├── persistence/
│   │   └── adapter/NotificacionPersistenceAdapter.java
│   ├── email/
│   │   └── adapter/SendGridEmailAdapter.java  # SendGrid Implementation
│   └── web/
│       ├── controller/NotificacionesController.java
│       └── dto/
│           ├── EnviarEmailRequest.java
│           └── NotificacionResponse.java
└── NotificacionesModuleConfiguration.java    # Spring Configuration
```

### **MÓDULO 4: SHARED KERNEL (Transversal)**

**📂 Ubicación actual → Mejorada:**
```java
// ACTUAL (Parcialmente correcto)
com.mitoga.shared/...

// MEJORADO (Más completo)
com.mitoga.shared/                             # Shared Kernel
├── domain/
│   ├── entity/
│   │   ├── BaseEntity.java                    # Base para todos los aggregates
│   │   └── AggregateRoot.java                 # Base para aggregate roots
│   ├── valueobject/
│   │   ├── ValueObject.java                   # Marker interface
│   │   ├── Email.java                         # VO compartido
│   │   ├── Telefono.java                      # VO compartido
│   │   └── Direccion.java                     # VO compartido
│   ├── event/
│   │   ├── DomainEvent.java                   # Base event
│   │   └── EventPublisher.java                # Port
│   ├── exception/
│   │   ├── DomainException.java               # Base exception
│   │   ├── ValidationException.java           # Validation errors
│   │   └── BusinessRuleException.java         # Business rule violations
│   └── catalogo/                              # Catálogos (ya modular)
│       ├── Catalogo.java                      # Aggregate Root
│       ├── CatalogoRepository.java            # Port
│       └── CatalogoTipo.java                  # Enum
├── application/
│   ├── UseCase.java                           # Base use case
│   ├── Command.java                           # Base command
│   ├── Query.java                             # Base query
│   └── catalogo/                              # Servicios catálogos
├── infrastructure/
│   ├── config/                                # Configuraciones compartidas
│   ├── api/                                   # API response patterns
│   ├── messaging/                             # Event infrastructure
│   └── persistence/                           # JPA base classes
└── SharedModuleConfiguration.java            # Shared configuration
```

---

## 🚀 **PLAN DE REFACTORING**

### **FASE 1: Preparación (1-2 días)**
1. ✅ **Crear estructura de packages** según módulos
2. ✅ **Mover archivos sin cambiar imports** (git mv)
3. ✅ **Configurar ArchUnit rules** para validar separación
4. ✅ **Configurar CI/CD** con validación

### **FASE 2: Módulo Shared (2-3 días)**
1. ✅ **Consolidar shared kernel**
2. ✅ **Extraer Value Objects comunes** (Email, Telefono)
3. ✅ **Crear base classes** (AggregateRoot, UseCase)
4. ✅ **Configurar Domain Events** infrastructure

### **FASE 3: Módulo Archivos (3-4 días)**
1. ✅ **Mover Archivo.java** a archivos.domain.entity
2. ✅ **Crear Value Objects** (ArchivoId, TipoArchivo)
3. ✅ **Refactorizar FileService** a Use Cases
4. ✅ **Implementar Domain Events**

### **FASE 4: Módulo Estudiantes (4-5 días)**
1. ✅ **Mover ProcesoRegistroEstudiante** a estudiantes.domain
2. ✅ **Crear Use Cases** específicos
3. ✅ **Refactorizar Controller** con nuevos DTOs
4. ✅ **Implementar Event Handlers**

### **FASE 5: Módulo Notificaciones (3-4 días)**
1. ✅ **Crear módulo desde cero**
2. ✅ **Mover NotificationService** al nuevo módulo
3. ✅ **Implementar Event Handlers** para otros módulos
4. ✅ **Testing independiente**

### **FASE 6: Validación y Testing (2-3 días)**
1. ✅ **Ejecutar ArchUnit tests**
2. ✅ **Integration tests** por módulo
3. ✅ **E2E tests** completos
4. ✅ **Performance testing**

---

## 🎯 **BENEFICIOS ESPERADOS**

### **📈 Antes vs Después:**
| Aspecto | ANTES (Actual) | DESPUÉS (Modular) |
|---------|---------------|-------------------|
| **Acoplamiento** | Alto (todo mezclado) | Bajo (eventos) |
| **Testing** | Difícil (dependencias) | Fácil (independiente) |
| **Comprensión** | Confusa (capas técnicas) | Clara (dominios) |
| **Escalabilidad** | Limitada | Alta (microservicios) |
| **Mantenimiento** | Costoso | Eficiente |

### **🔧 Capacidades Nuevas:**
- ✅ **Extracción a microservicios** en 1-2 días
- ✅ **Testing independiente** por módulo
- ✅ **Desarrollo en paralelo** por equipos
- ✅ **Deploy independiente** (futuro)
- ✅ **Escalado específico** por módulo

---

## 📋 **SIGUIENTE PASO**

**¿Procedemos con la FASE 1 (Preparación)?**
- Crear estructura de packages
- Mover archivos sin cambiar lógica
- Configurar ArchUnit rules
- Validar que todo compile

**O prefieres que analicemos primero algún módulo específico en detalle?** 🎯