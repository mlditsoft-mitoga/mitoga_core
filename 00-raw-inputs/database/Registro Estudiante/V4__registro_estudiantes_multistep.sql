-- ============================================================================
-- Migration: V4__registro_estudiantes_multistep.sql
-- Description: Modelo de datos completo para HU-001: Registro de Estudiante Multi-Step
--              Incluye manejo de imágenes, documentos, verificación biométrica
--              y soporte para menores de 18 años con responsable legal
-- Author: Database Engineer Senior - ZNS-METHOD
-- Date: 2025-11-14
-- Story: HU-001-registro-estudiante-multi-step
-- PostgreSQL Version: 16.x
-- 
-- ⚠️  MIGRACIÓN IDEMPOTENTE: 
--     Este script puede ejecutarse múltiples veces sin errores.
--     Usa DROP IF EXISTS + CREATE para todos los tipos ENUM.
--     Usa CREATE TABLE IF NOT EXISTS para las tablas.
-- ============================================================================

-- ====================
-- EXTENSIONES ADICIONALES
-- ====================

-- Para validaciones avanzadas de formatos de archivos
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ====================
-- SCHEMAS (SI NO EXISTEN DE V1-V3)
-- ====================

-- Verificar que los schemas existen (deberían estar creados por V1-V3)
CREATE SCHEMA IF NOT EXISTS autenticacion_schema;
CREATE SCHEMA IF NOT EXISTS perfiles_schema;
CREATE SCHEMA IF NOT EXISTS shared_schema;

-- ====================
-- ENUM TYPES (Reutilizables)
-- ====================

-- Estados del proceso de registro
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'estado_registro' AND typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'shared_schema')) THEN
        CREATE TYPE shared_schema.estado_registro AS ENUM (
            'STEP_1_CREDENCIALES',
            'STEP_2_DATOS_PERSONALES', 
            'STEP_3_VERIFICACION_BIOMETRICA',
            'STEP_4_CONFIRMACION',
            'COMPLETADO',
            'ABANDONADO',
            'RECHAZADO'
        );
    END IF;
END
$$;

-- Tipos de documentos de identidad
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'tipo_documento' AND typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'shared_schema')) THEN
        CREATE TYPE shared_schema.tipo_documento AS ENUM (
            'CEDULA_CIUDADANIA',
            'CEDULA_EXTRANJERIA', 
            'TARJETA_IDENTIDAD',
            'PASAPORTE',
            'REGISTRO_CIVIL'
        );
    END IF;
END
$$;

-- Tipos de archivo/imagen
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'tipo_archivo' AND typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'shared_schema')) THEN
        CREATE TYPE shared_schema.tipo_archivo AS ENUM (
            'FOTO_PERFIL',
            'DOCUMENTO_FRONTAL',
            'DOCUMENTO_TRASERO',
            'SELFIE_VERIFICACION',
            'DOCUMENTO_RESPONSABLE_FRONTAL',
            'DOCUMENTO_RESPONSABLE_TRASERO'
        );
    END IF;
END
$$;

-- Estados de verificación
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'estado_verificacion' AND typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'shared_schema')) THEN
        CREATE TYPE shared_schema.estado_verificacion AS ENUM (
            'PENDIENTE',
            'EN_REVISION',
            'APROBADO',
            'RECHAZADO',
            'REQUIERE_REVISION_MANUAL'
        );
    END IF;
END
$$;

COMMENT ON TYPE shared_schema.estado_registro IS 'Estados del proceso multi-step de registro';
COMMENT ON TYPE shared_schema.tipo_documento IS 'Tipos de documentos de identidad válidos en Colombia';
COMMENT ON TYPE shared_schema.tipo_archivo IS 'Tipos de archivos/imágenes en el proceso de verificación';
COMMENT ON TYPE shared_schema.estado_verificacion IS 'Estados de verificación biométrica/documental';

-- ====================
-- VERIFICACIÓN Y REPARACIÓN DE TABLAS
-- ====================

-- Function: Verificar si una tabla tiene una columna específica
CREATE OR REPLACE FUNCTION shared_schema.tabla_tiene_columna(
    p_schema_name TEXT, 
    p_table_name TEXT, 
    p_column_name TEXT
) RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = p_schema_name 
        AND table_name = p_table_name 
        AND column_name = p_column_name
    );
END;
$$ LANGUAGE plpgsql;

-- ====================
-- BC AUTENTICACIÓN: EXTENSIÓN PARA REGISTRO MULTI-STEP
-- ====================

