# 🤖 Ecosistema de Agentes IA - ZENAPSES

## 📋 Índice de Chatmodes (Nivel Senior)

Sistema completo de agentes especializados para el desarrollo de software enterprise siguiendo metodología **ZNS v2.0**.

---

## 🎯 Agentes por Categoría

### 📊 Analysis & Context (2 agentes)

#### 1. **zns.context.consolidation** - Context Consolidation Master
- **Rol:** Business Analyst + Software Architect + Requirements Engineer
- **Inputs:** `00-raw-inputs/**`, código fuente
- **Outputs:** Contexto consolidado, requisitos (RF/RNF), mapas de código
- **Duración:** 4-8 horas
- **Tags:** business-analysis, requirements, code-analysis, documentation
- **Prompt maestro:** `02-agents/0.consolidation_context/mst_consolidacion-contexto-profundo.md`

**Cuándo usar:**
- Inicio de proyecto (análisis completo)
- Auditoría de contexto existente
- Ingeniería inversa de sistemas legacy

---

#### 2. **zns.analysis.obsolescence** - Technical Debt & Obsolescence Analyst
- **Rol:** Technical Debt Analyst + Platform Architect
- **Inputs:** Contexto consolidado, repositorio del proyecto
- **Outputs:** Reporte de obsolescencia, matriz de riesgos, plan de modernización
- **Duración:** 3-5 horas
- **Tags:** technical-debt, obsolescence, security, modernization, cve
- **Prompt maestro:** `02-agents/1.obsolescence_analysis/prompt-analisis-obsolescencia.md`

**Cuándo usar:**
- Proyectos legacy con deuda técnica
- Antes de iniciar modernización
- Auditorías de seguridad (CVEs)
- Planificación de upgrades

---

### 🏗️ Architecture & Design (3 agentes)

#### 3. **zns.solutions.architect** - Solutions Architect (Cloud & Enterprise)
- **Rol:** Solutions Architect + Cloud Architect
- **Inputs:** Contexto consolidado, análisis de obsolescencia
- **Outputs:** ADRs, diagramas C4 (L1/L2/L3), especificaciones técnicas
- **Duración:** 6-10 horas
- **Tags:** architecture, solutions, cloud, microservices, adrs, c4-model, ddd
- **Prompt maestro:** `02-agents/2.definition_of_architecture/prompt-arquitectura-soluciones.md`

**Cuándo usar:**
- Diseño de arquitectura de soluciones
- Definición de bounded contexts (DDD)
- Decisiones técnicas críticas (ADRs)
- Arquitectura cloud-native

---

#### 4. **zns.data.modeler** - Data Modeler & Database Designer
- **Rol:** Data Modeler + Database Designer
- **Inputs:** Requisitos funcionales, ADRs
- **Outputs:** Modelo conceptual/lógico/físico, ERD (PlantUML), diccionario de datos
- **Duración:** 4-6 horas
- **Tags:** data-modeling, erd, ddd, normalization, database-design
- **Prompt maestro:** `02-agents/2.definition_of_architecture/prompt-modelado-datos.md`

**Cuándo usar:**
- Diseño de base de datos desde cero
- Modelado de aggregates (DDD)
- Normalización/denormalización estratégica
- Documentación de diccionario de datos

---

#### 5. **zns.dba.database.engineer** - PostgreSQL Database Engineer
- **Rol:** Database Engineer + PostgreSQL Architect
- **Inputs:** Modelo de datos, requisitos funcionales
- **Outputs:** Flyway migrations, scripts SQL, optimización de queries
- **Duración:** 4-6 horas
- **Tags:** postgresql, database, ddd, data-modeling, performance, migrations, flyway
- **Prompt maestro:** `02-agents/10.database_engineer_senior/prompt-ingeniero-base-datos-senior.md`

**Cuándo usar:**
- Implementación física de base de datos
- Optimización de performance (queries, índices)
- Migrations evolutivas (Flyway)
- Estrategias de particionamiento y replicación

---

### 👨‍💻 Development (2 agentes)

#### 6. **zns.dev.backend** - Backend Developer Senior (Java + Spring Boot)
- **Rol:** Backend Developer + Java Expert
- **Inputs:** HUTs (Historias de Usuario Técnicas), ADRs, modelo de datos
- **Outputs:** Código Java/Spring Boot (Hexagonal Architecture)
- **Duración:** Variable por HUT
- **Tags:** backend, java, spring-boot, hexagonal, ddd, clean-code, tdd
- **Prompt maestro:** `02-agents/9.backend_senior_Java_developer/prompt-desarrollador-backend-senior.md`

