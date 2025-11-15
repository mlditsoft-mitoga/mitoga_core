-- ============================================================================
-- Gestión de Imágenes y Archivos: Mejores Prácticas para MI-TOGA
-- Descripción: Implementación de hybrid approach para manejo de imágenes
--              Metadata en PostgreSQL + Storage externo (S3/Cloudinary/Local)
-- Autor: Database Engineer Senior - ZNS-METHOD
-- Fecha: 2025-11-14
-- ============================================================================

-- ====================
-- MEJORES PRÁCTICAS PARA MANEJO DE IMÁGENES
-- ====================

/*
❌ MAL: Almacenar imágenes directamente en PostgreSQL como BYTEA
✅ BIEN: Metadata en DB + archivos en storage externo

VENTAJAS DEL HYBRID APPROACH:
- Performance: Consultas rápidas (solo metadata)
- Escalabilidad: Storage independiente de DB
- Backup: Backups más pequeños y rápidos
- CDN: Distribución global de imágenes
- Caching: HTTP caching nativo
- Costos: Storage objeto es más económico
*/

-- ====================
-- CONFIGURACIÓN INICIAL
-- ====================

-- Crear directorio para configuración de storage
CREATE SCHEMA IF NOT EXISTS storage_schema;

-- Tabla: Configuración de Storage Providers
CREATE TABLE storage_schema.storage_providers (
    pkid_storage_providers UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- Identificación del provider
    provider_name VARCHAR(50) NOT NULL UNIQUE,
    provider_type VARCHAR(20) NOT NULL, -- AWS_S3, CLOUDINARY, AZURE_BLOB, LOCAL
    
    -- Configuración (sin credenciales sensibles)
    config JSONB NOT NULL,
    
    -- Estado
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    es_principal BOOLEAN NOT NULL DEFAULT FALSE,
    
    -- Limits
    tamaño_maximo_mb INTEGER DEFAULT 50,
    tipos_permitidos TEXT[] DEFAULT ARRAY['image/jpeg', 'image/png', 'image/webp'],
    
    CONSTRAINT pk_storage_providers PRIMARY KEY (pkid_storage_providers),
    CONSTRAINT ck_provider_type CHECK (provider_type IN ('AWS_S3', 'CLOUDINARY', 'AZURE_BLOB', 'LOCAL', 'GCP_STORAGE')),
    CONSTRAINT ck_tamaño_maximo CHECK (tamaño_maximo_mb > 0 AND tamaño_maximo_mb <= 100)
);

-- Índices
CREATE INDEX idx_storage_providers_activo ON storage_schema.storage_providers(activo) WHERE activo = TRUE;
CREATE UNIQUE INDEX idx_storage_providers_principal ON storage_schema.storage_providers(es_principal) 
    WHERE es_principal = TRUE AND expiration_date IS NULL;

-- Datos iniciales de storage providers
INSERT INTO storage_schema.storage_providers (provider_name, provider_type, config, es_principal, tamaño_maximo_mb) VALUES
('local_development', 'LOCAL', '{"base_path": "/var/www/mitoga/uploads", "base_url": "http://localhost:3000/uploads"}', TRUE, 50),
('cloudinary_main', 'CLOUDINARY', '{"cloud_name": "mitoga", "upload_preset": "ml_default", "secure": true}', FALSE, 50),
('aws_s3_production', 'AWS_S3', '{"bucket": "mitoga-uploads", "region": "us-east-1", "cloudfront_domain": "cdn.mitoga.com"}', FALSE, 100);

-- ====================
-- FUNCIONES PARA GESTIÓN DE IMÁGENES
-- ====================

-- Function: Obtener storage provider activo
CREATE OR REPLACE FUNCTION storage_schema.get_active_provider()
RETURNS RECORD AS $$
DECLARE
    provider_record RECORD;
BEGIN
    -- Buscar provider principal activo
    SELECT * FROM storage_schema.storage_providers 
    WHERE es_principal = TRUE AND activo = TRUE AND expiration_date IS NULL
    INTO provider_record;
    
    -- Si no hay principal, buscar cualquier activo
    IF NOT FOUND THEN
        SELECT * FROM storage_schema.storage_providers 
        WHERE activo = TRUE AND expiration_date IS NULL
        ORDER BY creation_date ASC
        LIMIT 1
        INTO provider_record;
    END IF;
    
    RETURN provider_record;
