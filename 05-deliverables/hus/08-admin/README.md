# Módulo 08: Administración

**Épica:** Gestión Operacional y Moderación de Plataforma  
**Prioridad:** MUST HAVE (parcial) + SHOULD HAVE (completo)  
**Story Points Totales:** 44 SP  
**Historias de Usuario:** 8 HUs

---

## 📋 Índice de Historias de Usuario

| ID | Título | SP | Estado | Prioridad |
|----|--------|----|----- --|-----------|
| [HU-060](HU-060-aprobar-rechazar-tutores.md) | Aprobar o Rechazar Tutores Pendientes | 8 | ✅ | MUST HAVE |
| [HU-061](HU-061-dashboard-metricas.md) | Dashboard de Métricas de la Plataforma | 5 | ✅ | MUST HAVE |
| [HU-062](HU-062-gestionar-usuarios.md) | Gestionar Usuarios (Buscar, Ver, Suspender) | 5 | ✅ | MUST HAVE |
| [HU-063](HU-063-moderar-resenas.md) | Moderar Reseñas y Reportes | 5 | ✅ | SHOULD HAVE |
| [HU-064](HU-064-resolver-disputas.md) | Resolver Disputas entre Usuarios | 8 | ✅ | SHOULD HAVE |
| [HU-065](HU-065-configurar-comisiones.md) | Configurar Comisiones y Tarifas | 3 | ✅ | MUST HAVE |
| [HU-066](HU-066-exportar-reportes.md) | Exportar Reportes Financieros | 5 | ✅ | MUST HAVE |
| [HU-067](HU-067-logs-auditoria.md) | Ver Logs de Auditoría del Sistema | 5 | ✅ | MUST HAVE |
| [HU-068](HU-068-gestionar-contenido.md) | Gestionar Contenido y Anuncios | 5 | ✅ | SHOULD HAVE |

**Total:** 8 HUs | 44 SP (error cálculo inicial, corregido)

---

## 🎯 Objetivos del Módulo

Proveer herramientas **operacionales robustas** para gestionar la plataforma, mantener calidad de tutores y resolver issues de usuarios.

**Valor de Negocio:**
- **Calidad garantizada:** Verificación de tutores previene malas experiencias (NPS +15 puntos)
- **Eficiencia operacional:** Herramientas reducen tiempo de gestión 60%
- **Compliance:** Audit logs y reportes financieros cumplen requisitos legales

**KPIs del Módulo:**
- Tiempo de aprobación de tutores: <48 horas
- Tiempo de resolución de disputas: <24 horas
- Tasa de tutores aprobados: ~70% (filtro de calidad)
- Uptime del dashboard: >99.9%

---

## 🔐 Roles y Permisos

### Super Admin
- ✅ Todas las funcionalidades
- ✅ Gestionar otros admins
- ✅ Cambiar configuración crítica (comisiones)

### Admin Moderador
- ✅ Aprobar/rechazar tutores
- ✅ Moderar reseñas
- ✅ Resolver disputas
- ❌ Cambiar comisiones
- ❌ Ver logs de auditoría

### Admin Soporte
- ✅ Gestionar usuarios (buscar, ver)
- ✅ Resolver disputas
- ❌ Suspender usuarios (requiere escalación)
- ❌ Cambiar configuración

### Admin Financiero
- ✅ Dashboard de métricas
- ✅ Exportar reportes financieros
- ✅ Emitir reembolsos manuales
- ❌ Gestionar usuarios

---

## 📊 Arquitectura del Panel de Admin

```
┌─────────────────────────────────────────────────────┐
│              Frontend Admin Dashboard                │
│                (React + TypeScript)                  │
├─────────────────────────────────────────────────────┤
│ • Layout: Sidebar con módulos                       │
│ • Auth: JWT con role "admin" required               │
│ • Routing: /admin/* protegido                       │
│ • UI Library: Tailwind + Shadcn/ui                  │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│              Backend API Routes                      │
│              /api/admin/* (protected)                │
├─────────────────────────────────────────────────────┤
│ GET  /admin/tutors/pending     → HU-060            │
│ POST /admin/tutors/:id/approve → HU-060            │
│ GET  /admin/dashboard/metrics  → HU-061            │
│ GET  /admin/users/search       → HU-062            │
│ POST /admin/users/:id/suspend  → HU-062            │
│ GET  /admin/reviews/reported   → HU-063            │
│ GET  /admin/disputes           → HU-064            │
│ POST /admin/refunds/manual     → HU-064            │
│ PUT  /admin/config/commissions → HU-065            │
│ GET  /admin/reports/financial  → HU-066            │
│ GET  /admin/audit-logs         → HU-067            │
│ POST /admin/content/banners    → HU-068            │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│                 Database (PostgreSQL)                │
├─────────────────────────────────────────────────────┤
│ users (role: admin, moderator, support, finance)    │
│ tutors (status: pending, approved, rejected)        │
│ audit_logs (action, admin_id, timestamp, details)   │
│ disputes (status: open, in_review, resolved)        │
│ platform_config (commissions, fees, settings)       │
└─────────────────────────────────────────────────────┘
```

