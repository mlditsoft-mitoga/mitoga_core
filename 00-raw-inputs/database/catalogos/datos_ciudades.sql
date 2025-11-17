-- ============================================================================
-- Script: datos_ciudades.sql
-- Descripción: Catálogo Jerárquico de Ciudades por País
-- Autor: Database Engineer Senior
-- Fecha: 12 de noviembre de 2025
-- Niveles: Continente (0) → País (1) → Ciudad (2)
-- ============================================================================

-- ========================================
-- NOTA IMPORTANTE
-- ========================================
-- Este script asume que ya existen los datos de países (datos_paises.sql)
-- Si no existen, ejecuta primero datos_paises.sql

-- ========================================
-- NIVEL 2: CIUDADES DE COLOMBIA
-- ========================================

-- Bogotá
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-BOG',
    'Bogotá',
    'Bogota',
    'Bogotá D.C. - Capital de Colombia',
    'Bogota D.C. - Capital of Colombia',
    1,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": true, "departamento": "Cundinamarca", "poblacion_millones": 7.9, "altitud_msnm": 2640, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Medellín
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-MDE',
    'Medellín',
    'Medellin',
    'Medellín - Ciudad de la Eterna Primavera',
    'Medellin - City of Eternal Spring',
    2,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Antioquia", "poblacion_millones": 2.5, "altitud_msnm": 1495, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Cali
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-CLI',
    'Cali',
    'Cali',
    'Santiago de Cali - Capital de la Salsa',
    'Santiago de Cali - Salsa Capital',
    3,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Valle del Cauca", "poblacion_millones": 2.2, "altitud_msnm": 1018, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Barranquilla
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-BAQ',
    'Barranquilla',
    'Barranquilla',
    'Barranquilla - Puerta de Oro de Colombia',
    'Barranquilla - Golden Gate of Colombia',
    4,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Atlántico", "poblacion_millones": 1.2, "altitud_msnm": 18, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Cartagena
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-CTG',
    'Cartagena',
    'Cartagena',
    'Cartagena de Indias - Ciudad Heroica',
    'Cartagena de Indias - Heroic City',
    5,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Bolívar", "poblacion_millones": 0.9, "altitud_msnm": 2, "zona_horaria": "UTC-5", "turistica": true}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Bucaramanga
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-BGA',
    'Bucaramanga',
    'Bucaramanga',
    'Bucaramanga - Ciudad Bonita',
    'Bucaramanga - Beautiful City',
    6,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Santander", "poblacion_millones": 0.6, "altitud_msnm": 959, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Cúcuta
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-CUC',
    'Cúcuta',
    'Cucuta',
    'San José de Cúcuta - Capital de Norte de Santander',
    'San Jose de Cucuta - Capital of Norte de Santander',
    7,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Norte de Santander", "poblacion_millones": 0.7, "altitud_msnm": 320, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Pereira
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-PEI',
    'Pereira',
    'Pereira',
    'Pereira - Perla del Eje Cafetero',
    'Pereira - Pearl of Coffee Region',
    8,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Risaralda", "poblacion_millones": 0.5, "altitud_msnm": 1411, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Santa Marta
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-SMR',
    'Santa Marta',
    'Santa Marta',
    'Santa Marta - Perla de América',
    'Santa Marta - Pearl of America',
    9,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Magdalena", "poblacion_millones": 0.5, "altitud_msnm": 6, "zona_horaria": "UTC-5", "turistica": true}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Ibagué
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-IBE',
    'Ibagué',
    'Ibague',
    'Ibagué - Capital Musical de Colombia',
    'Ibague - Musical Capital of Colombia',
    10,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Tolima", "poblacion_millones": 0.5, "altitud_msnm": 1285, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Manizales
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-MZL',
    'Manizales',
    'Manizales',
    'Manizales - Ciudad de las Puertas Abiertas',
    'Manizales - City of Open Doors',
    11,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Caldas", "poblacion_millones": 0.4, "altitud_msnm": 2150, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Villavicencio
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-VVC',
    'Villavicencio',
    'Villavicencio',
    'Villavicencio - Puerta al Llano',
    'Villavicencio - Gateway to the Plains',
    12,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Meta", "poblacion_millones": 0.5, "altitud_msnm": 467, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Pasto
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-PSO',
    'Pasto',
    'Pasto',
    'San Juan de Pasto - Capital de Nariño',
    'San Juan de Pasto - Capital of Narino',
    13,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Nariño", "poblacion_millones": 0.4, "altitud_msnm": 2527, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Armenia
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-AXM',
    'Armenia',
    'Armenia',
    'Armenia - Corazón del Eje Cafetero',
    'Armenia - Heart of Coffee Region',
    14,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Quindío", "poblacion_millones": 0.3, "altitud_msnm": 1483, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Neiva
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-NVA',
    'Neiva',
    'Neiva',
    'Neiva - Capital del Huila',
    'Neiva - Capital of Huila',
    15,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Huila", "poblacion_millones": 0.3, "altitud_msnm": 442, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Popayán
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-PPN',
    'Popayán',
    'Popayan',
    'Popayán - Ciudad Blanca',
    'Popayan - White City',
    16,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Cauca", "poblacion_millones": 0.3, "altitud_msnm": 1738, "zona_horaria": "UTC-5", "patrimonio_unesco": true}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Valledupar
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-VUP',
    'Valledupar',
    'Valledupar',
    'Valledupar - Capital del Vallenato',
    'Valledupar - Vallenato Capital',
    17,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Cesar", "poblacion_millones": 0.5, "altitud_msnm": 169, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Montería
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-MTR',
    'Montería',
    'Monteria',
    'Montería - Perla del Sinú',
    'Monteria - Pearl of Sinu',
    18,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Córdoba", "poblacion_millones": 0.5, "altitud_msnm": 18, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Sincelejo
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-SIN',
    'Sincelejo',
    'Sincelejo',
    'Sincelejo - Capital de Sucre',
    'Sincelejo - Capital of Sucre',
    19,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Sucre", "poblacion_millones": 0.3, "altitud_msnm": 213, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Tunja
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-TUN',
    'Tunja',
    'Tunja',
    'Tunja - Capital de Boyacá',
    'Tunja - Capital of Boyaca',
    20,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Boyacá", "poblacion_millones": 0.2, "altitud_msnm": 2820, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Riohacha
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-RCH',
    'Riohacha',
    'Riohacha',
    'Riohacha - Capital de La Guajira',
    'Riohacha - Capital of La Guajira',
    21,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "La Guajira", "poblacion_millones": 0.3, "altitud_msnm": 6, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Quibdó
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-UIB',
    'Quibdó',
    'Quibdo',
    'Quibdó - Capital del Chocó',
    'Quibdo - Capital of Choco',
    22,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Chocó", "poblacion_millones": 0.1, "altitud_msnm": 43, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Florencia
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-FLA',
    'Florencia',
    'Florencia',
    'Florencia - Puerta de Oro de la Amazonia',
    'Florencia - Golden Gate of the Amazon',
    23,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Caquetá", "poblacion_millones": 0.2, "altitud_msnm": 242, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Yopal
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-YOP',
    'Yopal',
    'Yopal',
    'Yopal - Capital de Casanare',
    'Yopal - Capital of Casanare',
    24,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Casanare", "poblacion_millones": 0.1, "altitud_msnm": 350, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Arauca
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-AUC',
    'Arauca',
    'Arauca',
    'Arauca - Capital del Arauca',
    'Arauca - Capital of Arauca',
    25,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Arauca", "poblacion_millones": 0.1, "altitud_msnm": 128, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Mocoa
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-MOC',
    'Mocoa',
    'Mocoa',
    'Mocoa - Capital del Putumayo',
    'Mocoa - Capital of Putumayo',
    26,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Putumayo", "poblacion_millones": 0.05, "altitud_msnm": 655, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Leticia
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-LET',
    'Leticia',
    'Leticia',
    'Leticia - Capital del Amazonas',
    'Leticia - Capital of Amazonas',
    27,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Amazonas", "poblacion_millones": 0.04, "altitud_msnm": 96, "zona_horaria": "UTC-5", "frontera": true}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Puerto Carreño
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-PCR',
    'Puerto Carreño',
    'Puerto Carreno',
    'Puerto Carreño - Capital del Vichada',
    'Puerto Carreno - Capital of Vichada',
    28,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Vichada", "poblacion_millones": 0.02, "altitud_msnm": 51, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- San José del Guaviare
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-SJE',
    'San José del Guaviare',
    'San Jose del Guaviare',
    'San José del Guaviare - Capital del Guaviare',
    'San Jose del Guaviare - Capital of Guaviare',
    29,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Guaviare", "poblacion_millones": 0.05, "altitud_msnm": 175, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Mitú
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-MIT',
    'Mitú',
    'Mitu',
    'Mitú - Capital del Vaupés',
    'Mitu - Capital of Vaupes',
    30,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Vaupés", "poblacion_millones": 0.02, "altitud_msnm": 180, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Inírida
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-INI',
    'Inírida',
    'Inirida',
    'Inírida - Capital del Guainía',
    'Inirida - Capital of Guainia',
    31,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Guainía", "poblacion_millones": 0.02, "altitud_msnm": 95, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Soacha
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-SOA',
    'Soacha',
    'Soacha',
    'Soacha - Área Metropolitana de Bogotá',
    'Soacha - Bogota Metropolitan Area',
    32,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Cundinamarca", "poblacion_millones": 0.7, "altitud_msnm": 2566, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Bello
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CO-BLL',
    'Bello',
    'Bello',
    'Bello - Área Metropolitana de Medellín',
    'Bello - Medellin Metropolitan Area',
    33,
    TRUE,
    TRUE,
    'fa-city',
    '#FFD700',
    '{"pais_codigo": "CO", "capital": false, "departamento": "Antioquia", "poblacion_millones": 0.5, "altitud_msnm": 1450, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CO' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- ========================================
