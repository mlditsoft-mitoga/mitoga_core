# HU-073: Ver historial de sesiones

**Épica:** Perfiles | **Rol:** Estudiante/Tutor | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** estudiante/tutor, **quiero** ver un historial completo de todas mis sesiones pasadas con detalles, **para** revisar aprendizaje/ingresos y descargar comprobantes.

---

## ✅ Criterios

### **Escenario 1: Estudiante ve historial sesiones**
```gherkin
Given estudiante "Ana" completó 15 sesiones
When accede a /perfil/historial
Then muestra tabla:
  | Fecha      | Tutor   | Materia      | Duración | Calificación | Monto   | Recibo |
  | 05/01 9:00 | Carlos  | Matemáticas  | 1h       | ⭐⭐⭐⭐⭐        | $15.000 | [PDF]  |
  | 28/12 14:00| María   | Inglés       | 1h       | ⭐⭐⭐⭐         | $18.000 | [PDF]  |
  
  And filtros: Por materia, Por tutor, Rango fechas
  And estadísticas: "15 sesiones completadas | $270.000 invertido"
```

### **Escenario 2: Tutor ve historial ingresos**
```gherkin
Given tutor "Carlos" completó 50 sesiones
When accede a /finanzas/historial
Then muestra dashboard:
  - Gráfico ingresos mensuales (últimos 6 meses)
  - Total ganado: $1.200.000 (bruto) | $960.000 (neto después comisión)
  - Sesiones por materia: Matemáticas (35), Física (15)
  - Rating promedio: ⭐4.8 (basado en 42 reseñas)
  - Exportar CSV/Excel para contabilidad
```

### **Escenario 3: Descargar comprobante sesión**
```gherkin
When hace clic "Descargar recibo" sesión BK-001
Then genera PDF con:
  - Logo MI-TOGA + datos fiscales plataforma
  - Fecha sesión: 05/01/2025 9:00-10:00
  - Tutor: Carlos Pérez
  - Estudiante: Ana Martínez
  - Monto pagado: $15.000 COP
  - Método pago: •••• 4242
  - Número transacción: TRX-20250105-001
```

---

## 🔗 Trazabilidad

**RF:** RF-073 | **RNF:** RNF-FIN-004 (comprobantes almacenados 5 años compliance)

**Story Points:** 3 SP

---

## 🧩 Dependencias

- **Depende de:** HU-027 (Sesiones completadas)

---

## ✔️ DoD

- [ ] Endpoint `GET /api/perfil/historial-sesiones?desde=2024-01-01&hasta=2025-01-31`
- [ ] Página `/perfil/historial` con tabla paginada + filtros
- [ ] Gráficos Chart.js/Recharts (ingresos mensuales tutor)
- [ ] Endpoint `GET /api/bookings/{id}/recibo` genera PDF (puppeteer/pdfkit)
- [ ] Exportar CSV con datos sesiones (botón "Exportar")
- [ ] Tests E2E: verificar historial, descargar PDF, filtros funcionan

---

**Etiquetas:** `#perfiles` `#mvp` `#must-have` `#historial` `#comprobantes` `#finanzas` `#reporting`