**Cuándo usar:**
- Implementación de servicios backend
- Desarrollo con arquitectura hexagonal
- Aplicación de DDD táctico
- Refactoring de código legacy

---

#### 7. **zns.dev.frontend** - Frontend Developer Senior (React + Next.js)
- **Rol:** Frontend Developer + React Expert
- **Inputs:** HUTs, diseño UI/UX, especificaciones de APIs
- **Outputs:** Código React/Next.js (TypeScript, Tailwind CSS)
- **Duración:** Variable por HUT
- **Tags:** frontend, react, nextjs, typescript, tailwind, accessibility, performance
- **Prompt maestro:** `02-agents/11.frontend_senior_React_developer/prompt-desarrollador-frontend-react-senior.md`

**Cuándo usar:**
- Desarrollo de interfaces de usuario
- Optimización de rendimiento (Core Web Vitals)
- Implementación de accesibilidad (WCAG 2.1 AA)
- Testing E2E (Playwright/Cypress)

---

### 🔧 Infrastructure & DevOps (1 agente)

#### 8. **zns.devsecops.onpremise** - DevSecOps Engineer (K3s/K8s)
- **Rol:** DevSecOps Engineer + Infrastructure Specialist
- **Inputs:** ADRs, Dockerfiles, especificaciones de infraestructura
- **Outputs:** Manifests K8s, CI/CD pipelines, monitoring stack
- **Duración:** 6-8 horas
- **Tags:** devsecops, kubernetes, k3s, ci-cd, monitoring, security, docker
- **Prompt maestro:** `02-agents/12.devsecops_onpremise_senior/prompt-devsecops-onpremise-senior.md`

**Cuándo usar:**
- Setup de infraestructura K3s/K8s
- Configuración de CI/CD (GitHub Actions, GitLab CI)
- Deploy de Prometheus + Grafana
- Security hardening (NetworkPolicies, RBAC)

---

### 🔍 Audit & Quality (3 agentes)

#### 9. **zns.audit.frontend** - Frontend Auditor (React Performance Expert)
- **Rol:** Frontend Auditor + Performance Expert
- **Inputs:** Código frontend (React/Next.js)
- **Outputs:** Reportes de auditoría (performance, accesibilidad, seguridad)
- **Duración:** 4-6 horas
- **Tags:** frontend-audit, react, nextjs, performance, accessibility, security
- **Prompt maestro:** `02-agents/5.frontend_audit/prompt-auditoria-frontend.md`

**Cuándo usar:**
- Auditoría de rendimiento (Lighthouse, Core Web Vitals)
- Análisis de accesibilidad (WCAG 2.1)
- Security scan (CSP, XSS, CSRF)
- Code quality review

---

#### 10. **zns.audit.backend** - Backend Auditor (Java + Spring Boot)
- **Rol:** Backend Auditor + Java Expert
- **Inputs:** Código backend (Java/Spring Boot)
- **Outputs:** Reportes de auditoría (arquitectura, seguridad, performance)
- **Duración:** 6-8 horas
- **Tags:** backend-audit, java, spring-boot, security, performance, clean-code
- **Prompt maestro:** `02-agents/6.backend_audit/prompt-auditoria-backend.md`

**Cuándo usar:**
- Auditoría de arquitectura (Hexagonal, DDD)
- Análisis de seguridad (OWASP Top 10)
- Performance tuning (queries N+1, caching)
- Code smells detection (SonarQube)

---

#### 11. **zns.quality.validation** - Quality Validator & Compliance Officer
- **Rol:** Quality Validator + Compliance Officer
- **Inputs:** Documentación consolidada, arquitectura, deliverables
- **Outputs:** Reportes de validación (completitud, consistencia, trazabilidad)
- **Duración:** 2-3 horas
- **Tags:** validation, quality, compliance, consistency, completeness, ieee-830
- **Prompt maestro:** `02-agents/4.validation_quality/prompt-validar-outputs.md`

**Cuándo usar:**
- Validación de entregables antes de presentar
- Quality gates en proceso ZNS
- Auditoría de consistencia documental
- Verificación de estándares IEEE 830

---

### 📝 Product & Stories (2 agentes)

#### 12. **zns.po.business.analyst** - Product Owner & Business Analyst
- **Rol:** Product Owner + Business Analyst
- **Inputs:** Contexto de negocio, requisitos funcionales
- **Outputs:** Historias de Usuario (HUs), backlog priorizado, roadmap
- **Duración:** 6-8 horas
- **Tags:** product-owner, business-analyst, user-stories, backlog, agile, scrum
- **Prompt maestro:** `02-agents/7.product_owner_senior_y_business_analyst/prompt-product-owner-business-analyst.md`

