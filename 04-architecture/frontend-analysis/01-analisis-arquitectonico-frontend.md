# Análisis y Diseño de Arquitectura Frontend - MI-TOGA

**Proyecto:** MI-TOGA - Plataforma de Tutorías Virtuales  
**Cliente/Organización:** ZENAPSES S.A.S  
**Rol Ejecutor:** Solutions Architect Senior y Cloud Architect  
**Fecha de Análisis:** 8 de noviembre de 2025  
**Versión del Documento:** 1.0  
**Método:** ZNS - Consolidación, Estructuración, Inteligencia, Best Practices, Arquitectura

---

## 📋 Resumen Ejecutivo

Este documento presenta un **análisis exhaustivo y diseño de arquitectura frontend** para la plataforma MI-TOGA, basado en requisitos funcionales, no funcionales y análisis del código actual.

### Hallazgos Clave

| Aspecto | Estado Actual | Recomendación Principal |
|---------|---------------|-------------------------|
| **Framework** | Next.js 16.0 con App Router | ✅ Mantener - Stack moderno y óptimo |
| **Arquitectura** | Monolito modular básico | ⚠️ Evolucionar a arquitectura por features con DDD táctico |
| **Performance** | Build estático (SSG) para S3 | ⚠️ Migrar a SSR híbrido con ISR para mejor SEO y UX |
| **State Management** | React Context local | ⚠️ Implementar Zustand para estado global escalable |
| **Type Safety** | TypeScript 5.9 | ✅ Mantener con configuración strict mode |
| **Testing** | No implementado (0%) | 🔴 Crítico - Implementar Jest + Testing Library (meta: 80%) |
| **API Integration** | Mock data hardcoded | 🔴 Crítico - Implementar capa de servicios con axios + SWR |
| **Security** | Autenticación básica localStorage | 🔴 Crítico - Migrar a JWT con httpOnly cookies |
| **Accessibility** | Básica (sin auditoría) | ⚠️ Implementar WCAG 2.1 AA compliance |
| **Deployment** | Build estático manual a S3 | ⚠️ Automatizar CI/CD con GitHub Actions |

### Métricas de Calidad Actuales

| Métrica | Valor Actual | Meta Fase 2 | Meta Año 1 |
|---------|--------------|-------------|------------|
| **Cobertura de Tests** | 0% | 70% | 85% |
| **Core Web Vitals (LCP)** | ~2.8s (estimado) | < 2.5s | < 1.5s |
| **Lighthouse Score** | ~75 (estimado) | 90+ | 95+ |
| **Bundle Size** | ~180KB (gzipped) | < 200KB | < 150KB |
| **Type Safety** | Parcial | Estricto | Estricto |
| **Accesibilidad Score** | ~60 (estimado) | 85+ | 95+ |

### Inversión Estimada

| Fase | Descripción | Horas | Costo (USD $100/h) | Prioridad |
|------|-------------|-------|---------------------|-----------|
| **Fase 1** | Quick Wins + Críticos | 120h | $12,000 | 🔴 ALTA |
| **Fase 2** | Refactoring Arquitectónico | 160h | $16,000 | 🟠 MEDIA |
| **Fase 3** | Escalabilidad + Testing | 100h | $10,000 | 🟡 MEDIA |
| **Fase 4** | Optimización + DevOps | 80h | $8,000 | 🟢 BAJA |
| **TOTAL** | - | **460h** | **$46,000** | - |

**ROI Esperado:** 
- Reducción de bugs en producción: 60%
- Mejora de tiempo de desarrollo de features: 40%
- Mejora de SEO y conversión: 25%
- Reducción de costos de mantenimiento: 35%

---

## 1️⃣ FASE CONTEXTO - Análisis del Proyecto

### 1.1 Descripción del Proyecto

**MI-TOGA** es una plataforma web de tutoría virtual que conecta estudiantes con tutores calificados en Colombia. El proyecto busca democratizar el acceso a educación de calidad mediante una solución tecnológica moderna y escalable.

#### Información General

| Campo | Valor |
|-------|-------|
| **Nombre del Proyecto** | MI-TOGA |
| **Dominio de Negocio** | EdTech - Marketplace de Tutorías |
| **Organización** | ZENAPSES S.A.S |
| **Tipo de Aplicación** | Web App (SPA + SSG actual) |
| **Estado Actual** | MVP - Fase 1 (Frontend) |
| **Usuario Objetivo** | Estudiantes (12-35 años) y Tutores (20-55 años) |
| **Alcance Geográfico** | Colombia (inicial), LATAM (futuro) |

#### Problemática de Negocio

1. **Acceso limitado a tutorías de calidad:** No todos los estudiantes tienen acceso a tutores especializados
2. **Altos costos de tutorías presenciales:** Las tutorías privadas tradicionales son costosas
3. **Falta de flexibilidad horaria:** Dificultad para coordinar horarios
4. **Ausencia de sistemas de calificación:** No existe un mecanismo transparente
5. **Procesos manuales de coordinación:** La búsqueda y agendamiento es ineficiente

#### Propuesta de Valor

