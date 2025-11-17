-- ═══════════════════════════════════════════════════════════════════════════════
-- SCRIPT: FORZAR_RECREACION_FUNCIONES_CATALOGO.sql
-- AUTOR: Database Engineer Senior
-- FECHA: 2025-11-17
-- ═══════════════════════════════════════════════════════════════════════════════
-- PROPÓSITO:
--   FORZAR la eliminación completa de funciones catalogo_* existentes en
--   CUALQUIER esquema (shared_schema, appmatch_schema, public) y recrearlas
--   correctamente en appmatch_schema con las columnas correctas.
--
-- INSTRUCCIONES DE EJECUCIÓN EN DBEAVER:
--   1. Copiar TODO este script
--   2. Abrir nueva ventana SQL en DBeaver (Ctrl+])
--   3. Pegar el script completo
--   4. Ejecutar TODO (Ctrl+Enter o clic en "Execute SQL Script")
--   5. Verificar mensajes en la consola
-- ═══════════════════════════════════════════════════════════════════════════════

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASO 1: ELIMINAR FORZOSAMENTE TODAS LAS FUNCIONES catalogo_* EN TODOS LOS ESQUEMAS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DO $$
DECLARE
    v_funcion RECORD;
    v_drop_statement TEXT;
BEGIN
    RAISE NOTICE '════════════════════════════════════════════════════════════════';
    RAISE NOTICE 'PASO 1: Eliminando TODAS las funciones catalogo_* existentes...';
    RAISE NOTICE '════════════════════════════════════════════════════════════════';
    
    -- Iterar sobre TODAS las funciones que empiecen con 'catalogo_'
    FOR v_funcion IN 
        SELECT 
            n.nspname AS esquema,
            p.proname AS nombre,
            pg_get_function_identity_arguments(p.oid) AS argumentos,
            oidvectortypes(p.proargtypes) AS tipos_args
        FROM pg_proc p
        INNER JOIN pg_namespace n ON p.pronamespace = n.oid
        WHERE p.proname LIKE 'catalogo_%'
        ORDER BY n.nspname, p.proname
    LOOP
        -- Construir statement DROP con signature completa
        v_drop_statement := format(
            'DROP FUNCTION IF EXISTS %I.%I(%s) CASCADE',
            v_funcion.esquema,
            v_funcion.nombre,
            v_funcion.argumentos
        );
        
        RAISE NOTICE '  🗑️  Eliminando: %.%(%)', 
            v_funcion.esquema, 
            v_funcion.nombre,
            v_funcion.argumentos;
        
        -- Ejecutar DROP
        EXECUTE v_drop_statement;
    END LOOP;
    
    RAISE NOTICE '✅ Funciones eliminadas exitosamente';
    RAISE NOTICE '';
END $$;

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASO 2: VERIFICAR QUE NO QUEDE NINGUNA FUNCIÓN catalogo_*
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DO $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM pg_proc p
    INNER JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE p.proname LIKE 'catalogo_%';
    
    RAISE NOTICE '════════════════════════════════════════════════════════════════';
    RAISE NOTICE 'PASO 2: Verificación post-eliminación';
    RAISE NOTICE '════════════════════════════════════════════════════════════════';
    RAISE NOTICE 'Funciones catalogo_* restantes: %', v_count;
    
    IF v_count = 0 THEN
        RAISE NOTICE '✅ Todas las funciones eliminadas correctamente';
    ELSE
        RAISE WARNING '⚠️  Aún quedan % funciones. Verificar manualmente.', v_count;
    END IF;
    RAISE NOTICE '';
END $$;

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASO 3: CREAR FUNCIÓN 1 - catalogo_obtener_arbol
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- NOTA IMPORTANTE: El orden de las columnas en RETURNS TABLE DEBE coincidir 
-- EXACTAMENTE con el orden de los campos en CatalogoJpaEntity.java

