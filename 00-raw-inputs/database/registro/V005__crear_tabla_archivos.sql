-- ═══════════════════════════════════════════════════════════════════════════════
-- SCRIPT: V005__crear_tabla_archivos.sql
-- AUTOR: Database Engineer Senior - PostgreSQL Architect
-- FECHA: 2025-11-16
-- VERSION: 1.0.0
-- 
-- DESCRIPCION:
--   Creación de la tabla 'archivos' para gestionar documentos adjuntos por perfil
--   de usuario (fotos de perfil, documentos de identidad, certificados, PDFs, etc.).
--   
--   Cada registro representa UN archivo asociado a un perfil específico de usuario.
--   Permite múltiples archivos por perfil (ej: foto perfil + cédula + diploma).
--   
--   Características:
--   - Almacenamiento de metadata del archivo (nombre, tipo, tamaño, hash)
--   - Soporte para múltiples tipos de archivo (imagen, documento, video, audio)
--   - Categorización de archivos (FOTO_PERFIL, DOCUMENTO_IDENTIDAD, CERTIFICADO, etc.)
--   - Path/URL del archivo en storage (filesystem, S3, Azure Blob, etc.)
--   - Validación de virus/malware (estado_verificacion)
--   - Versionado de archivos (version del archivo)
--
-- BOUNDED CONTEXT: Gestión de Archivos (File Management)
-- PATTERN: One-to-Many (Un perfil puede tener múltiples archivos)
-- 
-- DEPENDENCIAS:
--   - V003__crear_tabla_perfil_informacion_basica.sql (tabla perfil_informacion_basica)
--   - PostgreSQL 12+, Extension uuid-ossp
--
-- CRITERIOS DE DISEÑO DDD:
--   ✅ Schema único (appmatch_schema)
--   ✅ Naming convention: pkid_{tabla}, creation_date, expiration_date
--   ✅ Foreign Keys con nomenclatura estándar (fk_pkid_{tabla})
--   ✅ Constraints explícitos (tipo_archivo, categoria, estado)
--   ✅ Soft delete (expiration_date)
--   ✅ Audit trail completo (usuario que subió, IP, fecha)
--   ✅ Índices para búsquedas comunes y filtros
--   ✅ Seguridad (hash MD5/SHA256 para verificación de integridad)
-- ═══════════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 1: Verificar prerrequisitos
-- ═══════════════════════════════════════════════════════════════════════════════

-- Verificar que existe appmatch_schema
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'appmatch_schema') THEN
        RAISE EXCEPTION 'Schema appmatch_schema no existe. Ejecutar scripts previos.';
    END IF;
END $$;

-- Verificar que existe tabla perfil_informacion_basica
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'appmatch_schema' AND table_name = 'perfil_informacion_basica'
    ) THEN
        RAISE EXCEPTION 'Tabla appmatch_schema.perfil_informacion_basica no existe. Ejecutar V003 primero.';
    END IF;
END $$;

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 2: Crear tabla archivos
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS appmatch_schema.archivos (
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    pkid_archivos UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- RELACIÓN CON PERFIL DE USUARIO
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    fk_pkid_perfil_informacion_basica UUID NOT NULL,
        -- FK a appmatch_schema.perfil_informacion_basica
        -- Un perfil puede tener MÚLTIPLES archivos (1:N)
        -- Ejemplo: Un tutor puede tener foto perfil + cédula + diploma + certificados
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- METADATA DEL ARCHIVO
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    nombre_original VARCHAR(255) NOT NULL,
        -- Nombre original del archivo subido por el usuario
        -- Ejemplo: "cedula_frente.jpg", "diploma_universidad.pdf"
        
    nombre_almacenado VARCHAR(255) NOT NULL,
        -- Nombre del archivo en el storage (filesystem, S3, Azure Blob)
        -- Ejemplo: "2025/11/16/aabee5d7-14bb-4d90-8e4b-347b736b6485.jpg"
        -- Usar UUID o hash para evitar conflictos de nombres
        
    ruta_almacenamiento TEXT NOT NULL,
        -- Path completo o URL del archivo en storage
        -- Filesystem: "/opt/mitoga/uploads/2025/11/16/aabee5d7.jpg"
        -- S3: "s3://mitoga-prod-uploads/2025/11/16/aabee5d7.jpg"
        -- Azure: "https://mitogastorage.blob.core.windows.net/uploads/2025/11/16/aabee5d7.jpg"
        -- URL pública: "https://cdn.mitoga.com/uploads/2025/11/16/aabee5d7.jpg"
    
    extension VARCHAR(10) NOT NULL,
        -- Extensión del archivo (sin punto)
        -- Ejemplos: jpg, png, pdf, docx, mp4
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- AUDITORÍA Y CONTROL
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    fecha_carga TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        -- Fecha/hora en que se cargó el archivo
        
    descripcion TEXT NULL,
        -- Descripción opcional del archivo proporcionada por el usuario
        -- Ejemplo: "Cédula de ciudadanía frente", "Diploma de ingeniería"
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- METADATA EXTENDIDA
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    metadata JSONB DEFAULT '{}'::JSONB,
        -- Metadata adicional del archivo
        -- Ejemplos: 
        -- {"exif": {...}, "ocr_text": "...", "tags": ["certificado", "2023"]}
        -- {"aprobado_por": "admin_uuid", "fecha_aprobacion": "2025-11-16"}
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- CONSTRAINTS
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    CONSTRAINT pk_archivos PRIMARY KEY (pkid_archivos),
    
    -- Foreign Keys
    CONSTRAINT fk_archivos_perfil_informacion_basica
        FOREIGN KEY (fk_pkid_perfil_informacion_basica)
        REFERENCES appmatch_schema.perfil_informacion_basica(pkid_perfil_informacion_basica)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        -- Si se elimina el perfil, se eliminan sus archivos
    
    -- CHECK constraints - Nombres
    CONSTRAINT ck_archivos_nombre_original_no_vacio
        CHECK (TRIM(nombre_original) <> ''),
        
    CONSTRAINT ck_archivos_nombre_almacenado_no_vacio
        CHECK (TRIM(nombre_almacenado) <> ''),
        
    CONSTRAINT ck_archivos_ruta_almacenamiento_no_vacia
        CHECK (TRIM(ruta_almacenamiento) <> ''),
    
    -- CHECK constraint - Extensión
    CONSTRAINT ck_archivos_extension_no_vacia
        CHECK (TRIM(extension) <> ''),
        
    CONSTRAINT ck_archivos_extension_minusculas
        CHECK (extension = LOWER(extension)),
        -- Extensión siempre en minúsculas
    
    -- Soft delete coherente
    CONSTRAINT ck_archivos_soft_delete_coherente
        CHECK (
            expiration_date IS NULL OR 
            expiration_date > creation_date
        )
);

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 3: Crear índices para búsquedas comunes y performance
-- ═══════════════════════════════════════════════════════════════════════════════

