# Requisitos Funcionales - MI-TOGA

**Proyecto:** MI-TOGA - Plataforma de Tutorías Virtuales  
**Fecha:** 08/11/2025 | **Versión:** 1.0  
**Fuentes:** PROYECTO_CONTEXTO.md + Código frontend mi-toga/

---

## 1. Módulos del Sistema

| # | Módulo | Responsabilidad | Estado |
|---|--------|-----------------|--------|
| 1 | Autenticación | Registro, login, recuperación de contraseña | ✅ Mock (⏳ Real pendiente) |
| 2 | Marketplace | Búsqueda, filtrado y visualización de tutores | ✅ Implementado |
| 3 | Perfiles | Gestión de perfiles (estudiante/tutor) | ⚠️ Parcial |
| 4 | Reservas | Agendamiento de sesiones | ❌ Pendiente |
| 5 | Pagos | Procesamiento de pagos y comisiones | ❌ Pendiente |
| 6 | Videollamadas | Sesiones virtuales en vivo | ❌ Pendiente |
| 7 | Notificaciones | Email, push, SMS | ❌ Pendiente |
| 8 | Administración | Panel admin, moderación | ⚠️ Parcial |

---

## 2. Requisitos Funcionales por Módulo

### 📌 **NOTA IMPORTANTE: Procesos de Registro Multi-Step**

El sistema implementa **dos procesos de registro diferenciados** (estudiante vs tutor), ambos con **formularios multi-step guiados**:

#### 🎓 **Registro de Estudiante** (4 Steps)
```
STEP 1: Credenciales
├─ Email + contraseña (validación fuerte)
├─ Confirmación de contraseña
└─ Verificación OTP por email (6 dígitos)

STEP 2: Información Personal
├─ Datos básicos (nombres, apellidos, género, fecha nacimiento)
├─ Contacto (teléfono, país, ciudad, dirección)
├─ Nivel educativo + Sobre mí
├─ ⚠️ SI MENOR DE 18: Datos del responsable (nombre, email, teléfono)
└─ Aceptación de términos + Habeas Data

STEP 3: Verificación Biométrica
├─ Foto de perfil (cámara/upload)
├─ Documento ID frontal
├─ Documento ID trasero
├─ Selfie en tiempo real (anti-spoofing)
└─ ⚠️ SI MENOR DE 18: Documento del responsable (frontal + trasero)

STEP 4: Confirmación
└─ Resumen + "Completar registro"
```

#### 👨‍🏫 **Registro de Tutor** (4 Steps)
```
STEP 1: Experiencia Laboral
├─ Formulario dinámico (empresa, cargo, fechas, descripción)
├─ Agregar múltiples experiencias
└─ Mínimo 1 experiencia requerida

STEP 2: Conocimientos y Especialidades
├─ Selector jerárquico (Categoría → Subcategoría → Tema)
├─ Búsqueda por texto
└─ Selección múltiple con chips

STEP 3: Idiomas
├─ Selector de idiomas
├─ Nivel de dominio (Básico, Intermedio, Avanzado, Nativo)
└─ Mínimo 1 idioma requerido

STEP 4: Resumen y Envío
└─ Preview completo + "Enviar para revisión"
```

**Componentes Reutilizables Implementados:**
- `CameraModal.tsx` → Captura de fotos con cámara
- `PDFViewerModal.tsx` → Visualización de T&C y políticas
- `PhoneInput.tsx` → Input de teléfono con validación
- `DatePicker.tsx` → Selector de fecha (formato dd/mm/yyyy)
- `KnowledgeSelector.tsx` → Selector jerárquico de conocimientos

**Estado Actual:** ✅ UI completamente funcional | ❌ Backend pendiente (persistencia, validación server-side, envío de emails, verificación biométrica real)

---

### Módulo 1: Autenticación

#### RF-001: Registro de Estudiante (Multi-Step)
- **Prioridad:** MUST HAVE
- **Estado:** ✅ Implementado (UI completa, mock backend)
- **Fuente Código:** `components/auth/StudentRegistration.tsx`, `contexts/AuthContext.tsx`
- **Historia:** Como estudiante nuevo, quiero completar un proceso de registro guiado por pasos para crear una cuenta verificada.

**Proceso de 4 Steps:**

**STEP 1: Credenciales**
- Email (validación formato + unicidad)
- Contraseña (mínimo 8 caracteres, mayúsculas, minúsculas, números)
- Confirmación de contraseña
- Verificación OTP por email (6 dígitos)

