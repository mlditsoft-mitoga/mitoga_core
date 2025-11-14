# HU-052: Push Notifications en Navegador

## 📋 Historia de Usuario

**Como** usuario activo de la plataforma,  
**Quiero** recibir notificaciones push en mi navegador en tiempo real,  
**Para** estar al tanto de mensajes, cambios en reservas y actualizaciones importantes sin estar en la página.

## 🎯 Valor de Negocio

Las push notifications **aumentan el engagement** al mantener a los usuarios informados en tiempo real. Son especialmente valiosas para mensajes urgentes (tutor canceló sesión, nuevo mensaje en chat).

**Impacto:** Engagement +25%, Tiempo de respuesta a mensajes reducido 50%

## 📝 Descripción Detallada

Implementación de Web Push API (Service Worker) para enviar notificaciones al navegador del usuario. Se solicitan permisos al usuario en momento oportuno (no inmediatamente al entrar). Tipos de notificaciones: nuevo mensaje, cambio en reserva, recordatorio próximo, pago procesado. Integración con Firebase Cloud Messaging (FCM) o OneSignal.

## ✅ Criterios de Aceptación

### Escenario 1: Solicitar permisos de notificaciones

**Dado que** soy un nuevo usuario que acaba de completar mi primera reserva  
**Cuando** la reserva se confirma exitosamente  
**Entonces** veo un banner amigable: "¿Quieres recibir notificaciones sobre tus sesiones? [Activar] [Ahora no]"  
**Y** si hago clic en "Activar", el navegador me solicita permisos nativos  
**Y** si acepto, se almacena mi token FCM en el backend  
**Y** si rechazo, no veo el banner nuevamente hasta pasados 7 días

### Escenario 2: Recibir notificación de nuevo mensaje

**Dado que** tengo notificaciones activadas  
**Y** estoy navegando en otra pestaña (no en MI-TOGA)  
**Cuando** un tutor me envía un mensaje de chat  
**Entonces** recibo una notificación push con:
- Título: "Nuevo mensaje de [Tutor]"
- Cuerpo: "[Primeros 50 caracteres del mensaje]..."
- Icono: Logo de MI-TOGA
- Badge: Foto del tutor
**Y** al hacer clic, se abre MI-TOGA en la pestaña de mensajes

### Escenario 3: Notificación de cambio en reserva

**Dado que** tengo una sesión reservada  
**Cuando** el tutor cancela o reprograma la sesión  
**Entonces** recibo notificación push inmediatamente:
- Título: "⚠️ Tu sesión del [fecha] fue cancelada"
- Cuerpo: "[Tutor] canceló la sesión. Se procesará reembolso"
- Acción: [Ver Detalles] [Reservar Nuevo Tutor]

### Escenario 4: Agrupar múltiples notificaciones

**Dado que** recibo 5 mensajes en rápida sucesión del mismo tutor  
**Cuando** el sistema envía las notificaciones  
**Entonces** se agrupan en una sola notificación:
- Título: "5 nuevos mensajes de [Tutor]"
- Cuerpo: "Último: [contenido último mensaje]"
**Y** no veo 5 notificaciones separadas (evitar spam)

### Escenario 5: Desactivar notificaciones desde configuración

**Dado que** quiero dejar de recibir notificaciones  
**Cuando** voy a "Configuración" → "Notificaciones"  
**Entonces** veo un toggle "Notificaciones Push" activado  
**Y** si lo desactivo, ya no recibo notificaciones  
**Y** puedo reactivarlo en cualquier momento

## 🔗 Trazabilidad

- **Módulo:** Notificaciones
- **Épica:** Notificaciones en Tiempo Real
- **Requisito Funcional:** RF-061 (Push notifications)
- **Requisito No Funcional:** RNF-PERF-005 (Entrega <3 segundos), RNF-PRIV-002 (Consentimiento explícito)
- **Prioridad:** SHOULD HAVE (Release 1.1)

## 📊 Estimación

- **Story Points:** 5
- **Esfuerzo Estimado:** 2-3 días
- **Complejidad:** Media (Service Worker + FCM integration)

## 🔄 Dependencias

- **Depende de:** Firebase Cloud Messaging account, Service Worker configurado
- **Bloquea a:** HU-053 (Notificaciones personalizadas por preferencias)
- **Relacionada con:** HU-042 (Chat en sesión - trigger de notificaciones)

## 🧪 Notas de Testing

1. **Permisos denegados:** Verificar flujo cuando usuario rechaza
2. **Múltiples dispositivos:** Usuario en desktop y móvil, recibe en ambos
3. **Expiración de tokens:** Renovar tokens FCM cada 60 días
4. **Agrupación:** 10 mensajes rápidos → 1 notificación agrupada
5. **Click action:** Notificación abre URL correcta

## ⚠️ Riesgos y Supuestos

**Supuestos:** FCM gratuito hasta 10M mensajes/mes, navegadores con Service Worker (Chrome, Firefox, Edge)  
**Riesgos:** **Bajo** - Safari con soporte limitado en iOS (requiere iOS 16.4+)

## ✔️ Definition of Done

- [ ] Service Worker configurado
- [ ] Integración con FCM completada
- [ ] Solicitud de permisos en momento oportuno
- [ ] 4 tipos de notificaciones implementadas
- [ ] Agrupación de notificaciones
- [ ] Tests en Chrome, Firefox, Edge
- [ ] Documentación de setup FCM

## 📌 Etiquetas

`#modulo-notificaciones` `#release-1.1` `#prioridad-media` `#push` `#fcm` `#service-worker` `#tiempo-real`

---

**Última actualización:** 2025-11-08  
**Autor:** Product Owner Senior - ZNS v2.0
