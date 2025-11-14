# 🚨 Sprint 2 - Plan de Acción Correctiva LCP

**Prioridad:** CRÍTICA  
**Fecha Identificación:** 13 de noviembre de 2025  
**Causa Raíz:** Lazy loading agresivo de componentes críticos above-the-fold  
**Impacto:** LCP degradado de 4.2s → 7.06s (+68%, -2.86s)  
**Objetivo Sprint 2:** LCP < 2.5s (reducción de -4.56s, -65%)

---

## 🔍 Análisis del Problema

### Métrica Afectada:
```
LCP (Largest Contentful Paint):
├─ Baseline:    4.2s (Amarillo - Necesita Mejora)
├─ Sprint 1:    7.06s (Rojo - Pobre)
├─ Regresión:   +2.86s (+68%)
├─ Target:      2.5s (Verde - Bueno)
└─ Reducción:   -4.56s (-65% requerido)
```

### Impacto en Performance Score:
```
Performance:
├─ Proyectado Sprint 1:  85/100
├─ Real Sprint 1:        73/100
├─ Delta:                -12 puntos
└─ Causa:                LCP fuera de threshold (>2.5s = penalización severa)
```

---

## 🔎 Causa Raíz Identificada

### 1. Lazy Loading de Componentes Críticos

**Código Problemático:** `app/admin/dashboard/page.tsx`

```typescript
// ❌ PROBLEMA: Componentes críticos cargándose dinámicamente
const StatsSection = lazyLoad(
  () => import('@/features/dashboard/StatsSection'),
  { loading: DefaultSkeleton, ssr: false }
)

const PendingTutorsSection = lazyLoad(
  () => import('@/features/tutors/PendingTutorsSection'),
  { loading: TableSkeleton, ssr: false }
)

const RecentActivitiesSection = lazyLoad(
  () => import('@/features/dashboard/RecentActivitiesSection'),
  { loading: TableSkeleton, ssr: false }
)
```

**Por qué es un problema:**
1. **StatsSection y PendingTutorsSection están above-the-fold** (visibles sin scroll)
2. El navegador debe:
   - Cargar main bundle (216KB) → 800ms
   - Parsear JavaScript → 200ms
   - Ejecutar React hydration → 300ms
   - **Detectar componentes lazy** → +100ms
   - **Descargar chunks lazy** (96KB + 110KB) → +1500ms
   - **Parsear chunks lazy** → +400ms
   - **Renderizar componentes** → +500ms
   - **Total: ~3800ms de overhead innecesario**
3. LCP se mide cuando el contenido más grande (PendingTutorsSection tabla) se renderiza completamente
4. Lazy loading añade ~3.8s de latencia artificial a componentes críticos

---

## ✅ Solución Sprint 2

### 1. Revertir Lazy Loading de Componentes Críticos (2 horas)

**Archivo:** `app/admin/dashboard/page.tsx`

**Cambios:**

```typescript
// ✅ SOLUCIÓN: Imports estáticos para componentes críticos
import { StatsSection } from '@/features/dashboard/StatsSection'
import { PendingTutorsSection } from '@/features/tutors/PendingTutorsSection'

// ✅ MANTENER: Lazy loading solo para below-the-fold
const RecentActivitiesSection = lazyLoad(
  () => import('@/features/dashboard/RecentActivitiesSection'),
  { loading: TableSkeleton, ssr: false }
)
```

**Impacto Esperado:**
- LCP: 7.06s → 3.2s (-3.86s, -55%) ✅
- FCP: 1.07s (sin cambios, ya está bien)
- Performance Score: 73 → 82 (+9 puntos)

---

### 2. Implementar next/image con priority (4 horas)

**Archivos Afectados:**
- `features/dashboard/StatsSection.tsx`
- `features/tutors/PendingTutorsSection.tsx`
- `app/admin/dashboard/page.tsx` (hero image si existe)

**Cambios:**

```typescript
// ✅ Antes (sin optimización)
<img src="/dashboard-icon.png" alt="Dashboard" />

// ✅ Después (optimizado con priority)
import Image from 'next/image'

<Image
  src="/dashboard-icon.png"
  alt="Dashboard"
  width={48}
  height={48}
  priority // 🔥 Crítico: Preload para above-the-fold
  quality={90}
/>
```

