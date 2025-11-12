-- ============================================================================
-- Script: V3__catalogo_recursivo_datos.sql
-- Descripción: Datos de ejemplo para tabla catalogo_recursivo
-- Autor: Database Engineering Team - MI-TOGA
-- Fecha: 12 de noviembre de 2025
-- ============================================================================

-- ============================================================================
-- CATÁLOGO 1: CATEGORÍAS DE TUTORÍAS (4 NIVELES)
-- ============================================================================

-- Nivel 0: Áreas Principales (Raíces)
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, codigo, nombre, nombre_en, descripcion, orden, seleccionable, icono, color, activo, metadatos) 
VALUES
('categorias_tutorias', 'CAT-MATE', 'Matemáticas', 'Mathematics', 'Todas las ramas de las matemáticas', 1, FALSE, 'fa-calculator', '#3498DB', TRUE, '{"nivel_educativo": ["primaria", "secundaria", "universidad"], "popularidad": 95}'::JSONB),
('categorias_tutorias', 'CAT-CIEN', 'Ciencias', 'Sciences', 'Ciencias naturales y experimentales', 2, FALSE, 'fa-flask', '#27AE60', TRUE, '{"nivel_educativo": ["secundaria", "universidad"], "popularidad": 88}'::JSONB),
('categorias_tutorias', 'CAT-LENG', 'Lenguas', 'Languages', 'Idiomas y comunicación', 3, FALSE, 'fa-language', '#E74C3C', TRUE, '{"nivel_educativo": ["primaria", "secundaria", "universidad"], "popularidad": 92}'::JSONB),
('categorias_tutorias', 'CAT-TECH', 'Tecnología', 'Technology', 'Programación y tecnologías de información', 4, FALSE, 'fa-laptop-code', '#9B59B6', TRUE, '{"nivel_educativo": ["universidad", "postgrado"], "popularidad": 98}'::JSONB),
('categorias_tutorias', 'CAT-ARTE', 'Artes', 'Arts', 'Artes visuales, música y diseño', 5, FALSE, 'fa-palette', '#E67E22', TRUE, '{"nivel_educativo": ["todos"], "popularidad": 75}'::JSONB);

-- Nivel 1: Subcategorías de Matemáticas
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, icono) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-MATE-ALG',
    'Álgebra',
    'Algebra',
    'Operaciones con variables y ecuaciones',
    1,
    TRUE,
    'fa-square-root-alt'
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-MATE' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, icono) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-MATE-GEOM',
    'Geometría',
    'Geometry',
    'Estudio de formas, espacios y figuras',
    2,
    TRUE,
    'fa-shapes'
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-MATE' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, icono) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-MATE-CALC',
    'Cálculo',
    'Calculus',
    'Derivadas, integrales y límites',
    3,
    TRUE,
    'fa-infinity'
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-MATE' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, icono) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-MATE-ESTA',
    'Estadística',
    'Statistics',
    'Análisis de datos y probabilidad',
    4,
    TRUE,
    'fa-chart-bar'
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-MATE' AND expiration_date IS NULL;

-- Nivel 2: Sub-subcategorías de Álgebra
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-MATE-ALG-ECUA',
    'Ecuaciones Lineales',
    'Linear Equations',
    'Resolución de ecuaciones de primer grado',
    1,
    TRUE,
    '{"dificultad": "basico", "tiempo_promedio": "45min"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-MATE-ALG' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-MATE-ALG-CUAD',
    'Ecuaciones Cuadráticas',
    'Quadratic Equations',
    'Resolución de ecuaciones de segundo grado',
    2,
    TRUE,
    '{"dificultad": "intermedio", "tiempo_promedio": "60min"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-MATE-ALG' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-MATE-ALG-POLI',
    'Polinomios',
    'Polynomials',
    'Operaciones con expresiones polinómicas',
    3,
    TRUE,
    '{"dificultad": "intermedio", "tiempo_promedio": "60min"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-MATE-ALG' AND expiration_date IS NULL;

-- Nivel 2: Sub-subcategorías de Cálculo
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-MATE-CALC-DER',
    'Derivadas',
    'Derivatives',
    'Cálculo diferencial y aplicaciones',
    1,
    TRUE,
    '{"dificultad": "avanzado", "tiempo_promedio": "90min"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-MATE-CALC' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-MATE-CALC-INT',
    'Integrales',
    'Integrals',
    'Cálculo integral y aplicaciones',
    2,
    TRUE,
    '{"dificultad": "avanzado", "tiempo_promedio": "90min"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-MATE-CALC' AND expiration_date IS NULL;

