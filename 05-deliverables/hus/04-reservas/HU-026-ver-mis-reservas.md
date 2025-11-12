# HU-026: Ver mis reservas

**Épica:** Reservas | **Rol:** Estudiante/Tutor | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** estudiante/tutor, **quiero** ver una lista de todas mis reservas (próximas, pasadas, canceladas), **para** gestionar mi agenda y revisar historial.

---

## ✅ Criterios

### **Escenario 1: Estudiante ve sus reservas**
```gherkin
Given estudiante "Ana" tiene:
  | Reserva | Estado      | Fecha      | Tutor   |
  | BK-001  | CONFIRMADA  | 13/01 10:00| Carlos  |
  | BK-002  | PENDIENTE   | 15/01 14:00| María   |
  | BK-003  | COMPLETADA  | 05/01 09:00| Luis    |
  | BK-004  | CANCELADA   | 20/12 11:00| Pedro   |

When accede a /mis-reservas
Then muestra tabs:
  - "Próximas (2)" → BK-001, BK-002
  - "Pasadas (1)" → BK-003
  - "Canceladas (1)" → BK-004
```

### **Escenario 2: Filtrar por estado**
```gherkin
When selecciona tab "Próximas"
Then muestra solo CONFIRMADAS + PENDIENTES ordenadas por fecha ASC
  And cada card incluye:
    - Avatar tutor + nombre
    - Materia
    - Fecha/hora countdown "En 2 días"
    - Botones: "Unirse" (si -15min), "Reprogramar", "Cancelar", "Detalles"
```

### **Escenario 3: Acciones rápidas desde listado**
```gherkin
Given reserva BK-001 inicia en 10 minutos
When hace clic "Unirse ahora"
Then redirige a /sesion/BK-001/videollamada (HU-040)
```

---

## 🔗 Trazabilidad

**RF:** RF-026 | **RNF:** RNF-USAB-009 (acceso rápido <2 clics)

**Story Points:** 5 SP

---

## 🧩 Dependencias

- **Depende de:** HU-021 (Reservas creadas)

---

## ✔️ DoD

- [ ] Endpoint `GET /api/mis-reservas?status=proximas|pasadas|canceladas`
- [ ] Página `/mis-reservas` con tabs filtros
- [ ] BookingCard component reutilizable
- [ ] Botones condicionales según estado (ej: "Unirse" solo si -15min)
- [ ] Countdown timer en tiempo real (actualiza cada min)
- [ ] Paginación infinita (12 por página)
- [ ] Tests E2E: verificar filtros, acciones botones

---

**Etiquetas:** `#reservas` `#mvp` `#must-have` `#dashboard` `#listado` `#gestion-agenda`
