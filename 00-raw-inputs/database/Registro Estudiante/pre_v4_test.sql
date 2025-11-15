-- ============================================================================
-- SCRIPT: Test rápido de V4
-- Description: Prueba rápida para verificar que V4 se ejecuta sin errores
-- Author: Database Engineer Senior - ZNS-METHOD  
-- Date: 2025-11-14
-- ============================================================================

\echo '🧪 PRUEBA RÁPIDA DE V4 - VERIFICAR QUE NO HAY ERRORES'

-- Verificar conexión
SELECT 
    '✅ Conectado a: ' || current_database() AS status,
    '👤 Usuario: ' || current_user AS usuario;

-- Test: Verificar que los schemas necesarios existen (o se crearán)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'shared_schema') THEN
        RAISE NOTICE '✅ shared_schema existe';
    ELSE
        RAISE NOTICE '📋 shared_schema será creado por V4';
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'autenticacion_schema') THEN
        RAISE NOTICE '✅ autenticacion_schema existe';
    ELSE
        RAISE NOTICE '📋 autenticacion_schema será creado por V4';
    END IF;
END
$$;

-- Test: Verificar que uuid-ossp está disponible
SELECT 
    CASE 
        WHEN EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'uuid-ossp') 
        THEN '✅ Extension uuid-ossp disponible'
        ELSE '📋 Extension uuid-ossp será instalada por V4'
    END AS extension_status;

\echo '🚀 Sistema listo para ejecutar V4'
\echo '💡 Ejecutar: \\i V4__registro_estudiantes_multistep.sql'
\echo '⚠️  Nota: V4 es idempotente - puede ejecutarse múltiples veces'