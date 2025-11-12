# 📖 README: Agente 4 - Validación de Calidad

**Fase**: 4 (Validación de Calidad)  
**Versión**: 1.0.0  
**Método CEIBA**: v1.2

---

## 🎯 Propósito

El **Agente 4: Validación de Calidad** es responsable de auditar exhaustivamente toda la documentación generada en las fases anteriores, garantizando:

✅ **Completitud**: Todos los artefactos obligatorios generados  
✅ **Consistencia**: Coherencia entre todos los documentos  
✅ **Corrección**: Adherencia a estándares y mejores prácticas  
✅ **Claridad**: Documentación comprensible y sin ambigüedades  
✅ **Trazabilidad**: Vínculo claro de requisitos → diseño → implementación

---

## 📂 Archivos de este Directorio

### 1. `prompt-validar-outputs.md`
**Prompt maestro** con instrucciones completas para ejecutar la validación de calidad.

- 🎭 **Rol**: Quality Assurance Architect y Technical Reviewer Senior
- 🎯 **Input**: Toda la documentación de fases 0, 1 (opcional), 2, 2.1
- 📊 **Output**: Reporte de validación con score global y plan de corrección
- ⏱️ **Duración**: 2-3 horas

### 2. `checklist-completitud.md`
**Checklist exhaustivo** de artefactos obligatorios por fase.

- ✅ Fase 0: Contexto consolidado (3 archivos)
- ✅ Fase 1: Análisis obsolescencia (si aplica)
- ✅ Fase 2: Arquitectura (ADRs, C4, specs)
- ✅ Fase 2.1: Modelado de datos (ERD, SQL schema)

### 3. `checklist-validacion-consistencia.md`
**Checklist de consistencia** entre documentos.

- 🔗 Trazabilidad requisitos → diseño
- 📝 Consistencia de nomenclatura
- 🏗️ Consistencia entre diagramas C4
- 💾 Consistencia modelo de datos (ERD ↔ SQL)
- 🔐 Consistencia de seguridad

---

## 🚀 Cómo Usar este Agente

### Cuándo Ejecutar

**✅ EJECUTAR cuando:**
- Has completado Fase 2 (Arquitectura) o Fase 2.1 (Modelado Datos)
- Antes de pasar a Fase 3 (Exportación a Word)
- Quieres validar calidad antes de entregar al cliente
- Tienes dudas sobre completitud o consistencia

**❌ NO ejecutar cuando:**
- Todavía estás en Fase 0 (Consolidación)
- No has generado ADRs ni diagramas C4
- Es un proyecto en progreso (ejecutar al finalizar cada fase)

---

### Flujo de Ejecución

```
1. Completar Fases 0, 2, 2.1
        ↓
2. Usar checklist-completitud.md (verificar artefactos)
        ↓
3. Ejecutar prompt-validar-outputs.md
        ↓
4. Revisar reporte de validación
        ↓
5. Corregir issues críticos/altos
        ↓
6. Re-validar (opcional)
        ↓
7. Aprobar para Fase 3 (Exportación)
```

---

### Input Requerido

El agente necesita acceso a:

```
01-context-consolidated/
  ├── 01-contexto-negocio.md
  ├── 02-requisitos-funcionales.md
  └── 03-requisitos-no-funcionales.md

03-analysis/ (opcional, solo si Fase 1 ejecutada)
  ├── reporte-obsolescencia-*.md
  └── plan-modernizacion-*.md

04-architecture/
  ├── adrs/
  │   ├── ADR-001-*.md
  │   ├── ADR-002-*.md
  │   └── ADR-003-*.md
  ├── diagrams/
  │   ├── c4-l1-context-*.puml
  │   ├── c4-l2-container-*.puml
  │   ├── c4-l3-component-*.puml
  │   └── erd-*.puml
  ├── specs/
  │   ├── modulo-*.md
  │   ├── api-*.md
  │   └── integracion-*.md
  ├── model-data/
  │   └── modelo-datos-*.md
  └── scripts/
      └── schema-*.sql
```