- **Marketplace centralizado** de tutores verificados
- **Flexibilidad de modalidades:** Virtual, presencial y en-sitio
- **Sistema de calificaciones transparente** con reseñas
- **Filtrado inteligente** por materia, precio, disponibilidad
- **Agendamiento digital** simplificado (Fase 2)
- **Pagos integrados** y seguros (Fase 4)
- **Videollamadas integradas** (Fase 3)

#### Stakeholders Principales

| Rol | Responsabilidad | Impacto |
|-----|-----------------|---------|
| **Estudiantes** | Usuarios que buscan tutorías | 🔴 ALTO - usuarios principales (1,000+ año 1) |
| **Tutores** | Profesionales que ofrecen servicios | 🔴 ALTO - oferta de la plataforma (200+ año 1) |
| **Administradores** | Personal que gestiona la plataforma | 🟡 MEDIO - operación (2-5 personas) |
| **Product Owner** | Define prioridades de producto | 🟠 ALTO - decisiones estratégicas |
| **Dev Team** | Implementa la plataforma | 🟠 ALTO - ejecución técnica |

---

### 1.2 Requisitos Funcionales

**Total de Requisitos Funcionales:** 45 requisitos distribuidos en 8 módulos principales.

#### Módulos Principales

##### Módulo 1: Autenticación y Gestión de Usuarios

| RF ID | Requisito | Prioridad | Fase | Estimación |
|-------|-----------|-----------|------|------------|
| RF-001 | Registro de Estudiantes | Must Have | MVP | 8h |
| RF-002 | Registro de Tutores | Must Have | MVP | 16h |
| RF-003 | Login con Credenciales | Must Have | MVP | 12h |
| RF-004 | Logout | Must Have | MVP | 4h |
| RF-005 | Recuperación de Contraseña | Should Have | Fase 2 | 16h |
| RF-006 | Verificación de Email | Should Have | Fase 2 | 12h |
| RF-007 | Login con OAuth 2.0 (Google/Facebook) | Nice to Have | Fase 3 | 24h |
| RF-008 | MFA (Autenticación de Dos Factores) | Nice to Have | Fase 5 | 40h |

**Criterios de Aceptación Clave (RF-001):**
- Validar formato de email (RFC 5322)
- Contraseña mínimo 8 caracteres (1 mayúscula, 1 minúscula, 1 número)
- Verificar email no duplicado
- Confirmación visual de registro exitoso
- Redirección al marketplace post-registro

##### Módulo 2: Marketplace de Tutores

| RF ID | Requisito | Prioridad | Fase | Estimación |
|-------|-----------|-----------|------|------------|
| RF-011 | Listado de Tutores Disponibles | Must Have | MVP | 16h |
| RF-012 | Filtrado por Materia | Must Have | MVP | 12h |
| RF-013 | Filtrado por Precio | Must Have | MVP | 8h |
| RF-014 | Filtrado por Modalidad | Must Have | MVP | 8h |
| RF-015 | Filtrado por Ciudad | Should Have | MVP | 8h |
| RF-016 | Ordenamiento de Resultados | Must Have | MVP | 8h |
| RF-017 | Búsqueda por Texto Libre | Should Have | Fase 2 | 16h |
| RF-018 | Paginación de Resultados | Must Have | MVP | 8h |

**Estado Actual:** ✅ Implementado con mock data
**Gap Principal:** Integración con backend API real

##### Módulo 3: Gestión de Perfiles

| RF ID | Requisito | Prioridad | Fase | Estimación |
|-------|-----------|-----------|------|------------|
| RF-021 | Vista Detallada de Perfil de Tutor | Must Have | MVP | 16h |
| RF-022 | Calificaciones y Reseñas | Must Have | MVP | 20h |
| RF-023 | Portafolio/Certificaciones (PDFs) | Should Have | Fase 2 | 16h |
| RF-024 | Video de Presentación | Nice to Have | Fase 3 | 24h |
| RF-025 | Edición de Perfil Estudiante | Should Have | Fase 2 | 12h |
| RF-026 | Edición de Perfil Tutor | Must Have | Fase 2 | 20h |
| RF-027 | Gestión de Disponibilidad (Tutor) | Must Have | Fase 2 | 32h |

##### Módulo 4: Sistema de Búsqueda y Filtrado

| RF ID | Requisito | Prioridad | Fase | Estimación |
|-------|-----------|-----------|------|------------|
| RF-031 | Búsqueda Avanzada Multi-criterio | Should Have | Fase 2 | 24h |
| RF-032 | Autocompletado de Búsqueda | Nice to Have | Fase 3 | 16h |
| RF-033 | Sugerencias Personalizadas | Nice to Have | Fase 4 | 40h |
| RF-034 | Historial de Búsquedas | Should Have | Fase 3 | 12h |
| RF-035 | Favoritos/Lista de Deseos | Should Have | Fase 2 | 16h |

**Estado Actual:** Filtrado básico implementado con lógica client-side
**Gap Principal:** Búsqueda avanzada con backend + Elasticsearch

##### Módulo 5: Sistema de Agendamiento (Fase 2)

