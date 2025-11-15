# 🔍 Análisis de Archivos Fuera de Estructura de BCs

## 📋 Archivos Detectados Fuera de los Bounded Contexts

### ❌ Problema: Arquitectura Legacy Mezclada
Existen archivos en rutas que **NO siguen** la estructura de Bounded Contexts ni Arquitectura Hexagonal:

```
src/main/java/com/mitoga/
├── Infrastructure/          ❌ LEGACY - Debería estar dentro de módulos BC
│   ├── service/
│   │   ├── FileServiceImpl.java         → Mover a archivos/infrastructure/adapter/
│   │   └── NotificationServiceImpl.java → Ya migrado (duplicado?)
│   └── web/controller/
│       ├── EstudianteRegistroController.java → Ya migrado (duplicado?)
│       └── FileController.java               → Ya migrado (duplicado?)
│
├── application/dto/         ❌ LEGACY - Debería estar en cada BC
│   ├── request/
│   │   ├── FileUploadRequestDTO.java         → Mover a archivos/infrastructure/web/dto/
│   │   └── RegistroEstudianteRequestDTO.java → Ya migrado (duplicado?)
│   └── response/
│       └── RegistroResponseDTO.java          → Mover a shared/application/dto/
│
├── config/                  ⚠️ INFRAESTRUCTURA COMPARTIDA
│   ├── EmailProperties.java    → Mover a shared/infrastructure/config/
│   ├── S3Config.java            → Mover a shared/infrastructure/config/
│   └── S3Properties.java        → Mover a shared/infrastructure/config/
│
└── domain/                  ❌ LEGACY - Debería estar dentro de módulos BC
    ├── entity/
    │   └── BaseEntity.java      → Ya migrado a shared/domain/valueobject/ (duplicado?)
    ├── enums/
    │   ├── ProveedorStorage.java → Ya migrado a archivos/domain/valueobject/ (duplicado?)
    │   └── TipoArchivo.java      → Ya migrado a archivos/domain/valueobject/ (duplicado?)
    ├── repository/
    │   └── ArchivoRepository.java → Ya migrado a archivos/domain/repository/ (duplicado?)
    └── service/
        ├── EstudianteRegistroService.java  → Duplicado? Revisar si es interfaz legacy
        ├── FileService.java                → Duplicado? Revisar si es interfaz legacy
        └── NotificationService.java        → Duplicado? Revisar si es interfaz legacy
```

---

## 🎯 Plan de Limpieza y Migración

### 📦 PASO 1: Verificar Duplicados (CRÍTICO)

Antes de mover archivos, debemos **verificar si son duplicados** de los ya migrados o si contienen lógica diferente:

| Archivo Legacy | Archivo Migrado | Acción |
|----------------|-----------------|--------|
| `Infrastructure/service/FileServiceImpl.java` | `archivos/infrastructure/persistence/adapter/*` | ⚠️ Verificar si es el mismo |
| `Infrastructure/web/controller/EstudianteRegistroController.java` | `estudiantes/infrastructure/web/controller/EstudianteRegistroController.java` | ⚠️ Verificar duplicado |
| `Infrastructure/web/controller/FileController.java` | `archivos/infrastructure/web/controller/FileController.java` | ⚠️ Verificar duplicado |
| `application/dto/request/RegistroEstudianteRequestDTO.java` | `estudiantes/infrastructure/web/dto/RegistroEstudianteRequestDTO.java` | ⚠️ Verificar duplicado |
| `domain/entity/BaseEntity.java` | `shared/domain/valueobject/BaseEntity.java` | ⚠️ Verificar duplicado |
| `domain/enums/ProveedorStorage.java` | `archivos/domain/valueobject/ProveedorStorage.java` | ⚠️ Verificar duplicado |
| `domain/enums/TipoArchivo.java` | `archivos/domain/valueobject/TipoArchivo.java` | ⚠️ Verificar duplicado |
| `domain/repository/ArchivoRepository.java` | `archivos/domain/repository/ArchivoRepository.java` | ⚠️ Verificar duplicado |

---

### 📦 PASO 2: Eliminar Duplicados Legacy

Si son duplicados **EXACTOS** o con pequeñas diferencias, **ELIMINAR** los archivos legacy:

```bash
# Eliminar archivos duplicados después de verificación
rm Infrastructure/service/FileServiceImpl.java
rm Infrastructure/web/controller/EstudianteRegistroController.java
rm Infrastructure/web/controller/FileController.java
rm application/dto/request/RegistroEstudianteRequestDTO.java
rm domain/entity/BaseEntity.java
rm domain/enums/ProveedorStorage.java
rm domain/enums/TipoArchivo.java
rm domain/repository/ArchivoRepository.java
```

