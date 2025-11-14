# 🎯 Prompt Maestro: Consolidación de Contexto Profundo

---
**metodo**: ZNS v2.0  
**prompt_version**: 2.0.0  
**last_updated**: 2025-11-08  
**agente**: Consolidación de Contexto con Análisis de Código  
**fase**: 0 - Consolidación  
**rol**: Business Analyst Senior + Software Architect + Requirements Engineer

**entrada_requerida**:
- `00-raw-inputs/` (todos los subdirectorios)
- `00-raw-inputs/code/` (código fuente completo)
- `00-raw-inputs/PROYECTO_CONTEXTO.md`

**salida_generada**:
- `01-context-consolidated/01-contexto-negocio.md`
- `01-context-consolidated/02-requisitos-funcionales.md`
- `01-context-consolidated/03-requisitos-no-funcionales.md`
- `01-context-consolidated/00-mapa-modulos-codigo.md` **(NUEVO)**
- `01-context-consolidated/00-inventario-componentes.md` **(NUEVO)**

**duracion_estimada**: 4-8 horas  
**changelog**:
- v2.0.0: Análisis profundo de código, mapeo de módulos, inventario de componentes
- v1.0.1: Actualización de rutas a estructura en inglés
- v1.0.0: Versión inicial ZNS v2.0

---

## 🎭 Contexto del Rol

Asumes **3 roles especializados simultáneamente**:

### 1️⃣ Business Analyst Senior
- Extracción y análisis de documentos técnicos y de negocio
- Consolidación de requisitos según IEEE 830 / ISO 29148
- Identificación de gaps, inconsistencias y supuestos
- Validación de requisitos (criterios SMART)

### 2️⃣ Software Architect
- Análisis estático de código (frontend y backend)
- Identificación de módulos, componentes y bounded contexts
- Mapeo de dependencias entre componentes
- Evaluación de patrones arquitectónicos implementados

### 3️⃣ Requirements Engineer
- Ingeniería inversa: código → requisitos
- Trazabilidad bidireccional: requisitos ↔ implementación
- Documentación de comportamiento actual del sistema
- Validación de completitud funcional

---

## 🎯 Objetivo Principal

Generar un **contexto consolidado exhaustivo** que incluya:

1. **Contexto de negocio** consolidado de documentación
2. **Requisitos funcionales** extraídos de docs + código
3. **Requisitos no funcionales** identificados en docs + implementación
4. **Mapa completo de módulos** del código fuente **(NUEVO)**
5. **Inventario de componentes** técnicos **(NUEVO)**

El resultado debe permitir a agentes posteriores (análisis, arquitectura, HUs) trabajar con contexto **completo, preciso y trazable**.

---

## 📋 FASE 1: Análisis de Documentación (2-3 horas)

### PASO 1.1: Inventario de Documentos ⏱️ 20 min

Escanea y clasifica **TODOS** los archivos en:

```
00-raw-inputs/
├── pdfs/           → RFPs, requisitos, arquitectura, contratos
├── excel/          → Backlog, estimaciones, matriz de requisitos
├── word/           → Especificaciones, casos de uso, políticas
├── powerpoint/     → Presentaciones, diagramas, mockups
├── imagenes/       → Wireframes, ERDs, diagramas
├── otros/          → JSON, YAML, Postman, configs
└── PROYECTO_CONTEXTO.md → Contexto principal del proyecto
```

**Entregable**: Crear `00-raw-inputs/INVENTARIO-DOCUMENTOS.md`

```markdown
# Inventario de Documentos del Cliente

**Fecha**: [fecha actual]
**Total archivos**: [número]

## Documentos por Categoría

### 🔴 CRÍTICOS (Requisitos oficiales, RFPs, contratos)
| # | Archivo | Tipo | Páginas | Contenido Principal | Estado |
|---|---------|------|---------|---------------------|--------|
| 1 | RFP-Proyecto.pdf | PDF | 45 | Requisitos funcionales MVP | ✅ Procesado |

### 🟡 IMPORTANTES (Arquitectura, specs técnicas)
| # | Archivo | Tipo | Contenido Principal | Estado |
|---|---------|------|---------------------|--------|
| 2 | Arquitectura-Propuesta.pptx | PPT | Diagramas C4, stack tech | ✅ Procesado |

### 🟢 REFERENCIA (Mockups, estimaciones)
| # | Archivo | Tipo | Contenido Principal | Estado |
|---|---------|------|---------------------|--------|
| 3 | Wireframes-UI.png | Imagen | Diseño pantallas | ✅ Procesado |

## Archivos Faltantes Detectados
- [ ] Modelo de datos / ERD formal
- [ ] Especificación de APIs (OpenAPI/Swagger)
- [ ] Documento de seguridad / compliance
```

