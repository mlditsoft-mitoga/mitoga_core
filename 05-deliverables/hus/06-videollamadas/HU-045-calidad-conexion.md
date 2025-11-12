# HU-045: Indicador de Calidad de Conexión

## 📋 Historia de Usuario

**Como** participante en una sesión de videollamada,  
**Quiero** ver un indicador de la calidad de mi conexión de red en tiempo real,  
**Para** saber si tengo problemas de conectividad que afecten la experiencia.

## 🎯 Valor de Negocio

Un indicador de calidad de conexión **previene frustraciones** al hacer visible la causa de problemas técnicos (lag, audio cortado, video pixelado). Reduce tickets de soporte y mejora la satisfacción del usuario.

**Impacto:** Tickets de soporte técnico -30%, NPS +5 puntos (transparencia)

## 📝 Descripción Detallada

Indicador de 3 niveles (verde/amarillo/rojo) visible en la interfaz de videollamada. Basado en métricas de WebRTC: packet loss, latencia (RTT), bitrate, jitter. Se actualiza cada 2 segundos. Si la conexión se degrada, muestra sugerencias: "Intenta cerrar otras aplicaciones" o "Conéctate a WiFi en lugar de datos móviles".

## ✅ Criterios de Aceptación

### Escenario 1: Conexión excelente (Verde)

**Dado que** estoy en una sesión con buena conexión de red  
**Cuando** el sistema mide mi calidad de red  
**Entonces** veo un icono verde (📶) con texto "Excelente" en la esquina superior izquierda  
**Y** las métricas son: Latencia <100ms, Packet Loss <1%, Bitrate >2 Mbps

### Escenario 2: Conexión inestable (Amarillo)

**Dado que** mi conexión se vuelve inestable (WiFi débil)  
**Cuando** el sistema detecta degradación  
**Entonces** el icono cambia a amarillo (📶) con texto "Inestable"  
**Y** veo un tooltip: "Tu conexión es débil. Considera acercarte al router"  
**Y** las métricas son: Latencia 100-300ms, Packet Loss 1-5%

### Escenario 3: Conexión pobre (Rojo)

**Dado que** mi conexión es muy mala (datos móviles 3G)  
**Cuando** el sistema detecta problemas severos  
**Entonces** el icono cambia a rojo (📵) con texto "Pobre"  
**Y** veo una alerta: "⚠️ Tu conexión es inestable. La calidad de video se ha reducido"  
**Y** el sistema reduce automáticamente la resolución a 360p para compensar  
**Y** las métricas son: Latencia >300ms, Packet Loss >5%

### Escenario 4: Ver detalles técnicos de la conexión

**Dado que** quiero más información sobre mi conexión  
**Cuando** hago clic en el indicador de calidad  
**Entonces** se abre un modal con detalles técnicos:
- Latencia (RTT): 85ms
- Packet Loss: 0.5%
- Bitrate entrante: 2.5 Mbps
- Bitrate saliente: 1.8 Mbps
- Resolución actual: 720p @ 30fps
- Codec: VP8/Opus

### Escenario 5: Sugerencias automáticas de mejora

**Dado que** mi conexión es inestable por varios minutos  
**Cuando** el sistema detecta el patrón  
**Entonces** veo un banner con sugerencias:
- "Cierra otras pestañas o aplicaciones que usen internet"
- "Desconecta otros dispositivos del WiFi"
- "Conéctate con cable Ethernet si es posible"
**Y** tengo un botón "Rehacer test de velocidad"

## 🔗 Trazabilidad

- **Módulo:** Videollamadas
- **Épica:** Calidad de Experiencia
- **Requisito Funcional:** RF-052 (Indicador de calidad)
- **Requisito No Funcional:** RNF-RELIAB-001 (Detección automática de problemas)
- **Prioridad:** SHOULD HAVE (Release 1.1)

## 📊 Estimación

- **Story Points:** 3
- **Esfuerzo Estimado:** 1-2 días
- **Complejidad:** Baja (métricas disponibles en WebRTC Stats API)

## 🔄 Dependencias

- **Depende de:** HU-040 (Videollamadas activas)
- **Bloquea a:** HU-060 (Notificar problemas de conexión por email)
- **Relacionada con:** HU-041 (Compartir pantalla - afecta calidad)

## 🧪 Notas de Testing

1. **Simulación de red:** Chrome DevTools Network Throttling (3G, 4G, Offline)
2. **Packet loss:** Agregar latencia artificial con `tc` (Linux) o Charles Proxy
3. **Precisión de métricas:** Comparar con Wireshark
4. **Actualización en tiempo real:** Verificar refresco cada 2 segundos

## ⚠️ Riesgos y Supuestos

**Supuestos:** WebRTC Stats API disponible (Chrome/Firefox), actualización no afecta performance  
**Riesgos:** **Bajo** - Medición de stats puede consumir CPU extra en dispositivos antiguos

## ✔️ Definition of Done

- [ ] Indicador de 3 niveles (verde/amarillo/rojo) visible
- [ ] Métricas de WebRTC Stats API integradas
- [ ] Sugerencias automáticas implementadas
- [ ] Tests con network throttling
- [ ] Documentación de umbrales de calidad

## 📌 Etiquetas

`#modulo-videollamadas` `#release-1.1` `#prioridad-media` `#ux` `#monitoring` `#webrtc-stats`

---

**Última actualización:** 2025-11-08  
**Autor:** Product Owner Senior - CEIBA v1.2