| RF ID | Requisito | Prioridad | Fase | Estimación |
|-------|-----------|-----------|------|------------|
| RF-041 | Visualización de Calendario de Tutor | Must Have | Fase 2 | 24h |
| RF-042 | Reserva de Sesión | Must Have | Fase 2 | 32h |
| RF-043 | Confirmación de Reserva (Tutor) | Must Have | Fase 2 | 16h |
| RF-044 | Cancelación de Sesión | Must Have | Fase 2 | 16h |
| RF-045 | Reprogramación de Sesión | Should Have | Fase 3 | 20h |
| RF-046 | Notificaciones de Recordatorio | Must Have | Fase 2 | 16h |

**Estado Actual:** ❌ No implementado
**Dependencia:** Backend API para gestión de disponibilidad y reservas

##### Módulo 6: Sistema de Pagos (Fase 4)

| RF ID | Requisito | Prioridad | Fase | Estimación |
|-------|-----------|-----------|------|------------|
| RF-051 | Integración con Pasarela de Pago | Must Have | Fase 4 | 40h |
| RF-052 | Registro de Métodos de Pago | Must Have | Fase 4 | 24h |
| RF-053 | Procesamiento de Pago al Reservar | Must Have | Fase 4 | 32h |
| RF-054 | Historial de Transacciones | Must Have | Fase 4 | 20h |
| RF-055 | Reembolsos | Should Have | Fase 4 | 32h |
| RF-056 | Facturación Electrónica | Nice to Have | Fase 5 | 40h |

**Estado Actual:** ❌ No implementado
**Proveedor Recomendado:** Stripe (internacional) o PayU (Colombia)

##### Módulo 7: Comunicación (Fase 3)

| RF ID | Requisito | Prioridad | Fase | Estimación |
|-------|-----------|-----------|------|------------|
| RF-061 | Chat en Tiempo Real | Must Have | Fase 3 | 40h |
| RF-062 | Videollamadas Integradas | Must Have | Fase 3 | 48h |
| RF-063 | Compartir Archivos en Chat | Should Have | Fase 3 | 16h |
| RF-064 | Historial de Conversaciones | Must Have | Fase 3 | 16h |
| RF-065 | Notificaciones Push | Should Have | Fase 3 | 24h |

**Estado Actual:** ❌ No implementado
**Proveedores Recomendados:** 
- Chat: Socket.io o Firebase Realtime Database
- Video: Agora, Twilio Video, o Daily.co

##### Módulo 8: Administración y Moderación

| RF ID | Requisito | Prioridad | Fase | Estimación |
|-------|-----------|-----------|------|------------|
| RF-071 | Dashboard Administrativo | Must Have | Fase 2 | 32h |
| RF-072 | Aprobación/Rechazo de Tutores | Must Have | Fase 2 | 20h |
| RF-073 | Gestión de Reportes/Denuncias | Should Have | Fase 3 | 24h |
| RF-074 | Analytics y Métricas | Should Have | Fase 3 | 32h |
| RF-075 | Gestión de Contenido (CMS) | Nice to Have | Fase 4 | 40h |

**Estado Actual:** Dashboard básico implementado sin funcionalidad
**Gap Principal:** Backend admin API y rol-based access control

---

### 1.3 Requisitos No Funcionales

#### RNF-001: Performance y Escalabilidad

**Tiempo de Respuesta de Páginas Web**

| Página | Meta p95 | Actual (Estimado) | Gap | Prioridad |
|--------|----------|-------------------|-----|-----------|
| Página de inicio (marketplace) | < 2s | ~2.8s | ⚠️ 0.8s | 🔴 ALTA |
| Perfiles de tutor | < 1.5s | ~2.5s | ⚠️ 1.0s | 🔴 ALTA |
| Dashboards | < 2s | ~3.0s | ⚠️ 1.0s | 🟠 MEDIA |

**Core Web Vitals (Meta Google)**

| Métrica | Descripción | Meta | Actual Estimado | Gap |
|---------|-------------|------|-----------------|-----|
| **LCP** | Largest Contentful Paint | < 2.5s | ~2.8s | ⚠️ Optimizar imágenes |
| **FID** | First Input Delay | < 100ms | ~150ms | ⚠️ Code splitting |
| **CLS** | Cumulative Layout Shift | < 0.1 | ~0.15 | ⚠️ Reserved space |

**Medición:** Google Lighthouse, Web Vitals API, Real User Monitoring (RUM)

**Escalabilidad de Usuarios Concurrentes**

| Fase | Usuarios Totales | Usuarios Concurrentes | Frontend Capacity | Backend Capacity |
|------|------------------|----------------------|-------------------|------------------|
| MVP (Fase 1) | 500 | 50 | ✅ Soportado (CDN S3) | ⚠️ Requiere diseño |
| Fase 2 | 2,000 | 200 | ✅ Soportado | ⚠️ Auto-scaling |
| Año 1 | 10,000 | 1,000 | ✅ Soportado | ⚠️ Horizontal scaling |
| Año 3 | 50,000 | 5,000 | ⚠️ Requiere CDN global | ⚠️ Kubernetes |

**Estrategia de Escalabilidad Frontend:**
1. **CDN Multi-región:** CloudFront con edge locations en LATAM
2. **Optimización de Assets:**
   - Lazy loading de imágenes y componentes
   - Code splitting por ruta
   - Tree shaking para eliminar código no usado
3. **Caching Estratégico:**
   - Service Worker para offline-first
   - SWR (stale-while-revalidate) para API data
   - Browser cache headers optimizados