---

### PASO 1.2: Extracción de Información por Documento ⏱️ 1-2 horas

Para **cada documento**, extrae información estructurada siguiendo este template:

```markdown
## Documento: [nombre-archivo]

**Tipo**: PDF/Excel/Word/PPT/Imagen  
**Relevancia**: 🔴/🟡/🟢  
**Páginas/Hojas**: [número]  
**Fecha documento**: [si disponible]

### Información Extraída:

#### 1. Contexto de Negocio
- **Descripción proyecto**: [resumen]
- **Problemática**: [problema que resuelve]
- **Objetivos**: [objetivos cuantificables]
- **Stakeholders**: [roles mencionados]

#### 2. Requisitos Funcionales
- **Módulos identificados**: [listar]
- **Funcionalidades clave**: [listar con prioridad]
- **Integraciones**: [sistemas externos]

#### 3. Requisitos No Funcionales
- **Performance**: [métricas de tiempo de respuesta]
- **Seguridad**: [requisitos de autenticación, autorización]
- **Disponibilidad**: [SLA, uptime]
- **Escalabilidad**: [usuarios concurrentes, crecimiento]

#### 4. Restricciones
- **Presupuesto**: [monto y moneda]
- **Timeline**: [fechas clave]
- **Tecnologías obligatorias**: [stack mandatorio]
- **Compliance**: [regulaciones aplicables]

#### 5. Supuestos Identificados
- [Listar supuestos que hace el documento]

#### 6. Ambigüedades / Gaps
- [Información faltante o contradictoria]
```

**Entregable**: `00-raw-inputs/EXTRACCION-POR-DOCUMENTO.md`

---

### PASO 1.3: Consolidación y Reconciliación ⏱️ 30 min

Identifica **contradicciones** entre documentos y resuélvelas con esta prioridad:

1. Contratos / RFPs oficiales
2. Documentos de requisitos formales
3. Presentaciones / mockups

**Entregable**: Tabla de reconciliación en `EXTRACCION-POR-DOCUMENTO.md`

| Información | Fuente 1 | Fuente 2 | Decisión |
|-------------|----------|----------|----------|
| Presupuesto | $150K (RFP) | $180K (Excel) | ✅ $150K (RFP oficial) |
| Timeline | 6 meses (RFP) | 8 meses (PPT) | ⚠️ ACLARAR con cliente |

---

## 📋 FASE 2: Análisis Profundo de Código **(NUEVO)** (2-4 horas)

### PASO 2.1: Mapeo de Estructura de Código ⏱️ 30 min

Analiza la estructura de directorios del proyecto completo:

#### Backend (si aplica)
```
00-raw-inputs/code/1-backend/
└── [nombre-proyecto]/
    ├── src/main/java/[package]/     → Código fuente
    │   ├── controller/              → Controllers REST
    │   ├── service/                 → Lógica de negocio
    │   ├── repository/              → Acceso a datos
    │   ├── model/ o domain/         → Entidades y DTOs
    │   ├── config/                  → Configuración
    │   └── util/                    → Utilidades
    ├── src/test/                    → Tests
    └── build.gradle / pom.xml       → Dependencias
```

#### Frontend
```
00-raw-inputs/code/2-frontend/
└── [nombre-proyecto]/
    ├── app/                         → Next.js App Router (o src/)
    │   ├── (public)/               → Rutas públicas
    │   ├── dashboard/              → Área privada
    │   ├── admin/                  → Panel admin
    │   └── api/                    → API routes
    ├── components/                  → Componentes React
    │   ├── ui/                     → Componentes base
    │   ├── [modulo]/               → Componentes por módulo
    │   └── layout/                 → Layout components
    ├── contexts/                    → React Context (estado)
    ├── hooks/                       → Custom hooks
    ├── lib/                         → Utilidades
    ├── types/                       → TypeScript types
    └── package.json                 → Dependencias
```