-- Verificar y reparar tabla proceso_registro si fue dañada por CASCADE
DO $$
BEGIN
    -- Si la tabla existe pero le falta la columna estado_actual, eliminarla para recrearla
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'proceso_registro' AND table_schema = 'autenticacion_schema') THEN
        IF NOT shared_schema.tabla_tiene_columna('autenticacion_schema', 'proceso_registro', 'estado_actual') THEN
            RAISE NOTICE 'Tabla proceso_registro dañada por CASCADE - eliminando para recrear';
            DROP TABLE autenticacion_schema.proceso_registro CASCADE;
        END IF;
    END IF;
END
$$;

-- Tabla: Proceso de Registro (Session State para multi-step)
CREATE TABLE IF NOT EXISTS autenticacion_schema.proceso_registro (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR
    -- ========================================
    pkid_proceso_registro UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- RELACIONES
    -- ========================================
    usuario_id UUID, -- NULL hasta completar registro
    
    -- ========================================
    -- ESTADO DEL PROCESO
    -- ========================================
    estado_actual shared_schema.estado_registro NOT NULL DEFAULT 'STEP_1_CREDENCIALES',
    step_completado INTEGER NOT NULL DEFAULT 0,
    
    -- ========================================
    -- DATOS TEMPORALES (JSON por flexibilidad)
    -- ========================================
    datos_step_1 JSONB, -- email, password_hash, otp_code, otp_expiry
    datos_step_2 JSONB, -- información personal + responsable si menor
    datos_step_3 JSONB, -- referencias a archivos subidos
    datos_step_4 JSONB, -- confirmación y términos
    
    -- ========================================
    -- METADATA DE SESIÓN
    -- ========================================
    ip_address INET,
    user_agent TEXT,
    session_id VARCHAR(255),
    fecha_inicio TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    fecha_ultimo_paso TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    fecha_expiracion TIMESTAMPTZ NOT NULL DEFAULT (NOW() + INTERVAL '7 days'),
    
    -- ========================================
    -- FLAGS DE CONTROL
    -- ========================================
    es_menor_edad BOOLEAN NOT NULL DEFAULT FALSE,
    requiere_responsable BOOLEAN NOT NULL DEFAULT FALSE,
    otp_verificado BOOLEAN NOT NULL DEFAULT FALSE,
    terminos_aceptados BOOLEAN NOT NULL DEFAULT FALSE,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_proceso_registro PRIMARY KEY (pkid_proceso_registro),
    CONSTRAINT fk_proceso_registro_usuario FOREIGN KEY (usuario_id) 
        REFERENCES autenticacion_schema.usuarios(pkid_usuarios) 
        ON DELETE CASCADE,
    CONSTRAINT ck_proceso_registro_step CHECK (step_completado >= 0 AND step_completado <= 4),
    CONSTRAINT ck_proceso_registro_menor_responsable CHECK (
        NOT es_menor_edad OR (es_menor_edad AND requiere_responsable)
    )
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_proceso_registro_usuario ON autenticacion_schema.proceso_registro(usuario_id);
CREATE INDEX IF NOT EXISTS idx_proceso_registro_estado ON autenticacion_schema.proceso_registro(estado_actual);
CREATE INDEX IF NOT EXISTS idx_proceso_registro_session ON autenticacion_schema.proceso_registro(session_id);

-- Índices condicionales (solo si la tabla existe y tiene datos)
DO $$
BEGIN
    -- Solo crear índices condicionales si la tabla existe
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'proceso_registro' AND table_schema = 'autenticacion_schema') THEN
        CREATE INDEX IF NOT EXISTS idx_proceso_registro_expiracion ON autenticacion_schema.proceso_registro(fecha_expiracion) 
            WHERE estado_actual != 'COMPLETADO';
        CREATE INDEX IF NOT EXISTS idx_proceso_registro_pendientes ON autenticacion_schema.proceso_registro(fecha_ultimo_paso) 
            WHERE estado_actual NOT IN ('COMPLETADO', 'ABANDONADO', 'RECHAZADO');
    END IF;
END
$$;

-- Triggers (solo si las tablas existen)
DO $$
BEGIN
    -- Solo crear triggers si la tabla existe
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'proceso_registro' AND table_schema = 'autenticacion_schema') THEN
        DROP TRIGGER IF EXISTS trg_proceso_registro_audit ON autenticacion_schema.proceso_registro;
        CREATE TRIGGER trg_proceso_registro_audit
            AFTER INSERT OR UPDATE OR DELETE ON autenticacion_schema.proceso_registro
            FOR EACH ROW
            EXECUTE FUNCTION shared_schema.audit_trigger_func();
    END IF;
END
$$;