-- NIVEL 2: CIUDADES DE MÉXICO
-- ========================================

-- Ciudad de México
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'MX-CMX',
    'Ciudad de México',
    'Mexico City',
    'Ciudad de México - Capital de México',
    'Mexico City - Capital of Mexico',
    1,
    TRUE,
    TRUE,
    'fa-city',
    '#006341',
    '{"pais_codigo": "MX", "capital": true, "estado": "Ciudad de México", "poblacion_millones": 9.2, "altitud_msnm": 2240, "zona_horaria": "UTC-6"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'MX' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Guadalajara
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'MX-GDL',
    'Guadalajara',
    'Guadalajara',
    'Guadalajara - Perla de Occidente',
    'Guadalajara - Pearl of the West',
    2,
    TRUE,
    TRUE,
    'fa-city',
    '#006341',
    '{"pais_codigo": "MX", "capital": false, "estado": "Jalisco", "poblacion_millones": 1.5, "altitud_msnm": 1566, "zona_horaria": "UTC-6"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'MX' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Monterrey
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'MX-MTY',
    'Monterrey',
    'Monterrey',
    'Monterrey - Sultana del Norte',
    'Monterrey - Sultan of the North',
    3,
    TRUE,
    TRUE,
    'fa-city',
    '#006341',
    '{"pais_codigo": "MX", "capital": false, "estado": "Nuevo León", "poblacion_millones": 1.1, "altitud_msnm": 540, "zona_horaria": "UTC-6"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'MX' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- ========================================
