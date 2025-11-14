# HU-042: Chat de Texto en Sesión

## 📋 Historia de Usuario

**Como** estudiante o tutor en una sesión de videollamada,  
**Quiero** enviar mensajes de texto en un chat lateral,  
**Para** compartir enlaces, código o notas sin interrumpir el flujo de audio.

## 🎯 Valor de Negocio

El chat complementa la videollamada permitiendo compartir recursos (URLs, snippets de código, notas) que serían difíciles de dictarse verbalmente. Mejora la experiencia pedagógica y reduce fricciones de comunicación.

**Impacto:** NPS +5-10 puntos, Engagement aumentado 15% (según benchmarks de Zoom)

## 📝 Descripción Detallada

Panel de chat lateral (300px ancho) que se abre/cierra con botón. Mensajes en tiempo real con Socket.io. Historial guardado en BD para consulta posterior. Soporte de markdown básico (negrita, cursiva, código inline).

## ✅ Criterios de Aceptación

### Escenario 1: Enviar mensaje de texto durante sesión

**Dado que** estoy en una sesión de videollamada activa  
**Cuando** hago clic en el icono de chat (💬) en la barra de controles  
**Entonces** se abre un panel lateral con el chat  
**Y** veo un input "Escribe un mensaje..." en la parte inferior  
**Y** cuando escribo "Hola, aquí está el link" y presiono Enter  
**Entonces** mi mensaje aparece en el chat con timestamp y mi nombre  
**Y** el otro participante recibe el mensaje en tiempo real con notificación sonora

### Escenario 2: Recibir mensaje mientras el chat está cerrado

**Dado que** el panel de chat está cerrado  
**Cuando** el otro participante me envía un mensaje  
**Entonces** veo un badge rojo con número "1" en el icono de chat (💬¹)  
**Y** escucho una notificación sutil  
**Y** al abrir el chat, veo el mensaje nuevo con indicador "Nuevo"

### Escenario 3: Compartir enlaces clickeables

**Dado que** quiero compartir un recurso externo  
**Cuando** escribo "Revisa esto: https://github.com/ejemplo" en el chat  
**Entonces** el link se convierte automáticamente en hipervínculo azul  
**Y** el destinatario puede hacer clic para abrirlo en nueva pestaña  
**Y** veo un preview del link (título + favicon) si es posible

### Escenario 4: Formato de código con backticks

**Dado que** quiero compartir un snippet de código  
**Cuando** escribo \`console.log('Hola')\` con backticks  
**Entonces** el texto aparece con formato de código (monospace, fondo gris)  
**Y** si uso triple backtick \`\`\`javascript, se formatea como bloque de código multilínea

### Escenario 5: Historial de chat después de la sesión

**Dado que** la sesión ha terminado  
**Cuando** accedo al detalle de la sesión desde "Mis Reservas"  
**Entonces** veo un botón "Ver Chat" que muestra todo el historial de mensajes  
**Y** puedo copiar mensajes o exportar el chat completo como TXT

## 🔗 Trazabilidad

- **Módulo:** Videollamadas
- **Épica:** Herramientas de Comunicación
- **Requisito Funcional:** RF-043 (Chat en tiempo real)
- **Requisito No Funcional:** RNF-PERF-003 (Entrega de mensajes <500ms)
- **Prioridad:** SHOULD HAVE (Release 1.1)

## 📊 Estimación

- **Story Points:** 5
- **Esfuerzo Estimado:** 2-3 días
- **Complejidad:** Media (Socket.io + persistencia en BD)

## 🔄 Dependencias

- **Depende de:** HU-040 (Iniciar sesión de video), Socket.io server configurado
- **Bloquea a:** HU-055 (Notificaciones de chat), HU-073 (Historial de sesiones con chat)
- **Relacionada con:** HU-041 (Compartir pantalla - complementario)

## 🧪 Notas de Testing

1. **Latencia de mensajes:** <500ms en red normal
2. **Orden de mensajes:** Verificar sincronización con múltiples mensajes rápidos
3. **Reconexión:** Red se cae, mensajes pendientes se envían al reconectar
4. **XSS:** Inyección de scripts maliciosos (<script>alert('xss')</script>)
5. **Links maliciosos:** Detectar phishing con VirusTotal API (opcional)

## ⚠️ Riesgos y Supuestos

**Supuestos:** Socket.io con rooms por sesión, mensajes encriptados en tránsito (TLS)  
**Riesgos:** 
- Spam de mensajes (rate limit: 10 msg/min por usuario)
- Almacenamiento de chat (¿borrar después de 30 días?)

## ✔️ Definition of Done

- [ ] Chat en tiempo real funcional
- [ ] Mensajes persistidos en PostgreSQL
- [ ] Links clickeables con sanitización XSS
- [ ] Tests E2E (enviar, recibir, formato)
- [ ] Demo con PO aprobada

## 📌 Etiquetas

`#modulo-videollamadas` `#release-1.1` `#prioridad-media` `#chat` `#tiempo-real` `#socket-io`

---

**Última actualización:** 2025-11-08  
**Autor:** Product Owner Senior - ZNS v2.0
