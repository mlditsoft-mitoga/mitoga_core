# Método CEIBA - Framework de Arquitectura de Prompts

> **C**onsolidación · **E**structuración · **I**nteligencia · **B**est Practices · **A**rquitectura

**Versión:** 1.2  
**Fecha:** 7 de noviembre de 2025  
**Autor:** ing. Wilmer Giovanny Torres Achury

---

## 🎉 Novedades en v1.2

### ✨ Mejoras Implementadas (7 nov 2025)

1. **🏷️ Versionamiento Individual de Prompts**
   - Cada prompt ahora tiene su propia versión (`prompt_version`)
   - Changelog detallado de cambios por prompt
   - Trazabilidad de evolución independiente del método

2. **📚 Caso de Estudio Completo: ShopFast E-commerce**
   - Ejemplo end-to-end de ejecución del método
   - Inputs simulados (RFP, checklist técnico)
   - Ejecución paso a paso documentada
   - Ver: `07-tools/ejemplos/shopfast-ecommerce-mvp/`

3. **✅ Agente 4: Validación de Calidad**
   - Nueva fase de auditoría de documentación
   - 5 dimensiones: Completitud, Consistencia, Corrección, Claridad, Compliance
   - Score global 0-100 con plan de corrección
   - 2 checklists exhaustivos incluidos
   - Ver: `02-agents/4.validation_quality/`

### 📊 Calidad del Framework

**Auditoría de Arquitectura de Prompts**: ⭐⭐⭐⭐⭐ **9.2/10 - EXCELENTE**  
Ver reporte completo: `AUDITORIA-ARQUITECTURA-PROMPTS.md`

---

## 📖 ¿Qué es el Método CEIBA?

El Método CEIBA es un **framework sistemático y profesional** para el análisis, diseño y documentación de arquitecturas de software mediante el uso de prompts especializados y agentes de IA.

**Casos de uso:**
- ✅ Análisis de obsolescencia tecnológica en proyectos existentes
- ✅ Diseño de arquitectura para proyectos nuevos
- ✅ Evaluación de deuda técnica
- ✅ Selección de stack tecnológico
- ✅ Estimación de costos y esfuerzos
- ✅ Documentación arquitectónica completa

---

## 🎯 Filosofía del Método

### Principios Fundamentales:

1. **🔄 Sistematización:** Proceso repetible y auditable
2. **📊 Basado en Datos:** Decisiones justificadas con métricas
3. **🤖 IA-Assisted:** Aprovecha capacidades de LLMs (Claude, GPT-4)
4. **📝 Documentación Exhaustiva:** Todo queda registrado
5. **🎨 Modular:** Componentes reutilizables
6. **⚡ Pragmático:** Balance entre teoría y ejecución

---

## 📁 Estructura del Proyecto

```
03.prompts/
│
├── 📂 00-raw-inputs/              # FASE 1: Recepción
│   ├── pdfs/                      # Documentos PDF del cliente
│   ├── excel/                     # Hojas de cálculo
│   ├── powerpoint/                # Presentaciones
│   ├── word/                      # Documentos Word
│   ├── imagenes/                  # Mockups, diagramas, wireframes
│   ├── otros/                     # Otros formatos
│   └── code/                      # Código fuente (modernización/migración)
│       ├── frontend/              # Código web (React, Angular, Vue, etc.)
│       ├── backend/               # Código APIs (Node, Java, Python, .NET, etc.)
│       └── mobile/                # Apps móviles (iOS, Android, React Native, Flutter)
│
├── 📂 01-context-consolidado/     # FASE 2: Consolidación
│   ├── 01-contexto-negocio.md         # Objetivos, stakeholders, alcance
│   ├── 02-requisitos-funcionales.md   # Módulos, funcionalidades, user stories
│   └── 03-requisitos-no-funcionales.md # Performance, seguridad, SLAs
│
├── 📂 02-agents/                 # FASE 3: Procesamiento
│   ├── 0.consolidation_context/
│   │   └── prompt-maestro-consolidacion.md    # Agente 0: Consolidación docs
│   ├── 1.obsolescence_analysis/
│   │   └── prompt-analisis-obsolescencia.md   # Agente 1: Evaluación técnica
│   ├── 2.definition_of_architecture/
│   │   ├── prompt-arquitectura-soluciones.md  # Agente 2: Diseño arquitectónico
│   │   ├── prompt-modelado-datos.md           # Sub-tarea: Modelado de datos
│   │   ├── README.md                          # Guía de uso
│   │   ├── plantilla-modulo-servicio.md       # Template módulos
│   │   ├── plantilla-api-endpoint.md          # Template APIs
│   │   ├── plantilla-adr.md                   # Template ADRs
│   │   ├── politica-diagramacion.md           # Política PlantUML + C4
│   │   └── checklist-seguridad.md             # Checklist seguridad
│   ├── 3.exporting_documents/
│   │   └── prompt-exportacion-word.md         # Agente 3: Exportación Word
│   └── 4.validation_quality/              # 🆕 NUEVO EN v1.2
│       ├── prompt-validar-outputs.md          # Agente 4: Validación calidad
│       ├── checklist-completitud.md           # Checklist artefactos
│       ├── checklist-validacion-consistencia.md # Checklist consistencia
│       └── README.md                          # Guía de validación
│
├── 📂 03-analysis/                # FASE 4A: Resultados Análisis
│   └── (Reportes de obsolescencia generados)
│
├── 📂 04-architecture/            # FASE 4B: Resultados Arquitectura
│   ├── adrs/                      # Architecture Decision Records
│   ├── diagrams/                  # C4, ERD, secuencia, deployment
│   ├── model-data/                # Modelo de datos detallado
│   ├── specs/                     # Specs detalladas de módulos/APIs
│   ├── scripts/                   # Scripts SQL, migrations
│   └── validation/                # 🆕 Reportes de validación (Agente 4)
│
├── 📂 05-deliverables/            # FASE 5: Output Final
│   └── (Documentos finales para cliente)
│
├── 📂 06-scripts/                 # Scripts de automatización
│   ├── extract_pdfs.py            # Extracción de texto de PDFs
│   └── export_to_word.py          # Exportación a Word
│
└── 📂 07-tools/                   # Herramientas y recursos
    └── ejemplos/                  # 🆕 NUEVO EN v1.2
        └── shopfast-ecommerce-mvp/    # Caso de estudio completo
            ├── README.md              # Descripción del caso
            ├── 00-inputs/             # Documentos simulados cliente
            ├── 01-fase0-consolidacion/ # Ejecución paso a paso Fase 0
            ├── 02-fase2-arquitectura/ # Ejecución paso a paso Fase 2
            └── 03-fase2.1-modelado-datos/ # Ejecución Fase 2.1
```

---

## 🚀 Paso a Paso - Ejecución Completa

### **FASE 1: Preparación del Proyecto** ⏱️ 15-30 min

#### Paso 1.1: Crear Proyecto Nuevo

```bash
# Navegar al workspace
cd d:\Documents\1.ceiba_workspace\03.prompts

# Copiar toda la estructura para nuevo proyecto (opcional)
# O trabajar directamente aquí
```

#### Paso 1.2: Recopilar Documentación del Cliente

**Checklist de documentos a solicitar:**

📋 **Documentos de Negocio:**
- [ ] RFP (Request for Proposal) o términos de referencia
- [ ] Descripción del negocio y problemática
- [ ] Objetivos y KPIs esperados
- [ ] Presupuesto aprobado y timeline

📋 **Documentos Técnicos:**
- [ ] Arquitectura propuesta/deseada (diagramas, documentación)
- [ ] Requisitos funcionales y no funcionales
- [ ] Casos de uso y user stories
- [ ] Mockups, wireframes, prototipos
- [ ] APIs documentadas o especificaciones
- [ ] Stack tecnológico preferido (ver: `00-raw-inputs/checklist-stack-tecnologico-cliente.md`)

📋 **Para Proyectos de Modernización/Migración (adicional):**
- [ ] Código fuente del sistema existente (acceso a repositorio)
- [ ] Arquitectura actual documentada
- [ ] Stack tecnológico actual con versiones
- [ ] Base de datos actual (ERD, esquemas, scripts)
- [ ] Documentación técnica legacy
- [ ] Historial de incidentes y problemas conocidos

📋 **Documentos de Restricciones:**
- [ ] Tecnologías mandatorias/prohibidas
- [ ] Compliance requerido (GDPR, PCI-DSS, HIPAA)
- [ ] SLAs esperados
- [ ] Volumen de usuarios/transacciones

