# ADR-001: Patrón Arquitectónico Frontend - Modular Monolith con Feature-Based Architecture

**Fecha:** 2025-11-08  
**Estado:** Aceptada  
**Autores:** Solutions Architect Senior  
**Revisores:** Tech Lead, Product Owner  
**Decisores:** CTO, Tech Lead

---

## Contexto y Problemática

**Descripción del Problema:**

MI-TOGA actualmente tiene una arquitectura frontend básica (monolito no estructurado) con un componente principal de 856 líneas (`page.tsx`) que mezcla UI, lógica de negocio y gestión de estado. Esto genera:

- Dificultad para mantener y escalar el código
- Duplicación de lógica entre componentes
- Testing complejo (código acoplado)
- Onboarding lento de nuevos desarrolladores
- Riesgo alto en refactorings

El equipo necesita decidir qué patrón arquitectónico adoptar para soportar crecimiento de:
- MVP (500 usuarios) → Año 1 (10,000 usuarios) → Año 3 (50,000 usuarios)
- 8 módulos funcionales (autenticación, marketplace, perfiles, agendamiento, pagos, comunicación, administración, búsqueda)
- Equipo de 1-2 developers frontend actualmente, 4-6 en Año 2

**Pregunta a Responder:**

¿Qué patrón arquitectónico debemos adoptar para el frontend de MI-TOGA que equilibre mantenibilidad, escalabilidad y velocidad de desarrollo?

**Factores de Decisión:**

- **Mantenibilidad:** Código fácil de entender y modificar
- **Escalabilidad:** Soportar crecimiento a 50,000 usuarios sin refactoring mayor
- **Velocidad de desarrollo:** Time-to-market para nuevas features
- **Complejidad operacional:** Evitar over-engineering para un equipo pequeño
- **Expertise del equipo:** Equipo junior-mid en arquitectura frontend
- **Testing:** Facilitar unit tests y integration tests
- **Code reuse:** Maximizar reutilización de componentes

---

## Opciones Consideradas

### Opción 1: Micro Frontends (con Module Federation)

**Descripción:**

Dividir la aplicación en múltiples aplicaciones frontend independientes por módulo de negocio:
- `mf-marketplace` (búsqueda y listado de tutores)
- `mf-auth` (login, registro)
- `mf-dashboard-student` (dashboard estudiante)
- `mf-dashboard-tutor` (dashboard tutor)
- `mf-booking` (agendamiento)
- `mf-payments` (pagos)

Cada micro frontend:
- Se desarrolla, prueba y deploya independientemente
- Tiene su propio repositorio Git
- Puede usar tecnologías diferentes (React 18 vs 19, diferentes state managers)
- Se integra en runtime con Webpack Module Federation

**Pros:**
- ✅ **Escalabilidad de equipos:** Equipos autónomos por módulo
- ✅ **Deploy independiente:** No requiere rebuild completo
- ✅ **Aislamiento de fallos:** Error en un micro frontend no afecta otros
- ✅ **Tecnologías heterogéneas:** Flexibilidad para experimentar

**Contras:**
- ❌ **Alta complejidad operacional:** 6+ repos, 6+ pipelines CI/CD, orquestación compleja
- ❌ **Performance overhead:** Carga múltiples frameworks, duplicación de dependencias
- ❌ **Experiencia de usuario inconsistente:** Difícil mantener look & feel uniforme
- ❌ **Complejidad de estado compartido:** Autenticación, carrito, notificaciones entre MFEs
- ❌ **Debugging difícil:** Errores que cruzan boundaries de MFEs
- ❌ **Overkill para equipo pequeño:** Requiere 3+ developers por MFE (18+ developers)

**Costos:**
- **Desarrollo:** +150% tiempo vs monolito (setup, coordinación)
- **Infraestructura:** $300-500/mes (múltiples deploys, edge orchestration)
- **Mantenimiento:** 40 horas/mes extra (coordinación, integración)

**Riesgos:**
- 🔴 **ALTO:** Equipo actual (1-2 devs) no tiene capacidad para gestionar 6 MFEs
- 🔴 **ALTO:** Complejidad técnica excede beneficios para escala actual
- 🟠 **MEDIO:** Vendor lock-in a Webpack Module Federation

---

### Opción 2: Monolito No Estructurado (Status Quo - Mejorado)

**Descripción:**

Mantener la estructura actual (todo en un repositorio y aplicación) pero aplicar mejoras incrementales:
- Mover lógica de `page.tsx` (856 líneas) a custom hooks
- Extraer componentes reutilizables
- Agregar Zod para validación
- Implementar Zustand para estado global
- Agregar tests unitarios (70% coverage)