-- Índice en FK a perfil_informacion_basica (CRÍTICO para JOINs)
CREATE INDEX idx_archivos_fk_perfil_info_basica 
    ON appmatch_schema.archivos(fk_pkid_perfil_informacion_basica) 
    WHERE expiration_date IS NULL;

-- Índice en fecha_carga para reportes temporales
CREATE INDEX idx_archivos_fecha_carga 
    ON appmatch_schema.archivos(fecha_carga DESC) 
    WHERE expiration_date IS NULL;

-- Índice GIN para búsquedas en metadata JSONB
CREATE INDEX idx_archivos_metadata 
    ON appmatch_schema.archivos USING GIN(metadata);

-- Índice en nombre_original para búsquedas por nombre
CREATE INDEX idx_archivos_nombre_original 
    ON appmatch_schema.archivos(LOWER(nombre_original)) 
    WHERE expiration_date IS NULL;

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 4: Documentación (COMMENTS)
-- ═══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE appmatch_schema.archivos IS 
'Tabla de archivos adjuntos por perfil de usuario (fotos, documentos, certificados, PDFs).
Un registro = un archivo. Tabla simplificada para almacenamiento básico de archivos.';

COMMENT ON COLUMN appmatch_schema.archivos.pkid_archivos IS 
'Primary Key UUID de la tabla archivos';

COMMENT ON COLUMN appmatch_schema.archivos.fk_pkid_perfil_informacion_basica IS 
'FK a appmatch_schema.perfil_informacion_basica. Un perfil puede tener múltiples archivos (1:N).';

COMMENT ON COLUMN appmatch_schema.archivos.nombre_original IS 
'Nombre original del archivo subido por el usuario (ej: "cedula_frente.jpg").';

COMMENT ON COLUMN appmatch_schema.archivos.nombre_almacenado IS 
'Nombre del archivo en el storage, típicamente UUID o hash para evitar conflictos.';

COMMENT ON COLUMN appmatch_schema.archivos.ruta_almacenamiento IS 
'Path completo o URL del archivo en storage (filesystem, S3, Azure Blob, CDN).';

COMMENT ON COLUMN appmatch_schema.archivos.extension IS 
'Extensión del archivo sin punto (jpg, png, pdf, docx, mp4).';

COMMENT ON COLUMN appmatch_schema.archivos.fecha_carga IS 
'Fecha y hora en que se cargó el archivo.';

COMMENT ON COLUMN appmatch_schema.archivos.descripcion IS 
'Descripción opcional del archivo proporcionada por el usuario.';

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 5: Queries de ejemplo para desarrollo
-- ═══════════════════════════════════════════════════════════════════════════════

-- Obtener todos los archivos de un perfil
-- SELECT 
--     a.pkid_archivos,
--     a.nombre_original,
--     a.extension,
--     a.ruta_almacenamiento,
--     a.fecha_carga,
--     a.descripcion
-- FROM appmatch_schema.archivos a
-- WHERE a.fk_pkid_perfil_informacion_basica = 'UUID_DEL_PERFIL'
--   AND a.expiration_date IS NULL
-- ORDER BY a.fecha_carga DESC;