**STEP 2: Información Personal**
- Nombres (primer nombre*, segundo nombre, primer apellido*, segundo apellido)
- Género (Masculino, Femenino, Otro, Prefiero no decir)
- Fecha de nacimiento (formato dd/mm/yyyy)
- Teléfono
- País y ciudad
- Dirección
- Nivel educativo (Primaria, Secundaria, Bachillerato, Técnico, Universitario, Posgrado)
- Sobre mí (textarea)
- ⚠️ **Para menores de 18 años:** Datos del responsable (nombre, apellido, email, teléfono)
- Aceptación de términos y condiciones ✓
- Aceptación de política de Habeas Data ✓

**STEP 3: Verificación Biométrica**
- Foto de perfil (captura con cámara o upload)
- Documento de identidad frontal (captura/upload)
- Documento de identidad trasero (captura/upload)
- Foto en tiempo real (selfie con cámara)
- ⚠️ **Para menores de 18 años:** Documento del responsable (frontal + trasero)

**STEP 4: Confirmación**
- Resumen de datos ingresados
- Botón "Completar registro"

**Criterios de Aceptación:**
1. ✅ UI implementada con progress bar y 4 steps
2. ✅ Validación client-side por step
3. ✅ Capitalización automática de nombres
4. ✅ Cálculo automático de edad y detección de menor
5. ✅ Captura de fotos con cámara (componente CameraModal)
6. ✅ Upload de documentos (JPG, PNG, PDF)
7. ✅ OTP modal para verificación de email (6 dígitos)
8. ⚠️ Navegación entre steps con validación
9. ❌ Backend: Persistencia en BD
10. ❌ Backend: Envío real de OTP por email
11. ❌ Backend: Verificación biométrica con face-api
12. ❌ Backend: Validación de documentos por admin

**Implementación:**
- UI: `StudentRegistration.tsx` (2087 líneas, completo)
- Auth: `AuthContext.register()` - Mock con localStorage
- Modales: `CameraModal.tsx`, `PDFViewerModal.tsx`
- Inputs: `PhoneInput.tsx`, `DatePicker.tsx`

**Gap Crítico:** ❌ Backend completo (API, BD, envío de emails, verificación biométrica)

#### RF-002: Login con Email/Password
- **Prioridad:** MUST HAVE
- **Estado:** ✅ Implementado (mock)
- **Fuente Código:** `AuthContext.login()`, componentes auth
- **Criterios:**
  1. Validar credenciales contra BD
  2. Generar JWT token
  3. Redireccionar según rol
- **Gap:** ❌ Autenticación real con JWT

#### RF-003: Recuperación de Contraseña
- **Prioridad:** MUST HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Solicitar reset por email
  2. Token temporal de reset
  3. Cambio de contraseña seguro

#### RF-004: Verificación de Email
- **Prioridad:** MUST HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Envío de token por email
  2. Validación de token único
  3. Activación de cuenta

#### RF-005: Registro de Tutor (Multi-Step)
- **Prioridad:** MUST HAVE
- **Estado:** ✅ Implementado (UI completa)
- **Fuente Código:** `components/tutor/TutorProfile.tsx`
- **Historia:** Como tutor nuevo, quiero completar un proceso de registro guiado que incluya mi experiencia laboral, conocimientos e idiomas para ofrecer tutorías.

**Proceso de 4 Steps:**

**STEP 1: Experiencia Laboral**
- Empresa/Institución *
- Cargo *
- Fecha de inicio * (formato mes/año)
- Fecha de finalización o "Trabajo actual"
- Descripción del cargo
- Agregar múltiples experiencias (lista dinámica)
- Eliminar experiencias
- Validación: Al menos 1 experiencia requerida

**STEP 2: Conocimientos y Especialidades**
- Selector jerárquico de conocimientos:
  - Categorías principales (Matemáticas, Ciencias, Idiomas, etc.)
  - Subcategorías (Álgebra, Cálculo, Geometría, etc.)
  - Temas específicos (Ecuaciones lineales, Derivadas, etc.)
- Selección múltiple
- Búsqueda por texto
- Chips visuales de conocimientos seleccionados
- Fuente de datos: `lib/knowledge-data.ts`

**STEP 3: Idiomas**
- Selector de idiomas
- Nivel de dominio por idioma (Básico, Intermedio, Avanzado, Nativo)
- Agregar múltiples idiomas
- Validación: Al menos 1 idioma requerido

**STEP 4: Resumen y Confirmación**
- Resumen de experiencia laboral (lista)
- Resumen de conocimientos (tags)
- Resumen de idiomas (lista con nivel)
- Botón "Enviar para revisión"

