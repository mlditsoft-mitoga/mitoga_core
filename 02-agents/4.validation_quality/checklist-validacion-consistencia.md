# 🔍 Checklist de Validación de Consistencia - Método ZNS v2.0

**Propósito**: Verificar que todos los artefactos generados son coherentes entre sí y no contienen contradicciones.

**Uso**: Este checklist debe ejecutarse en la Fase 4 (Validación de Calidad) para detectar inconsistencias antes de la entrega.

---

## 1️⃣ Consistencia de Nomenclatura

### 1.1 Nombres de Componentes/Servicios

**Objetivo**: Validar que los mismos componentes tienen nombres consistentes en todos los documentos.

#### Checklist:

- [ ] **C4-L2 ↔ C4-L3**: Componentes en Container se descomponen en Components con mismo nombre base
- [ ] **C4-L3 ↔ Specs**: Nombres de componentes en diagramas coinciden con nombres de módulos en specs
- [ ] **Convención de naming**: Consistente (kebab-case, PascalCase, snake_case)
  - [ ] Diagramas: "Auth Service" (formato C4)
  - [ ] Código/Specs: "auth-service" (kebab-case)
  - [ ] Base de datos: "users" (snake_case, plural/singular consistente)

#### Ejemplos de inconsistencias a buscar:

❌ **Inconsistente**:
- C4-L2: "Authentication Service"
- C4-L3: "AuthService"
- Spec: "user-service"
- SQL: "auth_users"

✅ **Consistente**:
- C4-L2: "Auth Service"
- C4-L3: "Auth Service" → Components: "Login Handler", "Token Manager"
- Spec: "modulo-auth.md" (menciona "Auth Service")
- SQL: "users" (entidad representa usuarios)

---

### 1.2 Nombres de Entidades/Tablas

**Objetivo**: Validar consistencia entre modelo de datos conceptual y físico.

#### Checklist:

- [ ] **ERD ↔ SQL**: Cada entidad en ERD tiene tabla en SQL con mismo nombre
- [ ] **Singular vs Plural**: Consistente en todo el proyecto
  - [ ] Opción A: ERD singular ("User"), SQL plural ("users")
  - [ ] Opción B: Ambos plural ("Users", "users")
- [ ] **Relaciones N:M**: Tablas join en SQL para cada relación many-to-many en ERD
- [ ] **Atributos**: Columnas en SQL coinciden con atributos en ERD (nombre y tipo)

#### Ejemplos de inconsistencias a buscar:

❌ **Inconsistente**:
- ERD: "Products" (plural)
- SQL: "product" (singular)
- Spec: "Producto" (español)

✅ **Consistente**:
- ERD: "Product" (singular, entidad conceptual)
- SQL: "products" (plural, tabla física)
- Spec: "Product entity" (consistente con ERD)

---

## 2️⃣ Trazabilidad Requisitos → Diseño

### 2.1 User Stories → ADRs

**Objetivo**: Cada requisito P0/P1 debe justificar al menos una decisión arquitectónica.

#### Checklist:

- [ ] **100% de US P0** mencionadas en al menos 1 ADR (contexto o consecuencias)
- [ ] **100% de US P1** mencionadas en al menos 1 ADR o spec de módulo
- [ ] **0 ADRs huérfanos**: Cada ADR responde a al menos 1 requisito

#### Cómo validar:

1. Listar todos los IDs de user stories P0/P1
2. Buscar cada ID en todos los ADRs y specs
3. Marcar US que NO aparecen en ningún documento de diseño

**Template de validación**:

| User Story | Prioridad | ADR | Spec | Diagrama | Status |
|------------|-----------|-----|------|----------|--------|
| US-001 | P0 | ADR-002 | modulo-catalog.md | C4-L3-Catalog | ✅ OK |
| US-012 | P0 | - | - | - | ❌ **CRÍTICO: Sin diseño** |
| US-025 | P1 | ADR-004 | - | - | ⚠️ **Falta spec detallada** |

