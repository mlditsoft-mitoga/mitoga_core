-- ============================================================================
-- Script: datos_genero_sexual.sql
-- Descripción: Catálogo de Género Sexual (Plano - 1 nivel)
-- Autor: Database Engineer Senior
-- Fecha: 12 de noviembre de 2025
-- Estructura: 1 nivel (sin jerarquía)
-- ============================================================================

-- GÉNERO SEXUAL (NIVEL 0 - SELECCIONABLES)
-- ============================================================================

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
VALUES 
('GENERO_SEXUAL', NULL, 'MASCULINO', 'Masculino', 'Male', 'Identidad de género masculino', 0, 1, TRUE, TRUE, 'fa-mars', '#4A90E2', 
'{"sexo_biologico": "M", "pronombres": ["él", "le"], "codigo_iso": "M", "abreviatura": "M"}'::jsonb);

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
VALUES 
('GENERO_SEXUAL', NULL, 'FEMENINO', 'Femenino', 'Female', 'Identidad de género femenino', 0, 2, TRUE, TRUE, 'fa-venus', '#E91E63', 
'{"sexo_biologico": "F", "pronombres": ["ella", "le"], "codigo_iso": "F", "abreviatura": "F"}'::jsonb);

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
VALUES 
('GENERO_SEXUAL', NULL, 'NO-BINARIO', 'No Binario', 'Non-Binary', 'Identidad de género no binaria', 0, 3, TRUE, TRUE, 'fa-transgender', '#9C27B0', 
'{"sexo_biologico": null, "pronombres": ["elle", "le"], "codigo_iso": "X", "abreviatura": "NB"}'::jsonb);

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
VALUES 
('GENERO_SEXUAL', NULL, 'OTRO', 'Otro', 'Other', 'Otra identidad de género', 0, 4, TRUE, TRUE, 'fa-genderless', '#607D8B', 
'{"sexo_biologico": null, "pronombres": ["elle", "le"], "codigo_iso": "O", "abreviatura": "O"}'::jsonb);

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
VALUES 
('GENERO_SEXUAL', NULL, 'PREFIERO-NO-DECIR', 'Prefiero no decir', 'Prefer not to say', 'Prefiere no especificar su género', 0, 5, TRUE, TRUE, 'fa-user-secret', '#95A5A6', 
'{"sexo_biologico": null, "pronombres": null, "codigo_iso": "U", "abreviatura": "PND", "privado": true}'::jsonb);


-- VERIFICACIÓN
-- ============================================================================

DO $$
DECLARE 
    v_count INTEGER;
    v_detalle TEXT;
BEGIN
    SELECT COUNT(*) INTO v_count 
    FROM shared_schema.catalogo_recursivo
    WHERE catalogo_tipo = 'GENERO_SEXUAL' 
    AND expiration_date IS NULL;
    
    RAISE NOTICE '=================================================';
    RAISE NOTICE 'CATÁLOGO GÉNERO SEXUAL - RESUMEN';
    RAISE NOTICE '=================================================';
    RAISE NOTICE 'Total de opciones de género: %', v_count;
    RAISE NOTICE '=================================================';
    RAISE NOTICE '';
    RAISE NOTICE 'Opciones disponibles:';
    RAISE NOTICE '-------------------------------------------------';
    
    FOR v_detalle IN 
        SELECT '  ' || orden || '. ' || nombre || ' (' || codigo || ')'
        FROM shared_schema.catalogo_recursivo
        WHERE catalogo_tipo = 'GENERO_SEXUAL' 
        AND expiration_date IS NULL
        ORDER BY orden
    LOOP
        RAISE NOTICE '%', v_detalle;
    END LOOP;
    
    RAISE NOTICE '=================================================';
END $$;