**Criterios de Aceptación:**
1. ✅ UI implementada con progress bar (% completado)
2. ✅ 4 steps con indicadores visuales (checkmarks)
3. ✅ Validación client-side por step
4. ✅ Navegación entre steps (Anterior/Siguiente)
5. ✅ Selector de conocimientos jerárquico funcional
6. ✅ Formulario de experiencia con validación de fechas
7. ✅ Selector de idiomas con niveles
8. ✅ Manejo de estado con React hooks
9. ❌ Backend: Persistencia en BD
10. ❌ Backend: Estado "En revisión" → Revisión admin → "Aprobado"/"Rechazado"
11. ❌ Backend: Notificación al tutor de decisión
12. ❌ Subida de documentos de verificación (títulos, certificados)

**Implementación:**
- UI: `TutorProfile.tsx` (714 líneas, completo)
- Componentes: `KnowledgeSelector.tsx` (selector jerárquico)
- Datos: `lib/knowledge-data.ts` (estructura de conocimientos)
- Estado: `useState` para steps y formulario
- Validación: Funciones `validateWorkExperience()`

**Gap Crítico:** ❌ Backend (API de tutores, flujo de aprobación admin, BD)

#### RF-006: OAuth Social Login
- **Prioridad:** SHOULD HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Login con Google
  2. Login con Facebook
  3. Sincronización de datos de perfil

---

### Módulo 2: Marketplace

#### RF-010: Buscar Tutores
- **Prioridad:** MUST HAVE
- **Estado:** ✅ Implementado
- **Fuente Código:** `app/page.tsx` (home marketplace)
- **Implementación:** Filtrado client-side sobre mock data
- **Criterios:**
  1. ✅ Búsqueda por nombre
  2. ✅ Filtro por materia (dropdown)
  3. ✅ Filtro por modalidad (virtual/presencial/en-sitio)
  4. ✅ Filtro por calificación mínima
  5. ✅ Filtro por rango de precio
- **Gap:** Backend con paginación, búsqueda full-text

#### RF-011: Ordenar Resultados
- **Prioridad:** MUST HAVE
- **Estado:** ✅ Implementado
- **Criterios:**
  1. ✅ Por calificación (mayor a menor)
  2. ✅ Por precio (menor a mayor, mayor a menor)
  3. ⚠️ Por relevancia (pendiente)

#### RF-012: Ver Perfil de Tutor
- **Prioridad:** MUST HAVE
- **Estado:** ✅ Implementado
- **Fuente Código:** `components/TutorProfileModal.tsx`
- **Criterios:**
  1. ✅ Foto, nombre, especialidad
  2. ✅ Bio, educación, experiencia
  3. ✅ Calificación promedio y # de reseñas
  4. ✅ Tarifas y modalidades
  5. ✅ Disponibilidad
  6. ⚠️ Reseñas reales (mock actual)
  7. ❌ Botón "Reservar sesión"

#### RF-013: Filtros Avanzados
- **Prioridad:** SHOULD HAVE
- **Estado:** ⚠️ Parcial
- **Criterios:**
  1. ✅ Filtros básicos implementados
  2. ❌ Disponibilidad por día/horario
  3. ❌ Idiomas del tutor
  4. ❌ Años de experiencia

#### RF-014: Favoritos
- **Prioridad:** SHOULD HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Marcar tutores como favoritos
  2. Ver lista de favoritos
  3. Recibir notificaciones de cambios

---

### Módulo 3: Perfiles

#### RF-020: Editar Perfil de Estudiante
- **Prioridad:** MUST HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Foto de perfil
  2. Datos personales (nombre, email, teléfono)
  3. Nivel educativo, intereses
  4. Preferencias de aprendizaje

#### RF-021: Gestionar Perfil de Tutor
- **Prioridad:** MUST HAVE
- **Estado:** ⚠️ Componente creado
- **Fuente Código:** `components/tutor/TutorProfile.tsx`
- **Criterios:**
  1. ✅ UI para edición de perfil
  2. Especialidades y materias
  3. Tarifas por materia
  4. Configuración de disponibilidad
  5. ❌ Persistencia en BD

#### RF-022: Subir Documentos de Verificación
- **Prioridad:** MUST HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Upload de títulos/certificados
  2. Documento de identidad
  3. Validación de formatos (PDF, JPG, PNG)
  4. Límite de tamaño (5MB por archivo)

#### RF-023: Ver Historial de Sesiones
- **Prioridad:** MUST HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Lista de sesiones pasadas
  2. Detalles: fecha, tutor/estudiante, duración, costo
  3. Filtrar por estado (completada, cancelada)

---

### Módulo 4: Reservas (❌ Pendiente de Implementación)