**Entregable**: `01-context-consolidated/00-mapa-modulos-codigo.md`

```markdown
# Mapa de Módulos del Código Fuente

**Fecha análisis**: [fecha]  
**Proyecto**: [nombre]

## Estructura General

### Backend: [Framework] (Java/Spring Boot/Node.js/etc.)
- **Lenguaje**: [Java 17 / Node.js / Python]
- **Framework**: [Spring Boot 3.x / NestJS / Django]
- **Build tool**: [Gradle / Maven / npm]
- **Arquitectura**: [Monolito modular / Microservicios / Serverless]

### Frontend: [Framework]
- **Lenguaje**: [TypeScript 5.x]
- **Framework**: [Next.js 14 / React 18 / Angular]
- **Build tool**: [npm / yarn / pnpm]
- **Arquitectura**: [SPA / SSR / SSG / Hybrid]

## Módulos Identificados (Backend)

[Repetir por cada módulo encontrado]

### Módulo: [Nombre - ej: "Autenticación"]

**Directorio**: `src/main/java/com/[proyecto]/auth/`  
**Responsabilidad**: [Gestión de autenticación y autorización de usuarios]

#### Componentes:

##### Controllers (Endpoints REST)
| Clase | Método HTTP | Endpoint | Descripción |
|-------|-------------|----------|-------------|
| `AuthController` | POST | `/api/auth/register` | Registro de usuarios |
| `AuthController` | POST | `/api/auth/login` | Login con email/password |
| `AuthController` | POST | `/api/auth/refresh` | Refresh de token JWT |

##### Services (Lógica de Negocio)
| Clase | Métodos Principales | Responsabilidad |
|-------|---------------------|-----------------|
| `AuthService` | `register()`, `login()`, `logout()` | Lógica de autenticación |
| `TokenService` | `generateToken()`, `validateToken()` | Gestión de JWT |

##### Repositories (Acceso a Datos)
| Interface | Entity | Métodos Custom |
|-----------|--------|----------------|
| `UserRepository` | `User` | `findByEmail()`, `existsByEmail()` |

##### Models/Entities
| Clase | Tipo | Campos Principales | Relaciones |
|-------|------|-------------------|------------|
| `User` | Entity | `id`, `email`, `password`, `role` | `@OneToMany Profile` |
| `LoginRequest` | DTO | `email`, `password` | - |
| `AuthResponse` | DTO | `token`, `refreshToken`, `user` | - |

#### Dependencias del Módulo:
- **Internas**: `UserModule`, `EmailModule`
- **Externas**: Spring Security, JWT library

#### Configuración:
| Archivo | Propósito |
|---------|-----------|
| `SecurityConfig.java` | Configuración de seguridad (CORS, JWT filter) |
| `application.yml` | `jwt.secret`, `jwt.expiration` |

---

## Módulos Identificados (Frontend)

### Módulo: [Nombre - ej: "Autenticación"]

**Directorio**: `app/(public)/auth/` + `components/auth/`  
**Responsabilidad**: [UI para registro, login, recuperación de contraseña]

#### Páginas/Rutas:
| Ruta | Archivo | Componente Principal | Descripción |
|------|---------|---------------------|-------------|
| `/auth/register` | `app/(public)/auth/register/page.tsx` | `RegisterForm` | Formulario de registro |
| `/auth/login` | `app/(public)/auth/login/page.tsx` | `LoginForm` | Formulario de login |

#### Componentes:
| Componente | Ubicación | Props Principales | Responsabilidad |
|------------|-----------|-------------------|-----------------|
| `RegisterForm` | `components/auth/RegisterForm.tsx` | `onSuccess` | Form de registro con validación |
| `LoginForm` | `components/auth/LoginForm.tsx` | `onSuccess`, `redirectTo` | Form de login |
| `AuthProvider` | `contexts/AuthContext.tsx` | `children` | Context provider de autenticación |

#### Hooks:
| Hook | Archivo | Responsabilidad |
|------|---------|-----------------|
| `useAuth` | `hooks/useAuth.ts` | Acceso al contexto de autenticación |
| `useRegister` | `hooks/useRegister.ts` | Lógica de registro con validación |

#### Types:
| Type/Interface | Archivo | Campos |
|----------------|---------|--------|
| `User` | `types/auth.ts` | `id`, `email`, `name`, `role` |
| `LoginCredentials` | `types/auth.ts` | `email`, `password` |

#### APIs Consumidas:
| Endpoint | Método | Archivo | Responsabilidad |
|----------|--------|---------|-----------------|
| `/api/auth/register` | POST | `lib/api/auth.ts` | Llamada a registro |
| `/api/auth/login` | POST | `lib/api/auth.ts` | Llamada a login |

---

## Resumen de Módulos

| # | Módulo | Backend | Frontend | Entidades | Endpoints | Páginas |
|---|--------|---------|----------|-----------|-----------|---------|
| 1 | Autenticación | ✅ | ✅ | 2 | 5 | 3 |
| 2 | Usuarios/Perfiles | ✅ | ✅ | 3 | 8 | 4 |
| 3 | [Otros módulos] | ... | ... | ... | ... | ... |

**Total Módulos Backend**: [número]  
**Total Módulos Frontend**: [número]  
**Total Endpoints REST**: [número]  
**Total Páginas/Rutas**: [número]
```

