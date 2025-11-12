-- ============================================================================
-- Script: datos_nivel_educativo.sql
-- Descripción: Catálogo de Niveles Educativos (Jerárquico)
-- Autor: Database Engineer Senior
-- Fecha: 12 de noviembre de 2025
-- Estructura: 2 niveles (Categoría → Nivel Específico)
-- ============================================================================

-- NIVEL 0: CATEGORÍAS EDUCATIVAS (NO SELECCIONABLES)
-- ============================================================================

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
VALUES 
('NIVEL_EDUCATIVO', NULL, 'CAT-BASICA', 'Educación Básica', 'Basic Education', 'Educación fundamental obligatoria', 0, 1, TRUE, FALSE, 'fa-school', '#4A90E2', 
'{"tipo": "categoria", "edad_minima": 5, "edad_maxima": 15}'::jsonb);

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
VALUES 
('NIVEL_EDUCATIVO', NULL, 'CAT-MEDIA', 'Educación Media', 'Secondary Education', 'Educación secundaria y bachillerato', 0, 2, TRUE, FALSE, 'fa-graduation-cap', '#E67E22', 
'{"tipo": "categoria", "edad_minima": 15, "edad_maxima": 18}'::jsonb);

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
VALUES 
('NIVEL_EDUCATIVO', NULL, 'CAT-SUPERIOR', 'Educación Superior', 'Higher Education', 'Educación universitaria y técnica', 0, 3, TRUE, FALSE, 'fa-university', '#27AE60', 
'{"tipo": "categoria", "edad_minima": 18, "edad_maxima": null}'::jsonb);

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
VALUES 
('NIVEL_EDUCATIVO', NULL, 'CAT-POSTGRADO', 'Postgrado', 'Postgraduate', 'Estudios de cuarto nivel', 0, 4, TRUE, FALSE, 'fa-user-graduate', '#8E44AD', 
'{"tipo": "categoria", "edad_minima": 22, "edad_maxima": null}'::jsonb);

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
VALUES 
('NIVEL_EDUCATIVO', NULL, 'CAT-OTROS', 'Otros Niveles', 'Other Levels', 'Niveles educativos especiales', 0, 5, TRUE, FALSE, 'fa-book', '#95A5A6', 
'{"tipo": "categoria"}'::jsonb);


-- NIVEL 1: EDUCACIÓN BÁSICA (SELECCIONABLES)
-- ============================================================================

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'NIVEL_EDUCATIVO', pkid_catalogo_recursivo, 'PREESCOLAR', 'Preescolar', 'Preschool', 'Educación preescolar o jardín infantil', 1, 1, TRUE, TRUE, 'fa-child', '#FFB6C1',
'{"duracion_anos": 3, "edad_ingreso": 3, "edad_egreso": 5, "obligatorio": false, "tipo_nivel": "inicial"}'::jsonb
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-BASICA' AND catalogo_tipo = 'NIVEL_EDUCATIVO' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'NIVEL_EDUCATIVO', pkid_catalogo_recursivo, 'PRIMARIA', 'Educación Primaria', 'Primary Education', 'Educación básica primaria (1° a 5°)', 1, 2, TRUE, TRUE, 'fa-book-reader', '#4A90E2',
'{"duracion_anos": 5, "edad_ingreso": 6, "edad_egreso": 10, "obligatorio": true, "tipo_nivel": "basica_primaria", "grados": "1° a 5°"}'::jsonb
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-BASICA' AND catalogo_tipo = 'NIVEL_EDUCATIVO' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'NIVEL_EDUCATIVO', pkid_catalogo_recursivo, 'SECUNDARIA', 'Educación Secundaria', 'Secondary Education', 'Educación básica secundaria (6° a 9°)', 1, 3, TRUE, TRUE, 'fa-book-open', '#3498DB',
'{"duracion_anos": 4, "edad_ingreso": 11, "edad_egreso": 14, "obligatorio": true, "tipo_nivel": "basica_secundaria", "grados": "6° a 9°"}'::jsonb
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-BASICA' AND catalogo_tipo = 'NIVEL_EDUCATIVO' AND expiration_date IS NULL;