-- NIVEL 2: CIUDADES DE ARGENTINA
-- ========================================

-- Buenos Aires
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'AR-BUE',
    'Buenos Aires',
    'Buenos Aires',
    'Buenos Aires - Capital Federal',
    'Buenos Aires - Federal Capital',
    1,
    TRUE,
    TRUE,
    'fa-city',
    '#74ACDF',
    '{"pais_codigo": "AR", "capital": true, "provincia": "Ciudad Autónoma", "poblacion_millones": 3.1, "altitud_msnm": 25, "zona_horaria": "UTC-3"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'AR' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Córdoba
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'AR-COR',
    'Córdoba',
    'Cordoba',
    'Córdoba - La Docta',
    'Cordoba - The Learned',
    2,
    TRUE,
    TRUE,
    'fa-city',
    '#74ACDF',
    '{"pais_codigo": "AR", "capital": false, "provincia": "Córdoba", "poblacion_millones": 1.3, "altitud_msnm": 390, "zona_horaria": "UTC-3"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'AR' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Rosario
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'AR-ROS',
    'Rosario',
    'Rosario',
    'Rosario - Cuna de la Bandera',
    'Rosario - Cradle of the Flag',
    3,
    TRUE,
    TRUE,
    'fa-city',
    '#74ACDF',
    '{"pais_codigo": "AR", "capital": false, "provincia": "Santa Fe", "poblacion_millones": 0.9, "altitud_msnm": 22, "zona_horaria": "UTC-3"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'AR' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- ========================================