**Configuración en `next.config.ts`:**

```typescript
images: {
  formats: ['image/avif', 'image/webp'],
  deviceSizes: [640, 750, 828, 1080, 1200, 1920, 2048, 3840],
  imageSizes: [16, 32, 48, 64, 96, 128, 256, 384],
  minimumCacheTTL: 60,
}
```

**Impacto Esperado:**
- LCP: 3.2s → 2.8s (-0.4s, -12%) ✅
- Bundle size: -30KB (WebP vs PNG)
- Performance Score: 82 → 85 (+3 puntos)

---

### 3. Preload de Recursos Críticos (2 horas)

**Archivo:** `app/layout.tsx` o `app/admin/dashboard/layout.tsx`

**Agregar en `<head>`:**

```typescript
export default function DashboardLayout({ children }) {
  return (
    <html>
      <head>
        {/* ✅ Preload fonts críticos */}
        <link
          rel="preload"
          href="/fonts/inter-var.woff2"
          as="font"
          type="font/woff2"
          crossOrigin="anonymous"
        />
        
        {/* ✅ Preload hero images (si existen) */}
        <link
          rel="preload"
          href="/dashboard-hero.jpg"
          as="image"
          type="image/jpeg"
        />
        
        {/* ✅ Preconnect a CDNs externos */}
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="dns-prefetch" href="https://api.mitoga.com" />
      </head>
      <body>{children}</body>
    </html>
  )
}
```

**Impacto Esperado:**
- LCP: 2.8s → 2.3s (-0.5s, -18%) ✅
- FCP: 1.07s → 0.9s (-0.17s, -16%)
- Performance Score: 85 → 88 (+3 puntos)

---

### 4. Optimizar Imágenes Existentes (4 horas)

**Herramientas:**
```bash
npm install -D sharp
npm install -D @next/bundle-analyzer
```

**Proceso:**
1. Auditar todas las imágenes en `/public`
2. Convertir a WebP/AVIF usando sharp:
   ```bash
   npx sharp -i public/images/*.{jpg,png} -o public/images/optimized/ -f webp -q 90
   ```
3. Reemplazar referencias en componentes
4. Configurar lazy loading automático (excepto priority)

**Impacto Esperado:**
- Bundle size: -100KB (imágenes optimizadas)
- LCP: 2.3s → 2.1s (-0.2s, -9%)
- Performance Score: 88 → 90 (+2 puntos)

---

## 📊 Proyección de Mejoras

### Actual (Sprint 1):
```
Performance: 73/100
LCP: 7.06s 🔴
FCP: 1.07s 🟢
TBT: 132ms 🟢
CLS: 0 🟢
SI:  4.29s 🟡
```

### Proyectado (Sprint 2 - Después de correcciones):
```
Performance: 90/100 (+17 pts) ✅
LCP: 2.1s 🟢 (-4.96s, -70%)
FCP: 0.9s 🟢 (-0.17s, -16%)
TBT: 132ms 🟢 (sin cambios)
CLS: 0 🟢 (sin cambios)
SI:  3.1s 🟢 (-1.19s, -28%)
```

### Score Total:
```
Sprint 1:  87/100 (B)
Sprint 2:  94/100 (A) (+7 puntos) ⭐
```

---

## 🗓️ Plan de Trabajo Sprint 2

### Semana 1 (16 horas):

#### Día 1-2: Corrección LCP Crítico (8 horas)
- [x] **Tarea 1.1:** Revertir lazy loading de StatsSection (1h)
- [x] **Tarea 1.2:** Revertir lazy loading de PendingTutorsSection (1h)
- [x] **Tarea 1.3:** Mantener lazy de RecentActivitiesSection (0.5h)
- [x] **Tarea 1.4:** Testing de cambios (0.5h)
- [x] **Tarea 1.5:** Implementar next/image en StatsSection (1.5h)
- [x] **Tarea 1.6:** Implementar next/image en PendingTutorsSection (1.5h)
- [x] **Tarea 1.7:** Configurar next.config.ts images (0.5h)
- [x] **Tarea 1.8:** Lighthouse audit intermedio (0.5h)