---

### 2.2 Requisitos → Diagramas C4

**Objetivo**: Funcionalidades core deben estar representadas en diagramas.

#### Checklist:

- [ ] **Módulos identificados** en Fase 0 aparecen como Containers en C4-L2
- [ ] **Funcionalidades P0** tienen componente dedicado en al menos un C4-L3
- [ ] **Integraciones externas** (Stripe, SendGrid, etc.) aparecen en C4-L1 y C4-L2

#### Ejemplos de gaps a buscar:

❌ **Gap detectado**:
- Requisito: "Sistema de pagos con Stripe" (P0)
- C4-L1: No aparece "Stripe" como sistema externo
- C4-L2: No aparece "Payment Service" como container

✅ **Cobertura completa**:
- Requisito: "Sistema de pagos con Stripe" (P0)
- C4-L1: "Stripe" como External System
- C4-L2: "Payment Service" container
- C4-L3: "Payment Processor", "Webhook Handler" components
- Spec: "modulo-payments.md"

---

### 2.3 RNFs → Decisiones Arquitectónicas

**Objetivo**: Requisitos no funcionales deben influir en ADRs.

#### Checklist:

- [ ] **RNFs de Performance** → ADR sobre caching, CDN, database indexing
- [ ] **RNFs de Seguridad** → ADR sobre autenticación, encriptación
- [ ] **RNFs de Escalabilidad** → ADR sobre arquitectura (monolito/microservicios)
- [ ] **RNFs de Compliance** → ADR sobre manejo de datos sensibles

#### Template de validación:

| RNF | Tipo | ADR que lo aborda | Spec que lo implementa | Status |
|-----|------|-------------------|------------------------|--------|
| RNF-001: < 2s page load | Performance | ADR-005 (CDN + ISR) | modulo-frontend.md | ✅ OK |
| RNF-008: PCI DSS L4 | Compliance | ADR-003 (Stripe) | modulo-payments.md | ✅ OK |
| RNF-012: GDPR | Compliance | - | - | ❌ **CRÍTICO: No diseñado** |

---

## 3️⃣ Consistencia entre Diagramas

### 3.1 C4-L1 → C4-L2

**Objetivo**: Sistemas internos en Context se expanden en Containers.

#### Checklist:

- [ ] **Sistema principal** en C4-L1 se descompone en múltiples containers en C4-L2
- [ ] **Sistemas externos** en C4-L1 aparecen en C4-L2 con mismas relaciones
- [ ] **Actores** (usuarios) consistentes en ambos niveles

#### Validación:

**C4-L1 (Context)**:
```
[ShopFast System] → [Stripe]
[Customer] → [ShopFast System]
```

**C4-L2 (Container)**: ✅ Debe tener:
```
[Frontend App] → [API Gateway] → [Payment Service] → [Stripe]
[Customer] → [Frontend App]
```

❌ **Inconsistencia** si:
- Stripe no aparece en C4-L2
- Customer no aparece en C4-L2
- Relaciones cambian (ej: Customer → Stripe directo)

---

### 3.2 C4-L2 → C4-L3

**Objetivo**: Containers se descomponen en Components.

#### Checklist:

- [ ] **Cada Container crítico** tiene su diagrama C4-L3
- [ ] **Componentes en C4-L3** suman la funcionalidad del Container padre
- [ ] **Dependencias externas** del Container se reflejan en Components

#### Validación:

**C4-L2 (Container)**:
```
[API Gateway] → [Catalog Service]
[Catalog Service] → [PostgreSQL]
```

**C4-L3 (Component de Catalog Service)**: ✅ Debe tener:
```
[Product Controller]
[Product Repository] → [PostgreSQL]
[Search Engine]
```

❌ **Inconsistencia** si:
- C4-L3 no muestra conexión a PostgreSQL
- Funcionalidad de búsqueda (mencionada en US) no tiene componente

---

## 4️⃣ Consistencia ADRs vs Implementación

