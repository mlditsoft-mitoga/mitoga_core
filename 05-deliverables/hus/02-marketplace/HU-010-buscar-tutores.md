# HU-010: Buscar tutores por materia

**Épica:** Marketplace  
**Rol:** Estudiante  
**Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia de Usuario

> **Como** estudiante,  
> **quiero** buscar tutores escribiendo una materia en el buscador,  
> **para** encontrar rápidamente tutores que enseñen lo que necesito aprender.

---

## 💼 Valor de Negocio

- **Core feature:** Es la funcionalidad central del producto (sin búsqueda, no hay marketplace)
- **Time to value:** Estudiante encuentra tutor en <30 segundos (fricción mínima)
- **Conversión:** 60% de búsquedas exitosas resultan en reserva (según benchmark Preply)

**ROI:** Métrica clave para Product-Market Fit (búsquedas exitosas = demanda real)

---

## 📄 Descripción

El estudiante accede a la página principal (`/`) o `/marketplace` y ve una barra de búsqueda prominente con placeholder "¿Qué quieres aprender? (Ej: Matemáticas, Inglés)". Al escribir:
1. Sistema muestra **autocompletado** con sugerencias de materias (ej: "Matemá..." → Matemáticas, Matemáticas aplicadas, Matemáticas financieras)
2. Al seleccionar o presionar Enter, redirige a `/marketplace/resultados?materia=matematicas`
3. Muestra listado de tutores con:
   - Foto de perfil
   - Nombre y especialización
   - Rating promedio (⭐ 4.8)
   - Precio por hora ($15.000 COP)
   - Badge "Verificado" si aplica
   - Botón "Ver perfil"

**Estado actual backend:** ✅ Implementado parcialmente  
- API `GET /api/tutores?materia=matematicas` funciona
- Frontend tiene TutorCard component (card de tutor en grid)
- Falta: autocompletado, filtros avanzados, paginación infinita

---

## ✅ Criterios de Aceptación

### **Escenario 1: Búsqueda exitosa con resultados**
```gherkin
Given existen 12 tutores con especialización "Matemáticas"
When el estudiante escribe "mate" en el buscador
Then el sistema muestra autocompletado con:
  | Sugerencia              | # Tutores |
  | Matemáticas             | 12        |
  | Matemáticas aplicadas   | 3         |
  | Matemática financiera   | 2         |

When selecciona "Matemáticas"
Then el sistema:
  - Redirige a /marketplace/resultados?materia=matematicas
  - Muestra título "Tutores de Matemáticas (12 resultados)"
  - Renderiza 12 cards de tutores en grid 3 columnas
  - Cada card muestra: foto, nombre, rating, precio, botón "Ver perfil"
  - Ordena por defecto: "Mejor valorados primero"
```

### **Escenario 2: Búsqueda sin resultados**
```gherkin
Given NO existen tutores con especialización "Latín"
When el estudiante escribe "Latín" y presiona Enter
Then el sistema:
  - Redirige a /marketplace/resultados?materia=latin
  - Muestra título "Tutores de Latín (0 resultados)"
  - Muestra ilustración empty state con mensaje:
    "No encontramos tutores de Latín. Intenta con otra materia o solicita que agreguemos esta área"
  - Ofrece botón "Solicitar materia" (abre modal para registrar demanda)
  - Sugiere materias relacionadas: "Quizás te interese: Español, Literatura, Filosofía"
```

### **Escenario 3: Búsqueda con typos/sinónimos**
```gherkin
Given el estudiante escribe "matematica" (sin tilde)
When presiona Enter
Then el sistema:
  - Detecta typo con algoritmo fuzzy matching (Levenshtein distance)
  - Autocorrige a "Matemáticas"
  - Muestra banner "Mostrando resultados para: Matemáticas"
  - Renderiza resultados normalmente

Given el estudiante busca "inglés" o "english"
Then el sistema reconoce sinónimos
  And muestra los mismos resultados (tutores de Inglés)
```

### **Escenario 4: Filtrado combinado con precio**
```gherkin
Given el estudiante buscó "Inglés" (30 resultados)
When aplica filtro "Precio máximo: $20.000"
Then el sistema:
  - Filtra tutores con precio_hora <= 20000
  - Actualiza contador "Tutores de Inglés (18 resultados)"
  - Mantiene query param: /resultados?materia=ingles&max_precio=20000
  - Los filtros persisten si navega atrás/adelante (browser history)
```

