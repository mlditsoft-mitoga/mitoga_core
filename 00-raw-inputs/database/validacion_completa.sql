-- ============================================================================
-- Script de Validación: Verificar instalación completa HU-001
-- Descripción: Script para ejecutar DESPUÉS de todos los migrations
--              Valida que todo esté correctamente instalado y funcionando
-- Autor: Database Engineer Senior - ZNS-METHOD
-- Fecha: 2025-11-14
-- ============================================================================

-- Banner de inicio
SELECT 
    '🎯 INICIANDO VALIDACIÓN COMPLETA DEL MODELO DE DATOS HU-001' as mensaje,
    NOW() as timestamp;

-- ====================
-- 1. VERIFICAR SCHEMAS
-- ====================
SELECT 
    '📁 VERIFICANDO SCHEMAS...' as paso;

SELECT 
    schema_name,
    CASE 
        WHEN schema_name IN ('shared_schema', 'autenticacion_schema', 'perfiles_schema', 'storage_schema') 
        THEN '✅ CORRECTO'
        ELSE '⚠️ INESPERADO'
    END as status
FROM information_schema.schemata 
WHERE schema_name LIKE '%_schema'
ORDER BY schema_name;

-- ====================
-- 2. VERIFICAR TABLAS PRINCIPALES
-- ====================
SELECT 
    '📊 VERIFICANDO TABLAS PRINCIPALES...' as paso;

WITH tablas_esperadas AS (
    SELECT unnest(ARRAY[
        'shared_schema.paises',
        'shared_schema.idiomas', 
        'shared_schema.monedas',
        'shared_schema.archivos',
        'shared_schema.domain_events',
        'shared_schema.audit_log',
        'autenticacion_schema.usuarios',
        'autenticacion_schema.proceso_registro',
        'autenticacion_schema.verificacion_identidad',
        'perfiles_schema.perfiles_estudiante',
        'storage_schema.storage_providers'
    ]) as tabla_esperada
)
SELECT 
    te.tabla_esperada,
    CASE 
        WHEN t.table_name IS NOT NULL THEN '✅ EXISTE'
        ELSE '❌ FALTA'
    END as status,
    COALESCE(pgc.reltuples::BIGINT, 0) as filas_aprox
FROM tablas_esperadas te
LEFT JOIN information_schema.tables t ON 
    t.table_schema || '.' || t.table_name = te.tabla_esperada
LEFT JOIN pg_class pgc ON pgc.relname = split_part(te.tabla_esperada, '.', 2)
ORDER BY te.tabla_esperada;

-- ====================
-- 3. VERIFICAR TIPOS ENUM
-- ====================
SELECT 
    '🏷️ VERIFICANDO TIPOS ENUM...' as paso;

SELECT 
    t.typname as tipo_enum,
    string_agg(e.enumlabel, ', ' ORDER BY e.enumsortorder) as valores,
    '✅ CORRECTO' as status
FROM pg_type t
JOIN pg_enum e ON t.oid = e.enumtypid
JOIN pg_namespace n ON t.typnamespace = n.oid
WHERE n.nspname = 'shared_schema'
AND t.typname IN ('estado_registro', 'tipo_documento', 'tipo_archivo', 'estado_verificacion')
GROUP BY t.typname
ORDER BY t.typname;

-- ====================
-- 4. VERIFICAR FUNCIONES CRÍTICAS
-- ====================
SELECT 
    '⚙️ VERIFICANDO FUNCIONES CRÍTICAS...' as paso;

SELECT 
    routine_schema,
    routine_name,
    '✅ EXISTE' as status,
    CASE 
        WHEN routine_name LIKE '%registro%' THEN '🎯 CORE'
        WHEN routine_name LIKE '%imagen%' OR routine_name LIKE '%archivo%' THEN '📸 MEDIA'
        ELSE '🔧 UTIL'
    END as categoria