END;
$$ LANGUAGE plpgsql;

-- Function: Generar path de almacenamiento
CREATE OR REPLACE FUNCTION storage_schema.generar_path_storage(
    p_tipo_archivo shared_schema.tipo_archivo,
    p_usuario_id UUID DEFAULT NULL,
    p_extension VARCHAR(10) DEFAULT '.jpg'
)
RETURNS TEXT AS $$
DECLARE
    v_fecha DATE := CURRENT_DATE;
    v_uuid TEXT := gen_random_uuid()::TEXT;
    v_path TEXT;
    v_folder TEXT;
BEGIN
    -- Determinar carpeta según tipo de archivo
    CASE p_tipo_archivo
        WHEN 'FOTO_PERFIL' THEN v_folder := 'perfiles';
        WHEN 'DOCUMENTO_FRONTAL', 'DOCUMENTO_TRASERO' THEN v_folder := 'documentos';
        WHEN 'SELFIE_VERIFICACION' THEN v_folder := 'verificacion';
        WHEN 'DOCUMENTO_RESPONSABLE_FRONTAL', 'DOCUMENTO_RESPONSABLE_TRASERO' THEN v_folder := 'responsables';
        ELSE v_folder := 'otros';
    END CASE;
    
    -- Construir path: /uploads/{folder}/{año}/{mes}/{día}/{uuid}{extension}
    v_path := FORMAT('/uploads/%s/%s/%s/%s/%s%s',
        v_folder,
        EXTRACT(YEAR FROM v_fecha),
        LPAD(EXTRACT(MONTH FROM v_fecha)::TEXT, 2, '0'),
        LPAD(EXTRACT(DAY FROM v_fecha)::TEXT, 2, '0'),
        v_uuid,
        p_extension
    );
    
    RETURN v_path;
END;
$$ LANGUAGE plpgsql;

-- Function: Validar imagen antes de guardar
CREATE OR REPLACE FUNCTION shared_schema.validar_imagen(
    p_mime_type VARCHAR(100),
    p_tamaño_bytes BIGINT,
    p_ancho_px INTEGER DEFAULT NULL,
    p_alto_px INTEGER DEFAULT NULL
)
RETURNS TABLE (
    es_valido BOOLEAN,
    mensaje_error TEXT
) AS $$
BEGIN
    -- Validar MIME type
    IF p_mime_type NOT IN ('image/jpeg', 'image/jpg', 'image/png', 'image/webp') THEN
        RETURN QUERY SELECT FALSE, 'Tipo de archivo no permitido. Use JPEG, PNG o WEBP';
        RETURN;
    END IF;
    
    -- Validar tamaño (máximo 50MB)
    IF p_tamaño_bytes > 52428800 THEN
        RETURN QUERY SELECT FALSE, 'Archivo demasiado grande. Máximo 50MB permitido';
        RETURN;
    END IF;
    
    -- Validar tamaño mínimo (1KB)
    IF p_tamaño_bytes < 1024 THEN
        RETURN QUERY SELECT FALSE, 'Archivo demasiado pequeño. Mínimo 1KB requerido';
        RETURN;
    END IF;
    
    -- Validar dimensiones si se proporcionan
    IF p_ancho_px IS NOT NULL AND p_alto_px IS NOT NULL THEN
        -- Mínimo 100x100 para fotos de perfil
        IF p_ancho_px < 100 OR p_alto_px < 100 THEN
            RETURN QUERY SELECT FALSE, 'Dimensiones muy pequeñas. Mínimo 100x100 píxeles';
            RETURN;
        END IF;
        
        -- Máximo 4K (4096x4096)
        IF p_ancho_px > 4096 OR p_alto_px > 4096 THEN
            RETURN QUERY SELECT FALSE, 'Dimensiones muy grandes. Máximo 4096x4096 píxeles';
            RETURN;
        END IF;
        
        -- Aspect ratio razonable (no muy alargado)
        IF (p_ancho_px::DECIMAL / p_alto_px) > 5 OR (p_alto_px::DECIMAL / p_ancho_px) > 5 THEN
            RETURN QUERY SELECT FALSE, 'Proporción de imagen inválida (muy alargada)';
            RETURN;
        END IF;
    END IF;
    
    RETURN QUERY SELECT TRUE, 'Imagen válida';
END;
$$ LANGUAGE plpgsql;

