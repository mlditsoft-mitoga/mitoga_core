# Módulo 06: Videollamadas

**Épica:** Sesión Virtual en Tiempo Real  
**Prioridad:** SHOULD HAVE (Release 1.1)  
**Story Points Totales:** 35 SP  
**Historias de Usuario:** 6 HUs

---

## 📋 Índice de Historias de Usuario

| ID | Título | SP | Estado | Prioridad |
|----|--------|----|----- --|-----------|
| [HU-040](HU-040-iniciar-sesion-video.md) | Iniciar Sesión de Video | 8 | ✅ | Alta |
| [HU-041](HU-041-compartir-pantalla.md) | Compartir Pantalla | 5 | ✅ | Media |
| [HU-042](HU-042-chat-texto-sesion.md) | Chat de Texto en Sesión | 5 | ✅ | Media |
| [HU-043](HU-043-grabar-sesion.md) | Grabar Sesión (Opcional) | 8 | ✅ | Baja (COULD) |
| [HU-044](HU-044-pizarra-colaborativa.md) | Pizarra Colaborativa | 8 | ✅ | Alta |
| [HU-045](HU-045-calidad-conexion.md) | Indicador de Calidad de Conexión | 3 | ✅ | Media |

**Total:** 6 HUs | 37 SP (3 SP extras por HU-043 COULD HAVE)

---

## 🎯 Objetivos del Módulo

Este módulo habilita la **experiencia core de la plataforma**: sesiones de tutoría virtual en tiempo real con herramientas profesionales de enseñanza.

**Valor de Negocio:**
- Sin videollamadas funcionales, no hay producto viable
- Herramientas (pantalla, pizarra, chat) diferencian de Zoom/Meet genéricos
- Calidad de conexión visible reduce frustración y tickets de soporte

**KPIs del Módulo:**
- Tasa de completitud de sesiones: >90%
- Latencia de conexión: <2 segundos
- NPS de experiencia de videollamada: >8.0

---

## 🔗 Dependencias Externas

### Tecnología WebRTC
- **Proveedor recomendado:** Agora.io (plan Pro: $0.99/1000 min)
- **Alternativas:** Twilio Video, Jitsi (self-hosted gratuito)
- **Decisión pendiente:** Tech Lead debe evaluar costo vs. features

### Librerías Frontend
- **Excalidraw** (pizarra colaborativa): MIT License, gratuito
- **Socket.io** (señalización y chat): MIT License, gratuito
- **WebRTC Adapter**: Compatibilidad cross-browser

---

## 📊 Flujo de Usuarios

```
Estudiante                          Sistema                          Tutor
    |                                  |                               |
    | 1. Ver "Mis Reservas"            |                               |
    |--------------------------------->|                               |
    |                                  |                               |
    | 2. Clic "Iniciar Sesión"         |                               |
    |   (15 min antes)                 |                               |
    |--------------------------------->|                               |
    |                                  | 3. Notificar tutor            |
    |                                  |------------------------------>|
    | 4. Entrar a sala de espera       |                               |
    |<---------------------------------|                               |
    |                                  |                               |
    | 5. Esperando... (video preview)  |                               |
    |                                  | 6. Tutor se une               |
    |                                  |<------------------------------|
    | 7. Conexión P2P establecida      |                               |
    |<---------------------------------|------------------------------>|
    |                                  |                               |
    | 8. Sesión en curso (video + audio)                              |
    |<---------------------------------------------------------------->|
    |                                  |                               |
    | 9. Usar herramientas: Chat, Pizarra, Compartir Pantalla         |
    |<---------------------------------------------------------------->|
    |                                  |                               |
    | 10. Terminar sesión              |                               |
    |--------------------------------->|                               |
    |                                  | 11. Guardar stats             |
    |                                  | 12. Trigger notificación      |
```

---

## 🧪 Estrategia de Testing

### Tests Unitarios (40%)
- Componentes de UI: Controles de video, botones mute/unmute
- Lógica de estados: Esperando, En sesión, Desconectado
- Manejo de permisos de navegador

### Tests de Integración (40%)
- Integración con SDK de Agora/Twilio
- Señalización con Socket.io
- Persistencia de chat en BD

### Tests E2E (20%)
- **Playwright** con mock de `getUserMedia()` y `getDisplayMedia()`
- Flujo completo: Iniciar → Conectar → Usar herramientas → Terminar
- Escenarios de error: Permisos denegados, red cae, reconexión

### Tests de Performance
- Latencia de conexión: Target <2s
- FPS de video: Target >24fps
- Sincronización de pizarra: Latencia <500ms

---

## ⚠️ Riesgos y Mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| NAT Traversal (firewalls corporativos) | Media | Alto | Configurar TURN server (coturn/Twilio) |
| Costos de videollamadas (Agora: $0.99/1K min) | Alta | Medio | Monitoreo de usage + alertas en $2K/mes |
| Latencia variable según región | Media | Medio | Edge servers en Colombia (Agora soporta) |
| Safari con WebRTC limitado | Baja | Bajo | Tests exhaustivos en Safari 12+ |

---

## 📈 Roadmap del Módulo

### Release 1.1 (SHOULD HAVE) - 6 HUs, 35 SP
- ✅ HU-040: Iniciar sesión video (CRÍTICO)
- ✅ HU-041: Compartir pantalla
- ✅ HU-042: Chat en sesión
- ✅ HU-044: Pizarra colaborativa (STEM)
- ✅ HU-045: Indicador de calidad

### Release 1.2 (COULD HAVE) - 1 HU, 8 SP
- ✅ HU-043: Grabar sesión

### Futuro (WON'T HAVE Release 1.x)
- Transcripción automática con IA
- Subtítulos en tiempo real (accesibilidad)
- Breakout rooms (tutorías grupales)
- Realidad aumentada (whiteboard 3D)

---

**Última actualización:** 2025-11-08  
**Autor:** Product Owner Senior - ZNS v2.0  
**Metodología:** INVEST Criteria + Gherkin Format