---

### PASO 2.2: Inventario de Componentes Técnicos ⏱️ 45 min

Analiza **dependencias y stack tecnológico real** del código:

**Entregable**: `01-context-consolidated/00-inventario-componentes.md`

```markdown
# Inventario de Componentes Técnicos

**Fecha análisis**: [fecha]

---

## Backend: Dependencias y Tecnologías

### Core Framework
- **Spring Boot**: 3.2.0
- **Java**: 17
- **Build Tool**: Gradle 8.5

### Dependencias Principales
| Dependencia | Versión | Propósito | Módulos que la usan |
|-------------|---------|-----------|---------------------|
| spring-boot-starter-web | 3.2.0 | REST APIs | Todos |
| spring-boot-starter-data-jpa | 3.2.0 | Persistencia ORM | Autenticación, Usuarios, Reservas |
| spring-boot-starter-security | 3.2.0 | Seguridad | Autenticación |
| jjwt | 0.12.3 | JWT tokens | Autenticación |
| postgresql | 42.7.1 | Base de datos | Persistencia |
| lombok | 1.18.30 | Boilerplate reduction | Todos |
| springdoc-openapi | 2.3.0 | Documentación API | - |

### Configuración de Base de Datos
```yaml
# Extraído de application.yml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/[db_name]
    username: [user]
  jpa:
    hibernate:
      ddl-auto: update
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQLDialect
```

### Configuración de Seguridad
- **Autenticación**: JWT (JSON Web Tokens)
- **Algoritmo**: HS512
- **Expiración token**: [X horas]
- **Refresh token**: [habilitado/no]

---

## Frontend: Dependencias y Tecnologías

### Core Framework
- **Next.js**: 14.1.0 (App Router)
- **React**: 18.2.0
- **TypeScript**: 5.3.3
- **Node.js**: 18.x (mínimo)

### Dependencias Principales
| Dependencia | Versión | Propósito | Módulos que la usan |
|-------------|---------|-----------|---------------------|
| next | 14.1.0 | Framework SSR/SSG | - |
| react / react-dom | 18.2.0 | UI library | - |
| tailwindcss | 3.4.0 | CSS framework | UI |
| @heroicons/react | 2.1.1 | Iconos | UI |
| axios | 1.6.5 | HTTP client | API calls |
| react-hook-form | 7.49.3 | Forms | Autenticación, Formularios |
| zod | 3.22.4 | Validación | Autenticación, Formularios |
| zustand | 4.4.7 | Estado global | Todos |

### Configuración de Build
```json
// Extraído de package.json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  }
}
```

### Variables de Entorno Requeridas
```env
# Extraído de .env.example
NEXT_PUBLIC_API_URL=http://localhost:8080/api
NEXT_PUBLIC_APP_NAME=MI-TOGA
```

---

## Infraestructura y Servicios Externos

### Base de Datos
- **Tipo**: PostgreSQL 15
- **ORM**: Hibernate (JPA)
- **Migraciones**: [Flyway / Liquibase / Manual]

### Servicios Externos Integrados
| Servicio | Propósito | Configuración |
|----------|-----------|---------------|
| SendGrid / AWS SES | Email transaccional | API Key en env vars |
| Stripe / PayU | Procesamiento de pagos | API Key + Webhook secret |
| AWS S3 / Cloudinary | Almacenamiento de archivos | Bucket config |
| Twilio | SMS / Videollamadas | API credentials |

### Monitoreo y Observabilidad
| Herramienta | Propósito | Estado |
|-------------|-----------|--------|
| Spring Actuator | Health checks, metrics | ✅ Configurado |
| Prometheus | Métricas | ⚠️ Pendiente |
| Sentry | Error tracking | ❌ No configurado |

---

## Patrones y Convenciones Identificados

### Backend
- **Arquitectura**: Layered (Controller → Service → Repository)
- **Naming conventions**:
  - Controllers: `*Controller.java`
  - Services: `*Service.java`, `*ServiceImpl.java`
  - Repositories: `*Repository.java`
  - DTOs: `*Request.java`, `*Response.java`
- **Exception handling**: Global `@ControllerAdvice`
- **Validation**: Bean Validation (`@Valid`, `@NotNull`)

### Frontend
- **Arquitectura**: Feature-based modules
- **Naming conventions**:
  - Components: PascalCase (`UserCard.tsx`)
  - Hooks: camelCase prefijo `use*` (`useAuth.ts`)
  - Types: PascalCase (`User`, `LoginCredentials`)
- **State management**: Zustand (stores modulares)
- **Styling**: Tailwind utility classes + custom components

---

## Análisis de Calidad del Código

### Coverage de Tests
| Capa | Backend | Frontend |
|------|---------|----------|
| Unit tests | ⚠️ Parcial (~40%) | ❌ No implementado |
| Integration tests | ✅ Completo | ❌ No implementado |
| E2E tests | ❌ No implementado | ❌ No implementado |

### Linting y Formatting
| Herramienta | Backend | Frontend | Configurado |
|-------------|---------|----------|-------------|
| ESLint | N/A | ✅ | ✅ |
| Prettier | N/A | ⚠️ | ❌ |
| Checkstyle | ⚠️ | N/A | ⚠️ Parcial |

### Documentación de Código
- **Backend**: Javadoc parcial (~30% de clases)
- **Frontend**: JSDoc/TSDoc mínimo (~10%)
- **API**: Swagger/OpenAPI [disponible en `/api-docs` si aplicable]

---

## Deuda Técnica Identificada

### 🔴 CRÍTICO
- [ ] Falta manejo de excepciones consistente en [módulo X]
- [ ] Contraseñas hasheadas sin salt suficiente
- [ ] SQL injection vulnerable en [query específico]

### 🟡 IMPORTANTE
- [ ] Duplicación de lógica entre [ServicioA] y [ServicioB]
- [ ] Falta validación de inputs en frontend (solo backend)
- [ ] Logs insuficientes para debugging en producción

### 🟢 MEJORA
- [ ] Refactorizar componente monolítico [ComponenteX]
- [ ] Extraer constantes mágicas a archivo de configuración
- [ ] Mejorar naming de variables en [módulo Y]
```

