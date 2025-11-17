-- ============================================================================
-- Script: datos_paises_04_asia.sql
-- Descripción: Países de Asia (Nivel 1)
-- Autor: Database Engineer Senior
-- Fecha: 12 de noviembre de 2025
-- Parte: 4 de 6 - Asia (50 países principales)
-- ============================================================================

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'AF', 'Afganistán', 'Afghanistan', 'República Islámica de Afganistán', 1, 1, TRUE, TRUE, 'fa-flag', '#000000',
'{"iso2": "AF", "iso3": "AFG", "codigo_numerico": "004", "capital": "Kabul", "moneda": "AFN", "idioma": "ps", "zona_horaria": "UTC+4:30", "codigo_telefono": "+93", "poblacion_millones": 40.1}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'SA', 'Arabia Saudita', 'Saudi Arabia', 'Reino de Arabia Saudita', 1, 2, TRUE, TRUE, 'fa-flag', '#165B33',
'{"iso2": "SA", "iso3": "SAU", "codigo_numerico": "682", "capital": "Riad", "moneda": "SAR", "idioma": "ar", "zona_horaria": "UTC+3", "codigo_telefono": "+966", "poblacion_millones": 35.3}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'AM', 'Armenia', 'Armenia', 'República de Armenia', 1, 3, TRUE, TRUE, 'fa-flag', '#D90012',
'{"iso2": "AM", "iso3": "ARM", "codigo_numerico": "051", "capital": "Ereván", "moneda": "AMD", "idioma": "hy", "zona_horaria": "UTC+4", "codigo_telefono": "+374", "poblacion_millones": 2.8}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'AZ', 'Azerbaiyán', 'Azerbaijan', 'República de Azerbaiyán', 1, 4, TRUE, TRUE, 'fa-flag', '#00B5E2',
'{"iso2": "AZ", "iso3": "AZE", "codigo_numerico": "031", "capital": "Bakú", "moneda": "AZN", "idioma": "az", "zona_horaria": "UTC+4", "codigo_telefono": "+994", "poblacion_millones": 10.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'BH', 'Baréin', 'Bahrain', 'Reino de Baréin', 1, 5, TRUE, TRUE, 'fa-flag', '#CE1126',
'{"iso2": "BH", "iso3": "BHR", "codigo_numerico": "048", "capital": "Manama", "moneda": "BHD", "idioma": "ar", "zona_horaria": "UTC+3", "codigo_telefono": "+973", "poblacion_millones": 1.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'BD', 'Bangladés', 'Bangladesh', 'República Popular de Bangladés', 1, 6, TRUE, TRUE, 'fa-flag', '#006A4E',
'{"iso2": "BD", "iso3": "BGD", "codigo_numerico": "050", "capital": "Daca", "moneda": "BDT", "idioma": "bn", "zona_horaria": "UTC+6", "codigo_telefono": "+880", "poblacion_millones": 166.3}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'BT', 'Bután', 'Bhutan', 'Reino de Bután', 1, 7, TRUE, TRUE, 'fa-flag', '#FF4E12',
'{"iso2": "BT", "iso3": "BTN", "codigo_numerico": "064", "capital": "Timbu", "moneda": "BTN", "idioma": "dz", "zona_horaria": "UTC+6", "codigo_telefono": "+975", "poblacion_millones": 0.8}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'MM', 'Birmania', 'Myanmar', 'República de la Unión de Myanmar', 1, 8, TRUE, TRUE, 'fa-flag', '#FECB00',
'{"iso2": "MM", "iso3": "MMR", "codigo_numerico": "104", "capital": "Naipyidó", "moneda": "MMK", "idioma": "my", "zona_horaria": "UTC+6:30", "codigo_telefono": "+95", "poblacion_millones": 54.8}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'BN', 'Brunéi', 'Brunei', 'Estado de Brunéi Darussalam', 1, 9, TRUE, TRUE, 'fa-flag', '#F7E017',
'{"iso2": "BN", "iso3": "BRN", "codigo_numerico": "096", "capital": "Bandar Seri Begawan", "moneda": "BND", "idioma": "ms", "zona_horaria": "UTC+8", "codigo_telefono": "+673", "poblacion_millones": 0.4}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'KH', 'Camboya', 'Cambodia', 'Reino de Camboya', 1, 10, TRUE, TRUE, 'fa-flag', '#032EA1',
'{"iso2": "KH", "iso3": "KHM", "codigo_numerico": "116", "capital": "Nom Pen", "moneda": "KHR", "idioma": "km", "zona_horaria": "UTC+7", "codigo_telefono": "+855", "poblacion_millones": 16.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'CN', 'China', 'China', 'República Popular China', 1, 11, TRUE, TRUE, 'fa-flag', '#DE2910',
'{"iso2": "CN", "iso3": "CHN", "codigo_numerico": "156", "capital": "Pekín", "moneda": "CNY", "idioma": "zh", "zona_horaria": "UTC+8", "codigo_telefono": "+86", "poblacion_millones": 1425.7}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'CY', 'Chipre', 'Cyprus', 'República de Chipre', 1, 12, TRUE, TRUE, 'fa-flag', '#D57800',
'{"iso2": "CY", "iso3": "CYP", "codigo_numerico": "196", "capital": "Nicosia", "moneda": "EUR", "idioma": "el", "zona_horaria": "UTC+2", "codigo_telefono": "+357", "poblacion_millones": 1.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'KP', 'Corea del Norte', 'North Korea', 'República Popular Democrática de Corea', 1, 13, TRUE, TRUE, 'fa-flag', '#024FA2',
'{"iso2": "KP", "iso3": "PRK", "codigo_numerico": "408", "capital": "Pionyang", "moneda": "KPW", "idioma": "ko", "zona_horaria": "UTC+9", "codigo_telefono": "+850", "poblacion_millones": 26.0}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'KR', 'Corea del Sur', 'South Korea', 'República de Corea', 1, 14, TRUE, TRUE, 'fa-flag', '#003478',
'{"iso2": "KR", "iso3": "KOR", "codigo_numerico": "410", "capital": "Seúl", "moneda": "KRW", "idioma": "ko", "zona_horaria": "UTC+9", "codigo_telefono": "+82", "poblacion_millones": 51.7}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'AE', 'Emiratos Árabes Unidos', 'United Arab Emirates', 'Emiratos Árabes Unidos', 1, 15, TRUE, TRUE, 'fa-flag', '#00732F',
'{"iso2": "AE", "iso3": "ARE", "codigo_numerico": "784", "capital": "Abu Dabi", "moneda": "AED", "idioma": "ar", "zona_horaria": "UTC+4", "codigo_telefono": "+971", "poblacion_millones": 9.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'PH', 'Filipinas', 'Philippines', 'República de Filipinas', 1, 16, TRUE, TRUE, 'fa-flag', '#0038A8',
'{"iso2": "PH", "iso3": "PHL", "codigo_numerico": "608", "capital": "Manila", "moneda": "PHP", "idioma": "en", "zona_horaria": "UTC+8", "codigo_telefono": "+63", "poblacion_millones": 113.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'GE', 'Georgia', 'Georgia', 'Georgia', 1, 17, TRUE, TRUE, 'fa-flag', '#FF0000',
'{"iso2": "GE", "iso3": "GEO", "codigo_numerico": "268", "capital": "Tiflis", "moneda": "GEL", "idioma": "ka", "zona_horaria": "UTC+4", "codigo_telefono": "+995", "poblacion_millones": 3.7}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'IN', 'India', 'India', 'República de la India', 1, 18, TRUE, TRUE, 'fa-flag', '#FF9933',
'{"iso2": "IN", "iso3": "IND", "codigo_numerico": "356", "capital": "Nueva Delhi", "moneda": "INR", "idioma": "hi", "zona_horaria": "UTC+5:30", "codigo_telefono": "+91", "poblacion_millones": 1407.6}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'ID', 'Indonesia', 'Indonesia', 'República de Indonesia', 1, 19, TRUE, TRUE, 'fa-flag', '#FF0000',
'{"iso2": "ID", "iso3": "IDN", "codigo_numerico": "360", "capital": "Yakarta", "moneda": "IDR", "idioma": "id", "zona_horaria": "UTC+7", "codigo_telefono": "+62", "poblacion_millones": 275.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'IQ', 'Irak', 'Iraq', 'República de Irak', 1, 20, TRUE, TRUE, 'fa-flag', '#CE1126',
'{"iso2": "IQ", "iso3": "IRQ", "codigo_numerico": "368", "capital": "Bagdad", "moneda": "IQD", "idioma": "ar", "zona_horaria": "UTC+3", "codigo_telefono": "+964", "poblacion_millones": 41.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'IR', 'Irán', 'Iran', 'República Islámica de Irán', 1, 21, TRUE, TRUE, 'fa-flag', '#239F40',
'{"iso2": "IR", "iso3": "IRN", "codigo_numerico": "364", "capital": "Teherán", "moneda": "IRR", "idioma": "fa", "zona_horaria": "UTC+3:30", "codigo_telefono": "+98", "poblacion_millones": 85.0}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'IL', 'Israel', 'Israel', 'Estado de Israel', 1, 22, TRUE, TRUE, 'fa-flag', '#0038B8',
'{"iso2": "IL", "iso3": "ISR", "codigo_numerico": "376", "capital": "Jerusalén", "moneda": "ILS", "idioma": "he", "zona_horaria": "UTC+2", "codigo_telefono": "+972", "poblacion_millones": 9.4}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'JP', 'Japón', 'Japan', 'Japón', 1, 23, TRUE, TRUE, 'fa-flag', '#BC002D',
'{"iso2": "JP", "iso3": "JPN", "codigo_numerico": "392", "capital": "Tokio", "moneda": "JPY", "idioma": "ja", "zona_horaria": "UTC+9", "codigo_telefono": "+81", "poblacion_millones": 125.1}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'JO', 'Jordania', 'Jordan', 'Reino Hachemita de Jordania', 1, 24, TRUE, TRUE, 'fa-flag', '#007A3D',
'{"iso2": "JO", "iso3": "JOR", "codigo_numerico": "400", "capital": "Amán", "moneda": "JOD", "idioma": "ar", "zona_horaria": "UTC+2", "codigo_telefono": "+962", "poblacion_millones": 10.3}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'KZ', 'Kazajistán', 'Kazakhstan', 'República de Kazajistán', 1, 25, TRUE, TRUE, 'fa-flag', '#00AFCA',
'{"iso2": "KZ", "iso3": "KAZ", "codigo_numerico": "398", "capital": "Astaná", "moneda": "KZT", "idioma": "kk", "zona_horaria": "UTC+6", "codigo_telefono": "+7", "poblacion_millones": 19.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'KW', 'Kuwait', 'Kuwait', 'Estado de Kuwait', 1, 26, TRUE, TRUE, 'fa-flag', '#007A3D',
'{"iso2": "KW", "iso3": "KWT", "codigo_numerico": "414", "capital": "Ciudad de Kuwait", "moneda": "KWD", "idioma": "ar", "zona_horaria": "UTC+3", "codigo_telefono": "+965", "poblacion_millones": 4.3}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'LA', 'Laos', 'Laos', 'República Democrática Popular Lao', 1, 27, TRUE, TRUE, 'fa-flag', '#CE1126',
'{"iso2": "LA", "iso3": "LAO", "codigo_numerico": "418", "capital": "Vientián", "moneda": "LAK", "idioma": "lo", "zona_horaria": "UTC+7", "codigo_telefono": "+856", "poblacion_millones": 7.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'LB', 'Líbano', 'Lebanon', 'República Libanesa', 1, 28, TRUE, TRUE, 'fa-flag', '#ED1C24',
'{"iso2": "LB", "iso3": "LBN", "codigo_numerico": "422", "capital": "Beirut", "moneda": "LBP", "idioma": "ar", "zona_horaria": "UTC+2", "codigo_telefono": "+961", "poblacion_millones": 6.8}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'MY', 'Malasia', 'Malaysia', 'Malasia', 1, 29, TRUE, TRUE, 'fa-flag', '#CC0001',
'{"iso2": "MY", "iso3": "MYS", "codigo_numerico": "458", "capital": "Kuala Lumpur", "moneda": "MYR", "idioma": "ms", "zona_horaria": "UTC+8", "codigo_telefono": "+60", "poblacion_millones": 32.7}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'MV', 'Maldivas', 'Maldives', 'República de Maldivas', 1, 30, TRUE, TRUE, 'fa-flag', '#D21034',
'{"iso2": "MV", "iso3": "MDV", "codigo_numerico": "462", "capital": "Malé", "moneda": "MVR", "idioma": "dv", "zona_horaria": "UTC+5", "codigo_telefono": "+960", "poblacion_millones": 0.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'MN', 'Mongolia', 'Mongolia', 'Mongolia', 1, 31, TRUE, TRUE, 'fa-flag', '#C4272F',
'{"iso2": "MN", "iso3": "MNG", "codigo_numerico": "496", "capital": "Ulán Bator", "moneda": "MNT", "idioma": "mn", "zona_horaria": "UTC+8", "codigo_telefono": "+976", "poblacion_millones": 3.3}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'NP', 'Nepal', 'Nepal', 'República Democrática Federal de Nepal', 1, 32, TRUE, TRUE, 'fa-flag', '#DC143C',
'{"iso2": "NP", "iso3": "NPL", "codigo_numerico": "524", "capital": "Katmandú", "moneda": "NPR", "idioma": "ne", "zona_horaria": "UTC+5:45", "codigo_telefono": "+977", "poblacion_millones": 30.0}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'OM', 'Omán', 'Oman', 'Sultanato de Omán', 1, 33, TRUE, TRUE, 'fa-flag', '#CE1126',
'{"iso2": "OM", "iso3": "OMN", "codigo_numerico": "512", "capital": "Mascate", "moneda": "OMR", "idioma": "ar", "zona_horaria": "UTC+4", "codigo_telefono": "+968", "poblacion_millones": 4.6}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'PK', 'Pakistán', 'Pakistan', 'República Islámica de Pakistán', 1, 34, TRUE, TRUE, 'fa-flag', '#01411C',
'{"iso2": "PK", "iso3": "PAK", "codigo_numerico": "586", "capital": "Islamabad", "moneda": "PKR", "idioma": "ur", "zona_horaria": "UTC+5", "codigo_telefono": "+92", "poblacion_millones": 225.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'PS', 'Palestina', 'Palestine', 'Estado de Palestina', 1, 35, TRUE, TRUE, 'fa-flag', '#000000',
'{"iso2": "PS", "iso3": "PSE", "codigo_numerico": "275", "capital": "Jerusalén Este", "moneda": "ILS", "idioma": "ar", "zona_horaria": "UTC+2", "codigo_telefono": "+970", "poblacion_millones": 5.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'QA', 'Catar', 'Qatar', 'Estado de Catar', 1, 36, TRUE, TRUE, 'fa-flag', '#8A1538',
'{"iso2": "QA", "iso3": "QAT", "codigo_numerico": "634", "capital": "Doha", "moneda": "QAR", "idioma": "ar", "zona_horaria": "UTC+3", "codigo_telefono": "+974", "poblacion_millones": 2.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'SG', 'Singapur', 'Singapore', 'República de Singapur', 1, 37, TRUE, TRUE, 'fa-flag', '#EF3340',
'{"iso2": "SG", "iso3": "SGP", "codigo_numerico": "702", "capital": "Singapur", "moneda": "SGD", "idioma": "en", "zona_horaria": "UTC+8", "codigo_telefono": "+65", "poblacion_millones": 5.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'SY', 'Siria', 'Syria', 'República Árabe Siria', 1, 38, TRUE, TRUE, 'fa-flag', '#CE1126',
'{"iso2": "SY", "iso3": "SYR", "codigo_numerico": "760", "capital": "Damasco", "moneda": "SYP", "idioma": "ar", "zona_horaria": "UTC+2", "codigo_telefono": "+963", "poblacion_millones": 18.3}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'LK', 'Sri Lanka', 'Sri Lanka', 'República Democrática Socialista de Sri Lanka', 1, 39, TRUE, TRUE, 'fa-flag', '#FFBE29',
'{"iso2": "LK", "iso3": "LKA", "codigo_numerico": "144", "capital": "Sri Jayawardenapura Kotte", "moneda": "LKR", "idioma": "si", "zona_horaria": "UTC+5:30", "codigo_telefono": "+94", "poblacion_millones": 21.8}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'TH', 'Tailandia', 'Thailand', 'Reino de Tailandia', 1, 40, TRUE, TRUE, 'fa-flag', '#A51931',
'{"iso2": "TH", "iso3": "THA", "codigo_numerico": "764", "capital": "Bangkok", "moneda": "THB", "idioma": "th", "zona_horaria": "UTC+7", "codigo_telefono": "+66", "poblacion_millones": 69.9}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'TL', 'Timor Oriental', 'Timor-Leste', 'República Democrática de Timor Oriental', 1, 41, TRUE, TRUE, 'fa-flag', '#DC241F',
'{"iso2": "TL", "iso3": "TLS", "codigo_numerico": "626", "capital": "Dili", "moneda": "USD", "idioma": "pt", "zona_horaria": "UTC+9", "codigo_telefono": "+670", "poblacion_millones": 1.3}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'TR', 'Turquía', 'Turkey', 'República de Turquía', 1, 42, TRUE, TRUE, 'fa-flag', '#E30A17',
'{"iso2": "TR", "iso3": "TUR", "codigo_numerico": "792", "capital": "Ankara", "moneda": "TRY", "idioma": "tr", "zona_horaria": "UTC+3", "codigo_telefono": "+90", "poblacion_millones": 84.8}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'TM', 'Turkmenistán', 'Turkmenistan', 'Turkmenistán', 1, 43, TRUE, TRUE, 'fa-flag', '#00843D',
'{"iso2": "TM", "iso3": "TKM", "codigo_numerico": "795", "capital": "Asjabad", "moneda": "TMT", "idioma": "tk", "zona_horaria": "UTC+5", "codigo_telefono": "+993", "poblacion_millones": 6.1}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'UZ', 'Uzbekistán', 'Uzbekistan', 'República de Uzbekistán', 1, 44, TRUE, TRUE, 'fa-flag', '#1EB53A',
'{"iso2": "UZ", "iso3": "UZB", "codigo_numerico": "860", "capital": "Taskent", "moneda": "UZS", "idioma": "uz", "zona_horaria": "UTC+5", "codigo_telefono": "+998", "poblacion_millones": 34.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'VN', 'Vietnam', 'Vietnam', 'República Socialista de Vietnam', 1, 45, TRUE, TRUE, 'fa-flag', '#DA251D',
'{"iso2": "VN", "iso3": "VNM", "codigo_numerico": "704", "capital": "Hanói", "moneda": "VND", "idioma": "vi", "zona_horaria": "UTC+7", "codigo_telefono": "+84", "poblacion_millones": 98.2}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'YE', 'Yemen', 'Yemen', 'República de Yemen', 1, 46, TRUE, TRUE, 'fa-flag', '#CE1126',
'{"iso2": "YE", "iso3": "YEM", "codigo_numerico": "887", "capital": "Saná", "moneda": "YER", "idioma": "ar", "zona_horaria": "UTC+3", "codigo_telefono": "+967", "poblacion_millones": 30.5}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'KG', 'Kirguistán', 'Kyrgyzstan', 'República Kirguisa', 1, 47, TRUE, TRUE, 'fa-flag', '#E8112D',
'{"iso2": "KG", "iso3": "KGZ", "codigo_numerico": "417", "capital": "Biskek", "moneda": "KGS", "idioma": "ky", "zona_horaria": "UTC+6", "codigo_telefono": "+996", "poblacion_millones": 6.6}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

