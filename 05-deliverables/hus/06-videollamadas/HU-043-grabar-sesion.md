# HU-043: Grabar Sesión (Opcional)

## 📋 Historia de Usuario

**Como** estudiante que desea repasar la sesión,  
**Quiero** grabar la videollamada con consentimiento del tutor,  
**Para** ver la explicación nuevamente después de la clase.

## 🎯 Valor de Negocio

La grabación de sesiones es un **diferenciador competitivo** que aumenta el valor percibido de la plataforma. Estudiantes valoran poder repasar explicaciones complejas.

**Impacto:** Valor percibido +30%, Justifica precios premium, Retención aumentada

## 📝 Descripción Detallada

Botón "Grabar" disponible solo para estudiantes (o tutor si ofrece). Requiere consentimiento explícito del otro participante antes de iniciar. Grabación procesada en backend (Agora Cloud Recording o AWS Kinesis Video Streams). Almacenada en S3 con link privado disponible 30 días. Descarga en MP4.

## ✅ Criterios de Aceptación

### Escenario 1: Solicitar grabación con consentimiento

**Dado que** soy un estudiante en una sesión activa  
**Cuando** hago clic en el botón "Grabar" (🔴)  
**Entonces** el sistema envía una solicitud al tutor: "[Estudiante] quiere grabar la sesión. ¿Aceptas?"  
**Y** el tutor ve botones [Aceptar] [Rechazar]  
**Y** si acepta, la grabación inicia con indicador "🔴 REC" visible para ambos  
**Y** si rechaza, veo mensaje: "El tutor no autorizó la grabación"

### Escenario 2: Detener grabación

**Dado que** estoy grabando la sesión  
**Cuando** hago clic en "Detener grabación"  
**Entonces** la grabación se detiene  
**Y** veo un mensaje: "Grabación guardada. Estará disponible en 5-10 minutos"  
**Y** ambos participantes ven notificación: "La grabación ha terminado"

### Escenario 3: Acceder a grabación después de la sesión

**Dado que** la sesión terminó y fue grabada  
**Cuando** accedo a "Mis Reservas" → Detalle de la sesión  
**Entonces** veo un botón "Ver Grabación" con estado "⏳ Procesando..." (si aún está procesando)  
**O** veo "▶️ Ver Grabación" (si ya está lista)  
**Y** al hacer clic, se abre un reproductor de video con la sesión completa  
**Y** tengo botón "Descargar (MP4)"

### Escenario 4: Tutor revoca acceso a grabación

**Dado que** el tutor quiere eliminar una grabación por contenido sensible  
**Cuando** solicita al soporte eliminar la grabación  
**Entonces** el estudiante pierde acceso y ve: "Grabación no disponible (eliminada)"

## 🔗 Trazabilidad

- **Módulo:** Videollamadas
- **Épica:** Herramientas Avanzadas
- **Requisito Funcional:** RF-051 (Grabación de sesión)
- **Requisito No Funcional:** RNF-PRIV-001 (Consentimiento explícito), RNF-STOR-001 (Retención 30 días)
- **Prioridad:** COULD HAVE (Release 1.2)

## 📊 Estimación

- **Story Points:** 8
- **Esfuerzo Estimado:** 4-5 días
- **Complejidad:** Alta (procesamiento de video en backend)

## 🔄 Dependencias

- **Depende de:** HU-040 (Videollamadas), Agora Cloud Recording API o AWS Kinesis
- **Bloquea a:** HU-077 (Analítica de sesiones con IA - transcripciones)
- **Relacionada con:** HU-036 (Historial de pagos - cobro extra por grabación)

## 🧪 Notas de Testing

1. **Consentimiento:** Tutor rechaza → No se graba
2. **Calidad de video:** 720p, audio clear
3. **Duración:** Sesión de 2 horas → MP4 de ~1GB
4. **Expiración:** Verificar borrado automático después de 30 días
5. **Privacidad:** Link no debe ser compartible (autenticación requerida)

## ⚠️ Riesgos y Supuestos

**Supuestos:** Consentimiento verbal no es suficiente, requiere clic explícito  
**Riesgos:** 
- **Alto:** Costos de almacenamiento (S3: $0.023/GB/mes, 1 sesión = 1GB promedio)
- **Medio:** Compliance GDPR/LGPD (derecho al olvido, borrado a pedido)

## ✔️ Definition of Done

- [ ] Flujo de consentimiento implementado
- [ ] Integración con Agora Cloud Recording
- [ ] Almacenamiento en S3 con lifecycle policy (30 días)
- [ ] Reproductor de video funcional
- [ ] Tests de procesamiento de video
- [ ] Documentación de políticas de grabación

## 📌 Etiquetas

`#modulo-videollamadas` `#release-1.2` `#prioridad-baja` `#grabacion` `#cloud-storage` `#compliance`

---

**Última actualización:** 2025-11-08  
**Autor:** Product Owner Senior - CEIBA v1.2
