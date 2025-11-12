# HU-021: Reservar sesión de tutoría

**Épica:** Reservas | **Rol:** Estudiante | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** estudiante, **quiero** seleccionar fecha, hora y duración de una sesión con un tutor, **para** confirmar mi reserva antes de pagar.

---

## 💼 Valor

- **Transaccional core:** Sin reservas, no hay ingresos (0% revenue)
- **Conversión:** 80% de estudiantes que llegan aquí, completan pago (funnel crítico)

---

## ✅ Criterios

### **Escenario 1: Reserva exitosa**
```gherkin
Given estudiante "Ana" ve perfil de tutor "Carlos" (Matemáticas, $15.000/h)
When selecciona:
  | Campo       | Valor                  |
  | Fecha       | Lunes 13/01/2025       |
  | Hora inicio | 10:00 AM               |
  | Duración    | 1 hora                 |
  | Modalidad   | Videollamada           |
Then sistema valida disponibilidad en BD
  And crea reserva PENDIENTE (booking_id: BK-20250113-001)
  And redirige a /checkout?booking_id=BK-20250113-001
  And muestra resumen: "Sesión de Matemáticas - $15.000 - Lunes 10:00 AM"
```

### **Escenario 2: Conflicto de disponibilidad**
```gherkin
Given otro estudiante reservó slot 10:00-11:00
When Ana intenta reservar mismo horario
Then sistema detecta conflicto (row lock DB)
  And muestra error "Este horario ya fue reservado. Elige otro"
  And marca slot como ocupado en calendario
```

### **Escenario 3: Reserva múltiples sesiones (paquete)**
```gherkin
When estudiante selecciona "Paquete 5 sesiones (descuento 10%)"
Then calcula: 5 × $15.000 × 0.9 = $67.500
  And crea 5 reservas PENDIENTES vinculadas (booking_pack_id)
```

---

## 🔗 Trazabilidad

**RF:** RF-020 (Reservar sesión)  
**RNF:** RNF-PERF-003 (reserva <2s), RNF-SEC-006 (evitar doble reserva con locks)

**Story Points:** 13 SP (Complejidad alta - transaccional)

---

## 🧩 Dependencias

- **Depende de:** HU-001 (Login estudiante), HU-012 (Ver perfil tutor)
- **Bloquea a:** HU-030 (Procesar pago)

---

## ✔️ DoD

- [ ] Endpoint `POST /api/bookings` con validación disponibilidad (row-level lock)
- [ ] Tabla `bookings` con estados: PENDIENTE, CONFIRMADA, CANCELADA, COMPLETADA
- [ ] Frontend: calendario interactivo con slots disponibles (react-big-calendar)
- [ ] Timer reserva PENDIENTE: expira en 15 min si no se paga
- [ ] Email confirmación con ICS attachment (agregar a calendario)
- [ ] Tests E2E: reserva exitosa + conflicto + expiración

---

**Etiquetas:** `#reservas` `#mvp` `#must-have` `#transaccional` `#revenue`

**Story Points:** 13 SP | **Estimado:** 5 días