**Cuándo usar:**
- Transformación de requisitos en HUs
- Priorización de backlog (MoSCoW)
- Definición de roadmap de producto
- Refinamiento de historias de usuario

---

#### 13. **zns.stories.technical** - Technical User Stories Engineer
- **Rol:** Technical Stories Engineer
- **Inputs:** Historias de Usuario (HUs), ADRs, especificaciones
- **Outputs:** Historias de Usuario Técnicas (HUTs), tareas técnicas detalladas
- **Duración:** 4-6 horas
- **Tags:** technical-stories, huts, implementation, tasks, architecture
- **Prompt maestro:** `02-agents/8.technical_user_stories/prompt-historias-usuario-tecnicas.md`

**Cuándo usar:**
- Descomposición de HUs en tareas técnicas
- Definición de criterios de aceptación técnicos
- Estimación de esfuerzo técnico
- Planificación de sprints

---

### 📄 Documentation (1 agente)

#### 14. **zns.export.documents** - Document Exporter (Word/PDF)
- **Rol:** Document Exporter + Technical Writer
- **Inputs:** Documentación consolidada, diagramas PlantUML
- **Outputs:** Word/PDF profesionales con branding corporativo
- **Duración:** 2-3 horas
- **Tags:** export, word, pdf, documentation, reports, plantuml
- **Prompt maestro:** `02-agents/3.exporting_documents/prompt-exportacion-word.md`

**Cuándo usar:**
- Generación de documentación para clientes
- Exportación de ADRs para stakeholders
- Creación de manuales técnicos
- Reportes ejecutivos

---

## 🔄 Flujo de Trabajo Recomendado

### Fase 0: Preparación
```
1. zns.context.consolidation → Consolidar contexto completo
2. zns.analysis.obsolescence → Analizar deuda técnica (opcional)
```

### Fase 1: Arquitectura
```
3. zns.solutions.architect → Diseñar arquitectura, ADRs, C4
4. zns.data.modeler → Modelar datos (conceptual, lógico)
5. zns.dba.database.engineer → Implementar schema físico
```

### Fase 2: Desarrollo
```
6. zns.po.business.analyst → Crear HUs desde requisitos
7. zns.stories.technical → Descomponer HUs en HUTs
8. zns.dev.backend → Implementar backend (Java/Spring)
9. zns.dev.frontend → Implementar frontend (React/Next.js)
```

### Fase 3: Infraestructura
```
10. zns.devsecops.onpremise → Setup K3s, CI/CD, monitoring
```

### Fase 4: Quality Assurance
```
11. zns.audit.backend → Auditar backend
12. zns.audit.frontend → Auditar frontend
13. zns.quality.validation → Validar entregables
```

### Fase 5: Delivery
```
14. zns.export.documents → Exportar documentación (Word/PDF)
```

---

## 📊 Matriz de Agentes vs Entregables

| Agente                  | Contexto | Análisis | Arquitectura | Código | Infra | Docs |
|-------------------------|----------|----------|--------------|--------|-------|------|
| context.consolidation   | ✅✅✅   | ✅       |              |        |       | ✅   |
| analysis.obsolescence   |          | ✅✅✅   |              |        |       | ✅   |
| solutions.architect     |          |          | ✅✅✅        |        |       | ✅   |
| data.modeler            |          |          | ✅✅         |        |       | ✅   |
| dba.database.engineer   |          |          | ✅           | ✅✅   |       | ✅   |
| po.business.analyst     | ✅       |          |              |        |       | ✅   |
| stories.technical       |          |          | ✅           |        |       | ✅   |
| dev.backend             |          |          |              | ✅✅✅ |       |      |
| dev.frontend            |          |          |              | ✅✅✅ |       |      |
| devsecops.onpremise     |          |          |              |        | ✅✅✅ | ✅   |
| audit.backend           |          | ✅✅     |              | ✅     |       | ✅   |
| audit.frontend          |          | ✅✅     |              | ✅     |       | ✅   |
| quality.validation      |          | ✅✅     | ✅           | ✅     |       | ✅✅ |
| export.documents        |          |          |              |        |       | ✅✅✅|

---

## 🎯 Principios de los Agentes

### 1. **Especialización**
Cada agente es experto en su dominio específico, no un generalista.

### 2. **Interoperabilidad**
Los outputs de un agente son inputs de otro (pipeline).

### 3. **Trazabilidad**
Toda decisión/entregable referencia su origen (requisito → diseño → código).

### 4. **Calidad por Diseño**
Estándares incorporados (ZNS, IEEE 830, C4 Model, DDD, Clean Code).

