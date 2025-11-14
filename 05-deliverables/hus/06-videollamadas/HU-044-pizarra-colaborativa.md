# HU-044: Pizarra Colaborativa

## 📋 Historia de Usuario

**Como** tutor enseñando matemáticas o conceptos visuales,  
**Quiero** usar una pizarra digital compartida durante la sesión,  
**Para** dibujar diagramas, resolver ecuaciones o explicar conceptos gráficamente en tiempo real.

## 🎯 Valor de Negocio

La pizarra colaborativa es **crítica para tutorías de STEM** (matemáticas, física, química, ingeniería). Permite explicaciones visuales que son imposibles solo con audio/video.

**Impacto:** Tutores STEM +50% de adopción, NPS aumentado 20 puntos en categoría matemáticas

## 📝 Descripción Detallada

Herramienta de whiteboard integrada (Excalidraw embed o Tldraw). Ambos participantes ven el canvas en tiempo real. Herramientas: lápiz, formas (rectángulo, círculo, flecha), texto, borrador, paleta de colores. Exportar como PNG al finalizar. Integrado en la interfaz de videollamada (panel lateral o modo picture-in-picture).

## ✅ Criterios de Aceptación

### Escenario 1: Abrir pizarra colaborativa

**Dado que** estoy en una sesión de videollamada como tutor  
**Cuando** hago clic en el botón "Pizarra" (🖊️) en la barra de controles  
**Entonces** se abre un panel lateral de 600px con canvas blanco  
**Y** veo herramientas: [Lápiz] [Formas] [Texto] [Borrador] [Colores] [Limpiar]  
**Y** el estudiante ve la misma pizarra sincronizada en tiempo real  
**Y** los videos de cámara se reducen a PiP (esquina superior derecha)

### Escenario 2: Dibujar y sincronizar en tiempo real

**Dado que** la pizarra está abierta  
**Cuando** dibujo una ecuación: "x² + 5x + 6 = 0" con la herramienta de texto  
**Y** dibujo paréntesis con el lápiz: (x + 2)(x + 3)  
**Entonces** el estudiante ve mis trazos en tiempo real con latencia <500ms  
**Y** si el estudiante también dibuja, veo sus trazos en color diferente (azul vs. rojo)

### Escenario 3: Usar formas geométricas

**Dado que** quiero dibujar un triángulo  
**Cuando** selecciono la herramienta "Formas" → "Triángulo"  
**Y** hago clic y arrastro en el canvas  
**Entonces** se dibuja un triángulo perfecto con bordes suavizados  
**Y** puedo ajustar su tamaño con handles de redimensionamiento  
**Y** el estudiante ve la forma sincronizada

### Escenario 4: Cambiar color del trazo

**Dado que** estoy dibujando en la pizarra  
**Cuando** hago clic en la paleta de colores y selecciono "Rojo"  
**Entonces** todos mis nuevos trazos aparecen en rojo  
**Y** los trazos anteriores mantienen su color original  
**Y** el estudiante ve el nuevo color en sus pantalla

### Escenario 5: Limpiar pizarra

**Dado que** la pizarra tiene contenido dibujado  
**Cuando** hago clic en "Limpiar todo"  
**Entonces** veo un diálogo de confirmación: "¿Borrar toda la pizarra? No se puede deshacer"  
**Y** si confirmo, la pizarra queda en blanco para ambos participantes  
**Y** veo una notificación: "Pizarra limpiada"

### Escenario 6: Exportar pizarra como imagen

**Dado que** terminamos de resolver un ejercicio en la pizarra  
**Cuando** hago clic en "Exportar" (icono 💾)  
**Entonces** se descarga un archivo PNG con el contenido de la pizarra  
**Y** el nombre del archivo es: "pizarra-[fecha]-[hora].png"  
**Y** la imagen se adjunta automáticamente al historial de la sesión

## 🔗 Trazabilidad

- **Módulo:** Videollamadas
- **Épica:** Herramientas de Enseñanza
- **Requisito Funcional:** RF-044 (Pizarra colaborativa)
- **Requisito No Funcional:** RNF-PERF-004 (Sincronización <500ms), RNF-UX-002 (Intuitiva para no técnicos)
- **Prioridad:** SHOULD HAVE (Release 1.1)

## 📊 Estimación

- **Story Points:** 8
- **Esfuerzo Estimado:** 4-5 días
- **Complejidad:** Alta (canvas WebGL + sincronización en tiempo real)

## 🔄 Dependencias

- **Depende de:** HU-040 (Videollamadas), Librería Excalidraw/Tldraw, Socket.io
- **Bloquea a:** HU-045 (Anotar sobre pantalla compartida)
- **Relacionada con:** HU-041 (Compartir pantalla), HU-042 (Chat)

## 🧪 Notas de Testing

1. **Latencia de trazos:** <500ms en red 4G
2. **Múltiples usuarios:** Ambos dibujan simultáneamente sin colisiones
3. **Performance:** 1000 trazos en canvas sin lag
4. **Export:** PNG de 1920x1080, <2MB de tamaño
5. **Mobile:** Funciona en iPad (touch) - opcional Release 1.2

## ⚠️ Riesgos y Supuestos

**Supuestos:** Excalidraw bajo MIT license (libre uso), WebGL soportado (Chrome, Firefox)  
**Riesgos:** 
- **Medio:** Sincronización de trazos complejos puede causar lag en redes lentas
- **Bajo:** Safari puede tener issues con WebGL

## ✔️ Definition of Done

- [ ] Pizarra colaborativa funcional con Excalidraw/Tldraw
- [ ] Sincronización en tiempo real <500ms
- [ ] Export de PNG funcional
- [ ] Herramientas básicas (lápiz, formas, texto, borrador)
- [ ] Tests E2E de dibujo colaborativo
- [ ] Documentación de integración

## 📌 Etiquetas

`#modulo-videollamadas` `#release-1.1` `#prioridad-alta` `#whiteboard` `#canvas` `#tiempo-real` `#stem`

---

**Última actualización:** 2025-11-08  
**Autor:** Product Owner Senior - ZNS v2.0
