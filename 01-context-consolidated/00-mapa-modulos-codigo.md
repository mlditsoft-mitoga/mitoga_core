# Mapa de Módulos del Código - MI-TOGA Frontend

**Proyecto:** MI-TOGA Frontend (mi-toga/) | **Stack:** Next.js 16.0 + React 19.2 + TypeScript 5.9  
**Fecha:** 08/11/2025 | **Versión:** 1.0

---

## 1. Estructura de Directorios

```
mi-toga/
├── app/                    # Next.js App Router (páginas y rutas)
│   ├── (public)/          # Rutas públicas (sin autenticación)
│   ├── admin/             # Panel de administración
│   ├── dashboard/         # Dashboards por rol
│   ├── globals.css        # Estilos globales Tailwind
│   ├── layout.tsx         # Layout raíz
│   └── page.tsx           # Home (marketplace)
├── components/            # Componentes React reutilizables
│   ├── auth/             # Autenticación (login, registro)
│   ├── dashboard/        # Componentes de dashboards
│   ├── examples/         # Ejemplos/demos
│   ├── tutor/            # Componentes de tutores
│   └── ui/               # UI primitivos (button, modal, etc.)
├── contexts/              # React Contexts (estado global)
│   └── AuthContext.tsx   # Contexto de autenticación
├── types/                 # Definiciones TypeScript
│   ├── auth.ts
│   ├── subscription.ts
│   ├── tutor.ts
│   └── tutoring.ts
├── lib/                   # Utilidades y servicios
│   ├── services/         # Servicios de negocio
│   ├── utils/            # Funciones helper
│   ├── firebaseConfig.ts # Config de Firebase
│   └── mock-data.ts      # Datos mock
├── hooks/                 # Custom React hooks
│   └── useAuth.ts        # Hook de autenticación
├── public/                # Assets estáticos
└── [config files]         # next.config.ts, tailwind.config.ts, etc.
```

---

## 2. Módulos por Funcionalidad

### Módulo: Autenticación (`contexts/`, `components/auth/`, `hooks/`)

**Responsabilidad:** Registro (multi-step), login, recuperación de contraseña

| Componente | Path | Descripción | Estado |
|------------|------|-------------|--------|
| AuthContext | `contexts/AuthContext.tsx` | Proveedor de estado de auth (user, login, register, logout) | ✅ Mock |
| useAuth hook | `hooks/useAuth.ts` | Hook para consumir AuthContext | ✅ |
| **StudentRegistration** | `components/auth/StudentRegistration.tsx` | **Registro estudiante (4 steps: credenciales → info → verificación → confirmación)** | ✅ 2087 líneas |
| LoginForm | `components/auth/LoginForm.tsx` | Formulario de login | ✅ |
| RegisterForm | `components/auth/RegisterForm.tsx` | Formulario de registro (legacy?) | ✅ |
| LoginModal | `components/auth/LoginModal.tsx` | Modal de login reutilizable | ✅ |
| ForgotPassword | `components/auth/ForgotPassword.tsx` | Recuperación de contraseña | ⚠️ No funcional |

**Componentes de Soporte (Registro):**
| Componente | Path | Descripción | Usado en |
|------------|------|-------------|----------|
| CameraModal | `components/CameraModal.tsx` | Captura de fotos con cámara web | Registro estudiante (paso 3) |
| PDFViewerModal | `components/PDFViewerModal.tsx` | Visor de PDF (T&C, políticas) | Registro estudiante (paso 2) |
| PhoneInput | `components/PhoneInput.tsx` | Input de teléfono con validación | Registro estudiante (paso 2) |
| DatePicker | `components/DatePicker.tsx` | Selector de fecha (dd/mm/yyyy) | Registro estudiante (paso 2) |

**Tipos:**
- `types/auth.ts`: User, AuthState, LoginCredentials, RegisterData