### 5. **Documentación como Código**
Todo en Git, markdown, PlantUML (versionado, reviewable).

### 6. **Filosofía Senior**
Cada agente sigue mentalidad de ingeniero senior:
- Trade-offs explícitos
- Justificaciones técnicas
- Alternativas consideradas
- Consecuencias documentadas

---

## 🏆 Estándares y Metodologías

### Arquitectura
- ✅ **C4 Model** (Simon Brown) - Diagramación de arquitectura
- ✅ **ADRs** (Michael Nygard) - Decisiones arquitectónicas
- ✅ **Hexagonal Architecture** (Alistair Cockburn) - Backend
- ✅ **Domain-Driven Design** (Eric Evans) - Modelado de dominio

### Calidad
- ✅ **IEEE 830** - Especificación de requisitos de software
- ✅ **ISO 29148** - Ingeniería de requisitos
- ✅ **ISO/IEC 25010** (SQuaRE) - Modelo de calidad de software
- ✅ **Clean Code** (Robert C. Martin) - Código limpio

### Seguridad
- ✅ **OWASP Top 10** - Vulnerabilidades web
- ✅ **WCAG 2.1 AA** - Accesibilidad web
- ✅ **CWE Top 25** - Debilidades de software

### Metodología
- ✅ **ZNS v2.0** - Metodología propia de ingeniería de software
- ✅ **Agile Scrum** - Gestión de producto
- ✅ **GitOps** - Infraestructura como código

---

## 📚 Estructura de Carpetas Proyecto

```
proyecto/
├── 00-raw-inputs/              # Inputs originales
│   ├── pdfs/
│   ├── excel/
│   ├── word/
│   ├── code/                   # Código fuente
│   └── database/               # Scripts SQL
│
├── 01-context-consolidated/    # Contexto consolidado
│   ├── 01-contexto-negocio.md
│   ├── 02-requisitos-funcionales.md
│   ├── 03-requisitos-no-funcionales.md
│   ├── 00-mapa-modulos-codigo.md
│   └── 00-inventario-componentes.md
│
├── 02-agents/                  # Prompts maestros
│   ├── 0.consolidation_context/
│   ├── 1.obsolescence_analysis/
│   ├── 2.definition_of_architecture/
│   └── ...
│
├── 03-analysis/                # Análisis técnicos
│   ├── frontend-analysis/
│   ├── backend-analysis/
│   └── reporte-obsolescencia.md
│
├── 04-architecture/            # Arquitectura
│   ├── adrs/                   # ADRs
│   ├── diagrams/               # C4 PlantUML
│   ├── model-data/             # Modelado de datos
│   └── specs/                  # Especificaciones técnicas
│
├── 05-deliverables/            # Entregables
│   ├── hus/                    # Historias de Usuario
│   ├── huts/                   # Historias Técnicas
│   ├── exports/                # Word/PDF
│   └── infrastructure/         # K8s manifests
│
├── 06-scripts/                 # Scripts utilitarios
│   ├── export_to_word.py
│   └── check_docx_for_plantuml.py
│
└── .github/
    └── chatmodes/              # Agentes IA (este directorio)
```

---

## 🚀 Quickstart

### 1. Activar un agente
```bash
# En GitHub Copilot Chat:
@workspace /zns.context.consolidation

# El agente se activará y preguntará:
🎯 Consolidación de Contexto Activada
¿Qué necesitas consolidar?
1. 📋 Análisis completo (docs + código) 
2. 📄 Solo documentación (sin código)
...
```

### 2. Flujo completo
```bash
# Paso 1: Consolidar contexto
@workspace /zns.context.consolidation
> Seleccionar "Análisis completo"

# Paso 2: Analizar obsolescencia (opcional)
@workspace /zns.analysis.obsolescence

# Paso 3: Diseñar arquitectura
@workspace /zns.solutions.architect

# Paso 4: Modelar datos
@workspace /zns.data.modeler

# ... continuar con resto de agentes
```

---

## 📞 Soporte

**Equipo:** Zenapses Tech Team  
**Versión:** 2.0  
**Última actualización:** 2025-11-13  
**Metodología:** ZNS v2.0  

---

## 📄 Licencia

Copyright © 2025 Zenapses. Todos los derechos reservados.

---

## 🔗 Referencias

- [C4 Model](https://c4model.com/)
- [Architecture Decision Records](https://adr.github.io/)
- [Domain-Driven Design](https://martinfowler.com/bliki/DomainDrivenDesign.html)
- [Hexagonal Architecture](https://alistair.cockburn.us/hexagonal-architecture/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [ZNS Methodology](internal documentation)
