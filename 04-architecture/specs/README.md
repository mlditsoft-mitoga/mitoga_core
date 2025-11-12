# Especificaciones Técnicas Detalladas

## 📁 Propósito

Este directorio contiene las **especificaciones técnicas detalladas** de módulos, servicios y APIs del sistema.

---

## 📐 Estructura Recomendada

```
03-arquitectura/especificaciones/
├── modulos/                    # Especificaciones de módulos/servicios
│   ├── auth-service.md
│   ├── order-service.md
│   ├── payment-service.md
│   └── notification-service.md
│
├── apis/                       # Especificaciones de endpoints
│   ├── auth-api.md
│   ├── orders-api.md
│   ├── payments-api.md
│   └── notifications-api.md
│
└── integraciones/              # Integraciones con sistemas externos
    ├── stripe-integration.md
    ├── sendgrid-integration.md
    └── aws-s3-integration.md
```

---

## 📋 Plantillas Disponibles

### 1. Especificación de Módulo/Servicio
**Plantilla:** `02-agentes/2.definicion_arquitectura/plantilla-modulo-servicio.md`

**Contenido:**
- Propósito y responsabilidades
- Bounded context (si aplica DDD)
- Capas y componentes internos
- Tecnologías utilizadas
- Modelo de datos local
- APIs expuestas
- Dependencias externas
- Deployment y escalabilidad

**Naming:** `[nombre-servicio].md`

**Ejemplos:**
- `auth-service.md`
- `order-service.md`
- `payment-service.md`

---

### 2. Especificación de API/Endpoint
**Plantilla:** `02-agentes/2.definicion_arquitectura/plantilla-api-endpoint.md`

**Contenido:**
- Método HTTP y URL
- Autenticación/autorización
- Headers requeridos
- Path/Query parameters
- Request body schema (JSON)
- Response schemas (success + errors)
- Códigos de estado HTTP
- Ejemplos de request/response
- Rate limiting
- Validaciones

**Naming:** `[recurso]-api.md` o `[endpoint-name].md`

**Ejemplos:**
- `auth-api.md` (todos los endpoints de autenticación)
- `orders-api.md` (todos los endpoints de pedidos)
- `POST-create-order.md` (endpoint específico)

---

## ✅ Checklist de Especificaciones Mínimas

### Módulos/Servicios (Top 5-10)
- [ ] Auth/User Service
- [ ] Core Business Service (ej: Orders, Bookings)
- [ ] Payment/Billing Service
- [ ] Notification Service
- [ ] Reporting/Analytics Service

### APIs Críticas (Top 10-20)
- [ ] POST /api/v1/auth/login
- [ ] POST /api/v1/auth/register
- [ ] GET /api/v1/users/:id
- [ ] POST /api/v1/[recurso-principal]
- [ ] GET /api/v1/[recurso-principal]
- [ ] PUT/PATCH /api/v1/[recurso-principal]/:id
- [ ] DELETE /api/v1/[recurso-principal]/:id

### Integraciones Externas
- [ ] Payment gateway (Stripe, PayPal)
- [ ] Email service (SendGrid, SES)
- [ ] SMS service (Twilio)
- [ ] Storage (S3, Azure Blob)
- [ ] Third-party APIs

---

## 📊 Nivel de Detalle Recomendado

### Especificación Completa (Servicios Core)
```markdown
# Order Service

## 1. Propósito
Gestiona el ciclo de vida completo de pedidos...

## 2. Bounded Context (DDD)
Aggregate Roots:
- Order (orden con items)
- OrderItem (producto en orden)
Value Objects:
- OrderStatus (DRAFT, CONFIRMED, SHIPPED, DELIVERED, CANCELLED)
- Money (amount, currency)

## 3. Arquitectura Interna
├── Controllers (REST endpoints)
├── Application Services (use cases)
├── Domain Layer
│   ├── Entities
│   ├── Value Objects
│   └── Domain Services
└── Infrastructure
    ├── Repositories
    └── External Integrations

## 4. Stack Tecnológico
- Runtime: Node.js 20 LTS
- Framework: NestJS 10
- Database: PostgreSQL 15
- ORM: TypeORM
- Validation: class-validator
- Testing: Jest + Supertest

## 5. Modelo de Datos
[Ver ERD en diagramas/erd-database-orders.puml]

Tablas principales:
- orders (id, user_id, status, total, created_at)
- order_items (id, order_id, product_id, quantity, price)

## 6. APIs Expuestas
[Ver especificación completa en apis/orders-api.md]

- POST /api/v1/orders
- GET /api/v1/orders/:id
- PUT /api/v1/orders/:id/status
- DELETE /api/v1/orders/:id

## 7. Dependencias
- Auth Service (validar usuario)
- Product Service (validar inventario)
- Payment Service (procesar pago)
- Notification Service (enviar confirmación)

## 8. Deployment
- Container: Docker + ECS Fargate
- Replicas: 2 mínimo (HA)
- Autoscaling: CPU > 70%
- Resources: 512MB RAM, 0.25 vCPU
```

### Especificación Resumida (Servicios Secundarios)
```markdown
# Notification Service

## Propósito
Envío de notificaciones email/SMS/push.

## Stack
Node.js + Express + Redis (queue)

## Integraciones
- SendGrid (email)
- Twilio (SMS)
- Firebase Cloud Messaging (push)

## Deployment
Serverless (AWS Lambda) + SQS
```

---

## 🎨 Formato y Calidad

### Usar Markdown Estructurado
- Títulos jerárquicos (H1 → H6)
- Listas con viñetas o numeradas
- Tablas para comparativas
- Bloques de código con syntax highlighting
- Diagramas PlantUML embebidos (si aplica)

### Incluir Ejemplos Reales
❌ No: "El endpoint devuelve un JSON"  
✅ Sí:
```json
{
  "id": "ord_123abc",
  "status": "confirmed",
  "items": [
    {
      "product_id": "prod_456",
      "quantity": 2,
      "price": 29.99
    }
  ],
  "total": 59.98
}
```

### Ser Específico
❌ No: "Se valida el input"  
✅ Sí: "Se validan: email formato RFC 5322, password min 8 chars con mayúscula/número, phone formato E.164"

---

## 🔗 Referencias Cruzadas

### Desde Especificaciones → Diagramas
```markdown
Ver diagrama de componentes: 
`diagramas/c4-l3-components-order-service.puml`
```

### Desde Especificaciones → ADRs
```markdown
Decisión de usar TypeORM documentada en:
`adrs/ADR-006-orm-selection.md`
```

### Desde Especificaciones → Modelo de Datos
```markdown
Esquema completo de base de datos:
`modelo-datos/database/schema.sql`
```

---

## 📚 Recursos

**Plantillas:**
- `02-agentes/2.definicion_arquitectura/plantilla-modulo-servicio.md`
- `02-agentes/2.definicion_arquitectura/plantilla-api-endpoint.md`

**Estándares:**
- OpenAPI/Swagger para APIs REST
- AsyncAPI para APIs event-driven
- gRPC Protocol Buffers para microservicios

---

**Método:** CEIBA v1.2  
**Roles:** Solutions Architect Senior & Cloud Architect  
**Calidad:** Especificaciones detalladas para implementación directa