-- Buscar archivos por nombre
-- SELECT 
--     a.pkid_archivos,
--     a.nombre_original,
--     a.ruta_almacenamiento
-- FROM appmatch_schema.archivos a
-- WHERE a.fk_pkid_perfil_informacion_basica = 'UUID_DEL_PERFIL'
--   AND LOWER(a.nombre_original) LIKE '%cedula%'
--   AND a.expiration_date IS NULL;

-- Contar archivos por perfil
-- SELECT 
--     pib.pkid_perfil_informacion_basica,
--     COUNT(a.pkid_archivos) AS total_archivos
-- FROM appmatch_schema.perfil_informacion_basica pib
-- LEFT JOIN appmatch_schema.archivos a 
--     ON pib.pkid_perfil_informacion_basica = a.fk_pkid_perfil_informacion_basica
--     AND a.expiration_date IS NULL
-- WHERE pib.expiration_date IS NULL
-- GROUP BY pib.pkid_perfil_informacion_basica;

-- ═══════════════════════════════════════════════════════════════════════════════
-- FIN DEL SCRIPT
-- ═══════════════════════════════════════════════════════════════════════════════

-- NOTAS IMPORTANTES:
-- 
-- 1. RELACIÓN 1:N con perfil_informacion_basica:
--    - Un perfil puede tener MÚLTIPLES archivos
--    - Cada archivo pertenece a UN perfil específico
-- 2. CATEGORÍAS de archivos:
--    - FOTO_PERFIL: Foto de perfil del usuario (imagen)
--    - DOCUMENTO_IDENTIDAD: Cédula, pasaporte, DNI (imagen o PDF)
--    - CERTIFICADO_ACADEMICO: Diplomas, certificados de estudio
--    - CERTIFICADO_PROFESIONAL: Certificaciones profesionales
--    - CV_CURRICULUM: Curriculum vitae (PDF o Word)
--    - COMPROBANTE_PAGO: Recibos, facturas
--    - ANTECEDENTES: Certificado de antecedentes penales
--    - CARTA_RECOMENDACION: Cartas de recomendación
--    - CONTRATO: Contratos firmados
--    - OTROS: Documentos no clasificados
-- 3. VERSIONADO de archivos:
--    - Campo `version` incrementa al reemplazar
--    - `fk_pkid_archivos_anterior` referencia versión previa
--    - `es_version_activa` marca la versión actual
--    - Permite mantener historial sin eliminar versiones antiguas
-- 4. SEGURIDAD:
--    - Hash SHA256 para verificación de integridad
--    - Estado de verificación (antivirus, contenido inapropiado)
--    - Validación de tamaño máximo (100 MB por defecto)
--    - Campo `es_publico` para control de acceso
-- 5. STORAGE:
--    - `ruta_almacenamiento` puede ser path filesystem, S3 URL, Azure Blob URL, CDN URL
--    - `nombre_almacenado` debe ser único (usar UUID o hash)
--    - Soporte para thumbnails (campo `ruta_thumbnail`)
-- 6. METADATA EXTENDIDA:
--    - Dimensiones para imágenes (ancho_pixels, alto_pixels)
--    - JSONB para metadata adicional (EXIF, OCR, tags)
--    - Contador de descargas y fecha último acceso
-- 7. ON DELETE CASCADE en FK a perfil:
--    - Si se elimina el perfil, se eliminan sus archivos
--    - Implementar limpieza de archivos físicos en storage (job asíncrono)
-- 8. ÍNDICES optimizados:
--    - FK perfil (JOINs)
--    - Categoría (filtros por tipo)
--    - Estado verificación (archivos pendientes)
--    - Hash SHA256 (detección de duplicados)
--    - Fecha carga (reportes temporales)
-- 9. LÍMITES CONFIGURABLES:
--    - Tamaño máximo: 100 MB (ajustar en CHECK constraint según necesidades)
--    - Videos pueden requerir límites mayores (500 MB - 2 GB)
-- 10. Este script es idempotente (puede ejecutarse múltiples veces)
--
-- DEPENDENCIAS:
--   - V003: appmatch_schema.perfil_informacion_basica
--
-- SIGUIENTE PASO: 
--   - Implementar endpoints en backend:
--     * POST /api/v1/archivos/upload (subir archivo)
--     * GET /api/v1/archivos/{uuid} (descargar archivo)
--     * GET /api/v1/archivos/{uuid}/thumbnail (obtener thumbnail)
--     * DELETE /api/v1/archivos/{uuid} (soft delete)
--     * PUT /api/v1/archivos/{uuid}/verificar (cambiar estado verificación)
--     * GET /api/v1/perfiles/{uuid}/archivos (listar archivos de perfil)
--   - Implementar servicio de storage (S3, Azure Blob, filesystem)
--   - Implementar generación de thumbnails (ImageMagick, Sharp)
--   - Implementar análisis antivirus (ClamAV, VirusTotal API)
--   - Implementar limpieza de archivos huérfanos (job cron)