Sin cambiar la estructura fundamental de carpetas (`app/`, `components/`, `lib/`, `types/`).

**Pros:**
- ✅ **Simplicidad operacional:** 1 repo, 1 deploy, 1 CI/CD pipeline
- ✅ **Velocidad inmediata:** No requiere refactoring arquitectónico mayor
- ✅ **Shared code natural:** Componentes UI, utils, tipos TypeScript compartidos
- ✅ **Ideal para equipo pequeño:** 1-2 developers pueden manejar todo
- ✅ **Testing simple:** Jest + Testing Library sin complejidad inter-MFE

**Contras:**
- ❌ **Escalabilidad limitada:** A partir de 50+ componentes se vuelve caótico
- ❌ **Acoplamiento alto:** Cambios en un área pueden romper otras
- ❌ **No separation of concerns:** Difícil trabajar en paralelo sin conflictos Git
- ❌ **Crecimiento técnico de deuda:** Sin estructura clara, el código se degrada con el tiempo
- ❌ **Dificultad para nuevos devs:** No hay convenciones claras de dónde poner código

**Costos:**
- **Desarrollo:** Baseline (tiempo estándar)
- **Infraestructura:** $46-100/mes (S3 + CloudFront)
- **Mantenimiento:** 20 horas/mes (refactorings reactivos)

**Riesgos:**
- 🟠 **MEDIO:** En Año 2 (4-6 devs) empiezan conflictos de merge frecuentes
- 🟠 **MEDIO:** Refactoring mayor necesario en Año 2-3 (costo alto)
- 🟡 **BAJO:** Suficiente para MVP y Fase 1-2

---

### Opción 3: Modular Monolith con Feature-Based Architecture (RECOMENDADA)

**Descripción:**

Arquitectura de **monolito modular** donde:
- **Físicamente:** 1 repositorio, 1 aplicación Next.js, 1 deploy
- **Lógicamente:** Código organizado por **features** (módulos de negocio) con boundaries claros

**Estructura propuesta:**

```
src/
├── features/                    # Feature modules (bounded contexts)
│   ├── auth/
│   │   ├── components/          # LoginForm, RegisterForm, PasswordRecovery
│   │   ├── hooks/               # useAuth, useLogin, useRegister
│   │   ├── services/            # authService.ts (API calls)
│   │   ├── stores/              # authStore.ts (Zustand)
│   │   ├── schemas/             # loginSchema.ts (Zod validation)
│   │   ├── types/               # User, AuthState types
│   │   └── index.ts             # Public API del feature
│   │
│   ├── marketplace/
│   │   ├── components/          # TutorCard, TutorGrid, SearchFilters
│   │   ├── hooks/               # useTutors, useFilters, usePagination
│   │   ├── services/            # tutorService.ts
│   │   ├── stores/              # marketplaceStore.ts
│   │   ├── utils/               # filterTutors(), sortTutors()
│   │   ├── types/               # Tutor, Filter types
│   │   └── index.ts
│   │
│   ├── tutor-profile/
│   ├── booking/
│   ├── payments/
│   ├── chat/
│   ├── video/
│   └── admin/
│
├── shared/                      # Código compartido entre features
│   ├── components/              # Button, Modal, Input (UI library)
│   ├── hooks/                   # useDebounce, useIntersectionObserver
│   ├── utils/                   # formatDate, formatCurrency
│   ├── constants/               # API_BASE_URL, SUBJECTS, CITIES
│   ├── types/                   # Global types (ApiResponse, Pagination)
│   └── services/                # apiClient.ts (Axios instance)
│
├── app/                         # Next.js App Router (routing only)
│   ├── (public)/
│   │   ├── page.tsx             # Usa <MarketplacePage /> de features/marketplace
│   │   ├── login/page.tsx       # Usa <LoginPage /> de features/auth
│   │   └── registro/page.tsx
│   ├── tutores/[id]/page.tsx    # Usa <TutorProfilePage />
│   └── dashboard/
│       ├── estudiante/page.tsx
│       ├── tutor/page.tsx
│       └── admin/page.tsx
│
└── core/                        # Core infrastructure
    ├── config/                  # Configuración (env vars, feature flags)
    ├── monitoring/              # Sentry, analytics setup
    └── providers/               # React Context providers
```

**Principios clave:**

1. **Cada feature es autónomo:**
   - Tiene sus propios componentes, hooks, services, stores, tipos
   - No importa directamente de otros features (solo de `shared/`)
   - Expone API pública clara vía `index.ts`

