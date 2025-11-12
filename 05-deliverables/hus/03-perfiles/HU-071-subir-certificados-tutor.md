# HU-071: Subir certificados de tutor

**Épica:** Perfiles | **Rol:** Tutor | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** tutor, **quiero** subir mis certificados profesionales (títulos, diplomas, certificaciones), **para** validar mi experiencia y aumentar mi credibilidad ante estudiantes.

---

## 💼 Valor

- **Trust building:** Tutores con certificados verificados convierten 2.5x más
- **Compliance:** Requisito legal para tutorías especializadas (medicina, derecho)
- **Diferenciación:** Badge "Certificado verificado" destaca perfil en búsqueda

---

## ✅ Criterios

### **Escenario 1: Upload certificado exitoso**
```gherkin
Given tutor "Carlos" accede a /perfil/certificados
When hace clic "Subir certificado"
  And selecciona archivo "Titulo_Ingeniero.pdf" (2.3 MB)
  And completa formulario:
    | Campo              | Valor                     |
    | Tipo certificado   | Título universitario      |
    | Institución        | Universidad Nacional      |
    | Área conocimiento  | Ingeniería de Sistemas    |
    | Fecha obtención    | 15/06/2020                |
Then sistema:
  - Valida PDF < 5MB ✅
  - Upload a S3 bucket privado (no público)
  - Crea registro certificados tabla con status=PENDIENTE_REVISION
  - Notifica admin para aprobación
  - Muestra badge "En revisión (24-48h)"
```

### **Escenario 2: Admin aprueba certificado**
```gherkin
Given admin revisa certificado ID-123
When marca como "Aprobado"
Then sistema:
  - Cambia status=APROBADO
  - Activa badge "✓ Certificado verificado" en perfil tutor
  - Envía email tutor: "Tu certificado fue aprobado"
  - Aumenta score relevancia tutor (+15% ranking búsqueda)
```

### **Escenario 3: Admin rechaza certificado**
```gherkin
When admin marca "Rechazado" con motivo "Documento ilegible"
Then sistema:
  - Cambia status=RECHAZADO
  - Envía email tutor con motivo rechazo
  - Permite resubir (botón "Subir nuevamente")
```

### **Escenario 4: Múltiples certificados**
```gherkin
Given tutor tiene 3 certificados:
  | Certificado         | Status   |
  | Título Ingeniero    | Aprobado |
  | Maestría Educación  | Pendiente|
  | Certificación TOEFL | Aprobado |
When estudiante ve perfil tutor
Then muestra sección "Certificaciones (2 verificadas)":
  - Lista solo certificados APROBADOS
  - Icons por tipo: 🎓 Título, 📜 Certificación, 🏆 Maestría
```

---

## 🔗 Trazabilidad

**RF:** RF-071 (Subir certificados tutor)  
**RNF:** RNF-SEC-008 (certificados almacenados con encryption at rest)

**Story Points:** 8 SP | **Complejidad:** Alta (workflow aprobación admin)

---

## 🧩 Dependencias

- **Depende de:** HU-005 (Registro tutor)
- **Bloquea a:** HU-060 (Aprobación admin tutor)
- **Relacionada con:** HU-012 (Ver perfil tutor con certificados)

---

## ✔️ DoD

- [ ] Endpoint `POST /api/tutores/{id}/certificados` (multipart/form-data)
- [ ] Endpoint `GET /api/admin/certificados/pendientes` (admin panel)
- [ ] Endpoint `PATCH /api/admin/certificados/{id}/revisar` (aprobar/rechazar)
- [ ] Tabla `certificados`: tipo, institucion, area, fecha, status, archivo_url, reviewed_by, reviewed_at
- [ ] Storage S3 bucket privado con pre-signed URLs (admin solo)
- [ ] Validaciones: PDF/JPG < 5MB, metadata obligatorios
- [ ] Email templates: notificación aprobación/rechazo
- [ ] Badge "Certificado verificado" en TutorCard component
- [ ] Tests E2E: upload→aprobación admin→badge visible en perfil

---

**Etiquetas:** `#perfiles` `#mvp` `#must-have` `#tutor` `#certificaciones` `#admin-approval` `#trust` `#compliance`

---

## ⚠️ Supuestos

- Admin revisa certificados en <48h (SLA manual)
- OCR automático para validar texto certificado → Fase 2 (IA)
