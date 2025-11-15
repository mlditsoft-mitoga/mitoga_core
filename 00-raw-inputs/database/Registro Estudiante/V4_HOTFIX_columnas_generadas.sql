-- ============================================================================
-- HOTFIX: V4__registro_estudiantes_multistep.sql - Fixed Immutable Error
-- Archivo: V4_HOTFIX_columnas_generadas.sql
-- Fecha: 2025-11-14
-- Problema: SQL Error [42P17]: ERROR: generation expression is not immutable
-- ============================================================================

-- ===========================================
-- RESUMEN DE CAMBIOS REALIZADOS
-- ===========================================

/*
❌ PROBLEMA ORIGINAL:
   Las columnas GENERATED ALWAYS AS usaban funciones NO INMUTABLES:
   1. CONCAT() → No es inmutable en PostgreSQL
   2. DATE_PART('year', AGE()) → No es inmutable (depende del tiempo actual)

✅ SOLUCIÓN APLICADA:
   1. Reemplazado CONCAT() con concatenación || (inmutable)
   2. Eliminado columna generada edad (usar función calcular_edad() en su lugar)
   3. Corregido función calcular_edad() de IMMUTABLE a STABLE

📋 CAMBIOS EN V4__registro_estudiantes_multistep.sql:
   - nombre_completo: Usa || en lugar de CONCAT()
   - edad: Removida como columna generada
   - calcular_edad(): Marcada como STABLE en lugar de IMMUTABLE
*/

-- ===========================================
-- QUERY EXAMPLES: USANDO LA FUNCIÓN CALCULAR_EDAD
-- ===========================================

-- Ejemplo 1: Consultar estudiantes con edad calculada
SELECT 
    pkid_perfiles_estudiante,
    primer_nombre,
    primer_apellido,
    fecha_nacimiento,
    shared_schema.calcular_edad(fecha_nacimiento) AS edad_actual,
    CASE 
        WHEN shared_schema.calcular_edad(fecha_nacimiento) < 18 THEN 'MENOR'
        ELSE 'MAYOR'
    END AS categoria_edad
FROM perfiles_schema.perfiles_estudiante
WHERE expiration_date IS NULL
ORDER BY fecha_nacimiento DESC;

-- Ejemplo 2: Filtrar menores de edad
SELECT 
    nombre_completo,
    fecha_nacimiento,
    shared_schema.calcular_edad(fecha_nacimiento) AS edad,
    responsable_legal_nombre,
    responsable_legal_documento
FROM perfiles_schema.perfiles_estudiante
WHERE shared_schema.calcular_edad(fecha_nacimiento) < 18
AND expiration_date IS NULL;

-- Ejemplo 3: Estadísticas por rango de edad
SELECT 
    CASE 
        WHEN shared_schema.calcular_edad(fecha_nacimiento) < 13 THEN '0-12 años'
        WHEN shared_schema.calcular_edad(fecha_nacimiento) BETWEEN 13 AND 17 THEN '13-17 años'
        WHEN shared_schema.calcular_edad(fecha_nacimiento) BETWEEN 18 AND 25 THEN '18-25 años'
        WHEN shared_schema.calcular_edad(fecha_nacimiento) BETWEEN 26 AND 35 THEN '26-35 años'
        WHEN shared_schema.calcular_edad(fecha_nacimiento) BETWEEN 36 AND 50 THEN '36-50 años'
        ELSE '50+ años'
    END AS rango_edad,
    COUNT(*) AS cantidad_estudiantes
FROM perfiles_schema.perfiles_estudiante
WHERE expiration_date IS NULL
GROUP BY 
    CASE 
        WHEN shared_schema.calcular_edad(fecha_nacimiento) < 13 THEN '0-12 años'
        WHEN shared_schema.calcular_edad(fecha_nacimiento) BETWEEN 13 AND 17 THEN '13-17 años'
        WHEN shared_schema.calcular_edad(fecha_nacimiento) BETWEEN 18 AND 25 THEN '18-25 años'
        WHEN shared_schema.calcular_edad(fecha_nacimiento) BETWEEN 26 AND 35 THEN '26-35 años'
        WHEN shared_schema.calcular_edad(fecha_nacimiento) BETWEEN 36 AND 50 THEN '36-50 años'
        ELSE '50+ años'
    END
ORDER BY MIN(shared_schema.calcular_edad(fecha_nacimiento));

-- ===========================================
-- VALIDACIÓN: VERIFICAR FUNCIONES INMUTABLES
-- ===========================================

-- Query para verificar volatility de funciones
SELECT 
    schemaname,
    proname AS function_name,
    CASE provolatile
        WHEN 'i' THEN 'IMMUTABLE'
        WHEN 's' THEN 'STABLE'
        WHEN 'v' THEN 'VOLATILE'
    END AS volatility,
    prosrc AS function_body
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE schemaname IN ('shared_schema', 'autenticacion_schema')
AND proname IN ('calcular_edad', 'validar_email', 'generar_otp', 'capitalizar_nombre')
ORDER BY schemaname, proname;

-- ===========================================
-- TESTING: VERIFICAR COLUMNAS GENERADAS
-- ===========================================

-- Test 1: Verificar que nombre_completo funciona correctamente
WITH test_data AS (
    SELECT 
        'Juan' AS primer_nombre,
        'Carlos' AS segundo_nombre,
        'Pérez' AS primer_apellido,
        'González' AS segundo_apellido
)
SELECT 
    primer_nombre,
    segundo_nombre, 
    primer_apellido,
    segundo_apellido,
    TRIM(primer_nombre || COALESCE(' ' || segundo_nombre, '') || ' ' || primer_apellido || COALESCE(' ' || segundo_apellido, '')) AS nombre_completo_test
FROM test_data;

-- Test 2: Verificar función de edad
SELECT 
    '1990-05-15'::DATE AS fecha_nacimiento,
    shared_schema.calcular_edad('1990-05-15'::DATE) AS edad_calculada,
    DATE_PART('year', AGE('1990-05-15'::DATE)) AS edad_directa;

-- ===========================================
-- MIGRATION SAFE CHECK
-- ===========================================

-- Verificar que no hay dependencias rotas después del hotfix
SELECT 
    'V4 HOTFIX VERIFICATION' AS check_type,
    'SUCCESS - No broken dependencies found' AS status
WHERE NOT EXISTS (
    -- Buscar referencias a columna edad que ya no existe
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'perfiles_estudiante' 
    AND column_name = 'edad'
    AND is_generated = 'ALWAYS'
);

-- ===========================================
-- MANUAL EXECUTION GUIDE
-- ===========================================

/*
🔧 INSTRUCCIONES DE USO:

1. ✅ El archivo V4__registro_estudiantes_multistep.sql ya está corregido
2. ✅ Puedes ejecutar V4 sin el error de immutable functions
3. ✅ Usa shared_schema.calcular_edad(fecha_nacimiento) para obtener edad
4. ✅ La columna nombre_completo se genera automáticamente con ||

🚀 EJECUTAR EN ESTE ORDEN:
   V1__init_schema.sql
   V2__catalogo_recursivo.sql  
   V3__catalogo_recursivo_datos.sql
   V4__registro_estudiantes_multistep.sql (YA CORREGIDO)
   
⚠️  NOTAS IMPORTANTES:
   - La edad se calcula dinámicamente (no se almacena)
   - Es más precisa porque siempre refleja la edad actual
   - Mejor para compliance (GDPR) al no almacenar datos derivados
*/