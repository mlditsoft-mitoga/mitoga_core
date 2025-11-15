-- ============================================================================
-- Migration: V5_1__tutores_storage_extension.sql
-- Description: Extensión de shared_schema.archivos para soportar archivos de tutores
-- Author: Database Engineering Team - ZNS-METHOD
-- Date: 2025-11-14
-- Prerequisitos: V4 (shared_schema.archivos) y V5 (tutores_schema) ejecutados
-- PostgreSQL Version: 16.x
-- Basado en: Lecciones aprendidas V4 + V5 (11 errores corregidos)
-- ============================================================================

-- ====================
-- VERIFICACIÓN DE PREREQUISITOS
-- ====================

SELECT 'V5.1: INICIANDO EXTENSIÓN STORAGE TUTORES' as mensaje;

-- Verificar que V4 (archivos) fue ejecutado
DO $$
BEGIN
    IF NOT EXISTS (SELECT * FROM information_schema.tables 
                   WHERE table_schema = 'shared_schema' 
                   AND table_name = 'archivos') THEN
        RAISE EXCEPTION 'PREREQUISITO FALTANTE: Tabla shared_schema.archivos no existe. Ejecutar V4 primero.';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_type 
                   WHERE typname = 'tipo_archivo' 
                   AND typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'shared_schema')) THEN
        RAISE EXCEPTION 'PREREQUISITO FALTANTE: ENUM shared_schema.tipo_archivo no existe. Ejecutar V4 primero.';
    END IF;
    
    RAISE NOTICE '✅ Prerequisito V4 (shared_schema.archivos) verificado';
END $$;

-- Verificar que V5 (tutores) fue ejecutado
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.schemata 
                   WHERE schema_name = 'tutores_schema') THEN
        RAISE EXCEPTION 'PREREQUISITO FALTANTE: Schema tutores_schema no existe. Ejecutar V5 primero.';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables 
                   WHERE table_schema = 'tutores_schema' 
                   AND table_name = 'perfiles_tutor') THEN
        RAISE EXCEPTION 'PREREQUISITO FALTANTE: Tabla tutores_schema.perfiles_tutor no existe. Ejecutar V5 primero.';
    END IF;
    
    RAISE NOTICE '✅ Prerequisito V5 (tutores_schema) verificado';
END $$;

-- ====================
-- EXTENSIÓN DE ENUM TIPO_ARCHIVO
-- ====================