-- Nivel 1: Subcategorías de Ciencias
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, icono) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-CIEN-FIS',
    'Física',
    'Physics',
    'Leyes del movimiento, energía y materia',
    1,
    TRUE,
    'fa-atom'
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-CIEN' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, icono) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-CIEN-QUIM',
    'Química',
    'Chemistry',
    'Propiedades y reacciones de la materia',
    2,
    TRUE,
    'fa-vial'
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-CIEN' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, icono) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-CIEN-BIO',
    'Biología',
    'Biology',
    'Estudio de los seres vivos',
    3,
    TRUE,
    'fa-dna'
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-CIEN' AND expiration_date IS NULL;

-- Nivel 2: Sub-subcategorías de Física
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-CIEN-FIS-MEC',
    'Mecánica',
    'Mechanics',
    'Cinemática, dinámica y estática',
    1,
    TRUE,
    '{"dificultad": "intermedio", "requiere_laboratorio": false}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-CIEN-FIS' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-CIEN-FIS-ELEC',
    'Electricidad y Magnetismo',
    'Electricity and Magnetism',
    'Cargas, campos y circuitos eléctricos',
    2,
    TRUE,
    '{"dificultad": "avanzado", "requiere_laboratorio": true}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-CIEN-FIS' AND expiration_date IS NULL;

-- Nivel 1: Subcategorías de Lenguas
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, icono) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-LENG-ESP',
    'Español',
    'Spanish',
    'Gramática y literatura en español',
    1,
    TRUE,
    'fa-language'
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-LENG' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, icono) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-LENG-ING',
    'Inglés',
    'English',
    'English as a Second Language',
    2,
    TRUE,
    'fa-flag-usa'
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-LENG' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, icono) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-LENG-FRAN',
    'Francés',
    'French',
    'Langue française',
    3,
    TRUE,
    'fa-flag-france'
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-LENG' AND expiration_date IS NULL;

-- Nivel 2: Sub-subcategorías de Inglés
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-LENG-ING-GRAM',
    'Gramática Inglesa',
    'English Grammar',
    'Tiempos verbales, estructuras gramaticales',
    1,
    TRUE,
    '{"nivel_referencia": "B1-C1", "certificaciones": ["TOEFL", "IELTS"]}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-LENG-ING' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-LENG-ING-CONV',
    'Conversación',
    'Conversation',
    'Práctica oral y comprensión auditiva',
    2,
    TRUE,
    '{"nivel_referencia": "A2-C2", "modalidad": "virtual"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-LENG-ING' AND expiration_date IS NULL;

-- Nivel 1: Subcategorías de Tecnología
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, icono) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-TECH-PROG',
    'Programación',
    'Programming',
    'Desarrollo de software y algoritmos',
    1,
    TRUE,
    'fa-code'
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-TECH' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, icono) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-TECH-WEB',
    'Desarrollo Web',
    'Web Development',
    'Frontend, Backend y Full Stack',
    2,
    TRUE,
    'fa-globe'
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-TECH' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, icono) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-TECH-DATA',
    'Data Science',
    'Data Science',
    'Análisis de datos, ML y Big Data',
    3,
    TRUE,
    'fa-database'
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-TECH' AND expiration_date IS NULL;

-- Nivel 2: Sub-subcategorías de Programación
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-TECH-PROG-JAVA',
    'Java',
    'Java',
    'Programación orientada a objetos con Java',
    1,
    TRUE,
    '{"tecnologias": ["Spring Boot", "Hibernate", "Maven"], "nivel": "intermedio-avanzado"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-TECH-PROG' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-TECH-PROG-PY',
    'Python',
    'Python',
    'Programación versátil para múltiples dominios',
    2,
    TRUE,
    '{"tecnologias": ["Django", "Flask", "Pandas"], "nivel": "basico-avanzado"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-TECH-PROG' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-TECH-PROG-JS',
    'JavaScript',
    'JavaScript',
    'Lenguaje fundamental para desarrollo web',
    3,
    TRUE,
    '{"tecnologias": ["React", "Node.js", "TypeScript"], "nivel": "basico-avanzado"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-TECH-PROG' AND expiration_date IS NULL;