**Rutas:**
- `/login` → `app/(public)/login/page.tsx`
- `/registro` → `app/(public)/registro/page.tsx` → **StudentRegistration (4 steps)**
- `/dashboard` → Redirect según rol tras login

**Proceso de Registro Estudiante (StudentRegistration.tsx):**
1. **Step 1 - Credenciales:** Email, contraseña (validación fuerte: 8+ chars, mayúsculas, minúsculas, números), confirmación, OTP modal (6 dígitos)
2. **Step 2 - Información Personal:** Nombres (auto-capitalización), género, fecha nacimiento (validación edad), teléfono, país, ciudad, nivel educativo, términos y condiciones. **Para menores de 18:** datos del responsable (nombre, email, teléfono)
3. **Step 3 - Verificación Biométrica:** Foto perfil, documento ID (frontal + trasero), selfie en tiempo real. **Para menores:** documento del responsable
4. **Step 4 - Confirmación:** Resumen completo + botón "Completar registro"

**Features Implementadas:**
- ✅ Progress bar con % completado
- ✅ Validación client-side por step
- ✅ Capitalización automática de nombres
- ✅ Cálculo de edad y detección de menor (< 18 años)
- ✅ Captura de fotos con cámara (con preview)
- ✅ Upload de documentos (JPG, PNG, PDF)
- ✅ OTP modal para verificación de email
- ✅ Navegación entre steps con validación
- ✅ Error handling por field

**APIs Consumidas:** ❌ Ninguna (mock con localStorage)

**Dependencias:**
- React Context API
- localStorage (temporal, inseguro)
- @vladmandic/face-api (preparado, no usado)
- (Futuro) Firebase Auth o JWT API

**Gap Crítico:**
- ❌ Backend: API REST para registro
- ❌ Backend: Persistencia en PostgreSQL/MongoDB
- ❌ Backend: Envío real de OTP por email (SendGrid/AWS SES)
- ❌ Backend: Verificación biométrica real (face-api en backend)
- ❌ Backend: Validación de documentos por admin
- ❌ Backend: JWT token generation

---

### Módulo: Marketplace (`app/page.tsx`, `components/tutor/`, `lib/mock-data.ts`)

**Responsabilidad:** Búsqueda, filtrado y visualización de tutores

| Componente | Path | Descripción | Estado |
|------------|------|-------------|--------|
| HomePage | `app/page.tsx` | Marketplace principal (lista de tutores + filtros) | ✅ |
| TutorCard | `components/tutor/TutorCard.tsx` | Tarjeta de tutor (foto, nombre, rating, precio) | ✅ |
| TutorProfileModal | `components/tutor/TutorProfileModal.tsx` | Modal con perfil completo del tutor | ✅ |
| SearchBar | `components/ui/SearchBar.tsx` | Barra de búsqueda | ✅ |
| Filters | `components/ui/Filters.tsx` | Filtros (materia, modalidad, precio, rating) | ✅ |

**Tipos:**
- `types/tutor.ts`: Tutor, Review, Specialization

**Rutas:**
- `/` → Home marketplace

**Datos:**
- `lib/mock-data.ts`: 9 tutores mock (María García, Carlos López, etc.)

**APIs Consumidas:** ❌ Ninguna (filtrado client-side)

**Dependencias:**
- @heroicons/react (iconos)
- Tailwind CSS (estilos)

---

### Módulo: Perfiles (`components/tutor/TutorProfile.tsx`, `app/dashboard/profile/`)

**Responsabilidad:** Edición y visualización de perfiles de tutor/estudiante

| Componente | Path | Descripción | Estado |
|------------|------|-------------|--------|
| **TutorProfile** | `components/tutor/TutorProfile.tsx` | **Formulario de registro/edición de tutor (4 steps)** | ✅ 714 líneas |
| KnowledgeSelector | `components/tutor/KnowledgeSelector.tsx` | Selector jerárquico de conocimientos (categorías → subcategorías → temas) | ✅ |
| ProfilePage | `app/dashboard/profile/page.tsx` | Página de perfil del usuario | ⚠️ Básico |