---

## 🧪 Estrategia de Testing

### Tests Unitarios (30%)
- Cálculos de métricas (total usuarios, revenue, etc.)
- Lógica de permisos (role-based access control)
- Validaciones de formularios (comisiones, motivos)

### Tests de Integración (50%)
- Flujos de aprobación de tutores (con emails)
- Emisión de reembolsos (integración Stripe)
- Generación de reportes (CSV/Excel/PDF)
- Audit logs escritos en BD

### Tests E2E (20%)
- **Playwright/Cypress:** Login como admin → Aprobar tutor → Verificar email enviado
- Dashboard carga métricas correctas
- Exportar reporte → Descargar archivo válido

### Tests de Seguridad
- **RBAC:** Usuarios no-admin no pueden acceder a `/admin/*`
- **SQL Injection:** Parámetros de búsqueda sanitizados
- **CSRF:** Tokens en formularios críticos
- **Rate Limiting:** Max 100 req/min por admin

---

## ⚠️ Riesgos y Mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| Backlog de tutores pendientes (>50) | Media | Alto | Alerting a Super Admin, contratar más moderadores |
| Admin malintencionado suspende usuarios | Baja | Crítico | Audit logs, revisión mensual de acciones sospechosas |
| Dashboard lento con muchos datos | Media | Medio | Paginación, cache de métricas (Redis), índices BD |
| Reembolsos fraudulentos | Baja | Alto | Aprobación doble para reembolsos >$200K, audit log |

---

## 📈 Roadmap del Módulo

### Release 1.0 MVP (MUST HAVE) - 5 HUs, 26 SP
- ✅ HU-060: Aprobar/rechazar tutores
- ✅ HU-061: Dashboard métricas
- ✅ HU-062: Gestionar usuarios
- ✅ HU-065: Configurar comisiones
- ✅ HU-066: Reportes financieros
- ✅ HU-067: Audit logs

### Release 1.1 (SHOULD HAVE) - 3 HUs, 18 SP
- ✅ HU-063: Moderar reseñas
- ✅ HU-064: Resolver disputas
- ✅ HU-068: Gestionar contenido (CMS)

### Release 1.2 (COULD HAVE)
- HU-069: Análisis de cohortes (retención)
- HU-070: A/B testing de features
- HU-071: Dashboard de fraude (ML)
- HU-072: Gestión de cupones/descuentos

### Futuro (WON'T HAVE Release 1.x)
- Multi-idioma del admin panel
- Mobile app para admins (iOS/Android)
- BI integrado (Tableau/Metabase)

---

## 📊 KPIs Monitoreados en Dashboard

### Usuarios
- Total usuarios registrados (trend últimos 30 días)
- Nuevos registros hoy/semana/mes
- Ratio estudiantes:tutores (ideal 10:1)
- Usuarios activos (con sesión en últimos 30 días)

### Sesiones
- Sesiones completadas hoy/mes
- Tasa de completitud (completadas / reservadas)
- Duración promedio de sesiones
- Horarios peak (heatmap)

### Financiero
- Revenue del mes (bruto)
- Comisiones ganadas
- Pagos pendientes a tutores
- Reembolsos emitidos

### Calidad
- NPS promedio (escala 0-100)
- Rating promedio de tutores (1-5 estrellas)
- Tasa de disputas (disputas / sesiones)
- Tiempo promedio de resolución de disputas

---

**Última actualización:** 2025-11-08  
**Autor:** Product Owner Senior - ZNS v2.0  
**Metodología:** INVEST Criteria + Gherkin Format