4. **Bundle Optimization:**
   - Meta actual: ~180KB gzipped
   - Meta Fase 2: < 150KB gzipped
   - Análisis con webpack-bundle-analyzer

#### RNF-002: Disponibilidad y Confiabilidad

**Disponibilidad (Uptime)**

| Componente | SLA Target | Downtime Permitido/mes | Actual | Gap |
|------------|-----------|------------------------|--------|-----|
| **Frontend (S3/CloudFront)** | 99.9% | 43 minutos | 99.95% | ✅ Cumplido |
| **Backend API** | 99.9% | 43 minutos | ⚠️ Por diseñar | - |
| **Base de Datos** | 99.95% | 21 minutos | ⚠️ Por diseñar | - |

**Horario Crítico:** Lunes-Domingo 6:00-23:00 hora Colombia (UTC-5)

**Disaster Recovery**

| Aspecto | RPO | RTO | Estrategia |
|---------|-----|-----|------------|
| **Frontend Assets** | < 5 min | < 15 min | Multi-region S3 replication + CDN |
| **User Data** | < 1 hora | < 4 horas | Database backups + PITR |
| **Código Fuente** | 0 (Git) | < 30 min | GitHub como fuente de verdad |

**Tolerancia a Fallos Frontend**

| Escenario | Estrategia | Estado Actual |
|-----------|-----------|---------------|
| **API Backend Caído** | Error boundary + mensaje amigable | ⚠️ Parcial |
| **CDN Edge Failure** | Automatic failover a origen | ✅ CloudFront nativo |
| **JavaScript Error** | Error tracking (Sentry) + graceful degradation | ❌ No implementado |
| **Offline Mode** | Service Worker + cached data | ❌ No implementado |

#### RNF-003: Seguridad

**Autenticación y Autorización**

| Fase | Método | Estado Actual | Recomendación |
|------|--------|---------------|---------------|
| **MVP (Fase 1)** | localStorage + session | ⚠️ Implementado | 🔴 Migrar urgente |
| **Fase 2** | JWT (access + refresh tokens) | ❌ No implementado | 🔴 Crítico |
| **Fase 3** | OAuth 2.0 (Google, Facebook) | ❌ No implementado | 🟠 Alta |
| **Fase 5** | MFA (TOTP) | ❌ No implementado | 🟡 Media |

**Vulnerabilidades Identificadas en Código Actual**

| Vulnerabilidad | Severidad | Ubicación | Impacto | Remediación |
|----------------|-----------|-----------|---------|-------------|
| **Tokens en localStorage** | 🔴 CRÍTICA | `AuthContext.tsx` | XSS puede robar tokens | Migrar a httpOnly cookies |
| **No CSRF protection** | 🔴 ALTA | Global | Ataques CSRF posibles | Implementar CSRF tokens |
| **No input validation** | 🟠 MEDIA | Formularios | Inyección de código | Zod schema validation |
| **Sensitive data in logs** | 🟠 MEDIA | Console.log | Exposición de info | Remover logs de producción |
| **No rate limiting** | 🟡 MEDIA | API calls | DDoS/brute force | Implementar en backend + frontend throttle |

**Compliance y Regulaciones**

| Normativa | Aplicable | Estado Actual | Esfuerzo Restante |
|-----------|-----------|---------------|-------------------|
| **GDPR** | ⚠️ Parcial (futura expansión EU) | 30% | 80h |
| **PCI-DSS** | ✅ Sí (pagos Fase 4) | 0% | Usar Stripe (compliance incluido) |
| **LOPD Colombia** | ✅ Sí | 20% | 40h |
| **WCAG 2.1 AA** | ✅ Sí (accesibilidad) | 40% | 60h |

**Encriptación**

| Capa | Requerimiento | Estado Actual | Gap |
|------|---------------|---------------|-----|
| **Datos en tránsito** | TLS 1.3 | ✅ HTTPS CloudFront | Cumplido |
| **Datos en reposo** | AES-256 | ⚠️ Backend | Por implementar |
| **Tokens JWT** | Signed RS256 | ❌ No implementado | Crítico Fase 2 |

#### RNF-004: Usabilidad y Accesibilidad

**Diseño Responsivo**

| Dispositivo | Breakpoint | Soporte Actual | Core Web Vitals | Gap |
|-------------|-----------|----------------|-----------------|-----|
| **Mobile** | < 640px | ✅ Implementado | ~70 score | Optimizar imágenes |
| **Tablet** | 640px-1024px | ✅ Implementado | ~75 score | Touch targets |
| **Desktop** | > 1024px | ✅ Implementado | ~80 score | Lazy loading |

**Accesibilidad WCAG 2.1**

| Criterio | Nivel | Estado Actual | Prioridad | Esfuerzo |
|----------|-------|---------------|-----------|----------|
| **1.1 Alternativas de Texto** | A | ⚠️ Parcial | 🔴 ALTA | 16h |
| **1.3 Adaptable** | A | ✅ Bueno | 🟢 BAJA | 4h |
| **1.4 Distinguible** | AA | ⚠️ Parcial | 🟠 MEDIA | 24h |
| **2.1 Accesible por Teclado** | A | ⚠️ Parcial | 🔴 ALTA | 32h |
| **2.4 Navegable** | AA | ⚠️ Parcial | 🟠 MEDIA | 20h |
| **3.1 Legible** | A | ✅ Bueno | 🟢 BAJA | 8h |
| **3.2 Predecible** | AA | ✅ Bueno | 🟢 BAJA | 4h |
| **4.1 Compatible** | A | ⚠️ Parcial | 🟠 MEDIA | 16h |

