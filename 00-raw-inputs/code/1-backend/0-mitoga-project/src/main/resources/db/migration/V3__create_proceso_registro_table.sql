-- Migration: Crear tabla proceso_registro
-- Propósito: Gestionar el estado de procesos de registro multi-paso con TTL de 24 horas
--           Permite trazabilidad y validación de pasos secuenciales
--
-- BC01-Autenticacion | HUT-001 | Registro Estudiantes Multi-Paso

-- ============================================================================
-- Tabla: proceso_registro
-- ============================================================================

CREATE TABLE appmatch_schema.proceso_registro (
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    pkid_proceso_registro UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- CAMPOS DE NEGOCIO
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    fk_id_usuario UUID NULL, -- NULL temporalmente, se vincula después de crear Usuario
    estado_actual VARCHAR(50) NOT NULL,
    fecha_inicio TIMESTAMPTZ NOT NULL,
    fecha_expiracion_proceso TIMESTAMPTZ NOT NULL,
    fecha_ultima_actualizacion TIMESTAMPTZ NOT NULL,
    step_actual INTEGER NOT NULL,
    metadata_proceso JSONB,
    
    -- Primary Key
    CONSTRAINT pk_proceso_registro PRIMARY KEY (pkid_proceso_registro),
    
    -- Foreign Keys
    CONSTRAINT fk_proceso_registro_usuario 
        FOREIGN KEY (fk_id_usuario) 
        REFERENCES appmatch_schema.usuarios(pkid_usuarios)
        ON DELETE CASCADE,
    
    -- Check Constraints
    CONSTRAINT chk_proceso_estado_valido 
        CHECK (estado_actual IN (
            'STEP_1_COMPLETADO',
            'STEP_2_COMPLETADO',
            'STEP_3_COMPLETADO',
            'STEP_4_COMPLETADO',
            'COMPLETADO',
            'EXPIRADO',
            'CANCELADO'
        )),
    
    CONSTRAINT chk_proceso_step_rango 
        CHECK (step_actual >= 1 AND step_actual <= 4),
    
    CONSTRAINT chk_proceso_fechas_logicas 
        CHECK (fecha_expiracion_proceso > fecha_inicio),
        
    -- Soft delete coherente
    CONSTRAINT chk_proceso_soft_delete_coherente
        CHECK (
            expiration_date IS NULL OR 
            expiration_date > creation_date
        )
);

-- ============================================================================
-- Índices
-- ============================================================================

-- Índice para buscar procesos por usuario
CREATE INDEX idx_proceso_registro_usuario 
    ON appmatch_schema.proceso_registro(fk_id_usuario)
    WHERE expiration_date IS NULL;

-- Índice para filtrar por estado
CREATE INDEX idx_proceso_registro_estado 
    ON appmatch_schema.proceso_registro(estado_actual)
    WHERE expiration_date IS NULL;

-- Índice parcial para queries de procesos activos (optimiza búsqueda de expirados)
CREATE INDEX idx_proceso_registro_expiracion_activos 
    ON appmatch_schema.proceso_registro(fecha_expiracion_proceso) 
    WHERE expiration_date IS NULL 
      AND estado_actual NOT IN ('EXPIRADO', 'COMPLETADO', 'CANCELADO');

-- Índice en creation_date para reportes
CREATE INDEX idx_proceso_registro_creation_date 
    ON appmatch_schema.proceso_registro(creation_date DESC)
    WHERE expiration_date IS NULL;

-- ============================================================================
-- Comentarios (Documentación)
-- ============================================================================

COMMENT ON TABLE appmatch_schema.proceso_registro IS 
    'Gestiona el estado de procesos de registro multi-paso. TTL: 24 horas desde fecha_inicio. Permite validar progresión secuencial de steps.';

COMMENT ON COLUMN appmatch_schema.proceso_registro.pkid_proceso_registro IS 
    'Primary Key UUID de la tabla proceso_registro';

COMMENT ON COLUMN appmatch_schema.proceso_registro.creation_date IS 
    'Fecha y hora de creación del registro (inmutable, auditoría)';

COMMENT ON COLUMN appmatch_schema.proceso_registro.expiration_date IS 
    'Soft delete: NULL = proceso activo, NOT NULL = fecha de eliminación lógica.';

COMMENT ON COLUMN appmatch_schema.proceso_registro.fk_id_usuario IS 
    'FK al usuario propietario del proceso de registro.';

COMMENT ON COLUMN appmatch_schema.proceso_registro.estado_actual IS 
    'Estado actual del proceso: STEP_X_COMPLETADO, COMPLETADO, EXPIRADO, CANCELADO.';

COMMENT ON COLUMN appmatch_schema.proceso_registro.fecha_inicio IS 
    'Timestamp de inicio del proceso (creación en STEP 1).';

COMMENT ON COLUMN appmatch_schema.proceso_registro.fecha_expiracion_proceso IS 
    'Timestamp de expiración = fecha_inicio + 24 horas. Proceso expirado no puede continuar.';

COMMENT ON COLUMN appmatch_schema.proceso_registro.fecha_ultima_actualizacion IS 
    'Timestamp de última modificación (avance de step, cancelación, etc).';

COMMENT ON COLUMN appmatch_schema.proceso_registro.step_actual IS 
    'Número del step actual (1-4). Incrementa al completar cada paso.';

COMMENT ON COLUMN appmatch_schema.proceso_registro.metadata_proceso IS 
    'JSONB con metadata del proceso: {ipRegistro, userAgent, dispositivo, navegador, sistemaOperativo}.';