### 4.1 Decisiones Tecnológicas

**Objetivo**: Stack elegido en ADRs se refleja en specs y diagramas.

#### Checklist:

- [ ] **Tecnologías en ADR-XXX-stack** aparecen en:
  - [ ] Diagramas C4 (entre corchetes `[Next.js]`)
  - [ ] Specs de módulos (sección "Tecnologías")
  - [ ] Schema SQL (tipo de DB correcto)

#### Ejemplo de validación:

**ADR-002: Stack Tecnológico**
- Frontend: Next.js 14
- Backend: Node.js 20 + Fastify
- DB: PostgreSQL 15
- Cache: Redis 7

**Validar en C4-L2**:
```plantuml
Container(frontend, "Frontend", "Next.js 14") ✅
Container(api, "API", "Node.js + Fastify") ✅
ContainerDb(db, "Database", "PostgreSQL 15") ✅
ContainerDb(cache, "Cache", "Redis 7") ✅
```

❌ **Inconsistencia** si:
- C4 dice "React" en vez de "Next.js"
- Schema SQL es MySQL en vez de PostgreSQL

---

### 4.2 Decisiones de Arquitectura

**Objetivo**: Patrones elegidos se implementan consistentemente.

#### Checklist:

- [ ] **ADR sobre arquitectura** (monolito/microservicios) se refleja en:
  - [ ] Número de containers en C4-L2 (pocos = monolito, muchos = microservicios)
  - [ ] Comunicación entre componentes (in-process vs HTTP)
  - [ ] Estrategia de deployment en specs

#### Ejemplo de validación:

**ADR-001: Arquitectura Monolítica Modular**
- Decisión: Monolito modular (no microservicios)
- Justificación: Equipo pequeño, presupuesto limitado

**Validar en C4-L2**: ✅ Debe tener:
- 1-3 containers (no 10+)
- Comunicación in-process (no gRPC/message queues)
- 1 base de datos compartida (no DB per service)

❌ **Inconsistencia** si:
- C4-L2 muestra 8 microservicios independientes
- Specs mencionan Kubernetes y service mesh
- Hay 5 bases de datos diferentes

---

## 5️⃣ Consistencia Modelo de Datos

### 5.1 ERD ↔ Schema SQL

**Objetivo**: Diseño lógico y físico alineados.

#### Checklist:

- [ ] **Cada entidad** en ERD tiene tabla en SQL
- [ ] **Cada relación** en ERD tiene FK o tabla join en SQL
- [ ] **Cardinalidad** respetada (1:1 → UNIQUE FK, 1:N → FK, N:M → join table)
- [ ] **Atributos** en ERD coinciden con columnas en SQL (nombre y tipo compatible)

#### Validación de Relación 1:N

**ERD**:
```
User 1 ─── * Order
```

**SQL**: ✅ Debe tener:
```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY
);

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES users(id)  -- FK respeta 1:N
);
```

❌ **Inconsistencia** si:
- Falta FK `user_id` en `orders`
- FK tiene UNIQUE constraint (sería 1:1, no 1:N)

---

### 5.2 ERD ↔ Specs de Módulos

**Objetivo**: Entidades mencionadas en specs están en ERD.

#### Checklist:

- [ ] **Entidades en specs** de módulos aparecen en ERD
- [ ] **Atributos mencionados** en specs coinciden con ERD
- [ ] **Relaciones entre módulos** reflejadas en ERD

#### Ejemplo de validación:

**Spec: modulo-catalog.md**
```markdown
### Modelo de Datos
- Product: id, name, price, stock, category_id
- Category: id, name
```

**Validar en ERD**: ✅ Debe tener:
- Entidad "Product" con atributos mencionados
- Entidad "Category"
- Relación Product N ─── 1 Category

❌ **Inconsistencia** si:
- ERD no tiene entidad "Category"
- Product no tiene FK a Category
- Nombres de atributos diferentes (ej: "product_name" vs "name")

---

## 6️⃣ Consistencia de Integraciones