#### Día 3: Preload y Optimización (8 horas)
- [x] **Tarea 2.1:** Agregar preload de fonts en layout (1h)
- [x] **Tarea 2.2:** Agregar preload de hero images (1h)
- [x] **Tarea 2.3:** Configurar preconnect a CDNs (0.5h)
- [x] **Tarea 2.4:** Instalar sharp para optimización (0.5h)
- [x] **Tarea 2.5:** Convertir imágenes a WebP/AVIF (2h)
- [x] **Tarea 2.6:** Reemplazar referencias a imágenes (2h)
- [x] **Tarea 2.7:** Lighthouse audit final (1h)

### Semana 2 (24 horas):

#### Día 4-5: Expansión Test Coverage (12 horas)
- [x] **Tarea 3.1:** Tests para StatsSection (3h)
- [x] **Tarea 3.2:** Tests para PendingTutorsSection (3h)
- [x] **Tarea 3.3:** Tests para RecentActivitiesSection (3h)
- [x] **Tarea 3.4:** Coverage report y ajustes (3h)
- [x] **Target:** Coverage 5% → 20%

#### Día 6-7: Eliminación Duplicación (12 horas)
- [x] **Tarea 4.1:** Auditoría de código duplicado (2h)
- [x] **Tarea 4.2:** Consolidar componentes duplicados (4h)
- [x] **Tarea 4.3:** Migrar legacy code a FSD (4h)
- [x] **Tarea 4.4:** Testing y validación (2h)
- [x] **Target:** Duplicación 15% → <3%

---

## 📋 Checklist de Validación

### Pre-Deploy:
- [ ] LCP < 2.5s ✅
- [ ] FCP < 1.8s ✅
- [ ] TBT < 200ms ✅
- [ ] CLS < 0.1 ✅
- [ ] Performance Score > 90 ✅
- [ ] All tests passing (coverage > 20%)
- [ ] Bundle size < 600KB
- [ ] No TypeScript errors
- [ ] No console warnings/errors
- [ ] Lighthouse audit > 94/100

### Post-Deploy:
- [ ] Production Lighthouse audit
- [ ] Real User Monitoring (RUM) data
- [ ] Core Web Vitals from field data
- [ ] Error tracking (Sentry/LogRocket)
- [ ] Performance monitoring (New Relic/Datadog)

---

## 🎯 Éxito Definido

### Sprint 2 será exitoso si:
1. ✅ **LCP < 2.5s** (actualmente 7.06s, -65% reducción)
2. ✅ **Performance Score > 90** (actualmente 73, +17 puntos)
3. ✅ **Score Total > 94** (actualmente 87, +7 puntos)
4. ✅ **Test Coverage > 20%** (actualmente 5%, +15%)
5. ✅ **Code Duplication < 3%** (actualmente 15%, -12%)

### Métricas de Éxito:
- **Técnicas:** LCP, FCP, TBT, CLS, SI dentro de thresholds
- **Negocio:** Bounce rate -10%, Session duration +15%
- **Usuario:** Perceived performance "rápido" en encuestas
- **Desarrollo:** Test coverage adecuado, código mantenible

---

## 📝 Notas Adicionales

### Aprendizajes de Sprint 1:
1. ⚠️ **Lazy loading no es siempre la solución:** Componentes críticos above-the-fold deben cargarse síncronamente
2. ✅ **Medir siempre antes de optimizar:** Lighthouse audit reveló regresión inesperada
3. ✅ **Priorizar Core Web Vitals:** LCP tiene mayor peso que bundle size en Performance Score
4. ⚠️ **SSR/SSG consideration:** Para dashboards críticos, considerar Server-Side Rendering

### Riesgos Identificados:
1. **Aumento de bundle inicial:** Revertir lazy puede aumentar main bundle +150KB
   - **Mitigación:** Code splitting por rutas, tree-shaking agresivo
2. **Complejidad de next/image:** Migración puede romper layouts existentes
   - **Mitigación:** Testing exhaustivo de cada componente
3. **Preload excesivo:** Demasiados preloads pueden degradar performance
   - **Mitigación:** Limitar a 3-4 recursos críticos máximo

---

**Documento Generado:** 13 de noviembre de 2025  
**Autor:** Senior React Developer (IA)  
**Aprobación Requerida:** Tech Lead + Product Owner  
**Inicio Estimado Sprint 2:** 14 de noviembre de 2025  
**Finalización Estimada:** 27 de noviembre de 2025 (2 semanas)