**Acción:** 
1. Copiar documentos a `00-raw-inputs/` según su tipo (pdfs, excel, word, etc.)
2. **Si es modernización/migración:** Clonar código fuente a `00-raw-inputs/code/`
   - Frontend → `00-raw-inputs/code/frontend/`
   - Backend → `00-raw-inputs/code/backend/`
   - Mobile → `00-raw-inputs/code/mobile/`

---

### **FASE 2: Consolidación de Contexto** ⏱️ 1-3 horas

#### Paso 2.1: Ejecutar Agente de Consolidación

**🤖 AGENTE:** Consolidación de Contexto  
**📄 PROMPT:** `./02-agentes/0.consolidacion_contexto/prompt-maestro-consolidacion.md`  
**⏱️ TIEMPO:** 1-3 horas (según volumen de documentos)

**Comando para ejecutar:**

```
Hola Claude/GPT-4,

Necesito que asumas el rol de Analista de Negocios Senior y Arquitecto de Soluciones.

OBJETIVO: Consolidar toda la documentación del cliente ubicada en ./00-raw-inputs/ 
y generar contexto estructurado en ./01-context-consolidado/

PROCESO:
1. Lee y analiza TODOS los archivos en:
   - ./00-raw-inputs/pdfs/
   - ./00-raw-inputs/excel/
   - ./00-raw-inputs/powerpoint/
   - ./00-raw-inputs/word/
   - ./00-raw-inputs/imagenes/
   - ./00-raw-inputs/otros/

2. Extrae información relevante de cada documento siguiendo las categorías:
   - Contexto de negocio
   - Requisitos funcionales
   - Requisitos no funcionales
   - Restricciones y limitaciones

3. Consolida la información en estos 3 archivos:
   - ./01-context-consolidado/01-contexto-negocio.md
   - ./01-context-consolidado/02-requisitos-funcionales.md
   - ./01-context-consolidado/03-requisitos-no-funcionales.md

4. Si encuentras información contradictoria, prioriza:
   1º Contratos/RFPs oficiales
   2º Documentos de requisitos formales
   3º Presentaciones/mockups

5. Si falta información crítica:
   - Marca con ⚠️ PENDIENTE
   - Documenta supuesto razonable
   - Justifica el supuesto
   - Crea ./01-context-consolidado/00-supuestos-y-pendientes.md

6. Mantén trazabilidad: Indica la fuente de cada información (documento, página)

INSTRUCCIONES DETALLADAS:
Sigue paso a paso el prompt maestro ubicado en:
./02-agentes/0.consolidacion_contexto/prompt-maestro-consolidacion.md

Al finalizar, avísame si:
- ✅ Consolidación completa
- ⚠️ Hay gaps críticos que requieren información del cliente
- 🔴 Faltan documentos esenciales

¡Comencemos!
```

#### Paso 2.2: Validar Completitud del Contexto

**Checklist de validación:**

✅ **Contexto de Negocio:**
- [ ] Descripción clara del proyecto
- [ ] Objetivos de negocio cuantificados
- [ ] Stakeholders identificados
- [ ] Usuarios objetivo y volumetría

✅ **Requisitos Funcionales:**
- [ ] Módulos principales listados
- [ ] Funcionalidades priorizadas (Must/Should/Nice to Have)
- [ ] Integraciones requeridas
- [ ] Reglas de negocio críticas

✅ **Requisitos No Funcionales:**
- [ ] Performance targets (tiempo respuesta, RPS)
- [ ] Escalabilidad (usuarios concurrentes, crecimiento)
- [ ] Disponibilidad (SLA, RPO, RTO)
- [ ] Seguridad (compliance, encriptación)
- [ ] Presupuesto de infraestructura

**Si falta información:** Documentar supuestos y confirmar con cliente.

---

### **FASE 3: Ejecución de Agentes** ⏱️ 2-8 horas

Elige el agente según el tipo de proyecto:

---

#### 🔧 **OPCIÓN A: Análisis de Obsolescencia** (Proyectos Existentes)

**¿Cuándo usar?**
- Tienes código fuente de un proyecto existente
- Necesitas evaluar deuda técnica
- Requieres plan de modernización

**Paso 3.A.1: Preparar Acceso al Código**

```bash
# Opción 1: Clonar a carpeta code (recomendado)
cd ./00-raw-inputs/code
git clone <repo-url-frontend> ./frontend
git clone <repo-url-backend> ./backend
git clone <repo-url-mobile> ./mobile

# Opción 2: Si ya está clonado en otra ubicación
# Solo proporcionar la ruta al agente
```

**Paso 3.A.2: Ejecutar Agente de Obsolescencia**

**🤖 AGENTE:** Análisis de Obsolescencia  
**📄 PROMPT:** `./02-agentes/1.analisis_obsolescencia/prompt-analisis-obsolescencia.md`  
**⏱️ TIEMPO:** 4-8 horas (según tamaño del proyecto)

**Comando para ejecutar:**

```
Claude, vamos a realizar un análisis de obsolescencia completo.

CONTEXTO:
- Lee el contexto consolidado en ./01-context-consolidado/
- Código fuente ubicado en:
  * Frontend: ./00-raw-inputs/code/frontend
  * Backend: ./00-raw-inputs/code/backend
  * Mobile: ./00-raw-inputs/code/mobile

INSTRUCCIONES:
Asume el rol de Technical Debt Analyst Senior y Platform Architect.

Ejecuta el prompt completo que está en:
./02-agentes/1.analisis_obsolescencia/prompt-analisis-obsolescencia.md

Este prompt tiene las siguientes secciones:
0. Inventario del Stack Tecnológico Completo
1. Análisis de Arquitectura Actual
2. Análisis de Dependencias y Librerías
3. Evaluación de Versiones y Ciclo de Vida
4. Análisis de Vulnerabilidades (CVEs)
5. Evaluación de Prácticas de Desarrollo
6. Análisis de Infraestructura y DevOps
7. Reporte de Obsolescencia Consolidado
8. Plan de Acción y Roadmap de Modernización

Genera un reporte completo en:
./03-analisis/reporte-obsolescencia-[nombre-proyecto]-[fecha].md
```

**Tiempo estimado:** 4-8 horas (dependiendo del tamaño del proyecto)

**Entregables:**
- ✅ Inventario completo del stack tecnológico
- ✅ Matriz de obsolescencia por componente
- ✅ Listado de CVEs críticos
- ✅ Roadmap de modernización priorizado
- ✅ Estimación de esfuerzo y costos

---

#### 🏗️ **OPCIÓN B: Diseño de Arquitectura** (Proyectos Nuevos)

**¿Cuándo usar?**
- Proyecto greenfield (desde cero)
- Necesitas propuesta de arquitectura
- Requieres selección de stack tecnológico

**Paso 3.B.1: Ejecutar Agente de Arquitectura**

**🤖 AGENTE:** Diseño de Arquitectura y Soluciones  
**📄 PROMPT:** `./02-agentes/2.definicion_arquitectura/prompt-arquitectura-soluciones.md`  
**⏱️ TIEMPO:** 3-6 horas

**Comando para ejecutar:**

```
Claude, vamos a diseñar la arquitectura completa para este proyecto.

CONTEXTO:
- Lee el contexto consolidado en ./01-context-consolidado/

INSTRUCCIONES:
Asume el rol de Arquitecto de Software Senior, Ingeniero DevOps y Tech Lead.

Ejecuta el prompt completo que está en:
./02-agentes/2.definicion_arquitectura/prompt-arquitectura-soluciones.md

Este prompt tiene 9 fases:
1. Análisis de Requisitos
2. Diseño de Alto Nivel (Patrón Arquitectónico)
3. Diseño Detallado (Módulos, APIs, Datos)
4. Stack Tecnológico Recomendado
5. Infraestructura y Deployment
6. Seguridad y Compliance
7. Monitoreo y Observabilidad
8. Estimación de Costos
9. Plan de Implementación

Genera la documentación arquitectónica completa en:
./03-arquitectura/
```

**Paso 3.B.2: Documentar Decisiones Arquitectónicas**

**🤖 SUB-TAREA:** Generación de ADRs  
**📄 PLANTILLA:** `./02-agentes/2.definicion_arquitectura/plantilla-adr.md`  
**⏱️ TIEMPO:** 30 min por ADR

**Comando para ejecutar:**

