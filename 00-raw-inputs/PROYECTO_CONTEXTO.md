# MI-TOGA - Contexto del Proyecto

## 🎓 Descripción General

**MI-TOGA** es una plataforma web moderna de tutoría virtual que conecta estudiantes con tutores colombianos especializados. El proyecto busca democratizar el acceso a educación de calidad mediante tecnología web de última generación.

### Misión
Facilitar el encuentro entre estudiantes que buscan apoyo académico y tutores calificados en Colombia, ofreciendo una experiencia de aprendizaje flexible, accesible y de alta calidad.

### Visión
Convertirse en la plataforma líder de tutorías en Colombia, reconocida por su facilidad de uso, calidad de tutores y resultados académicos comprobables.

---

## 🏗️ Arquitectura Técnica

### Stack Tecnológico

**Frontend Framework:**
- **Next.js 16.0** con App Router (React Server Components)
- **React 19.2** con hooks y context API
- **TypeScript 5.9** para type safety

**Estilización:**
- **Tailwind CSS 4.1** como framework CSS principal
- Google Fonts: **Inter** (sans-serif) y **Poppins** (display)
- Sistema de diseño custom con variables CSS
- **@heroicons/react** para iconografía

**Herramientas de Desarrollo:**
- ESLint para linting
- Next.js Fast Refresh para desarrollo
- TypeScript compiler para verificación de tipos

### Estructura del Proyecto

```
mi-toga/
├── app/                      # Next.js App Router
│   ├── (public)/            # Rutas públicas (acceso sin autenticación)
│   ├── admin/               # Panel administrativo
│   ├── dashboard/           # Dashboards de usuario
│   │   ├── admin/          # Dashboard administrador
│   │   └── tutor/          # Dashboard tutor
│   ├── layout.tsx          # Layout raíz con tipografías y componentes globales
│   ├── page.tsx            # Página de inicio (marketplace de tutores)
│   └── globals.css         # Estilos globales y utilidades custom
├── components/              # Componentes React reutilizables
│   ├── auth/               # Componentes de autenticación
│   ├── ui/                 # Componentes UI base
│   ├── tutor/              # Componentes específicos de tutores
│   ├── examples/           # Componentes de ejemplo
│   ├── Header.tsx          # Navegación principal
│   ├── Footer.tsx          # Pie de página
│   ├── TutorCard.tsx       # Tarjeta de presentación de tutor
│   ├── InscripcionEventoModal.tsx  # Modal de inscripción a eventos
│   └── Providers.tsx       # Wrapper de providers de contexto
├── contexts/               # React Contexts para estado global
│   └── AuthContext.tsx     # Gestión de autenticación
├── lib/                    # Utilidades y datos
│   └── mock-data.ts        # Datos mock de tutores (9 tutores de prueba)
├── types/                  # Definiciones TypeScript
│   ├── tutor.ts           # Interfaz Tutor y tipos relacionados
│   └── auth.ts            # Tipos de autenticación
├── public/                # Recursos estáticos
└── docs/                  # Documentación del proyecto
```

---

## 🎨 Sistema de Diseño

### Paleta de Colores

**Color Primario:** `#1976D2` (Azul)
- Escala completa: `primary-50` a `primary-950`
- Usado en botones principales, links y elementos destacados

**Utilidades de Color:**
- Variables CSS en `:root` para consistencia
- Gradientes para botones (`btn-primary`)
- Estados hover/focus con transiciones suaves

### Componentes de Diseño

**Sistema de Tarjetas:**
```css
.card - Tarjeta blanca con sombra suave y hover effects
```

**Botones:**
```css
.btn-primary   - Botón azul con gradiente
.btn-secondary - Botón con borde, fondo transparente
.btn-ghost     - Botón transparente con hover
```

**Sombras:**
```css
.shadow-soft   - Sombra sutil (0 2px 8px)
.shadow-medium - Sombra media (0 4px 16px)
.shadow-strong - Sombra fuerte (0 8px 32px)
```