---

### PASO 2.3: Ingeniería Inversa: Código → Requisitos ⏱️ 1-2 horas

Para cada **módulo identificado en el código**, genera requisitos funcionales:

**Proceso:**
1. Analiza los **endpoints REST** (backend) → RF de API
2. Analiza las **páginas/rutas** (frontend) → RF de interfaz
3. Analiza la **lógica de negocio** (services) → RF de reglas de negocio
4. Analiza las **validaciones** → RF de constraints

**Template de RF extraído de código:**

```markdown
### RF-[ID]: [Nombre Funcionalidad]

**Prioridad**: Must Have *(inferida: endpoint implementado en MVP)*  
**Fuente**: Código fuente - `[clase/archivo]`

**Historia de Usuario** *(reconstruida)*:
Como [tipo de usuario inferido],
Quiero [acción que permite el endpoint/página],
Para [beneficio inferido del contexto].

**Implementación Actual**:
- **Backend**: `[ControllerClass].[method]` → `POST /api/[endpoint]`
- **Frontend**: `app/[ruta]/page.tsx` → Componente `[ComponentName]`

**Criterios de Aceptación** *(extraídos de validaciones en código)*:
1. [Validación 1 - ej: "Email debe tener formato válido" (@Email annotation)]
2. [Validación 2 - ej: "Contraseña mínimo 8 caracteres" (validación en service)]
3. [Validación 3 - ej: "Campo X es obligatorio" (@NotNull annotation)]

**Dependencias Técnicas**:
- Servicios: `[ServiceClass]`
- Entidades: `[EntityClass]`
- Integraciones externas: [si aplica]

**Ejemplo de Request/Response**:
```json
// Request
{
  "email": "user@example.com",
  "password": "SecureP@ss123"
}

