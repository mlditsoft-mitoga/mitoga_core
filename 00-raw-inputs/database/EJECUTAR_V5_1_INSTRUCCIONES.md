# 🎯 INSTRUCCIONES PARA EJECUTAR V5.1 - STORAGE EXTENSIÓN

## ✅ V5.1 - EXTENSIÓN STORAGE TUTORES
**Extiende `shared_schema.archivos` de V4 para soportar archivos y fotos de tutores**

## 📋 Credenciales PostgreSQL K3s:
- **Host:** 192.168.18.126
- **Puerto:** 5432  
- **Database:** mitogadb
- **Usuario:** admin
- **Password:** Shacall1989*.

## 🔧 Prerequisitos OBLIGATORIOS:
- ✅ **V4 ejecutado:** `shared_schema.archivos` debe existir
- ✅ **V5 ejecutado:** `tutores_schema.perfiles_tutor` debe existir
- ✅ **V1, V2, V3:** Schemas base ejecutados

## 🎯 ¿Qué hace V5.1?

### 📂 **Extiende ENUM `shared_schema.tipo_archivo`:**
```sql
-- Nuevos tipos para tutores:
'FOTO_PERFIL_TUTOR'      -- Avatar principal del tutor
'VIDEO_PRESENTACION'     -- Video intro del tutor  
'CERTIFICADO_EDUCATIVO'  -- Diplomas, títulos
'CERTIFICADO_EXPERIENCIA'-- Cartas laborales
'CERTIFICADO_IDIOMA'     -- TOEFL, DELE, etc.
'DOCUMENTO_FISCAL'       -- RUT, RFC para facturación
'PORTAFOLIO_TRABAJO'     -- Muestras de trabajo
'FOTO_WORKSPACE'         -- Foto del espacio de trabajo
```

### 🗂️ **Crea tabla `tutores_schema.tutor_archivos`:**
```sql
-- Relación N:M entre tutores y archivos compartidos
tutor_archivos {
    tutor_id → perfiles_tutor(pkid_tutor)
    archivo_id → shared_schema.archivos(pkid_archivos)
    es_principal BOOLEAN        -- Para foto perfil principal
    orden_visualizacion INTEGER -- Orden en galería
    fecha_verificacion TIMESTAMPTZ
    verificado_por_admin_id UUID
    etiquetas JSONB            -- ["verificado", "destacado"]
}
```

### ⚡ **Funciones helper incluidas:**
```sql
-- Obtener archivos de un tutor
SELECT * FROM tutores_schema.get_tutor_archivos(
    'uuid-tutor', 
    'CERTIFICADO_EDUCATIVO'::shared_schema.tipo_archivo
);

-- Obtener foto perfil principal o default
SELECT tutores_schema.get_foto_perfil_principal('uuid-tutor');
-- Retorna: URL o '/images/avatar-default.jpg'
```

## 🔧 Opciones de Ejecución:

### Opción 1: DBeaver / pgAdmin
1. Crear nueva conexión con las credenciales arriba
2. Abrir archivo: `V5_1__tutores_storage_extension.sql`
3. Ejecutar script completo (F5 o Ctrl+Enter)

### Opción 2: psql desde K3s pod
```bash
# Conectar al pod PostgreSQL
kubectl exec -it [POSTGRES_POD_NAME] -n [NAMESPACE] -- psql -U admin -d mitogadb

# En psql ejecutar:
\i /path/to/V5_1__tutores_storage_extension.sql
```

### Opción 3: Cliente PostgreSQL remoto
```bash
# Si tienes psql instalado localmente
PGPASSWORD="Shacall1989*." psql -h 192.168.18.126 -p 5432 -U admin -d mitogadb -f V5_1__tutores_storage_extension.sql
```

## 📊 Esperado después de ejecución exitosa:
```
V5.1: INICIANDO EXTENSIÓN STORAGE TUTORES
✅ Prerequisito V4 (shared_schema.archivos) verificado
✅ Prerequisito V5 (tutores_schema) verificado
✅ Tipo FOTO_PERFIL_TUTOR agregado
✅ Tipo VIDEO_PRESENTACION agregado
✅ Tipo CERTIFICADO_EDUCATIVO agregado
✅ Tipo CERTIFICADO_EXPERIENCIA agregado
✅ Tipo CERTIFICADO_IDIOMA agregado
✅ Tipo DOCUMENTO_FISCAL agregado
✅ Tipo PORTAFOLIO_TRABAJO agregado
✅ Tipo FOTO_WORKSPACE agregado
✅ FK fk_tutor_archivos_tutor creada
✅ FK fk_tutor_archivos_archivo creada
✅ FK fk_tutor_archivos_admin_verificador creada
✅ Trigger auditoría tutor_archivos creado
✅ Constraint tipos tutores agregado a archivos
📊 RESUMEN V5.1 STORAGE EXTENSIÓN:
✅ Nuevos tipos archivo: 8 de 8 esperados
✅ Tabla tutor_archivos: CREADA
✅ Foreign Keys: 3 de 3 esperadas
✅ Índices: 6+ de 6+ esperados
✅ Funciones helper: 2 creadas
🎉 V5.1 STORAGE EXTENSIÓN COMPLETADA EXITOSAMENTE
```

## 🚨 En caso de errores:

### Error: "PREREQUISITO FALTANTE: shared_schema.archivos no existe"
- **Solución:** Ejecutar V4 primero (`V4__registro_estudiantes_multistep.sql`)

### Error: "PREREQUISITO FALTANTE: tutores_schema no existe"  
- **Solución:** Ejecutar V5 primero (`V5__registro_tutores_multistep.sql`)

### Error: "tipo ya existe"
- **Es normal:** V5.1 es idempotente, puede ejecutarse múltiples veces

## 🎯 **Arquitectura Storage Resultante:**

```
shared_schema.archivos (V4)
├── Metadata todos los archivos (estudiantes + tutores)
├── Storage providers (LOCAL, AWS_S3, CLOUDINARY)
├── Validaciones MIME types
└── Hashes MD5/SHA256

tutores_schema.tutor_archivos (V5.1)
├── Relaciones tutor ↔ archivos
├── Metadata específica tutores
├── Control de archivos principales
├── Sistema de verificación admin
└── Etiquetas y orden visualización
```

## 💡 **Uso en APIs:**

```javascript
// Subir foto perfil tutor
POST /api/tutors/{tutorId}/files
{
  "file": FormData,
  "tipo": "FOTO_PERFIL_TUTOR", 
  "es_principal": true
}

// Obtener archivos tutor
GET /api/tutors/{tutorId}/files?tipo=CERTIFICADO_EDUCATIVO

// Obtener foto perfil
GET /api/tutors/{tutorId}/avatar
// Response: URL de foto principal o default
```

---

**🎯 V5.1 extiende el storage compartido de V4 para tutores con todas las lecciones aplicadas**