**Componentes de Soporte (TutorProfile):**
| Componente | Descripción | Usado en |
|------------|-------------|----------|
| WorkExperienceForm | Formulario dinámico de experiencia laboral (inline) | TutorProfile Step 1 |
| KnowledgeSelector | Selector jerárquico con búsqueda y chips | TutorProfile Step 2 |
| LanguageSelector | Selector de idiomas con niveles de dominio | TutorProfile Step 3 |
| SummaryView | Vista de resumen de todos los datos ingresados | TutorProfile Step 4 |

**Tipos:**
- `types/tutor.ts`: TutorProfile (name, bio, specializations, hourlyRate, etc.), WorkExperience, Review, Specialization

**Rutas:**
- `/dashboard/profile` → Perfil del usuario logueado
- `/ser-tutor` → Landing page para tutores (redirige a registro)

**Proceso de Registro Tutor (TutorProfile.tsx):**
1. **Step 1 - Experiencia Laboral:**
   - Formulario: Empresa/Institución, Cargo, Fecha inicio, Fecha fin (o "Trabajo actual"), Descripción
   - Agregar múltiples experiencias (lista dinámica)
   - Eliminar experiencias individualmente
   - Validación: Al menos 1 experiencia requerida
   - Validación de fechas (fin > inicio, no futuras)

2. **Step 2 - Conocimientos y Especialidades:**
   - Selector jerárquico de 3 niveles:
     - Nivel 1: Categorías (Matemáticas, Ciencias, Idiomas, Artes, etc.)
     - Nivel 2: Subcategorías (Álgebra, Cálculo, Geometría, etc.)
     - Nivel 3: Temas específicos (Ecuaciones lineales, Derivadas, etc.)
   - Búsqueda por texto (filtrado)
   - Selección múltiple con chips visuales
   - Fuente de datos: `lib/knowledge-data.ts`

3. **Step 3 - Idiomas:**
   - Selector de idiomas (Español, Inglés, Francés, etc.)
   - Nivel de dominio por idioma (Básico, Intermedio, Avanzado, Nativo)
   - Agregar múltiples idiomas
   - Validación: Al menos 1 idioma requerido

4. **Step 4 - Resumen y Confirmación:**
   - Preview de experiencia laboral (cards)
   - Preview de conocimientos (tags/chips)
   - Preview de idiomas (lista con badge de nivel)
   - Botón "Enviar para revisión" → Estado "Pendiente aprobación admin"

**Features Implementadas:**
- ✅ Progress bar con % completado (0%, 33%, 66%, 100%)
- ✅ Indicadores visuales de step (checkmarks)
- ✅ Validación client-side por step
- ✅ Navegación entre steps (Anterior/Siguiente)
- ✅ Formulario de experiencia con validación robusta
- ✅ Selector de conocimientos jerárquico funcional
- ✅ Manejo de estado complejo con React hooks
- ✅ Error handling con mensajes específicos

**Datos:**
- `lib/knowledge-data.ts`: Estructura jerárquica de conocimientos (Categoría → Subcategoría → Tema)

**APIs Consumidas:** ❌ Ninguna (estado local, no persiste)

**Gap Crítico:**
- ❌ Backend: API REST para tutores (CRUD)
- ❌ Backend: Persistencia en BD
- ❌ Backend: Flujo de aprobación admin (Pendiente → Aprobado/Rechazado)
- ❌ Backend: Notificación al tutor de decisión
- ❌ Subida de documentos de verificación (títulos, certificados, antecedentes)
- ❌ Validación de experiencia laboral (referencias)
- ❌ Sincronización con perfil público del tutor en marketplace

---

### Módulo: Reservas (❌ No Implementado)

**Responsabilidad:** Agendamiento de sesiones de tutoría

**Componentes Esperados:**
- BookingCalendar
- BookingForm
- BookingList
- BookingDetails

