-- ============================================================================
-- Script: datos_tipo_documento.sql
-- Descripción: Catálogo de Tipos de Documento de Identificación - Colombia
-- Autor: Database Engineer Senior
-- Fecha: 12 de noviembre de 2025
-- Normativa: Resolución DIAN, Registraduría Nacional, Migración Colombia
-- ============================================================================

-- ========================================
-- NIVEL 0: CATEGORÍAS PRINCIPALES
-- ========================================

-- Categoría: Personas Naturales Colombianas
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
VALUES
(
    'TIPO_DOCUMENTO',
    NULL,
    'DOC-CAT-NAT',
    'Personas Naturales',
    'Natural Persons',
    'Documentos de identificación para personas naturales colombianas',
    'Identification documents for Colombian natural persons',
    1,
    TRUE,
    FALSE,  -- Las categorías no son seleccionables
    'fa-user',
    '#2E86DE',
    '{"categoria": "personas_naturales", "pais": "CO", "tipo_persona": "natural"}'::jsonb
);

-- Categoría: Personas Jurídicas
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
VALUES
(
    'TIPO_DOCUMENTO',
    NULL,
    'DOC-CAT-JUR',
    'Personas Jurídicas',
    'Legal Entities',
    'Documentos de identificación tributaria para personas jurídicas',
    'Tax identification documents for legal entities',
    2,
    TRUE,
    FALSE,
    'fa-building',
    '#10AC84',
    '{"categoria": "personas_juridicas", "pais": "CO", "tipo_persona": "juridica"}'::jsonb
);

-- Categoría: Extranjeros
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
VALUES
(
    'TIPO_DOCUMENTO',
    NULL,
    'DOC-CAT-EXT',
    'Extranjeros',
    'Foreigners',
    'Documentos de identificación para personas extranjeras',
    'Identification documents for foreign persons',
    3,
    TRUE,
    FALSE,
    'fa-globe',
    '#F39C12',
    '{"categoria": "extranjeros", "pais": "CO", "tipo_persona": "extranjero"}'::jsonb
);

-- ========================================
-- NIVEL 1: TIPOS DE DOCUMENTO - PERSONAS NATURALES
-- ========================================

-- Cédula de Ciudadanía (CC)
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'TIPO_DOCUMENTO',
    pkid_catalogo_recursivo,
    'CC',
    'Cédula de Ciudadanía',
    'Citizenship Card',
    'Documento de identidad para ciudadanos colombianos mayores de 18 años',
    'Identity document for Colombian citizens over 18 years old',
    1,
    TRUE,
    TRUE,  -- Este SÍ es seleccionable
    'fa-id-card',
    '#3742FA',
    '{"codigo_dian": "13", "longitud_min": 6, "longitud_max": 10, "formato": "numerico", "edad_minima": 18, "emite": "Registraduría Nacional"}'::jsonb
FROM shared_schema.catalogo_recursivo
WHERE codigo = 'DOC-CAT-NAT' AND catalogo_tipo = 'TIPO_DOCUMENTO' AND expiration_date IS NULL;

-- Tarjeta de Identidad (TI)
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'TIPO_DOCUMENTO',
    pkid_catalogo_recursivo,
    'TI',
    'Tarjeta de Identidad',
    'Identity Card',
    'Documento de identidad para menores de edad colombianos entre 7 y 17 años',
    'Identity document for Colombian minors between 7 and 17 years old',
    2,
    TRUE,
    TRUE,
    'fa-id-card-o',
    '#5F27CD',
    '{"codigo_dian": "12", "longitud_min": 10, "longitud_max": 11, "formato": "numerico", "edad_minima": 7, "edad_maxima": 17, "emite": "Registraduría Nacional"}'::jsonb
FROM shared_schema.catalogo_recursivo
WHERE codigo = 'DOC-CAT-NAT' AND catalogo_tipo = 'TIPO_DOCUMENTO' AND expiration_date IS NULL;

-- Registro Civil (RC)
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'TIPO_DOCUMENTO',
    pkid_catalogo_recursivo,
    'RC',
    'Registro Civil',
    'Birth Certificate',
    'Registro civil de nacimiento para menores de 7 años',
    'Birth certificate for children under 7 years old',
    3,
    TRUE,
    TRUE,
    'fa-file-text-o',
    '#A29BFE',
    '{"codigo_dian": "11", "longitud_min": 9, "longitud_max": 12, "formato": "numerico", "edad_minima": 0, "edad_maxima": 6, "emite": "Registraduría Nacional"}'::jsonb