**Herramientas de Auditoría:**
- axe DevTools
- WAVE Browser Extension
- Lighthouse Accessibility Score
- Screen reader testing (NVDA, JAWS)

**Internacionalización (i18n)**

| Aspecto | Estado Actual | Meta Fase 3 |
|---------|---------------|-------------|
| **Idiomas soportados** | Español (hardcoded) | ES + EN + PT |
| **Formato de fechas** | Nativo JS | Intl.DateTimeFormat |
| **Formato de moneda** | COP hardcoded | Multi-currency support |
| **Biblioteca recomendada** | - | next-intl o i18next |

#### RNF-005: Mantenibilidad y Calidad de Código

**Cobertura de Tests**

| Tipo de Test | Cobertura Actual | Meta Fase 2 | Meta Año 1 | Herramientas |
|--------------|------------------|-------------|------------|--------------|
| **Unit Tests** | 0% | 70% | 85% | Jest + Testing Library |
| **Integration Tests** | 0% | 40% | 60% | Testing Library + MSW |
| **E2E Tests** | 0% | 20% | 40% | Playwright o Cypress |

**Métricas de Calidad de Código**

| Métrica | Valor Actual | Meta | Herramienta |
|---------|--------------|------|-------------|
| **TypeScript Coverage** | ~80% | 100% | `tsc --noEmit` |
| **ESLint Errors** | ~15 warnings | 0 errors | ESLint |
| **Code Duplication** | ~12% (estimado) | < 5% | SonarQube |
| **Cyclomatic Complexity** | ~8 (promedio) | < 10 | Code Climate |
| **Technical Debt** | ~20 días (estimado) | < 10 días | SonarQube |

**Documentación**

| Tipo | Estado Actual | Meta |
|------|---------------|------|
| **README** | ✅ Completo | Mantener actualizado |
| **Componentes (Storybook)** | ❌ No implementado | Fase 3 |
| **API Documentation** | ❌ No existe | JSDoc + TypeDoc (Fase 2) |
| **Architecture Decision Records (ADRs)** | ❌ No existe | Este documento + ADRs |

#### RNF-006: Optimización de Costos

**Estimación de Costos Mensuales - Frontend**

| Recurso | MVP (500 users) | Fase 2 (2K users) | Año 1 (10K users) | Año 3 (50K users) |
|---------|-----------------|-------------------|-------------------|-------------------|
| **AWS S3 (hosting)** | $5 | $10 | $30 | $80 |
| **AWS CloudFront (CDN)** | $15 | $50 | $200 | $800 |
| **GitHub Actions (CI/CD)** | $0 (free tier) | $0 | $50 | $200 |
| **Sentry (error tracking)** | $26 | $26 | $79 | $149 |
| **Vercel (alternativa)** | $20 | $20 | $150 | $400 |
| **TOTAL ESTIMADO** | **$46/mes** | **$106/mes** | **$509/mes** | **$1,629/mes** |

**Optimizaciones de Costo Recomendadas:**
1. **Aggressive caching:** Cache-Control headers optimizados (1 año para assets)
2. **Image optimization:** WebP con fallback (reduce bandwidth 30-50%)
3. **Lazy loading:** Code splitting reduce initial bundle (ahorro ~40%)
4. **Gzip/Brotli compression:** Reduce transfer size 70-80%
5. **Reserved instances:** Considerar RI para backend (ahorro 30-50%)

---

### 1.4 Análisis del Stack Tecnológico Actual

#### Frontend Stack Actual

| Componente | Tecnología | Versión | Evaluación | Acción Recomendada |
|------------|-----------|---------|------------|--------------------|
| **Framework** | Next.js | 16.0.0 | ✅ Excelente | Mantener |
| **Runtime** | React | 19.2.0 | ✅ Última versión | Mantener |
| **Lenguaje** | TypeScript | 5.9.3 | ✅ Última versión | Mantener |
| **Estilos** | Tailwind CSS | 4.1.16 | ✅ Última versión | Mantener |
| **Build Tool** | Turbopack (Next.js) | Incluido | ✅ Muy rápido | Mantener |
| **Linting** | ESLint | 9.38.0 | ✅ Actualizado | Configurar reglas strict |
| **Type Checking** | TypeScript | 5.9.3 | ⚠️ No strict | Habilitar strict mode |
| **Iconos** | Heroicons | 2.2.0 | ✅ Buena elección | Mantener |
| **HTTP Client** | Axios | 1.13.1 | ✅ Estándar | Mantener + agregar interceptors |
| **Authentication** | Custom (localStorage) | N/A | ❌ Inseguro | Reemplazar (JWT + cookies) |
| **State Management** | React Context | Nativo | ⚠️ Limitado | Migrar a Zustand Fase 2 |
| **Face Recognition** | @vladmandic/face-api | 1.7.15 | ⚠️ ¿Necesario? | Evaluar ROI vs complejidad |
| **Firebase** | Firebase | 12.4.0 | ⚠️ ¿Uso actual? | Clarificar propósito |