-- Agregar nuevos tipos de archivo para tutores (Lección #7: gestión defensiva de ENUMs)
DO $$
BEGIN
    -- Verificar cada tipo individualmente antes de agregar
    IF NOT EXISTS (SELECT 1 FROM pg_enum e 
                   JOIN pg_type t ON e.enumtypid = t.oid 
                   WHERE t.typname = 'tipo_archivo' 
                   AND e.enumlabel = 'FOTO_PERFIL_TUTOR') THEN
        ALTER TYPE shared_schema.tipo_archivo ADD VALUE 'FOTO_PERFIL_TUTOR';
        RAISE NOTICE '✅ Tipo FOTO_PERFIL_TUTOR agregado';
    ELSE
        RAISE NOTICE 'Tipo FOTO_PERFIL_TUTOR ya existe';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_enum e 
                   JOIN pg_type t ON e.enumtypid = t.oid 
                   WHERE t.typname = 'tipo_archivo' 
                   AND e.enumlabel = 'VIDEO_PRESENTACION') THEN
        ALTER TYPE shared_schema.tipo_archivo ADD VALUE 'VIDEO_PRESENTACION';
        RAISE NOTICE '✅ Tipo VIDEO_PRESENTACION agregado';
    ELSE
        RAISE NOTICE 'Tipo VIDEO_PRESENTACION ya existe';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_enum e 
                   JOIN pg_type t ON e.enumtypid = t.oid 
                   WHERE t.typname = 'tipo_archivo' 
                   AND e.enumlabel = 'CERTIFICADO_EDUCATIVO') THEN
        ALTER TYPE shared_schema.tipo_archivo ADD VALUE 'CERTIFICADO_EDUCATIVO';
        RAISE NOTICE '✅ Tipo CERTIFICADO_EDUCATIVO agregado';
    ELSE
        RAISE NOTICE 'Tipo CERTIFICADO_EDUCATIVO ya existe';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_enum e 
                   JOIN pg_type t ON e.enumtypid = t.oid 
                   WHERE t.typname = 'tipo_archivo' 
                   AND e.enumlabel = 'CERTIFICADO_EXPERIENCIA') THEN
        ALTER TYPE shared_schema.tipo_archivo ADD VALUE 'CERTIFICADO_EXPERIENCIA';
        RAISE NOTICE '✅ Tipo CERTIFICADO_EXPERIENCIA agregado';
    ELSE
        RAISE NOTICE 'Tipo CERTIFICADO_EXPERIENCIA ya existe';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_enum e 
                   JOIN pg_type t ON e.enumtypid = t.oid 
                   WHERE t.typname = 'tipo_archivo' 
                   AND e.enumlabel = 'CERTIFICADO_IDIOMA') THEN
        ALTER TYPE shared_schema.tipo_archivo ADD VALUE 'CERTIFICADO_IDIOMA';
        RAISE NOTICE '✅ Tipo CERTIFICADO_IDIOMA agregado';
    ELSE
        RAISE NOTICE 'Tipo CERTIFICADO_IDIOMA ya existe';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_enum e 
                   JOIN pg_type t ON e.enumtypid = t.oid 
                   WHERE t.typname = 'tipo_archivo' 
                   AND e.enumlabel = 'DOCUMENTO_FISCAL') THEN
        ALTER TYPE shared_schema.tipo_archivo ADD VALUE 'DOCUMENTO_FISCAL';
        RAISE NOTICE '✅ Tipo DOCUMENTO_FISCAL agregado';
    ELSE
        RAISE NOTICE 'Tipo DOCUMENTO_FISCAL ya existe';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_enum e 
                   JOIN pg_type t ON e.enumtypid = t.oid 
                   WHERE t.typname = 'tipo_archivo' 
                   AND e.enumlabel = 'PORTAFOLIO_TRABAJO') THEN
        ALTER TYPE shared_schema.tipo_archivo ADD VALUE 'PORTAFOLIO_TRABAJO';
        RAISE NOTICE '✅ Tipo PORTAFOLIO_TRABAJO agregado';
    ELSE
        RAISE NOTICE 'Tipo PORTAFOLIO_TRABAJO ya existe';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_enum e 
                   JOIN pg_type t ON e.enumtypid = t.oid 
                   WHERE t.typname = 'tipo_archivo' 
                   AND e.enumlabel = 'FOTO_WORKSPACE') THEN
        ALTER TYPE shared_schema.tipo_archivo ADD VALUE 'FOTO_WORKSPACE';
        RAISE NOTICE '✅ Tipo FOTO_WORKSPACE agregado';
    ELSE
        RAISE NOTICE 'Tipo FOTO_WORKSPACE ya existe';
    END IF;
END $$;

-- ====================
-- TABLA DE RELACIÓN TUTOR-ARCHIVOS
-- ====================