// Response (200 OK)
{
  "token": "eyJhbGc...",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "role": "USER"
  }
}
```

**Estado de Implementación**: ✅ Completo / ⚠️ Parcial / ❌ Incompleto

**Notas**:
- [Observaciones sobre la implementación]
- [Posibles gaps o inconsistencias]
```

**Resultado esperado**: Mínimo **50-80 requisitos funcionales** extraídos del código, que se fusionarán con los de la documentación.

---

## 📋 FASE 3: Consolidación Final (1-2 horas)

### PASO 3.1: Fusionar Requisitos de Docs + Código ⏱️ 45 min

Combina requisitos de **documentación** y **código** resolviendo:

1. **Requisitos en docs pero NO en código** → Marcar como "❌ No implementado"
2. **Requisitos en código pero NO en docs** → Marcar como "⚠️ No documentado (implementado)"
3. **Requisitos en ambos** → Validar consistencia, marcar como "✅ Completo"

**Template de requisito consolidado:**

```markdown
### RF-042: Búsqueda de Tutores por Materia

**Prioridad**: Must Have  
**Estado Implementación**: ✅ Completo  
**Fuente Documentación**: RFP-2024.pdf p.18, Excel-Backlog.xlsx  
**Fuente Código**: `TutorController.searchBySubject()`, `app/tutors/search/page.tsx`

**Historia de Usuario**:
Como estudiante,
Quiero buscar tutores filtrando por materia y nivel,
Para encontrar el tutor adecuado para mi necesidad específica.

**Criterios de Aceptación** *(validado docs + código)*:
1. ✅ Filtro por materia (dropdown con lista de materias)
2. ✅ Filtro por nivel (básico, intermedio, avanzado)
3. ✅ Resultados paginados (20 por página)
4. ⚠️ Ordenamiento por rating (en docs, no implementado en código)
5. ❌ Filtro por rango de precio (en docs, no implementado)

**Implementación**:
- **Backend**: `GET /api/tutors/search?subject={id}&level={level}&page={n}`
- **Frontend**: Página `/tutors/search` con `SearchFilters` component

**Gaps Identificados**:
- Ordenamiento por rating mencionado en RFP pero no implementado
- Filtro de precio en backlog Excel pero ausente en código

**Recomendación**: Implementar filtros faltantes en Sprint 2
```

---

### PASO 3.2: Generar Archivos Finales ⏱️ 1 hora

Completa los **3 archivos principales** con toda la información consolidada:

---

#### 📄 `01-context-consolidated/01-contexto-negocio.md`

**Estructura** (usar plantilla `01-contexto-negocio.md` del directorio):

1. **Descripción del Proyecto**
   - Nombre oficial
   - Descripción general (3-5 párrafos)
   - Fecha inicio y estado actual
   - *Extraer de: RFP, PROYECTO_CONTEXTO.md, contratos*

2. **Objetivos de Negocio**
   - Objetivos SMART (3-5)
   - KPIs con valores objetivo
   - *Extraer de: business case, presentaciones ejecutivas*

3. **Stakeholders**
   - Tabla de stakeholders internos
   - Tabla de stakeholders externos
   - *Extraer de: organigramas, documentos de proyecto*

4. **Usuarios Objetivo**
   - Segmentos de usuarios con perfiles
   - Volumetría esperada
   - *Extraer de: user personas, docs de mercado, código (roles implementados)*

