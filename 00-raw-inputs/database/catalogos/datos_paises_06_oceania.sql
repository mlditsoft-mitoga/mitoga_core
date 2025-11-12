-- ============================================================================
-- Script: datos_paises_06_oceania.sql
-- Descripción: Países de Oceanía (Nivel 1)
-- Autor: Database Engineer Senior
-- Fecha: 12 de noviembre de 2025
-- Parte: 6 de 6 - Oceanía (14 países)
-- ============================================================================

INSERT INTO shared_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'AU', 'Australia', 'Australia', 'Mancomunidad de Australia', 1, 1, TRUE, TRUE, 'fa-flag', '#012169',
'{"iso2": "AU", "iso3": "AUS", "codigo_numerico": "036", "capital": "Canberra", "moneda": "AUD", "idioma": "en", "zona_horaria": "UTC+10", "codigo_telefono": "+61", "poblacion_millones": 25.7}'::jsonb
FROM shared_schema.catalogo_recursivo WHERE codigo = 'CONT-OCEANIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'NZ', 'Nueva Zelanda', 'New Zealand', 'Nueva Zelanda', 1, 2, TRUE, TRUE, 'fa-flag', '#00247D',
'{"iso2": "NZ", "iso3": "NZL", "codigo_numerico": "554", "capital": "Wellington", "moneda": "NZD", "idioma": "en", "zona_horaria": "UTC+12", "codigo_telefono": "+64", "poblacion_millones": 5.1}'::jsonb
FROM shared_schema.catalogo_recursivo WHERE codigo = 'CONT-OCEANIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'PG', 'Papúa Nueva Guinea', 'Papua New Guinea', 'Estado Independiente de Papúa Nueva Guinea', 1, 3, TRUE, TRUE, 'fa-flag', '#CE1126',
'{"iso2": "PG", "iso3": "PNG", "codigo_numerico": "598", "capital": "Port Moresby", "moneda": "PGK", "idioma": "en", "zona_horaria": "UTC+10", "codigo_telefono": "+675", "poblacion_millones": 9.1}'::jsonb
FROM shared_schema.catalogo_recursivo WHERE codigo = 'CONT-OCEANIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'FJ', 'Fiyi', 'Fiji', 'República de Fiyi', 1, 4, TRUE, TRUE, 'fa-flag', '#002868',
'{"iso2": "FJ", "iso3": "FJI", "codigo_numerico": "242", "capital": "Suva", "moneda": "FJD", "idioma": "en", "zona_horaria": "UTC+12", "codigo_telefono": "+679", "poblacion_millones": 0.9}'::jsonb
FROM shared_schema.catalogo_recursivo WHERE codigo = 'CONT-OCEANIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'SB', 'Islas Salomón', 'Solomon Islands', 'Islas Salomón', 1, 5, TRUE, TRUE, 'fa-flag', '#0051BA',
'{"iso2": "SB", "iso3": "SLB", "codigo_numerico": "090", "capital": "Honiara", "moneda": "SBD", "idioma": "en", "zona_horaria": "UTC+11", "codigo_telefono": "+677", "poblacion_millones": 0.7}'::jsonb
FROM shared_schema.catalogo_recursivo WHERE codigo = 'CONT-OCEANIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'VU', 'Vanuatu', 'Vanuatu', 'República de Vanuatu', 1, 6, TRUE, TRUE, 'fa-flag', '#CE1126',
'{"iso2": "VU", "iso3": "VUT", "codigo_numerico": "548", "capital": "Port Vila", "moneda": "VUV", "idioma": "bi", "zona_horaria": "UTC+11", "codigo_telefono": "+678", "poblacion_millones": 0.3}'::jsonb
FROM shared_schema.catalogo_recursivo WHERE codigo = 'CONT-OCEANIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'WS', 'Samoa', 'Samoa', 'Estado Independiente de Samoa', 1, 7, TRUE, TRUE, 'fa-flag', '#CE1126',
'{"iso2": "WS", "iso3": "WSM", "codigo_numerico": "882", "capital": "Apia", "moneda": "WST", "idioma": "sm", "zona_horaria": "UTC+13", "codigo_telefono": "+685", "poblacion_millones": 0.2}'::jsonb
FROM shared_schema.catalogo_recursivo WHERE codigo = 'CONT-OCEANIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'TO', 'Tonga', 'Tonga', 'Reino de Tonga', 1, 8, TRUE, TRUE, 'fa-flag', '#C10000',
'{"iso2": "TO", "iso3": "TON", "codigo_numerico": "776", "capital": "Nukualofa", "moneda": "TOP", "idioma": "to", "zona_horaria": "UTC+13", "codigo_telefono": "+676", "poblacion_millones": 0.1}'::jsonb
FROM shared_schema.catalogo_recursivo WHERE codigo = 'CONT-OCEANIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'KI', 'Kiribati', 'Kiribati', 'República de Kiribati', 1, 9, TRUE, TRUE, 'fa-flag', '#CE1126',
'{"iso2": "KI", "iso3": "KIR", "codigo_numerico": "296", "capital": "Tarawa del Sur", "moneda": "AUD", "idioma": "en", "zona_horaria": "UTC+12", "codigo_telefono": "+686", "poblacion_millones": 0.1}'::jsonb
FROM shared_schema.catalogo_recursivo WHERE codigo = 'CONT-OCEANIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'FM', 'Micronesia', 'Micronesia', 'Estados Federados de Micronesia', 1, 10, TRUE, TRUE, 'fa-flag', '#75B2DD',
'{"iso2": "FM", "iso3": "FSM", "codigo_numerico": "583", "capital": "Palikir", "moneda": "USD", "idioma": "en", "zona_horaria": "UTC+10", "codigo_telefono": "+691", "poblacion_millones": 0.1}'::jsonb
FROM shared_schema.catalogo_recursivo WHERE codigo = 'CONT-OCEANIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'MH', 'Islas Marshall', 'Marshall Islands', 'República de las Islas Marshall', 1, 11, TRUE, TRUE, 'fa-flag', '#003893',
'{"iso2": "MH", "iso3": "MHL", "codigo_numerico": "584", "capital": "Majuro", "moneda": "USD", "idioma": "en", "zona_horaria": "UTC+12", "codigo_telefono": "+692", "poblacion_millones": 0.06}'::jsonb
FROM shared_schema.catalogo_recursivo WHERE codigo = 'CONT-OCEANIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'PW', 'Palaos', 'Palau', 'República de Palaos', 1, 12, TRUE, TRUE, 'fa-flag', '#4AADD6',
'{"iso2": "PW", "iso3": "PLW", "codigo_numerico": "585", "capital": "Ngerulmud", "moneda": "USD", "idioma": "en", "zona_horaria": "UTC+9", "codigo_telefono": "+680", "poblacion_millones": 0.02}'::jsonb
FROM shared_schema.catalogo_recursivo WHERE codigo = 'CONT-OCEANIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'NR', 'Nauru', 'Nauru', 'República de Nauru', 1, 13, TRUE, TRUE, 'fa-flag', '#002170',
'{"iso2": "NR", "iso3": "NRU", "codigo_numerico": "520", "capital": "Yaren", "moneda": "AUD", "idioma": "na", "zona_horaria": "UTC+12", "codigo_telefono": "+674", "poblacion_millones": 0.01}'::jsonb
FROM shared_schema.catalogo_recursivo WHERE codigo = 'CONT-OCEANIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'TV', 'Tuvalu', 'Tuvalu', 'Tuvalu', 1, 14, TRUE, TRUE, 'fa-flag', '#1C75BC',
'{"iso2": "TV", "iso3": "TUV", "codigo_numerico": "798", "capital": "Funafuti", "moneda": "AUD", "idioma": "en", "zona_horaria": "UTC+12", "codigo_telefono": "+688", "poblacion_millones": 0.01}'::jsonb
FROM shared_schema.catalogo_recursivo WHERE codigo = 'CONT-OCEANIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Verificación
DO $$
DECLARE v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM shared_schema.catalogo_recursivo cr
    INNER JOIN shared_schema.catalogo_recursivo padre ON cr.fkid_padre = padre.pkid_catalogo_recursivo
    WHERE cr.catalogo_tipo = 'PAIS' AND cr.nivel = 1 AND cr.expiration_date IS NULL
    AND padre.codigo = 'CONT-OCEANIA';
    RAISE NOTICE 'OCEANÍA: % países insertados', v_count;
END $$;