INSERT INTO appmatch_schema.catalogo_recursivo (catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, nivel, orden, activo, seleccionable, icono, color, metadatos)
SELECT 'PAIS', pkid_catalogo_recursivo, 'TJ', 'Tayikistán', 'Tajikistan', 'República de Tayikistán', 1, 48, TRUE, TRUE, 'fa-flag', '#006600',
'{"iso2": "TJ", "iso3": "TJK", "codigo_numerico": "762", "capital": "Dusambé", "moneda": "TJS", "idioma": "tg", "zona_horaria": "UTC+5", "codigo_telefono": "+992", "poblacion_millones": 9.7}'::jsonb
FROM appmatch_schema.catalogo_recursivo WHERE codigo = 'CONT-ASIA' AND catalogo_tipo = 'PAIS' AND expiration_date IS NULL;

-- Verificación
DO $$
DECLARE v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM appmatch_schema.catalogo_recursivo cr
    INNER JOIN appmatch_schema.catalogo_recursivo padre ON cr.fkid_padre = padre.pkid_catalogo_recursivo
    WHERE cr.catalogo_tipo = 'PAIS' AND cr.nivel = 1 AND cr.expiration_date IS NULL
    AND padre.codigo = 'CONT-ASIA';
    RAISE NOTICE 'ASIA: % países insertados', v_count;
END $$;