2. **Dependencias permitidas:**
   ```
   features/auth → shared/         ✅ Permitido
   features/booking → shared/      ✅ Permitido
   features/booking → features/auth ❌ PROHIBIDO (usar shared API)
   app/page.tsx → features/marketplace ✅ Permitido
   ```

3. **Comunicación entre features:**
   - Via eventos (custom events del navegador)
   - Via Zustand stores compartidos (mínimo)
   - Via URL params/query strings

4. **Testing:**
   - Cada feature tiene su carpeta `__tests__/`
   - Tests independientes por feature
   - Mocks de otros features vía `index.ts` API

**Pros:**
- ✅ **Escalabilidad arquitectónica:** Preparado para crecer a 50+ features sin refactoring
- ✅ **Mantenibilidad alta:** Código organizado por dominio de negocio (DDD táctico)
- ✅ **Onboarding rápido:** Nuevos devs encuentran código intuitivamente
- ✅ **Testing simple:** Tests aislados por feature, fácil de mockear
- ✅ **Trabajo paralelo:** Múltiples devs pueden trabajar en features distintos sin conflictos
- ✅ **Migración gradual a MFEs:** Si en futuro se necesita, features ya están aislados
- ✅ **Simplicidad operacional:** Sigue siendo 1 repo, 1 deploy (como monolito)
- ✅ **Reusabilidad:** `shared/` centraliza componentes comunes

**Contras:**
- ❌ **Requiere disciplina:** Equipo debe respetar boundaries (no imports directos entre features)
- ❌ **Refactoring inicial:** Requiere mover código actual a nueva estructura (80-120 horas)
- ❌ **Curva de aprendizaje:** Equipo debe entender principios de feature modules
- ❌ **Deploy atómico:** Cambio en un feature requiere deploy completo (no deploy independiente)

**Costos:**
- **Desarrollo:**
  - Refactoring inicial: 120 horas ($12,000 @ $100/h)
  - Velocidad post-refactoring: +20% más rápido que status quo
- **Infraestructura:** $46-100/mes (igual que status quo, sin overhead)
- **Mantenimiento:** 15 horas/mes (menos que monolito caótico)

**Riesgos:**
- 🟡 **BAJO:** Requiere training inicial (8 horas) para equipo
- 🟡 **BAJO:** Necesita linting rules para enforcer boundaries
- 🟢 **MUY BAJO:** Ampliamente probado en industria (Nx, Angular, Domain-Driven Design)

---

## Matriz de Decisión

| Criterio | Peso | Micro Frontends | Monolito No Estructurado | Modular Monolith (Feature-Based) |
|----------|------|-----------------|--------------------------|----------------------------------|
| **Mantenibilidad** | 25% | 8/10 = 2.0 | 4/10 = 1.0 | **9/10 = 2.25** |
| **Escalabilidad** | 20% | 9/10 = 1.8 | 5/10 = 1.0 | **8/10 = 1.6** |
| **Simplicidad (inverso)** | 20% | 2/10 = 0.4 | 8/10 = 1.6 | **7/10 = 1.4** |
| **Velocidad de desarrollo** | 15% | 4/10 = 0.6 | 7/10 = 1.05 | **8/10 = 1.2** |
| **Costo (inverso)** | 10% | 3/10 = 0.3 | 9/10 = 0.9 | **7/10 = 0.7** |
| **Expertise del equipo** | 10% | 3/10 = 0.3 | 9/10 = 0.9 | **7/10 = 0.7** |
| **TOTAL** | **100%** | **5.4** | **6.45** | **🏆 7.85** |

---

## Decisión

**Opción Seleccionada:** Opción 3 - **Modular Monolith con Feature-Based Architecture**

**Justificación:**

1. **Balance óptimo:** Ofrece escalabilidad de microservicios con simplicidad de monolito
2. **Preparación para futuro:** Si en Año 3 necesitamos Micro Frontends, features ya están aislados (migración incremental)
3. **Ideal para equipo actual:** 1-2 devs pueden manejar, pero soporta crecimiento a 6+ devs
4. **Alineación con backend:** Backend Spring Boot usa bounded contexts (DDD), frontend debe reflejar misma estructura
5. **Mantenibilidad a largo plazo:** Código organizado por dominio, no por tipo técnico
6. **ROI claro:** Inversión inicial de 120h se recupera en 6 meses con +20% velocidad de desarrollo

**Comparación con alternativas:**
- vs **Micro Frontends:** Evitamos complejidad innecesaria para escala actual (10K usuarios Año 1)
- vs **Monolito No Estructurado:** Evitamos acumulación de deuda técnica que será costosa en Año 2

