# HU-051: Recordatorio de Sesión (24h y 1h antes)

## 📋 Historia de Usuario

**Como** estudiante con sesiones reservadas,  
**Quiero** recibir recordatorios automáticos antes de la sesión,  
**Para** no olvidar mi cita con el tutor y llegar a tiempo.

## 🎯 Valor de Negocio

Los recordatorios **reducen drásticamente los no-shows**, que son la principal causa de pérdida de ingresos en plataformas de servicios bajo demanda.

**Impacto:** Tasa de no-shows reducida de 15% a 5% (benchmarks de Calendly/Cal.com), Revenue aumentado 10%

## 📝 Descripción Detallada

Sistema de recordatorios por email y push notification enviados automáticamente 24 horas y 1 hora antes de cada sesión. Job scheduler (cron o AWS EventBridge) consulta reservas próximas y envía notificaciones. Incluye botón de "Confirmar asistencia" y links de cancelación/reprogramación.

## ✅ Criterios de Aceptación

### Escenario 1: Recordatorio 24 horas antes

**Dado que** tengo una sesión reservada para mañana 15/11 a las 14:00  
**Cuando** llega el momento exacto 24 horas antes (14/11 a las 14:00)  
**Entonces** recibo un email con asunto: "Recordatorio: Sesión con [Tutor] mañana a las 14:00"  
**Y** recibo una push notification en el navegador (si tengo permisos activados)  
**Y** el contenido incluye: Fecha, hora, tutor, materia, duración  
**Y** tengo botones: [Confirmar Asistencia] [Reprogramar] [Cancelar]

### Escenario 2: Recordatorio 1 hora antes

**Dado que** mi sesión es en 1 hora (15/11 a las 14:00, ahora es 13:00)  
**Cuando** el sistema ejecuta el job de recordatorios  
**Entonces** recibo email con asunto: "Tu sesión comienza en 1 hora"  
**Y** recibo push notification con sonido de urgencia  
**Y** el email incluye botón destacado: "Unirme a la Sesión" (link directo a videollamada)

### Escenario 3: Confirmar asistencia desde el email

**Dado que** recibí el recordatorio de 24h  
**Cuando** hago clic en "Confirmar Asistencia"  
**Entonces** se abre una página de confirmación  
**Y** veo mensaje: "✅ Confirmaste tu asistencia. Te esperamos mañana"  
**Y** el tutor recibe notificación: "[Estudiante] confirmó su asistencia"  
**Y** ya no recibo más recordatorios (excepto el de 1h antes)

### Escenario 4: No se envían recordatorios si la sesión fue cancelada

**Dado que** cancelé mi sesión para mañana esta mañana  
**Cuando** llega el momento del recordatorio de 24h  
**Entonces** **no recibo** ningún email ni notificación  
**Y** el job verifica el estado de la reserva antes de enviar

### Escenario 5: Múltiples sesiones en un día

**Dado que** tengo 2 sesiones mañana (una a las 10:00 y otra a las 14:00)  
**Cuando** se envían los recordatorios  
**Entonces** recibo **2 emails separados**, uno por cada sesión  
**Y** cada email indica la hora específica de esa sesión  
**Y** no se agrupan en un solo email (para claridad)

## 🔗 Trazabilidad

- **Módulo:** Notificaciones
- **Épica:** Recordatorios Automáticos
- **Requisito Funcional:** RF-034 (Recordatorios de sesión)
- **Requisito No Funcional:** RNF-RELIAB-003 (Recordatorio entregado con precisión de ±5 minutos)
- **Prioridad:** MUST HAVE (Release 1.0)

## 📊 Estimación

- **Story Points:** 5
- **Esfuerzo Estimado:** 2-3 días
- **Complejidad:** Media (cron job + lógica de agendamiento)

## 🔄 Dependencias

- **Depende de:** HU-021 (Reservar sesión), HU-050 (Email confirmación), AWS EventBridge o cron
- **Bloquea a:** HU-054 (Recordatorio de sesión completada para calificar)
- **Relacionada con:** HU-052 (Push notifications)

## 🧪 Notas de Testing

1. **Precisión temporal:** Verificar envío exacto a las 24h y 1h antes
2. **Time zones:** Reserva en UTC -5 (Colombia), verificar cálculo correcto
3. **Idempotencia:** Job ejecutado 2 veces no envía emails duplicados
4. **Reservas canceladas:** Verificar que no se envían recordatorios
5. **Carga:** 1000 reservas en mismo horario → 1000 emails en <5 minutos

## ⚠️ Riesgos y Supuestos

**Supuestos:** AWS EventBridge con scheduled rules o cron job cada 5 minutos  
**Riesgos:** 
- **Medio:** Job falla y no se envían recordatorios → Alerting con PagerDuty
- **Bajo:** Time zone issues si expandimos a otros países

## ✔️ Definition of Done

- [ ] Cron job configurado (cada 5 min)
- [ ] Lógica de 24h y 1h implementada
- [ ] Email templates diseñados
- [ ] Push notifications integradas (Firebase/OneSignal)
- [ ] Tests de precisión temporal
- [ ] Idempotencia verificada (no duplicados)
- [ ] Logs de recordatorios enviados

## 📌 Etiquetas

`#modulo-notificaciones` `#release-1.0` `#prioridad-alta` `#recordatorios` `#email` `#cron` `#automation`

---

**Última actualización:** 2025-11-08  
**Autor:** Product Owner Senior - ZNS v2.0
