-- ============================================================================
-- Script: datos_paises_03_europa.sql
-- Descripción: Países de Europa (Nivel 1)
-- Autor: Database Engineer Senior
-- Fecha: 12 de noviembre de 2025
-- Parte: 3 de 6 - Europa (44 países)
-- ============================================================================

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'AL', 'Albania', 'Albania', 'República de Albania', 1, 1, TRUE, TRUE, 'fa-flag', '#E41E20',
'{"iso2": "AL", "iso3": "ALB", "codigo_numerico": "008", "capital": "Tirana", "moneda": "ALL", "idioma": "sq", "zona_horaria": "UTC+1", "codigo_telefono": "+355", "poblacion_millones": 2.8}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'DE', 'Alemania', 'Germany', 'República Federal de Alemania', 1, 2, TRUE, TRUE, 'fa-flag', '#000000',
'{"iso2": "DE", "iso3": "DEU", "codigo_numerico": "276", "capital": "Berlín", "moneda": "EUR", "idioma": "de", "zona_horaria": "UTC+1", "codigo_telefono": "+49", "poblacion_millones": 83.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'AD', 'Andorra', 'Andorra', 'Principado de Andorra', 1, 3, TRUE, TRUE, 'fa-flag', '#0018A8',
'{"iso2": "AD", "iso3": "AND", "codigo_numerico": "020", "capital": "Andorra la Vella", "moneda": "EUR", "idioma": "ca", "zona_horaria": "UTC+1", "codigo_telefono": "+376", "poblacion_millones": 0.08}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'AT', 'Austria', 'Austria', 'República de Austria', 1, 4, TRUE, TRUE, 'fa-flag', '#ED2939',
'{"iso2": "AT", "iso3": "AUT", "codigo_numerico": "040", "capital": "Viena", "moneda": "EUR", "idioma": "de", "zona_horaria": "UTC+1", "codigo_telefono": "+43", "poblacion_millones": 8.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'BE', 'Bélgica', 'Belgium', 'Reino de Bélgica', 1, 5, TRUE, TRUE, 'fa-flag', '#000000',
'{"iso2": "BE", "iso3": "BEL", "codigo_numerico": "056", "capital": "Bruselas", "moneda": "EUR", "idioma": "nl", "zona_horaria": "UTC+1", "codigo_telefono": "+32", "poblacion_millones": 11.6}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'BY', 'Bielorrusia', 'Belarus', 'República de Bielorrusia', 1, 6, TRUE, TRUE, 'fa-flag', '#D22730',
'{"iso2": "BY", "iso3": "BLR", "codigo_numerico": "112", "capital": "Minsk", "moneda": "BYN", "idioma": "be", "zona_horaria": "UTC+3", "codigo_telefono": "+375", "poblacion_millones": 9.3}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'BA', 'Bosnia y Herzegovina', 'Bosnia and Herzegovina', 'Bosnia y Herzegovina', 1, 7, TRUE, TRUE, 'fa-flag', '#002395',
'{"iso2": "BA", "iso3": "BIH", "codigo_numerico": "070", "capital": "Sarajevo", "moneda": "BAM", "idioma": "bs", "zona_horaria": "UTC+1", "codigo_telefono": "+387", "poblacion_millones": 3.3}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'BG', 'Bulgaria', 'Bulgaria', 'República de Bulgaria', 1, 8, TRUE, TRUE, 'fa-flag', '#D62612',
'{"iso2": "BG", "iso3": "BGR", "codigo_numerico": "100", "capital": "Sofía", "moneda": "BGN", "idioma": "bg", "zona_horaria": "UTC+2", "codigo_telefono": "+359", "poblacion_millones": 6.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'HR', 'Croacia', 'Croatia', 'República de Croacia', 1, 9, TRUE, TRUE, 'fa-flag', '#FF0000',
'{"iso2": "HR", "iso3": "HRV", "codigo_numerico": "191", "capital": "Zagreb", "moneda": "EUR", "idioma": "hr", "zona_horaria": "UTC+1", "codigo_telefono": "+385", "poblacion_millones": 4.0}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'DK', 'Dinamarca', 'Denmark', 'Reino de Dinamarca', 1, 10, TRUE, TRUE, 'fa-flag', '#C60C30',
'{"iso2": "DK", "iso3": "DNK", "codigo_numerico": "208", "capital": "Copenhague", "moneda": "DKK", "idioma": "da", "zona_horaria": "UTC+1", "codigo_telefono": "+45", "poblacion_millones": 5.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'SK', 'Eslovaquia', 'Slovakia', 'República Eslovaca', 1, 11, TRUE, TRUE, 'fa-flag', '#0B4EA2',
'{"iso2": "SK", "iso3": "SVK", "codigo_numerico": "703", "capital": "Bratislava", "moneda": "EUR", "idioma": "sk", "zona_horaria": "UTC+1", "codigo_telefono": "+421", "poblacion_millones": 5.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'SI', 'Eslovenia', 'Slovenia', 'República de Eslovenia', 1, 12, TRUE, TRUE, 'fa-flag', '#005DA4',
'{"iso2": "SI", "iso3": "SVN", "codigo_numerico": "705", "capital": "Liubliana", "moneda": "EUR", "idioma": "sl", "zona_horaria": "UTC+1", "codigo_telefono": "+386", "poblacion_millones": 2.1}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'ES', 'España', 'Spain', 'Reino de España', 1, 13, TRUE, TRUE, 'fa-flag', '#C60B1E',
'{"iso2": "ES", "iso3": "ESP", "codigo_numerico": "724", "capital": "Madrid", "moneda": "EUR", "idioma": "es", "zona_horaria": "UTC+1", "codigo_telefono": "+34", "poblacion_millones": 47.4}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'EE', 'Estonia', 'Estonia', 'República de Estonia', 1, 14, TRUE, TRUE, 'fa-flag', '#0072CE',
'{"iso2": "EE", "iso3": "EST", "codigo_numerico": "233", "capital": "Tallin", "moneda": "EUR", "idioma": "et", "zona_horaria": "UTC+2", "codigo_telefono": "+372", "poblacion_millones": 1.3}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'FI', 'Finlandia', 'Finland', 'República de Finlandia', 1, 15, TRUE, TRUE, 'fa-flag', '#003580',
'{"iso2": "FI", "iso3": "FIN", "codigo_numerico": "246", "capital": "Helsinki", "moneda": "EUR", "idioma": "fi", "zona_horaria": "UTC+2", "codigo_telefono": "+358", "poblacion_millones": 5.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'FR', 'Francia', 'France', 'República Francesa', 1, 16, TRUE, TRUE, 'fa-flag', '#0055A4',
'{"iso2": "FR", "iso3": "FRA", "codigo_numerico": "250", "capital": "París", "moneda": "EUR", "idioma": "fr", "zona_horaria": "UTC+1", "codigo_telefono": "+33", "poblacion_millones": 67.8}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'GR', 'Grecia', 'Greece', 'República Helénica', 1, 17, TRUE, TRUE, 'fa-flag', '#0D5EAF',
'{"iso2": "GR", "iso3": "GRC", "codigo_numerico": "300", "capital": "Atenas", "moneda": "EUR", "idioma": "el", "zona_horaria": "UTC+2", "codigo_telefono": "+30", "poblacion_millones": 10.6}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'HU', 'Hungría', 'Hungary', 'Hungría', 1, 18, TRUE, TRUE, 'fa-flag', '#436F4D',
'{"iso2": "HU", "iso3": "HUN", "codigo_numerico": "348", "capital": "Budapest", "moneda": "HUF", "idioma": "hu", "zona_horaria": "UTC+1", "codigo_telefono": "+36", "poblacion_millones": 9.6}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'IE', 'Irlanda', 'Ireland', 'República de Irlanda', 1, 19, TRUE, TRUE, 'fa-flag', '#169B62',
'{"iso2": "IE", "iso3": "IRL", "codigo_numerico": "372", "capital": "Dublín", "moneda": "EUR", "idioma": "en", "zona_horaria": "UTC+0", "codigo_telefono": "+353", "poblacion_millones": 5.0}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'IS', 'Islandia', 'Iceland', 'República de Islandia', 1, 20, TRUE, TRUE, 'fa-flag', '#02529C',
'{"iso2": "IS", "iso3": "ISL", "codigo_numerico": "352", "capital": "Reikiavik", "moneda": "ISK", "idioma": "is", "zona_horaria": "UTC+0", "codigo_telefono": "+354", "poblacion_millones": 0.4}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'IT', 'Italia', 'Italy', 'República Italiana', 1, 21, TRUE, TRUE, 'fa-flag', '#009246',
'{"iso2": "IT", "iso3": "ITA", "codigo_numerico": "380", "capital": "Roma", "moneda": "EUR", "idioma": "it", "zona_horaria": "UTC+1", "codigo_telefono": "+39", "poblacion_millones": 59.1}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'LV', 'Letonia', 'Latvia', 'República de Letonia', 1, 22, TRUE, TRUE, 'fa-flag', '#9E3039',
'{"iso2": "LV", "iso3": "LVA", "codigo_numerico": "428", "capital": "Riga", "moneda": "EUR", "idioma": "lv", "zona_horaria": "UTC+2", "codigo_telefono": "+371", "poblacion_millones": 1.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'LI', 'Liechtenstein', 'Liechtenstein', 'Principado de Liechtenstein', 1, 23, TRUE, TRUE, 'fa-flag', '#002B7F',
'{"iso2": "LI", "iso3": "LIE", "codigo_numerico": "438", "capital": "Vaduz", "moneda": "CHF", "idioma": "de", "zona_horaria": "UTC+1", "codigo_telefono": "+423", "poblacion_millones": 0.04}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'LT', 'Lituania', 'Lithuania', 'República de Lituania', 1, 24, TRUE, TRUE, 'fa-flag', '#FDB913',
'{"iso2": "LT", "iso3": "LTU", "codigo_numerico": "440", "capital": "Vilna", "moneda": "EUR", "idioma": "lt", "zona_horaria": "UTC+2", "codigo_telefono": "+370", "poblacion_millones": 2.8}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'LU', 'Luxemburgo', 'Luxembourg', 'Gran Ducado de Luxemburgo', 1, 25, TRUE, TRUE, 'fa-flag', '#00A3E0',
'{"iso2": "LU", "iso3": "LUX", "codigo_numerico": "442", "capital": "Luxemburgo", "moneda": "EUR", "idioma": "lb", "zona_horaria": "UTC+1", "codigo_telefono": "+352", "poblacion_millones": 0.6}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'MK', 'Macedonia del Norte', 'North Macedonia', 'República de Macedonia del Norte', 1, 26, TRUE, TRUE, 'fa-flag', '#D20000',
'{"iso2": "MK", "iso3": "MKD", "codigo_numerico": "807", "capital": "Skopie", "moneda": "MKD", "idioma": "mk", "zona_horaria": "UTC+1", "codigo_telefono": "+389", "poblacion_millones": 2.1}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'MT', 'Malta', 'Malta', 'República de Malta', 1, 27, TRUE, TRUE, 'fa-flag', '#CF142B',
'{"iso2": "MT", "iso3": "MLT", "codigo_numerico": "470", "capital": "La Valeta", "moneda": "EUR", "idioma": "mt", "zona_horaria": "UTC+1", "codigo_telefono": "+356", "poblacion_millones": 0.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'MD', 'Moldavia', 'Moldova', 'República de Moldavia', 1, 28, TRUE, TRUE, 'fa-flag', '#0046AE',
'{"iso2": "MD", "iso3": "MDA", "codigo_numerico": "498", "capital": "Chisinau", "moneda": "MDL", "idioma": "ro", "zona_horaria": "UTC+2", "codigo_telefono": "+373", "poblacion_millones": 2.6}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'MC', 'Mónaco', 'Monaco', 'Principado de Mónaco', 1, 29, TRUE, TRUE, 'fa-flag', '#CE1126',
'{"iso2": "MC", "iso3": "MCO", "codigo_numerico": "492", "capital": "Mónaco", "moneda": "EUR", "idioma": "fr", "zona_horaria": "UTC+1", "codigo_telefono": "+377", "poblacion_millones": 0.04}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'ME', 'Montenegro', 'Montenegro', 'Montenegro', 1, 30, TRUE, TRUE, 'fa-flag', '#C40308',
'{"iso2": "ME", "iso3": "MNE", "codigo_numerico": "499", "capital": "Podgorica", "moneda": "EUR", "idioma": "sr", "zona_horaria": "UTC+1", "codigo_telefono": "+382", "poblacion_millones": 0.6}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'NO', 'Noruega', 'Norway', 'Reino de Noruega', 1, 31, TRUE, TRUE, 'fa-flag', '#BA0C2F',
'{"iso2": "NO", "iso3": "NOR", "codigo_numerico": "578", "capital": "Oslo", "moneda": "NOK", "idioma": "no", "zona_horaria": "UTC+1", "codigo_telefono": "+47", "poblacion_millones": 5.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'NL', 'Países Bajos', 'Netherlands', 'Reino de los Países Bajos', 1, 32, TRUE, TRUE, 'fa-flag', '#21468B',
'{"iso2": "NL", "iso3": "NLD", "codigo_numerico": "528", "capital": "Ámsterdam", "moneda": "EUR", "idioma": "nl", "zona_horaria": "UTC+1", "codigo_telefono": "+31", "poblacion_millones": 17.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'PL', 'Polonia', 'Poland', 'República de Polonia', 1, 33, TRUE, TRUE, 'fa-flag', '#DC143C',
'{"iso2": "PL", "iso3": "POL", "codigo_numerico": "616", "capital": "Varsovia", "moneda": "PLN", "idioma": "pl", "zona_horaria": "UTC+1", "codigo_telefono": "+48", "poblacion_millones": 38.0}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'PT', 'Portugal', 'Portugal', 'República Portuguesa', 1, 34, TRUE, TRUE, 'fa-flag', '#006600',
'{"iso2": "PT", "iso3": "PRT", "codigo_numerico": "620", "capital": "Lisboa", "moneda": "EUR", "idioma": "pt", "zona_horaria": "UTC+0", "codigo_telefono": "+351", "poblacion_millones": 10.3}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'GB', 'Reino Unido', 'United Kingdom', 'Reino Unido de Gran Bretaña e Irlanda del Norte', 1, 35, TRUE, TRUE, 'fa-flag', '#012169',
'{"iso2": "GB", "iso3": "GBR", "codigo_numerico": "826", "capital": "Londres", "moneda": "GBP", "idioma": "en", "zona_horaria": "UTC+0", "codigo_telefono": "+44", "poblacion_millones": 67.3}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'CZ', 'República Checa', 'Czech Republic', 'República Checa', 1, 36, TRUE, TRUE, 'fa-flag', '#11457E',
'{"iso2": "CZ", "iso3": "CZE", "codigo_numerico": "203", "capital": "Praga", "moneda": "CZK", "idioma": "cs", "zona_horaria": "UTC+1", "codigo_telefono": "+420", "poblacion_millones": 10.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'RO', 'Rumania', 'Romania', 'Rumania', 1, 37, TRUE, TRUE, 'fa-flag', '#002B7F',
'{"iso2": "RO", "iso3": "ROU", "codigo_numerico": "642", "capital": "Bucarest", "moneda": "RON", "idioma": "ro", "zona_horaria": "UTC+2", "codigo_telefono": "+40", "poblacion_millones": 19.1}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'RU', 'Rusia', 'Russia', 'Federación Rusa', 1, 38, TRUE, TRUE, 'fa-flag', '#0033A0',
'{"iso2": "RU", "iso3": "RUS", "codigo_numerico": "643", "capital": "Moscú", "moneda": "RUB", "idioma": "ru", "zona_horaria": "UTC+3", "codigo_telefono": "+7", "poblacion_millones": 144.1}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'SM', 'San Marino', 'San Marino', 'República de San Marino', 1, 39, TRUE, TRUE, 'fa-flag', '#5EB3D7',
'{"iso2": "SM", "iso3": "SMR", "codigo_numerico": "674", "capital": "San Marino", "moneda": "EUR", "idioma": "it", "zona_horaria": "UTC+1", "codigo_telefono": "+378", "poblacion_millones": 0.03}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'RS', 'Serbia', 'Serbia', 'República de Serbia', 1, 40, TRUE, TRUE, 'fa-flag', '#C6363C',
'{"iso2": "RS", "iso3": "SRB", "codigo_numerico": "688", "capital": "Belgrado", "moneda": "RSD", "idioma": "sr", "zona_horaria": "UTC+1", "codigo_telefono": "+381", "poblacion_millones": 6.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'SE', 'Suecia', 'Sweden', 'Reino de Suecia', 1, 41, TRUE, TRUE, 'fa-flag', '#006AA7',
'{"iso2": "SE", "iso3": "SWE", "codigo_numerico": "752", "capital": "Estocolmo", "moneda": "SEK", "idioma": "sv", "zona_horaria": "UTC+1", "codigo_telefono": "+46", "poblacion_millones": 10.4}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'CH', 'Suiza', 'Switzerland', 'Confederación Suiza', 1, 42, TRUE, TRUE, 'fa-flag', '#FF0000',
'{"iso2": "CH", "iso3": "CHE", "codigo_numerico": "756", "capital": "Berna", "moneda": "CHF", "idioma": "de", "zona_horaria": "UTC+1", "codigo_telefono": "+41", "poblacion_millones": 8.7}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'UA', 'Ucrania', 'Ukraine', 'Ucrania', 1, 43, TRUE, TRUE, 'fa-flag', '#0057B8',
'{"iso2": "UA", "iso3": "UKR", "codigo_numerico": "804", "capital": "Kiev", "moneda": "UAH", "idioma": "uk", "zona_horaria": "UTC+2", "codigo_telefono": "+380", "poblacion_millones": 41.0}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'VA', 'Vaticano', 'Vatican City', 'Estado de la Ciudad del Vaticano', 1, 44, TRUE, TRUE, 'fa-flag', '#FFD700',
'{"iso2": "VA", "iso3": "VAT", "codigo_numerico": "336", "capital": "Ciudad del Vaticano", "moneda": "EUR", "idioma": "la", "zona_horaria": "UTC+1", "codigo_telefono": "+379", "poblacion_millones": 0.001}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-EUROPA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Verificación
DO $$
DECLARE v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM appmatch_schema.catalogo_recursivo cr
    INNER JOIN appmatch_schema.catalogo_recursivo padre ON cr.fkid_padre = padre.pkid_catalogo_recursivo
    WHERE cr.catalogo_tipo = 'PAIS' AND cr.nivel = 1 AND cr.expiration_date IS NULL
    AND padre.codigo = 'CONT-EUROPA';
    RAISE NOTICE 'EUROPA: % países insertados', v_count;
END $$;