COMMENT ON TABLE autenticacion_schema.proceso_registro IS 'Aggregate: Estado del proceso multi-step de registro. Almacena progreso temporal hasta completar.';
COMMENT ON COLUMN autenticacion_schema.proceso_registro.datos_step_1 IS 'JSON: {email, password_hash, otp_code, otp_expiry, otp_attempts}';
COMMENT ON COLUMN autenticacion_schema.proceso_registro.datos_step_2 IS 'JSON: datos personales completos + datos responsable si es menor';
COMMENT ON COLUMN autenticacion_schema.proceso_registro.datos_step_3 IS 'JSON: referencias a archivos subidos (paths/URLs)';

-- ====================
-- BC PERFILES: DATOS COMPLETOS ESTUDIANTE
-- ====================

-- Verificar y reparar tabla perfiles_estudiante si fue dañada por CASCADE
DO $$
BEGIN
    -- Si la tabla existe pero le falta la columna genero_id o otras columnas críticas, eliminarla para recrearla
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'perfiles_estudiante' AND table_schema = 'perfiles_schema') THEN
        IF NOT shared_schema.tabla_tiene_columna('perfiles_schema', 'perfiles_estudiante', 'genero_id') OR
           NOT shared_schema.tabla_tiene_columna('perfiles_schema', 'perfiles_estudiante', 'pais_id') OR
           NOT shared_schema.tabla_tiene_columna('perfiles_schema', 'perfiles_estudiante', 'ciudad_id') OR
           NOT shared_schema.tabla_tiene_columna('perfiles_schema', 'perfiles_estudiante', 'nivel_educativo_id') THEN
            RAISE NOTICE 'Tabla perfiles_estudiante dañada por CASCADE - eliminando para recrear';
            DROP TABLE perfiles_schema.perfiles_estudiante CASCADE;
        END IF;
    END IF;
END
$$;