---

### 📦 PASO 3: Migrar Archivos Únicos a Shared Infrastructure

#### 3.1 Config → `shared/infrastructure/config/`

| Archivo Actual | Destino | Razón |
|----------------|---------|-------|
| `config/EmailProperties.java` | `shared/infrastructure/config/EmailProperties.java` | Configuración compartida por BC Notificaciones |
| `config/S3Config.java` | `shared/infrastructure/config/S3Config.java` | Configuración compartida por Storage |
| `config/S3Properties.java` | `shared/infrastructure/config/S3Properties.java` | Propiedades compartidas por Storage |

#### 3.2 DTOs Únicos → Mover según responsabilidad

| Archivo Actual | Destino | Razón |
|----------------|---------|-------|
| `application/dto/request/FileUploadRequestDTO.java` | `archivos/infrastructure/web/dto/FileUploadRequestDTO.java` | DTO específico del BC Archivos |
| `application/dto/response/RegistroResponseDTO.java` | `shared/application/dto/RegistroResponseDTO.java` | DTO compartido (si es genérico) |

#### 3.3 Services Legacy → Evaluar si son interfaces Port

| Archivo Actual | Acción | Razón |
|----------------|--------|-------|
| `domain/service/EstudianteRegistroService.java` | 🔍 **Verificar si es interfaz Port** | Si es interfaz, podría ser `estudiantes/application/port/input/EstudianteRegistroUseCase.java` renombrado |
| `domain/service/FileService.java` | 🔍 **Verificar si es interfaz Port** | Si es interfaz, podría ser `archivos/application/port/input/FileUseCase.java` renombrado |
| `domain/service/NotificationService.java` | 🔍 **Verificar si es interfaz Port** | Si es interfaz, podría ser `notificaciones/application/port/input/NotificationUseCase.java` renombrado |

**Nota:** En Arquitectura Hexagonal, las interfaces `Service` del dominio legacy **deben renombrarse a `UseCase`** (Ports de entrada).

---

### 📦 PASO 4: Eliminar Directorios Legacy Vacíos

Después de migrar/eliminar archivos:

```bash
# Eliminar directorios vacíos
rm -r Infrastructure/
rm -r application/
rm -r domain/
rm -r config/
```

---

## 🔄 Estrategia de Migración Detallada

### 🚨 Prioridad 1: Verificar Duplicados (HOY)

```bash
# Comparar archivos duplicados sospechosos
diff Infrastructure/web/controller/EstudianteRegistroController.java \
     estudiantes/infrastructure/web/controller/EstudianteRegistroController.java

diff domain/entity/BaseEntity.java \
     shared/domain/valueobject/BaseEntity.java
```

**Decisión:**
- ✅ Si son **idénticos**: Eliminar el legacy
- ⚠️ Si hay **pequeñas diferencias**: Consolidar en el nuevo (copiar mejoras) y eliminar legacy
- ❌ Si son **muy diferentes**: Investigar por qué y reconciliar lógica

---

### 🚨 Prioridad 2: Migrar Configs a Shared (HOY)

```java
// ANTES (Legacy)
com.mitoga.config.S3Config

// DESPUÉS (Shared Infrastructure)
com.mitoga.shared.infrastructure.config.S3Config
```

**Cambios necesarios:**
1. Mover archivos a `shared/infrastructure/config/`
2. Actualizar package declarations
3. Actualizar imports en clases que los usen (`archivos/infrastructure/persistence/adapter/*`)
4. Verificar `application.properties` / `application.yml`

---

### 🚨 Prioridad 3: Reconciliar Services Legacy (HOY)

**Si `domain/service/EstudianteRegistroService.java` es una INTERFAZ:**

```java
// ANTES (Legacy - DDD Clásico)
package com.mitoga.domain.service;

public interface EstudianteRegistroService {
    RegistroResponseDTO iniciarProceso(RegistroEstudianteRequestDTO request);
}

// DESPUÉS (Hexagonal - Port de Entrada)
package com.mitoga.estudiantes.application.port.input;

public interface EstudianteRegistroUseCase {
    RegistroResponseDTO iniciarProceso(IniciarRegistroCommand command);
}
```