---

### Output Generado

El agente genera 3 archivos en `04-architecture/validation/`:

#### 1. `reporte-validacion-{fecha}.md`
Reporte completo con:
- 📊 Executive summary con score global (0-100)
- 📋 Issues por severidad (🔴🟡🟠🟢)
- 📝 Plan de corrección priorizado
- 💡 Recomendaciones estratégicas

#### 2. `checklist-completitud.md`
Checklist marcado con ✅/❌ de:
- Artefactos obligatorios por fase
- Secciones obligatorias por tipo de documento
- Cobertura de trazabilidad

#### 3. `matriz-inconsistencias.md`
Tabla de inconsistencias detectadas:
- Nomenclatura (componentes, entidades)
- Trazabilidad (requisitos sin diseño)
- Gaps de seguridad
- Modelos de datos (ERD vs SQL)

---

## 📊 Scoring de Calidad

### Fórmula

```
Score Global = (
  Completitud * 0.30 +
  Consistencia * 0.25 +
  Corrección * 0.25 +
  Claridad * 0.10 +
  Compliance * 0.10
) * 100
```

### Interpretación

| Score | Nivel | Acción |
|-------|-------|--------|
| 90-100 | ⭐ Excelente | ✅ Aprobar para entrega |
| 75-89 | ⭐ Bueno | ✅ Aprobar con issues menores |
| 60-74 | ⚠️ Aceptable | ⚠️ Resolver issues altos |
| 40-59 | ❌ Insuficiente | ❌ Revisión mayor requerida |
| 0-39 | 🔴 Crítico | ⛔ Rehacer documentación |

---

## 🔍 Dimensiones de Validación

### 1. Completitud (30%)
- ✅ Todos los artefactos obligatorios generados
- ✅ Todas las secciones obligatorias completas
- ✅ Cobertura de requisitos P0/P1 al 100%

### 2. Consistencia (25%)
- 🔗 Trazabilidad requisitos → diseño → implementación
- 📝 Nomenclatura consistente (componentes, entidades, tablas)
- 🏗️ Diagramas C4 coherentes entre niveles (L1→L2→L3)
- 💾 Modelo de datos: ERD ↔ SQL schema alineados

### 3. Corrección (25%)
- 📐 Adherencia a estándares (C4 Model, IEEE 830, ISO 25010)
- 🏆 Mejores prácticas de arquitectura (SOLID, DRY, loose coupling)
- 🔒 Seguridad by design (auth, encryption, input validation)
- ⚡ Performance (caching, indexing, estimaciones de volumen)

### 4. Claridad (10%)
- 📖 Redacción técnica precisa y no ambigua
- 🖼️ Diagramas legibles (sin overlapping, colores consistentes)
- 💡 Ejemplos concretos en specs complejas
- 📚 Glosario de términos (si dominio complejo)

### 5. Compliance (10%)
- 📜 Regulaciones cubiertas (PCI DSS, GDPR, HIPAA)
- 🛡️ Seguridad según estándares (OWASP, CIS Benchmarks)
- 📋 Políticas organizacionales respetadas

---

## 🚨 Severidad de Issues

### 🔴 CRÍTICO (Bloqueante)
- Requisitos P0 sin diseño
- Gaps de seguridad críticos (no auth en módulo de pagos)
- Diagramas que no renderizan
- Compliance gap (PCI DSS no cumplido)

**Acción**: ⛔ **STOP** - Resolver antes de continuar

---

### 🟡 ALTO (Debe resolverse)
- Inconsistencias de nombres entre documentos
- Requisitos P1 sin trazabilidad
- Decisiones arquitectónicas sin justificación
- Falta de índices en DB para queries frecuentes

**Acción**: 📋 Resolver antes de Fase 3 (Exportación)

---

### 🟠 MEDIO (Deseable)
- Falta de ejemplos en specs complejas
- Diagramas con texto superpuesto
- Nomenclatura inconsistente menor
- No caching strategy documentada

