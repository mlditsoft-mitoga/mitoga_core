# HU-040: Iniciar Sesión de Video

## 📋 Historia de Usuario

**Como** estudiante con una sesión reservada,  
**Quiero** iniciar una videollamada con mi tutor en el horario acordado,  
**Para** recibir mi tutoría en tiempo real con video y audio.

## 🎯 Valor de Negocio

Funcionalidad **core** de la plataforma que permite la interacción en tiempo real entre estudiante y tutor. Sin videollamadas funcionales, el producto pierde su propuesta de valor principal. Esta historia habilita:
- **Experiencia de tutoría virtual completa**
- **Reducción de no-shows** (acceso directo desde la plataforma)
- **Control de calidad** (registros de sesiones iniciadas/completadas)
- **Diferenciación vs. competencia** (no depender de Zoom/Meet externos)

**Impacto en KPIs:**
- Tasa de completitud de sesiones: Target >90%
- NPS: Conveniencia de acceso integrado
- Retención: Experiencia unificada sin salir de la plataforma

## 📝 Descripción Detallada

El estudiante accede a su panel de "Mis Reservas" y ve una sesión próxima a iniciarse (dentro de 15 minutos previos al horario). El sistema muestra un botón "Iniciar Sesión" que lanza una sala de videollamada.

**Flujo principal:**
1. Usuario navega a "Mis Reservas" y encuentra sesión programada
2. 15 minutos antes del inicio, aparece botón "Iniciar Sesión" (verde)
3. Al hacer clic, se abre modal/página full-screen con videollamada
4. Solicitud de permisos de cámara y micrófono (browser prompt)
5. Pre-visualización de video propio mientras espera al tutor
6. Notificación automática al tutor de que el estudiante está listo
7. Cuando el tutor se une, inicia la sesión con video bilateral

**Integraciones técnicas:**
- **WebRTC** para comunicación P2P o MCU (Agora/Twilio/Jitsi)
- **Socket.io** para señalización en tiempo real
- **AWS S3/CloudFront** para assets de UI (botones, iconos)

**Consideraciones UX:**
- Test de conexión previo (check de cámara, micrófono, ancho de banda)
- Indicador de "Esperando al tutor..." con timer
- Opción de "Reintentar conexión" si falla
- Acceso responsive (desktop + tablet, mobile opcional en V2)

## ✅ Criterios de Aceptación

### Escenario 1: Inicio exitoso de sesión por estudiante

**Dado que** soy un estudiante con una sesión reservada para hoy a las 14:00  
**Y** la hora actual es 13:45 (15 minutos antes)  
**Cuando** accedo a "Mis Reservas" en el dashboard  
**Entonces** veo el botón "Iniciar Sesión" habilitado en color verde junto a mi reserva  
**Y** el botón muestra un tooltip "Puedes entrar 15 minutos antes del inicio"

### Escenario 2: Solicitud de permisos de cámara y micrófono

**Dado que** hago clic en "Iniciar Sesión"  
**Cuando** se abre la interfaz de videollamada  
**Entonces** el navegador me solicita permisos de cámara y micrófono  
**Y** veo mi video en preview mientras concedo permisos  
**Y** si deniego permisos, veo un mensaje de error: "Necesitas habilitar cámara y micrófono para continuar"  
**Y** tengo un botón "Reintentar permisos"

### Escenario 3: Sala de espera antes de que el tutor se una

**Dado que** he iniciado la sesión exitosamente  
**Y** el tutor aún no se ha conectado  
**Cuando** estoy en la sala de videollamada  
**Entonces** veo mi video en pantalla completa  
**Y** veo un mensaje: "Esperando a [Nombre del Tutor]..." con animación de loading  
**Y** veo un timer que cuenta el tiempo de espera (00:00)  
**Y** tengo controles de mute/unmute de audio y video  
**Y** tengo un botón "Salir de la sesión"

### Escenario 4: Conexión exitosa con el tutor

