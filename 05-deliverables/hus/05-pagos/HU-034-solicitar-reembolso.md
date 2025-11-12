# HU-034: Solicitar reembolso

**Épica:** Pagos | **Rol:** Estudiante | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** estudiante, **quiero** solicitar reembolso si el tutor no cumplió expectativas o hubo problemas técnicos, **para** recuperar mi dinero cuando corresponda.

---

## ✅ Criterios

### **Escenario 1: Reembolso por cancelación >24h (automático)**
```gherkin
Given reserva BK-001 cancelada 48h antes por estudiante
Then sistema procesa reembolso automático:
  - Calcula 100% monto ($15.000)
  - Stripe Refund API crea reembolso
  - Fondos regresan en 5-7 días bancarios
  - Email: "Reembolso procesado. Verás fondos en tu cuenta pronto"
```

### **Escenario 2: Reembolso manual por problema tutor**
```gherkin
Given sesión BK-002 completada pero estudiante insatisfecho
When accede a /sesiones/BK-002
  And hace clic "Solicitar reembolso"
Then muestra formulario:
  - Motivo (dropdown): "Tutor no se presentó", "Calidad insuficiente", "Problema técnico", "Otro"
  - Descripción (textarea 500 chars)
  - Evidencia (opcional): screenshot, archivo
When envía solicitud
Then crea ticket soporte status=PENDIENTE_REVISION
  And retiene fondos tutor (no transferibles hasta resolución)
  And admin revisa en 24-48h
```

### **Escenario 3: Admin aprueba reembolso**
```gherkin
Given ticket reembolso TICKET-001
When admin marca "Aprobar reembolso 100%"
Then sistema:
  - Procesa refund Stripe ($15.000)
  - Deduce del saldo tutor (penalización)
  - Notifica ambas partes decisión
  - Marca sesión como REEMBOLSADA
```

### **Escenario 4: Admin rechaza reembolso**
```gherkin
When admin marca "Rechazar - Sin evidencia suficiente"
Then:
  - Libera fondos a tutor (pago procesado normalmente)
  - Notifica estudiante con justificación
  - Ofrece mediación si estudiante insiste
```

---

## 🔗 Trazabilidad

**RF:** RF-034 | **RNF:** RNF-FIN-005 (política reembolsos transparente)

**Story Points:** 8 SP | **Complejidad:** Alta (flujo manual admin)

---

## 🧩 Dependencias

- **Depende de:** HU-030 (Pago procesado), HU-027 (Sesión completada)

---

## ✔️ DoD

- [ ] Endpoint `POST /api/bookings/{id}/solicitar-reembolso`
- [ ] Endpoint `POST /api/admin/reembolsos/{id}/revisar` (aprobar/rechazar)
- [ ] Tabla `refunds`: booking_id, monto, motivo, status, evidencia_url, reviewed_by
- [ ] Integración Stripe Refunds API (partial/full refunds)
- [ ] Panel admin: cola tickets reembolso priorizados
- [ ] Email templates: reembolso aprobado/rechazado
- [ ] Tests E2E: solicitar→admin aprueba→verificar fondos devueltos

---

**Etiquetas:** `#pagos` `#mvp` `#must-have` `#reembolsos` `#soporte` `#admin-review` `#customer-service`