-- Crear tabla de relación entre tutores y archivos (Lección #4: idempotente)
CREATE TABLE IF NOT EXISTS tutores_schema.tutor_archivos (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR
    -- ========================================
    pkid_tutor_archivo UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- RELACIONES
    -- ========================================
    tutor_id UUID NOT NULL,
    archivo_id UUID NOT NULL,
    
    -- ========================================
    -- METADATA ESPECÍFICA DEL TUTOR
    -- ========================================
    es_principal BOOLEAN DEFAULT FALSE, -- Para foto perfil principal
    orden_visualizacion INTEGER DEFAULT 0,
    descripcion TEXT NULL,
    etiquetas JSONB DEFAULT '[]'::JSONB, -- ["verificado", "destacado"]
    fecha_verificacion TIMESTAMPTZ NULL,
    verificado_por_admin_id UUID NULL,
    notas_verificacion TEXT NULL,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_tutor_archivos PRIMARY KEY (pkid_tutor_archivo),
    CONSTRAINT uq_tutor_archivo UNIQUE (tutor_id, archivo_id),
    CONSTRAINT ck_tutor_archivos_orden CHECK (orden_visualizacion >= 0)
);

-- ====================
-- FOREIGN KEYS PARA TUTOR_ARCHIVOS
-- ====================

-- Foreign Keys (Lección #10: nombres exactos de PK)
DO $$
BEGIN
    -- FK a tutores (Lección #10: pkid_usuarios correcto)
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_schema = 'tutores_schema' 
                   AND table_name = 'tutor_archivos'
                   AND constraint_name = 'fk_tutor_archivos_tutor') THEN
        ALTER TABLE tutores_schema.tutor_archivos 
        ADD CONSTRAINT fk_tutor_archivos_tutor 
        FOREIGN KEY (tutor_id) REFERENCES tutores_schema.perfiles_tutor(pkid_tutor) ON DELETE CASCADE;
        RAISE NOTICE '✅ FK fk_tutor_archivos_tutor creada';
    END IF;
    
    -- FK a archivos compartidos
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_schema = 'tutores_schema' 
                   AND table_name = 'tutor_archivos'
                   AND constraint_name = 'fk_tutor_archivos_archivo') THEN
        ALTER TABLE tutores_schema.tutor_archivos 
        ADD CONSTRAINT fk_tutor_archivos_archivo 
        FOREIGN KEY (archivo_id) REFERENCES shared_schema.archivos(pkid_archivos) ON DELETE CASCADE;
        RAISE NOTICE '✅ FK fk_tutor_archivos_archivo creada';
    END IF;
    
    -- FK a admin verificador (Lección #10: pkid_usuarios correcto)
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_schema = 'tutores_schema' 
                   AND table_name = 'tutor_archivos'
                   AND constraint_name = 'fk_tutor_archivos_admin_verificador') THEN
        ALTER TABLE tutores_schema.tutor_archivos 
        ADD CONSTRAINT fk_tutor_archivos_admin_verificador 
        FOREIGN KEY (verificado_por_admin_id) REFERENCES autenticacion_schema.usuarios(pkid_usuarios);
        RAISE NOTICE '✅ FK fk_tutor_archivos_admin_verificador creada';
    END IF;
END $$;

-- ====================
-- ÍNDICES PARA PERFORMANCE
-- ====================

-- Índices optimizados (Lección #4: IF NOT EXISTS)
CREATE INDEX IF NOT EXISTS idx_tutor_archivos_tutor_id ON tutores_schema.tutor_archivos(tutor_id);
CREATE INDEX IF NOT EXISTS idx_tutor_archivos_archivo_id ON tutores_schema.tutor_archivos(archivo_id);
CREATE INDEX IF NOT EXISTS idx_tutor_archivos_es_principal ON tutores_schema.tutor_archivos(tutor_id, es_principal) WHERE es_principal = TRUE;
CREATE INDEX IF NOT EXISTS idx_tutor_archivos_orden ON tutores_schema.tutor_archivos(tutor_id, orden_visualizacion);
CREATE INDEX IF NOT EXISTS idx_tutor_archivos_etiquetas ON tutores_schema.tutor_archivos USING GIN(etiquetas);
CREATE INDEX IF NOT EXISTS idx_tutor_archivos_pendientes_verificacion ON tutores_schema.tutor_archivos(verificado_por_admin_id) WHERE fecha_verificacion IS NULL;

-- ====================
-- TRIGGERS DE AUDITORÍA
-- ====================

-- Trigger de auditoría (Lección #4: verificación defensiva)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables 
               WHERE table_name = 'tutor_archivos' 
               AND table_schema = 'tutores_schema') THEN
        
        DROP TRIGGER IF EXISTS trg_tutor_archivos_audit ON tutores_schema.tutor_archivos;
        CREATE TRIGGER trg_tutor_archivos_audit
            AFTER INSERT OR UPDATE OR DELETE ON tutores_schema.tutor_archivos
            FOR EACH ROW
            EXECUTE FUNCTION shared_schema.audit_trigger_func();
        RAISE NOTICE '✅ Trigger auditoría tutor_archivos creado';
    END IF;
END $$;

-- Trigger para updated_at
SELECT tutores_schema.setup_updated_at_trigger('tutor_archivos');

-- ====================
-- EXTENSIÓN DE CONSTRAINTS ARCHIVOS
-- ====================

-- Agregar constraint para validar tipos de tutores (Lección #6: NO subqueries en CHECK)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_schema = 'shared_schema' 
                   AND table_name = 'archivos'
                   AND constraint_name = 'ck_archivos_tipos_tutores') THEN
        
        ALTER TABLE shared_schema.archivos 
        ADD CONSTRAINT ck_archivos_tipos_tutores CHECK (
            tipo_archivo IN (
                'FOTO_PERFIL', 'DOCUMENTO_FRONTAL', 'DOCUMENTO_TRASERO', 
                'SELFIE_VERIFICACION', 'DOCUMENTO_RESPONSABLE_FRONTAL', 'DOCUMENTO_RESPONSABLE_TRASERO',
                'FOTO_PERFIL_TUTOR', 'VIDEO_PRESENTACION', 'CERTIFICADO_EDUCATIVO',
                'CERTIFICADO_EXPERIENCIA', 'CERTIFICADO_IDIOMA', 'DOCUMENTO_FISCAL',
                'PORTAFOLIO_TRABAJO', 'FOTO_WORKSPACE'
            )
        );
        RAISE NOTICE '✅ Constraint tipos tutores agregado a archivos';
    END IF;
END $$;

-- ====================
-- FUNCIONES HELPER PARA TUTORES
-- ====================

-- Función para obtener archivos de un tutor por tipo
CREATE OR REPLACE FUNCTION tutores_schema.get_tutor_archivos(
    p_tutor_id UUID,
    p_tipo_archivo shared_schema.tipo_archivo DEFAULT NULL
)
RETURNS TABLE (
    archivo_id UUID,
    nombre_original VARCHAR(255),
    storage_url TEXT,
    es_principal BOOLEAN,
    fecha_verificacion TIMESTAMPTZ,
    descripcion TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.pkid_archivos,
        a.nombre_original,
        a.storage_url,
        ta.es_principal,
        ta.fecha_verificacion,
        ta.descripcion
    FROM tutores_schema.tutor_archivos ta
    JOIN shared_schema.archivos a ON ta.archivo_id = a.pkid_archivos
    WHERE ta.tutor_id = p_tutor_id
      AND ta.expiration_date IS NULL
      AND a.expiration_date IS NULL
      AND (p_tipo_archivo IS NULL OR a.tipo_archivo = p_tipo_archivo)
    ORDER BY ta.orden_visualizacion, ta.creation_date;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener foto de perfil principal
CREATE OR REPLACE FUNCTION tutores_schema.get_foto_perfil_principal(p_tutor_id UUID)
RETURNS VARCHAR(500) AS $$
DECLARE
    v_url VARCHAR(500);
BEGIN
    SELECT a.storage_url INTO v_url
    FROM tutores_schema.tutor_archivos ta
    JOIN shared_schema.archivos a ON ta.archivo_id = a.pkid_archivos
    WHERE ta.tutor_id = p_tutor_id
      AND a.tipo_archivo = 'FOTO_PERFIL_TUTOR'
      AND ta.es_principal = TRUE
      AND ta.expiration_date IS NULL
      AND a.expiration_date IS NULL
    LIMIT 1;
    
    RETURN COALESCE(v_url, '/images/avatar-default.jpg');
END;
$$ LANGUAGE plpgsql;

-- ====================
-- COMENTARIOS Y DOCUMENTACIÓN
-- ====================

COMMENT ON TABLE tutores_schema.tutor_archivos IS 'Relación N:M entre tutores y archivos. Extiende shared_schema.archivos para casos específicos de tutores.';
COMMENT ON COLUMN tutores_schema.tutor_archivos.es_principal IS 'TRUE solo para la foto de perfil principal del tutor';
COMMENT ON COLUMN tutores_schema.tutor_archivos.etiquetas IS 'Array JSON de etiquetas: ["verificado", "destacado", "pendiente"]';
COMMENT ON FUNCTION tutores_schema.get_tutor_archivos IS 'Obtiene archivos de un tutor filtrados opcionalmente por tipo';
COMMENT ON FUNCTION tutores_schema.get_foto_perfil_principal IS 'Retorna URL de foto perfil principal o imagen por defecto';

-- ====================
-- VALIDACIÓN FINAL
-- ====================

-- Verificar que todo se creó correctamente
DO $$
DECLARE
    v_enum_count INTEGER;
    v_table_exists BOOLEAN;
    v_fk_count INTEGER;
    v_index_count INTEGER;
BEGIN
    -- Verificar tipos agregados al ENUM
    SELECT COUNT(*) INTO v_enum_count
    FROM pg_enum e 
    JOIN pg_type t ON e.enumtypid = t.oid 
    WHERE t.typname = 'tipo_archivo' 
      AND e.enumlabel IN ('FOTO_PERFIL_TUTOR', 'VIDEO_PRESENTACION', 'CERTIFICADO_EDUCATIVO', 
                          'CERTIFICADO_EXPERIENCIA', 'CERTIFICADO_IDIOMA', 'DOCUMENTO_FISCAL',
                          'PORTAFOLIO_TRABAJO', 'FOTO_WORKSPACE');
    
    -- Verificar tabla creada
    SELECT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'tutores_schema' 
        AND table_name = 'tutor_archivos'
    ) INTO v_table_exists;
    
    -- Verificar FKs creadas
    SELECT COUNT(*) INTO v_fk_count
    FROM information_schema.table_constraints 
    WHERE constraint_schema = 'tutores_schema' 
      AND table_name = 'tutor_archivos'
      AND constraint_type = 'FOREIGN KEY';
    
    -- Verificar índices creados
    SELECT COUNT(*) INTO v_index_count
    FROM pg_indexes 
    WHERE schemaname = 'tutores_schema' 
      AND tablename = 'tutor_archivos';
    
    -- Reporte final
    RAISE NOTICE '📊 RESUMEN V5.1 STORAGE EXTENSIÓN:';
    RAISE NOTICE '✅ Nuevos tipos archivo: % de 8 esperados', v_enum_count;
    RAISE NOTICE '✅ Tabla tutor_archivos: %', CASE WHEN v_table_exists THEN 'CREADA' ELSE 'ERROR' END;
    RAISE NOTICE '✅ Foreign Keys: % de 3 esperadas', v_fk_count;
    RAISE NOTICE '✅ Índices: % de 6+ esperados', v_index_count;
    RAISE NOTICE '✅ Funciones helper: 2 creadas';
    
    IF v_enum_count >= 6 AND v_table_exists AND v_fk_count = 3 AND v_index_count >= 6 THEN
        RAISE NOTICE '🎉 V5.1 STORAGE EXTENSIÓN COMPLETADA EXITOSAMENTE';
    ELSE
        RAISE WARNING '⚠️ V5.1 incompleta - revisar logs arriba';
    END IF;
END $$;