-- ═══════════════════════════════════════════════════════════════════════════════
-- SCRIPT: V007__migrar_funciones_catalogo_a_appmatch_schema.sql
-- AUTOR: Database Engineer Senior - PostgreSQL Architect
-- FECHA: 2025-11-17
-- VERSION: 1.0.0
-- 
-- DESCRIPCION:
--   Recreación de las funciones de catálogo con referencias actualizadas a
--   appmatch_schema. Este script corrige el error:
--   "ERROR: relation "shared_schema.catalogo_recursivo" does not exist"
--
--   Funciones incluidas:
--   1. catalogo_obtener_arbol() - Obtener estructura jerárquica completa
--   2. catalogo_obtener_ancestros() - Obtener ruta desde raíz hasta nodo
--   3. catalogo_obtener_descendientes() - Obtener todos los hijos recursivamente
--
-- BOUNDED CONTEXT: Shared - Catálogos Recursivos
-- DEPENDENCIAS:
--   - appmatch_schema.catalogo_recursivo (tabla debe existir)
--
-- IMPORTANTE:
--   ⚠️  Este script DROP + CREATE las funciones existentes
--   ⚠️  Ejecutar DESPUÉS de crear appmatch_schema y tabla catalogo_recursivo
-- ═══════════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 1: Verificar prerrequisitos
-- ═══════════════════════════════════════════════════════════════════════════════

DO $$
BEGIN
    -- Verificar que existe appmatch_schema
    IF NOT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'appmatch_schema') THEN
        RAISE EXCEPTION 'Schema appmatch_schema no existe. Ejecutar scripts de migración primero.';
    END IF;
    
    -- Verificar que existe tabla catalogo_recursivo
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'appmatch_schema' 
        AND table_name = 'catalogo_recursivo'
    ) THEN
        RAISE EXCEPTION 'Tabla appmatch_schema.catalogo_recursivo no existe. Crear tabla primero.';
    END IF;
    
    RAISE NOTICE '✅ Prerrequisitos verificados: appmatch_schema y catalogo_recursivo existen';
END $$;

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 2: DROP funciones antiguas (si existen en shared_schema o appmatch_schema)
-- ═══════════════════════════════════════════════════════════════════════════════

-- Drop en shared_schema (si existe)
DROP FUNCTION IF EXISTS shared_schema.catalogo_obtener_arbol(VARCHAR, BOOLEAN, BOOLEAN) CASCADE;
DROP FUNCTION IF EXISTS shared_schema.catalogo_obtener_ancestros(UUID, BOOLEAN) CASCADE;
DROP FUNCTION IF EXISTS shared_schema.catalogo_obtener_descendientes(UUID, BOOLEAN) CASCADE;

-- Drop en appmatch_schema (si existe con definición vieja)
DROP FUNCTION IF EXISTS appmatch_schema.catalogo_obtener_arbol(VARCHAR, BOOLEAN, BOOLEAN) CASCADE;
DROP FUNCTION IF EXISTS appmatch_schema.catalogo_obtener_ancestros(UUID, BOOLEAN) CASCADE;
DROP FUNCTION IF EXISTS appmatch_schema.catalogo_obtener_descendientes(UUID, BOOLEAN) CASCADE;

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 3: Crear función catalogo_obtener_arbol()
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION appmatch_schema.catalogo_obtener_arbol(
    p_tipo VARCHAR,
    p_solo_activos BOOLEAN DEFAULT TRUE,
    p_solo_seleccionables BOOLEAN DEFAULT FALSE
)
RETURNS TABLE (
    pkid_catalogo_recursivo UUID,
    codigo VARCHAR,
    nombre VARCHAR,
    descripcion TEXT,
    catalogo_tipo VARCHAR,
    fkid_padre UUID,
    nivel SMALLINT,
    orden SMALLINT,
    seleccionable BOOLEAN,
    metadatos JSONB,
    activo BOOLEAN,
    creation_date TIMESTAMPTZ,
    ruta TEXT,
    tiene_hijos BOOLEAN
)
AS $$
BEGIN
    -- Validar que el tipo no sea NULL
    IF p_tipo IS NULL THEN
        RAISE EXCEPTION 'El parámetro p_tipo no puede ser NULL';
    END IF;
    
    RETURN QUERY
    WITH RECURSIVE arbol AS (
        -- Nodos raíz (nivel 1)
        SELECT 
            c.pkid_catalogo_recursivo,
            c.codigo,
            c.nombre,
            c.descripcion,
            c.catalogo_tipo,
            c.fkid_padre,
            c.nivel,
            c.orden,
            c.seleccionable,
            c.metadatos,
            c.activo,
            c.creation_date,
            c.nombre::TEXT AS ruta,
            c.tiene_hijos
        FROM appmatch_schema.catalogo_recursivo c
        WHERE c.catalogo_tipo = p_tipo
          AND c.fkid_padre IS NULL
          AND c.expiration_date IS NULL
          AND (NOT p_solo_activos OR c.activo = TRUE)
          AND (NOT p_solo_seleccionables OR c.seleccionable = TRUE)
        
        UNION ALL
        
        -- Recursión: nodos hijos
        SELECT 
            c.pkid_catalogo_recursivo,
            c.codigo,
            c.nombre,
            c.descripcion,
            c.catalogo_tipo,
            c.fkid_padre,
            c.nivel,
            c.orden,
            c.seleccionable,
            c.metadatos,
            c.activo,
            c.creation_date,
            (a.ruta || ' > ' || c.nombre)::TEXT AS ruta,
            c.tiene_hijos
        FROM appmatch_schema.catalogo_recursivo c
        INNER JOIN arbol a ON c.fkid_padre = a.pkid_catalogo_recursivo
        WHERE c.expiration_date IS NULL
          AND (NOT p_solo_activos OR c.activo = TRUE)
          AND (NOT p_solo_seleccionables OR c.seleccionable = TRUE)
    )
    SELECT * FROM arbol
    ORDER BY ruta, orden;
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION appmatch_schema.catalogo_obtener_arbol(VARCHAR, BOOLEAN, BOOLEAN) IS
'Obtiene la estructura jerárquica completa de un catálogo recursivo.
Parámetros:
  - p_tipo: Tipo de catálogo (ej: TIPO_DOCUMENTO, PAIS, CIUDAD)
  - p_solo_activos: Si TRUE, solo retorna elementos activos
  - p_solo_seleccionables: Si TRUE, solo retorna elementos seleccionables