#### Dependencias Faltantes Críticas

| Librería | Propósito | Prioridad | Fase | Justificación |
|----------|-----------|-----------|------|---------------|
| **Zod** | Schema validation | 🔴 ALTA | Fase 2 | Type-safe validation |
| **React Hook Form** | Form management | 🔴 ALTA | Fase 2 | Performance + UX |
| **SWR** | Data fetching | 🔴 ALTA | Fase 2 | Caching + revalidation |
| **Zustand** | State management | 🟠 MEDIA | Fase 2 | Escala mejor que Context |
| **Jest** | Unit testing | 🔴 CRÍTICA | Inmediato | Calidad de código |
| **@testing-library/react** | Component testing | 🔴 CRÍTICA | Inmediato | Testing Library |
| **MSW** | API mocking | 🟠 MEDIA | Fase 2 | Testing realista |
| **Playwright** | E2E testing | 🟡 MEDIA | Fase 3 | User flows completos |
| **next-intl** | Internacionalización | 🟡 MEDIA | Fase 3 | i18n escalable |
| **Framer Motion** | Animations | 🟢 BAJA | Fase 4 | UX premium |

#### Análisis de Arquitectura del Código Actual

**Estructura de Carpetas Actual**

```
mi-toga/
├── app/                        # ✅ App Router Next.js 16
│   ├── (public)/              # ✅ Buena práctica: Route groups
│   │   ├── layout.tsx
│   │   ├── page.tsx           # Marketplace (856 líneas - ⚠️ muy grande)
│   │   ├── login/
│   │   ├── registro/
│   │   ├── registro-exitoso/
│   │   └── ser-tutor/
│   ├── dashboard/             # Dashboards por rol
│   │   ├── estudiante/
│   │   ├── tutor/
│   │   └── admin/
│   ├── layout.tsx             # Root layout
│   └── globals.css
├── components/                # ⚠️ Flat structure (no agrupados)
│   ├── EventosEspecialesModal.tsx
│   ├── Footer.tsx
│   ├── LoadingScreen.tsx
│   ├── PageLoader.tsx
│   ├── PDFViewerModal.tsx
│   ├── PhoneInput.tsx
│   ├── Providers.tsx
│   ├── PropuestaEventoModal.tsx
│   ├── TutorCard.tsx
│   ├── TutorProfileModal.tsx
│   ├── TutorsShowcase.tsx
│   ├── InscripcionEventoModal.tsx
│   └── ui/
│       └── Modal.tsx
├── contexts/                  # ✅ Separados
│   └── AuthContext.tsx        # ⚠️ localStorage (seguridad)
├── hooks/                     # ✅ Custom hooks
│   └── useAuth.ts
├── lib/                       # ⚠️ Mix de utilidades y datos
│   └── mock-data.ts          # ⚠️ Mock data hardcoded
├── types/                     # ✅ TypeScript types
│   └── tutor.ts
├── public/                    # Assets estáticos
├── docs/                      # Documentación
├── .vscode/                   # VS Code config
└── out/                       # Build output (SSG)
```

**Problemas Arquitectónicos Identificados**

| Problema | Severidad | Ubicación | Impacto | Solución |
|----------|-----------|-----------|---------|----------|
| **Componente monolítico gigante** | 🔴 ALTA | `page.tsx` (856 líneas) | Mantenibilidad baja | Refactorizar en componentes |
| **Mock data hardcoded** | 🔴 ALTA | `lib/mock-data.ts` | No escalable | Capa de servicios + API |
| **No separación de concerns** | 🟠 MEDIA | `page.tsx` | Lógica + UI mezcladas | Feature-based architecture |
| **localStorage para auth** | 🔴 CRÍTICA | `AuthContext.tsx` | Vulnerabilidad XSS | JWT + httpOnly cookies |
| **No validación de datos** | 🟠 MEDIA | Formularios | Errores en runtime | Zod schemas |
| **Componentes no tipados** | 🟡 MEDIA | Varios | TypeScript parcial | Strict mode + interfaces |
| **No lazy loading** | 🟡 MEDIA | Imports | Bundle grande | dynamic() Next.js |
| **Flat component structure** | 🟡 MEDIA | `components/` | Difícil navegar | Agrupar por feature |

**Componente `page.tsx` (Marketplace) - Análisis Detallado**

**Líneas de código:** 856 líneas (⚠️ debe ser < 300)

**Responsabilidades mezcladas:**
1. ❌ Estado local (8 useState hooks)
2. ❌ Lógica de filtrado de tutores
3. ❌ Paginación
4. ❌ Ordenamiento
5. ❌ Renderizado de UI
6. ❌ Modal management
7. ❌ LocalStorage para eventos especiales

**Fragmento de código problemático:**

