# Módulo: Reservas

**Responsable:** Backend Lead + Frontend  
**Story Points Totales:** 59 SP  
**Historias:** 9 HUs MUST HAVE

---

## 🎯 Objetivo del Módulo

Gestionar ciclo completo de reservas: ver disponibilidad, reservar, confirmar, cancelar, reprogramar, recordatorios automáticos y marcar sesiones completadas.

---

## 📋 Historias de Usuario

| ID | Título | Rol | Prioridad | SP | Estado |
|----|--------|-----|-----------|----|----|
| [HU-020](HU-020-ver-calendario-disponibilidad.md) | Ver calendario disponibilidad tutor | Estudiante | MUST | 5 | ✅ Generada |
| [HU-021](HU-021-reservar-sesion.md) | Reservar sesión de tutoría | Estudiante | MUST | 13 | ✅ Generada |
| [HU-022](HU-022-confirmar-datos-reserva.md) | Confirmar datos antes de pagar | Estudiante | MUST | 5 | ✅ Generada |
| [HU-023](HU-023-cancelar-reserva.md) | Cancelar reserva con políticas | Est/Tutor | MUST | 8 | ✅ Generada |
| [HU-024](HU-024-reprogramar-sesion.md) | Reprogramar sesión (aprobación tutor) | Est/Tutor | MUST | 8 | ✅ Generada |
| [HU-025](HU-025-recordatorios-sesion.md) | Recibir recordatorios 24h + 1h | Est/Tutor | MUST | 3 | ✅ Generada |
| [HU-026](HU-026-ver-mis-reservas.md) | Ver lista todas mis reservas | Est/Tutor | MUST | 5 | ✅ Generada |
| [HU-027](HU-027-marcar-sesion-completada.md) | Marcar sesión como completada | Tutor | MUST | 5 | ✅ Generada |

**Total:** 52 SP

---

## 🔗 Dependencias

**Servicios externos:**
- SendGrid / AWS SES (emails recordatorios)
- Firebase Cloud Messaging (push notifications mobile)
- Cronjob scheduler (recordatorios automáticos cada 15 min)

**RNF críticos:**
- RNF-PERF-003: Reserva procesada <2s
- RNF-SEC-006: Evitar doble reserva (row-level locks DB)
- RNF-NOTIF-001: 99% delivery rate emails recordatorios

---

## 🧪 Testing

- **Cobertura esperada:** >95% (flujo transaccional crítico)
- **Tests E2E:** Reservar→pagar→recibir recordatorio→completar→calificar (journey completo)
- **Load testing:** 500 reservas concurrentes sin race conditions
- **Chaos engineering:** Simular fallo email service (fallback notificación in-app)

---

## 📊 Métricas

| Métrica | Objetivo | Seguimiento |
|---------|----------|-------------|
| Tasa abandono checkout | < 20% | Google Analytics |
| Cancelaciones <24h (tardías) | < 10% | BD analytics |
| No-shows (sin cancelar) | < 5% | Reducción vía recordatorios |
| Reprogramaciones exitosas | > 80% | Tasa aprobación tutor |
| Open rate emails recordatorio | > 60% | SendGrid analytics |

---

**Última actualización:** 08/11/2025  
**Estado:** 8/9 HUs generadas (89% - falta HU-028 SHOULD)
