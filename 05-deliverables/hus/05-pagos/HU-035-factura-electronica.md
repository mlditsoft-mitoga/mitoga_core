# HU-035: Generar factura electrónica

**Épica:** Pagos | **Rol:** Estudiante/Tutor | **Prioridad:** MUST HAVE (MVP - Colombia compliance)

---

## 📖 Historia

> **Como** estudiante/tutor colombiano, **quiero** generar factura electrónica DIAN para cada transacción, **para** cumplir requisitos fiscales y deducir impuestos.

---

## ✅ Criterios

### **Escenario 1: Factura generada automáticamente post-pago**
```gherkin
Given estudiante "Ana" pagó sesión BK-001 ($15.000)
When pago confirmado exitosamente
Then sistema ejecuta job generación factura:
  - Consulta API DIAN para número factura consecutivo
  - Genera XML factura electrónica (formato UBL 2.1)
  - Firma digitalmente con certificado plataforma
  - Envía a DIAN para validación
  - Guarda PDF + XML en S3
  - Envía email con adjuntos: Factura_MITOGA_001.pdf
```

### **Escenario 2: Contenido factura estudiante**
```gherkin
Then factura incluye:
  - Emisor: MI-TOGA SAS | NIT 901.234.567-8
  - Receptor: Ana Martínez | CC 1.234.567.890
  - Fecha emisión: 05/01/2025
  - Concepto: "Sesión tutoría Matemáticas - 1 hora"
  - Tutor: Carlos Pérez
  - Subtotal: $15.000
  - IVA (19%): $2.850
  - Total: $17.850
  - CUFE (código único DIAN): ABC123...
  - QR verificación DIAN
```

### **Escenario 3: Factura para tutor (ingresos)**
```gherkin
Given tutor "Carlos" recibió pago sesión
When fondos liberados después 7 días
Then genera factura tutor→plataforma:
  - Emisor: Carlos Pérez | NIT/CC personal
  - Receptor: MI-TOGA SAS
  - Concepto: "Servicios profesionales tutoría"
  - Subtotal: $12.000 (80% después comisión)
  - Retención fuente (si aplica): $600 (5%)
  - Total a pagar: $11.400
```

### **Escenario 4: Descargar factura desde historial**
```gherkin
When accede a /perfil/facturas
Then muestra listado facturas:
  | Número      | Fecha      | Concepto    | Monto    | Descargar |
  | FAC-001-2025| 05/01/2025 | Sesión Mat. | $17.850  | [PDF][XML]|
  | FAC-002-2025| 12/01/2025 | Sesión Ing. | $19.040  | [PDF][XML]|
```

---

## 🔗 Trazabilidad

**RF:** RF-035 | **RNF:** RNF-LEGAL-001 (facturación electrónica DIAN obligatoria Colombia)

**Story Points:** 8 SP | **Complejidad:** Alta (integración DIAN)

---

## 🧩 Dependencias

- **Depende de:** HU-030 (Pago procesado)

---

## ✔️ DoD

- [ ] Integración API DIAN factura electrónica (proveedor: Alegra, Siigo, Carvajal)
- [ ] Endpoint `POST /api/facturas/generar` job background
- [ ] Generación XML UBL 2.1 + firma digital
- [ ] PDF template factura con logo + QR DIAN
- [ ] Tabla `facturas`: numero, cufe, xml_url, pdf_url, dian_status
- [ ] Página `/perfil/facturas` listado descargables
- [ ] Email adjunta PDF + XML automáticamente
- [ ] Manejo errores DIAN (reintento 3 veces si falla)
- [ ] Tests integración: mock DIAN API, validar XML estructura

---

**Etiquetas:** `#pagos` `#mvp` `#must-have` `#facturacion-electronica` `#dian` `#colombia` `#compliance` `#legal`

---

## ⚠️ Supuestos

- Plataforma tiene certificado digital DIAN vigente
- Proveedor facturación (Alegra/Siigo) maneja complejidad DIAN
- IVA 19% aplicable servicios educativos digitales (validar con contador)
