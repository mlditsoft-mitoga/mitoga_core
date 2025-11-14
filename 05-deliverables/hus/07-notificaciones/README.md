# Módulo 07: Notificaciones

**Épica:** Comunicación Transaccional y en Tiempo Real  
**Prioridad:** MUST HAVE (MVP parcial) + SHOULD HAVE (Release 1.1 completo)  
**Story Points Totales:** 19 SP  
**Historias de Usuario:** 5 HUs

---

## 📋 Índice de Historias de Usuario

| ID | Título | SP | Estado | Prioridad |
|----|--------|----|----- --|-----------|
| [HU-050](HU-050-email-confirmacion-reserva.md) | Email de Confirmación de Reserva | 3 | ✅ | MUST HAVE |
| [HU-051](HU-051-recordatorios-sesion.md) | Recordatorios de Sesión (24h y 1h) | 5 | ✅ | MUST HAVE |
| [HU-052](HU-052-push-notifications.md) | Push Notifications en Navegador | 5 | ✅ | SHOULD HAVE |
| [HU-053](HU-053-configurar-preferencias.md) | Configurar Preferencias de Notificaciones | 3 | ✅ | SHOULD HAVE |
| [HU-054](HU-054-notificacion-calificacion.md) | Notificación Sesión Completada (Calificar) | 3 | ✅ | SHOULD HAVE |

**Total:** 5 HUs | 19 SP

---

## 🎯 Objetivos del Módulo

Mantener a los usuarios **informados y engaged** mediante comunicaciones oportunas y relevantes.

**Valor de Negocio:**
- **Reducción de no-shows:** Recordatorios reducen ausencias de 15% a 5% (benchmark Calendly)
- **Aumento de reseñas:** Notificación post-sesión aumenta tasa de calificación de 5% a 35%
- **Engagement:** Push notifications mantienen usuarios activos (+25% sesiones repeat)

**KPIs del Módulo:**
- Tasa de entrega de emails: >99.5% (SendGrid SLA)
- Tiempo de entrega: <1 minuto (emails), <3 segundos (push)
- Opt-in de push notifications: >40% de usuarios
- Tasa de click en notificaciones: >15%

---

## 🔗 Dependencias Externas

### Email Transaccional
- **Proveedor recomendado:** SendGrid (plan Essentials: $20/mes, 40K emails)
- **Alternativa:** AWS SES (más barato, setup complejo)
- **Requisitos:** Dominio verificado, SPF/DKIM configurados (evitar spam)

### Push Notifications
- **Proveedor:** Firebase Cloud Messaging (FCM) - Gratuito hasta 10M mensajes/mes
- **Alternativa:** OneSignal (más features, plan gratuito limitado)
- **Requisitos:** Service Worker configurado, HTTPS obligatorio

---

## 📊 Arquitectura de Notificaciones

```
┌─────────────────────────────────────────────────────────┐
│                   Triggers de Eventos                    │
├─────────────────────────────────────────────────────────┤
│ • Reserva creada       → Email confirmación (HU-050)    │
│ • 24h antes sesión     → Email + Push recordatorio       │
│ • 1h antes sesión      → Email + Push recordatorio       │
│ • Sesión completada    → Email solicitud calificación   │
│ • Nuevo mensaje        → Push notification               │
│ • Cambio en reserva    → Email + Push                    │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│              Notification Service (Backend)              │
├─────────────────────────────────────────────────────────┤
│ 1. Verificar preferencias usuario (HU-053)              │
│ 2. Seleccionar canales habilitados                      │
│ 3. Aplicar templating (Handlebars)                      │
│ 4. Enviar por canales:                                  │
│    - Email: SendGrid API                                │
│    - Push: FCM API                                       │
│    - SMS: Twilio API (opcional)                         │
│ 5. Log de entrega (success/failure)                     │
│ 6. Reintentos automáticos (3x con backoff)              │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│                  Entrega a Usuarios                      │
├─────────────────────────────────────────────────────────┤
│ 📧 Email → Inbox (Gmail, Outlook, etc.)                │
│ 🔔 Push → Navegador (Chrome, Firefox, Edge)            │
│ 📱 SMS → Teléfono móvil (opcional)                     │
└─────────────────────────────────────────────────────────┘
```

---

## 🧪 Estrategia de Testing

### Tests Unitarios (30%)
- Template rendering con datos dinámicos
- Lógica de preferencias (verificar canales habilitados)
- Cálculo de timestamps para recordatorios

### Tests de Integración (50%)
- Integración con SendGrid API (sandbox mode)
- Integración con FCM (test tokens)
- Flujo completo: Trigger → Service → API → Entrega
- Reintentos automáticos en caso de fallo

### Tests E2E (20%)
- Reservar sesión → Recibir email confirmación en <1 min
- 24h antes → Recibir recordatorio con datos correctos
- Completar sesión → Recibir solicitud de calificación
- Cambiar preferencias → Verificar que se respetan

---

## ⚠️ Riesgos y Mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| Emails en spam | Media | Alto | Warm up de dominio, SPF/DKIM/DMARC, feedback loops |
| Rate limits SendGrid excedidos | Baja | Medio | Monitoreo de usage, upgrade a plan superior si necesario |
| Usuario no recibe push (permisos denegados) | Alta | Bajo | Fallback a email, UI clara pidiendo permisos |
| Cron job de recordatorios falla | Baja | Alto | Alerting con PagerDuty, job idempotente |

---

## 📈 Roadmap del Módulo

### Release 1.0 MVP (MUST HAVE) - 2 HUs, 8 SP
- ✅ HU-050: Email confirmación reserva
- ✅ HU-051: Recordatorios 24h/1h

### Release 1.1 (SHOULD HAVE) - 3 HUs, 11 SP
- ✅ HU-052: Push notifications
- ✅ HU-053: Configurar preferencias
- ✅ HU-054: Solicitud de calificación

### Release 1.2 (COULD HAVE)
- HU-055: Notificaciones de chat (mensajes nuevos)
- HU-056: Resumen semanal por email (digest)
- HU-057: SMS para recordatorios críticos (Twilio)

### Futuro (WON'T HAVE Release 1.x)
- Notificaciones WhatsApp (WhatsApp Business API)
- Notificaciones móviles nativas (iOS/Android apps)
- Personalización con IA (mejor horario de envío)

---

## 📧 Templates de Email

**Ubicación:** `src/templates/emails/`

| Template | Archivo | Variables |
|----------|---------|-----------|
| Confirmación de reserva | `booking-confirmation.hbs` | `{{studentName}}`, `{{tutorName}}`, `{{sessionDate}}`, `{{sessionTime}}` |
| Recordatorio 24h | `reminder-24h.hbs` | `{{sessionDate}}`, `{{tutorName}}`, `{{joinLink}}` |
| Recordatorio 1h | `reminder-1h.hbs` | `{{sessionTime}}`, `{{joinLink}}` |
| Solicitud calificación | `rating-request.hbs` | `{{tutorName}}`, `{{ratingLink}}` |

**Estándar de diseño:** Responsive (mobile-first), branding MI-TOGA, botones CTA claros, footer con unsubscribe

---

**Última actualización:** 2025-11-08  
**Autor:** Product Owner Senior - ZNS v2.0  
**Metodología:** INVEST Criteria + Gherkin Format
