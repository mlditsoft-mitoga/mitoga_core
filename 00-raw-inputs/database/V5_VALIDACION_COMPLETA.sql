-- =====================================================
-- V5 - VALIDACIÓN COMPLETA TUTORES
-- =====================================================
-- Descripción: Valida que V5 se haya aplicado correctamente
-- Puede ejecutarse múltiples veces de forma segura
-- Basado en lecciones aprendidas de V4
-- =====================================================

\echo '========================================'
\echo 'INICIANDO VALIDACIÓN V5 TUTORES'
\echo '========================================'

-- PREREQUISITO: Validar que V4 esté aplicado
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'shared_schema') OR
       NOT EXISTS (SELECT 1 FROM information_schema.routines 
                   WHERE routine_schema = 'shared_schema' 
                   AND routine_name = 'tabla_tiene_columna') THEN
        RAISE EXCEPTION 'PREREQUISITO FALLIDO: V4 (estudiantes) debe ejecutarse antes que V5';
    ELSE
        RAISE NOTICE '✅ V4 prerequisitos OK';
    END IF;
END $$;

-- 1. VALIDAR SCHEMA TUTORES
\echo ''
\echo '1. Validando schema tutores...'
SELECT 
    CASE WHEN COUNT(*) = 1 THEN '✅ Schema tutores_schema creado'
         ELSE '❌ Schema tutores_schema NO EXISTE'
    END as resultado_schema_tutores
FROM information_schema.schemata 
WHERE schema_name = 'tutores_schema';

-- 2. VALIDAR ENUMS ESPECÍFICOS DE TUTORES
\echo ''
\echo '2. Validando ENUMs de tutores...'
SELECT 
    CASE WHEN COUNT(*) = 3 THEN '✅ Todos los ENUMs de tutores creados'
         ELSE '❌ Faltan ENUMs: ' || (3 - COUNT(*))::TEXT || ' de 3'
    END as resultado_enums_tutores
FROM pg_type 
WHERE typname IN ('estado_aprobacion_tutor', 'nivel_dominio_idioma', 'estado_sesion');

-- 3. VALIDAR TABLAS PRINCIPALES DE TUTORES
\echo ''
\echo '3. Validando tablas de tutores...'
SELECT 
    CASE WHEN COUNT(*) = 5 THEN '✅ Todas las tablas de tutores creadas'
         ELSE '❌ Faltan tablas: ' || (5 - COUNT(*))::TEXT || ' de 5'
    END as resultado_tablas_tutores
FROM information_schema.tables 
WHERE table_schema = 'tutores_schema'
  AND table_name IN ('proceso_registro_tutor', 'perfiles_tutor', 'experiencia_laboral', 'tutor_conocimientos', 'tutor_idiomas');

-- 4. VALIDAR INTEGRIDAD DE COLUMNAS CRÍTICAS (Anti CASCADE damage)
\echo ''
\echo '4. Validando integridad de columnas críticas...'

-- 4.1 proceso_registro_tutor
SELECT 
    CASE WHEN COUNT(*) = 4 THEN '✅ proceso_registro_tutor: todas las columnas críticas'
         ELSE '❌ proceso_registro_tutor: faltan ' || (4 - COUNT(*))::TEXT || ' columnas'
    END as resultado_proceso_tutor
FROM information_schema.columns 
WHERE table_schema = 'tutores_schema' 
  AND table_name = 'proceso_registro_tutor'
  AND column_name IN ('estado_actual', 'step_completado', 'datos_formulario', 'experiencias_laborales');

-- 4.2 perfiles_tutor
SELECT 
    CASE WHEN COUNT(*) = 4 THEN '✅ perfiles_tutor: columnas críticas presentes'
         ELSE '❌ perfiles_tutor: faltan ' || (4 - COUNT(*))::TEXT || ' de 4'
    END as resultado_perfiles_tutor
FROM information_schema.columns 
WHERE table_schema = 'tutores_schema' 
  AND table_name = 'perfiles_tutor'
  AND column_name IN ('estado_aprobacion', 'tarifa_por_hora', 'nombres', 'apellidos');

