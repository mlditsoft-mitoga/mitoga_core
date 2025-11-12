# ✅ Checklist de Completitud - Método CEIBA v1.2

**Propósito**: Verificar que todos los artefactos obligatorios han sido generados y contienen las secciones requeridas.

**Uso**: Marcar con [x] cada item completado. Este checklist debe estar 100% completo antes de pasar a Fase 3 (Exportación).

---

## 📋 Fase 0: Consolidación de Contexto

### Artefactos Obligatorios

- [ ] `01-context-consolidated/01-contexto-negocio.md` existe
- [ ] `01-context-consolidated/02-requisitos-funcionales.md` existe
- [ ] `01-context-consolidated/03-requisitos-no-funcionales.md` existe

### Contenido de `01-contexto-negocio.md`

- [ ] **Sección 1**: Resumen Ejecutivo (elevator pitch, problema, solución)
- [ ] **Sección 2**: Modelo de Negocio (segmentos, propuesta de valor, canales, ingresos)
- [ ] **Sección 3**: Objetivos Estratégicos (OKRs, KPIs, métricas de éxito)
- [ ] **Sección 4**: Análisis de Stakeholders (clientes, admins, terceros)
- [ ] **Sección 5**: Restricciones y Supuestos (presupuesto, timeline, equipo)
- [ ] **Longitud mínima**: > 1,000 palabras

### Contenido de `02-requisitos-funcionales.md`

- [ ] **User Stories**: Mínimo 20 user stories documentadas
- [ ] **Formato**: Cada US tiene formato "Como/Quiero/Para" o Gherkin
- [ ] **Criterios de Aceptación**: Cada US tiene criterios específicos
- [ ] **Priorización**: Cada US tiene prioridad (P0/P1/P2 o MoSCoW)
- [ ] **Estimaciones**: Cada US tiene story points o esfuerzo estimado
- [ ] **Módulos Identificados**: Agrupación lógica de funcionalidades
- [ ] **Dependencias**: Relaciones entre USs documentadas

### Contenido de `03-requisitos-no-funcionales.md`

- [ ] **RNFs Documentados**: Mínimo 10 requisitos no funcionales
- [ ] **Categorías ISO 25010**: Performance, Seguridad, Escalabilidad, Usabilidad, etc.
- [ ] **Métricas Cuantificables**: Cada RNF tiene SLO/KPI medible
- [ ] **Estrategia de Validación**: Cómo se verificará cada RNF
- [ ] **Priorización**: Crítico / Alto / Medio / Bajo
- [ ] **Compliance Mapeado**: Regulaciones (PCI, GDPR, etc.) vinculadas a RNFs

---

## 🔍 Fase 1: Análisis de Obsolescencia (si aplica)

**Nota**: Esta fase solo aplica para proyectos brownfield (modernización/migración).

- [ ] `03-analysis/reporte-obsolescencia-{proyecto}.md` existe
- [ ] `03-analysis/plan-modernizacion-{proyecto}.md` existe
- [ ] **Opcional**: `03-analysis/matriz-riesgos-{proyecto}.xlsx`

### Contenido de Reporte de Obsolescencia

- [ ] Inventario tecnológico completo (stack actual)
- [ ] Análisis de versiones y EOL dates
- [ ] CVEs identificados con severidad
- [ ] Score de deuda técnica (0-100)
- [ ] Recomendaciones de modernización priorizadas

---

## 🏗️ Fase 2: Arquitectura de Soluciones

### ADRs (Architecture Decision Records)

- [ ] **Mínimo 3 ADRs** generados
- [ ] ADR sobre arquitectura general (monolito/microservicios/híbrido)
- [ ] ADR sobre stack tecnológico (lenguajes, frameworks, DBs)
- [ ] ADR sobre estrategia de despliegue (cloud provider, containerización)

#### Por cada ADR:

- [ ] **Metadata**: Fecha, estado, autores, revisores
- [ ] **Contexto y Problemática**: Qué se está decidiendo y por qué
- [ ] **Opciones Consideradas**: Mínimo 3 alternativas evaluadas
- [ ] **Matriz de Decisión**: Scoring cuantitativo con pesos
- [ ] **Decisión Tomada**: Opción elegida con justificación
- [ ] **Consecuencias**: Pros y cons explícitos
- [ ] **Plan de Implementación**: Pasos concretos
- [ ] **Monitoreo**: Cómo validar la decisión post-implementación