FROM shared_schema.catalogo_recursivo
WHERE codigo = 'DOC-CAT-NAT' AND catalogo_tipo = 'TIPO_DOCUMENTO' AND expiration_date IS NULL;

-- Cédula de Extranjería (CE) - Para residentes
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'TIPO_DOCUMENTO',
    pkid_catalogo_recursivo,
    'CE',
    'Cédula de Extranjería',
    'Foreigner ID',
    'Documento de identificación para extranjeros residentes en Colombia',
    'Identification document for foreign residents in Colombia',
    4,
    TRUE,
    TRUE,
    'fa-vcard',
    '#00D2D3',
    '{"codigo_dian": "22", "longitud_min": 6, "longitud_max": 7, "formato": "numerico", "emite": "Migración Colombia", "requiere_visa": true}'::jsonb
FROM shared_schema.catalogo_recursivo
WHERE codigo = 'DOC-CAT-NAT' AND catalogo_tipo = 'TIPO_DOCUMENTO' AND expiration_date IS NULL;

-- NUIP (Número Único de Identificación Personal) - Sistema nuevo
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'TIPO_DOCUMENTO',
    pkid_catalogo_recursivo,
    'NUIP',
    'NUIP - Número Único de Identificación Personal',
    'Unique Personal Identification Number',
    'Nuevo sistema unificado de identificación (en implementación)',
    'New unified identification system (under implementation)',
    5,
    FALSE,  -- Aún no activo oficialmente
    FALSE,
    'fa-fingerprint',
    '#8E44AD',
    '{"codigo_dian": "13", "longitud": 11, "formato": "numerico", "emite": "Registraduría Nacional", "en_implementacion": true, "año_inicio": 2023}'::jsonb
FROM shared_schema.catalogo_recursivo
WHERE codigo = 'DOC-CAT-NAT' AND catalogo_tipo = 'TIPO_DOCUMENTO' AND expiration_date IS NULL;

-- ========================================
-- NIVEL 1: TIPOS DE DOCUMENTO - PERSONAS JURÍDICAS
-- ========================================

-- NIT (Número de Identificación Tributaria)
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'TIPO_DOCUMENTO',
    pkid_catalogo_recursivo,
    'NIT',
    'NIT - Número de Identificación Tributaria',
    'Tax Identification Number',
    'Número de identificación tributaria para personas jurídicas y personas naturales con actividad comercial',
    'Tax identification number for legal entities and natural persons with commercial activity',
    1,
    TRUE,
    TRUE,
    'fa-briefcase',
    '#27AE60',
    '{"codigo_dian": "31", "longitud": 10, "formato": "numerico_con_dv", "digito_verificacion": true, "emite": "DIAN", "obligatorio_facturacion": true}'::jsonb
FROM shared_schema.catalogo_recursivo
WHERE codigo = 'DOC-CAT-JUR' AND catalogo_tipo = 'TIPO_DOCUMENTO' AND expiration_date IS NULL;

-- ========================================
-- NIVEL 1: TIPOS DE DOCUMENTO - EXTRANJEROS
-- ========================================

-- Pasaporte
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'TIPO_DOCUMENTO',
    pkid_catalogo_recursivo,
    'PA',
    'Pasaporte',
    'Passport',
    'Documento de viaje internacional para extranjeros',
    'International travel document for foreigners',
    1,
    TRUE,
    TRUE,
    'fa-plane',
    '#E67E22',
    '{"codigo_dian": "41", "longitud_min": 6, "longitud_max": 20, "formato": "alfanumerico", "emite": "País de origen", "internacional": true}'::jsonb
FROM shared_schema.catalogo_recursivo
WHERE codigo = 'DOC-CAT-EXT' AND catalogo_tipo = 'TIPO_DOCUMENTO' AND expiration_date IS NULL;

-- PEP (Permiso Especial de Permanencia)
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'TIPO_DOCUMENTO',
    pkid_catalogo_recursivo,
    'PEP',
    'PEP - Permiso Especial de Permanencia',
    'Special Stay Permit',
    'Permiso especial de permanencia para migrantes venezolanos',
    'Special stay permit for Venezuelan migrants',
    2,
    TRUE,
    TRUE,
    'fa-id-badge',
    '#E74C3C',
    '{"codigo_dian": "47", "longitud": 13, "formato": "alfanumerico", "emite": "Migración Colombia", "temporal": true, "nacionalidad": "VE"}'::jsonb
FROM shared_schema.catalogo_recursivo
WHERE codigo = 'DOC-CAT-EXT' AND catalogo_tipo = 'TIPO_DOCUMENTO' AND expiration_date IS NULL;

