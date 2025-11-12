# HU-041: Compartir Pantalla

## 📋 Historia de Usuario

**Como** tutor impartiendo una sesión de tutoría,  
**Quiero** compartir mi pantalla con el estudiante durante la videollamada,  
**Para** mostrar presentaciones, código, documentos o ejercicios en tiempo real.

## 🎯 Valor de Negocio

La función de compartir pantalla es **esencial para tutorías efectivas** en materias técnicas (programación, diseño, matemáticas) donde el tutor debe demostrar procesos paso a paso. Esta capacidad:
- **Aumenta la calidad pedagógica** de las sesiones
- **Diferencia la plataforma** vs. videollamadas genéricas (Zoom requiere plan Pro)
- **Mejora NPS y retención** al ofrecer herramientas profesionales
- **Habilita casos de uso avanzados** (code review en vivo, corrección de ejercicios)

**Impacto en KPIs:**
- NPS: Tutores profesionales valoran herramientas de enseñanza
- Valor percibido: Justifica tarifas premium por sesión
- Engagement: Mayor interactividad = sesiones más largas

## 📝 Descripción Detallada

Durante una sesión de videollamada activa, el tutor tiene acceso a un botón "Compartir Pantalla" en la barra de controles. Al hacer clic:
1. El navegador muestra un selector nativo para elegir qué compartir (ventana, pestaña, pantalla completa)
2. El tutor selecciona y confirma
3. El estudiante ve la pantalla compartida en lugar del video del tutor
4. El tutor puede detener el uso compartido en cualquier momento

**Consideraciones técnicas:**
- **API nativa:** `navigator.mediaDevices.getDisplayMedia()` (Chrome 72+, Firefox 66+)
- **Resolución adaptativa:** Ajustar calidad según ancho de banda (720p → 480p → screen share optimizado)
- **Indicador visual:** El tutor siempre ve un banner "Estás compartiendo pantalla" para evitar compartir contenido sensible accidentalmente

**Casos de uso principales:**
- **Programación:** Mostrar IDE con código en vivo
- **Matemáticas:** Resolver ejercicios en pizarra digital (Excalidraw, OneNote)
- **Diseño:** Mostrar Figma/Photoshop
- **Documentos:** Presentar PDFs, Google Docs, Excel

## ✅ Criterios de Aceptación

### Escenario 1: Tutor comparte pantalla exitosamente

**Dado que** soy un tutor en una sesión de videollamada activa  
**Y** tengo contenido que quiero mostrar al estudiante  
**Cuando** hago clic en el botón "Compartir Pantalla" (icono 📋)  
**Entonces** el navegador me muestra un diálogo de selección de ventana/pestaña/pantalla  
**Y** selecciono mi ventana de VS Code y hago clic en "Compartir"  
**Y** veo un banner rojo en la parte superior: "🔴 Estás compartiendo pantalla - Clic aquí para detener"  
**Y** el estudiante ve mi pantalla de VS Code en tiempo real  
**Y** mi video queda en una ventana pequeña (PiP) en la esquina del estudiante

### Escenario 2: Vista desde la perspectiva del estudiante

**Dado que** estoy en una sesión como estudiante  
**Cuando** el tutor comienza a compartir su pantalla  
**Entonces** veo una notificación: "[Nombre Tutor] está compartiendo pantalla"  
**Y** la pantalla compartida reemplaza el video principal del tutor  
**Y** el video de cámara del tutor se reduce a un PiP en esquina (opcional: desactivarlo)  
**Y** veo un indicador "🖥️ Pantalla compartida" en la barra superior  
**Y** puedo hacer zoom in/out si la pantalla es difícil de leer (botón +/-)

### Escenario 3: Tutor detiene el uso compartido

**Dado que** estoy compartiendo mi pantalla como tutor  
**Cuando** hago clic en el banner rojo "Detener compartir pantalla"  
**O** cuando hago clic en "Detener" en el diálogo del navegador  
**Entonces** mi pantalla deja de compartirse inmediatamente  
**Y** el video de cámara vuelve a ser la vista principal para el estudiante  
**Y** el estudiante ve una notificación: "El tutor dejó de compartir pantalla"  
**Y** el botón "Compartir Pantalla" vuelve a estar disponible

### Escenario 4: Estudiante intenta compartir pantalla (no permitido por defecto)

**Dado que** soy un estudiante en una sesión  
**Cuando** veo la barra de controles  
**Entonces** **no veo** el botón "Compartir Pantalla" (solo visible para tutores)  
**Y** si el tutor habilita la opción "Permitir al estudiante compartir pantalla" durante la sesión  
**Entonces** el botón aparece para mí y puedo usarlo

### Escenario 5: Compartir pantalla con audio del sistema (avanzado)

**Dado que** voy a compartir una pestaña de Chrome con un video de YouTube  
**Cuando** selecciono la pestaña en el diálogo de compartir pantalla  
**Entonces** veo un checkbox "Compartir audio de la pestaña"  
**Y** si lo marco, el estudiante escucha el audio del video además de mi micrófono  
**Y** veo un indicador "🔊 Compartiendo audio del sistema"

### Escenario 6: Manejo de error de permisos denegados

**Dado que** hago clic en "Compartir Pantalla"  
**Cuando** deniego el permiso en el diálogo del navegador o cancelo  
**Entonces** veo un mensaje: "No se pudo compartir pantalla. Verifica los permisos"  
**Y** el botón "Compartir Pantalla" sigue disponible para reintentar  
**Y** no se afecta la videollamada en curso

### Escenario 7: Calidad adaptativa por ancho de banda