-- Tabla: Perfiles de Estudiante (Datos completos post-registro)
CREATE TABLE IF NOT EXISTS perfiles_schema.perfiles_estudiante (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR
    -- ========================================
    pkid_perfiles_estudiante UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- RELACIONES
    -- ========================================
    usuario_id UUID NOT NULL,
    pais_id UUID NOT NULL,
    idioma_preferido_id UUID NOT NULL,
    
    -- ========================================
    -- DATOS PERSONALES BÁSICOS
    -- ========================================
    primer_nombre VARCHAR(50) NOT NULL,
    segundo_nombre VARCHAR(50),
    primer_apellido VARCHAR(50) NOT NULL,
    segundo_apellido VARCHAR(50),
    nombre_completo VARCHAR(255) GENERATED ALWAYS AS (
        TRIM(primer_nombre || COALESCE(' ' || segundo_nombre, '') || ' ' || primer_apellido || COALESCE(' ' || segundo_apellido, ''))
    ) STORED,
    
    -- ========================================
    -- DATOS DEMOGRÁFICOS
    -- ========================================
    fecha_nacimiento DATE NOT NULL,
    -- ⚠️ NOTA: Removed GENERATED column for edad - Use function calcular_edad() for computed age
    -- edad se calcula dinámicamente via función para evitar ERROR: generation expression is not immutable
    genero_id UUID, -- FK a shared_schema.catalogo_recursivo (tipo: 'generos')
    
    -- ========================================
    -- CONTACTO
    -- ========================================
    telefono VARCHAR(20),
    telefono_verified BOOLEAN NOT NULL DEFAULT FALSE,
    ciudad_id UUID, -- FK a shared_schema.catalogo_recursivo (tipo: 'ciudades')
    direccion TEXT,
    
    -- ========================================
    -- PERFIL ACADÉMICO
    -- ========================================
    nivel_educativo_id UUID, -- FK a shared_schema.catalogo_recursivo (tipo: 'niveles_educativos')
    institucion_educativa VARCHAR(255),
    sobre_mi TEXT,
    
    -- ========================================
    -- RESPONSABLE LEGAL (Si es menor de 18)
    -- ========================================
    es_menor_edad BOOLEAN NOT NULL DEFAULT FALSE,
    responsable_nombre VARCHAR(255),
    responsable_apellido VARCHAR(255),
    responsable_email VARCHAR(255),
    responsable_telefono VARCHAR(20),
    responsable_relacion VARCHAR(50), -- padre, madre, tutor legal, etc.
    
    -- ========================================
    -- CONFIGURACIONES
    -- ========================================
    notificaciones_email BOOLEAN NOT NULL DEFAULT TRUE,
    notificaciones_sms BOOLEAN NOT NULL DEFAULT FALSE,
    notificaciones_push BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- ========================================
    -- METADATA
    -- ========================================
    metadata JSONB DEFAULT '{}'::JSONB,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_perfiles_estudiante PRIMARY KEY (pkid_perfiles_estudiante),
    CONSTRAINT fk_perfiles_estudiante_usuario FOREIGN KEY (usuario_id) 
        REFERENCES autenticacion_schema.usuarios(pkid_usuarios) 
        ON DELETE CASCADE,
    CONSTRAINT fk_perfiles_estudiante_pais FOREIGN KEY (pais_id) 
        REFERENCES shared_schema.catalogo_recursivo(pkid_catalogo_recursivo),
    CONSTRAINT fk_perfiles_estudiante_idioma FOREIGN KEY (idioma_preferido_id) 
        REFERENCES shared_schema.catalogo_recursivo(pkid_catalogo_recursivo),
    CONSTRAINT fk_perfiles_estudiante_genero FOREIGN KEY (genero_id) 
        REFERENCES shared_schema.catalogo_recursivo(pkid_catalogo_recursivo),
    CONSTRAINT fk_perfiles_estudiante_ciudad FOREIGN KEY (ciudad_id) 
        REFERENCES shared_schema.catalogo_recursivo(pkid_catalogo_recursivo),
    CONSTRAINT fk_perfiles_estudiante_nivel_educativo FOREIGN KEY (nivel_educativo_id) 
        REFERENCES shared_schema.catalogo_recursivo(pkid_catalogo_recursivo),
    CONSTRAINT uq_perfiles_estudiante_usuario UNIQUE (usuario_id),
    -- REMOVED: ck_perfiles_estudiante_genero (now FK to catalogo)
    -- REMOVED: ck_perfiles_estudiante_edad (edad column no longer exists)
    -- CHECK constraints para validación de lógica de negocio
    CONSTRAINT ck_perfiles_estudiante_menor_responsable CHECK (
        NOT es_menor_edad OR (
            es_menor_edad AND 
            responsable_nombre IS NOT NULL AND 
            responsable_email IS NOT NULL AND 
            responsable_telefono IS NOT NULL
        )
    ),
    CONSTRAINT ck_perfiles_estudiante_email_responsable CHECK (
        responsable_email IS NULL OR 
        responsable_email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'
    )
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_perfiles_estudiante_usuario ON perfiles_schema.perfiles_estudiante(usuario_id);
CREATE INDEX IF NOT EXISTS idx_perfiles_estudiante_pais ON perfiles_schema.perfiles_estudiante(pais_id);
CREATE INDEX IF NOT EXISTS idx_perfiles_estudiante_genero ON perfiles_schema.perfiles_estudiante(genero_id);
CREATE INDEX IF NOT EXISTS idx_perfiles_estudiante_ciudad ON perfiles_schema.perfiles_estudiante(ciudad_id);
CREATE INDEX IF NOT EXISTS idx_perfiles_estudiante_nivel_educativo ON perfiles_schema.perfiles_estudiante(nivel_educativo_id);
CREATE INDEX IF NOT EXISTS idx_perfiles_estudiante_fecha_nacimiento ON perfiles_schema.perfiles_estudiante(fecha_nacimiento);
CREATE INDEX IF NOT EXISTS idx_perfiles_estudiante_menor ON perfiles_schema.perfiles_estudiante(es_menor_edad) 
    WHERE es_menor_edad = TRUE;
CREATE INDEX IF NOT EXISTS idx_perfiles_estudiante_responsable_email ON perfiles_schema.perfiles_estudiante(responsable_email) 
    WHERE responsable_email IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_perfiles_estudiante_metadata ON perfiles_schema.perfiles_estudiante USING GIN(metadata);

-- Triggers (solo si las tablas existen)
DO $$
BEGIN
    -- Solo crear triggers si la tabla existe
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'perfiles_estudiante' AND table_schema = 'perfiles_schema') THEN
        DROP TRIGGER IF EXISTS trg_perfiles_estudiante_audit ON perfiles_schema.perfiles_estudiante;
        CREATE TRIGGER trg_perfiles_estudiante_audit
            AFTER INSERT OR UPDATE OR DELETE ON perfiles_schema.perfiles_estudiante
            FOR EACH ROW
            EXECUTE FUNCTION shared_schema.audit_trigger_func();
    END IF;
END
$$;

COMMENT ON TABLE perfiles_schema.perfiles_estudiante IS 'Aggregate: Perfil completo del estudiante con datos personales y responsable legal si es menor';

