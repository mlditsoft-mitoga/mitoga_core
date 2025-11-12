# HU-032: Guardar método de pago

**Épica:** Pagos | **Rol:** Estudiante | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** estudiante frecuente, **quiero** guardar mi tarjeta de forma segura, **para** pagar más rápido en futuras reservas sin reingresar datos.

---

## ✅ Criterios

### **Escenario 1: Guardar tarjeta durante primer pago**
```gherkin
Given estudiante "Ana" paga primera reserva
When completa datos tarjeta en checkout
  And marca checkbox "Guardar tarjeta para futuros pagos"
Then Stripe tokeniza tarjeta (payment_method_id)
  And guarda en BD:
    - last4: "4242"
    - brand: "Visa"
    - exp_month: 12
    - exp_year: 2026
    - is_default: true
  And NO almacena número completo ni CVV (PCI-DSS compliance)
```

### **Escenario 2: Pagar con tarjeta guardada**
```gherkin
Given Ana tiene tarjeta guardada •••• 4242
When reserva nueva sesión
Then checkout muestra:
  "Pagar con •••• 4242 (Visa)" [Seleccionado]
  "Usar otra tarjeta" [Link]
When hace clic "Confirmar pago"
Then procesa sin solicitar datos tarjeta nuevamente
  And solo solicita CVV por seguridad (opcional configurar)
```

### **Escenario 3: Múltiples tarjetas guardadas**
```gherkin
Given Ana guardó 2 tarjetas:
  - •••• 4242 (Visa) - Default
  - •••• 1111 (Mastercard)
When accede a /configuracion/metodos-pago
Then muestra listado:
  [✓] •••• 4242 Visa - Expira 12/2026 [Principal] [Eliminar]
  [ ] •••• 1111 Mastercard - Expira 06/2027 [Usar como principal] [Eliminar]
When hace clic "Usar como principal" en Mastercard
Then actualiza is_default en BD
```

### **Escenario 4: Eliminar tarjeta guardada**
```gherkin
When hace clic "Eliminar" en tarjeta •••• 1111
Then muestra confirmación "¿Eliminar Mastercard •••• 1111?"
When confirma
Then elimina payment_method de Stripe + BD
  And si era única tarjeta, próximo pago solicita datos completos
```

---

## 🔗 Trazabilidad

**RF:** RF-032 | **RNF:** RNF-SEC-012 (tokenización PCI-DSS, no almacenar datos sensibles)

**Story Points:** 5 SP

---

## 🧩 Dependencias

- **Depende de:** HU-030 (Procesar pago base)

---

## ✔️ DoD

- [ ] Tabla `payment_methods`: user_id, stripe_payment_method_id, last4, brand, exp_month, exp_year, is_default
- [ ] Endpoint `POST /api/payment-methods` guarda método
- [ ] Endpoint `DELETE /api/payment-methods/{id}` elimina
- [ ] Stripe Elements con opción "Save card" checkbox
- [ ] Página `/configuracion/metodos-pago` gestión tarjetas
- [ ] Validación expiración tarjeta (alertar si expira <30 días)
- [ ] Tests E2E: guardar tarjeta→pagar con guardada→eliminar

---

**Etiquetas:** `#pagos` `#mvp` `#must-have` `#metodos-pago` `#stripe` `#pci-dss` `#tokenizacion` `#ux-checkout`