-- Nivel 3: Sub-sub-subcategorías de Java
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-TECH-PROG-JAVA-SPRING',
    'Spring Framework',
    'Spring Framework',
    'Framework empresarial Java más popular',
    1,
    TRUE,
    '{"modulos": ["Spring Boot", "Spring Data", "Spring Security"], "duracion": "120min"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-TECH-PROG-JAVA' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-TECH-PROG-JAVA-JPA',
    'JPA/Hibernate',
    'JPA/Hibernate',
    'Object-Relational Mapping en Java',
    2,
    TRUE,
    '{"temas": ["Entidades", "Relaciones", "JPQL", "Criteria API"], "duracion": "90min"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-TECH-PROG-JAVA' AND expiration_date IS NULL;

-- ============================================================================
-- CATÁLOGO 2: UBICACIONES GEOGRÁFICAS (3 NIVELES)
-- ============================================================================

-- Nivel 0: Países (Raíces)
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, codigo, nombre, nombre_en, orden, seleccionable, icono, color, activo, metadatos) 
VALUES
('ubicaciones', 'UBI-COL', 'Colombia', 'Colombia', 1, FALSE, 'fa-flag', '#FCD116', TRUE, '{"iso_code": "CO", "continente": "America del Sur", "poblacion": 51000000, "moneda": "COP"}'::JSONB),
('ubicaciones', 'UBI-MEX', 'México', 'Mexico', 2, FALSE, 'fa-flag', '#006847', TRUE, '{"iso_code": "MX", "continente": "America del Norte", "poblacion": 128000000, "moneda": "MXN"}'::JSONB),
('ubicaciones', 'UBI-ARG', 'Argentina', 'Argentina', 3, FALSE, 'fa-flag', '#74ACDF', TRUE, '{"iso_code": "AR", "continente": "America del Sur", "poblacion": 45000000, "moneda": "ARS"}'::JSONB),
('ubicaciones', 'UBI-ESP', 'España', 'Spain', 4, FALSE, 'fa-flag', '#C60B1E', TRUE, '{"iso_code": "ES", "continente": "Europa", "poblacion": 47000000, "moneda": "EUR"}'::JSONB);

-- Nivel 1: Departamentos/Estados de Colombia
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, orden, seleccionable, metadatos) 
SELECT 
    'ubicaciones',
    pkid_catalogo_recursivo,
    'UBI-COL-CUN',
    'Cundinamarca',
    'Cundinamarca',
    1,
    FALSE,
    '{"capital": "Bogotá", "poblacion": 3200000, "zona": "Andina"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'UBI-COL' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, orden, seleccionable, metadatos) 
SELECT 
    'ubicaciones',
    pkid_catalogo_recursivo,
    'UBI-COL-ANT',
    'Antioquia',
    'Antioquia',
    2,
    FALSE,
    '{"capital": "Medellín", "poblacion": 6600000, "zona": "Andina"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'UBI-COL' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, orden, seleccionable, metadatos) 
SELECT 
    'ubicaciones',
    pkid_catalogo_recursivo,
    'UBI-COL-VAL',
    'Valle del Cauca',
    'Valle del Cauca',
    3,
    FALSE,
    '{"capital": "Cali", "poblacion": 4600000, "zona": "Pacífica"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'UBI-COL' AND expiration_date IS NULL;

-- Nivel 2: Ciudades de Cundinamarca
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, orden, seleccionable, metadatos) 
SELECT 
    'ubicaciones',
    pkid_catalogo_recursivo,
    'UBI-COL-CUN-BOG',
    'Bogotá D.C.',
    'Bogota D.C.',
    1,
    TRUE,
    '{"tipo": "Capital", "poblacion": 7800000, "zona_horaria": "UTC-5"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'UBI-COL-CUN' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, orden, seleccionable, metadatos) 
SELECT 
    'ubicaciones',
    pkid_catalogo_recursivo,
    'UBI-COL-CUN-CHIA',
    'Chía',
    'Chia',
    2,
    TRUE,
    '{"tipo": "Municipio", "poblacion": 140000, "zona_horaria": "UTC-5"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'UBI-COL-CUN' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, orden, seleccionable, metadatos) 