### Diagramas C4

#### Nivel 1: Context

- [ ] `04-architecture/diagrams/c4-l1-context-{proyecto}.puml` existe
- [ ] Muestra sistema principal y sistemas externos
- [ ] Muestra usuarios (actores) principales
- [ ] Relaciones claramente etiquetadas
- [ ] Renderiza sin errores (PlantUML)

#### Nivel 2: Container

- [ ] `04-architecture/diagrams/c4-l2-container-{proyecto}.puml` existe
- [ ] Muestra todos los containers (apps, DBs, servicios)
- [ ] Tecnologías especificadas entre corchetes [Tech]
- [ ] Relaciones con protocolos (HTTP, gRPC, async)
- [ ] Renderiza sin errores

#### Nivel 3: Component

- [ ] **Mínimo 1 diagrama C4-L3** por módulo core
- [ ] Formato: `c4-l3-component-{modulo}.puml`
- [ ] Muestra componentes internos del container
- [ ] Responsabilidades de cada componente claras
- [ ] Renderiza sin errores

### Especificaciones de Módulos

- [ ] **Especificaciones de módulos** para 100% funcionalidades P0/P1
- [ ] Formato: `04-architecture/specs/modulo-{nombre}.md`

#### Por cada Especificación de Módulo:

- [ ] **Propósito y Responsabilidades**: Qué hace el módulo
- [ ] **APIs Públicas**: Endpoints + contratos (request/response)
- [ ] **Modelo de Datos**: Entidades manejadas
- [ ] **Dependencias**: Otros módulos/servicios requeridos
- [ ] **Consideraciones de Seguridad**: Auth, autorización, validación
- [ ] **Estimaciones de Volumen**: Usuarios, transacciones, datos
- [ ] **Performance**: SLOs de latencia, throughput

### Especificaciones de APIs

- [ ] `04-architecture/specs/api-{nombre}.md` para APIs públicas
- [ ] Formato OpenAPI 3.0 o equivalente
- [ ] Todos los endpoints documentados (GET, POST, PUT, DELETE)
- [ ] Schemas de request/response definidos
- [ ] Códigos de error documentados (4xx, 5xx)
- [ ] Autenticación especificada (JWT, OAuth, API Key)
- [ ] Rate limiting documentado

### Especificaciones de Integraciones

- [ ] `04-architecture/specs/integracion-{servicio}.md` por integración externa
- [ ] Proveedor claramente identificado (Stripe, SendGrid, etc.)
- [ ] Endpoints usados documentados
- [ ] Manejo de errores especificado
- [ ] Estrategia de retry documentada
- [ ] Webhook handling (si aplica)

---

## 💾 Fase 2.1: Modelado de Datos

### Modelo de Datos Relacional

- [ ] `04-architecture/model-data/modelo-datos-{proyecto}.md` existe
- [ ] Todas las entidades documentadas
- [ ] Relaciones entre entidades (1:1, 1:N, N:M)
- [ ] Atributos de cada entidad con tipos de datos
- [ ] Claves primarias y foráneas identificadas
- [ ] Índices sugeridos para queries frecuentes

### Entity Relationship Diagram (ERD)

- [ ] `04-architecture/diagrams/erd-{proyecto}.puml` existe
- [ ] Todas las entidades del modelo aparecen
- [ ] Relaciones con cardinalidad (1..1, 1..*, *..*)
- [ ] Renderiza sin errores (PlantUML)

### Schema SQL

- [ ] `04-architecture/scripts/schema-{proyecto}-v1.sql` existe
- [ ] Todas las tablas del ERD tienen DDL
- [ ] PRIMARY KEYs definidas
- [ ] FOREIGN KEYs con ON DELETE/UPDATE
- [ ] UNIQUE constraints donde aplica
- [ ] INDEXes para columnas más consultadas
- [ ] TIMESTAMPs (created_at, updated_at)
- [ ] Soft deletes considerados (deleted_at, si aplica)

### ADR de Estrategia de Persistencia

- [ ] `04-architecture/adrs/ADR-XXX-estrategia-persistencia.md` existe
- [ ] Decisión de tipo de DB (SQL, NoSQL, híbrido)
- [ ] Justificación de normalización (3NF, BCNF, desnormalización)
- [ ] Estrategia de caché (Redis, Memcached)
- [ ] Estrategia de particionamiento/sharding (si aplica)

---