### 6.1 Integraciones en Múltiples Niveles

**Objetivo**: Servicios externos mencionados consistentemente.

#### Checklist:

- [ ] **Cada integración** en C4-L1 tiene:
  - [ ] External System en diagrama
  - [ ] Spec de integración (`integracion-{servicio}.md`)
  - [ ] Mencionada en ADR de decisión tecnológica
  - [ ] Endpoints usados documentados en spec

#### Template de validación:

| Integración | C4-L1 | C4-L2 | Spec | ADR | Endpoints Doc | Status |
|-------------|-------|-------|------|-----|---------------|--------|
| Stripe | ✅ | ✅ | ✅ integracion-stripe.md | ✅ ADR-003 | ✅ | ✅ OK |
| SendGrid | ✅ | ✅ | ❌ | ✅ ADR-002 | ❌ | ⚠️ **Falta spec** |
| AWS S3 | ❌ | ✅ | ✅ | ❌ | ✅ | ⚠️ **No en C4-L1** |

---

### 6.2 Webhooks y Callbacks

**Objetivo**: Comunicación bidireccional documentada.

#### Checklist:

- [ ] **Webhooks de terceros** (ej: Stripe payment.succeeded) tienen:
  - [ ] Endpoint receptor en spec de API
  - [ ] Componente handler en C4-L3
  - [ ] Manejo de errores documentado
  - [ ] Validación de firma (security) especificada

---

## 7️⃣ Consistencia de Seguridad

### 7.1 Autenticación Consistente

**Objetivo**: Mecanismo de auth uniforme en toda la arquitectura.

#### Checklist:

- [ ] **ADR sobre autenticación** define mecanismo único (JWT, OAuth, etc.)
- [ ] **Todos los módulos** que requieren auth lo especifican en spec
- [ ] **APIs públicas** documentan auth en header (ej: `Authorization: Bearer <token>`)
- [ ] **C4-L3** muestra componente de auth (Auth Middleware, Token Validator)

#### Validación:

**ADR-004: Autenticación con JWT**
- Decisión: JWT en header `Authorization`
- Issuer: Auth Service
- Validación: Middleware en API Gateway

**Validar en specs**: ✅ Todos los módulos deben decir:
```markdown
### Seguridad
- Autenticación: JWT en header Authorization
- Endpoints protegidos: Middleware valida token
```

❌ **Inconsistencia** si:
- Un módulo dice "Session cookies"
- Otro dice "API Key"
- ADR dice JWT pero specs no lo mencionan

---

### 7.2 Datos Sensibles

**Objetivo**: Tratamiento consistente de PII y datos financieros.

#### Checklist:

- [ ] **Datos sensibles identificados** en modelo de datos (ej: email, phone, payment_data)
- [ ] **Encriptación en reposo** especificada para campos sensibles
- [ ] **Enmascaramiento en logs** documentado en specs
- [ ] **Compliance** (GDPR, PCI DSS) vinculado a tratamiento de datos

---

## 8️⃣ Consistencia de Volúmenes y Performance

### 8.1 Estimaciones Consistentes

**Objetivo**: Números de volumen no contradictorios.

#### Checklist:

- [ ] **Estimaciones en contexto de negocio** ↔ **Specs de módulos**
  - [ ] Usuarios concurrentes
  - [ ] Transacciones por día
  - [ ] Volumen de datos (GB)
- [ ] **RNFs de performance** ↔ **Decisiones de caching/indexing** en ADRs

#### Validación:

**Contexto de negocio**:
- 1,000 productos
- 100 órdenes/día
- 500 usuarios concurrentes

**Specs de módulos**: ✅ Deben estimar:
- Catalog Service: 1k productos, 10k búsquedas/día
- Order Service: 100-150 órdenes/día (buffer)
- Auth Service: 500 login simultáneos

❌ **Inconsistencia** si:
- Spec dice "1 millón de productos" (contradice negocio)
- No hay índices para queries de búsqueda (contradice volumen)

