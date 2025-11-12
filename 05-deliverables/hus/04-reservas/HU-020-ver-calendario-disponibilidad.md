# HU-020: Ver calendario de disponibilidad tutor

**Épica:** Reservas | **Rol:** Estudiante | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** estudiante, **quiero** ver el calendario de disponibilidad del tutor en tiempo real, **para** seleccionar fecha y hora conveniente antes de reservar.

---

## ✅ Criterios

### **Escenario 1: Ver calendario en perfil tutor**
```gherkin
Given tutor "Carlos" configuró disponibilidad Lun-Vie 9-18h
When estudiante ve perfil /tutores/123
Then muestra calendario próximos 14 días:
  - Slots disponibles (verde): "Lun 10:00-11:00 disponible"
  - Slots ocupados (gris): "Lun 14:00-15:00 reservado"
  - Días bloqueados (rojo): "Sáb-Dom no disponible"
When hace hover en slot verde
Then muestra tooltip "Matemáticas - $15.000/hora - Disponible"
```

### **Escenario 2: Actualización en tiempo real**
```gherkin
Given estudiante A y B ven mismo calendario simultáneamente
When A reserva slot "Lun 10:00"
Then calendario B se actualiza automático (WebSocket)
  And slot cambia a ocupado sin refresh
```

---

## 🔗 Trazabilidad

**RF:** RF-020 | **RNF:** RNF-PERF-007 (actualización tiempo real <2s)

**Story Points:** 5 SP

---

## 🧩 Dependencias

- **Depende de:** HU-072 (Configurar disponibilidad)
- **Bloquea a:** HU-021 (Reservar sesión)

---

## ✔️ DoD

- [ ] Endpoint `GET /api/tutores/{id}/disponibilidad?inicio=2025-01-10&fin=2025-01-24`
- [ ] Calendario component (FullCalendar/react-big-calendar)
- [ ] WebSocket eventos: `booking.created` actualiza UI
- [ ] Cache Redis slots disponibles (invalidar al reservar)
- [ ] Tests E2E: ver calendario→reservar→verificar actualización

---

**Etiquetas:** `#reservas` `#mvp` `#must-have` `#calendario` `#tiempo-real` `#websocket`
