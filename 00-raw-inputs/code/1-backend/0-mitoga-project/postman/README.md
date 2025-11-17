# 📮 Postman Collection - Mitoga Registro Estudiante (HUT-001)

## 📋 Descripción

Collection completa para probar el flujo de registro multi-step de estudiantes en Mitoga.

**Arquitectura**: Hexagonal (Ports & Adapters) + DDD  
**Stack**: Spring Boot 3.4.1 + PostgreSQL 17.6 + Redis 7 + MinIO

---

## 🚀 Quick Start

### 1. Importar Collection y Environment

```bash
# En Postman:
File → Import → Seleccionar archivos:
- Mitoga_Registro_Estudiante_HUT-001.postman_collection.json
- Mitoga_Local.postman_environment.json
- Mitoga_Dev.postman_environment.json
```

### 2. Seleccionar Environment

- **Local**: `Mitoga Local` (http://localhost:8080)
- **Dev**: `Mitoga Dev` (https://api-dev.mitoga.edu.co)

### 3. Ejecutar Flujo Completo

**Opción A: Manual** (paso a paso)
1. STEP 1 - Credenciales
2. STEP 2 - Información Personal (Mayor Edad)
3. STEP 3 - Archivos
4. STEP 4 - Confirmación OTP

**Opción B: Automatizado** (Collection Runner)
```
1. Click derecho en la collection
2. Run collection
3. Select environment: Mitoga Local
4. Run Mitoga Registro Estudiante
```

---

## 📊 Requests Incluidas

### 1️⃣ STEP 1 - Credenciales
**POST** `/api/v1/auth/registro/step-1`

**Input**:
```json
{
  "email": "{{testEmail}}",
  "password": "{{testPassword}}",
  "aceptaTerminos": true,
  "aceptaHabeasData": true
}
```

**Output**:
```json
{
  "data": {
    "usuarioId": "uuid",
    "procesoId": "uuid",
    "mensaje": "OTP enviado a email"
  }
}
```

**Tests Automatizados** (7 tests):
- ✅ Status 201 Created
- ✅ Response time < 3000ms
- ✅ Response has required fields
- ✅ UsuarioId is valid UUID
- ✅ ProcesoId is valid UUID
- ✅ Mensaje mentions OTP
- ✅ Variables guardadas en environment

---

### 2️⃣ STEP 2 - Información Personal (Mayor Edad)
**POST** `/api/v1/auth/registro/step-2`

**Input**:
```json
{
  "procesoId": "{{procesoId}}",
  "primerNombre": "Juan",
  "segundoNombre": "Carlos",
  "primerApellido": "Pérez",
  "segundoApellido": "García",
  "fechaNacimiento": "2000-05-15",
  "genero": "M",
  "paisId": "uuid",
  "ciudadId": "uuid",
  "direccion": "Calle 123 # 45-67",
  "telefono": "+57 310 1234567"
}
```

**Output**:
```json
{
  "data": {
    "procesoId": "uuid",
    "requiereResponsableLegal": false,
    "stepCompletado": 2
  }
}
```

**Tests Automatizados** (5 tests):
- ✅ Status 200 OK
- ✅ Response time < 2000ms
- ✅ Proceso ID matches
- ✅ No requiere responsable legal
- ✅ Step completado es 2

---

### 3️⃣ STEP 3 - Archivos
**POST** `/api/v1/auth/registro/step-3`  
*Content-Type*: `multipart/form-data`

**Input**:
- `procesoId`: UUID
- `tipoDocumento`: CEDULA_CIUDADANIA
- `numeroDocumento`: string
- `fotoPerfil`: file (JPG/PNG, max 5MB)
- `fotoDocumentoFrontal`: file
- `fotoDocumentoReverso`: file
- `fotoEnVivo`: file (selfie)

**Output**:
```json
{
  "data": {
    "verificacionId": "uuid",
    "archivoIds": ["uuid1", "uuid2", "uuid3", "uuid4"],
    "stepCompletado": 3
  }
}
```

**Tests Automatizados** (5 tests):
- ✅ Status 200 OK
- ✅ Response time < 5000ms
- ✅ Verificación ID exists
- ✅ ArchivoIds array has 4 elements
- ✅ Step completado es 3

---

### 4️⃣ STEP 4 - Confirmación OTP
**POST** `/api/v1/auth/registro/step-4`

**Input**:
```json
{
  "procesoId": "{{procesoId}}",
  "codigoOTP": "{{otpCode}}"
}
```

**Output**:
```json
{
  "data": {
    "usuarioId": "uuid",
    "accessToken": "jwt-token",
    "refreshToken": "jwt-refresh-token",
    "emailVerificado": true
  }
}
```

**Tests Automatizados** (6 tests):
- ✅ Status 200 OK
- ✅ Response time < 2000ms
- ✅ Access token is present
- ✅ Refresh token is present
- ✅ Usuario ID matches
- ✅ Email verificado es true

---

## 🔐 Variables de Environment

### Mitoga Local
```json
{
  "baseUrl": "http://localhost:8080",
  "testEmail": "estudiante.local@mitoga.edu.co",
  "testPassword": "LocalPass123!",
  "usuarioId": "",         // Auto-populated
  "procesoId": "",         // Auto-populated
  "otpCode": "123456",     // Mock (en prod obtener del email)
  "verificacionId": "",    // Auto-populated
  "accessToken": "",       // Auto-populated
  "refreshToken": ""       // Auto-populated
}
```

### Mitoga Dev
```json
{
  "baseUrl": "https://api-dev.mitoga.edu.co",
  "testEmail": "estudiante.dev@mitoga.edu.co",
  "testPassword": "DevPass123!",
  ...
}
```

---

## ✅ Tests Automatizados

**Total**: **23 tests** automatizados

| Request | Tests | Validaciones |
|---------|-------|--------------|
| STEP 1  | 7     | Status, tiempo, UUIDs válidos, variables guardadas |
| STEP 2  | 5     | Status, proceso ID, responsable legal, step |
| STEP 3  | 5     | Status, verificación ID, 4 archivos, step |
| STEP 4  | 6     | Status, tokens JWT, email verificado |

**Ejecución**:
```bash
# CLI (Newman)
newman run Mitoga_Registro_Estudiante_HUT-001.postman_collection.json \
  -e Mitoga_Local.postman_environment.json \
  --reporters cli,json

# Postman GUI
Collection Runner → Run → Ver resultados
```

---

## 🎯 Flujos Cubiertos

### ✅ Flujo Happy Path - Mayor de Edad
1. ✅ STEP 1: Registro credenciales
2. ✅ STEP 2: Información personal (sin responsable legal)
3. ✅ STEP 3: Upload 4 archivos
4. ✅ STEP 4: Validación OTP → Tokens JWT

### ⚠️ Validaciones de Errores
- ❌ Email duplicado → 409 Conflict
- ❌ Password débil → 400 Bad Request
- ❌ OTP inválido → 400 Bad Request
- ❌ OTP expirado (> 10 min) → 400 Bad Request
- ❌ Transición de estado inválida → 409 Conflict

---

## 📝 Notas Importantes

### OTP en Tests
⚠️ **IMPORTANTE**: En ambiente de pruebas, el OTP está hardcodeado como `"123456"` en la variable `{{otpCode}}`.

**En producción**:
1. Ejecutar STEP 1
2. Revisar email recibido
3. Copiar OTP de 6 dígitos
4. Actualizar variable `{{otpCode}}` en Postman
5. Ejecutar STEP 4

### Archivos en STEP 3
Para ejecutar STEP 3 correctamente:
1. Preparar 4 imágenes de prueba (JPG/PNG)
2. En Postman, ir a Body → form-data
3. Para cada campo `file`, seleccionar archivo local
4. Enviar request

**Restricciones**:
- Formatos: image/jpeg, image/png
- Tamaño máximo: 5MB por archivo
- 4 archivos obligatorios

---

## 🔧 Troubleshooting

### Error: "Email ya registrado"
**Solución**: Cambiar variable `{{testEmail}}` a un email nuevo en el environment.

### Error: "Proceso no encontrado"
**Solución**: Verificar que `{{procesoId}}` esté poblado correctamente después de STEP 1.

### Error: "OTP inválido"
**Solución**: 
- Local: Verificar que `{{otpCode}}` = `"123456"`
- Dev: Revisar email y copiar OTP real

### Error: "Archivo demasiado grande"
**Solución**: Reducir tamaño de imágenes a < 5MB.

---

## 📊 Métricas de Performance

| Endpoint | Tiempo Esperado |
|----------|-----------------|
| STEP 1   | < 3000ms        |
| STEP 2   | < 2000ms        |
| STEP 3   | < 5000ms        |
| STEP 4   | < 2000ms        |

**Flujo completo**: < 12 segundos

---

## 🚀 CI/CD Integration

Para integrar con pipelines CI/CD:

```yaml
# .gitlab-ci.yml
test:postman:
  stage: test
  image: postman/newman:alpine
  script:
    - newman run postman/Mitoga_Registro_Estudiante_HUT-001.postman_collection.json \
        -e postman/Mitoga_Dev.postman_environment.json \
        --reporters cli,junit \
        --reporter-junit-export results.xml
  artifacts:
    reports:
      junit: results.xml
```

---

## 📚 Referencias

- **Documentación API**: `/swagger-ui.html`
- **Architecture Decision Records**: `04-architecture/adrs/`
- **HUT-001 Spec**: `05-deliverables/huts/HUT-001.md`
- **Postman Docs**: https://learning.postman.com/docs/

---

✅ **Collection creada**: 16 Nov 2025  
📦 **Versión**: 1.0.0  
👨‍💻 **Autor**: ZNS Backend Senior Developer