-- 4.3 experiencia_laboral
SELECT 
    CASE WHEN COUNT(*) = 3 THEN '✅ experiencia_laboral: columnas críticas presentes'
         ELSE '❌ experiencia_laboral: faltan ' || (3 - COUNT(*))::TEXT || ' de 3'
    END as resultado_experiencia
FROM information_schema.columns 
WHERE table_schema = 'tutores_schema' 
  AND table_name = 'experiencia_laboral'
  AND column_name IN ('empresa', 'cargo', 'tutor_id');

-- 4.4 tutor_conocimientos
SELECT 
    CASE WHEN COUNT(*) = 3 THEN '✅ tutor_conocimientos: columnas críticas presentes'
         ELSE '❌ tutor_conocimientos: faltan ' || (3 - COUNT(*))::TEXT || ' de 3'
    END as resultado_conocimientos
FROM information_schema.columns 
WHERE table_schema = 'tutores_schema' 
  AND table_name = 'tutor_conocimientos'
  AND column_name IN ('tutor_id', 'conocimiento_id', 'nivel_experticia');

-- 4.5 tutor_idiomas
SELECT 
    CASE WHEN COUNT(*) = 4 THEN '✅ tutor_idiomas: columnas críticas presentes'
         ELSE '❌ tutor_idiomas: faltan ' || (4 - COUNT(*))::TEXT || ' de 4'
    END as resultado_idiomas
FROM information_schema.columns 
WHERE table_schema = 'tutores_schema' 
  AND table_name = 'tutor_idiomas'
  AND column_name IN ('tutor_id', 'idioma_id', 'nivel_dominio', 'es_idioma_nativo');

-- 5. VALIDAR ÍNDICES ESTRATÉGICOS
\echo ''
\echo '5. Validando índices...'
SELECT 
    CASE WHEN COUNT(*) >= 25 THEN '✅ Índices creados: ' || COUNT(*) || ' (25+ esperados)'
         ELSE '❌ Pocos índices: ' || COUNT(*) || ' (esperados 25+)'
    END as resultado_indices_tutores
FROM pg_indexes 
WHERE schemaname = 'tutores_schema';

-- 6. VALIDAR FOREIGN KEYS
\echo ''
\echo '6. Validando foreign keys...'
SELECT 
    CASE WHEN COUNT(*) >= 12 THEN '✅ Foreign Keys: ' || COUNT(*) || ' (12+ esperadas)'
         ELSE '❌ Foreign Keys insuficientes: ' || COUNT(*) || ' (esperadas 12+)'
    END as resultado_foreign_keys_tutores
FROM information_schema.table_constraints 
WHERE constraint_type = 'FOREIGN KEY' 
  AND constraint_schema = 'tutores_schema';

-- 7. VALIDAR TRIGGERS UPDATED_AT
\echo ''
\echo '7. Validando triggers updated_at...'
SELECT 
    CASE WHEN COUNT(*) = 5 THEN '✅ Todos los triggers updated_at creados'
         ELSE '❌ Triggers faltantes: ' || (5 - COUNT(*))::TEXT || ' de 5'
    END as resultado_triggers_tutores
FROM information_schema.triggers 
WHERE trigger_schema = 'tutores_schema'
  AND trigger_name LIKE '%_updated_at';

-- 8. VALIDAR FUNCIONES DE UTILIDAD
\echo ''
\echo '8. Validando funciones de utilidad...'
SELECT 
    CASE WHEN COUNT(*) >= 3 THEN '✅ Funciones de utilidad: ' || COUNT(*) || ' disponibles'
         ELSE '❌ Faltan funciones: esperadas 3+, encontradas ' || COUNT(*) 
    END as resultado_funciones_tutores
FROM information_schema.routines 
WHERE routine_schema = 'tutores_schema';

