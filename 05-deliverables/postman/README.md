# 📦 Postman Collections - MI-TOGA Platform

## 📋 Descripción

Colecciones de Postman organizadas por **Bounded Context** siguiendo arquitectura DDD + Hexagonal.

---

## 🗂️ Estructura de Colecciones

### ✅ BC01 - Autenticación
**Archivo**: `BC01-Autenticacion.postman_collection.json`

**Subdominios cubiertos**:
1. **Registro Multi-step**: 4 pasos (credenciales, info personal, documentos, confirmación)
2. **Verificación Email**: OTP de 6 dígitos con TTL 10 minutos
3. **Login & Tokens**: JWT con Access Token (15 min) + Refresh Token (7 días)
4. **Recuperación Contraseña**: Token por email con TTL 24 horas

**Endpoints (17 total)**:
- `POST /api/v1/auth/registro/estudiante/step1` - Iniciar registro
- `PUT /api/v1/auth/registro/estudiante/step2` - Información personal
- `POST /api/v1/auth/registro/estudiante/step3` - Subir documentos
- `POST /api/v1/auth/registro/estudiante/step4` - Confirmar registro
- `POST /api/v1/auth/verificar-email` - Verificar código OTP
- `POST /api/v1/auth/reenviar-otp` - Reenviar OTP
- `POST /api/v1/auth/login` - Login con JWT
- `POST /api/v1/auth/refresh` - Renovar access token
- `POST /api/v1/auth/logout` - Cerrar sesión
- `GET /api/v1/auth/sesiones` - Listar sesiones activas
- `DELETE /api/v1/auth/sesiones/:id` - Cerrar sesión específica
- `POST /api/v1/auth/recuperar-password` - Solicitar recuperación
- `GET /api/v1/auth/validar-token-recuperacion` - Validar token
- `POST /api/v1/auth/restablecer-password` - Nueva contraseña

**HUTs relacionados**:
- HUT-001: Registro Estudiantes
- HUT-002: Registro Tutores
- HUT-003: Verificación Email OTP
- HUT-006: Login + Refresh Token

---

### ✅ BC - Shared Services
**Archivo**: `BC-Shared-Services.postman_collection.json`

**Subdominios cubiertos**:
1. **Gestión de Archivos**: Upload/download con MinIO/S3
2. **Catálogos**: Países, ciudades, géneros, tipos documento
3. **Health Checks**: Monitoreo de servicios

**Endpoints (12 total)**:
- `POST /api/v1/archivos/upload` - Subir archivo (multipart)
- `GET /api/v1/archivos/:id/download` - Descargar archivo (pre-signed URL)
- `DELETE /api/v1/archivos/:id` - Eliminar archivo (soft delete)
- `GET /api/v1/archivos` - Listar archivos por entidad
- `GET /api/v1/catalogos/paises` - Listar países
- `GET /api/v1/catalogos/ciudades` - Listar ciudades por país
- `GET /api/v1/catalogos/generos` - Listar géneros
- `GET /api/v1/catalogos/tipos-documento` - Tipos de documento
- `GET /api/v1/catalogos/buscar` - Búsqueda universal
- `GET /actuator/health` - Health check
- `GET /actuator/info` - Info de la aplicación

**HUTs relacionados**:
- HUT-004: Gestión Archivos MinIO/S3

---

## 🚀 Cómo Usar

### 1. Importar Colecciones en Postman

#### Opción A: Import desde archivo
1. Abrir Postman Desktop
2. Click en **Import** (esquina superior izquierda)
3. Seleccionar **Upload Files**
4. Importar:
   - `BC01-Autenticacion.postman_collection.json`
   - `BC-Shared-Services.postman_collection.json`
   - `MI-TOGA-Development.postman_environment.json`

#### Opción B: Import desde carpeta
1. Click en **Import**
2. Seleccionar **Folder**
3. Elegir la carpeta `05-deliverables/postman/`
4. Postman detectará automáticamente todos los archivos JSON

---

### 2. Configurar Environment

1. En Postman, ir a **Environments** (barra lateral izquierda)
2. Seleccionar **MI-TOGA Development**
3. Verificar variables:
   - `baseUrl`: `http://localhost:8080` (cambiar si usas otro puerto)
   - `accessToken`: Se auto-completa tras login
   - `refreshToken`: Se auto-completa tras login
   - `usuarioId`, `email`, etc.: Se auto-completan durante flujo

4. **Activar el environment**: Click en el dropdown superior derecho y seleccionar "MI-TOGA Development"

---

### 3. Flujo de Prueba Completo (Registro + Login)

#### PASO 1: Registro de Estudiante (4 Steps)