-- Function: Procesar imagen después de upload
CREATE OR REPLACE FUNCTION shared_schema.procesar_imagen_post_upload(
    p_archivo_id UUID
)
RETURNS TABLE (
    success BOOLEAN,
    mensaje TEXT,
    url_optimizada TEXT
) AS $$
DECLARE
    v_archivo RECORD;
    v_path_optimized TEXT;
BEGIN
    -- Obtener información del archivo
    SELECT * FROM shared_schema.archivos WHERE pkid_archivos = p_archivo_id INTO v_archivo;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT FALSE, 'Archivo no encontrado', NULL::TEXT;
        RETURN;
    END IF;
    
    -- Marcar como procesado (el procesamiento real se haría en background)
    UPDATE shared_schema.archivos 
    SET 
        procesado = TRUE,
        metadata = metadata || jsonb_build_object(
            'procesado_en', NOW(),
            'optimizaciones', ARRAY['resize', 'compress', 'webp_conversion']
        )
    WHERE pkid_archivos = p_archivo_id;
    
    -- Generar URL optimizada (simulado)
    v_path_optimized := REPLACE(v_archivo.storage_url, '.jpg', '_opt.webp');
    
    RETURN QUERY SELECT TRUE, 'Imagen procesada exitosamente', v_path_optimized;
END;
$$ LANGUAGE plpgsql;

-- ====================
-- FUNCIONES ESPECIALIZADAS POR TIPO DE IMAGEN
-- ====================

-- Function: Guardar foto de perfil (con validaciones específicas)
CREATE OR REPLACE FUNCTION shared_schema.guardar_foto_perfil(
    p_usuario_id UUID,
    p_nombre_original VARCHAR(255),
    p_mime_type VARCHAR(100),
    p_tamaño_bytes BIGINT,
    p_ancho_px INTEGER,
    p_alto_px INTEGER,
    p_base64_data TEXT DEFAULT NULL -- Para preview rápido
)
RETURNS TABLE (
    archivo_id UUID,
    storage_path TEXT,
    storage_url TEXT,
    success BOOLEAN,
    mensaje TEXT
) AS $$
DECLARE
    v_archivo_id UUID;
    v_storage_path TEXT;
    v_storage_url TEXT;
    v_provider RECORD;
    v_extension VARCHAR(10);
    v_validacion RECORD;
    v_hash_md5 TEXT;
BEGIN
    -- Validar imagen
    SELECT * FROM shared_schema.validar_imagen(p_mime_type, p_tamaño_bytes, p_ancho_px, p_alto_px) INTO v_validacion;
    
    IF NOT v_validacion.es_valido THEN
        RETURN QUERY SELECT NULL::UUID, NULL::TEXT, NULL::TEXT, FALSE, v_validacion.mensaje_error;
        RETURN;
    END IF;
    
    -- Validaciones específicas para foto de perfil
    IF p_ancho_px < 200 OR p_alto_px < 200 THEN
        RETURN QUERY SELECT NULL::UUID, NULL::TEXT, NULL::TEXT, FALSE, 'Foto de perfil debe ser mínimo 200x200 píxeles';
        RETURN;
    END IF;
    
    -- Determinar extensión
    CASE p_mime_type
        WHEN 'image/jpeg', 'image/jpg' THEN v_extension := '.jpg';
        WHEN 'image/png' THEN v_extension := '.png';
        WHEN 'image/webp' THEN v_extension := '.webp';
        ELSE v_extension := '.jpg';
    END CASE;
    
    -- Obtener provider de storage
    SELECT * FROM storage_schema.get_active_provider() INTO v_provider;
    
    -- Generar path
    v_storage_path := storage_schema.generar_path_storage('FOTO_PERFIL', p_usuario_id, v_extension);
    
    -- Construir URL completa
    IF v_provider.provider_type = 'LOCAL' THEN
        v_storage_url := (v_provider.config->>'base_url') || v_storage_path;
    ELSIF v_provider.provider_type = 'CLOUDINARY' THEN
        v_storage_url := FORMAT('https://res.cloudinary.com/%s/image/upload%s', 
            v_provider.config->>'cloud_name', v_storage_path);
    ELSIF v_provider.provider_type = 'AWS_S3' THEN
        v_storage_url := FORMAT('https://%s.s3.amazonaws.com%s', 
            v_provider.config->>'bucket', v_storage_path);
    END IF;
    
    -- Generar hash MD5 para el preview base64 (si se proporciona)
    IF p_base64_data IS NOT NULL THEN
        v_hash_md5 := md5(p_base64_data);
    END IF;
    
    -- Insertar archivo
    INSERT INTO shared_schema.archivos (
        nombre_original,
        nombre_archivo,
        tipo_archivo,
        mime_type,
        tamaño_bytes,
        storage_provider,
        storage_path,
        storage_url,
        ancho_px,
        alto_px,
        hash_md5,
        metadata
    ) VALUES (
        p_nombre_original,
        REPLACE(v_storage_path, '/uploads/', ''),
        'FOTO_PERFIL',
        p_mime_type,
        p_tamaño_bytes,
        v_provider.provider_name,
        v_storage_path,
        v_storage_url,
        p_ancho_px,
        p_alto_px,
        v_hash_md5,
        jsonb_build_object(
            'usuario_id', p_usuario_id,
            'es_foto_perfil', TRUE,
            'preview_base64', CASE WHEN p_base64_data IS NOT NULL THEN LEFT(p_base64_data, 500) ELSE NULL END,
            'upload_timestamp', NOW()
        )
    ) RETURNING pkid_archivos INTO v_archivo_id;
    
    RETURN QUERY SELECT v_archivo_id, v_storage_path, v_storage_url, TRUE, 'Foto de perfil guardada exitosamente';
