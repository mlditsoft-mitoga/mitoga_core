# HU-022: Confirmar datos de reserva

**Épica:** Reservas | **Rol:** Estudiante | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** estudiante, **quiero** revisar un resumen detallado de mi reserva antes de pagar, **para** confirmar que todos los datos son correctos.

---

## ✅ Criterios

### **Escenario 1: Pantalla resumen pre-checkout**
```gherkin
Given estudiante seleccionó slot "Lun 13/01 10:00-11:00"
When hace clic "Continuar a pago"
Then redirige a /checkout/BK-001 con resumen:
  | Campo              | Valor                  |
  | Tutor              | Carlos Pérez ⭐4.8     |
  | Materia            | Matemáticas - Cálculo  |
  | Fecha              | Lunes 13/01/2025       |
  | Hora               | 10:00 - 11:00 AM       |
  | Duración           | 1 hora                 |
  | Modalidad          | Videollamada           |
  | Precio             | $15.000                |
  | Comisión plataforma| Incluida               |
  | Total a pagar      | $15.000                |
  
  And muestra políticas:
    - "Cancelación gratis >24h antes"
    - "Reembolso 50% <24h antes"
  And botón "Modificar reserva" (volver a calendario)
  And botón "Pagar ahora" (proceder HU-030)
```

### **Escenario 2: Modificar reserva antes de pagar**
```gherkin
When hace clic "Modificar reserva"
Then vuelve a /tutores/123/reservar
  And mantiene tutor seleccionado
  And permite elegir nuevo slot
```

---

## 🔗 Trazabilidad

**RF:** RF-022 | **RNF:** RNF-USAB-007 (checkout claro reduce abandono)

**Story Points:** 5 SP

---

## 🧩 Dependencias

- **Depende de:** HU-021 (Reservar sesión)
- **Bloquea a:** HU-030 (Procesar pago)

---

## ✔️ DoD

- [ ] Página `/checkout/:booking_id` con resumen detallado
- [ ] Validación reserva aún disponible (no reservada por otro)
- [ ] Timer expiración reserva PENDIENTE (15 min countdown)
- [ ] Botón "Volver" permite editar sin perder datos
- [ ] Tests E2E: flujo reservar→resumen→modificar→pagar

---

**Etiquetas:** `#reservas` `#mvp` `#must-have` `#checkout` `#ux` `#conversion`