-- Comentarios para FK de catálogos
COMMENT ON COLUMN perfiles_schema.perfiles_estudiante.genero_id IS 'FK: shared_schema.catalogo_recursivo [catalogo_tipo=GENERO_SEXUAL] - Identidad de género del estudiante';
COMMENT ON COLUMN perfiles_schema.perfiles_estudiante.ciudad_id IS 'FK: shared_schema.catalogo_recursivo [catalogo_tipo=CIUDAD] - Ciudad de residencia del estudiante';  
COMMENT ON COLUMN perfiles_schema.perfiles_estudiante.nivel_educativo_id IS 'FK: shared_schema.catalogo_recursivo [catalogo_tipo=NIVEL_EDUCATIVO] - Nivel académico actual';
COMMENT ON COLUMN perfiles_schema.perfiles_estudiante.pais_id IS 'FK: shared_schema.catalogo_recursivo [catalogo_tipo=PAIS] - País de residencia';
COMMENT ON COLUMN perfiles_schema.perfiles_estudiante.idioma_preferido_id IS 'FK: shared_schema.catalogo_recursivo [catalogo_tipo=IDIOMA] - Idioma preferido para comunicación';
COMMENT ON COLUMN perfiles_schema.perfiles_estudiante.nombre_completo IS 'GENERATED COLUMN: Concatenación automática de nombres y apellidos';
COMMENT ON COLUMN perfiles_schema.perfiles_estudiante.es_menor_edad IS 'FLAG: TRUE si el estudiante es menor de 18 años - requiere responsable legal';
COMMENT ON COLUMN perfiles_schema.perfiles_estudiante.responsable_nombre IS 'REQUIRED if es_menor_edad=TRUE - Nombre completo del responsable legal';
COMMENT ON COLUMN perfiles_schema.perfiles_estudiante.responsable_relacion IS 'ENUM-like: padre, madre, tutor_legal, abuelo, abuela, tio, tia, hermano_mayor, guardian_legal';

-- ====================
-- SHARED: GESTIÓN DE ARCHIVOS/IMÁGENES
-- ====================

-- Verificar y reparar tabla archivos si fue dañada por CASCADE
DO $$
BEGIN
    -- Si la tabla existe pero le falta la columna tipo_archivo, eliminarla para recrearla
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'archivos' AND table_schema = 'shared_schema') THEN
        IF NOT shared_schema.tabla_tiene_columna('shared_schema', 'archivos', 'tipo_archivo') THEN
            RAISE NOTICE 'Tabla archivos dañada por CASCADE - eliminando para recrear';
            DROP TABLE shared_schema.archivos CASCADE;
        END IF;
    END IF;
END
$$;

-- Tabla: Archivos/Imágenes (Metadata + External Storage)
CREATE TABLE IF NOT EXISTS shared_schema.archivos (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR
    -- ========================================
    pkid_archivos UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- METADATA DEL ARCHIVO
    -- ========================================
    nombre_original VARCHAR(255) NOT NULL,
    nombre_archivo VARCHAR(255) NOT NULL, -- UUID + extensión
    tipo_archivo shared_schema.tipo_archivo NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    tamaño_bytes BIGINT NOT NULL,
    
    -- ========================================
    -- STORAGE INFORMATION
    -- ========================================
    storage_provider VARCHAR(50) NOT NULL DEFAULT 'LOCAL', -- LOCAL, AWS_S3, CLOUDINARY, AZURE
    storage_path TEXT NOT NULL, -- path completo en el storage
    storage_url TEXT, -- URL pública si disponible
    storage_bucket VARCHAR(255), -- bucket/container name si aplica
    
    -- ========================================
    -- METADATA IMAGEN (Si es imagen)
    -- ========================================
    ancho_px INTEGER,
    alto_px INTEGER,
    formato VARCHAR(10), -- JPG, PNG, WEBP, etc.
    calidad INTEGER, -- 1-100 para JPEG
    
    -- ========================================
    -- VERIFICACIÓN Y SEGURIDAD
    -- ========================================
    hash_md5 VARCHAR(32), -- Para detectar duplicados
    hash_sha256 VARCHAR(64), -- Para verificar integridad
    procesado BOOLEAN NOT NULL DEFAULT FALSE,
    procesamiento_error TEXT,
    
    -- ========================================
    -- METADATA ADICIONAL
    -- ========================================
    metadata JSONB DEFAULT '{}'::JSONB, -- Exif, coordenadas, etc.
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_archivos PRIMARY KEY (pkid_archivos),
    CONSTRAINT ck_archivos_tamaño CHECK (tamaño_bytes > 0 AND tamaño_bytes <= 52428800), -- Max 50MB
    CONSTRAINT ck_archivos_mime_imagen CHECK (
        tipo_archivo NOT IN ('FOTO_PERFIL', 'SELFIE_VERIFICACION') OR
        mime_type IN ('image/jpeg', 'image/png', 'image/webp')
    ),
    CONSTRAINT ck_archivos_storage_provider CHECK (
        storage_provider IN ('LOCAL', 'AWS_S3', 'CLOUDINARY', 'AZURE_BLOB', 'GCP_STORAGE')
    )
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_archivos_tipo ON shared_schema.archivos(tipo_archivo);
CREATE INDEX IF NOT EXISTS idx_archivos_hash_md5 ON shared_schema.archivos(hash_md5);
CREATE INDEX IF NOT EXISTS idx_archivos_storage_provider ON shared_schema.archivos(storage_provider);
CREATE INDEX IF NOT EXISTS idx_archivos_procesado ON shared_schema.archivos(procesado) WHERE NOT procesado;
CREATE INDEX IF NOT EXISTS idx_archivos_metadata ON shared_schema.archivos USING GIN(metadata);

-- Triggers (solo si las tablas existen)
DO $$
BEGIN
    -- Solo crear triggers si la tabla existe
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'archivos' AND table_schema = 'shared_schema') THEN
        DROP TRIGGER IF EXISTS trg_archivos_audit ON shared_schema.archivos;
        CREATE TRIGGER trg_archivos_audit
            AFTER INSERT OR UPDATE OR DELETE ON shared_schema.archivos
            FOR EACH ROW
            EXECUTE FUNCTION shared_schema.audit_trigger_func();
    END IF;
