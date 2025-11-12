-- Fix: Modificar catalogo_obtener_arbol para retornar nombres de columna completos

-- Primero eliminamos la función existente
DROP FUNCTION IF EXISTS shared_schema.catalogo_obtener_arbol(VARCHAR, BOOLEAN, BOOLEAN);

-- Ahora la creamos con la firma correcta
CREATE OR REPLACE FUNCTION shared_schema.catalogo_obtener_arbol(
    p_catalogo_tipo VARCHAR,
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
    color CHAR,
    activo BOOLEAN,
    seleccionable BOOLEAN,
    tiene_hijos BOOLEAN,
    metadatos JSONB,
    created_by UUID,
    updated_at TIMESTAMPTZ,
    updated_by UUID
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.pkid_catalogo_recursivo,
        c.creation_date,
        c.expiration_date,
        c.catalogo_tipo,
        c.fkid_padre,
        c.nivel,
        c.path_completo,
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
    FROM shared_schema.catalogo_recursivo c
    WHERE c.catalogo_tipo = p_catalogo_tipo
      AND c.expiration_date IS NULL
      AND (NOT p_solo_activos OR c.activo = TRUE)
      AND (NOT p_solo_seleccionables OR c.seleccionable = TRUE)
    ORDER BY c.nivel, c.fkid_padre NULLS FIRST, c.orden, c.nombre;
END;
$$ LANGUAGE plpgsql STABLE;