Retorna la jerarquía completa con ruta, nivel y flag de si tiene hijos.';

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 4: Crear función catalogo_obtener_ancestros()
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION appmatch_schema.catalogo_obtener_ancestros(
    p_catalogo_id UUID,
    p_incluir_propio BOOLEAN DEFAULT TRUE
)
RETURNS TABLE (
    pkid_catalogo_recursivo UUID,
    codigo VARCHAR,
    nombre VARCHAR,
    descripcion TEXT,
    catalogo_tipo VARCHAR,
    fkid_padre UUID,
    nivel SMALLINT,
    orden SMALLINT,
    seleccionable BOOLEAN,
    metadatos JSONB,
    activo BOOLEAN,
    creation_date TIMESTAMPTZ,
    nivel_relativo INTEGER
)
AS $$
BEGIN
    -- Validar que el ID no sea NULL
    IF p_catalogo_id IS NULL THEN
        RAISE EXCEPTION 'El parámetro p_catalogo_id no puede ser NULL';
    END IF;
    
    RETURN QUERY
    WITH RECURSIVE ancestros AS (
        -- Nodo inicial
        SELECT 
            c.pkid_catalogo_recursivo,
            c.codigo,
            c.nombre,
            c.descripcion,
            c.catalogo_tipo,
            c.fkid_padre,
            c.nivel,
            c.orden,
            c.seleccionable,
            c.metadatos,
            c.activo,
            c.creation_date,
            0 AS nivel_relativo
        FROM appmatch_schema.catalogo_recursivo c
        WHERE c.pkid_catalogo_recursivo = p_catalogo_id
          AND c.expiration_date IS NULL
        
        UNION ALL
        
        -- Recursión hacia arriba (padres)
        SELECT 
            c.pkid_catalogo_recursivo,
            c.codigo,
            c.nombre,
            c.descripcion,
            c.catalogo_tipo,
            c.fkid_padre,
            c.nivel,
            c.orden,
            c.seleccionable,
            c.metadatos,
            c.activo,
            c.creation_date,
            a.nivel_relativo + 1 AS nivel_relativo
        FROM appmatch_schema.catalogo_recursivo c
        INNER JOIN ancestros a ON c.pkid_catalogo_recursivo = a.fkid_padre
        WHERE c.expiration_date IS NULL
    )
    SELECT * FROM ancestros
    WHERE p_incluir_propio OR nivel_relativo > 0
    ORDER BY nivel_relativo DESC;  -- Del raíz al nodo
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION appmatch_schema.catalogo_obtener_ancestros(UUID, BOOLEAN) IS
'Obtiene todos los ancestros (padres) de un nodo de catálogo hasta la raíz.
Parámetros:
  - p_catalogo_id: UUID del nodo desde el cual obtener ancestros
  - p_incluir_propio: Si TRUE, incluye el nodo mismo en el resultado