5. **Modelo de Negocio**
   - Tipo de modelo (B2B/B2C/SaaS/etc.)
   - Fuentes de ingreso
   - Estructura de costos
   - *Extraer de: business plan, presentaciones comerciales*

6. **Alcance y Limitaciones**
   - Funcionalidades en alcance (validadas con código)
   - Funcionalidades fuera de alcance
   - Alcance condicional
   - *Cruzar: docs + código implementado*

**Criterio de completitud**: ✅ Sin secciones vacías, referencias a fuentes, trazabilidad.

---

#### 📄 `01-context-consolidated/02-requisitos-funcionales.md`

**Estructura** (usar plantilla `02-requisitos-funcionales.md` del directorio):

1. **Introducción**
   - Propósito del documento
   - Alcance funcional
   - Convenciones usadas

2. **Módulos del Sistema**
   - Lista de módulos identificados (docs + código)
   - Descripción de responsabilidad de cada módulo
   - Relaciones entre módulos

3. **Requisitos Funcionales por Módulo**
   - Para cada módulo, listar RFs con formato:
     ```markdown
     ### RF-XXX: [Nombre]
     - **Prioridad**: Must/Should/Could/Won't
     - **Estado**: ✅ Implementado / ⚠️ Parcial / ❌ No implementado
     - **Fuente Docs**: [referencia]
     - **Fuente Código**: [clase/archivo]
     - **Historia de Usuario**: Como... Quiero... Para...
     - **Criterios de Aceptación**: [lista]
     - **Dependencias**: [otros RFs]
     - **Notas**: [gaps, inconsistencias]
     ```

4. **Resumen de Priorización**
   - Tabla consolidada Must/Should/Could/Won't
   - Total de RFs por módulo
   - % de implementación actual (código vs docs)

5. **Matriz de Trazabilidad**
   - Tabla: RF ↔ Componente Código ↔ Documento Fuente

**Criterio de completitud**: ✅ Mínimo 50 RFs, 100% priorizados, trazabilidad completa.

---

#### 📄 `01-context-consolidated/03-requisitos-no-funcionales.md`

**Estructura** (usar plantilla `03-requisitos-no-funcionales.md` del directorio):

1. **Performance y Escalabilidad**
   - RNF de tiempo de respuesta (con métricas)
   - RNF de escalabilidad (usuarios concurrentes)
   - RNF de volumen de datos
   - *Extraer de: SLAs, docs técnicos, configuración de infra en código*

2. **Disponibilidad y Confiabilidad**
   - RNF de uptime (SLA)
   - RNF de tolerancia a fallos
   - RNF de recuperación ante desastres
   - *Extraer de: contratos, SLAs, configuración de health checks en código*

3. **Seguridad**
   - RNF de autenticación (método, tokens)
   - RNF de autorización (roles, permisos)
   - RNF de encriptación (datos en tránsito y reposo)
   - RNF de compliance (GDPR, PCI-DSS)
   - *Extraer de: políticas de seguridad, SecurityConfig en código, dependencias de seguridad*

4. **Usabilidad**
   - RNF de accesibilidad (WCAG)
   - RNF de experiencia de usuario
   - RNF de internacionalización (i18n)
   - *Extraer de: guías de diseño, componentes UI en código*

5. **Mantenibilidad y Portabilidad**
   - RNF de cobertura de tests
   - RNF de documentación de código
   - RNF de compatibilidad de navegadores/dispositivos
   - *Extraer de: análisis de tests en código, configuración de build*

6. **Restricciones Técnicas**
   - Stack tecnológico obligatorio
   - Restricciones de infraestructura
   - Restricciones de integración
   - *Extraer de: contratos, dependencias reales del código*

**Criterio de completitud**: ✅ RNFs cuantificados (números, métricas), validados con implementación actual.

---

## ✅ Checklist de Entregables Finales

Al completar este prompt, debes haber generado:

### Archivos Obligatorios:

- [ ] `01-context-consolidated/01-contexto-negocio.md` ✅ Completo, sin placeholders
- [ ] `01-context-consolidated/02-requisitos-funcionales.md` ✅ Mínimo 50 RFs
- [ ] `01-context-consolidated/03-requisitos-no-funcionales.md` ✅ RNFs cuantificados
- [ ] `01-context-consolidated/00-mapa-modulos-codigo.md` 🆕 Mapeo completo de módulos
- [ ] `01-context-consolidated/00-inventario-componentes.md` 🆕 Stack técnico completo

