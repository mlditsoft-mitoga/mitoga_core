# Diagramas Arquitectónicos

## 📁 Propósito

Este directorio contiene todos los **diagramas de arquitectura** del proyecto en formato PlantUML (.puml) como fuente principal.

---

## 📐 Política de Diagramación

**⚠️ IMPORTANTE:** El Método ZNS v2.0 utiliza **PlantUML + C4 Model** como estándar obligatorio.

Lee la política completa:
```
02-agentes/2.definicion_arquitectura/politica-diagramacion.md
```

---

## 📋 Tipos de Diagramas Requeridos

### 1. C4 Model - Architecture
- **C4 Level 1:** `c4-l1-context-[sistema].puml` - Vista de contexto del sistema
- **C4 Level 2:** `c4-l2-containers-[sistema].puml` - Contenedores y tecnologías
- **C4 Level 3:** `c4-l3-components-[servicio].puml` - Componentes internos por servicio

### 2. Entity-Relationship Diagrams (ERD)
- **Database:** `erd-database-[nombre].puml` - Modelo de datos con notación Crow's Foot

### 3. Sequence Diagrams
- **Flows:** `sequence-[flujo].puml` - Flujos críticos del sistema
  - `sequence-auth-login.puml`
  - `sequence-order-checkout.puml`
  - `sequence-payment-process.puml`

### 4. Deployment Diagrams
- **Infrastructure:** `deployment-[cloud]-[ambiente].puml` - Infraestructura cloud
  - `deployment-aws-production.puml`
  - `deployment-aws-staging.puml`
  - `deployment-azure-production.puml`

---

## 📐 Nomenclatura de Archivos

```
[tipo]-[nivel]-[nombre-descriptivo].puml
```

**Convención obligatoria:**

| Tipo | Patrón | Ejemplo |
|------|--------|---------|
| C4 L1 | `c4-l1-context-[sistema]` | `c4-l1-context-ecommerce.puml` |
| C4 L2 | `c4-l2-containers-[sistema]` | `c4-l2-containers-ecommerce.puml` |
| C4 L3 | `c4-l3-components-[servicio]` | `c4-l3-components-order-service.puml` |
| ERD | `erd-database-[nombre]` | `erd-database-main.puml` |
| Sequence | `sequence-[flujo]` | `sequence-auth-login.puml` |
| Deployment | `deployment-[cloud]-[env]` | `deployment-aws-production.puml` |

---

## 🔄 Workflow de Generación

### Paso 1: Crear Diagrama PlantUML
```plantuml
@startuml
!include https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/master/C4_Context.puml

title Sistema E-commerce - Vista de Contexto

Person(cliente, "Cliente", "Usuario de la tienda")
System(ecommerce, "Sistema E-commerce", "Gestiona pedidos y pagos")
System_Ext(payment, "Pasarela de Pago", "Stripe")

Rel(cliente, ecommerce, "Realiza pedidos", "HTTPS")
Rel(ecommerce, payment, "Procesa pagos", "REST API")

@enduml
```

### Paso 2: Renderizar a SVG
```bash
# Renderizar un archivo
plantuml -tsvg c4-l1-context-ecommerce.puml

# Batch rendering (todos los diagramas)
plantuml -tsvg *.puml
```

### Paso 3: Importar a Draw.io (Opcional)
```
1. Abrir https://app.diagrams.net/
2. File → Import from → SVG
3. Ajustar estilo corporativo
4. Exportar:
   - .drawio.xml (editable)
   - .png (presentaciones, 300dpi)
```

### Paso 4: Versionar en Git
```bash
git add c4-l1-context-ecommerce.puml     # Fuente (obligatorio)
git add c4-l1-context-ecommerce.svg      # Renderizado
git add c4-l1-context-ecommerce.drawio.xml  # Draw.io (si refinado)
git add c4-l1-context-ecommerce.png      # Imagen final
```

---

## ✅ Checklist de Completitud

### Proyecto Mínimo (Greenfield)
- [ ] C4 L1: Contexto del sistema completo
- [ ] C4 L2: Contenedores con tecnologías
- [ ] C4 L3: Componentes de servicios críticos (top 2-3)
- [ ] ERD: Modelo de datos principal
- [ ] Sequence: Flujos críticos (top 3-5)
- [ ] Deployment: Infraestructura producción

### Proyecto Completo (Enterprise)
- [ ] Todo lo anterior +
- [ ] C4 L3: Todos los servicios principales
- [ ] ERD: Por bounded context o microservicio
- [ ] Sequence: Flujos error/compensación
- [ ] Deployment: Staging + DR/Backup
- [ ] State diagrams: Lifecycle de entidades críticas

---

## 🎨 Guía de Estilo

### Colores C4 (por defecto)
- **Person:** #08427B (azul oscuro)
- **System:** #1168BD (azul medio)
- **System_Ext:** #999999 (gris)
- **Container:** #438DD5 (azul claro)

### Personalización (opcional)
```plantuml
!define PERSON_BG_COLOR #2E86C1
!define SYSTEM_BG_COLOR #5DADE2

Person(user, "Usuario", $bgColor=PERSON_BG_COLOR)
```

### Fuentes
```plantuml
skinparam defaultFontName Arial
skinparam defaultFontSize 14
skinparam titleFontSize 18
```

---

## 📚 Plantillas y Ejemplos

**Plantillas completas:**
```
02-agentes/2.definicion_arquitectura/prompt-arquitectura-soluciones.md
```

**Secciones relevantes:**
- Línea 1660-1850: C4 L1/L2/L3
- Línea 1900-2100: ERD Crow's Foot
- Línea 2200-2300: Sequence diagrams
- Línea 2400-2500: Deployment AWS/Azure/GCP

---

## 🔗 Recursos

- **PlantUML:** https://plantuml.com/
- **C4 Model:** https://c4model.com/
- **C4-PlantUML:** https://github.com/plantuml-stdlib/C4-PlantUML
- **AWS Icons:** https://github.com/awslabs/aws-icons-for-plantuml
- **Azure Icons:** https://github.com/plantuml-stdlib/Azure-PlantUML

---

**Método:** ZNS v2.0  
**Estándar:** PlantUML + C4 Model (obligatorio)  
**Ver política completa:** `02-agentes/2.definicion_arquitectura/politica-diagramacion.md`