**Tipografía:**
- **Headings:** Poppins (font-display) - Bold, profesional
- **Body:** Inter (font-sans) - Legible, moderna
- Escala tipográfica coherente usando Tailwind

### Responsive Design
- Mobile-first approach
- Breakpoints estándar de Tailwind
- Grid layouts fluidos
- Componentes adaptables

---

## 👥 Roles de Usuario

### 1. **Estudiante**
**Funcionalidades:**
- Buscar tutores por materia, calificación, precio
- Filtrar por modalidad (virtual/presencial/en-sitio)
- Ver perfiles detallados de tutores
- Agendar sesiones de tutoría
- Realizar pagos (funcionalidad futura)
- Calificar y comentar tutores

**Dashboard:** (Planeado)
- Sesiones programadas
- Historial de tutorías
- Tutores favoritos
- Pagos y facturación

### 2. **Tutor**
**Funcionalidades:**
- Crear y gestionar perfil profesional
- Establecer disponibilidad y tarifas
- Recibir solicitudes de tutoría
- Gestionar calendario
- Recibir pagos (funcionalidad futura)

**Dashboard:** `/dashboard/tutor`
- Gestión de perfil (TutorProfile.tsx)
- Calendario de sesiones
- Estadísticas de rendimiento
- Configuración de tarifas

### 3. **Administrador**
**Funcionalidades:**
- Aprobar/rechazar tutores
- Gestionar usuarios
- Monitorear plataforma
- Resolver disputas
- Análisis y reportes

**Dashboard:** `/dashboard/admin`
- Panel de control general
- Gestión de usuarios
- Moderación de contenido
- Analíticas de plataforma

---

## 🔐 Sistema de Autenticación

### Implementación Actual (MVP)

**Tipo:** Autenticación client-side con localStorage

**Componente Principal:** `contexts/AuthContext.tsx`

**Funcionalidades:**
- Login/Logout
- Registro de usuarios
- Persistencia de sesión (localStorage)
- Protección de rutas (Client-side)

**Credenciales Demo:**
```
Email: demo@mitoga.com
Password: demo123
```

**Métodos del Contexto:**
```typescript
login(credentials: LoginCredentials): Promise<void>
register(data: RegisterData): Promise<void>
logout(): void
checkAuth(): void  // Verifica sesión al cargar
```

### Roadmap de Autenticación

**Futuras Implementaciones:**
- Backend de autenticación (Next.js API Routes)
- JWT tokens
- Refresh tokens
- OAuth (Google, Facebook)
- Verificación por email
- Recuperación de contraseña
- Autenticación de dos factores (2FA)

---

## 📊 Modelo de Datos

### Entidad: Tutor

```typescript
interface Tutor {
  // Identificación
  id: string;
  name: string;
  photo: string;

  // Profesional
  specialty: string;
  subjects: string[];
  education: string;
  experience: string;

  // Calificación
  rating: number;        // 0-5 estrellas
  reviews: number;       // Cantidad de reseñas

  // Servicio
  hourlyRate: number;    // Tarifa en COP por hora
  modalities: Modality[]; // ['virtual', 'presencial', 'en-sitio']
  availability: string[]; // Días disponibles

  // Ubicación
  city: string;

  // Estado
  isVerified: boolean;   // Verificado por plataforma
  isOnline: boolean;     // Disponible ahora

  // Detalles
  description: string;
  languages: string[];
}

type Modality = 'virtual' | 'presencial' | 'en-sitio';
```

### Datos Mock

**Ubicación:** `lib/mock-data.ts`
**Cantidad:** 9 tutores de ejemplo
**Especialidades:** Matemáticas, Física, Química, Inglés, Programación, Historia

---

## 🎯 Funcionalidades Principales

### 1. **Marketplace de Tutores** (Página Principal)

**Ruta:** `/`
**Componente:** `app/page.tsx`