## 🎯 Validación Transversal

### Trazabilidad

- [ ] **100% requisitos P0** tienen diseño vinculado (ADR/diagrama/spec)
- [ ] **100% requisitos P1** tienen diseño vinculado
- [ ] **0 diseños huérfanos** (sin requisito que los justifique)

### Consistencia de Nombres

- [ ] Componentes en C4-L2 ↔ Módulos en specs (nombres consistentes)
- [ ] Entidades en ERD ↔ Tablas en SQL (nombres consistentes)
- [ ] Servicios en diagramas ↔ Integraciones en specs

### Seguridad (Módulos Críticos)

Para módulos de: Autenticación, Autorización, Pagos, Datos Personales

- [ ] Autenticación especificada (JWT, OAuth, etc.)
- [ ] Autorización especificada (RBAC, ABAC)
- [ ] Encriptación en tránsito (HTTPS)
- [ ] Encriptación en reposo (para datos sensibles)
- [ ] Input validation documentada
- [ ] Rate limiting considerado
- [ ] Audit logging especificado

### Compliance

- [ ] Todos los RNFs de compliance tienen cobertura en diseño
- [ ] PCI DSS: No almacenamiento de datos de tarjetas (si aplica)
- [ ] GDPR: Consentimiento, derecho al olvido, exportación (si aplica)
- [ ] HIPAA: Encriptación PHI (si aplica)

---

## 📊 Checklist de Calidad

### Formato y Estructura

- [ ] Todos los Markdown sin errores de sintaxis
- [ ] Todos los diagramas PlantUML renderizan correctamente
- [ ] Tablas bien formateadas (pipes alineados)
- [ ] Headers jerárquicos correctos (H1 > H2 > H3)
- [ ] Links internos funcionando
- [ ] Sin typos críticos (nombres técnicos)

### Extensión y Profundidad

- [ ] ADRs: Mínimo 2 páginas cada uno
- [ ] Specs de módulos: Mínimo 3 páginas cada uno
- [ ] Modelo de datos: Mínimo 5 páginas
- [ ] Total documentación: Mínimo 50 páginas

### Claridad

- [ ] Glosario de términos técnicos (si dominio complejo)
- [ ] Ejemplos concretos en specs complejas
- [ ] Diagramas de flujo para procesos complejos
- [ ] Código de ejemplo (snippets de API, queries SQL)

---

## ✅ Criterios de Aprobación

### Nivel Mínimo Aceptable

- [x] **80% de items obligatorios** completados
- [x] **100% de artefactos críticos** (ADRs principales, C4-L1, C4-L2)
- [x] **100% de trazabilidad P0** (requisitos → diseño)
- [x] **Zero gaps de seguridad** en módulos críticos

### Nivel Recomendado

- [x] **90% de items obligatorios** completados
- [x] **100% de trazabilidad P0 + P1**
- [x] **Diagramas C4-L3** para todos los módulos core
- [x] **Specs de APIs** para todos los endpoints públicos

### Nivel Excelente

- [x] **95% de items** completados
- [x] **100% de trazabilidad** (incluyendo P2)
- [x] **Documentación exhaustiva** (> 80 páginas)
- [x] **Scripts de validación** automatizados incluidos

---

## 📝 Notas de Uso

### Cómo usar este checklist:

1. **Durante la ejecución**: Marcar items al completarlos
2. **Pre-validación**: Revisar checklist antes de Fase 4 (Validación)
3. **Post-validación**: Corregir items faltantes identificados
4. **Pre-exportación**: Asegurar 100% completitud antes de Fase 3 (Word)

### Adaptaciones por tipo de proyecto:

**Proyecto Greenfield** (nuevo):
- Saltear Fase 1 (Obsolescencia)
- Enfocarse en Fases 0, 2, 2.1

**Proyecto Brownfield** (modernización):
- Ejecutar TODAS las fases (0, 1, 2, 2.1)
- Fase 1 crítica para entender deuda técnica

**MVP Rápido** (< 3 meses):
- Priorizar P0 únicamente
- Mínimo 3 ADRs
- Mínimo 1 C4-L3 (módulo más complejo)

**Proyecto Enterprise** (> 6 meses):
- 100% de checklist obligatorio
- Agregar specs de monitoreo
- Agregar runbooks de operaciones

---

**Versión**: 1.0.0  
**Fecha**: 7 de noviembre de 2025  
**Método CEIBA**: v1.2
