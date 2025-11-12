# HU-037: Transferir fondos a tutor

**Épica:** Pagos | **Rol:** Tutor | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** tutor, **quiero** retirar mis ganancias acumuladas a mi cuenta bancaria, **para** recibir pago por mis sesiones completadas.

---

## 💼 Valor

- **Trust:** Retiros rápidos (<48h) aumentan satisfacción tutores ~70%
- **Retention:** Pago puntual reduce churn tutores (crítico lado oferta)

---

## ✅ Criterios

### **Escenario 1: Solicitar retiro exitoso**
```gherkin
Given tutor "Carlos" tiene saldo disponible: $350.000
  And tiene cuenta bancaria verificada (Bancolombia)
When accede a /finanzas/retirar
  And ingresa monto: $300.000
  And hace clic "Solicitar retiro"
Then sistema valida:
  - Monto <= saldo disponible ✅
  - Monto >= mínimo ($50.000) ✅
  - Cuenta bancaria verificada ✅
Then crea retiro status=PENDIENTE
  And envía a cola procesamiento (batch nocturno)
  And muestra "Retiro procesado en 24-48h"
```

### **Escenario 2: Transferencia bancaria ejecutada**
```gherkin
Given retiro WD-001 PENDIENTE ($300.000)
When cronjob nocturno (2 AM) procesa batch
Then sistema:
  - Ejecuta ACH transfer via Stripe Payouts API
  - Cambia status → COMPLETADO
  - Actualiza saldo tutor: $350.000 - $300.000 = $50.000
  - Envía comprobante email: "Transferencia exitosa"
```

### **Escenario 3: Retiro mínimo no alcanzado**
```gherkin
Given tutor tiene saldo: $30.000
When intenta retirar $30.000
Then muestra error "Monto mínimo retiro: $50.000"
  And sugiere "Completa más sesiones para alcanzar mínimo"
```

### **Escenario 4: Fondos en hold (sesiones recientes)**
```gherkin
Given tutor completó sesión hace 2 días ($25.000)
When accede a /finanzas
Then muestra:
  - Saldo disponible: $200.000
  - En hold (próximos 5 días): $25.000
  - Total ganado: $225.000
  
Tooltip: "Fondos disponibles 7 días después de sesión completada (política anti-fraude)"
```

---

## 🔗 Trazabilidad

**RF:** RF-037 (Retiros tutores)  
**RNF:** RNF-FIN-002 (retiros procesados <48h)

**Story Points:** 8 SP | **Complejidad:** Alta (integración bancaria)

---

## 🧩 Dependencias

- **Depende de:** HU-030 (Pagos), HU-033 (Comisiones), HU-027 (Sesión completada)

---

## ✔️ DoD

- [ ] Endpoint `POST /api/tutores/{id}/retiros` validaciones
- [ ] Endpoint `PATCH /api/admin/retiros/{id}/procesar` (batch manual)
- [ ] Tabla `withdrawals`: tutor_id, monto, status, cuenta_bancaria, processed_at
- [ ] Integración Stripe Payouts / ACH transfers
- [ ] Cronjob batch nocturno retiros pendientes
- [ ] Política hold 7 días fondos (configurable)
- [ ] Dashboard tutor: historial retiros, saldo disponible/en hold
- [ ] Comprobante PDF generado (metadata transacción)
- [ ] Tests E2E: solicitar retiro→aprobar→verificar transferencia

---

**Etiquetas:** `#pagos` `#mvp` `#must-have` `#retiros` `#tutores` `#payouts` `#finanzas`

---

## ⚠️ Supuestos

- Hold 7 días reduce riesgo chargebacks/reembolsos post-sesión
- Mínimo $50.000 reduce costos transaccionales (fee fijo Stripe)