-- NIVEL 2: CIUDADES DE BRASIL
-- ========================================

-- Brasília
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'BR-BSB',
    'Brasília',
    'Brasilia',
    'Brasília - Capital Federal',
    'Brasilia - Federal Capital',
    1,
    TRUE,
    TRUE,
    'fa-city',
    '#009B3A',
    '{"pais_codigo": "BR", "capital": true, "estado": "Distrito Federal", "poblacion_millones": 3.0, "altitud_msnm": 1172, "zona_horaria": "UTC-3"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'BR' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- São Paulo
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'BR-SAO',
    'São Paulo',
    'Sao Paulo',
    'São Paulo - Ciudad más poblada de Brasil',
    'Sao Paulo - Most populated city in Brazil',
    2,
    TRUE,
    TRUE,
    'fa-city',
    '#009B3A',
    '{"pais_codigo": "BR", "capital": false, "estado": "São Paulo", "poblacion_millones": 12.3, "altitud_msnm": 760, "zona_horaria": "UTC-3"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'BR' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Río de Janeiro
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'BR-RIO',
    'Río de Janeiro',
    'Rio de Janeiro',
    'Río de Janeiro - Ciudad Maravillosa',
    'Rio de Janeiro - Marvelous City',
    3,
    TRUE,
    TRUE,
    'fa-city',
    '#009B3A',
    '{"pais_codigo": "BR", "capital": false, "estado": "Río de Janeiro", "poblacion_millones": 6.7, "altitud_msnm": 11, "zona_horaria": "UTC-3", "turistica": true}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'BR' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- ========================================
-- NIVEL 2: CIUDADES DE CHILE
-- ========================================

-- Santiago
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CL-SCL',
    'Santiago',
    'Santiago',
    'Santiago de Chile - Capital',
    'Santiago de Chile - Capital',
    1,
    TRUE,
    TRUE,
    'fa-city',
    '#D52B1E',
    '{"pais_codigo": "CL", "capital": true, "region": "Metropolitana", "poblacion_millones": 6.3, "altitud_msnm": 570, "zona_horaria": "UTC-4"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CL' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Valparaíso
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'CL-VAL',
    'Valparaíso',
    'Valparaiso',
    'Valparaíso - Joya del Pacífico',
    'Valparaiso - Jewel of the Pacific',
    2,
    TRUE,
    TRUE,
    'fa-city',
    '#D52B1E',
    '{"pais_codigo": "CL", "capital": false, "region": "Valparaíso", "poblacion_millones": 0.3, "altitud_msnm": 41, "zona_horaria": "UTC-4", "patrimonio_unesco": true}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'CL' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- ========================================
-- NIVEL 2: CIUDADES DE PERÚ
-- ========================================

-- Lima
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'PE-LIM',
    'Lima',
    'Lima',
    'Lima - Ciudad de los Reyes',
    'Lima - City of Kings',
    1,
    TRUE,
    TRUE,
    'fa-city',
    '#D91023',
    '{"pais_codigo": "PE", "capital": true, "departamento": "Lima", "poblacion_millones": 9.7, "altitud_msnm": 154, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'PE' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Cusco
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'PE-CUZ',
    'Cusco',
    'Cusco',
    'Cusco - Ombligo del Mundo',
    'Cusco - Navel of the World',
    2,
    TRUE,
    TRUE,
    'fa-city',
    '#D91023',
    '{"pais_codigo": "PE", "capital": false, "departamento": "Cusco", "poblacion_millones": 0.4, "altitud_msnm": 3399, "zona_horaria": "UTC-5", "turistica": true, "patrimonio_unesco": true}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'PE' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- ========================================
-- NIVEL 2: CIUDADES DE ESPAÑA
-- ========================================