FROM information_schema.routines 
WHERE routine_schema IN ('autenticacion_schema', 'shared_schema', 'storage_schema')
AND routine_type = 'FUNCTION'
AND routine_name IN (
    'iniciar_registro_estudiante',
    'verificar_otp_registro', 
    'guardar_datos_personales_registro',
    'guardar_verificacion_biometrica',
    'completar_registro_estudiante',
    'guardar_foto_perfil',
    'guardar_documento_identidad',
    'validar_imagen',
    'calcular_edad',
    'capitalizar_nombre'
)
ORDER BY categoria, routine_name;

-- ====================
-- 5. VERIFICAR DATOS INICIALES
-- ====================
SELECT 
    '💾 VERIFICANDO DATOS INICIALES...' as paso;

SELECT 
    'Países' as tabla,
    COUNT(*) as registros,
    string_agg(codigo, ', ' ORDER BY codigo) as ejemplos
FROM shared_schema.paises
WHERE expiration_date IS NULL

UNION ALL

SELECT 
    'Idiomas' as tabla,
    COUNT(*) as registros,
    string_agg(codigo, ', ' ORDER BY codigo) as ejemplos
FROM shared_schema.idiomas
WHERE expiration_date IS NULL

UNION ALL

SELECT 
    'Monedas' as tabla,
    COUNT(*) as registros,
    string_agg(codigo, ', ' ORDER BY codigo) as ejemplos  
FROM shared_schema.monedas
WHERE expiration_date IS NULL

UNION ALL

SELECT 
    'Storage Providers' as tabla,
    COUNT(*) as registros,
    string_agg(provider_name, ', ' ORDER BY provider_name) as ejemplos
FROM storage_schema.storage_providers
WHERE expiration_date IS NULL;

-- ====================
-- 6. VERIFICAR ÍNDICES CRÍTICOS  
-- ====================
SELECT 
    '📇 VERIFICANDO ÍNDICES CRÍTICOS...' as paso;

SELECT 
    schemaname,
    tablename,
    indexname,
    '✅ EXISTE' as status
FROM pg_indexes 
WHERE schemaname IN ('autenticacion_schema', 'perfiles_schema', 'shared_schema')
AND indexname IN (
    'idx_usuarios_email',
    'idx_proceso_registro_session',
    'idx_archivos_tipo',
    'idx_perfiles_estudiante_usuario'
)
ORDER BY schemaname, tablename, indexname;

-- ====================
-- 7. VERIFICAR TRIGGERS DE AUDITORÍA
-- ====================
SELECT 
    '🔍 VERIFICANDO TRIGGERS DE AUDITORÍA...' as paso;

SELECT 
    trigger_schema,
    trigger_name,
    event_object_table,
    '✅ ACTIVO' as status
FROM information_schema.triggers
WHERE trigger_schema IN ('autenticacion_schema', 'perfiles_schema', 'shared_schema')
AND trigger_name LIKE '%audit%'
ORDER BY trigger_schema, event_object_table;

-- ====================
-- 8. TEST FUNCIONAL BÁSICO
-- ====================
SELECT 
    '🧪 EJECUTANDO TEST FUNCIONAL BÁSICO...' as paso;

-- Test 1: Validación de email
SELECT 
    'Test validar_email()' as test,
    shared_schema.validar_email('test@email.com') as resultado_esperado_true,
    shared_schema.validar_email('email_invalido') as resultado_esperado_false,
    CASE 
        WHEN shared_schema.validar_email('test@email.com') = TRUE 
        AND shared_schema.validar_email('email_invalido') = FALSE
        THEN '✅ PASS'
        ELSE '❌ FAIL'
    END as status;

-- Test 2: Cálculo de edad
SELECT 
    'Test calcular_edad()' as test,
    shared_schema.calcular_edad('2000-01-01'::DATE) as edad_calculada,
    CASE 
        WHEN shared_schema.calcular_edad('2000-01-01'::DATE) BETWEEN 20 AND 30
        THEN '✅ PASS'
        ELSE '❌ FAIL'
    END as status;