SELECT 
    'ubicaciones',
    pkid_catalogo_recursivo,
    'UBI-COL-CUN-SOACHA',
    'Soacha',
    'Soacha',
    3,
    TRUE,
    '{"tipo": "Municipio", "poblacion": 650000, "zona_horaria": "UTC-5"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'UBI-COL-CUN' AND expiration_date IS NULL;

-- Nivel 2: Ciudades de Antioquia
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, orden, seleccionable, metadatos) 
SELECT 
    'ubicaciones',
    pkid_catalogo_recursivo,
    'UBI-COL-ANT-MED',
    'Medellín',
    'Medellin',
    1,
    TRUE,
    '{"tipo": "Capital", "poblacion": 2600000, "zona_horaria": "UTC-5"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'UBI-COL-ANT' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, orden, seleccionable, metadatos) 
SELECT 
    'ubicaciones',
    pkid_catalogo_recursivo,
    'UBI-COL-ANT-ENV',
    'Envigado',
    'Envigado',
    2,
    TRUE,
    '{"tipo": "Municipio", "poblacion": 240000, "zona_horaria": "UTC-5"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'UBI-COL-ANT' AND expiration_date IS NULL;

-- Nivel 1: Estados de México
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, orden, seleccionable, metadatos) 
SELECT 
    'ubicaciones',
    pkid_catalogo_recursivo,
    'UBI-MEX-CDMX',
    'Ciudad de México',
    'Mexico City',
    1,
    TRUE,
    '{"tipo": "Capital Federal", "poblacion": 9200000, "zona_horaria": "UTC-6"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'UBI-MEX' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, orden, seleccionable, metadatos) 
SELECT 
    'ubicaciones',
    pkid_catalogo_recursivo,
    'UBI-MEX-JAL',
    'Jalisco',
    'Jalisco',
    2,
    FALSE,
    '{"capital": "Guadalajara", "poblacion": 8300000, "zona_horaria": "UTC-6"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'UBI-MEX' AND expiration_date IS NULL;

-- ============================================================================
-- CATÁLOGO 3: TIPOS DE DOCUMENTO (2 NIVELES)
-- ============================================================================

-- Nivel 0: Categorías de Documentos (Raíces)
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, codigo, nombre, nombre_en, descripcion, orden, seleccionable, icono, activo) 
VALUES
('tipos_documento', 'DOC-IDEN', 'Documentos de Identificación', 'Identity Documents', 'Documentos oficiales de identidad', 1, FALSE, 'fa-id-card', TRUE),
('tipos_documento', 'DOC-ACAD', 'Documentos Académicos', 'Academic Documents', 'Certificados y diplomas educativos', 2, FALSE, 'fa-graduation-cap', TRUE),
('tipos_documento', 'DOC-FINA', 'Documentos Financieros', 'Financial Documents', 'Documentos de transacciones financieras', 3, FALSE, 'fa-file-invoice-dollar', TRUE);

-- Nivel 1: Tipos de Documentos de Identificación
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'tipos_documento',
    pkid_catalogo_recursivo,
    'DOC-IDEN-CC',
    'Cédula de Ciudadanía',
    'National ID Card',
    'Documento de identificación nacional (Colombia)',
    1,
    TRUE,
    '{"pais": "Colombia", "formato": "numero", "longitud": 10, "valido_hasta": null}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'DOC-IDEN' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'tipos_documento',
    pkid_catalogo_recursivo,
    'DOC-IDEN-PASS',
    'Pasaporte',
    'Passport',
    'Documento de viaje internacional',
    2,
    TRUE,
    '{"pais": "Internacional", "formato": "alfanumerico", "longitud": 9, "valido_hasta": "10 años"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'DOC-IDEN' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'tipos_documento',
    pkid_catalogo_recursivo,
    'DOC-IDEN-CE',
    'Cédula de Extranjería',
    'Foreign ID Card',
    'Documento de identificación para extranjeros',
    3,
    TRUE,
    '{"pais": "Colombia", "formato": "numero", "longitud": 7, "valido_hasta": "variable"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'DOC-IDEN' AND expiration_date IS NULL;