**Cambios:**
1. Renombrar `Service` → `UseCase` (convención Hexagonal)
2. Cambiar DTOs por Commands (CQRS)
3. Mover a `application/port/input/`
4. Eliminar interfaz legacy

---

## 🎯 Resultado Esperado

### ✅ Estructura Final Limpia

```
src/main/java/com/mitoga/
├── autenticacion/        🆕 BC nuevo (FASE 1)
│   ├── domain/
│   ├── application/
│   └── infrastructure/
│
├── marketplace/          🆕 BC nuevo (FASE 4)
├── perfiles/             🆕 BC nuevo (FASE 2)
├── reservas/             🆕 BC nuevo (FASE 5)
├── pagos/                🆕 BC nuevo (FASE 6)
├── videollamadas/        🆕 BC nuevo (FASE 7)
├── admin/                🆕 BC nuevo (FASE 8)
│
├── notificaciones/       ✅ BC correcto
│   ├── domain/
│   ├── application/
│   └── infrastructure/
│
├── shared/               ✅ Shared Kernel expandido
│   ├── domain/
│   │   ├── valueobject/  (BaseEntity, Email, etc.)
│   │   ├── event/        (DomainEvent)
│   │   └── exception/    (BusinessException)
│   ├── application/
│   │   └── dto/          (RegistroResponseDTO, ErrorResponse)
│   └── infrastructure/
│       ├── config/       🔄 S3Config, EmailProperties, etc.
│       ├── storage/      🔄 StoragePort, S3Adapter (ex-archivos)
│       ├── email/        (EmailPort, EmailAdapter)
│       └── cache/        (CachePort, RedisAdapter)
│
└── MitogaApplication.java

❌ YA NO EXISTEN:
├── Infrastructure/       (Eliminado)
├── application/          (Eliminado)
├── config/               (Eliminado)
├── domain/               (Eliminado)
├── estudiantes/          (Refactorizado a autenticacion + perfiles)
└── archivos/             (Movido a shared/infrastructure/storage)
```

---

## 📋 Checklist de Limpieza

### ✅ Verificación de Duplicados
- [ ] Comparar `Infrastructure/service/FileServiceImpl.java` con archivos migrados
- [ ] Comparar `Infrastructure/web/controller/*` con `*/infrastructure/web/controller/*`
- [ ] Comparar `application/dto/*` con `*/infrastructure/web/dto/*`
- [ ] Comparar `domain/entity/BaseEntity.java` con `shared/domain/valueobject/BaseEntity.java`
- [ ] Comparar `domain/enums/*` con `archivos/domain/valueobject/*`
- [ ] Comparar `domain/repository/ArchivoRepository.java` con `archivos/domain/repository/*`

### ✅ Migración a Shared
- [ ] Mover `config/S3Config.java` → `shared/infrastructure/config/S3Config.java`
- [ ] Mover `config/S3Properties.java` → `shared/infrastructure/config/S3Properties.java`
- [ ] Mover `config/EmailProperties.java` → `shared/infrastructure/config/EmailProperties.java`
- [ ] Actualizar imports en clases dependientes

### ✅ Reconciliar Interfaces Legacy
- [ ] Verificar si `domain/service/EstudianteRegistroService.java` es Port duplicado
- [ ] Verificar si `domain/service/FileService.java` es Port duplicado
- [ ] Verificar si `domain/service/NotificationService.java` es Port duplicado
- [ ] Consolidar diferencias en los Ports nuevos
- [ ] Eliminar interfaces legacy

### ✅ Eliminar Archivos Legacy
- [ ] Eliminar `Infrastructure/` completo
- [ ] Eliminar `application/` completo
- [ ] Eliminar `config/` completo
- [ ] Eliminar `domain/` completo

### ✅ Validación Final
- [ ] Compilar proyecto: `./gradlew build`
- [ ] Ejecutar tests: `./gradlew test`
- [ ] Verificar cobertura: `./gradlew jacocoTestReport`
- [ ] Validar ArchUnit rules (cuando se implemente)

---

## 🚀 Siguiente Paso

**1. ¿Comenzamos verificando los duplicados?**

Ejecutaré comandos `diff` para comparar archivos sospechosos y determinar si son duplicados exactos o tienen diferencias.

**2. Luego migraremos configs a Shared Infrastructure**

Una vez limpio de duplicados, moveremos los archivos de configuración compartida.

**3. Finalmente comenzaremos FASE 1: BC Autenticación**

Con la estructura limpia, podemos proceder con la creación del nuevo Bounded Context de Autenticación.