CREATE OR REPLACE FUNCTION appmatch_schema.catalogo_obtener_arbol(
    p_tipo VARCHAR,
    p_solo_activos BOOLEAN DEFAULT TRUE,
    p_solo_seleccionables BOOLEAN DEFAULT FALSE
)
RETURNS TABLE (
    pkid_catalogo_recursivo UUID,
    creation_date TIMESTAMPTZ,
    expiration_date TIMESTAMPTZ,
    catalogo_tipo VARCHAR,
    fkid_padre UUID,
    nivel SMALLINT,
    path_completo TEXT,
    codigo VARCHAR,
    nombre VARCHAR,
    nombre_en VARCHAR,
    descripcion TEXT,
    descripcion_en TEXT,
    orden SMALLINT,
    icono VARCHAR,
    color CHAR(7),
    activo BOOLEAN,
    seleccionable BOOLEAN,
    tiene_hijos BOOLEAN,
    metadatos JSONB,
    created_by UUID,
    updated_at TIMESTAMPTZ,
    updated_by UUID
)
LANGUAGE plpgsql
STABLE
AS $$
BEGIN
    RETURN QUERY
    WITH RECURSIVE catalogo_tree AS (
        -- Nodos raíz (sin padre)
        SELECT 
            c.pkid_catalogo_recursivo,
            c.creation_date,
            c.expiration_date,
            c.catalogo_tipo,
            c.fkid_padre,
            c.nivel,
            c.nombre::TEXT AS path_completo,  -- Usamos ruta como path_completo
            c.codigo,
            c.nombre,
            c.nombre_en,
            c.descripcion,
            c.descripcion_en,
            c.orden,
            c.icono,
            c.color,
            c.activo,
            c.seleccionable,
            c.tiene_hijos,
            c.metadatos,
            c.created_by,
            c.updated_at,
            c.updated_by
        FROM appmatch_schema.catalogo_recursivo c
        WHERE c.catalogo_tipo = p_tipo
          AND c.fkid_padre IS NULL
          AND c.expiration_date IS NULL
          AND (NOT p_solo_activos OR c.activo = TRUE)
          AND (NOT p_solo_seleccionables OR c.seleccionable = TRUE)
        
        UNION ALL
        
        -- Nodos hijos (recursivo)
        SELECT 
            c.pkid_catalogo_recursivo,
            c.creation_date,
            c.expiration_date,
            c.catalogo_tipo,
            c.fkid_padre,
            c.nivel,
            (ct.path_completo || ' > ' || c.nombre)::TEXT AS path_completo,
            c.codigo,
            c.nombre,
            c.nombre_en,
            c.descripcion,
            c.descripcion_en,
            c.orden,
            c.icono,
            c.color,
            c.activo,
            c.seleccionable,
            c.tiene_hijos,
            c.metadatos,
            c.created_by,
            c.updated_at,
            c.updated_by
        FROM appmatch_schema.catalogo_recursivo c
        INNER JOIN catalogo_tree ct ON c.fkid_padre = ct.pkid_catalogo_recursivo
        WHERE c.expiration_date IS NULL
          AND (NOT p_solo_activos OR c.activo = TRUE)
          AND (NOT p_solo_seleccionables OR c.seleccionable = TRUE)
    )
    SELECT * FROM catalogo_tree
    ORDER BY path_completo, orden;
END;
$$;

COMMENT ON FUNCTION appmatch_schema.catalogo_obtener_arbol IS 
'Obtiene el árbol jerárquico completo de un catálogo específico.
Parámetros:
  - p_tipo: Tipo de catálogo (ej: TIPO_DOCUMENTO, PAIS, etc.)
  - p_solo_activos: Filtrar solo registros activos (default: TRUE)
  - p_solo_seleccionables: Filtrar solo registros seleccionables (default: FALSE)
Retorna una estructura jerárquica con ruta completa y nivel de profundidad.
IMPORTANTE: Usa nombres de columnas correctos (pkid_catalogo_recursivo, fkid_padre, catalogo_tipo, orden, seleccionable, metadatos)';

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASO 4: CREAR FUNCIÓN 2 - catalogo_obtener_ancestros
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CREATE OR REPLACE FUNCTION appmatch_schema.catalogo_obtener_ancestros(
    p_catalogo_id UUID,
    p_incluir_propio BOOLEAN DEFAULT TRUE
)
RETURNS TABLE (
    pkid_catalogo_recursivo UUID,
    fkid_padre UUID,
    catalogo_tipo VARCHAR,
    codigo VARCHAR,
    nombre VARCHAR,
    nivel SMALLINT,
    orden SMALLINT,
    activo BOOLEAN,
    nivel_relativo INTEGER
)
LANGUAGE plpgsql
STABLE
AS $$
BEGIN
    RETURN QUERY
    WITH RECURSIVE ancestros AS (
        -- Nodo inicial
        SELECT 
            c.pkid_catalogo_recursivo,
            c.fkid_padre,
            c.catalogo_tipo,
            c.codigo,
            c.nombre,
            c.nivel,
            c.orden,
            c.activo,
            0::INTEGER AS nivel_relativo
        FROM appmatch_schema.catalogo_recursivo c
        WHERE c.pkid_catalogo_recursivo = p_catalogo_id
          AND c.expiration_date IS NULL
          AND p_incluir_propio = TRUE
        
        UNION ALL
        
        -- Padres recursivamente
        SELECT 
            c.pkid_catalogo_recursivo,
            c.fkid_padre,
            c.catalogo_tipo,
            c.codigo,
            c.nombre,
            c.nivel,
            c.orden,
            c.activo,
            (a.nivel_relativo - 1)::INTEGER AS nivel_relativo
        FROM appmatch_schema.catalogo_recursivo c
        INNER JOIN ancestros a ON c.pkid_catalogo_recursivo = a.fkid_padre
        WHERE c.expiration_date IS NULL
    )
    SELECT * FROM ancestros
    ORDER BY nivel_relativo;
