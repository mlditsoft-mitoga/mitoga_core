# Inventario de Componentes Técnicos - MI-TOGA

**Proyecto:** MI-TOGA Frontend | **Fecha:** 08/11/2025 | **Versión:** 1.0  
**Fuente:** package.json + configuración + código mi-toga/

---

## 1. Stack Tecnológico

### Framework Principal
- **Next.js:** 16.0.0 (App Router, SSR, Static Generation)
- **React:** 19.2.0 (UI library)
- **TypeScript:** 5.9.0 (tipado estático)

### Styling
- **Tailwind CSS:** 4.1.7 (utility-first CSS)
- **PostCSS:** 8.4.49 (CSS processing)

### Estado y Autenticación
- **React Context API:** (AuthContext - gestión de estado auth)
- **Firebase:** 12.4.0 (preparado, no usado actualmente)

### HTTP y APIs
- **Axios:** 1.13.1 (HTTP client)

### UI/UX
- **@heroicons/react:** 2.2.0 (iconos SVG)
- **@vladmandic/face-api:** 1.7.15 (reconocimiento facial - uso desconocido)

### Calidad de Código
- **ESLint:** 9.18.0 (linting)
- **eslint-config-next:** 16.0.0 (reglas Next.js)

### Build y Tooling
- **Turbopack:** (incluido en Next.js 16 - bundler ultra-rápido)
- **Node.js:** >= 18 (requerido)

---

## 2. Dependencias Completas (package.json)

```json
{
  "dependencies": {
    "@heroicons/react": "^2.2.0",
    "@vladmandic/face-api": "^1.7.15",
    "axios": "^1.13.1",
    "firebase": "^12.4.0",
    "next": "16.0.0",
    "react": "^19.2.0",
    "react-dom": "^19.2.0"
  },
  "devDependencies": {
    "@types/node": "^22",
    "@types/react": "^19",
    "@types/react-dom": "^19",
    "eslint": "^9",
    "eslint-config-next": "16.0.0",
    "postcss": "^8.4.49",
    "tailwindcss": "^4.1.7",
    "typescript": "^5"
  }
}
```

**Total:** 7 dependencies + 7 devDependencies = 14 paquetes

---

## 3. Análisis de Dependencias

### Críticas (Bloqueantes)
- **next, react, react-dom:** Framework base
- **typescript:** Tipado (strict: false, debería ser true)
- **tailwindcss:** Estilos

### Importantes (Alta Prioridad)
- **axios:** HTTP client (preparado para APIs backend)
- **@heroicons/react:** Iconos UI

### Opcionales (Baja Prioridad)
- **firebase:** No usado actualmente (⚠️ puede eliminarse si no se usa)
- **@vladmandic/face-api:** ⚠️ Propósito desconocido (verificación biométrica? no implementado)

### Faltantes Críticas
- ❌ **Jest + React Testing Library:** Testing (0% cobertura)
- ❌ **Zod/Yup:** Validación de esquemas
- ❌ **React Hook Form:** Gestión de formularios
- ❌ **date-fns/dayjs:** Manejo de fechas (necesario para reservas)
- ❌ **Stripe SDK:** Pagos
- ❌ **Agora/Twilio SDK:** Videollamadas
- ❌ **next-i18next:** Internacionalización

---

## 4. Configuración

### next.config.ts
```typescript
import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Config por defecto de Next.js 16
};

export default nextConfig;
```
**Observaciones:** Configuración mínima. Falta:
- `images.domains` (optimización de imágenes externas)
- `env` variables
- `redirects`, `rewrites` si necesario

### tailwind.config.ts
```typescript
import type { Config } from "tailwindcss";

export default {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        background: "var(--background)",
        foreground: "var(--foreground)",
      },
    },
  },
  plugins: [],
} satisfies Config;
```
**Observaciones:** Configuración básica. Podría extenderse con:
- Colores de marca personalizados
- Breakpoints custom
- Plugins (forms, typography, aspect-ratio)

### tsconfig.json
```json
{
  "compilerOptions": {
    "target": "ES2017",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": false,  // ⚠️ DEBERÍA SER TRUE
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
```
**⚠️ Problemas:**
- `strict: false` → Debería ser `true` (TypeScript no está en modo estricto)
- Falta `strictNullChecks`, `noImplicitAny`, etc.

### .eslintrc.json
```json
{
  "extends": "next/core-web-vitals"
}
```
**Observaciones:** Configuración mínima de ESLint. Podría añadir:
- `eslint-plugin-react-hooks` (ya incluido en next/core-web-vitals)
- Reglas custom del equipo

### postcss.config.mjs
```javascript
export default {
  plugins: {
    tailwindcss: {},
  },
};
```
**Observaciones:** Configuración mínima. Funcional.

---

