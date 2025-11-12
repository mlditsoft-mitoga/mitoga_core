# HU-027: Marcar sesión como completada

**Épica:** Reservas | **Rol:** Tutor | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** tutor, **quiero** marcar una sesión como completada después de finalizar, **para** confirmar que se realizó y liberar pago a mi saldo.

---

## ✅ Criterios

### **Escenario 1: Tutor marca sesión completada**
```gherkin
Given sesión BK-001 programada "10:00-11:00"
  And hora actual: 11:05 (pasó fin programado)
When tutor accede a /mis-sesiones
  And hace clic "Marcar como completada"
Then sistema:
  - Cambia booking status → COMPLETADA
  - Libera fondos hold (disponibles para retiro en 7 días)
  - Solicita estudiante calificar (email + notificación)
  - Incrementa contador sesiones_completadas tutor
  - Muestra "Sesión completada. Fondos disponibles 20/01"
```

### **Escenario 2: Confirmación dual (ambos marcan completada)**
```gherkin
Given tutor marcó completada
When estudiante también marca "Confirmar sesión recibida"
Then valida ambas confirmaciones
  And acelera liberación fondos (de 7 días → 24h)
```

### **Escenario 3: Estudiante disputa sesión**
```gherkin
When estudiante marca "Sesión NO realizada"
Then crea ticket soporte status=EN_REVISION
  And retiene fondos hasta resolución admin
  And notifica admin con evidencias (logs videollamada, duración)
```

---

## 🔗 Trazabilidad

**RF:** RF-027 | **RNF:** RNF-FIN-003 (fondos hold protege plataforma fraude)

**Story Points:** 5 SP

---

## 🧩 Dependencias

- **Depende de:** HU-021 (Reserva), HU-030 (Pago procesado)
- **Bloquea a:** HU-015 (Calificar tutor), HU-037 (Retiros tutor)

---

## ✔️ DoD

- [ ] Endpoint `PATCH /api/bookings/{id}/completar`
- [ ] Validación: solo marcar si hora_fin < NOW
- [ ] Lógica hold fondos (tabla `tutor_balance` con available_at)
- [ ] Email estudiante: "Califica tu sesión con Carlos"
- [ ] Sistema disputas básico (tabla `session_disputes`)
- [ ] Tests E2E: completar→fondos en hold→verificar saldo tutor

---

**Etiquetas:** `#reservas` `#mvp` `#must-have` `#completar-sesion` `#finanzas` `#release-fondos`
