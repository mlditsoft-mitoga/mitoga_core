# HU-023: Cancelar reserva

**Épica:** Reservas | **Rol:** Estudiante / Tutor | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** estudiante o tutor, **quiero** cancelar una sesión reservada aplicando políticas de cancelación, **para** liberar el horario si surgen imprevistos.

---

## 💼 Valor

- **Flexibilidad:** Política justa aumenta confianza plataforma ~40%
- **Revenue protection:** Cancelaciones <24h penalizadas (reduce cancelaciones frívolas 60%)
- **UX:** Proceso claro reduce conflictos tutor-estudiante

---

## ✅ Criterios

### **Escenario 1: Cancelación gratuita (>24h antes)**
```gherkin
Given reserva BK-001 confirmada para "Lunes 10/01 10:00 AM"
  And fecha actual: "Viernes 08/01 14:00"
  And tiempo restante: 44 horas (>24h)
When estudiante hace clic "Cancelar reserva"
  And confirma en modal "¿Seguro cancelar?"
Then sistema:
  - Cambia booking status → CANCELADA_ESTUDIANTE
  - Libera slot en calendario tutor (disponible nuevamente)
  - Procesa reembolso 100% ($15.000) a método de pago
  - Envía email a ambos: "Reserva cancelada"
  - NO aplica penalización
```

### **Escenario 2: Cancelación con penalización (<24h antes)**
```gherkin
Given reserva BK-002 para "Lunes 10/01 10:00 AM"
  And fecha actual: "Lunes 10/01 08:00" (2h antes)
When estudiante cancela
Then sistema:
  - Cambia status → CANCELADA_TARDIA
  - Calcula penalización: 50% del valor ($7.500)
  - Reembolsa 50% a estudiante ($7.500)
  - Transfiere 50% a tutor como compensación
  - Marca slot como liberado (tutor puede aceptar nueva reserva)
  - Envía email con detalles penalización
```

### **Escenario 3: Cancelación por tutor (emergencia)**
```gherkin
Given tutor "Carlos" tiene emergencia
When cancela reserva BK-003 (3h antes)
Then sistema:
  - Cambia status → CANCELADA_TUTOR
  - Reembolsa 100% a estudiante (sin penalización)
  - NO transfiere fondos a tutor (pierde ingreso)
  - Registra cancelación en historial tutor (métrica confiabilidad)
  - Si 3+ cancelaciones tutor/mes → notifica admin (review manual)
  - Envía disculpa automática a estudiante + cupón 10% descuento
```

### **Escenario 4: No-show estudiante (no cancela, no asiste)**
```gherkin
Given reserva BK-004 para "10:00 AM"
  And estudiante NO cancela previamente
When pasan 15 minutos sin join (10:15 AM)
Then sistema:
  - Tutor marca "Estudiante no asistió" en dashboard
  - Cambia status → NO_SHOW_ESTUDIANTE
  - NO reembolsa pago (100% a tutor)
  - Penaliza estudiante: strike (3 strikes → suspensión temporal)
  - Envía email: "Perdiste tu sesión por no asistir"
```

### **Escenario 5: Cancelación con crédito (alternativa reembolso)**
```gherkin
When estudiante cancela >24h antes
Then muestra opciones:
  | Opción              | Beneficio                   |
  | Reembolso a tarjeta | 100% en 5-7 días bancarios  |
  | Crédito plataforma  | 110% inmediato (bonus 10%)  |

When selecciona "Crédito plataforma"
Then crea saldo wallet: $16.500
  And puede usar en próxima reserva
```

---

## 🔗 Trazabilidad

**RF:** RF-023 (Cancelar reserva)  
**RNF:** RNF-SEC-009 (reembolsos auditados), RNF-USAB-006 (política visible antes reservar)

**Story Points:** 8 SP | **Complejidad:** Alta (múltiples flujos + pagos)

---

## 🧩 Dependencias

- **Depende de:** HU-021 (Reservar sesión), HU-030 (Procesar pago)
- **Relacionada con:** HU-034 (Reembolsos), HU-027 (Marcar completada)

---

## ✔️ DoD

- [ ] Endpoint `POST /api/bookings/{id}/cancelar` con validaciones política
- [ ] Lógica cálculo tiempo restante (comparar con fecha_hora_sesion)
- [ ] Integración Stripe Refunds API (partial/full refunds)
- [ ] Estados booking: CANCELADA_ESTUDIANTE, CANCELADA_TUTOR, CANCELADA_TARDIA, NO_SHOW
- [ ] Tabla `cancellations`: booking_id, cancelado_por, motivo, penalizacion_aplicada, reembolso_monto
- [ ] Email templates: cancelación exitosa, penalización aplicada, no-show
- [ ] Dashboard tutor: botón "Marcar no-show" (disponible +15min después hora)
- [ ] Sistema strikes estudiantes (3 no-shows → suspensión 30 días)
- [ ] Tests E2E: cancelación gratuita + tardía + no-show

---

**Etiquetas:** `#reservas` `#mvp` `#must-have` `#cancelacion` `#reembolsos` `#politicas` `#revenue-protection`

---

## 📋 Política Cancelación (debe mostrarse antes de reservar)

**Cancelación gratuita:** >24h antes → reembolso 100%  
**Cancelación tardía:** <24h antes → reembolso 50%, tutor recibe 50%  
**No-show:** Sin aviso → sin reembolso, tutor recibe 100%  
**Cancelación tutor:** Reembolso 100% + cupón 10% descuento

---

## ⚠️ Supuestos

- Política 24h es estándar industria (benchmark Airbnb, Calendly)
- Sistema wallet para créditos reduce costos transaccionales Stripe