Retorna la ruta desde la raíz hasta el nodo (o hasta su padre si incluir_propio=FALSE).';

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 5: Crear función catalogo_obtener_descendientes()
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION appmatch_schema.catalogo_obtener_descendientes(
    p_catalogo_id UUID,
    p_incluir_propio BOOLEAN DEFAULT TRUE
)
RETURNS TABLE (
    pkid_catalogo_recursivo UUID,
    codigo VARCHAR,
    nombre VARCHAR,
    descripcion TEXT,
    catalogo_tipo VARCHAR,
    fkid_padre UUID,
    nivel SMALLINT,
    orden SMALLINT,
    seleccionable BOOLEAN,
    metadatos JSONB,
    activo BOOLEAN,
    creation_date TIMESTAMPTZ,
    ruta TEXT,
    nivel_relativo INTEGER
)
AS $$
BEGIN
    -- Validar que el ID no sea NULL
    IF p_catalogo_id IS NULL THEN
        RAISE EXCEPTION 'El parámetro p_catalogo_id no puede ser NULL';
    END IF;
    
    RETURN QUERY
    WITH RECURSIVE descendientes AS (
        -- Nodo inicial
        SELECT 
            c.pkid_catalogo_recursivo,
            c.codigo,
            c.nombre,
            c.descripcion,
            c.catalogo_tipo,
            c.fkid_padre,
            c.nivel,
            c.orden,
            c.seleccionable,
            c.metadatos,
            c.activo,
            c.creation_date,
            c.nombre::TEXT AS ruta,
            0 AS nivel_relativo
        FROM appmatch_schema.catalogo_recursivo c
        WHERE c.pkid_catalogo_recursivo = p_catalogo_id
          AND c.expiration_date IS NULL
        
        UNION ALL
        
        -- Recursión hacia abajo (hijos)
        SELECT 
            c.pkid_catalogo_recursivo,
            c.codigo,
            c.nombre,
            c.descripcion,
            c.catalogo_tipo,
            c.fkid_padre,
            c.nivel,
            c.orden,
            c.seleccionable,
            c.metadatos,
            c.activo,
            c.creation_date,
            (d.ruta || ' > ' || c.nombre)::TEXT AS ruta,
            d.nivel_relativo + 1 AS nivel_relativo
        FROM appmatch_schema.catalogo_recursivo c
        INNER JOIN descendientes d ON c.fkid_padre = d.pkid_catalogo_recursivo
        WHERE c.expiration_date IS NULL
    )
    SELECT * FROM descendientes
    WHERE p_incluir_propio OR nivel_relativo > 0
    ORDER BY ruta, orden;
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION appmatch_schema.catalogo_obtener_descendientes(UUID, BOOLEAN) IS
'Obtiene todos los descendientes (hijos) de un nodo de catálogo recursivamente.
Parámetros:
  - p_catalogo_id: UUID del nodo desde el cual obtener descendientes
  - p_incluir_propio: Si TRUE, incluye el nodo mismo en el resultado
Retorna todos los hijos, nietos, etc. con su ruta y nivel relativo.';

-- ═══════════════════════════════════════════════════════════════════════════════
-- VERIFICACIÓN FINAL
-- ═══════════════════════════════════════════════════════════════════════════════

DO $$
DECLARE
    v_funciones_count INTEGER;
BEGIN
    -- Contar funciones creadas en appmatch_schema
    SELECT COUNT(*) INTO v_funciones_count
    FROM pg_proc p
    INNER JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname = 'appmatch_schema'
      AND p.proname IN (
          'catalogo_obtener_arbol',
          'catalogo_obtener_ancestros',
          'catalogo_obtener_descendientes'
      );
    
    RAISE NOTICE '════════════════════════════════════════════════════════════════';
    RAISE NOTICE '✅ VERIFICACIÓN DE FUNCIONES DE CATÁLOGO';
    RAISE NOTICE '════════════════════════════════════════════════════════════════';
    RAISE NOTICE 'Funciones creadas en appmatch_schema: %', v_funciones_count;
    RAISE NOTICE '════════════════════════════════════════════════════════════════';
    
    IF v_funciones_count = 3 THEN
        RAISE NOTICE '✅ SCRIPT V007 EJECUTADO EXITOSAMENTE';
        RAISE NOTICE '';
        RAISE NOTICE '📝 Funciones migradas:';
        RAISE NOTICE '   1. appmatch_schema.catalogo_obtener_arbol()';
        RAISE NOTICE '   2. appmatch_schema.catalogo_obtener_ancestros()';
        RAISE NOTICE '   3. appmatch_schema.catalogo_obtener_descendientes()';
        RAISE NOTICE '';
        RAISE NOTICE '🧪 Puedes probar con:';
        RAISE NOTICE '   SELECT * FROM appmatch_schema.catalogo_obtener_arbol(''TIPO_DOCUMENTO'', TRUE, TRUE);';
    ELSE
        RAISE WARNING '⚠️  Se esperaban 3 funciones pero se encontraron: %', v_funciones_count;
        RAISE WARNING '⚠️  Verificar que todas las funciones se hayan creado correctamente';
    END IF;
END $$;