**Tipos:**
- `types/tutoring.ts`: Booking, TimeSlot, BookingStatus

**Rutas Esperadas:**
- `/dashboard/bookings` → Lista de reservas
- `/tutor/{id}/book` → Reservar sesión con tutor

**APIs Necesarias:**
- `POST /api/bookings` → Crear reserva
- `GET /api/bookings` → Obtener reservas del usuario
- `PATCH /api/bookings/{id}` → Actualizar/cancelar

---

### Módulo: Pagos (❌ No Implementado)

**Responsabilidad:** Procesamiento de pagos con Stripe/PayU

**Componentes Esperados:**
- PaymentForm (formulario de pago)
- PaymentHistory (historial de pagos)
- InvoiceDownload (descargar facturas)

**Tipos:**
- `types/payment.ts`: Payment, PaymentMethod, Invoice

**Rutas Esperadas:**
- `/checkout/{bookingId}` → Pagar reserva
- `/dashboard/payments` → Historial de pagos

**APIs Necesarias:**
- `POST /api/payments/intent` → Crear payment intent (Stripe)
- `POST /api/payments/confirm` → Confirmar pago
- `GET /api/invoices/{id}` → Descargar factura PDF

---

### Módulo: Videollamadas (❌ No Implementado)

**Responsabilidad:** Sesiones de video en vivo (Agora/Twilio/WebRTC)

**Componentes Esperados:**
- VideoRoom (sala de videollamada)
- VideoControls (mute, cámara, compartir pantalla)
- ChatPanel (chat de texto)

**Tipos:**
- `types/video.ts`: VideoSession, Participant

**Rutas Esperadas:**
- `/session/{sessionId}` → Unirse a videollamada

**APIs Necesarias:**
- `POST /api/video/token` → Generar token de acceso (Agora/Twilio)
- `GET /api/sessions/{id}` → Datos de sesión

---

### Módulo: Notificaciones (❌ No Implementado)

**Responsabilidad:** Email, push y SMS

**Componentes Esperados:**
- NotificationBell (campana de notificaciones)
- NotificationList (lista de notificaciones)
- NotificationSettings (preferencias)

**Tipos:**
- `types/notification.ts`: Notification, NotificationType

**APIs Necesarias:**
- `GET /api/notifications` → Obtener notificaciones
- `PATCH /api/notifications/{id}/read` → Marcar como leída
- `POST /api/notifications/send` → Enviar notificación (backend)

---

### Módulo: Administración (`app/dashboard/admin/`)

**Responsabilidad:** Panel admin (aprobar tutores, métricas, moderación)

| Componente | Path | Descripción | Estado |
|------------|------|-------------|--------|
| AdminDashboard | `app/dashboard/admin/page.tsx` | Dashboard principal de admin | ⚠️ UI básica |
| TutorApproval | `app/dashboard/admin/tutors/page.tsx` | Lista de tutores pendientes | ❌ No impl. |
| MetricsDashboard | `app/dashboard/admin/metrics/page.tsx` | KPIs y gráficos | ❌ No impl. |

**Rutas:**
- `/dashboard/admin` → Dashboard admin (requiere rol admin)
- `/dashboard/admin/tutors` → Gestión de tutores
- `/dashboard/admin/metrics` → Métricas

**APIs Necesarias:**
- `GET /api/admin/tutors?status=pending` → Tutores pendientes
- `PATCH /api/admin/tutors/{id}/approve` → Aprobar tutor
- `GET /api/admin/metrics` → Datos de métricas

---

## 3. Dependencias entre Módulos

```
AuthContext (root)
    ↓ consume
[Todos los módulos protegidos]
    ↓
Marketplace → TutorProfile (view only)
    ↓
Reservas → Marketplace (seleccionar tutor)
    ↓
Pagos → Reservas (pagar reserva)
    ↓
Videollamadas → Reservas (unirse a sesión)
    ↓
Notificaciones → [Todos los módulos] (eventos)
    ↓
Admin → [Todos los módulos] (moderación)
```