-- Madrid
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'ES-MAD',
    'Madrid',
    'Madrid',
    'Madrid - Capital de España',
    'Madrid - Capital of Spain',
    1,
    TRUE,
    TRUE,
    'fa-city',
    '#C60B1E',
    '{"pais_codigo": "ES", "capital": true, "comunidad": "Madrid", "poblacion_millones": 3.3, "altitud_msnm": 667, "zona_horaria": "UTC+1"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'ES' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Barcelona
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'ES-BCN',
    'Barcelona',
    'Barcelona',
    'Barcelona - Ciudad Condal',
    'Barcelona - Condal City',
    2,
    TRUE,
    TRUE,
    'fa-city',
    '#C60B1E',
    '{"pais_codigo": "ES", "capital": false, "comunidad": "Cataluña", "poblacion_millones": 1.6, "altitud_msnm": 12, "zona_horaria": "UTC+1", "turistica": true}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'ES' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Sevilla
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'ES-SVQ',
    'Sevilla',
    'Seville',
    'Sevilla - Capital de Andalucía',
    'Seville - Capital of Andalusia',
    3,
    TRUE,
    TRUE,
    'fa-city',
    '#C60B1E',
    '{"pais_codigo": "ES", "capital": false, "comunidad": "Andalucía", "poblacion_millones": 0.7, "altitud_msnm": 7, "zona_horaria": "UTC+1"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'ES' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- ========================================
-- NIVEL 2: CIUDADES DE ESTADOS UNIDOS
-- ========================================

-- Washington D.C.
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'US-WAS',
    'Washington D.C.',
    'Washington D.C.',
    'Washington D.C. - Capital Federal',
    'Washington D.C. - Federal Capital',
    1,
    TRUE,
    TRUE,
    'fa-city',
    '#B22234',
    '{"pais_codigo": "US", "capital": true, "estado": "Distrito de Columbia", "poblacion_millones": 0.7, "altitud_msnm": 125, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'US' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Nueva York
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'US-NYC',
    'Nueva York',
    'New York',
    'Nueva York - La Gran Manzana',
    'New York - The Big Apple',
    2,
    TRUE,
    TRUE,
    'fa-city',
    '#B22234',
    '{"pais_codigo": "US", "capital": false, "estado": "Nueva York", "poblacion_millones": 8.3, "altitud_msnm": 10, "zona_horaria": "UTC-5"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'US' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Los Ángeles
INSERT INTO appmatch_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, descripcion_en, orden, activo, seleccionable, icono, color, metadatos)
SELECT
    'CIUDAD',
    pkid_catalogo_recursivo,
    'US-LAX',
    'Los Ángeles',
    'Los Angeles',
    'Los Ángeles - Ciudad de las Estrellas',
    'Los Angeles - City of Stars',
    3,
    TRUE,
    TRUE,
    'fa-city',
    '#B22234',
    '{"pais_codigo": "US", "capital": false, "estado": "California", "poblacion_millones": 4.0, "altitud_msnm": 93, "zona_horaria": "UTC-8"}'::jsonb
FROM appmatch_schema.catalogo_recursivo
WHERE codigo = 'US' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- ========================================
-- VERIFICACIÓN DE INSERCIÓN
-- ========================================

DO $$
DECLARE
    v_count_ciudades INTEGER;
BEGIN
    -- Contar ciudades insertadas
    SELECT COUNT(*) INTO v_count_ciudades
    FROM appmatch_schema.catalogo_recursivo
    WHERE catalogo_tipo = 'CIUDAD' 
      AND expiration_date IS NULL;
    
    -- Log de resultados
    RAISE NOTICE '================================================';
    RAISE NOTICE 'CATÁLOGO CIUDAD INSERTADO';
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Total ciudades insertadas: %', v_count_ciudades;
    RAISE NOTICE '================================================';
    
    -- Validación
    IF v_count_ciudades < 25 THEN
        RAISE WARNING 'Se esperaban al menos 25 ciudades, se insertaron %', v_count_ciudades;
    END IF;
END $$;

-- ========================================
-- CONSULTAS DE VERIFICACIÓN
-- ========================================

-- Ver ciudades por país
SELECT 
    p.nombre as pais,
    c.nombre as ciudad,
    c.codigo,
    c.metadatos->>'poblacion_millones' as poblacion_millones,
    c.metadatos->>'capital' as es_capital
FROM appmatch_schema.catalogo_recursivo c
INNER JOIN appmatch_schema.catalogo_recursivo p ON c.fkid_padre = p.pkid_catalogo_recursivo
WHERE c.catalogo_tipo = 'CIUDAD'
  AND c.expiration_date IS NULL
ORDER BY p.nombre, c.orden;

-- Obtener árbol completo de ciudades
-- SELECT * FROM appmatch_schema.catalogo_obtener_arbol('CIUDAD', TRUE, TRUE);
