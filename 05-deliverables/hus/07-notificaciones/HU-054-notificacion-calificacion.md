# HU-054: Notificación de Sesión Completada (Solicitud de Calificación)

## 📋 Historia de Usuario

**Como** estudiante que acaba de terminar una sesión,  
**Quiero** recibir una notificación para calificar y reseñar al tutor,  
**Para** ayudar a otros estudiantes y dar feedback al tutor.

## 🎯 Valor de Negocio

Las calificaciones post-sesión son **críticas para la confianza** del marketplace. Sin reseñas, tutores nuevos no reciben reservas (efecto "cold start"). Esta notificación aumenta la tasa de reseñas de 5% a 35% (datos de Airbnb/Uber).

**Impacto:** Tasa de reseñas +700%, Calidad de tutores visible, Confianza en marketplace aumentada

## 📝 Descripción Detallada

Email y push notification enviados 5 minutos después de que una sesión se marca como "Completada". Incluye form rápido de calificación (1-5 estrellas) y campo de reseña opcional. Botón "Calificar Ahora" con link directo. Recordatorio adicional a las 24 horas si no se calificó.

## ✅ Criterios de Aceptación

### Escenario 1: Recibir notificación 5 minutos después de sesión completada

**Dado que** acabo de completar una sesión de Matemáticas con Juan Pérez a las 15:00  
**Cuando** el tutor marca la sesión como "Completada" a las 15:02  
**Entonces** a las 15:07 (5 minutos después) recibo:
- **Email** con asunto: "¿Cómo fue tu sesión con Juan Pérez? ⭐"
- **Push notification:** "Califica tu sesión con Juan Pérez"
**Y** el email incluye:
- Resumen de sesión: Materia, duración, fecha
- Calificación rápida: 1-5 estrellas clickeables en el email
- Botón: "Escribir Reseña" (link a formulario completo)

### Escenario 2: Calificar desde el email (quick rating)

**Dado que** recibí el email de solicitud de calificación  
**Cuando** hago clic en "4 estrellas" directamente en el email  
**Entonces** se registra mi calificación de 4 estrellas  
**Y** se abre una página de agradecimiento: "¡Gracias por tu feedback! ¿Quieres agregar una reseña escrita?"  
**Y** tengo opción de escribir reseña (opcional)  
**Y** ya no recibo recordatorio de calificación para esta sesión

### Escenario 3: Escribir reseña completa

**Dado que** quiero dejar feedback detallado  
**Cuando** hago clic en "Escribir Reseña" en el email  
**Entonces** se abre un formulario con:
- Calificación (1-5 estrellas) preseleccionada si ya hice quick rating
- Campo de texto: "¿Qué te pareció la sesión?" (500 caracteres máx)
- Checkboxes opcionales: "¿Qué destacas?" (Puntualidad, Didáctica, Conocimiento, Paciencia)
- Toggle: "Compartir mi nombre" o "Anónimo"
**Y** al enviar, veo: "✅ Reseña publicada. ¡Gracias por ayudar a otros estudiantes!"

### Escenario 4: Recordatorio si no se calificó en 24 horas

**Dado que** no califiqué la sesión en el mismo día  
**Cuando** han pasado 24 horas desde que terminó la sesión  
**Entonces** recibo un **segundo recordatorio** por email:
- Asunto: "No olvides calificar tu sesión con Juan Pérez"
- Mensaje más breve con botón "Calificar Ahora"
**Y** después de este recordatorio, no se envían más notificaciones (máximo 2)

### Escenario 5: No solicitar calificación si la sesión fue cancelada

**Dado que** una sesión fue cancelada (no completada)  
**Cuando** el sistema verifica el estado de la sesión  
**Entonces** **no se envía** notificación de calificación  
**Y** solo se solicita calificación para sesiones con estado "Completada"

## 🔗 Trazabilidad

- **Módulo:** Notificaciones
- **Épica:** Feedback y Calidad
- **Requisito Funcional:** RF-015 (Calificar tutor post-sesión)
- **Requisito No Funcional:** RNF-UX-003 (Proceso de calificación <1 minuto)
- **Prioridad:** SHOULD HAVE (Release 1.1)

## 📊 Estimación

- **Story Points:** 3
- **Esfuerzo Estimado:** 1-2 días
- **Complejidad:** Baja (trigger de email + form simple)

## 🔄 Dependencias

- **Depende de:** HU-027 (Marcar sesión completada), HU-015 (Sistema de calificaciones)
- **Bloquea a:** HU-076 (Dashboard de reseñas para tutores)
- **Relacionada con:** HU-050 (Email confirmación - template similar)

## 🧪 Notas de Testing

1. **Timing:** Verificar envío exactamente 5 min después de completada
2. **Quick rating:** Clic en estrellas del email registra calificación
3. **Doble recordatorio:** Verificar que se envía solo si no calificó
4. **Estados:** Sesiones canceladas no reciben notificación
5. **Múltiples sesiones:** 2 sesiones en un día → 2 emails separados

## ⚠️ Riesgos y Supuestos

**Supuestos:** Tutor marca sesión como "Completada" (trigger del workflow)  
**Riesgos:** **Bajo** - Spam si se envían muchas solicitudes (limitar a 1 por sesión)

## ✔️ Definition of Done

- [ ] Trigger de envío 5 min post-sesión
- [ ] Quick rating en email funcional
- [ ] Formulario de reseña completa
- [ ] Recordatorio a las 24h si no calificó
- [ ] Validación de estados (solo "Completada")
- [ ] Tests de timing y lógica de recordatorios

## 📌 Etiquetas

`#modulo-notificaciones` `#release-1.1` `#prioridad-alta` `#calificaciones` `#feedback` `#marketplace-quality`

---

**Última actualización:** 2025-11-08  
**Autor:** Product Owner Senior - CEIBA v1.2