**Acción**: 📝 Agregar a backlog

---

### 🟢 BAJO (Nice to have)
- Typos y errores ortográficos
- Formato Markdown inconsistente
- Mejoras de legibilidad en diagramas

**Acción**: ✨ Opcional

---

## 💡 Ejemplos de Issues Comunes

### Issue 1: Requisito sin Diseño

```markdown
🔴 **CRÍTICO**: US-012 - Sistema de Reviews

**Problema**: 
User story P0 "dejar reviews de productos" no aparece en 
ningún ADR, diagrama C4, ni especificación de módulo.

**Acción**: 
1. Crear ADR-XXX para arquitectura de reviews
2. Agregar "Review Service" a C4-L3
3. Crear spec modulo-reviews.md
4. Agregar entidad "Review" a ERD
```

---

### Issue 2: Inconsistencia de Nombres

```markdown
🟡 **ALTO**: Nomenclatura Inconsistente - Auth

**Problema**:
- C4-L2: "Authentication Service"
- C4-L3: "AuthService"
- Spec: "user-service"

**Acción**: Estandarizar a "Auth Service" (diagramas) y 
"auth-service" (código/specs)
```

---

### Issue 3: Seguridad No Especificada

```markdown
🔴 **CRÍTICO**: Sin Auth en Módulo de Pagos

**Problema**: modulo-payments.md no especifica:
- Mecanismo de autenticación
- Validación de ownership (¿puede usuario A pagar orden de B?)

**Acción**: Agregar sección "Seguridad" con JWT + role validation
```

---

## 🛠️ Herramientas de Automatización

### Scripts Incluidos en Checklists

1. **validate-plantuml.sh**: Valida sintaxis de diagramas
2. **extract-component-names.sh**: Extrae nombres para comparación
3. **count-artifacts.sh**: Cuenta artefactos generados
4. **validate-traceability.py**: Verifica trazabilidad de USs

### Herramientas Externas Recomendadas

- **PlantUML**: `plantuml -checkonly *.puml`
- **markdownlint**: Validación de formato Markdown
- **Vale**: Linter de prosa técnica
- **linkchecker**: Validación de links

---

## 📚 Referencias

### Documentos de Soporte
- `checklist-seguridad.md`: Defense in Depth (8 capas)
- `plantilla-adr.md`: Estructura esperada de ADRs
- `politica-diagramacion.md`: Estándares de C4 + PlantUML

### Estándares Externos
- **C4 Model**: https://c4model.com
- **ADR Guidelines**: https://adr.github.io
- **ISO 25010**: Software Quality Model
- **IEEE 830**: Software Requirements Specification

---

## ❓ Preguntas Frecuentes

**P: ¿Cuándo debo ejecutar la validación?**  
R: Después de completar Fase 2 o 2.1, antes de exportar a Word.

**P: ¿Qué hago si el score es < 75?**  
R: Prioriza issues 🔴 CRÍTICOS y 🟡 ALTOS. Re-valida después de corregir.

**P: ¿Puedo saltarme la validación?**  
R: No recomendado. La validación detecta issues que serán más costosos de corregir después de entregar al cliente.

**P: ¿Cuánto tiempo toma la validación?**  
R: 2-3 horas para proyecto promedio. Proyectos grandes pueden tomar 4-5 horas.

**P: ¿Qué pasa si encuentro > 20 issues?**  
R: Señal de que la documentación necesita revisión mayor. Prioriza por severidad y corrige por fases.

---

## 📞 Soporte

Para dudas sobre este agente:
1. Revisar ejemplos en `07-tools/ejemplos/`
2. Consultar `AUDITORIA-ARQUITECTURA-PROMPTS.md`
3. Revisar changelog de versiones del agente

---

**Creado**: 7 de noviembre de 2025  
**Versión**: 1.0.0  
**Método CEIBA**: v1.2  
**Autor**: Equipo Método CEIBA