END
$$;

COMMENT ON TABLE shared_schema.archivos IS 'Repository: Metadata de archivos/imágenes con external storage. NO almacena binarios en DB.';
COMMENT ON COLUMN shared_schema.archivos.storage_path IS 'Path completo: /uploads/2025/11/14/uuid-filename.jpg';
COMMENT ON COLUMN shared_schema.archivos.storage_url IS 'URL pública: https://cdn.mitoga.com/uploads/2025/11/14/uuid-filename.jpg';

-- ====================
-- BC AUTENTICACIÓN: VERIFICACIÓN BIOMÉTRICA
-- ====================

-- Verificar y reparar tabla verificacion_identidad si fue dañada por CASCADE
DO $$
BEGIN
    -- Si la tabla existe pero le falta la columna tipo_documento o estado, eliminarla para recrearla
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'verificacion_identidad' AND table_schema = 'autenticacion_schema') THEN
        IF NOT shared_schema.tabla_tiene_columna('autenticacion_schema', 'verificacion_identidad', 'tipo_documento') OR
           NOT shared_schema.tabla_tiene_columna('autenticacion_schema', 'verificacion_identidad', 'estado') THEN
            RAISE NOTICE 'Tabla verificacion_identidad dañada por CASCADE - eliminando para recrear';
            DROP TABLE autenticacion_schema.verificacion_identidad CASCADE;
        END IF;
    END IF;
END
$$;