**Step 1 - Credenciales**:
```http
POST /api/v1/auth/registro/estudiante/step1
Body: {
  "email": "test@example.com",
  "password": "SecurePass123!",
  "confirmPassword": "SecurePass123!"
}
```
✅ **Auto-guarda**: `usuarioId`, `procesoRegistroId`, `email`

**Step 2 - Información Personal**:
```http
PUT /api/v1/auth/registro/estudiante/step2
Body: {
  "usuarioId": "{{usuarioId}}",
  "informacionPersonal": { ... }
}
```
✅ **Auto-guarda**: `informacionBasicaId`

**Step 3 - Documentos**:
```http
POST /api/v1/auth/registro/estudiante/step3
Form-data: 4 archivos (fotoPerfil, documentoFrente, documentoReverso, fotoEnVivo)
```

**Step 4 - Confirmación**:
```http
POST /api/v1/auth/registro/estudiante/step4
Body: {
  "aceptaciones": { ... }
}
```
✅ **Auto-guarda**: `perfilEstudianteId`

---

#### PASO 2: Verificar Email (OTP)

1. Revisar email de prueba (o logs del backend)
2. Copiar código OTP de 6 dígitos
3. Ejecutar:
```http
POST /api/v1/auth/verificar-email
Body: {
  "usuarioId": "{{usuarioId}}",
  "email": "{{email}}",
  "codigoOTP": "123456"
}
```
✅ **Auto-guarda**: `accessToken`, `refreshToken`

---

#### PASO 3: Login (Próximas Sesiones)

```http
POST /api/v1/auth/login
Body: {
  "email": "{{email}}",
  "password": "SecurePass123!"
}
```
✅ **Auto-guarda**: Nuevos tokens + `sesionId`

---

### 4. Tests Automáticos

Cada request incluye **Test Scripts** que:
- ✅ Validan status code
- ✅ Extraen y guardan variables automáticamente
- ✅ Validan estructura de response
- ✅ Muestran logs en Console

**Ver resultados**:
- Tab **Test Results** (después de ejecutar request)
- Console de Postman: `View > Show Postman Console`

---

## 🔐 Autenticación

### Bearer Token (Auto-configurado)

Todos los endpoints protegidos usan **Bearer Token** automáticamente:

```
Authorization: Bearer {{accessToken}}
```

La variable `{{accessToken}}` se actualiza automáticamente tras:
- Login exitoso
- Verificación de email
- Refresh token

---

### Refresh Token Workflow

Si el access token expira (15 min):

1. Ejecutar:
```http
POST /api/v1/auth/refresh
Body: {
  "refreshToken": "{{refreshToken}}"
}
```

2. Postman auto-actualiza `accessToken` y `refreshToken` (token rotation)

---

## 📊 Variables de Environment

### Variables Auto-gestionadas (No editar manualmente)

| Variable | Descripción | Se completa en |
|----------|-------------|----------------|
| `accessToken` | JWT (15 min) | Login / Verificar Email / Refresh |
| `refreshToken` | JWT (7 días) | Login / Verificar Email / Refresh |
| `usuarioId` | UUID del usuario | Registro Step 1 |
| `email` | Email del usuario | Registro Step 1 |
| `procesoRegistroId` | UUID del proceso | Registro Step 1 |
| `informacionBasicaId` | UUID info personal | Registro Step 2 |
| `perfilEstudianteId` | UUID perfil | Registro Step 4 |
| `sesionId` | UUID sesión activa | Login |
| `archivoId` | UUID archivo subido | Upload archivo |

### Variables Configurables

| Variable | Valor Default | Descripción |
|----------|---------------|-------------|
| `baseUrl` | `http://localhost:8080` | URL base del backend |
| `paisId` | `550e8400-...` | UUID país por defecto (Colombia) |

---

## 🧪 Ejecutar Toda una Colección (Runner)

### 1. Collection Runner

1. Click derecho en la colección (ej: **BC01 - Autenticación**)
2. Seleccionar **Run collection**
3. Configurar:
   - Environment: **MI-TOGA Development**
   - Iterations: 1
   - Delay: 500ms (para no sobrecargar)
4. Click **Run BC01 - Autenticación**

### 2. Newman (CLI)

```bash
# Instalar Newman
npm install -g newman

# Ejecutar colección
newman run BC01-Autenticacion.postman_collection.json \
  -e MI-TOGA-Development.postman_environment.json \
  --delay-request 500

# Con reporte HTML
newman run BC01-Autenticacion.postman_collection.json \
  -e MI-TOGA-Development.postman_environment.json \
  -r html \
  --reporter-html-export newman-report.html
```

---

