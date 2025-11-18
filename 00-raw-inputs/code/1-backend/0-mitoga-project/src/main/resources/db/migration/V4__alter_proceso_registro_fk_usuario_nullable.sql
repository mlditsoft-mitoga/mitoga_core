-- Migration: Modificar fk_id_usuario para permitir NULL
-- Propósito: Permitir crear ProcesoRegistro ANTES de Usuario para evitar problemas de FK transaccionales
--
-- BC01-Autenticacion | HUT-001 | Registro Estudiantes Multi-Paso

-- ============================================================================
-- Modificar columna fk_id_usuario para permitir NULL
-- ============================================================================

-- PASO 1: Eliminar FK constraint (causa problemas transaccionales)
ALTER TABLE appmatch_schema.proceso_registro
    DROP CONSTRAINT IF EXISTS fk_proceso_registro_usuario;

-- PASO 2: Hacer columna nullable
ALTER TABLE appmatch_schema.proceso_registro
    ALTER COLUMN fk_id_usuario DROP NOT NULL;

-- ============================================================================
-- Comentario
-- ============================================================================

COMMENT ON COLUMN appmatch_schema.proceso_registro.fk_id_usuario IS 
    'FK al usuario propietario del proceso. NULL temporalmente al crear proceso, se vincula después de crear Usuario.';