-- Tabla: Verificación Biométrica/Documental
CREATE TABLE IF NOT EXISTS autenticacion_schema.verificacion_identidad (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR
    -- ========================================
    pkid_verificacion_identidad UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- RELACIONES
    -- ========================================
    usuario_id UUID NOT NULL,
    proceso_registro_id UUID NOT NULL,
    
    -- ========================================
    -- DOCUMENTOS DE IDENTIDAD
    -- ========================================
    tipo_documento shared_schema.tipo_documento NOT NULL,
    numero_documento VARCHAR(50) NOT NULL,
    lugar_expedicion VARCHAR(100),
    fecha_expedicion DATE,
    fecha_vencimiento DATE,
    
    -- ========================================
    -- ARCHIVOS ASOCIADOS
    -- ========================================
    foto_perfil_id UUID, -- FK a shared_schema.archivos
    documento_frontal_id UUID,
    documento_trasero_id UUID,
    selfie_verificacion_id UUID,
    
    -- ARCHIVOS DEL RESPONSABLE (si es menor)
    responsable_documento_frontal_id UUID,
    responsable_documento_trasero_id UUID,
    
    -- ========================================
    -- ESTADO DE VERIFICACIÓN
    -- ========================================
    estado shared_schema.estado_verificacion NOT NULL DEFAULT 'PENDIENTE',
    fecha_verificacion TIMESTAMPTZ,
    verificado_por UUID, -- admin que verificó
    
    -- ========================================
    -- RESULTADOS AUTOMÁTICOS (AI/OCR)
    -- ========================================
    ocr_datos_extraidos JSONB, -- datos extraídos por OCR
    verificacion_automatica JSONB, -- resultado de checks automáticos
    puntuacion_confianza DECIMAL(3,2), -- 0.00 - 1.00
    
    -- ========================================
    -- OBSERVACIONES
    -- ========================================
    observaciones TEXT,
    razon_rechazo TEXT,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_verificacion_identidad PRIMARY KEY (pkid_verificacion_identidad),
    CONSTRAINT fk_verificacion_identidad_usuario FOREIGN KEY (usuario_id) 
        REFERENCES autenticacion_schema.usuarios(pkid_usuarios) 
        ON DELETE CASCADE,
    CONSTRAINT fk_verificacion_identidad_proceso FOREIGN KEY (proceso_registro_id) 
        REFERENCES autenticacion_schema.proceso_registro(pkid_proceso_registro) 
        ON DELETE CASCADE,
    CONSTRAINT fk_verificacion_identidad_foto_perfil FOREIGN KEY (foto_perfil_id) 
        REFERENCES shared_schema.archivos(pkid_archivos),
    CONSTRAINT fk_verificacion_identidad_doc_frontal FOREIGN KEY (documento_frontal_id) 
        REFERENCES shared_schema.archivos(pkid_archivos),
    CONSTRAINT fk_verificacion_identidad_doc_trasero FOREIGN KEY (documento_trasero_id) 
        REFERENCES shared_schema.archivos(pkid_archivos),
    CONSTRAINT fk_verificacion_identidad_selfie FOREIGN KEY (selfie_verificacion_id) 
        REFERENCES shared_schema.archivos(pkid_archivos),
    CONSTRAINT fk_verificacion_responsable_doc_frontal FOREIGN KEY (responsable_documento_frontal_id) 
        REFERENCES shared_schema.archivos(pkid_archivos),
    CONSTRAINT fk_verificacion_responsable_doc_trasero FOREIGN KEY (responsable_documento_trasero_id) 
        REFERENCES shared_schema.archivos(pkid_archivos),
    CONSTRAINT uq_verificacion_identidad_usuario UNIQUE (usuario_id),
    CONSTRAINT ck_verificacion_confianza CHECK (
        puntuacion_confianza IS NULL OR 
        (puntuacion_confianza >= 0.00 AND puntuacion_confianza <= 1.00)
    )
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_verificacion_identidad_usuario ON autenticacion_schema.verificacion_identidad(usuario_id);
CREATE INDEX IF NOT EXISTS idx_verificacion_identidad_estado ON autenticacion_schema.verificacion_identidad(estado);
CREATE INDEX IF NOT EXISTS idx_verificacion_identidad_numero_doc ON autenticacion_schema.verificacion_identidad(numero_documento);
CREATE INDEX IF NOT EXISTS idx_verificacion_identidad_pendientes ON autenticacion_schema.verificacion_identidad(creation_date DESC) 
    WHERE estado = 'PENDIENTE';

-- Triggers (solo si las tablas existen)
DO $$
BEGIN
    -- Solo crear triggers si la tabla existe
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'verificacion_identidad' AND table_schema = 'autenticacion_schema') THEN
        DROP TRIGGER IF EXISTS trg_verificacion_identidad_audit ON autenticacion_schema.verificacion_identidad;
        CREATE TRIGGER trg_verificacion_identidad_audit
            AFTER INSERT OR UPDATE OR DELETE ON autenticacion_schema.verificacion_identidad
            FOR EACH ROW
            EXECUTE FUNCTION shared_schema.audit_trigger_func();
    END IF;
END
$$;

COMMENT ON TABLE autenticacion_schema.verificacion_identidad IS 'Aggregate: Proceso de verificación biométrica/documental del estudiante';
COMMENT ON COLUMN autenticacion_schema.verificacion_identidad.ocr_datos_extraidos IS 'JSON: Datos extraídos automáticamente por OCR del documento';
COMMENT ON COLUMN autenticacion_schema.verificacion_identidad.verificacion_automatica IS 'JSON: Resultados de verificaciones automáticas (face matching, document validation)';

-- ============================================================================
-- FUNCTIONS PARA REGISTRO MULTI-STEP
-- ============================================================================

-- Function: Trigger de auditoría universal 
CREATE OR REPLACE FUNCTION shared_schema.audit_trigger_func()
RETURNS trigger AS $$
BEGIN
    -- Esta función debe existir si se van a usar triggers de auditoría
    -- Por ahora, simplemente retorna el registro sin hacer nada
    -- En una implementación completa, esto escribiría a una tabla de auditoría
    
    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Function: Update timestamp automático
CREATE OR REPLACE FUNCTION shared_schema.trigger_set_timestamp()
RETURNS trigger AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function: Calcular edad desde fecha de nacimiento
-- ⚠️ NOTA: Esta función NO es IMMUTABLE porque AGE() depende del tiempo actual
CREATE OR REPLACE FUNCTION shared_schema.calcular_edad(fecha_nac DATE)
RETURNS INTEGER AS $$
BEGIN
    RETURN DATE_PART('year', AGE(fecha_nac));
END;
$$ LANGUAGE plpgsql STABLE;

