-- ═══════════════════════════════════════════════════════════════════════════════
-- SCRIPT DE DIAGNÓSTICO: Verificar estado de funciones catalogo_*
-- ═══════════════════════════════════════════════════════════════════════════════
-- PROPÓSITO: Identificar qué funciones existen y en qué esquemas
-- EJECUTAR EN: DBeaver conectado a mitogadb
-- ═══════════════════════════════════════════════════════════════════════════════

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASO 1: Listar TODAS las funciones relacionadas con 'catalogo'
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT 
    n.nspname AS esquema,
    p.proname AS nombre_funcion,
    pg_get_function_identity_arguments(p.oid) AS argumentos,
    pg_get_functiondef(p.oid) AS definicion_completa
FROM pg_proc p
INNER JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE p.proname LIKE 'catalogo_%'
ORDER BY n.nspname, p.proname;

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASO 2: Verificar específicamente las 3 funciones que necesitamos
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT 
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM pg_proc p
            INNER JOIN pg_namespace n ON p.pronamespace = n.oid
            WHERE n.nspname = 'appmatch_schema' 
            AND p.proname = 'catalogo_obtener_arbol'
        ) THEN '✅ EXISTE'
        ELSE '❌ NO EXISTE'
    END AS estado_catalogo_obtener_arbol,
    
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM pg_proc p
            INNER JOIN pg_namespace n ON p.pronamespace = n.oid
            WHERE n.nspname = 'appmatch_schema' 
            AND p.proname = 'catalogo_obtener_ancestros'
        ) THEN '✅ EXISTE'
        ELSE '❌ NO EXISTE'
    END AS estado_catalogo_obtener_ancestros,
    
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM pg_proc p
            INNER JOIN pg_namespace n ON p.pronamespace = n.oid
            WHERE n.nspname = 'appmatch_schema' 
            AND p.proname = 'catalogo_obtener_descendientes'
        ) THEN '✅ EXISTE'
        ELSE '❌ NO EXISTE'
    END AS estado_catalogo_obtener_descendientes;

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASO 3: Verificar si existen funciones en shared_schema (antiguas)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT 
    n.nspname AS esquema,
    p.proname AS nombre_funcion,
    pg_get_function_identity_arguments(p.oid) AS argumentos
FROM pg_proc p
INNER JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'shared_schema' 
  AND p.proname LIKE 'catalogo_%'
ORDER BY p.proname;

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASO 4: Ver la definición completa de catalogo_obtener_arbol si existe
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DO $$
DECLARE
    v_definicion TEXT;
BEGIN
    SELECT pg_get_functiondef(p.oid) INTO v_definicion
    FROM pg_proc p
    INNER JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname = 'appmatch_schema' 
      AND p.proname = 'catalogo_obtener_arbol'
    LIMIT 1;
    
    IF v_definicion IS NOT NULL THEN
        RAISE NOTICE '════════════════════════════════════════════════════════════════';
        RAISE NOTICE 'DEFINICIÓN DE catalogo_obtener_arbol:';
        RAISE NOTICE '════════════════════════════════════════════════════════════════';
        RAISE NOTICE '%', v_definicion;
    ELSE
        RAISE NOTICE '❌ La función catalogo_obtener_arbol NO EXISTE en appmatch_schema';
    END IF;
END $$;

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- RESULTADO ESPERADO:
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Si V007 se ejecutó correctamente:
--   - PASO 1: Debe mostrar 3 funciones en appmatch_schema
--   - PASO 2: Debe mostrar "✅ EXISTE" para las 3 funciones
--   - PASO 3: Debe estar VACÍO (no funciones en shared_schema)
--   - PASO 4: Debe mostrar la definición completa con columnas correctas
--
-- Si V007 NO se ejecutó:
--   - PASO 1: Puede mostrar funciones en shared_schema o ninguna
--   - PASO 2: Debe mostrar "❌ NO EXISTE" para las 3 funciones
--   - PASO 3: Puede mostrar funciones antiguas en shared_schema
--   - PASO 4: Debe mostrar "NO EXISTE"
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