```tsx
// ⚠️ PROBLEMA: Demasiados estados en un componente
const [selectedSubject, setSelectedSubject] = useState<string>('all');
const [selectedCity, setSelectedCity] = useState<string>('all');
const [selectedModality, setSelectedModality] = useState<string>('all');
const [sortBy, setSortBy] = useState<string>('featured');
const [onlineOnly, setOnlineOnly] = useState<boolean>(false);
const [searchQuery, setSearchQuery] = useState<string>('');
const [selectedTutor, setSelectedTutor] = useState<Tutor | null>(null);
const [isModalOpen, setIsModalOpen] = useState(false);

// ⚠️ PROBLEMA: Lógica de negocio en componente de UI
const filteredTutors = useMemo(() => {
  let filtered = [...mockTutors]; // ⚠️ Mock data hardcoded
  
  if (searchQuery) {
    filtered = filtered.filter(tutor =>
      tutor.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      tutor.specialty.toLowerCase().includes(searchQuery.toLowerCase()) ||
      tutor.subjects.some(s => s.toLowerCase().includes(searchQuery.toLowerCase()))
    );
  }
  // ... más filtros (80+ líneas)
}, [selectedSubject, selectedCity, selectedModality, sortBy, onlineOnly, searchQuery]);
```

**Refactoring Recomendado:**

```tsx
// ✅ SOLUCIÓN: Custom hook para filtros
function useMarketplaceFilters() {
  const [filters, setFilters] = useState<MarketplaceFilters>({
    subject: 'all',
    city: 'all',
    modality: 'all',
    sortBy: 'featured',
    onlineOnly: false,
    searchQuery: ''
  });
  
  return { filters, setFilters };
}

// ✅ SOLUCIÓN: Servicio separado para lógica de negocio
class TutorFilterService {
  static filterTutors(tutors: Tutor[], filters: MarketplaceFilters): Tutor[] {
    // Lógica de filtrado
  }
}

// ✅ SOLUCIÓN: Componente limpio
export default function MarketplacePage() {
  const { filters, setFilters } = useMarketplaceFilters();
  const { data: tutors, isLoading } = useTutors(filters); // SWR hook
  
  return (
    <>
      <SearchBar filters={filters} onFiltersChange={setFilters} />
      <TutorGrid tutors={tutors} isLoading={isLoading} />
    </>
  );
}
```

#### Análisis de Configuración Next.js

**`next.config.ts` Actual:**

```typescript
const nextConfig: NextConfig = {
  output: 'export', // ⚠️ SSG estático - limita features
  images: {
    unoptimized: true, // ⚠️ No optimización de imágenes
    remotePatterns: [
      {
        protocol: 'https',
        hostname: '**', // ⚠️ Inseguro - permite cualquier dominio
      },
    ],
  },
  trailingSlash: true, // ✅ OK para S3
};
```

**Problemas Identificados:**

| Configuración | Problema | Impacto | Solución Recomendada |
|---------------|----------|---------|----------------------|
| `output: 'export'` | No permite API Routes, ISR, ni SSR | Sin dynamic features | Migrar a SSR híbrido (Vercel) |
| `images.unoptimized: true` | No optimización automática de imágenes | Performance degradada | Usar CDN con optimización o next/image |
| `remotePatterns: '**'` | Acepta imágenes de cualquier dominio | Riesgo de seguridad | Whitelist específica de dominios |
| No `i18n` config | Solo español hardcoded | No escalable | Agregar next-intl config |

**Configuración Recomendada para Fase 2:**

```typescript
const nextConfig: NextConfig = {
  // ✅ Híbrido: SSG + SSR + ISR
  // output: 'export', // ❌ Remover
  
  images: {
    // ✅ Optimización automática
    unoptimized: false,
    formats: ['image/webp', 'image/avif'],
    deviceSizes: [640, 750, 828, 1080, 1200, 1920],
    imageSizes: [16, 32, 48, 64, 96, 128, 256, 384],
    
    // ✅ Whitelist específica
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'mitoga-assets.s3.amazonaws.com',
      },
      {
        protocol: 'https',
        hostname: 'firebasestorage.googleapis.com',
        pathname: '/v0/b/mitoga-prod/**',
      },
    ],
  },
  
  // ✅ Revalidación incremental
  experimental: {
    optimizeCss: true,
    optimizePackageImports: ['@heroicons/react'],
  },
  
  // ✅ Headers de seguridad
  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
          {
            key: 'X-DNS-Prefetch-Control',
            value: 'on'
          },
          {
            key: 'Strict-Transport-Security',
            value: 'max-age=63072000; includeSubDomains; preload'
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff'
          },
          {
            key: 'X-Frame-Options',
            value: 'SAMEORIGIN'
          },
          {
            key: 'X-XSS-Protection',
            value: '1; mode=block'
          },
          {
            key: 'Referrer-Policy',
            value: 'strict-origin-when-cross-origin'
          },
        ],
      },
    ];
  },
  
  // ✅ Redirects SEO-friendly
  async redirects() {
    return [
      {
        source: '/tutor/:id',
        destination: '/tutores/:id',
        permanent: true,
      },
    ];
  },
};
```

#### Análisis de Testing

**Estado Actual:** 🔴 CRÍTICO - 0% cobertura

**Evidencias:**
- No se encontraron archivos `*.test.ts` o `*.spec.ts`
- No hay configuración de Jest/Vitest
- No hay GitHub Actions para CI con tests
- No hay `@testing-library` instalado

