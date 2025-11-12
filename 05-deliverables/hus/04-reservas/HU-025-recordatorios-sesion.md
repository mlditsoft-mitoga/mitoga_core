# HU-025: Recibir recordatorios de sesión

**Épica:** Reservas | **Rol:** Estudiante / Tutor | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** estudiante/tutor, **quiero** recibir recordatorios automáticos 24h y 1h antes de mi sesión, **para** no olvidar la clase y prepararme a tiempo.

---

## 💼 Valor

- **Reducción no-shows:** Recordatorios reducen ausencias ~70% (benchmark Calendly)
- **Engagement:** Emails/notificaciones mantienen plataforma top-of-mind
- **Preparación:** Recordatorio 1h permite preparar materiales

---

## ✅ Criterios

### **Escenario 1: Recordatorio 24h antes (email + push)**
```gherkin
Given reserva BK-001 confirmada para "Martes 12/01 15:00"
When faltan exactamente 24 horas (Lunes 12/01 15:00)
Then sistema ejecuta cronjob cada 15 minutos:
  - Busca reservas con fecha_hora entre NOW+23:45 y NOW+24:15
  - Envía email a estudiante:
    Subject: "🔔 Tu sesión de Matemáticas es mañana a las 15:00"
    Body: Tutor Carlos | Materia Matemáticas | Botón "Unirse" | "Cancelar gratis"
  - Envía email a tutor similar
  - Si push notifications habilitadas → envía notificación móvil
  - Registra en tabla `notifications` (sent_at, type=REMINDER_24H)
```

### **Escenario 2: Recordatorio 1h antes**
```gherkin
When faltan 60 minutos (Martes 12/01 14:00)
Then envía recordatorio urgente:
  - Email subject: "⏰ Tu sesión empieza en 1 hora"
  - Push notification con sonido (alta prioridad)
  - SMS opcional si configurado (Twilio)
  - Botón "Unirse ahora" activo (genera link videollamada)
```

### **Escenario 3: Usuario deshabilitó notificaciones**
```gherkin
Given estudiante "Ana" desactivó emails recordatorios en /configuracion
When sistema intenta enviar recordatorio 24h
Then:
  - NO envía email (respeta preferencia)
  - SÍ envía notificación in-app (dentro plataforma, no intrusiva)
  - Muestra badge rojo en icono campana (contador "1 recordatorio")
```

### **Escenario 4: Recordatorio incluye link videollamada**
```gherkin
Given recordatorio 1h antes
When estudiante hace clic "Unirse ahora"
Then:
  - Redirige a /sesion/BK-001/videollamada
  - Genera room Jitsi/Zoom: mitoga-BK-001-12012026
  - Si falta >15min, muestra sala espera: "La sesión inicia en X minutos"
  - Si falta <15min, permite acceso inmediato
```

### **Escenario 5: Sesión cancelada después de enviar recordatorio**
```gherkin
Given recordatorio 24h fue enviado (Lunes 15:00)
When tutor cancela sesión (Lunes 18:00)
Then sistema:
  - Envía email cancelación (sobrescribe recordatorio)
  - Si usuario abre email recordatorio antiguo, muestra banner "Esta sesión fue cancelada"
```

---

## 🔗 Trazabilidad

**RF:** RF-025 (Recordatorios automáticos)  
**RNF:** RNF-NOTIF-001 (99% delivery rate emails), RNF-PERF-006 (cronjob <5min procesamiento)

**Story Points:** 3 SP | **Complejidad:** Media (integración email + push)

---

## 🧩 Dependencias

- **Depende de:** HU-021 (Reserva confirmada)
- **Relacionada con:** HU-040 (Videollamada - link en recordatorio)

---

## ✔️ DoD

- [ ] Cronjob cada 15 minutos busca reservas próximas (24h y 1h)
- [ ] Endpoint `POST /api/notifications/send-reminder` (idempotente)
- [ ] Tabla `notifications`: booking_id, user_id, type, sent_at, opened_at
- [ ] Email templates: reminder_24h.html, reminder_1h.html (responsive)
- [ ] Integración SendGrid/AWS SES con tracking (open rate, click rate)
- [ ] Push notifications con Firebase Cloud Messaging (FCM)
- [ ] Link videollamada dinámico generado en recordatorio 1h
- [ ] Preferencias usuario en /configuracion (toggle recordatorios)
- [ ] Tests unitarios: lógica cronjob, cálculo tiempo restante
- [ ] Test E2E: reserva→esperar 24h mock→verificar email recibido

---

**Etiquetas:** `#reservas` `#mvp` `#must-have` `#recordatorios` `#notificaciones` `#email` `#push` `#engagement` `#no-show-reduction`

---

## 📊 Métricas Esperadas

- **Open rate emails:** >60% (industry benchmark 20-30%)
- **Click rate "Unirse ahora":** >40%
- **Reducción no-shows:** 70% (de 20% → 6%)

---

## ⚠️ Supuestos

- Cronjob ejecuta cada 15 min (tolerancia ±15 min aceptable)
- SMS opcional (costo adicional Twilio, solo usuarios premium Fase 2)
- Push notifications requieren app móvil (PWA suficiente MVP)