---

## 9️⃣ Checklist de Validación Manual

### Para Ejecutar Validación de Consistencia:

#### Paso 1: Extraer Nombres (15 min)
```bash
# Componentes de C4
grep -rh "Container\|Component" 04-architecture/diagrams/*.puml | sort | uniq

# Entidades de ERD
grep -rh "entity\|class" 04-architecture/diagrams/erd-*.puml | sort | uniq

# Tablas de SQL
grep "CREATE TABLE" 04-architecture/scripts/*.sql | sort
```

#### Paso 2: Crear Matriz de Trazabilidad (30 min)
- Listar todos los US P0/P1
- Buscar cada US en ADRs, specs, diagramas
- Marcar con ✅ / ❌

#### Paso 3: Validar Tecnologías (15 min)
- Extraer tecnologías de ADRs
- Buscar en diagramas C4 (entre corchetes)
- Verificar consistencia

#### Paso 4: Validar Modelo de Datos (20 min)
- Comparar entidades ERD vs tablas SQL
- Verificar relaciones vs foreign keys
- Validar cardinalidad

#### Paso 5: Generar Reporte (10 min)
- Listar todas las inconsistencias encontradas
- Clasificar por severidad (🔴🟡🟠🟢)
- Priorizar correcciones

---

## ✅ Criterios de Aprobación

### Nivel Mínimo Aceptable
- [ ] **Zero inconsistencias 🔴 CRÍTICAS**
- [ ] **< 5 inconsistencias 🟡 ALTAS**
- [ ] **100% trazabilidad P0**
- [ ] **Tecnologías consistentes** entre ADRs y diagramas

### Nivel Recomendado
- [ ] **< 3 inconsistencias 🟡 ALTAS**
- [ ] **< 10 inconsistencias 🟠 MEDIAS**
- [ ] **100% trazabilidad P0 + P1**
- [ ] **Nombres 100% consistentes** (componentes, entidades)

### Nivel Excelente
- [ ] **Zero inconsistencias 🟡 ALTAS**
- [ ] **< 5 inconsistencias 🟠 MEDIAS**
- [ ] **100% trazabilidad completa** (incluyendo P2)
- [ ] **Documentación de supuestos** cuando hay ambigüedad

---

## 🛠️ Scripts de Automatización

### Script 1: Validar nombres de componentes

```bash
#!/bin/bash
# validate-component-names.sh

# Extraer componentes de C4-L2
c4l2=$(grep -oh 'Container([^,]*' 04-architecture/diagrams/c4-l2-*.puml | cut -d'(' -f2 | tr -d '"' | sort)

# Extraer nombres de specs
specs=$(ls 04-architecture/specs/modulo-*.md | xargs -I{} basename {} .md | sed 's/modulo-//' | sort)

# Comparar
echo "=== Componentes en C4-L2 ==="
echo "$c4l2"
echo ""
echo "=== Módulos en specs ==="
echo "$specs"
echo ""
echo "=== Inconsistencias ==="
comm -3 <(echo "$c4l2") <(echo "$specs")
```

### Script 2: Validar trazabilidad

```python
#!/usr/bin/env python3
# validate-traceability.py

import re
import glob

# Extraer user stories de requisitos
with open('01-context-consolidated/02-requisitos-funcionales.md') as f:
    user_stories = re.findall(r'US-\d+', f.read())

# Buscar en ADRs y specs
traced = set()
for file in glob.glob('04-architecture/**/*.md', recursive=True):
    with open(file) as f:
        content = f.read()
        for us in user_stories:
            if us in content:
                traced.add(us)

# Reportar no trazados
untraced = set(user_stories) - traced
if untraced:
    print("❌ User stories sin trazabilidad:")
    for us in sorted(untraced):
        print(f"  - {us}")
else:
    print("✅ 100% trazabilidad")
```

---

**Versión**: 1.0.0  
**Fecha**: 7 de noviembre de 2025  
**Método ZNS**: v1.2
