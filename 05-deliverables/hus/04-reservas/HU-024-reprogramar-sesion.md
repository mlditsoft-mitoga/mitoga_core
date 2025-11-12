# HU-024: Reprogramar sesión

**Épica:** Reservas | **Rol:** Estudiante/Tutor | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** estudiante/tutor, **quiero** proponer una nueva fecha/hora para sesión reservada, **para** ajustar sin cancelar si surgen imprevistos.

---

## ✅ Criterios

### **Escenario 1: Estudiante propone reprogramación**
```gherkin
Given reserva BK-001 confirmada "Lun 13/01 10:00"
When estudiante accede a /mis-reservas
  And hace clic "Reprogramar"
Then muestra calendario tutor con slots disponibles
When selecciona nuevo slot "Mar 14/01 15:00"
Then crea solicitud status=PENDIENTE_APROBACION_TUTOR
  And envía notificación tutor: "Ana quiere reprogramar sesión"
  And mantiene reserva original válida hasta respuesta
```

### **Escenario 2: Tutor aprueba reprogramación**
```gherkin
When tutor aprueba desde /mis-reservas
Then sistema:
  - Actualiza booking fecha_hora → "Mar 14/01 15:00"
  - Libera slot original "Lun 13/01 10:00"
  - Envía confirmación a ambos
  - NO cobra nueva transacción (pago ya procesado)
```

### **Escenario 3: Tutor rechaza reprogramación**
```gherkin
When tutor rechaza con motivo "Ese horario no me conviene"
Then notifica estudiante
  And permite proponer nuevo slot (máx 3 intentos)
  And si 3 rechazos, ofrece cancelar con reembolso 100%
```

---

## 🔗 Trazabilidad

**RF:** RF-024 | **RNF:** RNF-USAB-008 (flexibilidad aumenta satisfacción)

**Story Points:** 8 SP | **Complejidad:** Alta (flujo aprobación)

---

## 🧩 Dependencias

- **Depende de:** HU-021 (Reserva), HU-020 (Calendario)

---

## ✔️ DoD

- [ ] Endpoint `POST /api/bookings/{id}/reprogramar` con nuevo slot
- [ ] Endpoint `PATCH /api/bookings/{id}/reprogramacion/aprobar`
- [ ] Tabla `reschedule_requests`: booking_id, propuesto_por, nuevo_slot, status
- [ ] UI: modal reprogramación con calendario disponibilidad
- [ ] Límite 3 intentos reprogramación por reserva
- [ ] Notificaciones email ambas partes
- [ ] Tests E2E: proponer→aprobar→verificar fecha actualizada

---

**Etiquetas:** `#reservas` `#mvp` `#must-have` `#reprogramacion` `#flexibilidad` `#workflow-aprobacion`