```
Claude, documenta las decisiones arquitectónicas clave usando la plantilla:
./02-agentes/2.definicion_arquitectura/plantilla-adr.md

INSTRUCCIONES:
Crea un ADR (Architecture Decision Record) para cada una de estas decisiones:
1. Patrón arquitectónico (Monolito vs Microservicios)
2. Base de datos principal (SQL vs NoSQL, motor específico)
3. Autenticación y autorización (JWT, OAuth, SAML)
4. Cloud provider (AWS, Azure, GCP)
5. Estrategia de deployment (Blue-Green, Canary)

Para cada ADR incluye:
- Contexto y problemática
- Opciones consideradas (mínimo 3)
- Matriz de decisión con scoring
- Decisión seleccionada con justificación
- Consecuencias (positivas y negativas)
- Plan de implementación

Guarda los ADRs en: ./03-arquitectura/adrs/ADR-XXX-[titulo].md
```

---

**Paso 3.B.3: Especificar Módulos y APIs**

**🤖 SUB-TAREA:** Especificación Detallada  
**📄 PLANTILLAS:** `plantilla-modulo-servicio.md`, `plantilla-api-endpoint.md`  
**⏱️ TIEMPO:** 20 min por módulo, 15 min por endpoint

**Comando para ejecutar:**

```
Claude, usando las plantillas:
- ./02-agentes/2.definicion_arquitectura/plantilla-modulo-servicio.md
- ./02-agentes/2.definicion_arquitectura/plantilla-api-endpoint.md

INSTRUCCIONES:
Crea documentación detallada para:
1. Cada módulo/servicio principal del sistema
2. Los endpoints de API más críticos (top 10-20)

Para cada módulo incluye:
- Responsabilidad única
- API/Interfaz pública
- Modelo de datos
- Dependencias
- Consideraciones de performance y seguridad

Para cada endpoint incluye:
- Método HTTP y URL
- Autenticación/autorización
- Request/Response schemas
- Códigos de error
- Ejemplos de uso

Guarda las especificaciones en: 
- ./03-arquitectura/especificaciones/modulos/
- ./03-arquitectura/especificaciones/apis/
```

---

**Paso 3.B.4: Generar Diagramas**

**🤖 SUB-TAREA:** Generación de Diagramas  
**📄 FORMATO:** PlantUML + C4 Model (.puml) → Export a SVG/Draw.io  
**⏱️ TIEMPO:** 20-40 min por diagrama

**🎯 POLÍTICA DE DIAGRAMACIÓN:**
```
ESTÁNDAR PRINCIPAL: PlantUML + C4 Model (OBLIGATORIO)
✅ Architecture: C4 L1/L2/L3 (Context, Container, Component)
✅ Data: ERD con notación Crow's Foot
✅ Sequence: Flujos críticos con autonumber
✅ Deployment: Infraestructura cloud (AWS/Azure/GCP icons)

VENTAJAS:
✅ Versionable en Git (archivos .puml legibles)
✅ Exportable a SVG → Draw.io para refinamiento visual
✅ Profesional (iconos oficiales cloud providers)
✅ Automatizable en CI/CD pipelines

ESTÁNDAR SECUNDARIO: Mermaid (Uso Limitado)
⚠️ Solo para: Flowcharts simples embebidos en documentación
⚠️ NO usar para: Arquitectura enterprise, presentaciones cliente
```

**Comando para ejecutar:**

```
Claude, genera diagramas arquitectónicos profesionales usando PlantUML + C4 Model.

HERRAMIENTAS:
- PlantUML con biblioteca C4 Model oficial
- Export a SVG para importar a Draw.io
- Archivos .puml versionables en Git

INSTRUCCIONES:
Crea los siguientes diagramas en formato PlantUML (.puml):

1. **C4 Level 1: Diagrama de Contexto del Sistema**
   - Usuarios/actores principales
   - Tu sistema (boundaries)
   - Sistemas externos (APIs, servicios third-party)
   - Interacciones de alto nivel con protocolos
   
   Incluir: !include C4_Context.puml
   Usar: Person(), System(), System_Ext(), Rel()

2. **C4 Level 2: Diagrama de Contenedores**
   - Frontend apps (web, mobile, admin panel)
   - Backend services/APIs
   - Bases de datos (PostgreSQL, MongoDB, Redis)
   - Message queues (RabbitMQ, Kafka, SQS)
   - Storage (S3, Azure Blob)
   - Relaciones con tecnologías específicas
   
   Incluir: !include C4_Container.puml
   Usar: Container(), ContainerDb(), System_Boundary()

3. **C4 Level 3: Diagrama de Componentes** (para servicios principales)
   - Componentes internos de cada servicio crítico
   - Capas: Controllers → Services → Repositories
   - Dependencias entre componentes
   - Librerías y frameworks
   
   Incluir: !include C4_Component.puml
   Usar: Component(), Container_Boundary()

4. **Diagrama Entidad-Relación (ERD)**
   - Entidades principales con atributos y tipos
   - Relaciones con cardinalidad (1:1, 1:N, N:M)
   - Primary keys, foreign keys, índices
   - Notas con volumen estimado y estrategia de particionamiento
   
   Usar: entity, ||--o{, ||--||, }o--o{

5. **Diagramas de Secuencia** (top 3-5 flujos críticos)
   - Flujo de autenticación completo
   - Flujo de transacción principal del negocio
   - Flujo de integración con servicios externos
   - Manejo de errores y compensaciones
   
   Usar: autonumber, participant, ->, ->>, activate/deactivate

6. **Diagrama de Deployment Cloud**
   - Infraestructura AWS/Azure/GCP con iconos oficiales
   - VPCs, subnets (public/private), availability zones
   - Compute (EC2, ECS, AKS, App Service)
   - Networking (load balancers, CDN, DNS)
   - Storage y databases
   - Security groups, firewalls
   
   Incluir: !include AWSPuml/... (para AWS)
   Usar iconos oficiales del cloud provider

FORMATO:
Guarda los diagramas en: ./03-arquitectura/diagramas/

Naming convention:
- c4-l1-context-[sistema].puml
- c4-l2-containers-[sistema].puml
- c4-l3-components-[servicio].puml
- erd-database-[nombre].puml
- sequence-[flujo].puml
- deployment-[cloud]-[ambiente].puml

GUÍA DETALLADA:
Lee la sección completa "Guía de Generación de Diagramas con PlantUML + C4" en:
./02-agentes/2.definicion_arquitectura/prompt-arquitectura-soluciones.md

Incluye:
- Plantillas completas de cada tipo de diagrama
- Sintaxis específica de PlantUML + C4
- Iconos de cloud providers
- Convenciones de naming y estilo
- Workflow de exportación a Draw.io

WORKFLOW DE EXPORTACIÓN:
1. Generar .puml (código versionado)
2. Renderizar: plantuml -tsvg archivo.puml
3. Importar SVG a Draw.io para ajustes visuales
4. Exportar Draw.io: XML + PNG final
5. Versionar: .puml + .drawio.xml + .png

¡Comienza con los diagramas!
```

**Tiempo estimado total Fase 3B:** 3-6 horas

**Entregables:**
- ✅ Documento de arquitectura completo
- ✅ ADRs de decisiones clave (5-10 documentos)
- ✅ Especificaciones de módulos (5-10 documentos)
- ✅ Especificaciones de APIs (10-20 endpoints)
- ✅ Diagramas arquitectónicos (C4, ERD, deployment)
- ✅ Stack tecnológico justificado
- ✅ Estimación de costos cloud
- ✅ Plan de implementación por fases

---

### **FASE 4: Validación de Calidad (NUEVO v1.2)** ⏱️ 30-60 min

#### Paso 4.1: Ejecutar Agente de Validación

**🤖 AGENTE:** Validación de Calidad (Agente 4)  
**📄 PROMPT:** `./02-agents/4.validation_quality/prompt-validar-outputs.md`  
**⏱️ TIEMPO:** 30-60 minutos

**¿Cuándo ejecutar?**
- ✅ Después de completar Fase 3 (Análisis de Obsolescencia o Definición de Arquitectura)
- ✅ Antes de entregar documentación al cliente
- ✅ Como gate de calidad en revisiones por pares

**Comando para ejecutar:**