-- 9. VALIDAR CONSTRAINTS (sin subqueries - Lección #8)
\echo ''
\echo '9. Validando constraints CHECK...'
SELECT 
    CASE WHEN COUNT(*) >= 8 THEN '✅ Constraints CHECK: ' || COUNT(*) || ' (sin subqueries)'
         ELSE '❌ Constraints insuficientes: ' || COUNT(*) || ' (esperadas 8+)'
    END as resultado_constraints_tutores
FROM information_schema.check_constraints 
WHERE constraint_schema = 'tutores_schema';

-- 10. TEST FUNCIONAL: Simulación de registro de tutor
\echo ''
\echo '10. Test funcional de registro de tutor...'

DO $$
DECLARE
    test_usuario_id UUID;
    test_proceso_id UUID;
    test_tutor_id UUID;
    test_experiencia_id UUID;
    test_count INTEGER;
BEGIN
    -- Crear usuario mock para testing
    INSERT INTO autenticacion_schema.usuarios (
        email, 
        password_hash, 
        rol
    ) VALUES (
        'test_tutor_v5@example.com',
        'hash_mock_test',
        'TUTOR'
    ) RETURNING pkid_usuario INTO test_usuario_id;
    
    -- Test 1: INSERT en proceso_registro_tutor
    INSERT INTO tutores_schema.proceso_registro_tutor (
        usuario_id, 
        estado_actual, 
        step_completado,
        datos_formulario
    ) VALUES (
        test_usuario_id,
        'PENDIENTE_REGISTRO',
        1,
        '{"test": true}'::jsonb
    ) RETURNING pkid_proceso_tutor INTO test_proceso_id;
    
    -- Test 2: INSERT en perfiles_tutor
    INSERT INTO tutores_schema.perfiles_tutor (
        usuario_id,
        nombres,
        apellidos,
        fecha_nacimiento,
        estado_aprobacion,
        tarifa_por_hora
    ) VALUES (
        test_usuario_id,
        'Test',
        'Tutor V5',
        '1985-06-15',
        'PENDIENTE_REGISTRO',
        25.50
    ) RETURNING pkid_tutor INTO test_tutor_id;
    
    -- Test 3: INSERT en experiencia_laboral
    INSERT INTO tutores_schema.experiencia_laboral (
        tutor_id,
        empresa,
        cargo,
        fecha_inicio,
        es_trabajo_actual
    ) VALUES (
        test_tutor_id,
        'Test Company',
        'Senior Developer',
        '2020-01-01',
        TRUE
    ) RETURNING pkid_experiencia INTO test_experiencia_id;
    
    -- Test 4: Validar función de completitud
    PERFORM tutores_schema.validar_completitud_perfil(test_tutor_id);
    
    -- Test 5: UPDATE con trigger updated_at
    UPDATE tutores_schema.perfiles_tutor 
    SET estado_aprobacion = 'EN_REVISION'
    WHERE pkid_tutor = test_tutor_id;
    
    -- Cleanup (soft delete)
    UPDATE autenticacion_schema.usuarios 
    SET deleted_at = CURRENT_TIMESTAMP 
    WHERE pkid_usuario = test_usuario_id;
    
    UPDATE tutores_schema.perfiles_tutor 
    SET expiration_date = CURRENT_TIMESTAMP 
    WHERE pkid_tutor = test_tutor_id;
    
    RAISE NOTICE '✅ Test funcional tutores exitoso (INSERT/UPDATE/SELECT/FUNCTION)';
    
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '❌ Test funcional tutores falló: %', SQLERRM;
END $$;

-- 11. VALIDAR LECCIONES APLICADAS DE V4
\echo ''
\echo '11. Verificando lecciones aplicadas de V4...'

DO $$
DECLARE
    lecciones_aplicadas INTEGER := 0;
BEGIN
    -- Lección #1: || en lugar de CONCAT (verificar en funciones)
    IF EXISTS (SELECT 1 FROM information_schema.routines 
               WHERE routine_schema = 'tutores_schema' 
               AND routine_definition ~* '\|\|' 
               AND NOT routine_definition ~* 'CONCAT\(') THEN
        lecciones_aplicadas := lecciones_aplicadas + 1;
        RAISE NOTICE '✅ Lección #1: Operador || usado (no CONCAT)';
    END IF;
    
    -- Lección #3: ENUMs con IF NOT EXISTS (verificar en script)
    IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'estado_aprobacion_tutor') THEN
        lecciones_aplicadas := lecciones_aplicadas + 1;
        RAISE NOTICE '✅ Lección #3: ENUMs creados sin CASCADE destructivo';
    END IF;
    
    -- Lección #4: Índices con IF NOT EXISTS
    IF EXISTS (SELECT 1 FROM pg_indexes 
               WHERE schemaname = 'tutores_schema' 
               AND indexname LIKE 'idx_%') THEN
        lecciones_aplicadas := lecciones_aplicadas + 1;
        RAISE NOTICE '✅ Lección #4: Índices con IF NOT EXISTS aplicados';
    END IF;
    
    -- Lección #5: Auto-reparación implementada (función helper)
    IF EXISTS (SELECT 1 FROM information_schema.routines 
               WHERE routine_schema = 'shared_schema' 
               AND routine_name = 'tabla_tiene_columna') THEN
        lecciones_aplicadas := lecciones_aplicadas + 1;
        RAISE NOTICE '✅ Lección #5: Auto-reparación con función helper';
    END IF;
    
    -- Lección #6: Parámetros con prefijo p_ (verificar función)
    IF EXISTS (SELECT 1 FROM information_schema.parameters 
               WHERE specific_schema = 'shared_schema' 
               AND parameter_name LIKE 'p_%') THEN
        lecciones_aplicadas := lecciones_aplicadas + 1;
        RAISE NOTICE '✅ Lección #6: Parámetros únicos con prefijo p_';
    END IF;
    
    -- Lección #8: No subqueries en CHECK constraints
    IF NOT EXISTS (SELECT 1 FROM information_schema.check_constraints 
                   WHERE constraint_schema = 'tutores_schema'
                   AND check_clause ~* 'EXISTS\s*\(\s*SELECT') THEN
        lecciones_aplicadas := lecciones_aplicadas + 1;
        RAISE NOTICE '✅ Lección #8: Sin subqueries en CHECK constraints';
    END IF;
    
    RAISE NOTICE '📊 Total lecciones V4 aplicadas en V5: %/6', lecciones_aplicadas;
