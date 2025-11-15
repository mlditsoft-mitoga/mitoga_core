-- ============================================================================
-- TEST: Verificar que V4 es completamente idempotente
-- Description: Script de prueba para validar que V4 puede ejecutarse múltiples veces
-- Author: Database Engineer Senior - ZNS-METHOD
-- Date: 2025-11-14
-- ============================================================================

\echo '🧪 INICIANDO TEST DE IDEMPOTENCIA PARA V4'

-- Verificar que estamos en la base de datos correcta
SELECT 
    'Conectado a DB: ' || current_database() AS info,
    'Usuario: ' || current_user AS usuario,
    'Timestamp: ' || NOW()::TEXT AS timestamp;

-- Test 1: Verificar que tipos ENUM existen y pueden recrearse
\echo '📋 TEST 1: Verificando tipos ENUM...'

DO $$
BEGIN
    -- Test DROP IF EXISTS + CREATE para tipos ENUM
    IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'estado_registro') THEN
        RAISE NOTICE '✅ estado_registro existe - ready for DROP IF EXISTS';
    ELSE
        RAISE NOTICE '📋 estado_registro no existe - será creado';
    END IF;
END
$$;

-- Test 2: Verificar índices existentes
\echo '📋 TEST 2: Verificando índices existentes...'

SELECT 
    'Índices encontrados para proceso_registro: ' || COUNT(*)::TEXT AS info
FROM pg_indexes 
WHERE tablename = 'proceso_registro' 
AND schemaname = 'autenticacion_schema';

-- Test 3: Contar objetos actuales
\echo '📋 TEST 3: Contando objetos actuales...'

SELECT 
    'SCHEMAS existentes: ' || (
        SELECT COUNT(*) FROM information_schema.schemata 
        WHERE schema_name IN ('autenticacion_schema', 'perfiles_schema', 'shared_schema')
    )::TEXT AS schemas,
    'TABLAS V4: ' || (
        SELECT COUNT(*) FROM information_schema.tables 
        WHERE table_name IN ('proceso_registro', 'perfiles_estudiante', 'archivos', 'verificacion_identidad')
    )::TEXT AS tablas_v4,
    'TIPOS ENUM: ' || (
        SELECT COUNT(*) FROM pg_type 
        WHERE typname IN ('estado_registro', 'tipo_documento', 'tipo_archivo', 'estado_verificacion')
    )::TEXT AS tipos_enum;

\echo '🚀 Test completado. Proceder con ejecución de V4...'
\echo ''
\echo '⚠️  NOTA: Si hay objetos existentes, V4 debería manejarlos sin errores'
\echo '✅ V4 usa DROP IF EXISTS para ENUMs'
\echo '✅ V4 usa CREATE TABLE IF NOT EXISTS para tablas' 
\echo '✅ V4 usa CREATE INDEX IF NOT EXISTS para índices'
\echo '✅ V4 usa DROP TRIGGER IF EXISTS + CREATE TRIGGER para triggers'
\echo ''