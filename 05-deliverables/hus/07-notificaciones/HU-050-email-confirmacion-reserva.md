# HU-050: Notificación por Email de Confirmación de Reserva

## 📋 Historia de Usuario

**Como** estudiante que acaba de reservar una sesión,  
**Quiero** recibir un email de confirmación con todos los detalles,  
**Para** tener un registro de mi reserva y datos del tutor.

## 🎯 Valor de Negocio

El email de confirmación es **comunicación crítica** que reduce no-shows y da profesionalismo a la plataforma. Sin este email, los usuarios dudan si la reserva fue exitosa.

**Impacto:** Tasa de no-shows reducida 25%, Confianza en la plataforma aumentada, Tickets de "¿Se guardó mi reserva?" eliminados

## 📝 Descripción Detallada

Email transaccional enviado inmediatamente después de completar una reserva. Contiene: datos de la sesión (fecha, hora, duración), información del tutor (nombre, foto, especialidad), link para unirse a la sesión, link para cancelar/reprogramar, añadir a Google Calendar (iCal attachment).

**Proveedor:** SendGrid (transactional email) o AWS SES  
**Template:** HTML responsive con branding de MI-TOGA

## ✅ Criterios de Aceptación

### Escenario 1: Recibir email de confirmación después de reservar

**Dado que** acabo de completar una reserva para una sesión de Matemáticas con el tutor "Juan Pérez" para el 15/11/2025 a las 14:00  
**Cuando** el pago se procesa exitosamente  
**Entonces** recibo un email en menos de 1 minuto a mi dirección registrada  
**Y** el asunto es: "Confirmación de Reserva - Sesión con Juan Pérez"  
**Y** el email contiene:
- Saludo personalizado: "Hola [Mi Nombre],"
- Detalles de sesión: Materia, Fecha, Hora, Duración (1 hora)
- Información del tutor: Nombre, foto, especialidad
- Valor pagado: $50,000 COP
- Botón: "Unirme a la Sesión" (habilitado 15 min antes)
- Botón: "Reprogramar" | "Cancelar"
- Adjunto: Evento de calendario (ical)
- Footer: Soporte, Términos, Redes sociales

### Escenario 2: Link de "Añadir a Calendario" funcional

**Dado que** recibí el email de confirmación  
**Cuando** hago clic en el botón "Añadir a Calendario" o abro el attachment .ics  
**Entonces** se descarga un archivo calendar-event.ics  
**Y** al abrirlo con Google Calendar/Outlook, se crea un evento con:
- Título: "Tutoría: Matemáticas con Juan Pérez"
- Fecha y hora correctas
- Duración: 1 hora
- Descripción: Link de sesión + datos del tutor
- Recordatorio: 1 hora antes

### Escenario 3: Link de "Cancelar Reserva" con token seguro

**Dado que** quiero cancelar desde el email  
**Cuando** hago clic en "Cancelar Reserva"  
**Entonces** se abre el navegador en una página de MI-TOGA con el formulario de cancelación prellenado  
**Y** el link incluye un token de autenticación temporal (válido 7 días)  
**Y** no necesito iniciar sesión nuevamente (one-click cancellation)

### Escenario 4: Email no llega (caso de error)

**Dado que** el envío de email falla (SendGrid caído o email inválido)  
**Cuando** el sistema intenta enviar el email  
**Entonces** el backend reintenta 3 veces con backoff exponencial (1min, 5min, 15min)  
**Y** si falla definitivamente, se loggea el error con ID de reserva  
**Y** el usuario ve la confirmación en pantalla igualmente (no se bloquea el flujo)  
**Y** se envía alerta a equipo de soporte

### Escenario 5: Email responsive en móvil

**Dado que** abro el email de confirmación en mi iPhone  
**Cuando** veo el email en la app de Gmail/iOS Mail  
**Entonces** el diseño es responsive y legible sin hacer zoom  
**Y** los botones tienen tamaño táctil adecuado (44x44px mínimo)  
**Y** las imágenes cargan correctamente

## 🔗 Trazabilidad

- **Módulo:** Notificaciones
- **Épica:** Comunicación Transaccional
- **Requisito Funcional:** RF-060 (Email de confirmación)
- **Requisito No Funcional:** RNF-RELIAB-002 (Entrega de email <1 minuto, SLA 99.5%)
- **Prioridad:** MUST HAVE (MVP - Release 1.0)

## 📊 Estimación

- **Story Points:** 3
- **Esfuerzo Estimado:** 1-2 días
- **Complejidad:** Baja (integración con SendGrid API + template HTML)

## 🔄 Dependencias

- **Depende de:** HU-021 (Reservar sesión), SendGrid account configurado
- **Bloquea a:** HU-051 (Notificación de recordatorio 24h antes)
- **Relacionada con:** HU-030 (Procesar pago - trigger del email)

## 🧪 Notas de Testing

1. **Envío exitoso:** Verificar email llega en <1 min
2. **Reintento en error:** Mockear SendGrid down, verificar reintentos
3. **Attachment iCal:** Validar formato ICS correcto (RFC 5545)
4. **Links de token:** Verificar expiración después de 7 días
5. **Spam score:** Revisar con Mail Tester (score >8/10)
6. **Clients:** Probar en Gmail, Outlook, iOS Mail, Yahoo

## ⚠️ Riesgos y Supuestos

**Supuestos:** SendGrid con cuenta verificada (dominio authenticado con SPF/DKIM)  
**Riesgos:** 
- **Medio:** Emails en spam (solución: warming up de dominio, feedback loops)
- **Bajo:** Rate limits de SendGrid (100 emails/día gratis → plan de $20/mes para 40K)

## ✔️ Definition of Done

- [ ] Integración con SendGrid API completada
- [ ] Template HTML responsive diseñado
- [ ] iCal attachment generado correctamente
- [ ] Tests de envío en múltiples clientes de email
- [ ] Reintentos implementados (3x con backoff)
- [ ] Logs de errores en Sentry/CloudWatch
- [ ] Spam score validado (>8/10)

## 📌 Etiquetas

`#modulo-notificaciones` `#release-1.0` `#prioridad-alta` `#email` `#sendgrid` `#transactional`

---

**Última actualización:** 2025-11-08  
**Autor:** Product Owner Senior - ZNS v2.0