## 5. Patrones y Convenciones Identificadas

### Arquitectura
- **App Router:** Next.js 16 (file-based routing en `/app`)
- **Server/Client Components:** ⚠️ No diferenciados explícitamente (falta `"use client"` en componentes)
- **Layouts:** `app/layout.tsx` (root layout) + layouts por sección

### Estado
- **React Context:** AuthContext para autenticación global
- **useState/useEffect:** Estado local en componentes
- **❌ Falta:** State management robusto (Zustand, Redux si escala)

### Estilos
- **Tailwind Utility-First:** Clases en JSX
- **CSS Modules:** No usado (podría usarse si necesario)
- **Responsive:** Mobile-first con Tailwind breakpoints

### TypeScript
- **Tipos:** Definidos en `/types` (auth.ts, tutor.ts, etc.)
- **⚠️ Problema:** `strict: false` permite `any` implícito

### Formularios
- **⚠️ Sin librería:** Formularios con `<form>` nativo + `onChange`
- **Recomendación:** Migrar a React Hook Form + Zod

### Routing
- **File-based:** `/app/page.tsx` → `/`
- **Grupos de rutas:** `(public)` para rutas públicas
- **Layouts anidados:** `dashboard/layout.tsx`

---

## 6. Calidad de Código

### Tests
- **Cobertura:** 0% (❌ no hay tests)
- **Framework:** ❌ Jest/Vitest no configurado
- **Recomendación:** Añadir Jest + React Testing Library

### Linting
- **ESLint:** ✅ Configurado (next/core-web-vitals)
- **Prettier:** ❌ No configurado (recomendado añadir)
- **Pre-commit hooks:** ❌ No hay Husky (recomendado)

### Documentación
- **README:** ✅ Existe (básico)
- **JSDoc:** ❌ Falta en componentes
- **Storybook:** ❌ No hay (útil para design system)

### Seguridad
- **Dependencias:** ⚠️ Validar con `npm audit`
- **Secrets:** ⚠️ Verificar que no haya `.env` en git
- **CORS:** ⚠️ Configurar en backend cuando exista

---

## 7. Performance

### Optimizaciones Aplicadas
- ✅ **App Router:** Rendering optimizado de Next.js 16
- ✅ **Code Splitting:** Automático por ruta
- ✅ **Turbopack:** Build ultra-rápido (dev mode)

### Optimizaciones Pendientes
- ❌ **Next.js Image:** No usado consistentemente (usar `<Image>` en lugar de `<img>`)
- ❌ **Dynamic Imports:** No usado (útil para modales, componentes pesados)
- ❌ **Lazy Loading:** No implementado en listas largas (virtualización)
- ❌ **Memoización:** Falta `useMemo`, `useCallback` en componentes costosos

---

## 8. Deuda Técnica (Resumen)

### 🔴 Crítica
1. **TypeScript strict: false** → Permite bugs sutiles
2. **Sin tests** → 0% cobertura, alto riesgo de regresiones
3. **Auth mock inseguro** → localStorage sin encriptación
4. **Sin backend** → 100% del negocio pendiente

### 🟠 Alta
5. **Dependencias no usadas:** firebase, face-api (revisar si eliminar)
6. **Sin validación de formularios** → Usar React Hook Form + Zod
7. **Sin manejo de errores global** → Error boundaries
8. **Sin optimización de imágenes** → Usar Next.js `<Image>`

### 🟡 Media
9. **Sin Prettier** → Formateo inconsistente
10. **Sin pre-commit hooks** → Commits sin validar
11. **Sin Storybook** → Difícil mantener design system
12. **Sin i18n** → Hardcoded español

---

## 9. Recomendaciones Inmediatas

### Prioridad 1 (Antes de MVP)
1. **Activar TypeScript strict mode:** `strict: true` en tsconfig.json
2. **Añadir testing:** Jest + React Testing Library (objetivo 60%+)
3. **Implementar backend real:** API REST + PostgreSQL + JWT
4. **Validar dependencias:** `npm audit fix` (seguridad)

### Prioridad 2 (Post-MVP)
5. **Añadir Prettier + Husky:** Formateo automático + pre-commit hooks
6. **Migrar a React Hook Form:** Mejor UX en formularios
7. **Optimizar imágenes:** Next.js `<Image>` en todos los componentes
8. **Añadir Storybook:** Documentar componentes UI

### Prioridad 3 (Mejora Continua)
9. **Implementar i18n:** next-i18next (inglés + español)
10. **Añadir Sentry:** Monitoreo de errores
11. **Implementar CI/CD:** GitHub Actions + tests automáticos
12. **State management:** Zustand/Redux si escala complejidad

---

## 10. Comparación con Estándares