**Dado que** estoy compartiendo pantalla  
**Cuando** el sistema detecta ancho de banda bajo (<1 Mbps)  
**Entonces** la resolución de pantalla compartida se reduce automáticamente a 480p  
**Y** el framerate baja de 30fps a 15fps para evitar lag  
**Y** veo una notificación: "Calidad reducida por conexión lenta"

## 🔗 Trazabilidad

- **Módulo:** Videollamadas
- **Épica:** Herramientas de Enseñanza Virtual
- **Requisito Funcional:** RF-050 (Compartir pantalla)
- **Requisito No Funcional:** 
  - RNF-PERF-002: Latencia de transmisión de pantalla <3 segundos
  - RNF-UX-001: Indicadores visuales claros de estado de compartir pantalla
- **Prioridad:** SHOULD HAVE (Release 1.1)

## 📊 Estimación

- **Story Points:** 5
- **Esfuerzo Estimado:** 2-3 días
- **Complejidad:** Media (API nativa, pero integración con WebRTC existente)

**Desglose técnico:**
- Frontend (botón + lógica de screen share): 1 día
- Integración con SDK WebRTC (transmisión de stream): 0.5 días
- Backend (logs de uso de screen share): 0.5 días
- Testing (permisos, resoluciones, cross-browser): 1 día

## 🔄 Dependencias

- **Depende de:** 
  - HU-040 (Iniciar sesión de video) - debe existir una videollamada activa
  - Navegador con soporte de `getDisplayMedia()` API
- **Bloquea a:** 
  - HU-044 (Pizarra colaborativa) - compartir pantalla es previo
  - HU-045 (Anotar sobre pantalla compartida)
- **Relacionada con:** 
  - HU-043 (Chat en sesión) - usar chat para complementar explicación de pantalla

## 🧪 Notas de Testing

**Casos de prueba críticos:**
1. **Happy path:** Tutor comparte VS Code, estudiante lo ve en 1080p
2. **Múltiples ventanas:** Compartir ventana específica vs. pantalla completa
3. **Audio del sistema:** Compartir pestaña con YouTube + audio
4. **Permisos denegados:** Cancelar diálogo de compartir pantalla
5. **Detener y reiniciar:** Compartir → Detener → Compartir de nuevo
6. **Ancho de banda bajo:** Simular 3G y verificar degradación de calidad
7. **Cross-browser:** Chrome (principal), Firefox, Edge

**Datos de prueba requeridos:**
- Sesión de videollamada activa (staging)
- Usuario con rol "tutor"
- Contenido de prueba: documento PDF, ventana de código

**Herramientas de testing:**
- **Manual:** Observar latencia y calidad de pantalla compartida
- **E2E:** Playwright con mock de `getDisplayMedia()`
- **Performance:** Medir FPS y latencia con Network tab

## 🎨 Notas de Diseño

**Botón en barra de controles:**
```
[🎤] [📷] [💬] [📋 Compartir Pantalla] [📞]
```

**Banner cuando está compartiendo:**
```
┌─────────────────────────────────────────────┐
│ 🔴 Estás compartiendo pantalla - Detener   │
└─────────────────────────────────────────────┘
```

**Vista del estudiante:**
```
┌─────────────────────────────────────────┐
│ 🖥️ Pantalla compartida por [Tutor]      │
│                                          │
│    ┌──────────────────────────────┐     │
│    │                              │     │
│    │   Pantalla del Tutor         │     │
│    │   (VS Code con código)       │     │
│    │                              │     │
│    │     ┌────────┐               │     │
│    │     │Video   │ (PiP)         │     │
│    │     │Tutor   │               │     │
│    │     └────────┘               │     │
│    └──────────────────────────────┘     │
│                                          │
│    [🔍 Zoom] [-] [+]                     │
└─────────────────────────────────────────┘
```

## ⚠️ Riesgos y Supuestos

**Supuestos:**
- Navegador con API `getDisplayMedia()` (Chrome 72+, Firefox 66+, Edge 79+, Safari 13+)
- El tutor tiene contenido adecuado para compartir (no sensible)
- Ancho de banda suficiente para transmitir pantalla (mínimo 1.5 Mbps)

**Riesgos:**
- **Medio:** Safari en macOS requiere permisos adicionales de "Grabación de Pantalla" en System Preferences
- **Medio:** Compartir pantalla 4K consume mucho ancho de banda → Limitar a 1080p máximo
- **Bajo:** Tutor comparte accidentalmente información sensible (contraseñas, emails) → Warning en UI

**Preguntas abiertas:**
- ¿Permitir al estudiante también compartir pantalla? (para mostrar ejercicios)
- ¿Grabar automáticamente cuando se comparte pantalla?
- ¿Límite de tiempo de pantalla compartida?

## ✔️ Definition of Done (DoD)

- [ ] Código desarrollado y code review aprobado
- [ ] Tests unitarios escritos y pasando (>80% cobertura)
- [ ] Tests E2E para compartir pantalla en Chrome y Firefox
- [ ] Validación de permisos del navegador manejada correctamente
- [ ] Criterios de aceptación validados por PO (demo con tutor real)
- [ ] Documentación técnica actualizada (guía de uso de API)
- [ ] Sin errores críticos o de seguridad
- [ ] Desplegado en staging y probado por QA
- [ ] Demo realizada con stakeholders
- [ ] Cumple estándares de performance (latencia <3s, framerate >15fps)

## 📌 Etiquetas (Tags)

`#modulo-videollamadas` `#release-1.1` `#prioridad-media` `#webrtc` `#frontend` `#herramientas-enseñanza`

---

**Última actualización:** 2025-11-08  
**Autor:** Product Owner Senior - CEIBA v1.2  
**Revisores:** Tech Lead (WebRTC), UX Designer
