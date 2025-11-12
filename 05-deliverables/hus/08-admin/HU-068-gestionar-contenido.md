# HU-068: Gestionar Contenido y Anuncios de la Plataforma

## 📋 Historia de Usuario

**Como** administrador de contenido,  
**Quiero** gestionar banners, anuncios y contenido promocional de la plataforma,  
**Para** comunicar novedades, promociones y mensajes importantes a los usuarios.

## 🎯 Valor de Negocio

Capacidad de comunicar promociones y novedades sin necesidad de desplegar código nuevo.

**Impacto:** Time-to-market de campañas reducido 80%, Engagement aumentado 15%

## 📝 Descripción Detallada

CMS simple para gestionar: Banners del home (sliders), Anuncios de mantenimiento, Pop-ups promocionales, Mensajes del sistema (info, warning, error), Páginas de contenido (FAQ, Términos). Editor WYSIWYG o markdown. Programación de publicación (fecha inicio/fin). Segmentación de audiencia (todos, solo estudiantes, solo tutores, por región).

## ✅ Criterios de Aceptación

### Escenario 1: Crear banner promocional

**Cuando** navego a "Contenido" → "Banners"  
**Y** hago clic en [Crear Nuevo Banner]  
**Entonces** veo formulario con:
- Título: "¡20% de descuento en tutorías de programación!"
- Descripción breve
- Imagen de banner (upload, 1920x400px recomendado)
- Link de acción: "/marketplace?category=programacion"
- Texto del botón: "Ver Tutores"
- Audiencia: Todos | Solo Estudiantes | Solo Tutores
- Fecha inicio: 10/11/2025
- Fecha fin: 17/11/2025
- Estado: Activo | Borrador

### Escenario 2: Banner se muestra en home

**Dado que** creé banner promocional activo  
**Cuando** un estudiante visita el home  
**Entonces** ve el banner en el slider principal  
**Y** al hacer clic en "Ver Tutores" lo redirige a marketplace filtrado

### Escenario 3: Programar anuncio de mantenimiento

**Cuando** planeo mantenimiento del 15/11 00:00-02:00  
**Y** creo anuncio de tipo "Mantenimiento Programado"  
**Entonces** se muestra banner amarillo en toda la plataforma:
- "⚠️ Mantenimiento Programado: 15/11 00:00-02:00 AM. La plataforma no estará disponible"
**Y** el banner desaparece automáticamente después del mantenimiento

### Escenario 4: Pop-up de bienvenida para nuevos usuarios

**Cuando** creo pop-up con:
- Título: "¡Bienvenido a MI-TOGA! 🎉"
- Contenido: "Obtén $20,000 de descuento en tu primera sesión. Usa código: BIENVENIDO20"
- Audiencia: Solo nuevos usuarios (menos de 7 días registrados)
- Frecuencia: Mostrar 1 vez por usuario
**Entonces** el pop-up se muestra al nuevo usuario al entrar  
**Y** después de cerrarlo, no vuelve a aparecer

### Escenario 5: Editar página de FAQ

**Cuando** navego a "Contenido" → "Páginas" → "FAQ"  
**Y** uso el editor markdown para agregar nueva pregunta:
```markdown
## ¿Cómo cancelo una sesión?
Puedes cancelar hasta 24 horas antes sin penalidad...
```
**Y** hago clic en [Guardar]  
**Entonces** la página `/faq` se actualiza inmediatamente  
**Y** los usuarios ven el nuevo contenido

### Escenario 6: Segmentar anuncio por región

**Cuando** creo banner promocional:
- Título: "Tutores en Bogotá: 15% descuento"
- Audiencia: Solo usuarios en Bogotá
**Entonces** el banner solo se muestra a usuarios con ciudad = Bogotá  
**Y** usuarios de otras ciudades no lo ven

## 🔗 Trazabilidad

- **Módulo:** Admin
- **RF:** RF-077 (Gestión de contenido)
- **Prioridad:** SHOULD HAVE

## 📊 Estimación

- **Story Points:** 5
- **Complejidad:** Media (CMS + editor + segmentación)

## 🔄 Dependencias

- Depende de: Sistema de usuarios (para segmentación)
- Relacionada con: HU-010 (Marketplace - muestra banners)

## 🧪 Testing

- Programación: Banner se activa/desactiva en fechas correctas
- Segmentación: Solo audiencia target ve contenido
- WYSIWYG: Editor funciona correctamente
- Performance: Carga de banners no afecta velocidad

## 📌 Etiquetas

`#admin` `#cms` `#contenido` `#marketing` `#banners` `#release-1.1`

---

**Última actualización:** 2025-11-08  
**Autor:** Product Owner Senior - CEIBA v1.2