END;
$$ LANGUAGE plpgsql;

-- Function: Guardar documento de identidad
CREATE OR REPLACE FUNCTION shared_schema.guardar_documento_identidad(
    p_usuario_id UUID,
    p_tipo_archivo shared_schema.tipo_archivo,
    p_nombre_original VARCHAR(255),
    p_mime_type VARCHAR(100),
    p_tamaño_bytes BIGINT,
    p_ancho_px INTEGER DEFAULT NULL,
    p_alto_px INTEGER DEFAULT NULL,
    p_ocr_data JSONB DEFAULT NULL
)
RETURNS TABLE (
    archivo_id UUID,
    storage_path TEXT,
    success BOOLEAN,
    mensaje TEXT
) AS $$
DECLARE
    v_archivo_id UUID;
    v_storage_path TEXT;
    v_storage_url TEXT;
    v_provider RECORD;
    v_extension VARCHAR(10);
    v_validacion RECORD;
BEGIN
    -- Validar que es tipo de documento
    IF p_tipo_archivo NOT IN ('DOCUMENTO_FRONTAL', 'DOCUMENTO_TRASERO', 'DOCUMENTO_RESPONSABLE_FRONTAL', 'DOCUMENTO_RESPONSABLE_TRASERO') THEN
        RETURN QUERY SELECT NULL::UUID, NULL::TEXT, FALSE, 'Tipo de archivo inválido para documento';
        RETURN;
    END IF;
    
    -- Validar imagen
    SELECT * FROM shared_schema.validar_imagen(p_mime_type, p_tamaño_bytes, p_ancho_px, p_alto_px) INTO v_validacion;
    
    IF NOT v_validacion.es_valido THEN
        RETURN QUERY SELECT NULL::UUID, NULL::TEXT, FALSE, v_validacion.mensaje_error;
        RETURN;
    END IF;
    
    -- Determinar extensión
    CASE p_mime_type
        WHEN 'image/jpeg', 'image/jpg' THEN v_extension := '.jpg';
        WHEN 'image/png' THEN v_extension := '.png';
        WHEN 'image/webp' THEN v_extension := '.webp';
        ELSE v_extension := '.jpg';
    END CASE;
    
    -- Obtener provider de storage
    SELECT * FROM storage_schema.get_active_provider() INTO v_provider;
    
    -- Generar path
    v_storage_path := storage_schema.generar_path_storage(p_tipo_archivo, p_usuario_id, v_extension);
    
    -- Construir URL
    IF v_provider.provider_type = 'LOCAL' THEN
        v_storage_url := (v_provider.config->>'base_url') || v_storage_path;
    END IF;
    
    -- Insertar archivo
    INSERT INTO shared_schema.archivos (
        nombre_original,
        nombre_archivo,
        tipo_archivo,
        mime_type,
        tamaño_bytes,
        storage_provider,
        storage_path,
        storage_url,
        ancho_px,
        alto_px,
        metadata
    ) VALUES (
        p_nombre_original,
        REPLACE(v_storage_path, '/uploads/', ''),
        p_tipo_archivo,
        p_mime_type,
        p_tamaño_bytes,
        v_provider.provider_name,
        v_storage_path,
        v_storage_url,
        p_ancho_px,
        p_alto_px,
        jsonb_build_object(
            'usuario_id', p_usuario_id,
            'es_documento', TRUE,
            'ocr_data', COALESCE(p_ocr_data, '{}'::JSONB),
            'upload_timestamp', NOW(),
            'security_level', 'HIGH'
        )
    ) RETURNING pkid_archivos INTO v_archivo_id;
    
    RETURN QUERY SELECT v_archivo_id, v_storage_path, TRUE, 'Documento guardado exitosamente';