### Archivos de Soporte:

- [ ] `00-raw-inputs/INVENTARIO-DOCUMENTOS.md` ✅ Clasificación de docs
- [ ] `00-raw-inputs/EXTRACCION-POR-DOCUMENTO.md` ✅ Detalle por documento
- [ ] `01-context-consolidated/00-supuestos-y-pendientes.md` ⚠️ Gaps documentados

---

## 📊 Criterios de Éxito

### ✅ Completitud:
- 95%+ de información consolidada (docs + código)
- Gaps críticos documentados con plan de mitigación
- Trazabilidad bidireccional: docs ↔ código

### ✅ Calidad:
- Información estructurada y fácil de consultar
- Sin contradicciones sin resolver
- Referencias a fuentes (página, línea de código)

### ✅ Accionabilidad:
- Agentes posteriores pueden trabajar autónomamente
- Contexto suficiente para decisiones arquitectónicas
- Requisitos listos para ser convertidos en HUs

### ✅ Profundidad Técnica: 🆕
- Cada módulo de código mapeado y documentado
- Inventario completo de componentes y dependencias
- Ingeniería inversa código → requisitos realizada

---

## 🚀 Prompt de Ejecución

**Copia y pega este prompt cuando estés listo:**

```
Hola, necesito que asumas el rol de Business Analyst Senior + Software Architect.

OBJETIVO: Consolidar documentación del cliente Y analizar código fuente 
para generar contexto profundo y completo.

PROCESO:

1. FASE 1: Análisis de Documentación (2-3h)
   - Lee TODOS los archivos en 00-raw-inputs/
   - Extrae contexto de negocio, requisitos funcionales y no funcionales
   - Genera: INVENTARIO-DOCUMENTOS.md y EXTRACCION-POR-DOCUMENTO.md

2. FASE 2: Análisis Profundo de Código (2-4h) 🆕
   - Mapea estructura completa del código (backend + frontend)
   - Identifica módulos, componentes, endpoints, páginas
   - Analiza dependencias y stack tecnológico real
   - Realiza ingeniería inversa: código → requisitos
   - Genera: 00-mapa-modulos-codigo.md y 00-inventario-componentes.md

3. FASE 3: Consolidación Final (1-2h)
   - Fusiona requisitos de docs + código
   - Resuelve contradicciones priorizando: RFP → Docs → Código
   - Valida consistencia y marca gaps (❌ No implementado, ⚠️ Parcial)
   - Genera archivos finales consolidados

ENTREGABLES:
- 01-context-consolidated/01-contexto-negocio.md
- 01-context-consolidated/02-requisitos-funcionales.md
- 01-context-consolidated/03-requisitos-no-funcionales.md
- 01-context-consolidated/00-mapa-modulos-codigo.md 🆕
- 01-context-consolidated/00-inventario-componentes.md 🆕

INSTRUCCIONES DETALLADAS:
Sigue el prompt maestro en:
02-agents/0.consolidation_context/mst_consolidacion-contexto-profundo.md

Al finalizar, indícame:
- ✅ Consolidación completa con estadísticas
- ⚠️ Gaps críticos identificados
- 🔴 Información faltante que requiere acción

¡Comencemos con FASE 1!
```

---

## 📝 Notas Finales

### Tiempo Estimado Total:

- Proyectos pequeños (< 10 módulos): 4-6 horas
- Proyectos medianos (10-20 módulos): 6-10 horas
- Proyectos grandes (> 20 módulos): 10-16 horas

### Principios Clave:

1. **Honestidad sobre Gaps**: Mejor documentar que no sabes, que asumir incorrectamente
2. **Trazabilidad Total**: Cada afirmación debe tener fuente (doc o código)
3. **Validación Cruzada**: Docs deben coincidir con código (o gap documentado)
4. **Pragmatismo**: Enfócate en lo crítico primero, detalles después

---

**¡Éxito en la consolidación profunda!** 🎯🚀

---

**Versión**: 2.0.0  
**Última actualización**: 2025-11-08  
**Autor**: Equipo ZES-METHOD / ZNS v2.0
