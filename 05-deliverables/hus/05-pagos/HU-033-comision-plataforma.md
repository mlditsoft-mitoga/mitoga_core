# HU-033: Calcular comisión plataforma

**Épica:** Pagos | **Rol:** Sistema | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** plataforma, **quiero** calcular y retener automáticamente 20% de comisión en cada transacción, **para** monetizar el servicio y distribuir fondos correctamente.

---

## 💼 Valor

- **Revenue model:** Comisión es única fuente ingresos plataforma
- **Transparencia:** Cálculo automático evita errores manuales

---

## ✅ Criterios

### **Escenario 1: Comisión 20% aplicada**
```gherkin
Given sesión reservada: $25.000
When pago procesado exitosamente
Then sistema calcula:
  - Monto bruto: $25.000
  - Comisión plataforma (20%): $5.000
  - Saldo tutor (80%): $20.000
  - Gateway fee Stripe (2.9% + $900): ~$1.600
  - Neto plataforma: $5.000 - $800 = $4.200
```

### **Escenario 2: Comisión en reembolsos**
```gherkin
When estudiante cancela >24h (reembolso 100%)
Then sistema:
  - Reembolsa $25.000 a estudiante
  - Plataforma absorbe $5.000 comisión perdida
  - Tutor NO pierde comisión (no recibió fondos aún)
```

### **Escenario 3: Comisión variable por volumen (Fase 2)**
```gherkin
Given tutor "Carlos" completa 50 sesiones/mes
Then aplica comisión escalonada:
  | Sesiones/mes | Comisión |
  | 1-20         | 20%      |
  | 21-50        | 18%      |
  | 51+          | 15%      |
```

---

## 🔗 Trazabilidad

**RF:** RF-033 (Comisiones automáticas)  
**RNF:** RNF-FIN-001 (cálculos auditados)

**Story Points:** 5 SP | **Complejidad:** Media

---

## 🧩 Dependencias

- **Depende de:** HU-030 (Procesar pago)
- **Relacionada con:** HU-037 (Transferir fondos tutor)

---

## ✔️ DoD

- [ ] Tabla `transactions`: monto_bruto, comision_plataforma, gateway_fee, saldo_tutor
- [ ] Lógica cálculo comisión configurable (env var COMMISSION_RATE=0.20)
- [ ] Dashboard admin: reporte comisiones diarias/mensuales
- [ ] Tests unitarios: cálculo comisión, reembolsos, edge cases

---

**Etiquetas:** `#pagos` `#mvp` `#must-have` `#comisiones` `#revenue` `#finanzas`
