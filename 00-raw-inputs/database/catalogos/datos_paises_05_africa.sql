-- ============================================================================
-- Script: datos_paises_05_africa.sql
-- Descripción: Países de África (Nivel 1)
-- Autor: Database Engineer Senior
-- Fecha: 12 de noviembre de 2025
-- Parte: 5 de 6 - África (54 países)
-- ============================================================================

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'ZA', 'Sudáfrica', 'South Africa', 'República de Sudáfrica', 1, 1, TRUE, TRUE, 'fa-flag', '#007A4D',
'{"iso2": "ZA", "iso3": "ZAF", "codigo_numerico": "710", "capital": "Pretoria", "moneda": "ZAR", "idioma": "en", "zona_horaria": "UTC+2", "codigo_telefono": "+27", "poblacion_millones": 59.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'DZ', 'Argelia', 'Algeria', 'República Argelina Democrática y Popular', 1, 2, TRUE, TRUE, 'fa-flag', '#006233',
'{"iso2": "DZ", "iso3": "DZA", "codigo_numerico": "012", "capital": "Argel", "moneda": "DZD", "idioma": "ar", "zona_horaria": "UTC+1", "codigo_telefono": "+213", "poblacion_millones": 44.6}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'AO', 'Angola', 'Angola', 'República de Angola', 1, 3, TRUE, TRUE, 'fa-flag', '#CC092F',
'{"iso2": "AO", "iso3": "AGO", "codigo_numerico": "024", "capital": "Luanda", "moneda": "AOA", "idioma": "pt", "zona_horaria": "UTC+1", "codigo_telefono": "+244", "poblacion_millones": 33.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'BJ', 'Benín', 'Benin', 'República de Benín', 1, 4, TRUE, TRUE, 'fa-flag', '#008751',
'{"iso2": "BJ", "iso3": "BEN", "codigo_numerico": "204", "capital": "Porto Novo", "moneda": "XOF", "idioma": "fr", "zona_horaria": "UTC+1", "codigo_telefono": "+229", "poblacion_millones": 12.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'BW', 'Botsuana', 'Botswana', 'República de Botsuana', 1, 5, TRUE, TRUE, 'fa-flag', '#75AADB',
'{"iso2": "BW", "iso3": "BWA", "codigo_numerico": "072", "capital": "Gaborone", "moneda": "BWP", "idioma": "en", "zona_horaria": "UTC+2", "codigo_telefono": "+267", "poblacion_millones": 2.4}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'BF', 'Burkina Faso', 'Burkina Faso', 'Burkina Faso', 1, 6, TRUE, TRUE, 'fa-flag', '#EF2B2D',
'{"iso2": "BF", "iso3": "BFA", "codigo_numerico": "854", "capital": "Uagadugú", "moneda": "XOF", "idioma": "fr", "zona_horaria": "UTC+0", "codigo_telefono": "+226", "poblacion_millones": 21.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'BI', 'Burundi', 'Burundi', 'República de Burundi', 1, 7, TRUE, TRUE, 'fa-flag', '#CE1126',
'{"iso2": "BI", "iso3": "BDI", "codigo_numerico": "108", "capital": "Gitega", "moneda": "BIF", "idioma": "fr", "zona_horaria": "UTC+2", "codigo_telefono": "+257", "poblacion_millones": 12.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'CV', 'Cabo Verde', 'Cape Verde', 'República de Cabo Verde', 1, 8, TRUE, TRUE, 'fa-flag', '#003893',
'{"iso2": "CV", "iso3": "CPV", "codigo_numerico": "132", "capital": "Praia", "moneda": "CVE", "idioma": "pt", "zona_horaria": "UTC-1", "codigo_telefono": "+238", "poblacion_millones": 0.6}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'CM', 'Camerún', 'Cameroon', 'República de Camerún', 1, 9, TRUE, TRUE, 'fa-flag', '#007A5E',
'{"iso2": "CM", "iso3": "CMR", "codigo_numerico": "120", "capital": "Yaundé", "moneda": "XAF", "idioma": "fr", "zona_horaria": "UTC+1", "codigo_telefono": "+237", "poblacion_millones": 27.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'TD', 'Chad', 'Chad', 'República del Chad', 1, 10, TRUE, TRUE, 'fa-flag', '#002664',
'{"iso2": "TD", "iso3": "TCD", "codigo_numerico": "148", "capital": "Yamena", "moneda": "XAF", "idioma": "fr", "zona_horaria": "UTC+1", "codigo_telefono": "+235", "poblacion_millones": 16.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'KM', 'Comoras', 'Comoros', 'Unión de las Comoras', 1, 11, TRUE, TRUE, 'fa-flag', '#3A75C4',
'{"iso2": "KM", "iso3": "COM", "codigo_numerico": "174", "capital": "Moroni", "moneda": "KMF", "idioma": "ar", "zona_horaria": "UTC+3", "codigo_telefono": "+269", "poblacion_millones": 0.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'CG', 'Congo', 'Republic of the Congo', 'República del Congo', 1, 12, TRUE, TRUE, 'fa-flag', '#009543',
'{"iso2": "CG", "iso3": "COG", "codigo_numerico": "178", "capital": "Brazzaville", "moneda": "XAF", "idioma": "fr", "zona_horaria": "UTC+1", "codigo_telefono": "+242", "poblacion_millones": 5.7}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'CD', 'Congo RDC', 'Democratic Republic of the Congo', 'República Democrática del Congo', 1, 13, TRUE, TRUE, 'fa-flag', '#007FFF',
'{"iso2": "CD", "iso3": "COD", "codigo_numerico": "180", "capital": "Kinsasa", "moneda": "CDF", "idioma": "fr", "zona_horaria": "UTC+1", "codigo_telefono": "+243", "poblacion_millones": 95.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'CI', 'Costa de Marfil', 'Ivory Coast', 'República de Costa de Marfil', 1, 14, TRUE, TRUE, 'fa-flag', '#F77F00',
'{"iso2": "CI", "iso3": "CIV", "codigo_numerico": "384", "capital": "Yamusukro", "moneda": "XOF", "idioma": "fr", "zona_horaria": "UTC+0", "codigo_telefono": "+225", "poblacion_millones": 27.0}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'EG', 'Egipto', 'Egypt', 'República Árabe de Egipto', 1, 15, TRUE, TRUE, 'fa-flag', '#CE1126',
'{"iso2": "EG", "iso3": "EGY", "codigo_numerico": "818", "capital": "El Cairo", "moneda": "EGP", "idioma": "ar", "zona_horaria": "UTC+2", "codigo_telefono": "+20", "poblacion_millones": 104.3}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'ER', 'Eritrea', 'Eritrea', 'Estado de Eritrea', 1, 16, TRUE, TRUE, 'fa-flag', '#12A24B',
'{"iso2": "ER", "iso3": "ERI", "codigo_numerico": "232", "capital": "Asmara", "moneda": "ERN", "idioma": "ti", "zona_horaria": "UTC+3", "codigo_telefono": "+291", "poblacion_millones": 3.6}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'ET', 'Etiopía', 'Ethiopia', 'República Democrática Federal de Etiopía', 1, 17, TRUE, TRUE, 'fa-flag', '#078930',
'{"iso2": "ET", "iso3": "ETH", "codigo_numerico": "231", "capital": "Adís Abeba", "moneda": "ETB", "idioma": "am", "zona_horaria": "UTC+3", "codigo_telefono": "+251", "poblacion_millones": 117.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'GA', 'Gabón', 'Gabon', 'República Gabonesa', 1, 18, TRUE, TRUE, 'fa-flag', '#009E60',
'{"iso2": "GA", "iso3": "GAB", "codigo_numerico": "266", "capital": "Libreville", "moneda": "XAF", "idioma": "fr", "zona_horaria": "UTC+1", "codigo_telefono": "+241", "poblacion_millones": 2.3}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'GM', 'Gambia', 'Gambia', 'República de Gambia', 1, 19, TRUE, TRUE, 'fa-flag', '#CE1126',
'{"iso2": "GM", "iso3": "GMB", "codigo_numerico": "270", "capital": "Banjul", "moneda": "GMD", "idioma": "en", "zona_horaria": "UTC+0", "codigo_telefono": "+220", "poblacion_millones": 2.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'GH', 'Ghana', 'Ghana', 'República de Ghana', 1, 20, TRUE, TRUE, 'fa-flag', '#006B3F',
'{"iso2": "GH", "iso3": "GHA", "codigo_numerico": "288", "capital": "Acra", "moneda": "GHS", "idioma": "en", "zona_horaria": "UTC+0", "codigo_telefono": "+233", "poblacion_millones": 31.7}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'GN', 'Guinea', 'Guinea', 'República de Guinea', 1, 21, TRUE, TRUE, 'fa-flag', '#CE1126',
'{"iso2": "GN", "iso3": "GIN", "codigo_numerico": "324", "capital": "Conakri", "moneda": "GNF", "idioma": "fr", "zona_horaria": "UTC+0", "codigo_telefono": "+224", "poblacion_millones": 13.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'GQ', 'Guinea Ecuatorial', 'Equatorial Guinea', 'República de Guinea Ecuatorial', 1, 22, TRUE, TRUE, 'fa-flag', '#3E9A00',
'{"iso2": "GQ", "iso3": "GNQ", "codigo_numerico": "226", "capital": "Malabo", "moneda": "XAF", "idioma": "es", "zona_horaria": "UTC+1", "codigo_telefono": "+240", "poblacion_millones": 1.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'GW', 'Guinea-Bisáu', 'Guinea-Bissau', 'República de Guinea-Bisáu', 1, 23, TRUE, TRUE, 'fa-flag', '#CE1126',
'{"iso2": "GW", "iso3": "GNB", "codigo_numerico": "624", "capital": "Bisáu", "moneda": "XOF", "idioma": "pt", "zona_horaria": "UTC+0", "codigo_telefono": "+245", "poblacion_millones": 2.0}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'KE', 'Kenia', 'Kenya', 'República de Kenia', 1, 24, TRUE, TRUE, 'fa-flag', '#BB0000',
'{"iso2": "KE", "iso3": "KEN", "codigo_numerico": "404", "capital": "Nairobi", "moneda": "KES", "idioma": "sw", "zona_horaria": "UTC+3", "codigo_telefono": "+254", "poblacion_millones": 54.0}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'LS', 'Lesoto', 'Lesotho', 'Reino de Lesoto', 1, 25, TRUE, TRUE, 'fa-flag', '#00209F',
'{"iso2": "LS", "iso3": "LSO", "codigo_numerico": "426", "capital": "Maseru", "moneda": "LSL", "idioma": "en", "zona_horaria": "UTC+2", "codigo_telefono": "+266", "poblacion_millones": 2.1}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'LR', 'Liberia', 'Liberia', 'República de Liberia', 1, 26, TRUE, TRUE, 'fa-flag', '#002868',
'{"iso2": "LR", "iso3": "LBR", "codigo_numerico": "430", "capital": "Monrovia", "moneda": "LRD", "idioma": "en", "zona_horaria": "UTC+0", "codigo_telefono": "+231", "poblacion_millones": 5.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'LY', 'Libia', 'Libya', 'Estado de Libia', 1, 27, TRUE, TRUE, 'fa-flag', '#239E46',
'{"iso2": "LY", "iso3": "LBY", "codigo_numerico": "434", "capital": "Trípoli", "moneda": "LYD", "idioma": "ar", "zona_horaria": "UTC+2", "codigo_telefono": "+218", "poblacion_millones": 6.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'MG', 'Madagascar', 'Madagascar', 'República de Madagascar', 1, 28, TRUE, TRUE, 'fa-flag', '#FC3D32',
'{"iso2": "MG", "iso3": "MDG", "codigo_numerico": "450", "capital": "Antananarivo", "moneda": "MGA", "idioma": "mg", "zona_horaria": "UTC+3", "codigo_telefono": "+261", "poblacion_millones": 28.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'MW', 'Malaui', 'Malawi', 'República de Malaui', 1, 29, TRUE, TRUE, 'fa-flag', '#CE1126',
'{"iso2": "MW", "iso3": "MWI", "codigo_numerico": "454", "capital": "Lilongüe", "moneda": "MWK", "idioma": "en", "zona_horaria": "UTC+2", "codigo_telefono": "+265", "poblacion_millones": 19.6}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'ML', 'Malí', 'Mali', 'República de Malí', 1, 30, TRUE, TRUE, 'fa-flag', '#14B53A',
'{"iso2": "ML", "iso3": "MLI", "codigo_numerico": "466", "capital": "Bamako", "moneda": "XOF", "idioma": "fr", "zona_horaria": "UTC+0", "codigo_telefono": "+223", "poblacion_millones": 21.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'MA', 'Marruecos', 'Morocco', 'Reino de Marruecos', 1, 31, TRUE, TRUE, 'fa-flag', '#C1272D',
'{"iso2": "MA", "iso3": "MAR", "codigo_numerico": "504", "capital": "Rabat", "moneda": "MAD", "idioma": "ar", "zona_horaria": "UTC+1", "codigo_telefono": "+212", "poblacion_millones": 37.3}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'MU', 'Mauricio', 'Mauritius', 'República de Mauricio', 1, 32, TRUE, TRUE, 'fa-flag', '#EA2839',
'{"iso2": "MU", "iso3": "MUS", "codigo_numerico": "480", "capital": "Port Louis", "moneda": "MUR", "idioma": "en", "zona_horaria": "UTC+4", "codigo_telefono": "+230", "poblacion_millones": 1.3}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'MR', 'Mauritania', 'Mauritania', 'República Islámica de Mauritania', 1, 33, TRUE, TRUE, 'fa-flag', '#006233',
'{"iso2": "MR", "iso3": "MRT", "codigo_numerico": "478", "capital": "Nuakchot", "moneda": "MRU", "idioma": "ar", "zona_horaria": "UTC+0", "codigo_telefono": "+222", "poblacion_millones": 4.7}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'MZ', 'Mozambique', 'Mozambique', 'República de Mozambique', 1, 34, TRUE, TRUE, 'fa-flag', '#007168',
'{"iso2": "MZ", "iso3": "MOZ", "codigo_numerico": "508", "capital": "Maputo", "moneda": "MZN", "idioma": "pt", "zona_horaria": "UTC+2", "codigo_telefono": "+258", "poblacion_millones": 32.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'NA', 'Namibia', 'Namibia', 'República de Namibia', 1, 35, TRUE, TRUE, 'fa-flag', '#003580',
'{"iso2": "NA", "iso3": "NAM", "codigo_numerico": "516", "capital": "Windhoek", "moneda": "NAD", "idioma": "en", "zona_horaria": "UTC+2", "codigo_telefono": "+264", "poblacion_millones": 2.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'NE', 'Níger', 'Niger', 'República del Níger', 1, 36, TRUE, TRUE, 'fa-flag', '#E05206',
'{"iso2": "NE", "iso3": "NER", "codigo_numerico": "562", "capital": "Niamey", "moneda": "XOF", "idioma": "fr", "zona_horaria": "UTC+1", "codigo_telefono": "+227", "poblacion_millones": 25.3}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'NG', 'Nigeria', 'Nigeria', 'República Federal de Nigeria', 1, 37, TRUE, TRUE, 'fa-flag', '#008751',
'{"iso2": "NG", "iso3": "NGA", "codigo_numerico": "566", "capital": "Abuya", "moneda": "NGN", "idioma": "en", "zona_horaria": "UTC+1", "codigo_telefono": "+234", "poblacion_millones": 213.4}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'CF', 'República Centroafricana', 'Central African Republic', 'República Centroafricana', 1, 38, TRUE, TRUE, 'fa-flag', '#003082',
'{"iso2": "CF", "iso3": "CAF", "codigo_numerico": "140", "capital": "Bangui", "moneda": "XAF", "idioma": "fr", "zona_horaria": "UTC+1", "codigo_telefono": "+236", "poblacion_millones": 5.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'RW', 'Ruanda', 'Rwanda', 'República de Ruanda', 1, 39, TRUE, TRUE, 'fa-flag', '#00A1DE',
'{"iso2": "RW", "iso3": "RWA", "codigo_numerico": "646", "capital": "Kigali", "moneda": "RWF", "idioma": "rw", "zona_horaria": "UTC+2", "codigo_telefono": "+250", "poblacion_millones": 13.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'ST', 'Santo Tomé y Príncipe', 'Sao Tome and Principe', 'República Democrática de Santo Tomé y Príncipe', 1, 40, TRUE, TRUE, 'fa-flag', '#12AD2B',
'{"iso2": "ST", "iso3": "STP", "codigo_numerico": "678", "capital": "Santo Tomé", "moneda": "STN", "idioma": "pt", "zona_horaria": "UTC+0", "codigo_telefono": "+239", "poblacion_millones": 0.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'SN', 'Senegal', 'Senegal', 'República del Senegal', 1, 41, TRUE, TRUE, 'fa-flag', '#00853F',
'{"iso2": "SN", "iso3": "SEN", "codigo_numerico": "686", "capital": "Dakar", "moneda": "XOF", "idioma": "fr", "zona_horaria": "UTC+0", "codigo_telefono": "+221", "poblacion_millones": 17.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'SC', 'Seychelles', 'Seychelles', 'República de Seychelles', 1, 42, TRUE, TRUE, 'fa-flag', '#003F87',
'{"iso2": "SC", "iso3": "SYC", "codigo_numerico": "690", "capital": "Victoria", "moneda": "SCR", "idioma": "en", "zona_horaria": "UTC+4", "codigo_telefono": "+248", "poblacion_millones": 0.1}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'SL', 'Sierra Leona', 'Sierra Leone', 'República de Sierra Leona', 1, 43, TRUE, TRUE, 'fa-flag', '#1EB53A',
'{"iso2": "SL", "iso3": "SLE", "codigo_numerico": "694", "capital": "Freetown", "moneda": "SLL", "idioma": "en", "zona_horaria": "UTC+0", "codigo_telefono": "+232", "poblacion_millones": 8.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'SO', 'Somalia', 'Somalia', 'República Federal de Somalia', 1, 44, TRUE, TRUE, 'fa-flag', '#4189DD',
'{"iso2": "SO", "iso3": "SOM", "codigo_numerico": "706", "capital": "Mogadiscio", "moneda": "SOS", "idioma": "so", "zona_horaria": "UTC+3", "codigo_telefono": "+252", "poblacion_millones": 16.4}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'SD', 'Sudán', 'Sudan', 'República del Sudán', 1, 45, TRUE, TRUE, 'fa-flag', '#007229',
'{"iso2": "SD", "iso3": "SDN", "codigo_numerico": "729", "capital": "Jartum", "moneda": "SDG", "idioma": "ar", "zona_horaria": "UTC+2", "codigo_telefono": "+249", "poblacion_millones": 44.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'SS', 'Sudán del Sur', 'South Sudan', 'República de Sudán del Sur', 1, 46, TRUE, TRUE, 'fa-flag', '#078930',
'{"iso2": "SS", "iso3": "SSD", "codigo_numerico": "728", "capital": "Yuba", "moneda": "SSP", "idioma": "en", "zona_horaria": "UTC+2", "codigo_telefono": "+211", "poblacion_millones": 11.4}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'SZ', 'Esuatini', 'Eswatini', 'Reino de Esuatini', 1, 47, TRUE, TRUE, 'fa-flag', '#3E5EB9',
'{"iso2": "SZ", "iso3": "SWZ", "codigo_numerico": "748", "capital": "Mbabane", "moneda": "SZL", "idioma": "en", "zona_horaria": "UTC+2", "codigo_telefono": "+268", "poblacion_millones": 1.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'TZ', 'Tanzania', 'Tanzania', 'República Unida de Tanzania', 1, 48, TRUE, TRUE, 'fa-flag', '#1EB53A',
'{"iso2": "TZ", "iso3": "TZA", "codigo_numerico": "834", "capital": "Dodoma", "moneda": "TZS", "idioma": "sw", "zona_horaria": "UTC+3", "codigo_telefono": "+255", "poblacion_millones": 61.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'TG', 'Togo', 'Togo', 'República Togolesa', 1, 49, TRUE, TRUE, 'fa-flag', '#006A4E',
'{"iso2": "TG", "iso3": "TGO", "codigo_numerico": "768", "capital": "Lomé", "moneda": "XOF", "idioma": "fr", "zona_horaria": "UTC+0", "codigo_telefono": "+228", "poblacion_millones": 8.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'TN', 'Túnez', 'Tunisia', 'República Tunecina', 1, 50, TRUE, TRUE, 'fa-flag', '#E70013',
'{"iso2": "TN", "iso3": "TUN", "codigo_numerico": "788", "capital": "Túnez", "moneda": "TND", "idioma": "ar", "zona_horaria": "UTC+1", "codigo_telefono": "+216", "poblacion_millones": 12.0}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'UG', 'Uganda', 'Uganda', 'República de Uganda', 1, 51, TRUE, TRUE, 'fa-flag', '#FCDC04',
'{"iso2": "UG", "iso3": "UGA", "codigo_numerico": "800", "capital": "Kampala", "moneda": "UGX", "idioma": "en", "zona_horaria": "UTC+3", "codigo_telefono": "+256", "poblacion_millones": 47.1}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'ZM', 'Zambia', 'Zambia', 'República de Zambia', 1, 52, TRUE, TRUE, 'fa-flag', '#198A00',
'{"iso2": "ZM", "iso3": "ZMB", "codigo_numerico": "894", "capital": "Lusaka", "moneda": "ZMW", "idioma": "en", "zona_horaria": "UTC+2", "codigo_telefono": "+260", "poblacion_millones": 19.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'ZW', 'Zimbabue', 'Zimbabwe', 'República de Zimbabue', 1, 53, TRUE, TRUE, 'fa-flag', '#319B42',
'{"iso2": "ZW", "iso3": "ZWE", "codigo_numerico": "716", "capital": "Harare", "moneda": "ZWL", "idioma": "en", "zona_horaria": "UTC+2", "codigo_telefono": "+263", "poblacion_millones": 15.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'DJ', 'Yibuti', 'Djibouti', 'República de Yibuti', 1, 54, TRUE, TRUE, 'fa-flag', '#6AB2E7',
'{"iso2": "DJ", "iso3": "DJI", "codigo_numerico": "262", "capital": "Yibuti", "moneda": "DJF", "idioma": "fr", "zona_horaria": "UTC+3", "codigo_telefono": "+253", "poblacion_millones": 1.0}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-AFRICA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Verificación
DO $$
DECLARE v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM appmatch_schema.catalogo_recursivo cr
    INNER JOIN appmatch_schema.catalogo_recursivo padre ON cr.fkid_padre = padre.pkid_catalogo_recursivo
    WHERE cr.catalogo_tipo = 'PAIS' AND cr.nivel = 1 AND cr.expiration_date IS NULL
    AND padre.codigo = 'CONT-AFRICA';
    RAISE NOTICE 'ÁFRICA: % países insertados', v_count;
END $$;