END;
$$;

COMMENT ON FUNCTION appmatch_schema.catalogo_obtener_ancestros IS 
'Obtiene todos los ancestros (padres) de un catálogo hasta la raíz.
Parámetros:
  - p_catalogo_id: UUID del catálogo
  - p_incluir_propio: Incluir el nodo mismo en el resultado (default: TRUE)
Retorna la cadena de ancestros ordenados desde el nodo hasta la raíz.';

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASO 5: CREAR FUNCIÓN 3 - catalogo_obtener_descendientes
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CREATE OR REPLACE FUNCTION appmatch_schema.catalogo_obtener_descendientes(
    p_catalogo_id UUID,
    p_incluir_propio BOOLEAN DEFAULT TRUE
)
RETURNS TABLE (
    pkid_catalogo_recursivo UUID,
    fkid_padre UUID,
    catalogo_tipo VARCHAR,
    codigo VARCHAR,
    nombre VARCHAR,
    nivel SMALLINT,
    orden SMALLINT,
    tiene_hijos BOOLEAN,
    seleccionable BOOLEAN,
    activo BOOLEAN,
    nivel_relativo INTEGER
)
LANGUAGE plpgsql
STABLE
AS $$
BEGIN
    RETURN QUERY
    WITH RECURSIVE descendientes AS (
        -- Nodo inicial
        SELECT 
            c.pkid_catalogo_recursivo,
            c.fkid_padre,
            c.catalogo_tipo,
            c.codigo,
            c.nombre,
            c.nivel,
            c.orden,
            c.tiene_hijos,
            c.seleccionable,
            c.activo,
            0::INTEGER AS nivel_relativo
        FROM appmatch_schema.catalogo_recursivo c
        WHERE c.pkid_catalogo_recursivo = p_catalogo_id
          AND c.expiration_date IS NULL
          AND p_incluir_propio = TRUE
        
        UNION ALL
        
        -- Hijos recursivamente
        SELECT 
            c.pkid_catalogo_recursivo,
            c.fkid_padre,
            c.catalogo_tipo,
            c.codigo,
            c.nombre,
            c.nivel,
            c.orden,
            c.tiene_hijos,
            c.seleccionable,
            c.activo,
            (d.nivel_relativo + 1)::INTEGER AS nivel_relativo
        FROM appmatch_schema.catalogo_recursivo c
        INNER JOIN descendientes d ON c.fkid_padre = d.pkid_catalogo_recursivo
        WHERE c.expiration_date IS NULL
    )
    SELECT * FROM descendientes
    ORDER BY nivel_relativo, orden;
END;
$$;

COMMENT ON FUNCTION appmatch_schema.catalogo_obtener_descendientes IS 
'Obtiene todos los descendientes (hijos) de un catálogo recursivamente.
Parámetros:
  - p_catalogo_id: UUID del catálogo padre
  - p_incluir_propio: Incluir el nodo mismo en el resultado (default: TRUE)
Retorna toda la sub-jerarquía ordenada por nivel y orden.';

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASO 6: VERIFICAR CREACIÓN EXITOSA
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DO $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM pg_proc p
    INNER JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname = 'appmatch_schema'
      AND p.proname IN ('catalogo_obtener_arbol', 'catalogo_obtener_ancestros', 'catalogo_obtener_descendientes');
    
    RAISE NOTICE '════════════════════════════════════════════════════════════════';
    RAISE NOTICE 'PASO 6: Verificación de creación';
    RAISE NOTICE '════════════════════════════════════════════════════════════════';
    RAISE NOTICE 'Funciones creadas en appmatch_schema: %', v_count;
    
    IF v_count = 3 THEN
        RAISE NOTICE '✅✅✅ LAS 3 FUNCIONES CREADAS EXITOSAMENTE';
        RAISE NOTICE '';
        RAISE NOTICE 'Prueba ejecutar:';
        RAISE NOTICE '  SELECT * FROM appmatch_schema.catalogo_obtener_arbol(''TIPO_DOCUMENTO'', TRUE, TRUE);';
    ELSE
        RAISE WARNING '⚠️  Solo se crearon % de 3 funciones. Verificar errores arriba.', v_count;
    END IF;
    RAISE NOTICE '════════════════════════════════════════════════════════════════';
END $$;

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASO 7: MOSTRAR LISTA FINAL DE FUNCIONES
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT 
    n.nspname AS esquema,
    p.proname AS funcion,
    pg_get_function_identity_arguments(p.oid) AS argumentos,
    pg_get_function_result(p.oid) AS retorno
FROM pg_proc p
INNER JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'appmatch_schema'
  AND p.proname LIKE 'catalogo_%'
ORDER BY p.proname;