END;
$$ LANGUAGE plpgsql;

-- ====================
-- VISTAS PARA FACILITAR CONSULTAS
-- ====================

-- Vista: Archivos con información del usuario
CREATE OR REPLACE VIEW shared_schema.v_archivos_usuarios AS
SELECT 
    a.pkid_archivos,
    a.nombre_original,
    a.tipo_archivo,
    a.tamaño_bytes,
    a.storage_url,
    a.ancho_px,
    a.alto_px,
    a.procesado,
    a.creation_date,
    
    -- Info del usuario
    u.email,
    pe.nombre_completo,
    pe.es_menor_edad,
    
    -- Stats
    ROUND(a.tamaño_bytes / 1024.0 / 1024.0, 2) AS tamaño_mb,
    CASE 
        WHEN a.ancho_px IS NOT NULL THEN FORMAT('%sx%s', a.ancho_px, a.alto_px)
        ELSE 'N/A'
    END AS dimensiones
FROM shared_schema.archivos a
LEFT JOIN autenticacion_schema.usuarios u ON (a.metadata->>'usuario_id')::UUID = u.pkid_usuarios
LEFT JOIN perfiles_schema.perfiles_estudiante pe ON u.pkid_usuarios = pe.usuario_id
WHERE a.expiration_date IS NULL;

-- Vista: Estadísticas de archivos por tipo
CREATE OR REPLACE VIEW shared_schema.v_stats_archivos AS
SELECT 
    tipo_archivo,
    COUNT(*) AS total_archivos,
    ROUND(AVG(tamaño_bytes / 1024.0 / 1024.0), 2) AS tamaño_promedio_mb,
    ROUND(SUM(tamaño_bytes / 1024.0 / 1024.0), 2) AS tamaño_total_mb,
    COUNT(*) FILTER (WHERE procesado = TRUE) AS procesados,
    COUNT(*) FILTER (WHERE procesado = FALSE) AS pendientes_proceso
FROM shared_schema.archivos
WHERE expiration_date IS NULL
GROUP BY tipo_archivo
ORDER BY total_archivos DESC;

-- ====================
-- TRIGGERS PARA AUDITORÍA DE IMÁGENES
-- ====================