```
Claude, asume el rol de Auditor de Calidad y ejecuta el agente de validación:

PROMPT: ./02-agents/4.validation_quality/prompt-validar-outputs.md

INPUTS A VALIDAR:
- Contexto consolidado: ./01-context-consolidated/
- Análisis/Arquitectura: ./03-analysis/ o ./04-architecture/

CHECKLISTS A UTILIZAR:
- Completitud: ./02-agents/4.validation_quality/checklist-completitud.md
- Consistencia: ./02-agents/4.validation_quality/checklist-validacion-consistencia.md

SALIDA ESPERADA:
Genera reporte de validación en:
./04-architecture/validation/validation-report-[fecha].md

El reporte debe incluir:
1. Score global (0-100) con breakdown por dimensión
2. Issues encontrados organizados por severidad (🔴🟡🟠🟢)
3. Recomendaciones específicas con archivos y líneas
4. Checklist de remediación prioritaria

Al finalizar, indícame:
- ✅ Score obtenido y nivel de calidad
- ⚠️ Issues críticos (🔴) que bloquean entrega
- 🔧 Issues altos (🟡) recomendados para fix
```

#### Paso 4.2: Remediar Issues Críticos y Altos

**Si el score < 75 (calidad insuficiente):**

```
Claude, revisa el reporte de validación y:

1. PRIORIDAD CRÍTICA (🔴):
   - Fix inmediato, bloquean entrega
   - Re-ejecutar validación después de cada fix

2. PRIORIDAD ALTA (🟡):
   - Fix recomendado antes de entrega
   - Pueden aplazarse con justificación documentada

3. PRIORIDAD MEDIA/BAJA (🟠🟢):
   - Backlog para iteración futura
   - No bloquean entrega

Para cada issue crítico/alto:
- Identifica el archivo y sección afectada
- Aplica la corrección
- Documenta el cambio en changelog
- Re-valida el archivo específico

Al terminar, re-ejecuta validación completa para verificar score ≥ 75
```

#### Paso 4.3: Validar Completitud con Checklists Manuales

**Para Proyectos Existentes (Obsolescencia):**

```
Claude, revisa el reporte de obsolescencia generado y valida:

✅ COMPLETITUD:
- [ ] Se identificaron TODAS las tecnologías del stack
- [ ] Se verificaron versiones y fechas EOL
- [ ] Se auditaron CVEs críticos
- [ ] El roadmap tiene priorización clara (P0, P1, P2)
- [ ] Las estimaciones de esfuerzo son realistas

✅ CONSISTENCIA:
- [ ] Stack tecnológico consistente con contexto consolidado
- [ ] Prioridades alineadas con requisitos no funcionales
- [ ] Estimaciones coherentes con complejidad identificada
```

**Para Proyectos Nuevos (Arquitectura):**

```
Claude, revisa la arquitectura propuesta usando el checklist:
./02-agents/2.definition_of_architecture/README.md (sección "Checklist Rápido")

Valida:
✅ Requisitos (funcionales, no funcionales, restricciones)
✅ Diseño (patrón, diagramas C4, stack tecnológico, APIs, modelo datos)
✅ Operación (infraestructura, CI/CD, monitoreo, disaster recovery)
✅ Seguridad (checklist: ./02-agents/2.definition_of_architecture/checklist-seguridad.md)
✅ Viabilidad (estimación costos, timeline, equipo)
```

#### Paso 4.4: Revisión por Pares (Opcional)

Si trabajas en equipo:
- Compartir reporte de validación con Tech Lead / Arquitecto Senior
- Recibir feedback en issues de severidad ALTA
- Iterar sobre puntos de mejora
- Re-ejecutar validación después de cambios

---

### **FASE 5: Generación de Entregables** ⏱️ 2-4 horas

#### Paso 5.1: Compilar Documento Ejecutivo

```
Claude, crea un documento ejecutivo para el cliente que resuma:

PARA OBSOLESCENCIA:
1. Executive Summary (1 página)
2. Hallazgos Principales (con severidad)
3. Riesgos Identificados (técnicos, seguridad, negocio)
4. Roadmap de Modernización (fases, timeline, costos)
5. Recomendaciones Prioritarias (quick wins)

PARA ARQUITECTURA:
1. Executive Summary (1 página)
2. Arquitectura Propuesta (diagrama de alto nivel)
3. Stack Tecnológico Recomendado (con justificación)
4. Estimación de Costos (desarrollo + infra mensual)
5. Plan de Implementación (fases, hitos, riesgos)

Formato: Markdown profesional, exportable a PDF
Guarda en: ./04-entregables/propuesta-[proyecto]-[fecha].md
```

#### Paso 5.2: Crear Presentación Ejecutiva

```
Claude, genera una presentación en formato Markdown que pueda
convertirse a PowerPoint, con estas secciones:

Slide 1: Portada
Slide 2-3: Contexto y Problemática
Slide 4-5: Propuesta de Solución (arquitectura/modernización)
Slide 6-7: Stack Tecnológico / Tecnologías a Actualizar
Slide 8-9: Roadmap y Fases
Slide 10: Estimación de Costos y Esfuerzo
Slide 11: Riesgos y Mitigaciones
Slide 12: Próximos Pasos

Guarda en: ./04-entregables/presentacion-[proyecto]-[fecha].md
```

#### Paso 5.3: Exportar a PDF (Opcional)

Usa herramientas como:
- **Markdown to PDF:** Typora, Pandoc, VSCode extensions
- **PlantUML to Image:** PlantUML CLI, VSCode extension (jebbs.plantuml), exportar a SVG/PNG
- **Draw.io to PDF:** Exportación directa desde Draw.io/Diagrams.net
- **Presentación:** Reveal.js, Marp, o exportar a Google Slides/PowerPoint

---

## 🔧 Herramientas Recomendadas

### **Para Ejecución de Prompts:**
- ✅ **Claude Code** (VSCode Extension) - RECOMENDADO
- ✅ **Claude.ai** (Web)
- ✅ **GPT-4** (ChatGPT Plus / API)
- ✅ **Copilot Chat** (GitHub Copilot)

### **Para Diagramación:**

**🎯 POLÍTICA DE DIAGRAMACIÓN - Método CEIBA v1.2:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📐 ESTÁNDAR PRINCIPAL: PlantUML + C4 Model (OBLIGATORIO)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ USAR PARA:
  • Architecture: C4 L1 (Context), L2 (Container), L3 (Component)
  • Data Models: ERD con notación Crow's Foot
  • Sequences: Flujos críticos con autonumber
  • Deployment: Infraestructura cloud (AWS/Azure/GCP)

✅ VENTAJAS:
  • Versionable en Git (archivos .puml legibles, diffeables)
  • Exportable: .puml → SVG → Draw.io → PNG/PDF
  • Profesional: Iconos oficiales de cloud providers
  • Automatizable: Integración CI/CD pipelines

📤 WORKFLOW:
  1. Escribir: codigo-diagrama.puml
  2. Renderizar: plantuml -tsvg codigo-diagrama.puml
  3. Refinar: Importar SVG a Draw.io para ajustes visuales
  4. Exportar: .drawio.xml + PNG para presentaciones
  5. Versionar: .puml + .drawio.xml + .png en Git

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 ESTÁNDAR SECUNDARIO: Mermaid (Solo Uso Limitado)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ USAR SOLO PARA:
  • Flowcharts simples embebidos en documentación
  • Diagramas Gantt para roadmaps rápidos
  • Diagramas de clase/estado muy simples

⚠️ NO USAR PARA:
  • Arquitectura enterprise (limitaciones de layout)
  • Presentaciones a clientes (calidad visual inferior)
  • Diagramas complejos con muchos elementos

⚠️ RAZÓN:
  • Dificultad para exportar/refinar visualmente
  • Layout automático inflexible
  • No hay iconos oficiales de cloud providers