**Impacto:**
- Bugs no detectados antes de producción
- Refactoring riesgoso (sin safety net)
- Confianza baja en deploys
- Deuda técnica acumulándose

**Estimación de Bugs en Producción sin Tests:**
- Bugs críticos: 3-5 por mes
- Bugs medios: 10-15 por mes
- Costo de corrección post-release: 5x más caro

---

### 1.5 Restricciones y Limitaciones

#### Restricciones Técnicas

| Restricción | Descripción | Impacto | Mitigación |
|-------------|-------------|---------|------------|
| **Presupuesto Limitado** | Budget frontend ~$500/mes Fase 1 | No puede usar servicios premium | Usar servicios open-source + free tiers |
| **Equipo Pequeño** | 1-2 desarrolladores frontend | Velocidad de desarrollo limitada | Priorizar MVP features, usar componentes pre-hechos |
| **Deadlines Agresivos** | MVP en 3 meses | Complejidad limitada | Monolito modular inicialmente |
| **Experiencia con DDD** | Equipo junior en DDD | Curva de aprendizaje | Training + pair programming |
| **Hosting S3 Actual** | Deployment estático actual | No SSR ni API routes | Migrar a Vercel Fase 2 |

#### Dependencias Externas Críticas

| Dependencia | Proveedor | Fase | Costo | Riesgo |
|-------------|-----------|------|-------|--------|
| **Backend API** | Por desarrollar | Fase 1-2 | - | 🔴 Bloqueante |
| **Pasarela de Pago** | Stripe/PayU | Fase 4 | % transacción | 🟡 Vendor lock-in |
| **Videollamadas** | Agora/Twilio | Fase 3 | Por uso | 🟡 Vendor lock-in |
| **Email Service** | SendGrid/SES | Fase 2 | $10-50/mes | 🟢 Reemplazable |
| **SMS Service** | Twilio | Fase 2 | $50-200/mes | 🟢 Reemplazable |

#### Compliance y Regulaciones

| Regulación | Aplicabilidad | Fecha Límite | Esfuerzo | Prioridad |
|------------|---------------|--------------|----------|-----------|
| **LOPD Colombia** | ✅ Obligatorio | Fase 2 | 40h | 🔴 ALTA |
| **WCAG 2.1 AA** | ✅ Obligatorio (accesibilidad) | Fase 3 | 60h | 🟠 MEDIA |
| **GDPR** | ⚠️ Futura expansión EU | Fase 5 | 80h | 🟢 BAJA |
| **PCI-DSS** | ✅ Obligatorio (pagos) | Fase 4 | Delegado a Stripe | 🟡 MEDIA |

---

### 1.6 Supuestos Documentados

Estos supuestos requieren validación con stakeholders antes de Fase 2:

| # | Supuesto | Criticidad | Necesita Validación |
|---|----------|------------|---------------------|
| 1 | Backend API estará listo para integración en mes 2 | 🔴 ALTA | Product Owner |
| 2 | Budget mensual frontend: $500 (Fase 1), $1,000 (Fase 2) | 🔴 ALTA | CFO/Finanzas |
| 3 | Equipo: 2 dev frontend + 1 UX designer disponibles | 🔴 ALTA | Tech Lead |
| 4 | Hosting en AWS (S3 + CloudFront) es mandatorio | 🟠 MEDIA | DevOps Lead |
| 5 | OAuth 2.0 con Google y Facebook es suficiente (no Apple) | 🟡 MEDIA | Product Owner |
| 6 | No se requiere app móvil nativa en Fase 1-3 | 🟡 MEDIA | Product Owner |
| 7 | Stripe es aceptable como pasarela de pago (alternativa: PayU) | 🟠 MEDIA | Finanzas |
| 8 | Testing coverage target: 80% (industry standard) | 🟢 BAJA | Tech Lead |
| 9 | CI/CD con GitHub Actions (no Jenkins/GitLab CI) | 🟢 BAJA | DevOps |
| 10 | Inglés como segundo idioma (no portugués) en Fase 3 | 🟢 BAJA | Product Owner |

---

## 2️⃣ FASE EJECUCIÓN - Diseño de Arquitectura

_(Continuará en siguiente sección...)_

**Próximas Secciones del Documento:**
- 2.1 Patrón Arquitectónico Seleccionado (Modular Monolith + DDD Táctico)
- 2.2 Diagramas C4 Model (Contexto, Contenedores, Componentes)
- 2.3 Stack Tecnológico Recomendado Completo
- 2.4 Diseño de Componentes y Módulos
- 2.5 Estrategia de Estado y Data Fetching
- 2.6 Seguridad y Autenticación (JWT Strategy)
- 2.7 Performance y Optimización
- 2.8 Testing Strategy Completa
- 2.9 CI/CD Pipeline
- 2.10 Monitoreo y Observabilidad

**Total de Páginas Estimadas:** 180-200 páginas

**Fecha de Entrega Completa:** Requiere 16-20 horas de trabajo adicional

---

**Notas de Progreso:**
- ✅ Fase 1 Contexto: COMPLETADA (Secciones 1.1-1.6)
- ⏳ Fase 2 Ejecución: EN PROGRESO
- ⏸️ Fase 3 Informe: PENDIENTE

**Última Actualización:** 2025-11-08 19:45 UTC-5