**Dado que** estoy esperando en la sala  
**Cuando** el tutor se une a la sesión  
**Entonces** veo el video del tutor en pantalla grande  
**Y** mi video aparece en una ventana pequeña (picture-in-picture) en esquina  
**Y** veo el nombre del tutor superpuesto en su video  
**Y** el timer cambia a "Sesión en curso: 00:00" y comienza a contar  
**Y** escucho un sonido de notificación sutil al conectarse

### Escenario 5: Intento de iniciar sesión fuera de horario permitido

**Dado que** tengo una sesión reservada para hoy a las 14:00  
**Y** la hora actual es 12:00 (más de 15 minutos antes)  
**Cuando** veo mi reserva en el dashboard  
**Entonces** el botón "Iniciar Sesión" está deshabilitado (gris)  
**Y** veo un mensaje: "Disponible 15 minutos antes del inicio (13:45)"

### Escenario 6: Manejo de error de conexión

**Dado que** intento iniciar la sesión  
**Cuando** hay un problema de conexión de red o el servicio de videollamadas no está disponible  
**Entonces** veo un mensaje de error: "No pudimos conectarte. Revisa tu conexión a internet"  
**Y** veo un botón "Reintentar"  
**Y** veo un botón "Reportar problema"  
**Y** el sistema envía un log de error al backend para debugging

## 🔗 Trazabilidad

- **Módulo:** Videollamadas
- **Épica:** Sesión Virtual en Tiempo Real
- **Requisito Funcional:** RF-050 (Iniciar videollamada)
- **Requisito No Funcional:** 
  - RNF-PERF-001: Latencia de conexión <2 segundos
  - RNF-DISP-001: Disponibilidad >99.9% del servicio de videollamadas
  - RNF-SEC-003: Encriptación end-to-end de video/audio
- **Prioridad:** SHOULD HAVE (Release 1.1)

## 📊 Estimación

- **Story Points:** 8
- **Esfuerzo Estimado:** 4-5 días
- **Complejidad:** Alta (integración con WebRTC + señalización en tiempo real)

**Desglose técnico:**
- Frontend (sala de video + UI): 2 días
- Integración SDK (Agora/Twilio/Jitsi): 1 día
- Backend (API de tokens de acceso + señalización): 1 día
- Testing (casos de conexión, reconexión, permisos): 1 día

## 🔄 Dependencias

- **Depende de:** 
  - HU-021 (Reservar sesión) - debe existir una reserva previa
  - Infraestructura: Decisión de proveedor WebRTC (Agora recomendado)
  - Infraestructura: Socket.io server para señalización
- **Bloquea a:** 
  - HU-041 (Compartir pantalla)
  - HU-042 (Grabar sesión)
  - HU-043 (Chat en sesión)
  - HU-044 (Pizarra colaborativa)
  - HU-027 (Marcar sesión completada)
- **Relacionada con:** 
  - HU-025 (Recordatorios de sesión)
  - HU-052 (Notificar inicio de sesión)

## 🧪 Notas de Testing

**Casos de prueba críticos:**
1. **Happy path:** Estudiante y tutor se conectan exitosamente en horario
2. **Permisos denegados:** Navegador bloquea cámara/micrófono
3. **Reconexión:** Red se cae y usuario reconecta sin reiniciar sesión
4. **Cross-browser:** Chrome, Firefox, Safari, Edge
5. **Latencia de red:** Simular conexión lenta (3G, 4G, Wifi)
6. **Tutor nunca se conecta:** Timeout después de 10 minutos
7. **Múltiples dispositivos:** Estudiante intenta entrar desde 2 navegadores

**Datos de prueba requeridos:**
- 2 usuarios reales (1 estudiante, 1 tutor) en ambientes staging
- Reserva de sesión en horario cercano (próximos 10 min)
- Tokens de acceso válidos para servicio de videollamadas

