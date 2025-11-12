# HU-070: Crear/editar perfil de estudiante

**Épica:** Perfiles | **Rol:** Estudiante | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** estudiante, **quiero** editar mi perfil (foto, nombre, intereses, nivel educativo), **para** personalizar mi experiencia y recibir recomendaciones relevantes.

---

## 💼 Valor

- **Personalización:** Perfiles completos aumentan engagement ~40%
- **Recomendaciones:** Datos nivel educativo mejoran match tutor-estudiante

---

## ✅ Criterios

### **Escenario 1: Editar perfil exitoso**
```gherkin
Given estudiante "María" accede a /perfil/editar
When actualiza:
  | Campo              | Valor anterior | Valor nuevo        |
  | Foto perfil        | default.jpg    | maria.jpg (upload) |
  | Nombre             | María          | María Fernández    |
  | Nivel educativo    | No especificado| Universitario      |
  | Materias interés   | []             | [Matemáticas, Física] |
  | Bio                | ""             | "Estudiante Ing..." |
Then sistema valida campos
  And guarda en BD
  And muestra toast "Perfil actualizado"
  And foto se procesa (resize 300×300, WebP)
```

### **Escenario 2: Cambio email requiere reverificación**
```gherkin
Given email actual "maria@email.com" verificado
When cambia a "maria.nueva@email.com"
Then sistema:
  - Marca email_verified=false
  - Envía OTP a email nuevo
  - Mantiene sesión activa pero requiere verificación
  - Muestra banner "Verifica tu nuevo email"
```

### **Escenario 3: Upload foto con validaciones**
```gherkin
When sube imagen 5MB, formato PNG
Then sistema valida:
  - Tamaño < 3MB ✅
  - Formato: JPG, PNG, WebP ✅
  - Dimensiones mín 200×200 ✅
Then procesa imagen:
  - Crop cuadrado automático
  - Resize 300×300 (thumbnail)
  - Compresión WebP (quality 85%)
  - Upload a S3/Cloudinary
  - Actualiza profile_picture URL
```

---

## 🔗 Trazabilidad

**RF:** RF-070 (Gestionar perfil estudiante)  
**RNF:** RNF-USAB-005 (preview foto antes guardar)

**Story Points:** 5 SP | **Complejidad:** Media

---

## 🧩 Dependencias

- **Depende de:** HU-001 (Registro estudiante)
- **Relacionada con:** HU-004 (Verificar email si cambia)

---

## ✔️ DoD

- [ ] Endpoint `PUT /api/estudiantes/{id}/perfil` con validaciones
- [ ] Endpoint `POST /api/upload/profile-picture` (multipart/form-data)
- [ ] Integración storage (AWS S3 / Cloudinary)
- [ ] Frontend: formulario con preview imagen en tiempo real
- [ ] Validación email único (si cambia)
- [ ] Campo "nivel_educativo": enum (Primaria, Secundaria, Universitario, Profesional)
- [ ] Tests unitarios: validaciones campos, upload imagen
- [ ] Test E2E: editar perfil completo→guardar→verificar datos

---

**Etiquetas:** `#perfiles` `#mvp` `#must-have` `#estudiante` `#personalizacion` `#upload-imagen`