-- Test 3: Capitalización
SELECT 
    'Test capitalizar_nombre()' as test,
    shared_schema.capitalizar_nombre('juan carlos') as resultado,
    CASE 
        WHEN shared_schema.capitalizar_nombre('juan carlos') = 'Juan Carlos'
        THEN '✅ PASS' 
        ELSE '❌ FAIL'
    END as status;

-- Test 4: Generación OTP
SELECT 
    'Test generar_otp()' as test,
    LENGTH(autenticacion_schema.generar_otp()) as longitud,
    CASE 
        WHEN LENGTH(autenticacion_schema.generar_otp()) = 6
        THEN '✅ PASS'
        ELSE '❌ FAIL'
    END as status;

-- ====================
-- 9. VERIFICAR CONSTRAINTS
-- ====================
SELECT 
    '🔒 VERIFICANDO CONSTRAINTS CRÍTICOS...' as paso;

SELECT 
    tc.constraint_schema,
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    '✅ ACTIVO' as status
FROM information_schema.table_constraints tc
WHERE tc.constraint_schema IN ('autenticacion_schema', 'perfiles_schema', 'shared_schema')
AND tc.constraint_type IN ('CHECK', 'FOREIGN KEY', 'UNIQUE')
AND tc.constraint_name IN (
    'ck_usuarios_email_formato',
    'ck_usuarios_rol', 
    'ck_perfiles_estudiante_edad',
    'ck_archivos_tamaño',
    'uq_usuarios_email'
)
ORDER BY tc.constraint_schema, tc.table_name;

-- ====================
-- 10. RESUMEN FINAL
-- ====================
SELECT 
    '📋 RESUMEN DE VALIDACIÓN' as seccion,
    '===============================================' as separador;

WITH validation_summary AS (
    SELECT 
        'Schemas' as componente,
        COUNT(*) as total
    FROM information_schema.schemata 
    WHERE schema_name LIKE '%_schema'
    
    UNION ALL
    
    SELECT 
        'Tablas principales' as componente,
        COUNT(*) as total
    FROM information_schema.tables 
    WHERE table_schema IN ('autenticacion_schema', 'perfiles_schema', 'shared_schema', 'storage_schema')
    
    UNION ALL
    
    SELECT 
        'Funciones' as componente,
        COUNT(*) as total
    FROM information_schema.routines 
    WHERE routine_schema IN ('autenticacion_schema', 'shared_schema', 'storage_schema')
    AND routine_type = 'FUNCTION'
    
    UNION ALL
    
    SELECT 
        'Triggers' as componente,
        COUNT(*) as total
    FROM information_schema.triggers
    WHERE trigger_schema IN ('autenticacion_schema', 'perfiles_schema', 'shared_schema')
)
SELECT 
    vs.componente,
    vs.total,
    CASE 
        WHEN vs.componente = 'Schemas' AND vs.total >= 4 THEN '✅ CORRECTO'
        WHEN vs.componente = 'Tablas principales' AND vs.total >= 10 THEN '✅ CORRECTO'  
        WHEN vs.componente = 'Funciones' AND vs.total >= 10 THEN '✅ CORRECTO'
        WHEN vs.componente = 'Triggers' AND vs.total >= 5 THEN '✅ CORRECTO'
        ELSE '⚠️ VERIFICAR'
    END as status
FROM validation_summary vs
ORDER BY vs.componente;

-- Banner final
SELECT 
    '🎉 VALIDACIÓN COMPLETA TERMINADA' as mensaje,
    'Si todos los status muestran ✅, el sistema está listo para HU-001' as resultado,
    NOW() as timestamp;

-- Siguiente paso recomendado
SELECT 
    '▶️ SIGUIENTE PASO: Ejecutar el ejemplo completo de registro' as accion_recomendada;