**Herramientas de testing:**
- **Manual:** Chrome DevTools (Network throttling para simular 3G)
- **E2E:** Playwright/Cypress con permisos de cámara mockeados
- **Performance:** Lighthouse CI (medir FPS de video, latencia)
- **Automatización:** Jest + RTL para UI, Testcontainers para backend

## 🎨 Notas de Diseño

**Wireframe sugerido:**
```
┌─────────────────────────────────────────┐
│ MI-TOGA                         [X] Salir│
├─────────────────────────────────────────┤
│                                          │
│    ┌──────────────────────────────┐     │
│    │                              │     │
│    │     Video del Tutor          │     │
│    │     (Pantalla Principal)     │     │
│    │                              │     │
│    │     ┌──────────┐             │     │
│    │     │Mi Video  │             │     │
│    │     │ (PiP)    │             │     │
│    │     └──────────┘             │     │
│    └──────────────────────────────┘     │
│                                          │
│    Sesión en curso: 05:32               │
│                                          │
│    [🎤] [📷] [💬] [📋] [📞 Terminar]    │
│    Mic  Cam  Chat Screen  Hang Up       │
└─────────────────────────────────────────┘
```

**Assets necesarios:**
- Iconos de mute/unmute (micrófono con slash)
- Icono de cámara on/off
- Spinner de loading para "Esperando al tutor"
- Avatar placeholder si no hay video

## ⚠️ Riesgos y Supuestos

**Supuestos:**
- El navegador del usuario soporta WebRTC (Chrome 74+, Firefox 66+, Safari 12+)
- El usuario tiene cámara y micrófono funcionales
- Ancho de banda mínimo: 1 Mbps para video SD (480p)
- El proveedor de videollamadas (Agora/Twilio) tiene SLA >99.9%

**Riesgos:**
- **Alto:** Problemas de NAT traversal (firewalls corporativos) → Mitigación: TURN server
- **Medio:** Latencia variable según región geográfica → Mitigación: Edge servers en Colombia
- **Medio:** Costos por minuto de videollamada (Agora: $0.99/1000 min) → Monitoreo de usage
- **Bajo:** Safari móvil con limitaciones de WebRTC → Test exhaustivo iOS

**Preguntas abiertas:**
- ¿Proveedor de videollamadas definitivo? (Agora vs Twilio vs Jitsi self-hosted)
- ¿Calidad de video por defecto? (360p, 480p, 720p)
- ¿Permitir entrada sin cámara (solo audio)?
- ¿Timeouts de espera? (si tutor no llega en X minutos)

## ✔️ Definition of Done (DoD)

- [ ] Código desarrollado y code review aprobado (2 reviewers)
- [ ] Tests unitarios escritos y pasando (>80% cobertura en componente de video)
- [ ] Tests E2E para flujo completo (Playwright con permisos mockeados)
- [ ] Integración con SDK de videollamadas probada en staging
- [ ] Criterios de aceptación validados por PO (demo en vivo)
- [ ] Documentación técnica actualizada (README con diagrama de arquitectura WebRTC)
- [ ] Sin errores críticos o de seguridad (OWASP, penetration test básico)
- [ ] Desplegado en ambiente de staging y probado por QA
- [ ] Demo realizada con stakeholders (video de 2 minutos de sesión exitosa)
- [ ] Cumple estándares de performance (latencia <2s, FPS >24)
- [ ] Logs de errores configurados (Sentry para frontend, Cloudwatch para backend)
- [ ] Documentación de API tokens de videollamadas (Postman collection)

## 📌 Etiquetas (Tags)

`#modulo-videollamadas` `#release-1.1` `#prioridad-alta` `#webrtc` `#frontend` `#backend` `#integracion` `#tiempo-real`

---

**Última actualización:** 2025-11-08  
**Autor:** Product Owner Senior - ZNS v2.0  
**Revisores:** Tech Lead (WebRTC), UX Designer, QA Lead