-- Nivel 1: Tipos de Documentos Académicos
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'tipos_documento',
    pkid_catalogo_recursivo,
    'DOC-ACAD-DIPL',
    'Diploma',
    'Diploma',
    'Certificado de grado académico',
    1,
    TRUE,
    '{"nivel": ["bachiller", "profesional", "postgrado"], "requiere_apostilla": true}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'DOC-ACAD' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'tipos_documento',
    pkid_catalogo_recursivo,
    'DOC-ACAD-CERT',
    'Certificado de Estudios',
    'Academic Certificate',
    'Certificado de notas y cursos aprobados',
    2,
    TRUE,
    '{"nivel": ["primaria", "secundaria", "universidad"], "requiere_apostilla": false}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'DOC-ACAD' AND expiration_date IS NULL;

-- ============================================================================
-- CATÁLOGO 4: ESTADOS DE TUTORÍA (2 NIVELES)
-- ============================================================================

-- Nivel 0: Estados Principales
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, codigo, nombre, nombre_en, descripcion, orden, seleccionable, icono, color, activo) 
VALUES
('estados_tutoria', 'EST-PEND', 'Pendiente', 'Pending', 'Tutoría solicitada pero no confirmada', 1, TRUE, 'fa-clock', '#F39C12', TRUE),
('estados_tutoria', 'EST-CONF', 'Confirmada', 'Confirmed', 'Tutoría confirmada por tutor', 2, TRUE, 'fa-check-circle', '#3498DB', TRUE),
('estados_tutoria', 'EST-PROG', 'En Progreso', 'In Progress', 'Tutoría en curso', 3, TRUE, 'fa-play-circle', '#9B59B6', TRUE),
('estados_tutoria', 'EST-COMP', 'Completada', 'Completed', 'Tutoría finalizada exitosamente', 4, TRUE, 'fa-check-double', '#27AE60', TRUE),
('estados_tutoria', 'EST-CANC', 'Cancelada', 'Cancelled', 'Tutoría cancelada', 5, FALSE, 'fa-times-circle', '#E74C3C', TRUE);

-- Nivel 1: Sub-estados de Cancelada
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'estados_tutoria',
    pkid_catalogo_recursivo,
    'EST-CANC-EST',
    'Cancelada por Estudiante',
    'Cancelled by Student',
    'El estudiante canceló la sesión',
    1,
    TRUE,
    '{"reembolso": true, "penalizacion": false}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'EST-CANC' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'estados_tutoria',
    pkid_catalogo_recursivo,
    'EST-CANC-TUT',
    'Cancelada por Tutor',
    'Cancelled by Tutor',
    'El tutor canceló la sesión',
    2,
    TRUE,
    '{"reembolso": true, "penalizacion": true}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'EST-CANC' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'estados_tutoria',
    pkid_catalogo_recursivo,
    'EST-CANC-SIS',
    'Cancelada por Sistema',
    'Cancelled by System',
    'Cancelación automática por tiempo de espera',
    3,
    TRUE,
    '{"reembolso": true, "penalizacion": false}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'EST-CANC' AND expiration_date IS NULL;

-- ============================================================================
-- CATÁLOGO 5: NIVELES EDUCATIVOS (SIMPLE - 1 NIVEL)
-- ============================================================================

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, codigo, nombre, nombre_en, descripcion, orden, seleccionable, icono, color, activo, metadatos) 
VALUES
('niveles_educativos', 'NIV-PRIM', 'Primaria', 'Elementary School', 'Grados 1-5', 1, TRUE, 'fa-child', '#FF6B6B', TRUE, '{"edad_minima": 6, "edad_maxima": 11}'::JSONB),
('niveles_educativos', 'NIV-SECU', 'Secundaria', 'Middle School', 'Grados 6-9', 2, TRUE, 'fa-user-graduate', '#4ECDC4', TRUE, '{"edad_minima": 12, "edad_maxima": 15}'::JSONB),
('niveles_educativos', 'NIV-MEDI', 'Media', 'High School', 'Grados 10-11', 3, TRUE, 'fa-school', '#95E1D3', TRUE, '{"edad_minima": 16, "edad_maxima": 17}'::JSONB),
('niveles_educativos', 'NIV-UNIV', 'Universidad', 'University', 'Pregrado', 4, TRUE, 'fa-university', '#F38181', TRUE, '{"edad_minima": 18, "edad_maxima": null}'::JSONB),
('niveles_educativos', 'NIV-POST', 'Postgrado', 'Graduate School', 'Maestría y Doctorado', 5, TRUE, 'fa-user-tie', '#AA96DA', TRUE, '{"edad_minima": 22, "edad_maxima": null}'::JSONB);