#### RF-030: Agendar Sesión
- **Prioridad:** MUST HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Seleccionar tutor
  2. Elegir fecha y hora disponible
  3. Especificar duración (30min, 1h, 2h)
  4. Confirmar modalidad
  5. Procesar pago o reservar sin pago

#### RF-031: Ver Calendario de Reservas
- **Prioridad:** MUST HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Vista de calendario mensual/semanal
  2. Próximas sesiones destacadas
  3. Integración con Google Calendar (opcional)

#### RF-032: Cancelar Reserva
- **Prioridad:** MUST HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Cancelación hasta 24h antes sin penalidad
  2. Reembolso según política
  3. Notificación a ambas partes

#### RF-033: Reprogramar Sesión
- **Prioridad:** SHOULD HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Proponer nueva fecha/hora
  2. Aprobación del tutor
  3. Actualización automática de calendario

#### RF-034: Recordatorios de Sesión
- **Prioridad:** MUST HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Notificación 24h antes
  2. Notificación 1h antes
  3. Email + push notification

---

### Módulo 5: Pagos (❌ Pendiente de Implementación)

#### RF-040: Procesar Pago de Sesión
- **Prioridad:** MUST HAVE
- **Estado:** ❌ No implementado (mencionado en roadmap Fase 4)
- **Fuente:** PROYECTO_CONTEXTO.md - Stripe/PayU
- **Criterios:**
  1. Integración con Stripe o PayU
  2. Pago con tarjeta de crédito/débito
  3. PSE (Colombia)
  4. Confirmación inmediata

#### RF-041: Calcular Comisión
- **Prioridad:** MUST HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Comisión de plataforma (estimado 20%)
  2. Cálculo automático en checkout
  3. Separación de fondos (tutor vs plataforma)

#### RF-042: Transferir Fondos a Tutor
- **Prioridad:** MUST HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Retiro de fondos disponibles
  2. Transferencia a cuenta bancaria
  3. Umbral mínimo de retiro
  4. Timeframe de transferencia (3-5 días hábiles)

#### RF-043: Generar Facturas
- **Prioridad:** MUST HAVE (Colombia - DIAN)
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Factura electrónica para estudiante
  2. Comprobante de pago para tutor
  3. Cumplimiento con DIAN

#### RF-044: Reembolsos
- **Prioridad:** MUST HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Solicitud de reembolso
  2. Aprobación por admin
  3. Reembolso automático a método original
  4. Timeframe de 7-14 días

---

### Módulo 6: Videollamadas (❌ Pendiente de Implementación)

#### RF-050: Iniciar Videollamada
- **Prioridad:** MUST HAVE
- **Estado:** ❌ No implementado (roadmap Fase 3)
- **Fuente:** PROYECTO_CONTEXTO.md - Agora/Twilio/WebRTC
- **Criterios:**
  1. Botón "Unirse a sesión" 15min antes
  2. Sala de espera virtual
  3. Test de audio/video antes de entrar
  4. Compartir pantalla
  5. Chat de texto integrado

#### RF-051: Grabación de Sesión (Opcional)
- **Prioridad:** COULD HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Consentimiento de ambas partes
  2. Grabación almacenada en cloud
  3. Descarga disponible 7 días

#### RF-052: Control de Calidad de Conexión
- **Prioridad:** SHOULD HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Indicador de calidad de red
  2. Ajuste automático de resolución
  3. Notificación de problemas de conexión

---

### Módulo 7: Notificaciones (❌ Pendiente de Implementación)

#### RF-060: Notificaciones por Email
- **Prioridad:** MUST HAVE
- **Estado:** ❌ No implementado (roadmap Fase 3)
- **Fuente:** PROYECTO_CONTEXTO.md - SendGrid/AWS SES
- **Criterios:**
  1. Email de bienvenida
  2. Confirmación de reserva
  3. Recordatorios de sesión
  4. Cambios en reservas
  5. Notificaciones de pago

#### RF-061: Push Notifications
- **Prioridad:** SHOULD HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Notificaciones en navegador
  2. Solicitar permiso al usuario
  3. Mensajes en tiempo real

#### RF-062: SMS (Opcional)
- **Prioridad:** COULD HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Recordatorios críticos por SMS
  2. Integración con Twilio
  3. Opt-in del usuario

#### RF-063: Configurar Preferencias de Notificaciones
- **Prioridad:** SHOULD HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Activar/desactivar por tipo
  2. Frecuencia de resúmenes
  3. Canales preferidos (email, push, SMS)

---

### Módulo 8: Administración