---

## 4. Componentes UI Reutilizables (`components/ui/`)

| Componente | Descripción | Usado en |
|------------|-------------|----------|
| Button | Botón reutilizable (variants: primary, secondary, outline) | Todos los módulos |
| Modal | Modal genérico | TutorProfileModal, confirmaciones |
| Input | Input de formulario | Auth, Perfiles, Filtros |
| Select | Dropdown | Filtros, formularios |
| Card | Tarjeta genérica | TutorCard, dashboards |
| Badge | Etiqueta (status, categoría) | TutorCard (rating), admin |
| Spinner | Loading indicator | Todas las páginas |

---

## 5. Configuración y Servicios

### Configuración

| Archivo | Propósito | Estado |
|---------|-----------|--------|
| `next.config.ts` | Configuración de Next.js | ✅ |
| `tailwind.config.ts` | Tema de Tailwind CSS | ✅ |
| `tsconfig.json` | Configuración de TypeScript | ✅ |
| `.eslintrc.json` | Reglas de linting | ✅ |
| `postcss.config.mjs` | PostCSS plugins | ✅ |
| `lib/firebaseConfig.ts` | Config de Firebase | ✅ (no usado actualmente) |

### Servicios (`lib/services/`)

| Servicio | Responsabilidad | Estado |
|----------|-----------------|--------|
| authService | Llamadas a API de auth | ❌ Pendiente |
| tutorService | CRUD de tutores | ❌ Pendiente |
| bookingService | Gestión de reservas | ❌ Pendiente |
| paymentService | Integración Stripe/PayU | ❌ Pendiente |
| notificationService | Envío de notificaciones | ❌ Pendiente |

---

## 6. Rutas Implementadas (App Router)

### Rutas Públicas (`app/(public)/`)
- `/` → Marketplace (home)
- `/login` → Login
- `/register` → Registro
- `/about` → Acerca de (si existe)

### Rutas Protegidas (`app/dashboard/`)
- `/dashboard` → Dashboard principal (redirect según rol)
- `/dashboard/profile` → Perfil del usuario
- `/dashboard/bookings` → Mis reservas (❌ pendiente)
- `/dashboard/payments` → Historial de pagos (❌ pendiente)

### Rutas Admin (`app/dashboard/admin/`)
- `/dashboard/admin` → Dashboard admin
- `/dashboard/admin/tutors` → Gestión de tutores (❌ pendiente)
- `/dashboard/admin/metrics` → Métricas (❌ pendiente)

---

## 7. Estado de Implementación por Módulo

| Módulo | Frontend | Backend | Base de Datos | APIs | Cobertura | Observaciones |
|--------|----------|---------|---------------|------|-----------|---------------|
| Autenticación | ✅ 95% | ❌ 0% | ❌ 0% | ❌ 0% | UI completa, mock | **Registro estudiante: 4 steps, 2087 líneas, OTP, biométrico, menores** |
| Marketplace | ✅ 90% | ❌ 0% | ❌ 0% | ❌ 0% | Datos mock | Filtros, búsqueda, perfiles |
| Perfiles | ✅ 90% | ❌ 0% | ❌ 0% | ❌ 0% | UI tutor completa | **Registro tutor: 4 steps, 714 líneas, experiencia, conocimientos, idiomas** |
| Reservas | ❌ 0% | ❌ 0% | ❌ 0% | ❌ 0% | No iniciado | - |
| Pagos | ❌ 0% | ❌ 0% | ❌ 0% | ❌ 0% | No iniciado | - |
| Videollamadas | ❌ 0% | ❌ 0% | ❌ 0% | ❌ 0% | No iniciado | - |
| Notificaciones | ❌ 0% | ❌ 0% | ❌ 0% | ❌ 0% | No iniciado | - |
| Admin | ⚠️ 20% | ❌ 0% | ❌ 0% | ❌ 0% | Solo estructura UI | - |