**Características:**
- Grid de tarjetas de tutores (TutorCard)
- Filtros interactivos:
  - Por materia
  - Por modalidad
  - Por calificación
  - Por rango de precio
- Ordenamiento:
  - Más valorados
  - Precio: menor a mayor
  - Precio: mayor a menor
- Búsqueda por nombre
- Indicadores de estado (online/offline)
- Badges de verificación

### 2. **Página "Cómo Funciona"**

**Ruta:** `/como-funciona` (eliminada, pendiente reestructurar)
**Propósito:** Explicar el proceso de usar la plataforma

**Secciones Típicas:**
1. Crea tu cuenta
2. Busca tu tutor ideal
3. Agenda tu sesión
4. Aprende y crece

### 3. **Autenticación**

**Login:** `/login` (eliminada, pendiente reestructurar)
**Registro:** `/registro` (eliminada, pendiente reestructurar)
**Registro Exitoso:** `/registro-exitoso` (eliminada, pendiente reestructurar)

**Flujo:**
1. Usuario ingresa credenciales
2. Validación client-side
3. Simulación de API call (setTimeout)
4. Almacenamiento en localStorage
5. Redirección al dashboard

### 4. **Eventos Especiales**

**Ruta:** `/eventos-especiales` (eliminada, pendiente reestructurar)
**Modal:** `InscripcionEventoModal.tsx`

**Propósito:** Talleres, webinars y eventos educativos especiales

### 5. **Panel de Tutor**

**Ruta:** `/dashboard/tutor`
**Componente Principal:** `TutorProfile.tsx`

**Secciones:**
- Información personal
- Especialidades y materias
- Configuración de tarifas
- Disponibilidad horaria
- Estadísticas de sesiones
- Reseñas recibidas

### 6. **Panel de Administrador**

**Ruta:** `/dashboard/admin`

**Funcionalidades Planeadas:**
- Aprobación de tutores
- Gestión de usuarios
- Moderación de reseñas
- Reportes y analíticas
- Configuración de plataforma

---

## 🚀 Roadmap Técnico

### Fase 1: MVP (Actual)
- ✅ Diseño UI/UX completo
- ✅ Sistema de componentes
- ✅ Autenticación client-side
- ✅ Marketplace de tutores
- ✅ Filtrado y búsqueda
- ✅ Datos mock

### Fase 2: Backend (Próximo)
- [ ] Next.js API Routes
- [ ] Conexión a base de datos (PostgreSQL/MongoDB)
- [ ] Autenticación real (JWT)
- [ ] CRUD de tutores
- [ ] CRUD de usuarios
- [ ] Sistema de roles y permisos

### Fase 3: Funcionalidades Core
- [ ] Sistema de agendamiento
- [ ] Notificaciones (email/push)
- [ ] Chat en tiempo real (Socket.io)
- [ ] Videollamadas (WebRTC/Agora)
- [ ] Sistema de calificaciones y reseñas
- [ ] Búsqueda avanzada

### Fase 4: Pagos y Monetización
- [ ] Integración de pasarela de pagos (Stripe/PayU)
- [ ] Sistema de comisiones
- [ ] Facturación automática
- [ ] Reporte de ingresos
- [ ] Retiros para tutores

### Fase 5: Optimizaciones
- [ ] SEO optimization
- [ ] Performance optimization
- [ ] Analytics (Google Analytics)
- [ ] A/B testing
- [ ] PWA capabilities
- [ ] Mobile app (React Native)

---

## 🔧 Comandos de Desarrollo

```bash
# Instalación
npm install

# Desarrollo local
npm run dev
# Servidor: http://localhost:3000

# Build de producción
npm run build

# Iniciar producción
npm start

# Linting
npm run lint

# Type checking
npx tsc --noEmit
```

---

## 📦 Dependencias Principales

```json
{
  "next": "^16.0.0",
  "react": "^19.2.0",
  "react-dom": "^19.2.0",
  "typescript": "^5.9.0",
  "tailwindcss": "^4.1.0",
  "@heroicons/react": "^2.x"
}
```

