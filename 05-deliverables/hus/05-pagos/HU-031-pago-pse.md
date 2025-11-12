# HU-031: Pagar con PSE (Colombia)

**Épica:** Pagos | **Rol:** Estudiante | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** estudiante colombiano, **quiero** pagar con PSE (transferencia bancaria), **para** usar mi método de pago preferido sin tarjeta de crédito.

---

## 💼 Valor

- **Inclusión:** 40% colombianos prefieren PSE vs tarjeta (menos bancarización)
- **Conversión:** Ofrecer PSE aumenta checkout success +25% en Latam

---

## ✅ Criterios

### **Escenario 1: Pago PSE exitoso**
```gherkin
Given reserva BK-002 PENDIENTE ($20.000)
When selecciona "Pagar con PSE"
Then muestra selector banco (Bancolombia, Davivienda, BBVA...)
When selecciona Bancolombia + confirma
Then redirige a portal PSE
  And estudiante autoriza en banca online
  And webhook PSE notifica APPROVED
  And sistema cambia booking → CONFIRMADA
```

### **Escenario 2: Pago PSE pendiente (asíncrono)**
```gherkin
When PSE responde PENDING (banco procesa)
Then muestra "Pago en proceso, recibirás confirmación en 5-10 min"
  And mantiene reserva PENDIENTE_PAGO (timer 30min)
When webhook confirma después de 8 min
Then actualiza a CONFIRMADA + envía email
```

---

## 🔗 Trazabilidad

**RF:** RF-031 (Método pago PSE)  
**RNF:** RNF-SEC-010 (integración PSE certificada)

**Story Points:** 8 SP | **Complejidad:** Alta (integración third-party)

---

## 🧩 Dependencias

- **Depende de:** HU-021 (Reserva), HU-030 (Pagos base)

---

## ✔️ DoD

- [ ] Integración gateway PSE (PayU / ePayco / Wompi)
- [ ] Endpoint `POST /api/payments/pse` con redirect URL
- [ ] Webhook `POST /api/webhooks/pse` validar signature
- [ ] Manejo estados asíncronos: PENDING → APPROVED/REJECTED
- [ ] Tests E2E: flujo PSE mock completo

---

**Etiquetas:** `#pagos` `#mvp` `#must-have` `#pse` `#colombia` `#transferencia-bancaria`
