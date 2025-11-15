-- ============================================================================
-- EJEMPLO: Consultas con FK UUID a Catálogos
-- Archivo: consultas_estudiantes_con_catalogos.sql
-- Fecha: 2025-11-14
-- Descripción: Ejemplos de cómo consultar estudiantes con JOINs a catálogos
-- ============================================================================

-- ===========================================
-- QUERY 1: ESTUDIANTES CON VALORES LEGIBLES DE CATÁLOGOS
-- ===========================================

-- Consulta completa con todos los catálogos unidos
SELECT 
    -- Datos básicos del estudiante
    pe.pkid_perfiles_estudiante,
    pe.nombre_completo,
    pe.fecha_nacimiento,
    shared_schema.calcular_edad(pe.fecha_nacimiento) AS edad_actual,
    pe.telefono,
    pe.direccion,
    pe.es_menor_edad,
    
    -- Valores legibles de catálogos (JOINs)
    pais.nombre AS pais_nombre,
    ciudad.nombre AS ciudad_nombre,
    genero.nombre AS genero,
    nivel_edu.nombre AS nivel_educativo,
    idioma.nombre AS idioma_preferido,
    
    -- Datos del responsable (si es menor)
    pe.responsable_nombre,
    pe.responsable_apellido,
    pe.responsable_email,
    pe.responsable_relacion,
    
    -- Metadata
    pe.creation_date AS fecha_registro,
    pe.metadata

FROM perfiles_schema.perfiles_estudiante pe
-- JOINs a catálogo_recursivo para valores legibles
LEFT JOIN shared_schema.catalogo_recursivo pais 
    ON pe.pais_id = pais.pkid_catalogo_recursivo 
    AND pais.catalogo_tipo = 'PAIS'
    AND pais.expiration_date IS NULL
LEFT JOIN shared_schema.catalogo_recursivo ciudad 
    ON pe.ciudad_id = ciudad.pkid_catalogo_recursivo 
    AND ciudad.catalogo_tipo = 'CIUDAD'
    AND ciudad.expiration_date IS NULL
LEFT JOIN shared_schema.catalogo_recursivo genero 
    ON pe.genero_id = genero.pkid_catalogo_recursivo 
    AND genero.catalogo_tipo = 'GENERO_SEXUAL'
    AND genero.expiration_date IS NULL
LEFT JOIN shared_schema.catalogo_recursivo nivel_edu 
    ON pe.nivel_educativo_id = nivel_edu.pkid_catalogo_recursivo 
    AND nivel_edu.catalogo_tipo = 'NIVEL_EDUCATIVO'
    AND nivel_edu.expiration_date IS NULL
LEFT JOIN shared_schema.catalogo_recursivo idioma 
    ON pe.idioma_preferido_id = idioma.pkid_catalogo_recursivo 
    AND idioma.catalogo_tipo = 'IDIOMA'
    AND idioma.expiration_date IS NULL

WHERE pe.expiration_date IS NULL
ORDER BY pe.creation_date DESC;

-- ===========================================
-- QUERY 2: USANDO FUNCIONES HELPER
-- ===========================================

-- Consulta simplificada usando las funciones helper
SELECT 
    pe.nombre_completo,
    pe.fecha_nacimiento,
    shared_schema.calcular_edad(pe.fecha_nacimiento) AS edad,
    
    -- Usando funciones helper para obtener nombres
    shared_schema.get_catalogo_nombre(pe.pais_id) AS pais,
    shared_schema.get_catalogo_nombre(pe.ciudad_id) AS ciudad,
    shared_schema.get_catalogo_nombre(pe.genero_id) AS genero,
    shared_schema.get_catalogo_nombre(pe.nivel_educativo_id) AS nivel_educativo,
    shared_schema.get_catalogo_nombre(pe.idioma_preferido_id) AS idioma

FROM perfiles_schema.perfiles_estudiante pe
WHERE pe.expiration_date IS NULL
ORDER BY pe.nombre_completo;

-- ===========================================
-- QUERY 3: FILTROS POR VALORES DE CATÁLOGO
-- ===========================================

-- Buscar estudiantes por ciudad (usando código de catálogo)
SELECT 
    pe.nombre_completo,
    ciudad.nombre AS ciudad,
    ciudad.codigo AS ciudad_codigo
FROM perfiles_schema.perfiles_estudiante pe
JOIN shared_schema.catalogo_recursivo ciudad 
    ON pe.ciudad_id = ciudad.pkid_catalogo_recursivo 
    AND ciudad.catalogo_tipo = 'CIUDAD'
WHERE ciudad.codigo IN ('BOG', 'MED', 'CALI')  -- Bogotá, Medellín, Cali
AND pe.expiration_date IS NULL;

-- Buscar estudiantes por género
SELECT 
    COUNT(*) AS cantidad,
    genero.nombre AS genero
FROM perfiles_schema.perfiles_estudiante pe
JOIN shared_schema.catalogo_recursivo genero 
    ON pe.genero_id = genero.pkid_catalogo_recursivo 
    AND genero.catalogo_tipo = 'GENERO_SEXUAL'
WHERE pe.expiration_date IS NULL
GROUP BY genero.nombre;

-- ===========================================
-- QUERY 4: ESTADÍSTICAS POR CATÁLOGOS
-- ===========================================