**Promedio:** Frontend 37% (↑ +9.5% vs estimación inicial) | Backend 0% | Full-stack 18.5%

**Nota:** El aumento en % frontend se debe a la complejidad y completitud excepcional de los formularios de registro multi-step (estudiante: 2087 líneas, tutor: 714 líneas), con componentes reutilizables, validaciones robustas, y UX pulida.

---

## 8. APIs REST Necesarias (Backend Pendiente)

### Autenticación
- `POST /api/auth/register` → Registro
- `POST /api/auth/login` → Login (devuelve JWT)
- `POST /api/auth/refresh` → Refresh token
- `POST /api/auth/logout` → Logout
- `POST /api/auth/forgot-password` → Reset password

### Tutores
- `GET /api/tutors` → Listar tutores (con filtros)
- `GET /api/tutors/{id}` → Detalle de tutor
- `POST /api/tutors` → Crear perfil de tutor
- `PATCH /api/tutors/{id}` → Actualizar perfil
- `DELETE /api/tutors/{id}` → Eliminar tutor

### Reservas
- `POST /api/bookings` → Crear reserva
- `GET /api/bookings` → Listar reservas del usuario
- `GET /api/bookings/{id}` → Detalle de reserva
- `PATCH /api/bookings/{id}` → Actualizar (reprogramar, cancelar)
- `GET /api/tutors/{id}/availability` → Disponibilidad del tutor

### Pagos
- `POST /api/payments/intent` → Crear payment intent
- `POST /api/payments/confirm` → Confirmar pago
- `GET /api/payments/history` → Historial
- `GET /api/invoices/{id}` → Descargar factura

### Admin
- `GET /api/admin/tutors?status=pending` → Tutores pendientes
- `PATCH /api/admin/tutors/{id}/approve` → Aprobar/rechazar tutor
- `GET /api/admin/metrics` → KPIs (usuarios, sesiones, ingresos)
- `GET /api/admin/users` → Gestión de usuarios

### Notificaciones
- `GET /api/notifications` → Notificaciones del usuario
- `PATCH /api/notifications/{id}/read` → Marcar como leída
- `POST /api/notifications/send` → Enviar notificación (admin/system)

---

## 9. Deuda Técnica Identificada

### Crítica
1. **Auth Mock Inseguro:** localStorage sin encriptación, no production-ready
2. **Sin Backend:** 0% de lógica de negocio implementada
3. **Sin Base de Datos:** Datos mock hardcoded
4. **Sin Tests:** 0% cobertura

### Alta
5. **Sin Validación Server-side:** Toda validación client-side (fácil de bypassear)
6. **Sin Manejo de Errores:** No hay error boundaries ni try-catch globales
7. **Sin TypeScript Strict:** `strict: false` en tsconfig.json
8. **Sin Documentación de Componentes:** Falta JSDoc en componentes

### Media
9. **Sin Optimización de Imágenes:** No usar Next.js Image component consistentemente
10. **Sin i18n:** Textos hardcoded en español
11. **Sin Accessibility Audit:** No validado WCAG 2.1
12. **Mock Data Hardcoded:** Debería estar en JSON separado o BD

---

## 10. Próximos Pasos Críticos

1. **Implementar Backend:** API REST con Node.js/Python + PostgreSQL
2. **Autenticación Real:** JWT + OAuth (Firebase/Auth0)
3. **Base de Datos:** Diseño de esquema y migrations
4. **Testing:** Jest + React Testing Library (objetivo 60%+)
5. **CI/CD:** GitHub Actions + Vercel deploy automático
6. **Monitoreo:** Sentry (errores) + Vercel Analytics (métricas)

---

**Documento:** ZNS v2.0 - Mapa de Módulos del Frontend  
**Basado en:** Estructura de código mi-toga/ (exploración directa)  
**Limitación:** Backend no disponible para mapeo (0% implementado)
