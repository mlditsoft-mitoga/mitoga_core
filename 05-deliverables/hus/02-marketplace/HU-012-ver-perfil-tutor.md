# HU-012: Ver perfil completo de tutor

**Épica:** Marketplace | **Rol:** Estudiante | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia de Usuario

> **Como** estudiante,  
> **quiero** ver el perfil detallado de un tutor (experiencia, reseñas, disponibilidad),  
> **para** tomar una decisión informada antes de reservar.

---

## 💼 Valor de Negocio

- **Trust building:** Perfiles completos aumentan confianza ~50% (benchmark Airbnb)
- **Conversión:** 70% de reservas ocurren después de ver perfil completo
- **Diferenciación:** Tutores destacan experiencia única (vs solo foto y precio)

---

## ✅ Criterios de Aceptación

### **Escenario 1: Ver perfil desde búsqueda**
```gherkin
Given el estudiante está en /marketplace/resultados
When hace clic en "Ver perfil" de un tutor
Then el sistema:
  - Redirige a /tutores/{tutor_id}/perfil
  - Muestra modal o página completa con:
    * Foto grande + nombre + badge "Verificado"
    * Rating promedio (⭐ 4.8) + # reseñas (24 opiniones)
    * Precio por hora ($18.000)
    * Video presentación (si disponible)
    * Descripción "Sobre mí" (500 chars)
    * Experiencia laboral (lista cronológica)
    * Materias que enseña (tags)
    * Idiomas (Español Nativo, Inglés Avanzado)
    * Últimas 5 reseñas con ratings
    * Calendario de disponibilidad (próximos 7 días)
    * Botón CTA "Reservar sesión"
```

### **Escenario 2: Ver reseñas completas**
```gherkin
Given el perfil muestra "24 opiniones"
When hace clic en "Ver todas las reseñas"
Then el sistema:
  - Muestra modal con lista paginada (10 por página)
  - Cada reseña incluye: rating ⭐, comentario, nombre estudiante, fecha
  - Filtros: "Más recientes", "Mejor valoradas", "Con comentario"
```

### **Escenario 3: Compartir perfil**
```gherkin
When hace clic en botón "Compartir"
Then muestra opciones: WhatsApp, Facebook, Copiar link
  And genera link corto: mitoga.co/t/juan-123
```

### **Escenario 4: Ver disponibilidad en tiempo real**
```gherkin
Given el tutor tiene disponibilidad configurada
When el estudiante ve el calendario en el perfil
Then muestra:
  - Próximos 7 días con slots disponibles (verde) e ocupados (gris)
  - Al hacer hover en slot: "Lunes 10:00-11:00 AM disponible"
  - Botón "Ver más fechas" (abre modal con calendario completo)
```

---

## 🔗 Trazabilidad

**RF:** RF-012 (Ver perfil tutor)  
**RNF:** RNF-PERF-002 (carga perfil <1s), RNF-SEO-002 (perfil indexable Google)

---

## 📏 Estimación

**Story Points:** 8 SP (Alta complejidad)  
**Desglose:** Backend 3 SP, Frontend 4 SP, Disponibilidad 1 SP

---

## 🧩 Dependencias

- **Depende de:** HU-005 (Registro tutor con datos perfil), HU-010 (Búsqueda)
- **Bloquea a:** HU-021 (Reservar sesión desde perfil)

---

## ✔️ Definition of Done

- [ ] Endpoint `GET /api/tutores/{id}/perfil` con todos los datos
- [ ] Endpoint `GET /api/tutores/{id}/disponibilidad?mes=2025-01`
- [ ] Frontend: componente TutorProfileModal reutilizable
- [ ] Integración video presentación (YouTube/Vimeo embed)
- [ ] Calendario disponibilidad con react-big-calendar
- [ ] Botón compartir con Web Share API
- [ ] SEO: meta tags Open Graph para shares
- [ ] Tests E2E: navegación búsqueda→perfil→reserva
- [ ] Performance: lazy loading de reseñas

---

## 🏷️ Etiquetas

`#marketplace` `#mvp` `#must-have` `#perfil-tutor` `#trust` `#conversion`

---

## ⚠️ Supuestos

- Video presentación aumenta reservas ~20% (opcional MVP)
- Badge "Verificado" requiere aprobación admin (HU-060)

---

**Story Points:** 8 SP | **Estimado:** 3-4 días
