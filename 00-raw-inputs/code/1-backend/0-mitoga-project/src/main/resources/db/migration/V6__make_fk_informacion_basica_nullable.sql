-- =====================================================
-- Migración V6: Hacer nullable fk_pkid_informacion_basica
-- =====================================================
-- Descripción: Permite crear perfil_informacion_basica en STEP 1
--              sin tener informacion_basica (se vincula en STEP 2)
-- Autor: Backend Team MI-TOGA
-- Fecha: 2025-11-17
-- =====================================================

-- 1. Eliminar constraint NOT NULL de fk_pkid_informacion_basica
ALTER TABLE appmatch_schema.perfil_informacion_basica 
    ALTER COLUMN fk_pkid_informacion_basica DROP NOT NULL;

-- 2. Verificación
DO $$
DECLARE
    column_nullable boolean;
BEGIN
    SELECT is_nullable = 'YES'
    INTO column_nullable
    FROM information_schema.columns
    WHERE table_schema = 'appmatch_schema'
      AND table_name = 'perfil_informacion_basica'
      AND column_name = 'fk_pkid_informacion_basica';
    
    IF column_nullable THEN
        RAISE NOTICE '✅ Columna fk_pkid_informacion_basica ahora es NULLABLE';
    ELSE
        RAISE EXCEPTION '❌ ERROR: Columna fk_pkid_informacion_basica sigue siendo NOT NULL';
    END IF;
END $$;