### **Escenario 5: Paginación infinita (scroll)**
```gherkin
Given la búsqueda devuelve 50 tutores
When el estudiante hace scroll hasta el final de la página (80% scrolled)
Then el sistema:
  - Carga automáticamente siguientes 12 tutores (paginación infinita)
  - Muestra skeleton loader mientras carga
  - Actualiza contador "Mostrando 24 de 50"
  - NO hace full page reload (smooth UX)
```

---

## 🔗 Trazabilidad

**Requisitos funcionales:**
- RF-010 (Buscar tutores) → funcionalidad principal
- RF-011 (Filtrar resultados) → complementa búsqueda básica

**Requisitos no funcionales:**
- RNF-PERF-001: Búsqueda debe responder en <500ms (incluso con 1000+ tutores)
- RNF-USAB-001: Autocompletado aparece después de 2 caracteres escritos
- RNF-SEO-001: URLs amigables (/resultados?materia=matematicas para indexación)

---

## 📏 Estimación

**Story Points:** 8 SP  
**Complejidad:** Alta

**Desglose:**
- Backend búsqueda + fuzzy matching: 3 SP
- Autocompletado con debounce: 2 SP
- Frontend grid tutores + paginación infinita: 2 SP
- Empty state + sugerencias: 1 SP

---

## 🧩 Dependencias

**Depende de:**
- HU-005 (Registro tutor) → requiere tutores en BD con materias configuradas
- HU-001 (Registro estudiante) → estudiantes pueden buscar sin login (público), pero no reservar

**Bloquea a:**
- HU-011 (Filtrar resultados avanzados) → se construye sobre esta búsqueda base
- HU-021 (Reservar sesión) → búsqueda es paso previo

**Relacionada con:**
- HU-012 (Ver perfil tutor) → desde card se accede a perfil completo

---

## ✔️ Definition of Done (DoD)

- [ ] Endpoint `GET /api/tutores/search?q={materia}` con fuzzy matching (Levenshtein)
- [ ] Endpoint `GET /api/materias/autocomplete?q={query}` para sugerencias
- [ ] Query optimizada: índice en columna `materias` (PostgreSQL GIN index)
- [ ] Frontend: barra búsqueda con autocompletado (debounce 300ms)
- [ ] TutorCard component actualizado con todos los campos (rating, precio, badge)
- [ ] Grid responsive (3 cols desktop → 2 cols tablet → 1 col mobile)
- [ ] Paginación infinita con Intersection Observer API
- [ ] Empty state con ilustración + CTA "Solicitar materia"
- [ ] Tests unitarios: fuzzy matching, autocompletado (>85% cobertura)
- [ ] Test E2E: búsqueda exitosa + sin resultados + scroll infinito (Cypress)
- [ ] Accesibilidad: autocompletado navegable con teclado (arrow keys + Enter)
- [ ] Performance: búsqueda con 1000 tutores <500ms (usar EXPLAIN ANALYZE)

---

## 🏷️ Etiquetas

`#modulo-marketplace` `#mvp` `#must-have` `#frontend` `#backend` `#busqueda` `#autocompletado` `#core-feature` `#ux-critica`

---

## 🧪 Notas de Testing

**Casos edge:**
- Búsqueda con caracteres especiales ("C++", "C#") → no romper query SQL
- Búsqueda en blanco (presiona Enter sin escribir) → mostrar "Todos los tutores"
- 10 usuarios buscan simultáneamente → verificar no hay race conditions en cache
- Usuario busca "matemática" (singular) vs "matemáticas" (plural) → normalizar

**Recomendación:** Implementar analytics para trackear búsquedas sin resultados (insights de demanda no cubierta)

---

## ⚠️ Riesgos y Supuestos

**Riesgos:**
- Fuzzy matching demasiado agresivo → devuelve resultados irrelevantes (tuning necesario)
- Paginación infinita en mobile consume mucha data → ofrecer toggle "Ver más" manual

**Supuestos:**
- 80% de estudiantes busca por materia (vs nombre de tutor) → validar con analytics
- Autocompletado reduce typos ~40% (benchmark Google Search)

---

## ❓ Preguntas Abiertas

1. ¿Permitir búsqueda por nombre de tutor también? → Fase 2 (menos común, pero útil)
2. ¿Guardar historial de búsquedas del usuario? → Sí, para "Búsquedas recientes"
3. ¿Límite de resultados sin login? → No, búsqueda es pública (solo reserva requiere login)