-- NIVEL 1: EDUCACIÓN MEDIA (SELECCIONABLES)
-- ============================================================================

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'NIVEL_EDUCATIVO', pkid_catalogo_recursivo, 'MEDIA', 'Educación Media', 'High School', 'Educación media vocacional (10° y 11°)', 1, 1, TRUE, TRUE, 'fa-school', '#E67E22',
'{"duracion_anos": 2, "edad_ingreso": 15, "edad_egreso": 16, "obligatorio": true, "tipo_nivel": "media", "grados": "10° y 11°", "titulo_otorga": "Bachiller"}'::jsonb
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-MEDIA' AND catalogo_tipo = 'NIVEL_EDUCATIVO' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'NIVEL_EDUCATIVO', pkid_catalogo_recursivo, 'MEDIA-TECNICA', 'Educación Media Técnica', 'Technical High School', 'Educación media con énfasis técnico', 1, 2, TRUE, TRUE, 'fa-cogs', '#D35400',
'{"duracion_anos": 2, "edad_ingreso": 15, "edad_egreso": 16, "obligatorio": false, "tipo_nivel": "media_tecnica", "grados": "10° y 11°", "titulo_otorga": "Bachiller Técnico"}'::jsonb
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-MEDIA' AND catalogo_tipo = 'NIVEL_EDUCATIVO' AND expiration_date IS NULL;


-- NIVEL 1: EDUCACIÓN SUPERIOR (SELECCIONABLES)
-- ============================================================================

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'NIVEL_EDUCATIVO', pkid_catalogo_recursivo, 'TECNICO', 'Técnico Profesional', 'Technical Professional', 'Formación técnica profesional (2 años)', 1, 1, TRUE, TRUE, 'fa-tools', '#16A085',
'{"duracion_anos": 2, "edad_ingreso": 17, "tipo_nivel": "tecnico_profesional", "titulo_otorga": "Técnico Profesional", "nivel_formacion": "T"}'::jsonb
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-SUPERIOR' AND catalogo_tipo = 'NIVEL_EDUCATIVO' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'NIVEL_EDUCATIVO', pkid_catalogo_recursivo, 'TECNOLOGICO', 'Tecnológico', 'Technological', 'Formación tecnológica (3 años)', 1, 2, TRUE, TRUE, 'fa-laptop-code', '#27AE60',
'{"duracion_anos": 3, "edad_ingreso": 17, "tipo_nivel": "tecnologico", "titulo_otorga": "Tecnólogo", "nivel_formacion": "TL"}'::jsonb
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-SUPERIOR' AND catalogo_tipo = 'NIVEL_EDUCATIVO' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'NIVEL_EDUCATIVO', pkid_catalogo_recursivo, 'PROFESIONAL', 'Profesional Universitario', 'University Degree', 'Educación universitaria profesional (4-5 años)', 1, 3, TRUE, TRUE, 'fa-university', '#2ECC71',
'{"duracion_anos": 5, "edad_ingreso": 17, "tipo_nivel": "profesional", "titulo_otorga": "Profesional", "nivel_formacion": "U"}'::jsonb
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-SUPERIOR' AND catalogo_tipo = 'NIVEL_EDUCATIVO' AND expiration_date IS NULL;


-- NIVEL 1: POSTGRADO (SELECCIONABLES)
-- ============================================================================

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'NIVEL_EDUCATIVO', pkid_catalogo_recursivo, 'ESPECIALIZACION', 'Especialización', 'Specialization', 'Especialización profesional (1-2 años)', 1, 1, TRUE, TRUE, 'fa-certificate', '#9B59B6',
'{"duracion_anos": 1, "edad_ingreso": 22, "tipo_nivel": "especializacion", "titulo_otorga": "Especialista", "nivel_formacion": "ESP", "requiere": "Título profesional"}'::jsonb
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-POSTGRADO' AND catalogo_tipo = 'NIVEL_EDUCATIVO' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'NIVEL_EDUCATIVO', pkid_catalogo_recursivo, 'MAESTRIA', 'Maestría', 'Master Degree', 'Maestría o magíster (2 años)', 1, 2, TRUE, TRUE, 'fa-user-graduate', '#8E44AD',
'{"duracion_anos": 2, "edad_ingreso": 22, "tipo_nivel": "maestria", "titulo_otorga": "Magíster", "nivel_formacion": "M", "requiere": "Título profesional"}'::jsonb
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-POSTGRADO' AND catalogo_tipo = 'NIVEL_EDUCATIVO' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'NIVEL_EDUCATIVO', pkid_catalogo_recursivo, 'DOCTORADO', 'Doctorado', 'PhD', 'Doctorado (4-5 años)', 1, 3, TRUE, TRUE, 'fa-award', '#6C3483',
'{"duracion_anos": 4, "edad_ingreso": 24, "tipo_nivel": "doctorado", "titulo_otorga": "Doctor", "nivel_formacion": "D", "requiere": "Título de maestría"}'::jsonb
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-POSTGRADO' AND catalogo_tipo = 'NIVEL_EDUCATIVO' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'NIVEL_EDUCATIVO', pkid_catalogo_recursivo, 'POSTDOCTORADO', 'Postdoctorado', 'Postdoctoral', 'Estudios postdoctorales (2-3 años)', 1, 4, TRUE, TRUE, 'fa-brain', '#5B2C6F',
'{"duracion_anos": 2, "edad_ingreso": 28, "tipo_nivel": "postdoctorado", "titulo_otorga": "Postdoctor", "nivel_formacion": "PD", "requiere": "Título de doctorado"}'::jsonb
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-POSTGRADO' AND catalogo_tipo = 'NIVEL_EDUCATIVO' AND expiration_date IS NULL;