-- Distribución de estudiantes por nivel educativo
SELECT 
    nivel_edu.nombre AS nivel_educativo,
    nivel_edu.codigo AS nivel_codigo,
    COUNT(*) AS total_estudiantes,
    COUNT(*) FILTER (WHERE pe.es_menor_edad = TRUE) AS menores_edad,
    ROUND(AVG(shared_schema.calcular_edad(pe.fecha_nacimiento)), 1) AS edad_promedio
FROM perfiles_schema.perfiles_estudiante pe
JOIN shared_schema.catalogo_recursivo nivel_edu 
    ON pe.nivel_educativo_id = nivel_edu.pkid_catalogo_recursivo 
    AND nivel_edu.catalogo_tipo = 'NIVEL_EDUCATIVO'
WHERE pe.expiration_date IS NULL
GROUP BY nivel_edu.nombre, nivel_edu.codigo, nivel_edu.orden
ORDER BY nivel_edu.orden;

-- Distribución geográfica (país y ciudad)
SELECT 
    pais.nombre AS pais,
    ciudad.nombre AS ciudad,
    COUNT(*) AS total_estudiantes
FROM perfiles_schema.perfiles_estudiante pe
JOIN shared_schema.catalogo_recursivo pais 
    ON pe.pais_id = pais.pkid_catalogo_recursivo 
    AND pais.catalogo_tipo = 'PAIS'
LEFT JOIN shared_schema.catalogo_recursivo ciudad 
    ON pe.ciudad_id = ciudad.pkid_catalogo_recursivo 
    AND ciudad.catalogo_tipo = 'CIUDAD'
WHERE pe.expiration_date IS NULL
GROUP BY pais.nombre, ciudad.nombre
ORDER BY total_estudiantes DESC;

-- ===========================================
-- QUERY 5: INSERTAR ESTUDIANTE CON CATÁLOGOS
-- ===========================================

-- Ejemplo de INSERT usando las funciones helper para obtener UUIDs
/*
INSERT INTO perfiles_schema.perfiles_estudiante (
    usuario_id,
    pais_id,
    ciudad_id,
    genero_id,
    nivel_educativo_id,
    idioma_preferido_id,
    primer_nombre,
    primer_apellido,
    fecha_nacimiento,
    telefono,
    direccion,
    es_menor_edad
) VALUES (
    'USER-UUID-AQUI'::UUID,
    shared_schema.get_catalogo_by_tipo_codigo('PAIS', 'CO'),           -- Colombia
    shared_schema.get_catalogo_by_tipo_codigo('CIUDAD', 'BOG'),        -- Bogotá
    shared_schema.get_catalogo_by_tipo_codigo('GENERO_SEXUAL', 'M'),   -- Masculino
    shared_schema.get_catalogo_by_tipo_codigo('NIVEL_EDUCATIVO', 'UNI'), -- Universitario
    shared_schema.get_catalogo_by_tipo_codigo('IDIOMA', 'ES'),         -- Español
    'Juan',
    'Pérez',
    '2000-05-15',
    '+57 300 123 4567',
    'Calle 123 #45-67, Chapinero',
    FALSE
);
*/

-- ===========================================
-- QUERY 6: VALIDAR INTEGRIDAD DE DATOS
-- ===========================================

-- Verificar que no hay FK huérfanos
SELECT 
    'FK Huérfanos Detectados' AS problema,
    COUNT(*) AS cantidad
FROM perfiles_schema.perfiles_estudiante pe
WHERE pe.expiration_date IS NULL
AND (
    (pe.pais_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM shared_schema.catalogo_recursivo 
        WHERE pkid_catalogo_recursivo = pe.pais_id 
        AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL
    ))
    OR
    (pe.genero_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM shared_schema.catalogo_recursivo 
        WHERE pkid_catalogo_recursivo = pe.genero_id 
        AND catalogo_tipo = 'GENERO_SEXUAL' AND expiration_date IS NULL
    ))
    OR
    (pe.ciudad_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM shared_schema.catalogo_recursivo 
        WHERE pkid_catalogo_recursivo = pe.ciudad_id 
        AND catalogo_tipo = 'CIUDAD' AND expiration_date IS NULL
    ))
    OR
    (pe.nivel_educativo_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM shared_schema.catalogo_recursivo 
        WHERE pkid_catalogo_recursivo = pe.nivel_educativo_id 
        AND catalogo_tipo = 'NIVEL_EDUCATIVO' AND expiration_date IS NULL
    ))
);

-- ===========================================
-- COMENTARIOS DE USO
-- ===========================================

/*
📋 GUÍA DE USO:

1. **Para consultas básicas**: Usar QUERY 1 (JOINs completos)
2. **Para consultas simples**: Usar QUERY 2 (funciones helper)
3. **Para filtros específicos**: Usar QUERY 3 (filtros por código)
4. **Para reportes**: Usar QUERY 4 (estadísticas)
5. **Para insertar datos**: Usar QUERY 5 como plantilla
6. **Para validar datos**: Usar QUERY 6 (verificar integridad)

💡 VENTAJAS DE ESTE ENFOQUE:
- ✅ Datos normalizados (no duplicación)
- ✅ Valores consistentes (solo opciones válidas)
- ✅ Fácil mantenimiento de catálogos
- ✅ Soporte multiidioma (nombre_en)
- ✅ Jerarquías (ciudades → departamentos → países)

⚠️  NOTAS IMPORTANTES:
- Siempre usar LEFT JOIN para campos opcionales
- Incluir filtro expiration_date IS NULL
- Validar catalogo_tipo en JOINs
- Usar funciones helper para inserts
*/