#### RF-070: Aprobar/Rechazar Tutores
- **Prioridad:** MUST HAVE
- **Estado:** ⚠️ UI dashboard creada
- **Fuente Código:** `app/dashboard/admin/` (parcial)
- **Criterios:**
  1. Ver lista de tutores pendientes
  2. Revisar documentos
  3. Aprobar o rechazar con motivo
  4. Notificar decisión al tutor

#### RF-071: Moderar Reseñas
- **Prioridad:** SHOULD HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Ver reseñas reportadas
  2. Ocultar reseñas inapropiadas
  3. Banear usuarios abusivos

#### RF-072: Dashboard de Métricas
- **Prioridad:** MUST HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Total usuarios (estudiantes, tutores)
  2. Sesiones completadas
  3. Ingresos totales
  4. Gráficos de tendencias

#### RF-073: Gestionar Usuarios
- **Prioridad:** MUST HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Buscar usuarios
  2. Ver detalles de cuenta
  3. Suspender/Reactivar cuenta
  4. Ver historial de sesiones

#### RF-074: Resolver Disputas
- **Prioridad:** SHOULD HAVE
- **Estado:** ❌ No implementado
- **Criterios:**
  1. Ver tickets de soporte
  2. Comunicación con usuarios
  3. Emitir reembolsos manuales
  4. Cerrar casos con notas

---

## 3. Resumen de Priorización

### MUST HAVE (MVP) - 32 RFs

| Módulo | RFs MUST | Implementados | Pendientes | Detalle |
|--------|----------|---------------|------------|---------|
| Autenticación | 5 | 3 (UI completa, mock) | 2 | RF-001 (registro estudiante 4 steps ✅), RF-002 (login ✅), RF-005 (registro tutor 4 steps ✅) |
| Marketplace | 3 | 3 | 0 | Búsqueda, filtros, perfiles ✅ |
| Perfiles | 3 | 0 | 3 | Edición pendiente |
| Reservas | 5 | 0 | 5 | No iniciado |
| Pagos | 5 | 0 | 5 | No iniciado |
| Videollamadas | 1 | 0 | 1 | No iniciado |
| Notificaciones | 1 | 0 | 1 | No iniciado |
| Admin | 4 | 0 | 4 | Solo UI básica |
| **TOTAL** | **27** | **6** | **21** | **22% implementado (UI)** |

### SHOULD HAVE (Fase 2-3) - 12 RFs
- RF-006 (OAuth), RF-013 (Filtros avanzados), RF-033 (Reprogramar), RF-052 (Calidad conexión), RF-061 (Push), RF-063 (Preferencias), RF-071 (Moderar reseñas), RF-074 (Disputas)

### COULD HAVE (Futuro) - 3 RFs
- RF-014 (Favoritos), RF-051 (Grabación), RF-062 (SMS)

### WON'T HAVE (Fuera de alcance actual)
- Tutorías grupales, Marketplace de materiales, LMS integrations

---

## 4. Estado de Implementación General

**Total RFs Identificados:** 42  
**Implementados (UI completa):** 6 (14%)  
- ✅ RF-001: Registro estudiante (4 steps: credenciales → info personal → verificación biométrica → confirmación)
- ✅ RF-002: Login con email/password
- ✅ RF-005: Registro tutor (4 steps: experiencia → conocimientos → idiomas → resumen)
- ✅ RF-010: Buscar tutores (filtros por materia, modalidad, precio, rating)
- ✅ RF-011: Ordenar resultados
- ✅ RF-012: Ver perfil de tutor (modal completo)

**Parcialmente Implementados:** 3 (7%)  
**Pendientes (sin UI o backend):** 33 (79%)

**Gap Crítico Principal:** Backend completo (API REST, BD, autenticación JWT, lógica de negocio, envío de emails, verificación biométrica)

**Observaciones importantes:**
- El proceso de registro está **excepcionalmente bien implementado** en frontend:
  - Estudiantes: 4 steps con OTP, validación de menores, captura biométrica, documentos
  - Tutores: 4 steps con experiencia laboral dinámica, selector jerárquico de conocimientos, idiomas
  - Componentes reutilizables: CameraModal, PDFViewerModal, PhoneInput, DatePicker
  - Validaciones robustas client-side
- **Sin embargo:** Todo es mock (localStorage), no hay backend real
- Frontend: ~30% completo | Backend: 0% | Full-stack: ~15%

---

**Documento:** ZNS v2.0 - Consolidación Profunda  
**Fuentes:** PROYECTO_CONTEXTO.md (roadmap) + Código frontend mi-toga/ (estructura)  
**Nota:** RFs extraídos por ingeniería inversa del código + documentación. Validación pendiente con Product Owner.