| Aspecto | Estado Actual | Estándar Industria | Gap |
|---------|---------------|-------------------|-----|
| TypeScript | ⚠️ No estricto | Strict mode ON | Activar strict |
| Tests | ❌ 0% | > 80% backend, > 60% frontend | Añadir Jest |
| Linting | ✅ ESLint | ESLint + Prettier | Añadir Prettier |
| Seguridad | ⚠️ Mock auth | JWT + OAuth | Backend real |
| Performance | ✅ Next.js 16 | Next.js + optimizaciones | Optimizar imágenes |
| Docs | ⚠️ README básico | README + JSDoc + Storybook | Documentar componentes |
| CI/CD | ❌ No hay | GitHub Actions + deploy auto | Implementar |
| Monitoring | ❌ No hay | Sentry + Analytics | Implementar |

---

## 11. Componentes UI Más Complejos (por LOC)

El frontend tiene componentes excepcionalmente complejos, especialmente en los flujos de registro:

| Componente | Path | LOC | Responsabilidad | Complejidad |
|------------|------|-----|-----------------|-------------|
| **StudentRegistration** | `components/auth/StudentRegistration.tsx` | **2087** | Registro estudiante (4 steps: credenciales + info + biométrico + confirmación) | ⭐⭐⭐⭐⭐ |
| **TutorProfile** | `components/tutor/TutorProfile.tsx` | **714** | Registro tutor (4 steps: experiencia + conocimientos + idiomas + resumen) | ⭐⭐⭐⭐⭐ |
| KnowledgeSelector | `components/tutor/KnowledgeSelector.tsx` | ~400 | Selector jerárquico de conocimientos (3 niveles: categoría → subcategoría → tema) | ⭐⭐⭐⭐ |
| CameraModal | `components/CameraModal.tsx` | ~300 | Captura de fotos con cámara web + preview + validación | ⭐⭐⭐⭐ |
| TutorProfileModal | `components/tutor/TutorProfileModal.tsx` | ~250 | Modal completo de perfil de tutor (info, reviews, ratings) | ⭐⭐⭐ |
| LoginModal | `components/auth/LoginModal.tsx` | ~250 | Modal de login con validación y estados | ⭐⭐⭐ |
| PDFViewerModal | `components/PDFViewerModal.tsx` | ~150 | Visor de PDF (términos y condiciones, políticas) | ⭐⭐ |
| PhoneInput | `components/PhoneInput.tsx` | ~100 | Input de teléfono con validación de formato | ⭐⭐⭐ |
| TutorCard | `components/tutor/TutorCard.tsx` | ~100 | Tarjeta de tutor (foto, rating, precio, modalidad) | ⭐⭐ |
| DatePicker | `components/DatePicker.tsx` | ~80 | Selector de fecha (formato dd/mm/yyyy) | ⭐⭐ |

**Total LOC en componentes clave:** ~4,430 líneas

**Observaciones:**
- **StudentRegistration** (2087 líneas) es el componente más complejo del proyecto:
  - 4 steps con validación específica por step
  - Manejo de OTP (modal + verificación)
  - Detección de menores de edad (< 18 años) con campos adicionales para responsable
  - Captura biométrica (foto perfil, documento ID frontal/trasero, selfie)
  - Documentos del responsable para menores
  - Capitalización automática de nombres
  - Validación de fecha de nacimiento (formato dd/mm/yyyy, no futuras, edad válida)
  - Aceptación de términos y Habeas Data
  - Progress bar con % completado

- **TutorProfile** (714 líneas) es el segundo componente más complejo:
  - 4 steps con validación por step
  - Formulario dinámico de experiencia laboral (agregar/eliminar múltiples)
  - Selector jerárquico de conocimientos (integra KnowledgeSelector)
  - Selector de idiomas con niveles de dominio
  - Progress bar con checkmarks
  - Vista de resumen final

**Componentización y Reutilización:**
- ✅ **Componentes de soporte bien diseñados:** CameraModal, PDFViewerModal, PhoneInput, DatePicker son reutilizables
- ✅ **Separación de responsabilidades:** KnowledgeSelector es componente independiente usado por TutorProfile
- ⚠️ **Oportunidad de refactoring:** StudentRegistration (2087 LOC) podría dividirse en sub-componentes por step
- ⚠️ **Sin tests:** Ninguno de estos componentes tiene tests (0% cobertura)

---

**Documento:** ZNS v2.0 - Inventario Técnico del Frontend  
**Conclusión:** Stack moderno (Next.js 16, React 19, TypeScript 5, Tailwind 4) con componentes UI excepcionalmente complejos y pulidos en registro (estudiante 2087 LOC, tutor 714 LOC). Sin embargo, persisten gaps críticos en testing, backend, seguridad y optimización. **Priorizar:** TypeScript strict mode, testing (Jest + RTL), y backend real antes de lanzar MVP.
