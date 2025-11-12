# HU-011: Filtrar resultados de búsqueda

**Épica:** Marketplace | **Rol:** Estudiante | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia de Usuario

> **Como** estudiante,  
> **quiero** filtrar los resultados de búsqueda por precio, rating, disponibilidad y modalidad,  
> **para** encontrar el tutor que mejor se ajuste a mis necesidades y presupuesto.

---

## 💼 Valor de Negocio

- **Reducción de fricción:** 45% de estudiantes usa filtros antes de reservar (benchmark Udemy)
- **Conversión:** Filtros aumentan tasa de reserva ~30% (usuarios encuentran match perfecto)
- **Segmentación:** Permite a tutores de diferentes rangos de precio captar su audiencia

---

## ✅ Criterios de Aceptación

### **Escenario 1: Filtrar por rango de precio**
```gherkin
Given la búsqueda devuelve 30 tutores de "Inglés"
When el estudiante selecciona:
  - Precio mínimo: $10.000
  - Precio máximo: $25.000
Then el sistema filtra tutores donde precio_hora BETWEEN 10000 AND 25000
  And actualiza contador "18 resultados"
  And URL incluye ?materia=ingles&min_precio=10000&max_precio=25000
```

### **Escenario 2: Filtrar por rating mínimo**
```gherkin
When selecciona "Rating mínimo: 4.5 ⭐"
Then el sistema muestra solo tutores con rating >= 4.5
  And ordena por rating DESC (mejor primero)
```

### **Escenario 3: Filtrar por disponibilidad**
```gherkin
Given el estudiante selecciona "Disponible hoy"
Then el sistema:
  - Consulta disponibilidad en tiempo real (tabla `tutor_availability`)
  - Muestra tutores con slots libres en próximas 24h
  - Badge "Disponible ahora" visible en card
```

### **Escenario 4: Filtrar por modalidad**
```gherkin
When selecciona "Solo videollamada"
Then filtra tutores con modalidad="virtual"
  And excluye tutores "presencial" o "ambas"
```

### **Escenario 5: Múltiples filtros combinados**
```gherkin
Given aplica filtros:
  | Filtro            | Valor         |
  | Materia           | Matemáticas   |
  | Precio máx        | $20.000       |
  | Rating mín        | 4.0           |
  | Modalidad         | Virtual       |
  | Disponibilidad    | Fines semana  |

Then el sistema aplica AND lógico a todos los filtros
  And muestra "3 resultados" (intersección)
```

---

## 🔗 Trazabilidad

**RF:** RF-011 (Filtros avanzados)  
**RNF:** RNF-PERF-001 (filtrado <300ms), RNF-USAB-002 (filtros sticky sidebar)

---

## 📏 Estimación

**Story Points:** 5 SP  
**Complejidad:** Media

---

## 🧩 Dependencias

- **Depende de:** HU-010 (Búsqueda base)
- **Bloquea a:** HU-013 (Ordenar resultados)

---

## ✔️ Definition of Done

- [ ] Endpoint `GET /api/tutores/search` acepta params: min_precio, max_precio, rating_min, modalidad, disponibilidad
- [ ] Query optimizada con índices compuestos
- [ ] Sidebar de filtros con checkboxes + sliders (precio, rating)
- [ ] Contador dinámico "X resultados"
- [ ] Reset button "Limpiar filtros"
- [ ] Tests E2E: combinaciones de filtros
- [ ] Responsive: filtros en drawer mobile

---

## 🏷️ Etiquetas

`#marketplace` `#mvp` `#must-have` `#filtros` `#ux`

---

**Story Points:** 5 SP | **Estimado:** 2 días
