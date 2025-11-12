# HU-036: Ver historial de pagos

**Épica:** Pagos | **Rol:** Estudiante/Tutor | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** estudiante/tutor, **quiero** ver un historial completo de todos mis pagos/cobros con filtros, **para** controlar mis finanzas y descargar comprobantes.

---

## ✅ Criterios

### **Escenario 1: Estudiante ve historial pagos**
```gherkin
Given estudiante "Ana" realizó 12 pagos
When accede a /finanzas/historial-pagos
Then muestra tabla:
  | Fecha      | Concepto         | Tutor   | Método    | Monto    | Estado    | Factura |
  | 05/01 10:15| Sesión Matemáticas| Carlos  | •••• 4242 | $15.000  | EXITOSO   | [PDF]   |
  | 28/12 14:30| Sesión Inglés    | María   | PSE       | $18.000  | EXITOSO   | [PDF]   |
  | 20/12 09:00| Sesión Física    | Luis    | •••• 4242 | $20.000  | REEMBOLSADO| [PDF]  |
  
  And filtros: Fecha (rango), Estado (exitoso/fallido/reembolsado), Método pago
  And estadísticas: "Total pagado 2025: $180.000 | 12 transacciones"
```

### **Escenario 2: Tutor ve historial ingresos**
```gherkin
Given tutor "Carlos" recibió 50 pagos
When accede a /finanzas/ingresos
Then muestra:
  - Total ganado (bruto): $1.200.000
  - Comisión plataforma (20%): -$240.000
  - Neto recibido: $960.000
  - Retirado: $800.000
  - Disponible retiro: $160.000
  - En hold (próximos 7 días): $25.000
  
  And gráfico ingresos mensuales (Chart.js)
  And botón "Exportar Excel" (contabilidad)
```

### **Escenario 3: Filtrar transacciones**
```gherkin
When selecciona filtros:
  - Fecha: 01/12/2024 - 31/12/2024
  - Estado: EXITOSO
Then actualiza tabla mostrando solo diciembre exitosos
  And actualiza estadísticas: "Total diciembre: $45.000 | 3 transacciones"
```

### **Escenario 4: Descargar comprobante transacción**
```gherkin
When hace clic "Descargar PDF" transacción TRX-001
Then genera comprobante con:
  - Logo MI-TOGA
  - Número transacción: TRX-20250105-001
  - Fecha/hora: 05/01/2025 10:15:23
  - Estudiante: Ana Martínez
  - Tutor: Carlos Pérez
  - Método: Visa •••• 4242
  - Monto: $15.000 COP
  - Estado: EXITOSO
  - Gateway ID: ch_3abc123 (Stripe)
```

---

## 🔗 Trazabilidad

**RF:** RF-036 | **RNF:** RNF-FIN-006 (historial transacciones auditable 5 años)

**Story Points:** 3 SP

---

## 🧩 Dependencias

- **Depende de:** HU-030 (Pagos procesados)

---

## ✔️ DoD

- [ ] Endpoint `GET /api/finanzas/historial?desde=2024-01-01&hasta=2025-01-31&estado=EXITOSO`
- [ ] Página `/finanzas/historial-pagos` tabla paginada (20 por página)
- [ ] Filtros: rango fechas, estado, método pago
- [ ] Gráfico ingresos mensuales (Chart.js line chart)
- [ ] Exportar CSV/Excel (button trigger download)
- [ ] Endpoint `GET /api/transacciones/{id}/comprobante` genera PDF
- [ ] Tests E2E: verificar filtros, descargar comprobante, exportar Excel

---

**Etiquetas:** `#pagos` `#mvp` `#must-have` `#historial-pagos` `#finanzas` `#reporting` `#comprobantes`