-- PPT (Permiso por Protección Temporal)
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'TIPO_DOCUMENTO',
    pkid_catalogo_recursivo,
    'PPT',
    'PPT - Permiso por Protección Temporal',
    'Temporary Protection Permit',
    'Permiso de protección temporal para migrantes venezolanos (reemplaza PEP desde 2021)',
    'Temporary protection permit for Venezuelan migrants (replaces PEP since 2021)',
    3,
    TRUE,
    TRUE,
    'fa-shield',
    '#C0392B',
    '{"codigo_dian": "47", "longitud": 20, "formato": "alfanumerico", "emite": "Migración Colombia", "temporal": true, "nacionalidad": "VE", "vigencia_años": 10}'::jsonb
FROM shared_schema.catalogo_recursivo
WHERE codigo = 'DOC-CAT-EXT' AND catalogo_tipo = 'TIPO_DOCUMENTO' AND expiration_date IS NULL;

-- DIE (Documento Identidad Extranjero)
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'TIPO_DOCUMENTO',
    pkid_catalogo_recursivo,
    'DIE',
    'DIE - Documento de Identificación Extranjero',
    'Foreign ID Document',
    'Documento de identificación emitido por otro país',
    'Identification document issued by another country',
    4,
    TRUE,
    TRUE,
    'fa-address-card-o',
    '#D35400',
    '{"codigo_dian": "50", "longitud_min": 5, "longitud_max": 30, "formato": "alfanumerico", "emite": "País extranjero"}'::jsonb
FROM shared_schema.catalogo_recursivo
WHERE codigo = 'DOC-CAT-EXT' AND catalogo_tipo = 'TIPO_DOCUMENTO' AND expiration_date IS NULL;

-- ========================================
-- VERIFICACIÓN DE INSERCIÓN
-- ========================================

DO $$
DECLARE
    v_count_categorias INTEGER;
    v_count_documentos INTEGER;
    v_count_total INTEGER;
BEGIN
    -- Contar categorías (nivel 0)
    SELECT COUNT(*) INTO v_count_categorias
    FROM shared_schema.catalogo_recursivo
    WHERE catalogo_tipo = 'TIPO_DOCUMENTO' 
      AND nivel = 0
      AND expiration_date IS NULL;
    
    -- Contar documentos (nivel 1)
    SELECT COUNT(*) INTO v_count_documentos
    FROM shared_schema.catalogo_recursivo
    WHERE catalogo_tipo = 'TIPO_DOCUMENTO' 
      AND nivel = 1
      AND expiration_date IS NULL;
    
    -- Total
    SELECT COUNT(*) INTO v_count_total
    FROM shared_schema.catalogo_recursivo
    WHERE catalogo_tipo = 'TIPO_DOCUMENTO' 
      AND expiration_date IS NULL;
    
    -- Log de resultados
    RAISE NOTICE '================================================';
    RAISE NOTICE 'CATÁLOGO TIPO_DOCUMENTO INSERTADO';
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Categorías (Nivel 0): %', v_count_categorias;
    RAISE NOTICE 'Documentos (Nivel 1): %', v_count_documentos;
    RAISE NOTICE 'Total registros: %', v_count_total;
    RAISE NOTICE '================================================';
    
    -- Validación
    IF v_count_categorias <> 3 THEN
        RAISE WARNING 'Se esperaban 3 categorías, se insertaron %', v_count_categorias;
    END IF;
    
    IF v_count_documentos <> 11 THEN
        RAISE WARNING 'Se esperaban 11 documentos, se insertaron %', v_count_documentos;
    END IF;
END $$;

-- ========================================
-- CONSULTAS DE VERIFICACIÓN
-- ========================================

-- Ver estructura jerárquica
SELECT 
    CASE WHEN nivel = 0 THEN nombre ELSE '  → ' || nombre END AS jerarquia,
    codigo,
    CASE WHEN seleccionable THEN 'Sí' ELSE 'No' END AS seleccionable,
    CASE WHEN activo THEN 'Activo' ELSE 'Inactivo' END AS estado,
    metadatos->>'codigo_dian' AS cod_dian,
    metadatos->>'emite' AS entidad_emisora
FROM shared_schema.catalogo_recursivo
WHERE catalogo_tipo = 'TIPO_DOCUMENTO'
  AND expiration_date IS NULL
ORDER BY nivel, orden;

-- Obtener árbol completo usando la función
-- SELECT * FROM shared_schema.catalogo_obtener_arbol('TIPO_DOCUMENTO', TRUE, TRUE);