-- NIVEL 1: OTROS NIVELES (SELECCIONABLES)
-- ============================================================================

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'NIVEL_EDUCATIVO', pkid_catalogo_recursivo, 'SIN-ESTUDIOS', 'Sin Estudios Formales', 'No Formal Education', 'Persona sin educación formal', 1, 1, TRUE, TRUE, 'fa-minus-circle', '#95A5A6',
'{"tipo_nivel": "ninguno"}'::jsonb
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-OTROS' AND catalogo_tipo = 'NIVEL_EDUCATIVO' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'NIVEL_EDUCATIVO', pkid_catalogo_recursivo, 'EDUCACION-BASICA-ADULTOS', 'Educación Básica Adultos', 'Adult Basic Education', 'Educación básica para adultos', 1, 2, TRUE, TRUE, 'fa-chalkboard-teacher', '#7F8C8D',
'{"tipo_nivel": "adultos", "edad_minima": 18, "modalidad": "Adultos"}'::jsonb
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-OTROS' AND catalogo_tipo = 'NIVEL_EDUCATIVO' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'NIVEL_EDUCATIVO', pkid_catalogo_recursivo, 'EDUCACION-ESPECIAL', 'Educación Especial', 'Special Education', 'Educación para personas con necesidades especiales', 1, 3, TRUE, TRUE, 'fa-hands-helping', '#34495E',
'{"tipo_nivel": "especial", "modalidad": "Educación inclusiva"}'::jsonb
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-OTROS' AND catalogo_tipo = 'NIVEL_EDUCATIVO' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'NIVEL_EDUCATIVO', pkid_catalogo_recursivo, 'CURSOS-CORTOS', 'Cursos y Diplomados', 'Short Courses & Diplomas', 'Cursos cortos, diplomados y certificaciones', 1, 4, TRUE, TRUE, 'fa-file-certificate', '#BDC3C7',
'{"tipo_nivel": "complementario", "duracion_variable": true}'::jsonb
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-OTROS' AND catalogo_tipo = 'NIVEL_EDUCATIVO' AND expiration_date IS NULL;


-- VERIFICACIÓN
-- ============================================================================

DO $$
DECLARE 
    v_categorias INTEGER;
    v_niveles INTEGER;
    v_total INTEGER;
    v_detalle TEXT;
BEGIN
    -- Contar categorías (nivel 0)
    SELECT COUNT(*) INTO v_categorias 
    FROM shared_schema.catalogo_recursivo
    WHERE catalogo_tipo = 'NIVEL_EDUCATIVO' 
    AND nivel = 0 
    AND expiration_date IS NULL;
    
    -- Contar niveles específicos (nivel 1)
    SELECT COUNT(*) INTO v_niveles 
    FROM shared_schema.catalogo_recursivo
    WHERE catalogo_tipo = 'NIVEL_EDUCATIVO' 
    AND nivel = 1 
    AND expiration_date IS NULL;
    
    -- Total
    v_total := v_categorias + v_niveles;
    
    RAISE NOTICE '=================================================';
    RAISE NOTICE 'CATÁLOGO NIVEL EDUCATIVO - RESUMEN';
    RAISE NOTICE '=================================================';
    RAISE NOTICE 'Categorías (Nivel 0): %', v_categorias;
    RAISE NOTICE 'Niveles Educativos (Nivel 1): %', v_niveles;
    RAISE NOTICE 'TOTAL REGISTROS: %', v_total;
    RAISE NOTICE '=================================================';
    RAISE NOTICE '';
    RAISE NOTICE 'Desglose por categoría:';
    RAISE NOTICE '-------------------------------------------------';
    
    -- Desglose por categoría
    FOR v_detalle IN 
        SELECT cr_padre.nombre || ': ' || COUNT(cr_hijo.pkid_catalogo_recursivo) || ' niveles'
        FROM shared_schema.catalogo_recursivo cr_padre
        LEFT JOIN shared_schema.catalogo_recursivo cr_hijo 
            ON cr_hijo.fkid_padre = cr_padre.pkid_catalogo_recursivo 
            AND cr_hijo.expiration_date IS NULL
        WHERE cr_padre.catalogo_tipo = 'NIVEL_EDUCATIVO' 
        AND cr_padre.nivel = 0 
        AND cr_padre.expiration_date IS NULL
        GROUP BY cr_padre.nombre, cr_padre.orden
        ORDER BY cr_padre.orden
    LOOP
        RAISE NOTICE '%', v_detalle;
    END LOOP;
    
    RAISE NOTICE '=================================================';
END $$;