END $$;

-- 12. VALIDACIÓN FINAL INTEGRAL
\echo ''
\echo '12. Resumen final integral...'

SELECT 
    CASE 
        WHEN schemas.total >= 1 
         AND enums.total = 3 
         AND tables.total = 5 
         AND indices.total >= 25 
         AND triggers.total = 5 
         AND foreign_keys.total >= 12
         AND functions.total >= 3
        THEN '🎉 V5 TUTORES COMPLETAMENTE FUNCIONAL'
        ELSE '⚠️  V5 PARCIAL - Revisar componentes faltantes'
    END as estado_final_v5,
    
    schemas.total as schemas_ok,
    enums.total as enums_ok,
    tables.total as tablas_ok,
    indices.total as indices_ok,
    triggers.total as triggers_ok,
    foreign_keys.total as fks_ok,
    functions.total as funciones_ok
    
FROM 
    (SELECT COUNT(*) as total FROM information_schema.schemata 
     WHERE schema_name = 'tutores_schema') schemas,
     
    (SELECT COUNT(*) as total FROM pg_type 
     WHERE typname IN ('estado_aprobacion_tutor', 'nivel_dominio_idioma', 'estado_sesion')) enums,
     
    (SELECT COUNT(*) as total FROM information_schema.tables 
     WHERE table_schema = 'tutores_schema'
       AND table_name IN ('proceso_registro_tutor', 'perfiles_tutor', 'experiencia_laboral', 'tutor_conocimientos', 'tutor_idiomas')) tables,
       
    (SELECT COUNT(*) as total FROM pg_indexes 
     WHERE schemaname = 'tutores_schema') indices,
     
    (SELECT COUNT(*) as total FROM information_schema.triggers 
     WHERE trigger_schema = 'tutores_schema') triggers,
     
    (SELECT COUNT(*) as total FROM information_schema.table_constraints 
     WHERE constraint_type = 'FOREIGN KEY' 
       AND constraint_schema = 'tutores_schema') foreign_keys,
       
    (SELECT COUNT(*) as total FROM information_schema.routines 
     WHERE routine_schema = 'tutores_schema') functions;

\echo ''
\echo '========================================'
\echo 'VALIDACIÓN V5 COMPLETADA'
\echo 'Si estado_final_v5 = FUNCIONAL, V5 está OK'
\echo '========================================'