```

**🛠️ Herramientas Recomendadas:**

**PlantUML Ecosystem:**
- ✅ **PlantUML + C4 Model** - Diagramas de arquitectura enterprise (C4 L1/L2/L3)
- ✅ **PlantUML ERD** - Modelos de datos con notación Crow's Foot
- ✅ **PlantUML Sequence** - Diagramas de secuencia detallados
- ✅ **PlantUML Deployment** - Infraestructura cloud (AWS/Azure/GCP icons)
- 📤 **Exportación**: .puml → SVG → Draw.io (.drawio.xml) → PNG/PDF
- 🔄 **Versionable en Git** y compatible con CI/CD

**Mermaid (Uso Limitado):**
- ⚠️ **Mermaid** - Solo para diagramas simples embebidos en docs (flowcharts básicos, Gantt)
- ⚠️ **NO usar para arquitectura enterprise** (limitaciones de exportación y calidad visual)

**🖌️ Refinamiento Visual:**
- ✅ **Draw.io / Diagrams.net** - Ajustes finales de diagramas exportados desde PlantUML
- ✅ **Lucidchart / Figma** - Presentaciones ejecutivas y colaboración visual

### **Para Documentación:**
- ✅ **VSCode** + Markdown Preview Enhanced
- ✅ **Obsidian** (knowledge base)
- ✅ **Notion** (colaborativo)
- ✅ **Confluence** (enterprise)

### **Para Análisis de Código (Obsolescencia):**
- ✅ **Snyk** (CVEs y dependencias)
- ✅ **OWASP Dependency-Check**
- ✅ **GitHub Dependabot**
- ✅ **SonarQube** (code quality)

---

## 📊 Métricas de Éxito

### **KPIs del Proceso:**

| Métrica | Target | ¿Cómo Medir? |
|---------|--------|--------------|
| Tiempo total de análisis | < 8 horas | Desde Fase 1 hasta Fase 4 |
| Completitud de contexto | 100% | Checklist Fase 2 completo |
| Cobertura de decisiones | > 90% | ADRs para decisiones críticas |
| Calidad de entregables | 4.5/5 | Feedback de cliente/equipo |
| Reutilización de templates | > 80% | % de templates usados sin modificar |

### **KPIs de Impacto (Post-Proyecto):**

| Métrica | Target | ¿Cómo Medir? |
|---------|--------|--------------|
| Reducción de deuda técnica | > 60% | CVEs resueltos, versiones actualizadas |
| Adherencia al diseño | > 85% | Implementación vs. arquitectura propuesta |
| Cumplimiento de SLAs | > 99% | Uptime, performance según RNF |
| Satisfacción del cliente | > 4.5/5 | Survey post-entrega |

---

## 🎓 Guías de Referencia Rápida

### **Quick Start para Proyectos Nuevos:**
📖 Leer: `./02-agentes/2.definicion_arquitectura/GUIA-RAPIDA-EJECUCION.md`  
⏱️ Tiempo: 15 minutos para empezar

### **Guía Completa de Ejecución:**
📖 Leer: `./02-agentes/2.definicion_arquitectura/guia-ejecucion-prompts.md`  
⏱️ Tiempo: 1 hora de lectura, referencia continua

### **Checklist de Seguridad:**
📖 Leer: `./02-agentes/2.definicion_arquitectura/checklist-seguridad.md`  
🛡️ Usar en: Fase de diseño y revisión

---

## ❓ FAQ - Preguntas Frecuentes

### **1. ¿Puedo usar el método para proyectos pequeños?**
✅ Sí. Ajusta el nivel de detalle según el tamaño:
- **Proyecto pequeño:** Enfócate en Fases 1-2 y documentación ligera
- **Proyecto mediano:** Proceso completo pero con ADRs simplificados
- **Proyecto enterprise:** Proceso completo con máximo detalle

### **2. ¿Qué hago si el cliente no tiene documentación?**
📝 Realiza sesiones de descubrimiento:
1. Entrevistas con stakeholders (usa templates como guía)
2. Workshops de definición de requisitos
3. Documenta todo en `01-context-consolidado/` desde cero

### **3. ¿Puedo usar ambos agentes en el mismo proyecto?**
✅ Sí. Caso típico: **Análisis de Obsolescencia → Diseño de Nueva Arquitectura**
1. Primero: Evalúa el sistema actual (Agente 1)
2. Segundo: Diseña la arquitectura objetivo (Agente 2)
3. Resultado: Roadmap de migración completo

### **4. ¿Funciona con Claude / GPT-4 / otros LLMs?**
✅ Sí. Los prompts están diseñados para ser agnósticos de LLM.
- **Recomendado:** Claude 3.5 Sonnet o GPT-4 Turbo
- **Mínimo:** Claude 3 Haiku o GPT-3.5 (puede requerir más iteraciones)

### **5. ¿Cómo adapto el método a mi organización?**
🔧 El método es modular. Puedes:
- Agregar/quitar secciones de los prompts
- Customizar templates según estándares internos
- Integrar con herramientas corporativas (Jira, Confluence)
- Ajustar fases según tu SDLC

### **6. ¿Qué hago con datos sensibles del cliente?**
🔒 Seguridad y privacidad:
- Agrega `00-raw-inputs/` a `.gitignore` (NO versionar datos de cliente)
- Usa variables/placeholders en contexto consolidado
- Considera LLMs on-premise para datos ultra-sensibles
- Firma NDAs apropiados antes de procesar

---

## 🔄 Versionamiento del Método

### **Versión 1.2** (7 de noviembre de 2025)
**✨ NOVEDADES PRINCIPALES:**
- 🆕 **Versionamiento de prompts**: Todos los prompts ahora incluyen `prompt_version`, `last_updated` y `changelog` en YAML frontmatter
- 🆕 **Agente 4 - Validación de Calidad**: Framework completo de QA con scoring 0-100, 5 dimensiones (Completitud, Consistencia, Corrección, Claridad, Compliance), y 4 niveles de severidad
- 🆕 **Caso de estudio completo**: ShopFast E-commerce MVP con inputs reales, ejecución paso a paso, y outputs documentados (`./07-tools/ejemplos/shopfast-ecommerce-mvp/`)
- 🆕 **Checklists de validación**: Completitud exhaustiva por fase + Consistencia con scripts automatizados

**AGENTES Y SUB-TAREAS:**
- ✅ Agente 0: Consolidación de Contexto (Business Analyst Senior) - v1.0.1
- ✅ Agente 1: Análisis de Obsolescencia (Technical Debt Analyst) - v1.0.1
- ✅ Agente 2: Definición de Arquitectura (Solutions Architect) - v1.0.2
- ✅ Agente 4: Validación de Calidad (QA Architect Senior) - v1.0.0 🆕
- ✅ Sub-tarea 2.1: Modelado de Datos (Data Architect Senior) - v1.0.1
- ✅ Sub-tarea 3: Exportación a Word (Technical Writer Senior) - v1.0.1

**CARACTERÍSTICAS EXISTENTES:**
- ✅ Roles especializados senior (7 roles definidos)
- ✅ **PlantUML + C4 Model como estándar obligatorio** (política de diagramación)
- ✅ Soporte para modernización/migración (directorio code/)
- ✅ Tech stack checklist completo
- ✅ Plantillas: ADR, API, Módulo, Seguridad
- ✅ Guías: Rápida (15 min) y Completa (con ejemplos reales)

### **Roadmap Futuro:**
- 🔜 v1.3: Templates faltantes (matriz-tecnologias, estimacion-costos, ejemplos-arquitecturas)
- 🔜 v1.4: Agente de Code Review (análisis de calidad automatizado)
- 🔜 v1.5: Scripts de automatización (extracción PDFs/Excel, diagramas en CI/CD)
- 🔜 v2.0: Integración con herramientas (Jira, GitHub, Figma)

---

## 👥 Roles Especializados por Fase

El Método CEIBA utiliza **roles especializados senior** para cada agente y sub-tarea, asegurando expertise específica en cada área:

### **Agente 0: Consolidación**
**🎭 Rol:** Business Analyst Senior & Requirements Engineer  
**Expertise:** Ingeniería de requisitos (IEEE 830/ISO 29148), extracción de información, modelado de procesos de negocio, validación SMART de requisitos.

### **Agente 1: Obsolescencia**
**🎭 Rol:** Technical Debt Analyst Senior & Platform Architect  
**Expertise:** Cuantificación de deuda técnica, auditoría de arquitecturas enterprise, análisis de vulnerabilidades (CVEs/OWASP), modernización de plataformas, DORA metrics.

### **Agente 2: Arquitectura**
**🎭 Rol:** Solutions Architect Senior & Cloud Architect  
**Expertise:** Diseño cloud-native (AWS/Azure/GCP), patrones arquitectónicos enterprise, optimización FinOps, SRE practices, compliance (GDPR/HIPAA/SOC2).

### **Agente 4: Validación (NUEVO v1.2)**
**🎭 Rol:** QA Architect Senior & Documentation Auditor  
**Expertise:** Auditoría de calidad de documentación técnica, validación de completitud y consistencia, scoring multidimensional, gestión de issues por severidad, definición de gates de calidad.

### **Sub-Tarea: Requisitos Funcionales**
**🎭 Rol:** Product Owner Senior & Domain Expert  
**Expertise:** Value streams, priorización por valor de negocio, modelado de dominio, viabilidad técnica.

### **Sub-Tarea: Requisitos No Funcionales**
**🎭 Rol:** Site Reliability Engineer (SRE) Senior & Performance Architect  
**Expertise:** SLIs/SLOs/SLAs, capacity planning, fault tolerance, observability, optimización de performance end-to-end.

### **Sub-Tarea: Modelado de Datos**
**🎭 Rol:** Data Architect Senior & Database Engineer  
**Expertise:** Diseño de modelos relacionales y NoSQL, Database per Service pattern, estrategias de particionamiento/sharding, Polyglot Persistence, migrations, performance tuning, data governance.

> **💡 Nota:** Al ejecutar prompts, siempre especifica el rol al inicio para que el LLM (Claude/GPT-4) adopte la perspectiva y expertise adecuada.

---

## �📋 Referencia Rápida de Comandos

Esta sección consolida todos los comandos de ejecución de prompts para acceso rápido.

---

### **🤖 Agente 0: Consolidación de Contexto**

**📌 Rol Especializado:** Business Analyst Senior & Requirements Engineer  
**Archivo:** `./02-agentes/0.consolidacion_contexto/prompt-maestro-consolidacion.md`  
**Entrada:** Documentos en `./00-raw-inputs/`  
**Salida:** Contexto consolidado en `./01-context-consolidado/`  
**Tiempo:** 1-3 horas

```bash
# COMANDO PARA COPIAR Y PEGAR EN CLAUDE/GPT-4:

Hola Claude/GPT-4,

Asume el rol de Business Analyst Senior y Requirements Engineer especializado en ingeniería de requisitos y consolidación de contexto empresarial.

OBJETIVO: Consolidar documentación de ./00-raw-inputs/ en ./01-context-consolidado/

PROCESO:
1. Analiza TODOS los archivos en ./00-raw-inputs/ (pdfs, excel, ppt, word, imágenes)
2. Extrae: contexto negocio, requisitos funcionales/no funcionales, restricciones
3. Consolida en:
   - ./01-context-consolidado/01-contexto-negocio.md
   - ./01-context-consolidado/02-requisitos-funcionales.md
   - ./01-context-consolidado/03-requisitos-no-funcionales.md
4. Prioriza: 1º Contratos/RFPs, 2º Requisitos formales, 3º Presentaciones
5. Para información faltante: marca ⚠️, documenta supuesto, crea 00-supuestos-y-pendientes.md
6. Mantén trazabilidad (documento fuente, página)

INSTRUCCIONES DETALLADAS:
./02-agentes/0.consolidacion_contexto/prompt-maestro-consolidacion.md

¡Comencemos!
```

---

### **🤖 Agente 1: Análisis de Obsolescencia**

**📌 Rol Especializado:** Technical Debt Analyst Senior & Platform Architect  
**Archivo:** `./02-agentes/1.analisis_obsolescencia/prompt-analisis-obsolescencia.md`  
**Entrada:** Contexto consolidado + Código fuente  
**Salida:** Reporte de obsolescencia en `./03-analisis/`  
**Tiempo:** 4-8 horas

```bash
# COMANDO PARA COPIAR Y PEGAR EN CLAUDE/GPT-4:

Hola Claude/GPT-4,

Asume el rol de Technical Debt Analyst Senior y Platform Architect especializado en evaluación de deuda técnica y modernización de plataformas.

OBJETIVO: Análisis exhaustivo de obsolescencia del proyecto.

CONTEXTO:
- Lee contexto consolidado en ./01-context-consolidado/
- Código fuente ubicado en:
  * Frontend: ./00-raw-inputs/code/frontend
  * Backend: ./00-raw-inputs/code/backend
  * Mobile: ./00-raw-inputs/code/mobile
  (O especifica rutas alternativas si el código está en otra ubicación)

INSTRUCCIONES:
Ejecuta el prompt: ./02-agentes/1.analisis_obsolescencia/prompt-analisis-obsolescencia.md

Secciones a completar:
0. Inventario Stack Tecnológico Completo (Frontend/Backend/DB/DevOps)
1. Análisis de Arquitectura Actual (patrones, componentes, flujos)
2. Análisis de Dependencias y Librerías (versiones, actualizaciones)
3. Evaluación de Versiones y Ciclo de Vida (EOL, LTS)
4. Análisis de Vulnerabilidades (CVEs críticos)
5. Evaluación de Prácticas de Desarrollo (code quality, testing)
6. Análisis de Infraestructura y DevOps (cloud, CI/CD)
7. Reporte de Obsolescencia Consolidado (priorizado)
8. Plan de Acción y Roadmap de Modernización (fases, costos)

SALIDA:
./03-analisis/reporte-obsolescencia-[proyecto]-[fecha].md

¡Comencemos!
```

---

### **🤖 Agente 2: Diseño de Arquitectura**

**📌 Rol Especializado:** Solutions Architect Senior & Cloud Architect  
**Archivo:** `./02-agentes/2.definicion_arquitectura/prompt-arquitectura-soluciones.md`  
**Entrada:** Contexto consolidado  
**Salida:** Arquitectura completa en `./03-arquitectura/`  
**Tiempo:** 3-6 horas

```bash
# COMANDO PARA COPIAR Y PEGAR EN CLAUDE/GPT-4:

Hola Claude/GPT-4,

Asume el rol de Solutions Architect Senior y Cloud Architect especializado en diseño de soluciones cloud-native y arquitecturas escalables.

OBJETIVO: Diseñar arquitectura completa del proyecto.

CONTEXTO:
- Lee contexto consolidado en ./01-context-consolidado/

INSTRUCCIONES:
Ejecuta el prompt: ./02-agentes/2.definicion_arquitectura/prompt-arquitectura-soluciones.md

Fases a completar:
1. Análisis de Requisitos (funcionales/no funcionales/restricciones)
2. Diseño de Alto Nivel (patrón arquitectónico, justificación)
3. Diseño Detallado (módulos, APIs, modelo de datos)
4. Stack Tecnológico Recomendado (con comparativas y justificación)
5. Infraestructura y Deployment (cloud, containers, CI/CD)
6. Seguridad y Compliance (autenticación, encriptación, auditoría)
7. Monitoreo y Observabilidad (logs, métricas, alertas)
8. Estimación de Costos (desarrollo + infraestructura)
9. Plan de Implementación (fases, hitos, riesgos)

SALIDA:
./03-arquitectura/arquitectura-propuesta-[proyecto]-[fecha].md

¡Comencemos!
```

---

### **🤖 Sub-Tarea 2A: Modelado de Datos**

**📌 Rol Especializado:** Data Architect Senior & Database Engineer  
**Plantilla:** `./02-agentes/2.definicion_arquitectura/prompt-modelado-datos.md`  
**Salida:** `./03-arquitectura/modelo-datos/`  
**Tiempo:** 2-4 horas

```bash
# COMANDO PARA COPIAR Y PEGAR EN CLAUDE/GPT-4:

Hola Claude/GPT-4,

Asume el rol de Data Architect Senior y Database Engineer especializado en diseño de modelos de datos para microservicios y sistemas escalables.

OBJETIVO: Diseñar modelo de datos completo para el sistema.

CONTEXTO:
- Lee arquitectura de soluciones ya definida
- Lee contexto consolidado en ./01-context-consolidado/

INSTRUCCIONES:
Ejecuta el prompt: ./02-agentes/2.definicion_arquitectura/prompt-modelado-datos.md

Fases a completar:
1. Modelado Conceptual (ERD, entidades, relaciones, bounded contexts)
2. Estrategia de Persistencia (selección DB por servicio/módulo, Polyglot Persistence)
3. Diseño de Esquemas Detallados (DDL, índices, particionamiento)
4. Patrones de Acceso a Datos (queries, repository pattern, caching)
5. Migración y Versionado (migrations, rollback strategy)
6. Seguridad y Compliance (encriptación, auditoría, GDPR)
7. Performance y Escalabilidad (índices, read replicas, sharding)

SALIDA:
./03-arquitectura/modelo-datos/modelo-datos-[proyecto]-[fecha].md
./03-arquitectura/modelo-datos/database/migrations/
./03-arquitectura/modelo-datos/diagramas/erd-*.puml

¡Comencemos!
```

---

### **🤖 Sub-Tarea 2B: Generación de ADRs**

**Plantilla:** `./02-agentes/2.definicion_arquitectura/plantilla-adr.md`  
**Salida:** `./03-arquitectura/adrs/`  
**Tiempo:** 30 min por ADR

```bash
# COMANDO PARA COPIAR Y PEGAR EN CLAUDE/GPT-4:

Claude, documenta decisiones arquitectónicas usando:
./02-agentes/2.definicion_arquitectura/plantilla-adr.md