---

## 🌐 Configuración de Entorno

### Variables de Entorno (Futuras)

```env
# Database
DATABASE_URL=

# Authentication
NEXTAUTH_SECRET=
NEXTAUTH_URL=

# APIs
STRIPE_PUBLIC_KEY=
STRIPE_SECRET_KEY=

# Email
SMTP_HOST=
SMTP_PORT=
SMTP_USER=
SMTP_PASSWORD=

# Storage
AWS_S3_BUCKET=
AWS_ACCESS_KEY=
AWS_SECRET_KEY=
```

---

## 🔒 Seguridad

### Consideraciones Actuales
- Validación de inputs en formularios
- Sanitización de datos de usuario
- HTTPS en producción (pendiente)
- CORS configurado (pendiente backend)

### Mejoras Futuras
- Rate limiting
- CSRF protection
- SQL injection prevention
- XSS prevention
- Password hashing (bcrypt)
- Autenticación de dos factores
- Logs de seguridad
- Monitoreo de vulnerabilidades

---

## 📱 Responsive Breakpoints

```javascript
// Tailwind breakpoints
sm: '640px'   // Tablet
md: '768px'   // Tablet landscape
lg: '1024px'  // Desktop
xl: '1280px'  // Desktop large
2xl: '1536px' // Desktop XL
```

---

## 🎓 Casos de Uso Principales

### Caso de Uso 1: Estudiante Busca Tutor
1. Estudiante ingresa a la plataforma
2. Navega el marketplace
3. Aplica filtros (materia: Matemáticas, modalidad: virtual)
4. Ordena por calificación
5. Selecciona un tutor
6. Ve perfil detallado
7. Agenda una sesión
8. Realiza pago
9. Recibe confirmación

### Caso de Uso 2: Tutor se Registra
1. Tutor hace clic en "Ser Tutor"
2. Completa formulario de registro
3. Sube documentos de verificación
4. Administrador revisa perfil
5. Perfil es aprobado
6. Tutor configura disponibilidad y tarifas
7. Perfil aparece en marketplace
8. Tutor recibe solicitudes de sesión

### Caso de Uso 3: Sesión de Tutoría
1. Estudiante agenda sesión
2. Ambos reciben notificación
3. Recordatorio 1 hora antes
4. Acceso a sala virtual (videollamada)
5. Sesión se lleva a cabo
6. Al finalizar, estudiante califica
7. Pago se procesa automáticamente
8. Tutor recibe fondos (menos comisión)

---

## 📈 Métricas de Éxito

### KPIs de Negocio
- Número de tutores activos
- Número de estudiantes registrados
- Sesiones realizadas por mes
- Tasa de retención de usuarios
- Valor promedio por sesión
- Net Promoter Score (NPS)

### KPIs Técnicos
- Tiempo de carga de página < 3s
- Core Web Vitals (LCP, FID, CLS)
- Uptime > 99.9%
- Tasa de error < 0.1%
- Tiempo de respuesta API < 200ms

---

## 🤝 Contribución

### Estándares de Código
- TypeScript estricto
- ESLint configurado
- Nombres descriptivos
- Componentes pequeños y reutilizables
- Comentarios en lógica compleja
- Props con interfaces tipadas

### Git Workflow
```bash
# Branches
main/master  - Producción
develop      - Desarrollo
feature/*    - Nuevas funcionalidades
bugfix/*     - Correcciones
hotfix/*     - Correcciones urgentes
```

---

## 📞 Soporte y Contacto

**Desarrollado por:** ZENAPSES S.A.S
**Proyecto:** MI-TOGA - Plataforma de Tutorías
**Versión:** 1.0.0 (MVP)
**Última actualización:** 2025

---

## 📄 Licencia

Este proyecto es propiedad de ZENAPSES S.A.S. Todos los derechos reservados.