-- Function: Validar email format
CREATE OR REPLACE FUNCTION shared_schema.validar_email(email TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$';
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Function: Generar código OTP
CREATE OR REPLACE FUNCTION autenticacion_schema.generar_otp()
RETURNS VARCHAR(6) AS $$
BEGIN
    RETURN LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');
END;
$$ LANGUAGE plpgsql;

-- Function: Capitalizar nombres
CREATE OR REPLACE FUNCTION shared_schema.capitalizar_nombre(nombre TEXT)
RETURNS TEXT AS $$
BEGIN
    RETURN INITCAP(TRIM(nombre));
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Function: Limpiar procesos registros expirados
CREATE OR REPLACE FUNCTION autenticacion_schema.limpiar_procesos_expirados()
RETURNS INTEGER AS $$
DECLARE
    registros_eliminados INTEGER := 0;
BEGIN
    -- Verificar que la tabla existe antes de intentar UPDATE
    IF EXISTS (SELECT 1 FROM information_schema.tables 
               WHERE table_name = 'proceso_registro' 
               AND table_schema = 'autenticacion_schema') THEN
        
        -- Marcar como abandonados los procesos expirados
        UPDATE autenticacion_schema.proceso_registro 
        SET 
            estado_actual = 'ABANDONADO',
            expiration_date = NOW()
        WHERE 
            fecha_expiracion < NOW() 
            AND estado_actual NOT IN ('COMPLETADO', 'ABANDONADO', 'RECHAZADO');
        
        GET DIAGNOSTICS registros_eliminados = ROW_COUNT;
    END IF;
    
    -- Log simplificado (sin tabla de auditoría por ahora)
    -- En implementación completa: escribir a tabla de auditoría
    -- INSERT INTO shared_schema.audit_log(...) VALUES (...);
    
    RETURN registros_eliminados;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION autenticacion_schema.limpiar_procesos_expirados() IS 'Limpia procesos de registro expirados (ejecutar diariamente)';

-- Function: Helper para obtener valores de catálogo por tipo
CREATE OR REPLACE FUNCTION shared_schema.get_catalogo_by_tipo_codigo(
    p_catalogo_tipo VARCHAR(50),
    p_codigo VARCHAR(50)
)
RETURNS UUID AS $$
DECLARE
    resultado_id UUID;
BEGIN
    SELECT pkid_catalogo_recursivo 
    INTO resultado_id
    FROM shared_schema.catalogo_recursivo 
    WHERE catalogo_tipo = p_catalogo_tipo 
    AND codigo = p_codigo
    AND expiration_date IS NULL
    AND activo = TRUE;
    
    RETURN resultado_id;
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION shared_schema.get_catalogo_by_tipo_codigo(VARCHAR, VARCHAR) IS 'Helper: Obtener UUID de catálogo por tipo y código';

-- Function: Helper para obtener nombre de valor de catálogo
CREATE OR REPLACE FUNCTION shared_schema.get_catalogo_nombre(p_catalogo_id UUID)
RETURNS VARCHAR AS $$
DECLARE
    resultado_nombre VARCHAR(255);
BEGIN
    SELECT nombre 
    INTO resultado_nombre
    FROM shared_schema.catalogo_recursivo 
    WHERE pkid_catalogo_recursivo = p_catalogo_id
    AND expiration_date IS NULL;
    
    RETURN COALESCE(resultado_nombre, 'VALOR_NO_ENCONTRADO');
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION shared_schema.get_catalogo_nombre(UUID) IS 'Helper: Obtener nombre legible de valor de catálogo por UUID';

-- ============================================================================
-- DATOS INICIALES - COMENTARIO
-- ============================================================================

-- NOTA: Los datos iniciales para PAIS, IDIOMA, GENERO_SEXUAL, CIUDAD, NIVEL_EDUCATIVO
-- deben ser insertados en V3__catalogo_recursivo_datos.sql con catalogo_tipo correspondiente
-- 
-- Ejemplos de uso:
-- SELECT shared_schema.get_catalogo_by_tipo_codigo('GENERO_SEXUAL', 'MASCULINO');
-- SELECT shared_schema.get_catalogo_by_tipo_codigo('CIUDAD', 'BOG');  
-- SELECT shared_schema.get_catalogo_by_tipo_codigo('NIVEL_EDUCATIVO', 'UNIVERSITARIO');

-- ============================================================================
-- COMENTARIOS FINALES
-- ============================================================================

COMMENT ON EXTENSION "uuid-ossp" IS 'V4__registro_estudiantes_multistep: UUIDs para todas las PKs';

-- Verificar que todas las tablas tienen audit triggers
DO $$
DECLARE
    tabla_record RECORD;
BEGIN
    FOR tabla_record IN 
        SELECT schemaname, tablename 
        FROM pg_tables 
        WHERE schemaname IN ('autenticacion_schema', 'perfiles_schema', 'shared_schema')
        AND tablename NOT IN ('audit_log', 'domain_events')
    LOOP
        RAISE NOTICE 'Tabla: %.% tiene audit trigger configurado', tabla_record.schemaname, tabla_record.tablename;
    END LOOP;
END $$;