---

## Consecuencias

### Positivas

- ✅ **Código más mantenible:** Features auto-contenidos con dependencies claras
- ✅ **Onboarding 3x más rápido:** Nuevos devs encuentran código intuitivamente
- ✅ **Testing 40% más fácil:** Tests aislados por feature con mocks claros
- ✅ **Velocidad de desarrollo +20%:** Menos tiempo buscando código, más tiempo programando
- ✅ **Escalabilidad probada:** Migración a MFEs (si necesario) es incremental

### Negativas

- ⚠️ **Refactoring inicial:** 120 horas para migrar código actual (spread en 3 sprints)
- ⚠️ **Curva de aprendizaje:** 8 horas de training para equipo en principios de feature modules
- ⚠️ **Necesita disciplina:** ESLint rules para enforcer boundaries (no imports prohibidos)

### Riesgos Mitigados

| Riesgo | Mitigación |
|--------|------------|
| Equipo no respeta boundaries | ESLint plugin `eslint-plugin-import` con rules custom |
| Código duplicado en features | Mover a `shared/` en refactorings continuos |
| Features muy grandes (>500 LOC) | Split en sub-features (ej: `auth/` → `auth/login/`, `auth/register/`) |

---

## Plan de Implementación

### Fase 1: Setup (Sprint 1 - Semana 1-2)

**Tareas:**
1. Crear estructura de carpetas `features/`, `shared/`, `core/`
2. Configurar ESLint rules para boundaries
3. Migrar `shared/` (components UI, utils, constants) - 20h
4. Documentar convenciones en `ARCHITECTURE.md` - 8h

**Entregable:** Estructura base lista

### Fase 2: Migración de Features Críticos (Sprint 1-2 - Semana 2-4)

**Tareas:**
1. Migrar `features/auth/` (login, registro) - 24h
2. Migrar `features/marketplace/` (tutores, filtros) - 32h
3. Migrar `features/tutor-profile/` (perfil detallado) - 20h
4. Actualizar imports en `app/` pages - 16h

**Entregable:** 3 features principales migrados, app funcionando

### Fase 3: Features Secundarios (Sprint 3 - Semana 5-6)

**Tareas:**
1. Migrar `features/booking/` (agendamiento - Fase 2) - 20h
2. Migrar `features/admin/` (dashboard admin) - 16h
3. Testing de integración - 12h
4. Documentación de APIs públicas - 8h

**Entregable:** Todos los features migrados

### Fase 4: Limpieza y Optimización (Sprint 4 - Semana 7)

**Tareas:**
1. Eliminar código legacy no usado - 8h
2. Refactoring de duplicaciones - 12h
3. Performance optimization (code splitting por feature) - 16h
4. Training a equipo en nueva arquitectura - 8h

**Entregable:** Arquitectura completa, equipo entrenado

**Total Estimado:** 120 horas (~3 sprints de 2 semanas)

---

## Validación y Métricas de Éxito

**Métricas Pre-Implementación (Baseline):**
- Tiempo para agregar nuevo feature: 40 horas
- Tiempo de onboarding nuevo dev: 2 semanas
- Cobertura de tests: 0%
- Bugs en producción: 3-5/mes
- Velocidad de desarrollo (story points/sprint): 20

**Métricas Post-Implementación (Meta 3 meses):**
- Tiempo para agregar nuevo feature: 32 horas (-20%)
- Tiempo de onboarding nuevo dev: 1 semana (-50%)
- Cobertura de tests: 70% (+70pp)
- Bugs en producción: 1-2/mes (-60%)
- Velocidad de desarrollo (story points/sprint): 24 (+20%)

**KPIs de Adopción:**
- 100% de features nuevos usan feature-based structure
- 0 violations de ESLint boundary rules en CI/CD
- Documentación de API pública de cada feature completa

---

## Referencias

- [Modular Monoliths by Simon Brown](https://www.youtube.com/watch?v=5OjqD-ow8GE)
- [Feature-Sliced Design](https://feature-sliced.design/)
- [Domain-Driven Design (Eric Evans)](https://www.domainlanguage.com/ddd/)
- [Nx Monorepo Best Practices](https://nx.dev/concepts/more-concepts/applications-and-libraries)
- [Angular Feature Modules](https://angular.io/guide/feature-modules)

---

**Aprobaciones:**

- [ ] Tech Lead: _________________ Fecha: _______
- [ ] Product Owner: _____________ Fecha: _______
- [ ] CTO: ______________________ Fecha: _______
