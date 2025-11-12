# HU-030: Procesar pago con tarjeta

**Épica:** Pagos | **Rol:** Estudiante | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** estudiante, **quiero** pagar la sesión reservada con tarjeta de crédito/débito, **para** confirmar mi reserva y acceder a la videollamada.

---

## 💼 Valor

- **Revenue enabler:** Sin pagos, 0% ingresos (bloqueante crítico MVP)
- **Seguridad:** PCI-DSS compliance delegado a Stripe/PayU (reducción riesgo)
- **Conversión:** Pasarelas conocidas aumentan trust ~35%

---

## ✅ Criterios

### **Escenario 1: Pago exitoso**
```gherkin
Given reserva BK-001 PENDIENTE ($15.000)
When estudiante ingresa datos tarjeta:
  | Campo       | Valor              |
  | Número      | 4242424242424242   |
  | Expiración  | 12/26              |
  | CVV         | 123                |
  | Nombre      | ANA LOPEZ          |
Then sistema:
  - Tokeniza tarjeta con Stripe API
  - Crea payment_intent ($15.000)
  - Procesa cargo (webhook SUCCEEDED)
  - Cambia booking status → CONFIRMADA
  - Calcula comisión plataforma (20%): $3.000
  - Asigna saldo tutor: $12.000
  - Envía email confirmación + recibo
  - Redirige a /booking-success?id=BK-001
```

### **Escenario 2: Pago rechazado**
```gherkin
When tarjeta es rechazada (fondos insuficientes)
Then webhook FAILED
  And muestra error "Pago rechazado. Verifica fondos o prueba otra tarjeta"
  And mantiene reserva PENDIENTE (3 intentos más antes de expirar)
```

### **Escenario 3: Guardar método de pago**
```gherkin
When estudiante marca checkbox "Guardar tarjeta para futuros pagos"
Then tokeniza y almacena payment_method_id (Stripe)
  And encripta últimos 4 dígitos: •••• 4242
  And próxima reserva ofrece "Pagar con •••• 4242"
```

---

## 🔗 Trazabilidad

**RF:** RF-030 (Procesar pagos)  
**RNF:** RNF-SEC-007 (PCI-DSS compliance), RNF-PERF-004 (pago <5s)

**Story Points:** 13 SP (Complejidad alta - integraciones críticas)

---

## 🧩 Dependencias

- **Depende de:** HU-021 (Reserva creada)
- **Bloquea a:** HU-025 (Recordatorios), HU-027 (Sesión completada)

---

## ✔️ DoD

- [ ] Integración Stripe Payment Intents API (webhook events)
- [ ] Endpoint `POST /api/payments/process` con idempotency key
- [ ] Tabla `payments` con estados: PENDING, SUCCEEDED, FAILED, REFUNDED
- [ ] Frontend: Stripe Elements (tarjeta tokenizada, no almacenar datos raw)
- [ ] Webhook `/api/webhooks/stripe` con signature validation
- [ ] Comisión automática 20% calculada en transaction
- [ ] Email recibo con detalles fiscales (DIAN compliance Colombia)
- [ ] Tests E2E: pago exitoso + rechazado + webhook mock

---

**Etiquetas:** `#pagos` `#mvp` `#must-have` `#stripe` `#revenue` `#pci-dss`

**Story Points:** 13 SP | **Estimado:** 5-6 días