-- Trigger: Log cuando se suba una imagen sensible
CREATE OR REPLACE FUNCTION shared_schema.log_imagen_sensible()
RETURNS TRIGGER AS $$
BEGIN
    -- Solo para documentos de identidad y selfies de verificación
    IF NEW.tipo_archivo IN ('DOCUMENTO_FRONTAL', 'DOCUMENTO_TRASERO', 'SELFIE_VERIFICACION', 
                           'DOCUMENTO_RESPONSABLE_FRONTAL', 'DOCUMENTO_RESPONSABLE_TRASERO') THEN
        
        INSERT INTO shared_schema.audit_log (
            schema_name,
            table_name,
            operation,
            record_id,
            new_data,
            ip_address
        ) VALUES (
            'shared_schema',
            'archivos',
            TG_OP,
            NEW.pkid_archivos,
            jsonb_build_object(
                'tipo_archivo', NEW.tipo_archivo,
                'usuario_id', NEW.metadata->>'usuario_id',
                'tamaño_bytes', NEW.tamaño_bytes,
                'timestamp', NOW(),
                'security_alert', 'IMAGEN_SENSIBLE_UPLOADED'
            ),
            '127.0.0.1'::INET
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_archivos_imagen_sensible
    AFTER INSERT ON shared_schema.archivos
    FOR EACH ROW
    EXECUTE FUNCTION shared_schema.log_imagen_sensible();

-- ====================
-- SCRIPTS DE EJEMPLO PARA DBEAVER
-- ====================

-- Ejemplo 1: Subir foto de perfil
DO $$
DECLARE
    resultado RECORD;
BEGIN
    SELECT * FROM shared_schema.guardar_foto_perfil(
        'f47ac10b-58cc-4372-a567-0e02b2c3d479'::UUID, -- usuario_id
        'mi_foto.jpg',
        'image/jpeg',
        1048576, -- 1MB
        800,     -- ancho
        600,     -- alto
        'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD...' -- preview base64 (truncado)
    ) INTO resultado;
    
    IF resultado.success THEN
        RAISE NOTICE 'Foto guardada: ID=%, URL=%', resultado.archivo_id, resultado.storage_url;
    ELSE
        RAISE NOTICE 'Error: %', resultado.mensaje;
    END IF;
END $$;

-- Ejemplo 2: Subir documento de identidad
DO $$
DECLARE
    resultado RECORD;
BEGIN
    SELECT * FROM shared_schema.guardar_documento_identidad(
        'f47ac10b-58cc-4372-a567-0e02b2c3d479'::UUID,
        'DOCUMENTO_FRONTAL',
        'cedula_frontal.jpg',
        'image/jpeg',
        2097152, -- 2MB
        1200,    -- ancho
        800,     -- alto
        '{"nombres": "JUAN CARLOS", "numero": "1234567890"}'::JSONB
    ) INTO resultado;
    
    IF resultado.success THEN
        RAISE NOTICE 'Documento guardado: ID=%, Path=%', resultado.archivo_id, resultado.storage_path;
    ELSE
        RAISE NOTICE 'Error: %', resultado.mensaje;
    END IF;
END $$;

-- Consultas útiles para DBeaver
-- ========================================

-- 1. Ver archivos recientes con info del usuario
SELECT * FROM shared_schema.v_archivos_usuarios 
ORDER BY creation_date DESC 
LIMIT 10;

-- 2. Estadísticas de archivos por tipo
SELECT * FROM shared_schema.v_stats_archivos;

-- 3. Documentos pendientes de verificación
SELECT 
    a.nombre_original,
    a.tipo_archivo,
    u.email,
    pe.nombre_completo,
    a.creation_date,
    vi.estado AS verificacion_estado
FROM shared_schema.archivos a
JOIN autenticacion_schema.usuarios u ON (a.metadata->>'usuario_id')::UUID = u.pkid_usuarios
JOIN perfiles_schema.perfiles_estudiante pe ON u.pkid_usuarios = pe.usuario_id
LEFT JOIN autenticacion_schema.verificacion_identidad vi ON u.pkid_usuarios = vi.usuario_id
WHERE a.tipo_archivo IN ('DOCUMENTO_FRONTAL', 'DOCUMENTO_TRASERO')
AND (vi.estado IS NULL OR vi.estado = 'PENDIENTE')
ORDER BY a.creation_date DESC;

-- 4. Limpiar archivos huérfanos (sin usuario asociado)
-- ¡CUIDADO! Solo ejecutar en desarrollo
/*
UPDATE shared_schema.archivos 
SET expiration_date = NOW()
WHERE (metadata->>'usuario_id') IS NULL 
AND creation_date < NOW() - INTERVAL '7 days';
*/

-- 5. Storage usage por provider
SELECT 
    storage_provider,
    COUNT(*) AS total_files,
    ROUND(SUM(tamaño_bytes) / 1024.0 / 1024.0 / 1024.0, 2) AS storage_used_gb
FROM shared_schema.archivos
WHERE expiration_date IS NULL
GROUP BY storage_provider;

COMMENT ON SCHEMA storage_schema IS 'Schema para configuración de storage providers y gestión de archivos';
COMMENT ON TABLE storage_schema.storage_providers IS 'Configuración de providers de almacenamiento (S3, Cloudinary, etc)';
COMMENT ON VIEW shared_schema.v_archivos_usuarios IS 'Vista con archivos y datos del usuario asociado';
COMMENT ON FUNCTION shared_schema.guardar_foto_perfil IS 'Función especializada para guardar fotos de perfil con validaciones específicas';
COMMENT ON FUNCTION shared_schema.guardar_documento_identidad IS 'Función para guardar documentos de identidad con seguridad alta';