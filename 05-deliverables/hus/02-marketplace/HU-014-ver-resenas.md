# HU-014: Ver reseñas de tutor

**Épica:** Marketplace | **Rol:** Estudiante | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** estudiante, **quiero** leer reseñas detalladas de otros estudiantes sobre un tutor, **para** tomar una decisión informada antes de reservar.

---

## 💼 Valor

- **Trust building:** 90% usuarios leen reseñas antes de comprar (benchmark Trustpilot)
- **Conversión:** Tutores con >10 reseñas positivas convierten 3x más

---

## ✅ Criterios

### **Escenario 1: Ver reseñas en perfil tutor**
```gherkin
Given tutor "Carlos" tiene 24 reseñas
When estudiante ve perfil en /tutores/123
Then muestra sección "Opiniones (24)":
  - Rating promedio ⭐ 4.8/5.0
  - Desglose: 5⭐(18) | 4⭐(4) | 3⭐(2) | 2⭐(0) | 1⭐(0)
  - Últimas 3 reseñas visibles (más recientes)
  - Botón "Ver todas las opiniones"
```

### **Escenario 2: Filtrar reseñas**
```gherkin
When hace clic "Ver todas (24)"
Then abre modal con filtros:
  | Filtro           | Valores                    |
  | Ordenar por      | Más recientes, Mejor valoradas |
  | Rating           | 5⭐, 4⭐, 3⭐ o menos        |
  | Con comentario   | Checkbox                   |
```

### **Escenario 3: Reseña detallada**
```gherkin
Given reseña de "Ana Martínez" con ⭐ 5.0
Then muestra:
  - Avatar + nombre estudiante (anonimizado: "Ana M.")
  - Rating ⭐⭐⭐⭐⭐
  - Fecha "Hace 2 semanas"
  - Materia "Matemáticas - Cálculo diferencial"
  - Comentario: "Excelente explicación, muy paciente..."
  - Badge "Sesión verificada" (completó pago)
```

---

## 🔗 Trazabilidad

**RF:** RF-014 (Ver reseñas)  
**RNF:** RNF-USAB-004 (reseñas verificadas post-sesión)

**Story Points:** 5 SP | **Complejidad:** Media

---

## 🧩 Dependencias

- **Depende de:** HU-012 (Perfil tutor), HU-027 (Completar sesión)
- **Bloquea a:** HU-015 (Calificar tutor)

---

## ✔️ DoD

- [ ] Endpoint `GET /api/tutores/{id}/reviews?sort=recent|rating&filter=5stars`
- [ ] Tabla `reviews` con: rating, comentario, student_id, booking_id, verified
- [ ] Frontend: ReviewCard component con rating stars visual
- [ ] Modal full reviews con paginación (10 por página)
- [ ] Reseñas solo visibles si sesión COMPLETADA (verified=true)
- [ ] Anonimización estudiantes (nombre + inicial apellido)
- [ ] Tests E2E: navegación perfil→reseñas→filtros

---

**Etiquetas:** `#marketplace` `#mvp` `#must-have` `#reviews` `#social-proof` `#trust`
