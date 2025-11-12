# HU-013: Ordenar resultados de búsqueda

**Épica:** Marketplace | **Rol:** Estudiante | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** estudiante, **quiero** ordenar los resultados por mejor valoración, menor precio, o más relevante, **para** encontrar el tutor ideal según mis criterios.

---

## 💼 Valor

- **Personalización:** 55% usuarios cambia orden por defecto (benchmark Amazon)
- **Conversión:** Ordenar por precio aumenta reservas ~20% (usuarios price-sensitive)

---

## ✅ Criterios

### **Escenario 1: Ordenar por mejor valoración**
```gherkin
Given búsqueda devuelve 20 tutores "Matemáticas"
When selecciona "Ordenar por: Mejor valorados"
Then sistema ordena por rating DESC, reseñas DESC
  And tutores con ⭐ 5.0 aparecen primero
  And URL actualiza: ?materia=matematicas&sort=rating
```

### **Escenario 2: Ordenar por menor precio**
```gherkin
When selecciona "Ordenar por: Menor precio"
Then ordena por precio_hora ASC
  And tutores desde $10.000 primero, $50.000 último
```

### **Escenario 3: Ordenar por más relevante (default)**
```gherkin
Given estudiante NO selecciona orden explícito
Then aplica algoritmo relevancia:
  - Rating × 0.4
  - # Reseñas × 0.3
  - Sesiones completadas × 0.2
  - Verificación badge × 0.1
```

---

## 🔗 Trazabilidad

**RF:** RF-013 (Ordenar resultados)  
**RNF:** RNF-PERF-001 (reordenamiento <200ms)

**Story Points:** 3 SP | **Complejidad:** Baja

---

## 🧩 Dependencias

- **Depende de:** HU-010 (Búsqueda base)
- **Relacionada con:** HU-011 (Filtros)

---

## ✔️ DoD

- [ ] Endpoint `GET /api/tutores/search` acepta param `sort=rating|price|relevance`
- [ ] Query optimizada con índices en `rating`, `precio_hora`
- [ ] Dropdown "Ordenar por" sticky en resultados
- [ ] Estado orden persiste en URL (compartir link ordenado)
- [ ] Tests E2E: cambio orden actualiza grid

---

**Etiquetas:** `#marketplace` `#mvp` `#must-have` `#sorting` `#ux`
