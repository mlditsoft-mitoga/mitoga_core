# HU-015: Calificar y reseñar tutor

**Épica:** Marketplace | **Rol:** Estudiante | **Prioridad:** SHOULD HAVE (Post-MVP)

---

## 📖 Historia

> **Como** estudiante, **quiero** calificar (⭐ 1-5) y escribir una reseña sobre mi tutor después de completar la sesión, **para** ayudar a otros estudiantes y dar feedback.

---

## 💼 Valor

- **Social proof:** Reseñas aumentan confianza nuevos usuarios ~85%
- **Quality control:** Tutores mal calificados (<3.5 ⭐) reciben alerta admin
- **Engagement:** Proceso calificación cierra ciclo estudiante (closure psicológico)

---

## ✅ Criterios

### **Escenario 1: Calificar después de sesión completada**
```gherkin
Given estudiante "Ana" completó sesión BK-001 con tutor "Carlos"
When accede a /sesiones/completadas
Then ve botón "Calificar sesión"
When hace clic, abre modal con:
  - Rating estrellas ⭐⭐⭐⭐⭐ (clickeable 1-5)
  - Campo comentario (opcional, 500 chars max)
  - Preguntas rápidas (checkboxes):
    * "Explicó claramente"
    * "Fue puntual"
    * "Resolvió mis dudas"
    * "Lo recomendaría"
When selecciona ⭐⭐⭐⭐⭐ + escribe comentario + marca 4/4 checkboxes
Then guarda review status=PUBLICADA
  And recalcula rating promedio tutor (actualiza en perfil)
  And muestra "¡Gracias por tu opinión!"
```

### **Escenario 2: Validación reseña duplicada**
```gherkin
Given estudiante ya calificó sesión BK-001
When intenta calificar nuevamente
Then muestra "Ya calificaste esta sesión. Ver tu reseña"
  And permite editar reseña existente (30 días después)
```

### **Escenario 3: Reseña con rating bajo (<3 ⭐) requiere comentario**
```gherkin
When selecciona ⭐⭐ (2 estrellas)
  And intenta enviar sin comentario
Then muestra error "Para calificaciones <3 estrellas, explica qué mejorar"
  And hace campo comentario obligatorio
```

---

## 🔗 Trazabilidad

**RF:** RF-015 (Calificar tutor)  
**RNF:** RNF-MOD-001 (reseñas ofensivas moderadas por IA)

**Story Points:** 8 SP | **Complejidad:** Alta (recálculo ratings, moderación)

---

## 🧩 Dependencias

- **Depende de:** HU-027 (Sesión completada)
- **Relacionada con:** HU-014 (Ver reseñas)

---

## ✔️ DoD

- [ ] Endpoint `POST /api/bookings/{id}/review` validaciones
- [ ] Tabla `reviews`: booking_id (unique), rating, comentario, helpful_votes, status
- [ ] Recalcular `tutores.rating_promedio` trigger/cronjob
- [ ] Modal calificación con stars component animado
- [ ] Moderación básica: filtro palabras ofensivas
- [ ] Email tutor: "Recibiste nueva reseña ⭐4.5"
- [ ] Tests E2E: completar sesión→calificar→verificar rating actualizado

---

**Etiquetas:** `#marketplace` `#post-mvp` `#should-have` `#reviews` `#social-proof` `#quality-control`
