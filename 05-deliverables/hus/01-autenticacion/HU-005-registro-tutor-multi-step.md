# HU-005: Registro de Tutor con Proceso Multi-Step

## 📋 Historia de Usuario

**Como** tutor nuevo,  
**Quiero** completar un proceso de registro guiado en 4 pasos con mi experiencia laboral, conocimientos e idiomas,  
**Para** ofrecer mis servicios de tutoría y ser aprobado por el admin.

## 🎯 Valor de Negocio

- **Calidad:** Proceso robusto asegura tutores calificados
- **Confianza:** Verificación de experiencia aumenta credibilidad
- **Supply-side:** Onboarding efectivo para lado de oferta del marketplace

## 📝 Descripción Detallada

Tutor completa 4 pasos: (1) Experiencia laboral (formulario dinámico, múltiples experiencias), (2) Conocimientos (selector jerárquico de 3 niveles: categoría→subcategoría→tema), (3) Idiomas con nivel de dominio, (4) Resumen y envío para revisión admin.

**Estado actual:** ✅ UI implementada (714 líneas) | ❌ Backend + flujo aprobación admin pendiente

## ✅ Criterios de Aceptación

### Escenario 1: Registro exitoso de tutor

**Dado que** soy un tutor nuevo  
**Cuando** completo los 4 steps con al menos 1 experiencia laboral, 3 conocimientos y 1 idioma  
**Y** hago clic en "Enviar para revisión"  
**Entonces** el sistema crea mi perfil con estado "Pendiente aprobación"  
**Y** recibo email de confirmación  
**Y** el admin recibe notificación para revisar mi perfil  
**Y** veo mensaje "Tu perfil está en revisión. Te notificaremos por email"

### Escenario 2: Agregar múltiples experiencias laborales

**Dado que** estoy en Step 1 (Experiencia laboral)  
**Cuando** completo el formulario (empresa, cargo, fechas, descripción)  
**Y** hago clic en "Agregar experiencia"  
**Entonces** la experiencia se agrega a la lista  
**Y** puedo agregar otra experiencia  
**Y** puedo eliminar experiencias individualmente  
**Y** el sistema valida que fecha fin > fecha inicio

### Escenario 3: Selección de conocimientos jerárquicos

**Dado que** estoy en Step 2 (Conocimientos)  
**Cuando** expando "Matemáticas" → "Álgebra"  
**Entonces** veo temas específicos (Ecuaciones lineales, Sistemas de ecuaciones, etc.)  
**Cuando** selecciono 5 temas  
**Entonces** veo chips visuales de los conocimientos seleccionados  
**Y** puedo buscar por texto para filtrar conocimientos  
**Y** puedo eliminar conocimientos haciendo clic en la X del chip

### Escenario 4: Agregar idiomas con niveles

**Dado que** estoy en Step 3 (Idiomas)  
**Cuando** selecciono "Español" y nivel "Nativo"  
**Y** agrego "Inglés" con nivel "Avanzado"  
**Entonces** veo una lista con ambos idiomas y sus niveles  
**Y** el sistema valida que al menos 1 idioma esté seleccionado

### Escenario 5: Navegación entre steps con validación

**Dado que** estoy en Step 1 sin experiencias agregadas  
**Cuando** hago clic en "Siguiente"  
**Entonces** veo error "Debes agregar al menos una experiencia laboral"  
**Y** no puedo avanzar al Step 2  
**Cuando** agrego 1 experiencia válida y hago clic en "Siguiente"  
**Entonces** avanzo al Step 2

## 🔗 Trazabilidad

- **Módulo:** Autenticación / Perfiles
- **Épica:** Onboarding de Tutor
- **Requisito Funcional:** [RF-005] Registro de Tutor (Multi-Step)
- **Prioridad:** MUST HAVE

## 📊 Estimación

- **Story Points:** 13
- **Complejidad:** Alta

## 🔄 Dependencias

- **Depende de:** [HU-001] Estructura de auth
- **Bloquea a:** [HU-060] Aprobar tutores (admin)
- **Relacionada con:** [HU-071] Subir certificados

## ✔️ Definition of Done

- [ ] API POST /api/tutors/register
- [ ] Persistencia de experiencia laboral, conocimientos, idiomas
- [ ] Estado "Pendiente aprobación" creado
- [ ] Notificación a admin
- [ ] Tests E2E del flujo 4 steps
- [ ] KnowledgeSelector funcional

## 📌 Etiquetas

`#autenticacion` `#perfiles` `#tutores` `#mvp` `#must-have` `#onboarding`

---

**Última actualización:** 08/11/2025
