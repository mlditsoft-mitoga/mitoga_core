# HU-060: Aprobar o Rechazar Tutores Pendientes

## 📋 Historia de Usuario

**Como** administrador de la plataforma,  
**Quiero** revisar y aprobar/rechazar solicitudes de tutores nuevos,  
**Para** garantizar la calidad de los tutores en el marketplace.

## 🎯 Valor de Negocio

El proceso de verificación manual es **crítico para la calidad** del marketplace. Tutores no verificados pueden dañar la reputación de la plataforma.

**Impacto:** Calidad de tutores garantizada, Confianza de estudiantes aumentada, Reducción de disputas 40%

## 📝 Descripción Detallada

Panel de admin con lista de tutores en estado "En Revisión". Vista de detalle con datos del perfil, documentos adjuntos (títulos, certificados, ID). Acciones: Aprobar (cambia estado a "Activo"), Rechazar con motivo (email automático al tutor), Solicitar más información. Filtros por fecha de solicitud, especialidad.

## ✅ Criterios de Aceptación

### Escenario 1: Ver lista de tutores pendientes de aprobación

**Dado que** soy un administrador autenticado  
**Cuando** navego a "Admin" → "Tutores Pendientes"  
**Entonces** veo una tabla con columnas: Foto, Nombre, Email, Especialidad, Fecha Solicitud, Estado, Acciones  
**Y** cada fila tiene botones: [Ver Detalles] [Aprobar] [Rechazar]  
**Y** veo contador: "15 tutores pendientes de revisión"

### Escenario 2: Revisar detalle de un tutor

**Dado que** quiero revisar la solicitud de "Juan Pérez"  
**Cuando** hago clic en [Ver Detalles]  
**Entonces** se abre una vista completa con:
- Datos personales: Nombre, email, teléfono, ciudad
- Experiencia laboral (lista de trabajos previos)
- Educación y certificaciones
- Especialidades declaradas
- Idiomas
- Documentos adjuntos: [📄 Título Universitario.pdf] [📄 Cédula Frontal.jpg] [📄 Cédula Trasera.jpg]
**Y** puedo descargar cada documento para verificación externa

### Escenario 3: Aprobar tutor exitosamente

**Dado que** revisé el perfil y documentos de Juan Pérez y todo está correcto  
**Cuando** hago clic en [Aprobar]  
**Entonces** veo diálogo de confirmación: "¿Aprobar a Juan Pérez como tutor? Recibirá un email de bienvenida"  
**Y** al confirmar:
- Estado del tutor cambia a "Activo"
- Se envía email automático: "¡Felicidades! Tu perfil fue aprobado"
- El tutor aparece ahora en el marketplace
- Se registra en audit log: "Admin [nombre] aprobó tutor ID 123 el 08/11/2025"

### Escenario 4: Rechazar tutor con motivo

**Dado que** los documentos de María García son ilegibles  
**Cuando** hago clic en [Rechazar]  
**Entonces** se abre un modal con:
- Campo de texto obligatorio: "Motivo del rechazo" (200 caracteres mín)
- Checkboxes de motivos comunes: "Documentos ilegibles", "Sin experiencia verificable", "Datos incompletos"
- Botón [Enviar Rechazo]
**Y** al enviar:
- Estado cambia a "Rechazado"
- Email automático con motivo: "Tu solicitud fue rechazada. Motivo: [motivo]. Puedes corregir y volver a aplicar"
- Tutor puede editar su perfil y volver a enviar para revisión

### Escenario 5: Solicitar información adicional

**Dado que** faltan certificados en la solicitud de Pedro López  
**Cuando** hago clic en [Solicitar Info]  
**Entonces** puedo escribir un mensaje personalizado  
**Y** se envía email al tutor: "El equipo de MI-TOGA requiere información adicional: [mensaje]"  
**Y** el estado cambia a "Info Solicitada"  
**Y** cuando el tutor actualiza su perfil, el estado vuelve a "En Revisión"

## 🔗 Trazabilidad

- **Módulo:** Admin
- **Épica:** Gestión de Calidad de Tutores
- **Requisito Funcional:** RF-070 (Aprobar/rechazar tutores)
- **Prioridad:** MUST HAVE (Release 1.0)

## 📊 Estimación

- **Story Points:** 8
- **Esfuerzo Estimado:** 3-4 días
- **Complejidad:** Alta (flujo complejo con estados, emails, audit log)

## 🔄 Dependencias

- **Depende de:** HU-005 (Registro de tutor), Sistema de roles (admin)
- **Bloquea a:** HU-012 (Ver perfil de tutor - solo tutores aprobados)
- **Relacionada con:** HU-061 (Moderar reseñas)

## 🧪 Notas de Testing

1. **Flujo de aprobación:** Tutor en revisión → Admin aprueba → Tutor recibe email → Aparece en marketplace
2. **Flujo de rechazo:** Motivo obligatorio, email enviado, no aparece en marketplace
3. **Solicitar info:** Email enviado, estado cambia, puede re-enviar
4. **Audit log:** Todas las acciones quedan registradas con admin ID y timestamp
5. **Permisos:** Solo rol "admin" puede acceder a este panel

## ⚠️ Riesgos y Supuestos

**Supuestos:** Máquina de estados: En Revisión → Aprobado/Rechazado/Info Solicitada  
**Riesgos:** **Medio** - Backlog de tutores pendientes si admin no revisa regularmente → Alerting con más de 20 pendientes

## ✔️ Definition of Done

- [ ] Panel de admin funcional
- [ ] Estados de tutor implementados
- [ ] Emails de aprobación/rechazo
- [ ] Audit log de acciones
- [ ] Tests de flujos completos
- [ ] Documentación de proceso de aprobación

## 📌 Etiquetas

`#modulo-admin` `#release-1.0` `#prioridad-alta` `#moderacion` `#calidad` `#workflow`

---

**Última actualización:** 2025-11-08  
**Autor:** Product Owner Senior - CEIBA v1.2