## 📝 Convenciones de Nomenclatura

### Carpetas
```
1. Registro
2. Verificación Email (OTP)
3. Login & Tokens
4. Recuperación Contraseña
```

### Requests
```
1.1 STEP 1 - Iniciar Registro (Credenciales)
1.2 STEP 2 - Completar Información Personal
3.1 Login (Access + Refresh Token)
3.2 Refresh Token (Renovar Access Token)
```

### Variables
- **camelCase**: `usuarioId`, `accessToken`, `perfilEstudianteId`
- **Descriptivas**: Evitar abreviaciones (`informacionBasicaId` en vez de `infoBId`)

---

## 🌍 Environments Disponibles

### Development (Local)
**Archivo**: `MI-TOGA-Development.postman_environment.json`
- Base URL: `http://localhost:8080`
- Backend: Spring Boot local
- Database: PostgreSQL local (puerto 5432)
- Redis: Local (puerto 6379)
- MinIO: Local (puerto 9000)

### Staging (Por crear)
- Base URL: `https://api-staging.mitoga.com`
- Backend: Servidor staging
- Database: PostgreSQL staging
- Redis: Redis Cloud
- Storage: MinIO cluster o AWS S3

### Production (Por crear)
- Base URL: `https://api.mitoga.com`
- Backend: Kubernetes cluster
- Database: RDS PostgreSQL
- Redis: ElastiCache
- Storage: AWS S3

---

## 🔧 Troubleshooting

### ❌ Error: "baseUrl is not defined"
**Solución**: Activar el environment "MI-TOGA Development" en el dropdown superior derecho.

### ❌ Error: 401 Unauthorized
**Causas**:
1. Access token expirado (15 min) → Ejecutar **3.2 Refresh Token**
2. Refresh token expirado (7 días) → Ejecutar **3.1 Login** de nuevo
3. Sesión cerrada manualmente → Hacer login nuevamente

**Solución rápida**: Ejecutar `POST /api/v1/auth/login` para obtener nuevos tokens.

### ❌ Error: "Email ya registrado"
**Solución**: 
- Usar la variable dinámica `{{$randomEmail}}` en Step 1 (ya configurada)
- O eliminar el usuario de la base de datos:
```sql
DELETE FROM appmatch_schema.usuarios WHERE email = 'test@example.com';
```

### ❌ Error: "Usuario no encontrado" en Step 2/3/4
**Causa**: Variables `usuarioId` o `procesoRegistroId` no se guardaron.

**Solución**:
1. Verificar que ejecutaste **Step 1** primero
2. Revisar tab **Test Results** de Step 1 → debe mostrar "✅ Usuario creado"
3. Verificar en **Environment** que `usuarioId` tiene valor

### ❌ Código OTP inválido
**Solución**:
1. Revisar logs del backend:
```bash
tail -f logs/mitoga-backend.log | grep OTP
```
2. O consultar Redis directamente:
```bash
redis-cli
GET otp:{usuarioId}
```

---

## 📚 Recursos Adicionales

### Documentación Relacionada
- **HUTs**: `05-deliverables/huts/` (Historias Técnicas detalladas)
- **ADRs**: `04-architecture/adrs/` (Decisiones arquitectónicas)
- **Diagramas**: `04-architecture/diagrams/` (C4, ERD, secuencia)
- **README Proyecto**: `README.md` (Estructura completa del método ZNS)

### Postman Learning
- [Postman Learning Center](https://learning.postman.com/)
- [Test Scripts Guide](https://learning.postman.com/docs/writing-scripts/test-scripts/)
- [Variables Guide](https://learning.postman.com/docs/sending-requests/variables/)

---

## 🎯 Próximas Colecciones (Roadmap)

- [ ] **BC02 - Marketplace**: Gestión de tutores y catálogo
- [ ] **BC03 - Perfiles**: Gestión de perfiles de estudiantes y tutores
- [ ] **BC04 - Reservas**: Sistema de reservas y disponibilidad
- [ ] **BC05 - Pagos**: Integración con Stripe/PSE
- [ ] **BC06 - Videollamadas**: Integración con Agora
- [ ] **BC07 - Notificaciones**: Email, push, SMS
- [ ] **BC08 - Admin**: Panel administrativo

---

## 📞 Contacto y Soporte

**Equipo Backend MI-TOGA**  
- Email: backend@mitoga.com
- Slack: #backend-dev
- Jira: [MI-TOGA Backend Board](https://mitoga.atlassian.net/...)

---

**Fecha última actualización**: 17 de noviembre de 2025  
**Versión**: 1.0.0  
**Autor**: Equipo Backend Senior MI-TOGA
