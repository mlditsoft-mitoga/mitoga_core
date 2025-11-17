-- ============================================================================
-- Script: datos_paises_02_america.sql
-- Descripción: Países de América (Nivel 1)
-- Autor: Database Engineer Senior
-- Fecha: 12 de noviembre de 2025
-- Parte: 2 de 6 - América (35 países)
-- ============================================================================

-- América del Sur

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'AR', 'Argentina', 'Argentina', 'República Argentina', 1, 1, TRUE, TRUE, 'fa-flag', '#74ACDF',
'{"iso2": "AR", "iso3": "ARG", "codigo_numerico": "032", "capital": "Buenos Aires", "moneda": "ARS", "idioma": "es", "zona_horaria": "UTC-3", "codigo_telefono": "+54", "poblacion_millones": 45.8}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'BO', 'Bolivia', 'Bolivia', 'Estado Plurinacional de Bolivia', 1, 2, TRUE, TRUE, 'fa-flag', '#007A3D',
'{"iso2": "BO", "iso3": "BOL", "codigo_numerico": "068", "capital": "Sucre", "moneda": "BOB", "idioma": "es", "zona_horaria": "UTC-4", "codigo_telefono": "+591", "poblacion_millones": 12.0}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'BR', 'Brasil', 'Brazil', 'República Federativa del Brasil', 1, 3, TRUE, TRUE, 'fa-flag', '#009B3A',
'{"iso2": "BR", "iso3": "BRA", "codigo_numerico": "076", "capital": "Brasília", "moneda": "BRL", "idioma": "pt", "zona_horaria": "UTC-3", "codigo_telefono": "+55", "poblacion_millones": 215.3}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'CL', 'Chile', 'Chile', 'República de Chile', 1, 4, TRUE, TRUE, 'fa-flag', '#D52B1E',
'{"iso2": "CL", "iso3": "CHL", "codigo_numerico": "152", "capital": "Santiago", "moneda": "CLP", "idioma": "es", "zona_horaria": "UTC-4", "codigo_telefono": "+56", "poblacion_millones": 19.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'CO', 'Colombia', 'Colombia', 'República de Colombia', 1, 5, TRUE, TRUE, 'fa-flag', '#FFD700',
'{"iso2": "CO", "iso3": "COL", "codigo_numerico": "170", "capital": "Bogotá", "moneda": "COP", "idioma": "es", "zona_horaria": "UTC-5", "codigo_telefono": "+57", "poblacion_millones": 51.6}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'EC', 'Ecuador', 'Ecuador', 'República del Ecuador', 1, 6, TRUE, TRUE, 'fa-flag', '#FFD100',
'{"iso2": "EC", "iso3": "ECU", "codigo_numerico": "218", "capital": "Quito", "moneda": "USD", "idioma": "es", "zona_horaria": "UTC-5", "codigo_telefono": "+593", "poblacion_millones": 18.0}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'GY', 'Guyana', 'Guyana', 'República Cooperativa de Guyana', 1, 7, TRUE, TRUE, 'fa-flag', '#009E49',
'{"iso2": "GY", "iso3": "GUY", "codigo_numerico": "328", "capital": "Georgetown", "moneda": "GYD", "idioma": "en", "zona_horaria": "UTC-4", "codigo_telefono": "+592", "poblacion_millones": 0.8}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'PY', 'Paraguay', 'Paraguay', 'República del Paraguay', 1, 8, TRUE, TRUE, 'fa-flag', '#D52B1E',
'{"iso2": "PY", "iso3": "PRY", "codigo_numerico": "600", "capital": "Asunción", "moneda": "PYG", "idioma": "es", "zona_horaria": "UTC-4", "codigo_telefono": "+595", "poblacion_millones": 7.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'PE', 'Perú', 'Peru', 'República del Perú', 1, 9, TRUE, TRUE, 'fa-flag', '#D91023',
'{"iso2": "PE", "iso3": "PER", "codigo_numerico": "604", "capital": "Lima", "moneda": "PEN", "idioma": "es", "zona_horaria": "UTC-5", "codigo_telefono": "+51", "poblacion_millones": 33.7}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'SR', 'Surinam', 'Suriname', 'República de Surinam', 1, 10, TRUE, TRUE, 'fa-flag', '#377E3F',
'{"iso2": "SR", "iso3": "SUR", "codigo_numerico": "740", "capital": "Paramaribo", "moneda": "SRD", "idioma": "nl", "zona_horaria": "UTC-3", "codigo_telefono": "+597", "poblacion_millones": 0.6}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'UY', 'Uruguay', 'Uruguay', 'República Oriental del Uruguay', 1, 11, TRUE, TRUE, 'fa-flag', '#0038A8',
'{"iso2": "UY", "iso3": "URY", "codigo_numerico": "858", "capital": "Montevideo", "moneda": "UYU", "idioma": "es", "zona_horaria": "UTC-3", "codigo_telefono": "+598", "poblacion_millones": 3.4}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'VE', 'Venezuela', 'Venezuela', 'República Bolivariana de Venezuela', 1, 12, TRUE, TRUE, 'fa-flag', '#FFCC00',
'{"iso2": "VE", "iso3": "VEN", "codigo_numerico": "862", "capital": "Caracas", "moneda": "VES", "idioma": "es", "zona_horaria": "UTC-4", "codigo_telefono": "+58", "poblacion_millones": 28.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- América Central

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'BZ', 'Belice', 'Belize', 'Belice', 1, 13, TRUE, TRUE, 'fa-flag', '#003F87',
'{"iso2": "BZ", "iso3": "BLZ", "codigo_numerico": "084", "capital": "Belmopán", "moneda": "BZD", "idioma": "en", "zona_horaria": "UTC-6", "codigo_telefono": "+501", "poblacion_millones": 0.4}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'CR', 'Costa Rica', 'Costa Rica', 'República de Costa Rica', 1, 14, TRUE, TRUE, 'fa-flag', '#002B7F',
'{"iso2": "CR", "iso3": "CRI", "codigo_numerico": "188", "capital": "San José", "moneda": "CRC", "idioma": "es", "zona_horaria": "UTC-6", "codigo_telefono": "+506", "poblacion_millones": 5.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'SV', 'El Salvador', 'El Salvador', 'República de El Salvador', 1, 15, TRUE, TRUE, 'fa-flag', '#0047AB',
'{"iso2": "SV", "iso3": "SLV", "codigo_numerico": "222", "capital": "San Salvador", "moneda": "USD", "idioma": "es", "zona_horaria": "UTC-6", "codigo_telefono": "+503", "poblacion_millones": 6.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'GT', 'Guatemala', 'Guatemala', 'República de Guatemala', 1, 16, TRUE, TRUE, 'fa-flag', '#4997D0',
'{"iso2": "GT", "iso3": "GTM", "codigo_numerico": "320", "capital": "Ciudad de Guatemala", "moneda": "GTQ", "idioma": "es", "zona_horaria": "UTC-6", "codigo_telefono": "+502", "poblacion_millones": 17.4}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'HN', 'Honduras', 'Honduras', 'República de Honduras', 1, 17, TRUE, TRUE, 'fa-flag', '#0073CF',
'{"iso2": "HN", "iso3": "HND", "codigo_numerico": "340", "capital": "Tegucigalpa", "moneda": "HNL", "idioma": "es", "zona_horaria": "UTC-6", "codigo_telefono": "+504", "poblacion_millones": 10.3}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'MX', 'México', 'Mexico', 'Estados Unidos Mexicanos', 1, 18, TRUE, TRUE, 'fa-flag', '#006341',
'{"iso2": "MX", "iso3": "MEX", "codigo_numerico": "484", "capital": "Ciudad de México", "moneda": "MXN", "idioma": "es", "zona_horaria": "UTC-6", "codigo_telefono": "+52", "poblacion_millones": 128.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'NI', 'Nicaragua', 'Nicaragua', 'República de Nicaragua', 1, 19, TRUE, TRUE, 'fa-flag', '#0067C6',
'{"iso2": "NI", "iso3": "NIC", "codigo_numerico": "558", "capital": "Managua", "moneda": "NIO", "idioma": "es", "zona_horaria": "UTC-6", "codigo_telefono": "+505", "poblacion_millones": 6.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'PA', 'Panamá', 'Panama', 'República de Panamá', 1, 20, TRUE, TRUE, 'fa-flag', '#DA121A',
'{"iso2": "PA", "iso3": "PAN", "codigo_numerico": "591", "capital": "Ciudad de Panamá", "moneda": "PAB", "idioma": "es", "zona_horaria": "UTC-5", "codigo_telefono": "+507", "poblacion_millones": 4.4}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- América del Norte

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'CA', 'Canadá', 'Canada', 'Canadá', 1, 21, TRUE, TRUE, 'fa-flag', '#FF0000',
'{"iso2": "CA", "iso3": "CAN", "codigo_numerico": "124", "capital": "Ottawa", "moneda": "CAD", "idioma": "en", "zona_horaria": "UTC-5", "codigo_telefono": "+1", "poblacion_millones": 38.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'US', 'Estados Unidos', 'United States', 'Estados Unidos de América', 1, 22, TRUE, TRUE, 'fa-flag', '#B22234',
'{"iso2": "US", "iso3": "USA", "codigo_numerico": "840", "capital": "Washington D.C.", "moneda": "USD", "idioma": "en", "zona_horaria": "UTC-5", "codigo_telefono": "+1", "poblacion_millones": 331.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Caribe

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'CU', 'Cuba', 'Cuba', 'República de Cuba', 1, 23, TRUE, TRUE, 'fa-flag', '#002A8F',
'{"iso2": "CU", "iso3": "CUB", "codigo_numerico": "192", "capital": "La Habana", "moneda": "CUP", "idioma": "es", "zona_horaria": "UTC-5", "codigo_telefono": "+53", "poblacion_millones": 11.3}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'DO', 'República Dominicana', 'Dominican Republic', 'República Dominicana', 1, 24, TRUE, TRUE, 'fa-flag', '#002D62',
'{"iso2": "DO", "iso3": "DOM", "codigo_numerico": "214", "capital": "Santo Domingo", "moneda": "DOP", "idioma": "es", "zona_horaria": "UTC-4", "codigo_telefono": "+1-809", "poblacion_millones": 11.1}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'HT', 'Haití', 'Haiti', 'República de Haití', 1, 25, TRUE, TRUE, 'fa-flag', '#00209F',
'{"iso2": "HT", "iso3": "HTI", "codigo_numerico": "332", "capital": "Puerto Príncipe", "moneda": "HTG", "idioma": "fr", "zona_horaria": "UTC-5", "codigo_telefono": "+509", "poblacion_millones": 11.7}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'JM', 'Jamaica', 'Jamaica', 'Jamaica', 1, 26, TRUE, TRUE, 'fa-flag', '#009B3A',
'{"iso2": "JM", "iso3": "JAM", "codigo_numerico": "388", "capital": "Kingston", "moneda": "JMD", "idioma": "en", "zona_horaria": "UTC-5", "codigo_telefono": "+1-876", "poblacion_millones": 2.8}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'TT', 'Trinidad y Tobago', 'Trinidad and Tobago', 'República de Trinidad y Tobago', 1, 27, TRUE, TRUE, 'fa-flag', '#CE1126',
'{"iso2": "TT", "iso3": "TTO", "codigo_numerico": "780", "capital": "Puerto España", "moneda": "TTD", "idioma": "en", "zona_horaria": "UTC-4", "codigo_telefono": "+1-868", "poblacion_millones": 1.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AMERICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Verificación
DO $$
DECLARE v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM appmatch_schema.catalogo_recursivo cr
    INNER JOIN appmatch_schema.catalogo_recursivo padre ON cr.fkid_padre = padre.pkid_catalogo_recursivo
    WHERE cr.catalogo_tipo = 'PAIS' AND cr.nivel = 1 AND cr.expiration_date IS NULL
    AND padre.codigo = 'CONT-AMERICA';
    RAISE NOTICE 'AMÉRICA: % países insertados', v_count;
END $$;