DECISIONES A DOCUMENTAR:
1. Patrón arquitectónico (Monolito/Microservicios/Modular Monolith)
2. Base de datos (SQL/NoSQL, motor específico)
3. Autenticación (JWT/OAuth/SAML)
4. Cloud provider (AWS/Azure/GCP)
5. Estrategia deployment (Blue-Green/Canary/Rolling)
6. [Agregar otras decisiones críticas]

Para cada ADR incluye:
- Contexto y problemática
- Opciones consideradas (mínimo 3)
- Matriz de decisión (scoring ponderado)
- Decisión seleccionada + justificación
- Consecuencias (pros/cons)
- Plan de implementación

SALIDA:
./03-arquitectura/adrs/ADR-001-[titulo].md
./03-arquitectura/adrs/ADR-002-[titulo].md
...
```

---

### **🤖 Sub-Tarea 2B: Especificación de Módulos**

**Plantilla:** `./02-agentes/2.definicion_arquitectura/plantilla-modulo-servicio.md`  
**Salida:** `./03-arquitectura/especificaciones/modulos/`  
**Tiempo:** 20 min por módulo

```bash
# COMANDO PARA COPIAR Y PEGAR EN CLAUDE/GPT-4:

Claude, especifica módulos del sistema usando:
./02-agentes/2.definicion_arquitectura/plantilla-modulo-servicio.md

MÓDULOS A DOCUMENTAR:
1. [Módulo 1 - ej: Gestión de Usuarios]
2. [Módulo 2 - ej: Autenticación y Seguridad]
3. [Módulo 3 - ej: Core de Negocio]
4. [Módulo 4 - ej: Integraciones]
5. [Módulo 5 - ej: Reportería y Analytics]
[Listar todos los módulos principales]

Para cada módulo incluye:
- Responsabilidad única (bounded context DDD)
- API/Interfaz pública (endpoints REST, eventos)
- Modelo de datos (entidades, relaciones, volumen)
- Dependencias (otros módulos, servicios externos)
- Stack tecnológico específico
- Consideraciones de performance, seguridad, escalabilidad

SALIDA:
./03-arquitectura/especificaciones/modulos/[nombre-modulo].md
```

---

### **🤖 Sub-Tarea 2C: Especificación de APIs**

**Plantilla:** `./02-agentes/2.definicion_arquitectura/plantilla-api-endpoint.md`  
**Salida:** `./03-arquitectura/especificaciones/apis/`  
**Tiempo:** 15 min por endpoint

```bash
# COMANDO PARA COPIAR Y PEGAR EN CLAUDE/GPT-4:

Claude, especifica endpoints críticos usando:
./02-agentes/2.definicion_arquitectura/plantilla-api-endpoint.md

ENDPOINTS A DOCUMENTAR (Top 10-20):
1. POST /api/v1/auth/login
2. POST /api/v1/auth/register
3. GET /api/v1/users/:id
4. POST /api/v1/[recurso-principal]
5. GET /api/v1/[recurso-principal]
[Listar endpoints críticos del sistema]

Para cada endpoint incluye:
- Método HTTP y URL completa
- Autenticación/autorización requerida
- Headers, path params, query params
- Request body schema (JSON/XML)
- Response schemas (success + errors)
- Códigos de estado HTTP
- Ejemplos de request/response
- Rate limiting
- Validaciones

SALIDA:
./03-arquitectura/especificaciones/apis/[endpoint-name].md
```

---

### **🤖 Sub-Tarea 2D: Generación de Diagramas**

**Formato:** PlantUML + C4 Model (.puml)  
**Salida:** `./03-arquitectura/diagramas/`  
**Tiempo:** 15-30 min por diagrama

**🎯 ESTÁNDAR: PlantUML + C4 Model (OBLIGATORIO para arquitectura)**

```bash
# COMANDO PARA COPIAR Y PEGAR EN CLAUDE/GPT-4:

Claude, genera diagramas arquitectónicos en formato PlantUML + C4 Model.

IMPORTANTE - POLÍTICA DE DIAGRAMACIÓN:
✅ USA: PlantUML + C4 Model para todos los diagramas de arquitectura
✅ EXPORTA: .puml → SVG → Draw.io (.drawio.xml) → PNG/PDF
✅ VERSIONA: Archivos .puml en Git (legibles, diffeables)
⚠️ NO USES: Mermaid para arquitectura enterprise (solo flowcharts simples)

DIAGRAMAS A CREAR:

1. C4 Level 1: Contexto del Sistema
   - Sintaxis: !include C4_Context.puml
   - Elementos: Person(), System(), System_Ext(), Rel()
   - Muestra: Usuarios/actores, sistema principal, sistemas externos

2. C4 Level 2: Contenedores
   - Sintaxis: !include C4_Container.puml
   - Elementos: Container(), ContainerDb(), System_Boundary()
   - Muestra: Frontend apps, backend services, databases, queues

3. C4 Level 3: Componentes (módulos principales)
   - Sintaxis: !include C4_Component.puml
   - Elementos: Component(), ComponentDb(), Rel()
   - Muestra: Componentes internos, capas (controllers, services, repos)

