# HU-063: Moderar Reseñas y Reportes

## 📋 Historia de Usuario

**Como** administrador,  
**Quiero** revisar reseñas reportadas por inapropiadas,  
**Para** mantener un ambiente seguro y profesional en la plataforma.

## 🎯 Valor de Negocio

Moderación de contenido protege la reputación de la plataforma y cumple con términos de servicio.

**Impacto:** Reducción de contenido inapropiado 95%, Confianza aumentada

## 📝 Descripción Detallada

Cola de reseñas reportadas por usuarios (motivos: lenguaje ofensivo, spam, información falsa). Admin puede: Ver reseña completa, Ver contexto (sesión, usuarios involucrados), Acciones: Aprobar (mantener visible), Ocultar, Eliminar, Banear usuario si es reincidente.

## ✅ Criterios de Aceptación

### Escenario 1: Ver lista de reseñas reportadas

**Dado que** soy admin  
**Cuando** navego a "Moderación" → "Reseñas Reportadas"  
**Entonces** veo tabla con: Fecha Reporte, Usuario que reportó, Reseña, Motivo, Estado (Pendiente/Revisada)  
**Y** puedo filtrar por motivo: Ofensivo, Spam, Falso, Otro

### Escenario 2: Revisar contexto de una reseña

**Cuando** clic en reseña reportada: "Este tutor es un fraude"  
**Entonces** veo:
- Reseña completa con calificación
- Sesión asociada (fecha, materia, duración)
- Perfil del estudiante que escribió la reseña
- Perfil del tutor reseñado
- Motivo del reporte: "Información falsa"
- Historial de reseñas del estudiante (para ver si es spam recurrente)

### Escenario 3: Ocultar reseña inapropiada

**Cuando** determino que la reseña contiene lenguaje ofensivo  
**Y** hago clic en [Ocultar Reseña]  
**Entonces** la reseña se oculta del perfil público del tutor  
**Y** se envía email al estudiante: "Tu reseña fue ocultada. Motivo: lenguaje inapropiado. Políticas: [link]"  
**Y** la calificación numérica (estrellas) se mantiene, solo el texto se oculta

### Escenario 4: Eliminar reseña y ajustar rating

**Cuando** determino que la reseña es spam (estudiante nunca tuvo sesión con ese tutor)  
**Y** hago clic en [Eliminar Reseña]  
**Entonces** se elimina completamente de la BD  
**Y** el rating promedio del tutor se recalcula sin esa reseña  
**Y** se envía notificación al tutor: "Una reseña falsa fue eliminada de tu perfil"

### Escenario 5: Banear usuario por spam recurrente

**Dado que** un estudiante ha escrito 5 reseñas spam en una semana  
**Cuando** reviso su historial y confirmo patrón de abuso  
**Y** hago clic en [Banear Usuario]  
**Entonces** el usuario queda suspendido permanentemente  
**Y** todas sus reseñas se marcan como "De usuario baneado" (ocultas)  
**Y** no puede crear nueva cuenta con mismo email

## 🔗 Trazabilidad

- **Módulo:** Admin
- **RF:** RF-071 (Moderar reseñas)
- **Prioridad:** SHOULD HAVE

## 📊 Estimación

- **Story Points:** 5
- **Complejidad:** Media

## 🔄 Dependencias

- Depende de: HU-015 (Sistema de reseñas), HU-062 (Gestionar usuarios)
- Relacionada con: HU-064 (Resolver disputas)

## 🧪 Testing

- Reportar reseña: Flujo de usuario normal
- Ocultar: Verificar no visible en perfil público
- Recalcular rating: Matemática correcta
- Baneo: Usuario no puede login

## 📌 Etiquetas

`#admin` `#moderacion` `#reseñas` `#contenido` `#release-1.1`