-- ============================================================================
-- CATÁLOGO 6: MODALIDADES DE TUTORÍA (2 NIVELES)
-- ============================================================================

-- Nivel 0: Modalidades
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, codigo, nombre, nombre_en, descripcion, orden, seleccionable, icono, color, activo) 
VALUES
('modalidades_tutoria', 'MOD-VIRT', 'Virtual', 'Online', 'Sesiones por videoconferencia', 1, FALSE, 'fa-video', '#3498DB', TRUE),
('modalidades_tutoria', 'MOD-PRES', 'Presencial', 'In-Person', 'Sesiones cara a cara', 2, FALSE, 'fa-handshake', '#27AE60', TRUE),
('modalidades_tutoria', 'MOD-HIBR', 'Híbrida', 'Hybrid', 'Combinación de virtual y presencial', 3, TRUE, 'fa-exchange-alt', '#9B59B6', TRUE);

-- Nivel 1: Sub-modalidades Virtuales
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'modalidades_tutoria',
    pkid_catalogo_recursivo,
    'MOD-VIRT-SYNC',
    'Virtual Sincrónica',
    'Live Online',
    'Sesión en vivo por videoconferencia',
    1,
    TRUE,
    '{"plataformas": ["Zoom", "Google Meet", "Microsoft Teams"], "requiere_camara": true}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'MOD-VIRT' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'modalidades_tutoria',
    pkid_catalogo_recursivo,
    'MOD-VIRT-ASYNC',
    'Virtual Asincrónica',
    'Recorded Online',
    'Contenido grabado y material de estudio',
    2,
    TRUE,
    '{"plataformas": ["YouTube", "Vimeo", "Plataforma Propia"], "requiere_camara": false}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'MOD-VIRT' AND expiration_date IS NULL;

-- Nivel 1: Sub-modalidades Presenciales
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'modalidades_tutoria',
    pkid_catalogo_recursivo,
    'MOD-PRES-DOMI',
    'Presencial a Domicilio',
    'At Home',
    'Tutor visita el domicilio del estudiante',
    1,
    TRUE,
    '{"costo_adicional": true, "radio_maximo_km": 15}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'MOD-PRES' AND expiration_date IS NULL;

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, descripcion, orden, seleccionable, metadatos) 
SELECT 
    'modalidades_tutoria',
    pkid_catalogo_recursivo,
    'MOD-PRES-CENT',
    'Presencial en Centro',
    'At Center',
    'Sesión en centro de estudios o biblioteca',
    2,
    TRUE,
    '{"costo_adicional": false, "centros_disponibles": ["Biblioteca Luis Ángel Arango", "Centro de Tutorías Universidad"]}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'MOD-PRES' AND expiration_date IS NULL;

-- ============================================================================
-- FIN DEL SCRIPT
-- ============================================================================

-- Verificar totales insertados por catálogo
SELECT 
    catalogo_tipo,
    COUNT(*) as total_registros,
    COUNT(DISTINCT nivel) as niveles_profundidad,
    SUM(CASE WHEN fkid_padre IS NULL THEN 1 ELSE 0 END) as nodos_raiz,
    SUM(CASE WHEN tiene_hijos = FALSE THEN 1 ELSE 0 END) as nodos_hoja
FROM shared_schema.catalogo_recursivo
WHERE expiration_date IS NULL
GROUP BY catalogo_tipo
ORDER BY catalogo_tipo;

-- ============================================================================
-- CATÁLOGO: TIPOS DE DOCUMENTO DE IDENTIFICACIÓN - COLOMBIA
-- ============================================================================
-- Autor: Database Engineer Senior
-- Fecha: 12 de noviembre de 2025
-- Normativa: Resolución DIAN, Registraduría Nacional, Superintendencias
-- Descripción: Catálogo jerárquico de tipos de documento de identificación
--              válidos en Colombia según normativa vigente 2025
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
    
    IF v_count_documentos < 10 THEN
        RAISE WARNING 'Se esperaban al menos 10 documentos, se insertaron %', v_count_documentos;
    END IF;
END $$;

-- Comentario final
COMMENT ON SCHEMA shared_schema IS 'Schema compartido - Actualizado con datos de ejemplo de catálogos recursivos (12/Nov/2025)';