4. Diagrama Entidad-Relación (ERD)
   - Sintaxis: PlantUML con notación Crow's Foot
   - Elementos: entity, ||--||, |o--o{
   - Muestra: Entidades, atributos, relaciones, cardinalidad

5. Diagramas de Secuencia (flujos críticos top 3-5)
   - Sintaxis: PlantUML Sequence
   - Elementos: participant, autonumber, ->, ->>, activate/deactivate
   - Muestra: Flujo auth, transacción principal, integraciones

6. Diagrama de Deployment Cloud
   - Sintaxis: PlantUML con iconos AWS/Azure/GCP oficiales
   - Elementos: !include AWSPuml/..., node, component
   - Muestra: VPCs, subnets, compute, load balancers, databases, networking

NOMENCLATURA DE ARCHIVOS:
- c4-l1-context-[sistema].puml
- c4-l2-containers-[sistema].puml
- c4-l3-components-[servicio].puml
- erd-database-[nombre].puml
- sequence-[flujo].puml
- deployment-[cloud]-[ambiente].puml

WORKFLOW DE EXPORTACIÓN:
1. Generar .puml (código versionado en Git)
2. Renderizar: plantuml -tsvg archivo.puml
3. Importar SVG a Draw.io para ajustes visuales
4. Exportar: .drawio.xml + PNG para presentaciones
5. Versionar: .puml + .drawio.xml + .png

PLANTILLAS COMPLETAS:
Ver guía detallada con sintaxis completa en:
./02-agentes/2.definicion_arquitectura/prompt-arquitectura-soluciones.md
(Sección: "Guía de Generación de Diagramas con PlantUML + C4")

SALIDA: ./03-arquitectura/diagramas/[nombre-archivo].puml
```

**🎨 REFINAMIENTO VISUAL (Opcional):**
```
Herramientas para mejorar presentación:
1. Draw.io: Importar SVG → Ajustar layout → Exportar PNG/PDF
2. Lucidchart/Figma: Recrear con branding corporativo para ejecutivos
```

---

### **🛡️ Checklist de Seguridad**

**Archivo:** `./02-agentes/2.definicion_arquitectura/checklist-seguridad.md`  
**Uso:** Validación durante diseño y revisión

```bash
# COMANDO PARA COPIAR Y PEGAR EN CLAUDE/GPT-4:

Claude, valida la arquitectura propuesta contra el checklist de seguridad:
./02-agentes/2.definicion_arquitectura/checklist-seguridad.md

INSTRUCCIONES:
Revisa cada capa de seguridad (Defense in Depth):

1. Seguridad de Red
   - Firewall, WAF, DDoS protection
   - VPN/VPC, network segmentation
   - Load balancers, DNS security

2. Seguridad de Infraestructura
   - OS hardening, SSH security
   - Container security (Docker)
   - Cloud security (IAM, Security Groups)
   - Kubernetes security (si aplica)

3. Seguridad de Aplicación
   - Autenticación (password policy, MFA)
   - Autorización (RBAC)
   - Encriptación (TLS, AES)
   - Input validation, output encoding
   - OWASP Top 10 coverage

4. Seguridad de Datos
   - Encriptación at rest y in transit
   - Backup y retention policies
   - Data masking/anonymization
   - Compliance (GDPR, PCI-DSS)

5. Seguridad Operacional
   - Logging y auditoría
   - Incident response plan
   - Vulnerability scanning
   - Penetration testing

SALIDA:
Reporte de gaps de seguridad + plan de mitigación
```

---

### **🤖 Agente 4: Validación de Calidad (NUEVO v1.2)**

**📌 Rol Especializado:** QA Architect Senior & Documentation Auditor  
**Archivo:** `./02-agents/4.validation_quality/prompt-validar-outputs.md`  
**Entrada:** Documentación consolidada + análisis/arquitectura  
**Salida:** Reporte de validación en `./04-architecture/validation/`  
**Tiempo:** 30-60 minutos

```bash
# COMANDO PARA COPIAR Y PEGAR EN CLAUDE/GPT-4:

Hola Claude/GPT-4,

Asume el rol de QA Architect Senior y Documentation Auditor especializado en auditoría de calidad de documentación técnica y arquitectónica.

OBJETIVO: Validar calidad de outputs generados por Método CEIBA y generar reporte con score y recomendaciones.

INPUTS A VALIDAR:
- Contexto consolidado: ./01-context-consolidated/
- Análisis de obsolescencia: ./03-analysis/ (si aplica)
- Arquitectura de soluciones: ./04-architecture/ (si aplica)

CHECKLISTS A UTILIZAR:
- Completitud: ./02-agents/4.validation_quality/checklist-completitud.md
- Consistencia: ./02-agents/4.validation_quality/checklist-validacion-consistencia.md

PROCESO:
1. Ejecuta el prompt maestro de validación:
   ./02-agents/4.validation_quality/prompt-validar-outputs.md

2. Evalúa 5 dimensiones de calidad:
   - Completitud (30%): Presencia de todas las secciones requeridas
   - Consistencia (25%): Coherencia entre documentos y trazabilidad
   - Corrección (25%): Precisión técnica y adherencia a estándares
   - Claridad (10%): Legibilidad y comprensión
   - Compliance (10%): Cumplimiento de políticas del método

3. Para cada dimensión:
   - Calcula score (0-100)
   - Identifica issues por severidad (🔴 Crítico, 🟡 Alto, 🟠 Medio, 🟢 Bajo)
   - Documenta ubicación exacta (archivo, línea, sección)
   - Provee recomendación específica de corrección

4. Genera reporte final con:
   - Score global ponderado (0-100)
   - Breakdown de scores por dimensión
   - Resumen ejecutivo de hallazgos
   - Issues organizados por severidad
   - Checklist de remediación priorizada

SALIDA:
./04-architecture/validation/validation-report-[fecha].md

CRITERIOS DE CALIDAD:
- 90-100: Excelente ✅ (Listo para entrega)
- 75-89: Bueno ⚠️ (Mejoras menores recomendadas)
- 60-74: Aceptable 🔶 (Requiere mejoras antes de entrega)
- <60: Insuficiente 🔴 (Bloquea entrega, requiere correcciones)

Al finalizar, indícame:
- ✅ Score global y nivel de calidad alcanzado
- ⚠️ Issues críticos (🔴) que bloquean entrega
- 🔧 Issues altos (🟡) recomendados para corrección
- 📋 Plan de remediación sugerido

¡Comencemos con la auditoría!
```

---

## 💡 Tips para Ejecución Efectiva

### **1. Preparación de Contexto**
```bash
# Antes de ejecutar cualquier agente, verifica:
- ✅ Documentos en ./00-raw-inputs/ están completos
- ✅ Contexto consolidado generado y validado
- ✅ Supuestos documentados si hay gaps
```

### **2. Ejecución Iterativa**
```bash
# No intentes completar todo en una sola sesión con la IA
# Mejor estrategia:
Sesión 1: Ejecutar agente principal (2-4 horas)
Sesión 2: Revisar output + iterar en áreas débiles (1-2 horas)
Sesión 3: Generar sub-tareas (ADRs, specs, diagramas) (2-3 horas)
```

### **3. Validación Continua (NUEVO v1.2)**
```bash
# Después de cada salida del agente:
- ✅ Verificar contra checklists de calidad
- ✅ Validar trazabilidad a requisitos
- ✅ Confirmar viabilidad técnica
- ✅ Revisar estimaciones de costo/tiempo

# NUEVO: Ejecutar Agente 4 de Validación
- ✅ Al completar Fase 3 (Análisis/Arquitectura)
- ✅ Antes de entrega al cliente
- ✅ Como gate de calidad en revisiones por pares
- ✅ Score mínimo requerido: 75/100 (Bueno)
- ✅ Remediar issues críticos (🔴) antes de continuar
```

### **4. Customización de Prompts**
```bash
# Los prompts son templates - ajústalos según:
- Tamaño del proyecto (pequeño/mediano/grande)
- Nivel de detalle requerido
- Estándares corporativos específicos
- Compliance particular de la industria
```

### **5. Manejo de Tokens**
```bash
# Si el LLM alcanza límite de tokens:
# Estrategia 1: Divide en sub-tareas
"Primero completa solo secciones 1-3, luego continuamos con 4-6"

# Estrategia 2: Resume contexto
"Aquí está un resumen del contexto anterior: [resumen]. Ahora continúa con..."

# Estrategia 3: Usa artifacts (Claude)
"Genera cada diagrama en un artifact separado"
```

---

## 🔄 Versionamiento del Método

### **Versión 1.2** (7 de noviembre de 2025)
- ✅ Agente 0: Consolidación de Contexto (Business Analyst Senior)
- ✅ Agente 1: Análisis de Obsolescencia (Technical Debt Analyst)
- ✅ Agente 2: Definición de Arquitectura (Solutions Architect)
- ✅ Sub-tarea: Modelado de Datos (Data Architect Senior)
- ✅ Roles especializados senior (6 roles definidos)
- ✅ **PlantUML + C4 Model como estándar obligatorio** (nueva política)
- ✅ Soporte para modernización/migración (directorio code/)
- ✅ Tech stack checklist completo
- ✅ Plantillas: ADR, API, Módulo, Seguridad
- ✅ Guías: Rápida (15 min) y Completa (con ejemplos reales)

### **Roadmap Futuro:**
- 🔜 v1.3: Templates faltantes (matriz-tecnologias, estimacion-costos, ejemplos-arquitecturas)
- 🔜 v1.4: Agente de Code Review (análisis de calidad automatizado)
- 🔜 v1.5: Scripts de automatización (extracción PDFs/Excel, diagramas en CI/CD)
- 🔜 v2.0: Integración con herramientas (Jira, GitHub, Figma)

---

## 🤝 Contribución y Soporte

### **¿Quieres mejorar el método?**

1. **Reporta issues:** Documenta problemas o áreas de mejora
2. **Propón mejoras:** Sugiere nuevos templates o secciones
3. **Comparte casos de estudio:** Ayuda a otros con tus experiencias
4. **Contribuye código:** Scripts de automatización, integraciones

### **Contacto:**
- 📧 Email: [tu-email]
- 💬 Slack/Teams: [canal]
- 📝 Wiki/Confluence: [enlace]

---

## 📚 Referencias y Recursos

### **Arquitectura de Software:**
- 📖 [C4 Model](https://c4model.com/) - Diagramas arquitectónicos
- 📖 [Architecture Decision Records (ADR)](https://adr.github.io/)
- 📖 [12-Factor App](https://12factor.net/) - Metodología para apps cloud-native
- 📖 [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

### **Seguridad:**
- 🛡️ [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- 🛡️ [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/)
- 🛡️ [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

### **DevOps y Cloud:**
- ☁️ [Azure Architecture Center](https://docs.microsoft.com/en-us/azure/architecture/)
- ☁️ [GCP Architecture Framework](https://cloud.google.com/architecture/framework)
- 🔧 [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/)

---

## 🎉 ¡Estás Listo!

Has completado la lectura de la guía completa del Método CEIBA.

**Próximos pasos:**

1. ✅ **Si es tu primer proyecto:** Lee la guía rápida en `./02-agentes/2.definicion_arquitectura/GUIA-RAPIDA-EJECUCION.md`

2. ✅ **Empieza con Fase 1:** Recopila documentación del cliente en `./00-raw-inputs/`

3. ✅ **Ejecuta tu primer análisis:** Sigue el paso a paso de este README

4. ✅ **Documenta tu experiencia:** Crea un caso de estudio para referencia futura

---

**¿Preguntas? ¿Problemas? ¿Sugerencias?**  
Este es un documento vivo. Actualízalo conforme aprendas y mejores el proceso.

---

**Buena suerte con tus proyectos! 🚀**

---

_Método CEIBA - Desarrollado con ❤️ para arquitectos de software y equipos de ingeniería._
