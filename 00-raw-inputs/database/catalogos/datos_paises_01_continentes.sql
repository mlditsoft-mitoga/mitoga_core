-- ============================================================================
-- Script: datos_paises_01_continentes.sql
-- Descripción: Catálogo de Continentes (Nivel 0)
-- Autor: Database Engineer Senior
-- Fecha: 12 de noviembre de 2025
-- Parte: 1 de 6 - Continentes
-- ============================================================================

-- ========================================
-- NIVEL 0: CONTINENTES
-- ========================================

-- América
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, nivel, orden, activo, seleccionable, icono, color, metadatos)
VALUES 
(
    'PAIS',
    NULL,
    'CONT-AMERICA',
    'América',
    'America',
    'Continente Americano',
    'American Continent',
    0,
    1,
    TRUE,
    FALSE,
    'fa-globe-americas',
    '#1E90FF',
    '{"tipo": "continente", "codigo_continente": "019"}'::jsonb
);

-- Europa
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, nivel, orden, activo, seleccionable, icono, color, metadatos)
VALUES 
(
    'PAIS',
    NULL,
    'CONT-EUROPA',
    'Europa',
    'Europe',
    'Continente Europeo',
    'European Continent',
    0,
    2,
    TRUE,
    FALSE,
    'fa-globe-europe',
    '#32CD32',
    '{"tipo": "continente", "codigo_continente": "150"}'::jsonb
);

-- Asia
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, nivel, orden, activo, seleccionable, icono, color, metadatos)
VALUES 
(
    'PAIS',
    NULL,
    'CONT-ASIA',
    'Asia',
    'Asia',
    'Continente Asiático',
    'Asian Continent',
    0,
    3,
    TRUE,
    FALSE,
    'fa-globe-asia',
    '#FF6347',
    '{"tipo": "continente", "codigo_continente": "142"}'::jsonb
);

-- África
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, nivel, orden, activo, seleccionable, icono, color, metadatos)
VALUES 
(
    'PAIS',
    NULL,
    'CONT-AFRICA',
    'África',
    'Africa',
    'Continente Africano',
    'African Continent',
    0,
    4,
    TRUE,
    FALSE,
    'fa-globe-africa',
    '#FFD700',
    '{"tipo": "continente", "codigo_continente": "002"}'::jsonb
);

-- Oceanía
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, nivel, orden, activo, seleccionable, icono, color, metadatos)
VALUES 
(
    'PAIS',
    NULL,
    'CONT-OCEANIA',
    'Oceanía',
    'Oceania',
    'Continente Oceánico',
    'Oceanic Continent',
    0,
    5,
    TRUE,
    FALSE,
    'fa-globe',
    '#00CED1',
    '{"tipo": "continente", "codigo_continente": "009"}'::jsonb
);

-- ========================================
-- VERIFICACIÓN
-- ========================================

DO $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM shared_schema.catalogo_recursivo
    WHERE catalogo_tipo = 'PAIS' 
      AND nivel = 0
      AND expiration_date IS NULL;
    
    RAISE NOTICE '================================================';
    RAISE NOTICE 'CONTINENTES INSERTADOS: %', v_count;
    RAISE NOTICE 'Esperados: 5';
    RAISE NOTICE '================================================';
END $$;
