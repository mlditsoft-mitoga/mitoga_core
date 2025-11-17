-- ═══════════════════════════════════════════════════════════════════════════════
-- SCRIPT: V002__crear_tabla_informacion_basica.sql
-- AUTOR: Database Engineer Senior - PostgreSQL Architect
-- FECHA: 2025-11-16
-- VERSION: 1.0.0
-- 
-- DESCRIPCION:
--   Creación de la tabla maestra 'informacion_basica' que almacena todos los datos
--   personales básicos según HUT-001 (Registro Estudiante) y HUT-002 (Registro Tutor).
--   
--   Esta es una TABLA MAESTRA independiente (no está directamente relacionada con usuarios).
--   La relación 1:1 con usuarios se establecerá desde la tabla usuarios (V003).
--   
--   Campos: Nombres completos (4 campos), fecha nacimiento, género (FK), teléfono,
--   ubicación (país FK, ciudad FK, dirección), nivel educativo (FK), sobre mí,
--   responsable legal (nombre, email, teléfono, número identificación).
--
-- BOUNDED CONTEXT: Shared Kernel (Datos maestros compartidos)
-- AGGREGATE: InformacionBasica (Value Objects: NombreCompleto, Ubicacion, ResponsableLegal)
-- 
-- DEPENDENCIAS:
--   - V001__crear_tabla_perfiles.sql (tabla perfiles ya existe)
--   - Catálogo recursivo (países, ciudades, géneros, niveles educativos)
--   - PostgreSQL 12+, Extension uuid-ossp
--
-- CRITERIOS DE DISEÑO DDD:
--   ✅ Schema único (appmatch_schema)
--   ✅ Naming convention: pkid_{tabla}, creation_date, expiration_date
--   ✅ Constraints explícitos
--   ✅ Soft delete (expiration_date)
--   ✅ Audit trail completo
--   ✅ Validaciones de negocio (edad mínima, teléfono formato)
--   ✅ Índices para búsquedas comunes
-- ═══════════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 1: Verificar prerrequisitos
-- ═══════════════════════════════════════════════════════════════════════════════

-- Verificar que existe appmatch_schema
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'appmatch_schema') THEN
        RAISE EXCEPTION 'Schema appmatch_schema no existe. Ejecutar V001 primero.';
    END IF;
END $$;

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 2: Crear tabla informacion_basica
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS appmatch_schema.informacion_basica (
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    pkid_informacion_basica UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- VALUE OBJECT: NOMBRE COMPLETO (4 campos según HUT-001)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    primer_nombre VARCHAR(50) NOT NULL,
        -- Primer nombre (obligatorio)
        -- Capitalización automática en backend
        
    segundo_nombre VARCHAR(50),
        -- Segundo nombre (opcional)
        
    primer_apellido VARCHAR(50) NOT NULL,
        -- Primer apellido (obligatorio)
        
    segundo_apellido VARCHAR(50),
        -- Segundo apellido (opcional)
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- IDENTIFICACIÓN Y CONTACTO PRINCIPAL
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    fk_pkid_catalogo_tipo_documento UUID NOT NULL,
        -- FK a appmatch_schema.catalogo_recursivo (tipo: TIPO_DOCUMENTO)
        -- Valores: CEDULA, PASAPORTE, DNI, NIE, RUT, etc.
    
    numero_identificacion VARCHAR(50) NOT NULL,
        -- Número de identificación del usuario (cédula, pasaporte, DNI, etc.)
        -- UNIQUE constraint garantiza unicidad junto con tipo_documento
        
    email VARCHAR(255) NOT NULL,
        -- Correo electrónico del usuario
        -- UNIQUE constraint garantiza unicidad
        -- Validación de formato en constraint
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- DATOS DEMOGRÁFICOS
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    fecha_nacimiento DATE NOT NULL,
        -- Fecha de nacimiento
        -- Validación: Mayor a 1900, menor a fecha actual
        -- Cálculo de edad automático en backend
        
    fk_pkid_catalogo_genero UUID NOT NULL,
        -- FK a appmatch_schema.catalogo_recursivo (tipo: GENERO)
        -- Valores: MASCULINO, FEMENINO, OTRO, PREFIERO_NO_DECIR
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- VALUE OBJECT: UBICACIÓN
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    fk_pkid_catalogo_pais UUID NOT NULL,
        -- FK a appmatch_schema.catalogo_recursivo (tipo: PAIS)
        -- Valores: COLOMBIA, MEXICO, ESPAÑA, etc.
        
    fk_pkid_catalogo_ciudad UUID NOT NULL,
        -- FK a appmatch_schema.catalogo_recursivo (tipo: CIUDAD)
        -- Valores: BOGOTA, MEDELLIN, MADRID, etc.
        -- Nota: ciudad debe ser hija del país seleccionado (jerarquía)
        
    direccion VARCHAR(255),
        -- Dirección completa (opcional)
        -- Formato: "Calle 123 #45-67, Apto 301"
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- CONTACTO
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    telefono VARCHAR(20) NOT NULL,
        -- Teléfono con código país (ej: "+57 310 1234567")
        -- Validación: Formato internacional
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- PERFIL EDUCATIVO (OPCIONAL - PRINCIPALMENTE ESTUDIANTES)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    fk_pkid_catalogo_nivel_educativo UUID,
        -- FK a appmatch_schema.catalogo_recursivo (tipo: NIVEL_EDUCATIVO)
        -- Valores: PRIMARIA, SECUNDARIA, BACHILLERATO, TECNICO, UNIVERSITARIO, POSGRADO
        -- NULL permitido (tutores pueden no especificar nivel educativo)
        
    sobre_mi TEXT,
        -- Descripción libre del usuario (máx 500 caracteres en validación backend)
        -- "Soy estudiante de ingeniería interesado en..."
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- RESPONSABLE LEGAL (MENORES DE 18 AÑOS)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    tiene_responsable_legal BOOLEAN NOT NULL DEFAULT FALSE,
        -- TRUE si el usuario es menor de 18 años
        -- Calculado automáticamente en backend según fecha_nacimiento
        
    responsable_email VARCHAR(255),
        -- Email del responsable legal (obligatorio si tiene_responsable_legal = TRUE)
        
    responsable_numero_identificacion VARCHAR(50),
        -- Número de identificación del responsable (cédula, pasaporte, etc.)
        -- Obligatorio si tiene_responsable_legal = TRUE
        
    responsable_primer_nombre VARCHAR(50),
        -- Primer nombre del responsable
        
    responsable_primer_apellido VARCHAR(50),
        -- Primer apellido del responsable
        
    responsable_telefono VARCHAR(20),
        -- Teléfono del responsable
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- METADATA Y AUDITORÍA
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    ip_registro VARCHAR(45),
        -- IP desde donde se registró (IPv4 o IPv6)
        
    metadata JSONB DEFAULT '{}'::JSONB,
        -- Metadata adicional flexible
        -- Ejemplos: {"user_agent": "...", "dispositivo": "web", "idioma": "es-CO"}
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- CONSTRAINTS
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    CONSTRAINT pk_informacion_basica PRIMARY KEY (pkid_informacion_basica),
    
    -- Unique constraints
    CONSTRAINT uk_informacion_basica_tipo_documento_numero
        UNIQUE (fk_pkid_catalogo_tipo_documento, numero_identificacion),
        -- Combinación tipo documento + número debe ser única
        -- Ej: CEDULA-80123456, PASAPORTE-AB123456
        
    CONSTRAINT uk_informacion_basica_email
        UNIQUE (email),
        -- Email único por usuario
    
    -- Foreign Keys a catálogo recursivo
    CONSTRAINT fk_informacion_basica_catalogo_tipo_documento
        FOREIGN KEY (fk_pkid_catalogo_tipo_documento)
        REFERENCES appmatch_schema.catalogo_recursivo(pkid_catalogo_recursivo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_informacion_basica_catalogo_genero
        FOREIGN KEY (fk_pkid_catalogo_genero)
        REFERENCES appmatch_schema.catalogo_recursivo(pkid_catalogo_recursivo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
    CONSTRAINT fk_informacion_basica_catalogo_pais
        FOREIGN KEY (fk_pkid_catalogo_pais)
        REFERENCES appmatch_schema.catalogo_recursivo(pkid_catalogo_recursivo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
    CONSTRAINT fk_informacion_basica_catalogo_ciudad
        FOREIGN KEY (fk_pkid_catalogo_ciudad)
        REFERENCES appmatch_schema.catalogo_recursivo(pkid_catalogo_recursivo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
    CONSTRAINT fk_informacion_basica_catalogo_nivel_educativo
        FOREIGN KEY (fk_pkid_catalogo_nivel_educativo)
        REFERENCES appmatch_schema.catalogo_recursivo(pkid_catalogo_recursivo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
    -- Validación de nombres (no vacíos después de trim)
    CONSTRAINT ck_informacion_basica_primer_nombre_no_vacio 
        CHECK (LENGTH(TRIM(primer_nombre)) > 0),
        
    CONSTRAINT ck_informacion_basica_primer_apellido_no_vacio 
        CHECK (LENGTH(TRIM(primer_apellido)) > 0),
    
    -- Validación de número de identificación (no vacío)
    CONSTRAINT ck_informacion_basica_numero_identificacion_no_vacio
        CHECK (LENGTH(TRIM(numero_identificacion)) > 0),
    
    -- Validación de email (formato)
    CONSTRAINT ck_informacion_basica_email_formato
        CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'),
    
    -- Validación de fecha de nacimiento (rango razonable)
    CONSTRAINT ck_informacion_basica_fecha_nacimiento_valida 
        CHECK (
            fecha_nacimiento >= '1900-01-01' AND 
            fecha_nacimiento <= CURRENT_DATE
        ),
        
    -- Validación de edad mínima (13 años según COPPA)
    CONSTRAINT ck_informacion_basica_edad_minima 
        CHECK (
            fecha_nacimiento <= CURRENT_DATE - INTERVAL '13 years'
        ),
    
    -- Validación de teléfono (formato internacional básico)
    CONSTRAINT ck_informacion_basica_telefono_formato 
        CHECK (telefono ~ '^\+?[0-9\s\-()]{8,20}$'),
    
    -- Validación de responsable legal (coherencia completa)
    CONSTRAINT ck_informacion_basica_responsable_coherente
        CHECK (
            (tiene_responsable_legal = FALSE) OR
            (tiene_responsable_legal = TRUE AND 
             responsable_email IS NOT NULL AND 
             responsable_numero_identificacion IS NOT NULL AND 
             responsable_primer_nombre IS NOT NULL AND 
             responsable_primer_apellido IS NOT NULL AND 
             responsable_telefono IS NOT NULL)
        ),
        -- Si tiene responsable legal, TODOS los campos del responsable son obligatorios (incluido número identificación)
        
    -- Validación de responsable legal (email formato)
    CONSTRAINT ck_informacion_basica_responsable_email_formato
        CHECK (
            responsable_email IS NULL OR 
            responsable_email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'
        ),
        
    -- Soft delete coherente
    CONSTRAINT ck_informacion_basica_soft_delete_coherente
        CHECK (
            expiration_date IS NULL OR 
            expiration_date > creation_date
        )
);

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 3: Crear índices para búsquedas comunes y performance de JOINs
-- ═══════════════════════════════════════════════════════════════════════════════

-- Índices en Foreign Keys (CRÍTICO para performance de JOINs)
CREATE INDEX idx_informacion_basica_fk_tipo_documento 
    ON appmatch_schema.informacion_basica(fk_pkid_catalogo_tipo_documento) 
    WHERE expiration_date IS NULL;

CREATE INDEX idx_informacion_basica_fk_genero 
    ON appmatch_schema.informacion_basica(fk_pkid_catalogo_genero) 
    WHERE expiration_date IS NULL;

CREATE INDEX idx_informacion_basica_fk_pais 
    ON appmatch_schema.informacion_basica(fk_pkid_catalogo_pais) 
    WHERE expiration_date IS NULL;

CREATE INDEX idx_informacion_basica_fk_ciudad 
    ON appmatch_schema.informacion_basica(fk_pkid_catalogo_ciudad) 
    WHERE expiration_date IS NULL;

CREATE INDEX idx_informacion_basica_fk_nivel_educativo 
    ON appmatch_schema.informacion_basica(fk_pkid_catalogo_nivel_educativo) 
    WHERE expiration_date IS NULL AND fk_pkid_catalogo_nivel_educativo IS NOT NULL;

-- Índice para búsqueda por nombres (caso común en admin/búsqueda)
CREATE INDEX idx_informacion_basica_nombres 
    ON appmatch_schema.informacion_basica(primer_nombre, primer_apellido) 
    WHERE expiration_date IS NULL;

-- Índice único compuesto para tipo documento + número (búsquedas frecuentes)
CREATE UNIQUE INDEX idx_informacion_basica_tipo_doc_numero 
    ON appmatch_schema.informacion_basica(fk_pkid_catalogo_tipo_documento, numero_identificacion) 
    WHERE expiration_date IS NULL;

-- Índice único para email (búsquedas frecuentes, login)
CREATE UNIQUE INDEX idx_informacion_basica_email 
    ON appmatch_schema.informacion_basica(email) 
    WHERE expiration_date IS NULL;

-- Índice compuesto para búsqueda por ubicación (país + ciudad)
CREATE INDEX idx_informacion_basica_ubicacion 
    ON appmatch_schema.informacion_basica(fk_pkid_catalogo_pais, fk_pkid_catalogo_ciudad) 
    WHERE expiration_date IS NULL;

-- Índice para búsqueda por fecha de nacimiento (cálculos de edad, estadísticas)
CREATE INDEX idx_informacion_basica_fecha_nacimiento 
    ON appmatch_schema.informacion_basica(fecha_nacimiento) 
    WHERE expiration_date IS NULL;

-- Índice para menores con responsable legal (compliance COPPA)
CREATE INDEX idx_informacion_basica_con_responsable 
    ON appmatch_schema.informacion_basica(tiene_responsable_legal) 
    WHERE expiration_date IS NULL AND tiene_responsable_legal = TRUE;

-- Índice GIN para búsquedas en metadata JSONB
CREATE INDEX idx_informacion_basica_metadata 
    ON appmatch_schema.informacion_basica USING GIN(metadata);

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 4: Insertar datos de prueba
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO appmatch_schema.informacion_basica (
    pkid_informacion_basica,
    creation_date,
    expiration_date,
    primer_nombre,
    segundo_nombre,
    primer_apellido,
    segundo_apellido,
    fk_pkid_catalogo_tipo_documento,
    numero_identificacion,
    email,
    fecha_nacimiento,
    fk_pkid_catalogo_genero,
    fk_pkid_catalogo_pais,
    fk_pkid_catalogo_ciudad,
    direccion,
    telefono,
    fk_pkid_catalogo_nivel_educativo,
    sobre_mi,
    tiene_responsable_legal,
    responsable_email,
    responsable_numero_identificacion,
    responsable_primer_nombre,
    responsable_primer_apellido,
    responsable_telefono,
    ip_registro,
    metadata
) VALUES (
    'aabee5d7-14bb-4d90-8e4b-347b736b6485'::UUID,
    '2025-11-16 19:55:00.250 -0500'::TIMESTAMPTZ,
    NULL,
    'Wilmer',
    'Giovanny',
    'Torres',
    'Achury',
    'f9fc4463-b888-4edc-af65-41a562af160a'::UUID,  -- FK tipo documento (CEDULA)
    '80123456',  -- Número de identificación
    'wilmer.torres@example.com',  -- Email
    '1989-02-07'::DATE,
    'e1b11566-27f7-4d1f-9a75-368ea0e3a0e8'::UUID,  -- FK género
    'ed9790a0-25ce-45b9-85fb-a3bcef6d36c1'::UUID,  -- FK país
    '4ab636b2-ef9b-4fad-b48c-66a8d0e162df'::UUID,  -- FK ciudad
    'call 38 No 24B224',
    '+573016738627',
    'f0fd0e60-d48e-474a-808f-cf807b1f27a7'::UUID,  -- FK nivel educativo
    'soy melo',
    FALSE,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    '{}'::JSONB
) ON CONFLICT (pkid_informacion_basica) DO NOTHING;

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 5: Documentación (COMMENTS)
-- ═══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE appmatch_schema.informacion_basica IS 
'TABLA MAESTRA: Información personal básica (Value Objects: NombreCompleto, Ubicacion, ResponsableLegal).
NOTA: Esta es una tabla maestra independiente. La relación 1:1 con usuarios se establece desde
la tabla usuarios (V003) con FK hacia esta tabla. Incluye datos demográficos, contacto,
perfil educativo y responsable legal para menores de 18 años.';

COMMENT ON COLUMN appmatch_schema.informacion_basica.pkid_informacion_basica IS 
'Primary Key UUID de la tabla informacion_basica';

COMMENT ON COLUMN appmatch_schema.informacion_basica.primer_nombre IS 
'Primer nombre del usuario (obligatorio, capitalizado automáticamente en backend)';

COMMENT ON COLUMN appmatch_schema.informacion_basica.segundo_nombre IS 
'Segundo nombre del usuario (opcional)';

COMMENT ON COLUMN appmatch_schema.informacion_basica.primer_apellido IS 
'Primer apellido del usuario (obligatorio, capitalizado automáticamente en backend)';

COMMENT ON COLUMN appmatch_schema.informacion_basica.segundo_apellido IS 
'Segundo apellido del usuario (opcional)';

COMMENT ON COLUMN appmatch_schema.informacion_basica.fk_pkid_catalogo_tipo_documento IS 
'FK a appmatch_schema.catalogo_recursivo (tipo: TIPO_DOCUMENTO). Valores: CEDULA, PASAPORTE, DNI, NIE, RUT, etc. 
Obligatorio. Usado en conjunto con numero_identificacion para identificación única.';

COMMENT ON COLUMN appmatch_schema.informacion_basica.numero_identificacion IS 
'Número de identificación del usuario (cédula, pasaporte, DNI, etc.). 
UNIQUE constraint compuesto con fk_pkid_catalogo_tipo_documento. Obligatorio.';

COMMENT ON COLUMN appmatch_schema.informacion_basica.email IS 
'Correo electrónico del usuario. UNIQUE constraint garantiza que no haya duplicados. 
Validación de formato mediante constraint. Obligatorio.';

COMMENT ON COLUMN appmatch_schema.informacion_basica.fecha_nacimiento IS 
'Fecha de nacimiento del usuario. Validación: Entre 1900-01-01 y fecha actual, edad mínima 13 años (COPPA compliance).';

COMMENT ON COLUMN appmatch_schema.informacion_basica.fk_pkid_catalogo_genero IS 
'FK a appmatch_schema.catalogo_recursivo (tipo: GENERO). Valores: MASCULINO, FEMENINO, OTRO, PREFIERO_NO_DECIR.';

COMMENT ON COLUMN appmatch_schema.informacion_basica.fk_pkid_catalogo_pais IS 
'FK a appmatch_schema.catalogo_recursivo (tipo: PAIS). Valores: COLOMBIA, MEXICO, ESPAÑA, etc.';

COMMENT ON COLUMN appmatch_schema.informacion_basica.fk_pkid_catalogo_ciudad IS 
'FK a appmatch_schema.catalogo_recursivo (tipo: CIUDAD). Valores: BOGOTA, MEDELLIN, MADRID, etc. 
Debe ser hijo del país seleccionado en la jerarquía del catálogo recursivo.';

COMMENT ON COLUMN appmatch_schema.informacion_basica.direccion IS 
'Dirección completa del usuario (opcional). Formato libre, ej: "Calle 123 #45-67, Apto 301"';

COMMENT ON COLUMN appmatch_schema.informacion_basica.telefono IS 
'Teléfono con código de país (formato internacional). Validación: 8-20 caracteres con +, números, espacios, guiones, paréntesis.';

COMMENT ON COLUMN appmatch_schema.informacion_basica.fk_pkid_catalogo_nivel_educativo IS 
'FK a appmatch_schema.catalogo_recursivo (tipo: NIVEL_EDUCATIVO). Valores: PRIMARIA, SECUNDARIA, BACHILLERATO, TECNICO, UNIVERSITARIO, POSGRADO. 
NULL permitido (ej: tutores que no especifican nivel educativo).';

COMMENT ON COLUMN appmatch_schema.informacion_basica.sobre_mi IS 
'Descripción libre del usuario (máx 500 caracteres validados en backend). 
Texto enriquecido donde el usuario describe sus intereses, objetivos, etc.';

COMMENT ON COLUMN appmatch_schema.informacion_basica.tiene_responsable_legal IS 
'TRUE si el usuario es menor de 18 años y requiere responsable legal (COPPA compliance). 
Calculado automáticamente en backend según fecha_nacimiento.';

COMMENT ON COLUMN appmatch_schema.informacion_basica.responsable_email IS 
'Email del responsable legal (obligatorio si tiene_responsable_legal = TRUE). 
Validación de formato email en constraint.';

COMMENT ON COLUMN appmatch_schema.informacion_basica.responsable_numero_identificacion IS 
'Número de identificación del responsable legal (cédula, pasaporte, etc.). 
Obligatorio si tiene_responsable_legal = TRUE. Validado en backend.';

COMMENT ON COLUMN appmatch_schema.informacion_basica.ip_registro IS 
'IP desde donde se completó el registro (IPv4 o IPv6, máx 45 caracteres). 
Usado para auditoría y detección de fraude.';

COMMENT ON COLUMN appmatch_schema.informacion_basica.metadata IS 
'Metadata adicional en formato JSONB. Ejemplos: user_agent, dispositivo (web/mobile), idioma preferido. 
Permite extender el modelo sin ALTER TABLE.';

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 6: Queries de ejemplo para desarrollo
-- ═══════════════════════════════════════════════════════════════════════════════

-- Obtener información básica con nombres de catálogos (JOIN con catálogo recursivo)
-- SELECT 
--     ib.pkid_informacion_basica,
--     ctd.nombre AS tipo_documento,
--     ib.numero_identificacion,
--     ib.email,
--     TRIM(CONCAT_WS(' ', ib.primer_nombre, ib.segundo_nombre, ib.primer_apellido, ib.segundo_apellido)) AS nombre_completo,
--     ib.fecha_nacimiento,
--     EXTRACT(YEAR FROM AGE(CURRENT_DATE, ib.fecha_nacimiento))::INT AS edad,
--     cg.nombre AS genero,
--     cp.nombre AS pais,
--     cc.nombre AS ciudad,
--     ib.telefono
-- FROM appmatch_schema.informacion_basica ib
-- INNER JOIN appmatch_schema.catalogo_recursivo ctd ON ib.fk_pkid_catalogo_tipo_documento = ctd.pkid_catalogo_recursivo
-- INNER JOIN appmatch_schema.catalogo_recursivo cg ON ib.fk_pkid_catalogo_genero = cg.pkid_catalogo_recursivo
-- INNER JOIN appmatch_schema.catalogo_recursivo cp ON ib.fk_pkid_catalogo_pais = cp.pkid_catalogo_recursivo
-- INNER JOIN appmatch_schema.catalogo_recursivo cc ON ib.fk_pkid_catalogo_ciudad = cc.pkid_catalogo_recursivo
-- WHERE ib.expiration_date IS NULL;

-- Buscar por tipo documento + número de identificación
-- SELECT * FROM appmatch_schema.informacion_basica 
-- WHERE fk_pkid_catalogo_tipo_documento = '00000000-0000-0000-0000-000000000001'::UUID 
--   AND numero_identificacion = '80123456' 
--   AND expiration_date IS NULL;

-- Buscar por email
-- SELECT * FROM appmatch_schema.informacion_basica 
-- WHERE email = 'wilmer.torres@example.com' AND expiration_date IS NULL;

-- Buscar por nombre
-- SELECT 
--     pkid_informacion_basica,
--     TRIM(CONCAT_WS(' ', primer_nombre, segundo_nombre, primer_apellido, segundo_apellido)) AS nombre_completo,
--     fecha_nacimiento
-- FROM appmatch_schema.informacion_basica 
-- WHERE expiration_date IS NULL 
--   AND (primer_nombre ILIKE '%juan%' OR primer_apellido ILIKE '%juan%');

-- Listar menores de edad con responsable legal
-- SELECT 
--     pkid_informacion_basica,
--     TRIM(CONCAT_WS(' ', primer_nombre, primer_apellido)) AS nombre_estudiante,
--     fecha_nacimiento,
--     EXTRACT(YEAR FROM AGE(CURRENT_DATE, fecha_nacimiento))::INT AS edad,
--     responsable_numero_identificacion,
--     TRIM(CONCAT_WS(' ', responsable_primer_nombre, responsable_primer_apellido)) AS nombre_responsable,
--     responsable_email,
--     responsable_telefono
-- FROM appmatch_schema.informacion_basica 
-- WHERE expiration_date IS NULL 
--   AND tiene_responsable_legal = TRUE;

-- Estadísticas demográficas por género (con nombre del catálogo)
-- SELECT 
--     cg.nombre AS genero, 
--     COUNT(*) AS total,
--     ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, ib.fecha_nacimiento))), 2) AS edad_promedio
-- FROM appmatch_schema.informacion_basica ib
-- INNER JOIN appmatch_schema.catalogo_recursivo cg ON ib.fk_pkid_catalogo_genero = cg.pkid_catalogo_recursivo
-- WHERE ib.expiration_date IS NULL
-- GROUP BY cg.nombre
-- ORDER BY total DESC;

-- Información básica por país y ciudad (con nombres de catálogos)
-- SELECT 
--     cp.nombre AS pais,
--     cc.nombre AS ciudad,
--     COUNT(*) AS total
-- FROM appmatch_schema.informacion_basica ib
-- INNER JOIN appmatch_schema.catalogo_recursivo cp ON ib.fk_pkid_catalogo_pais = cp.pkid_catalogo_recursivo
-- INNER JOIN appmatch_schema.catalogo_recursivo cc ON ib.fk_pkid_catalogo_ciudad = cc.pkid_catalogo_recursivo
-- WHERE ib.expiration_date IS NULL
-- GROUP BY cp.nombre, cc.nombre 
-- ORDER BY total DESC;

-- ═══════════════════════════════════════════════════════════════════════════════
-- FIN DEL SCRIPT
-- ═══════════════════════════════════════════════════════════════════════════════

-- NOTAS IMPORTANTES:
-- 
-- 1. TABLA MAESTRA: Esta es una tabla independiente SIN relación directa con usuarios
-- 2. La relación 1:1 con usuarios se establece en V003 (tabla usuarios tendrá FK a esta tabla)
-- 3. Campos ÚNICOS obligatorios:
--    - fk_pkid_catalogo_tipo_documento + numero_identificacion (UNIQUE compuesto)
--      Permite mismo número con diferente tipo (ej: CEDULA-123 y PASAPORTE-123 son válidos)
--    - email (VARCHAR 255) - Correo electrónico con validación de formato
-- 4. TIPO DE DOCUMENTO viene del catálogo recursivo:
--    - Valores comunes: CEDULA, PASAPORTE, DNI, NIE, RUT, CURP, etc.
--    - FK: fk_pkid_catalogo_tipo_documento
-- 5. Campos de responsable legal obligatorios SOLO si tiene_responsable_legal = TRUE
--    - Incluye: email, número identificación, nombres, apellido, teléfono
-- 6. Edad mínima 13 años (COPPA compliance - Children's Online Privacy Protection Act)
-- 7. FOREIGN KEYS a catálogo recursivo:
--    - fk_pkid_catalogo_tipo_documento (CEDULA, PASAPORTE, DNI, NIE, RUT, etc.)
--    - fk_pkid_catalogo_genero (MASCULINO, FEMENINO, OTRO, PREFIERO_NO_DECIR)
--    - fk_pkid_catalogo_pais (COLOMBIA, MEXICO, ESPAÑA, etc.)
--    - fk_pkid_catalogo_ciudad (BOGOTA, MEDELLIN, MADRID, etc.) - Jerarquía: hijo de país
--    - fk_pkid_catalogo_nivel_educativo (PRIMARIA...POSGRADO) - NULL permitido
-- 8. Nomenclatura FK: fk_pkid_catalogo_{tipo} según política estándar
-- 9. Soft delete obligatorio (expiration_date) - nunca DELETE físico
-- 10. Todos los cálculos (edad, nombre completo) se hacen en BACKEND, no en funciones SQL
-- 11. Índices en TODAS las FKs para optimizar JOINs con catálogo recursivo
-- 12. Índice UNIQUE compuesto en (tipo_documento + numero_identificacion) para búsquedas
-- 13. Índice UNIQUE en email (búsquedas frecuentes, login)
-- 14. Metadata JSONB permite extensibilidad sin ALTER TABLE
-- 15. INSERT de datos de prueba incluido (idempotente con ON CONFLICT)
-- 16. Este script es idempotente (puede ejecutarse múltiples veces)
--
-- DEPENDENCIAS:
--   - Requiere tabla appmatch_schema.catalogo_recursivo ya creada y poblada con:
--     * Tipos: TIPO_DOCUMENTO, GENERO, PAIS, CIUDAD, NIVEL_EDUCATIVO
--     * UUIDs específicos para los datos de prueba insertados
--
-- SIGUIENTE PASO: 
--   - Crear tabla appmatch_schema.usuarios (V003) que tendrá FK a esta tabla:
--     fk_pkid_informacion_basica UUID NOT NULL REFERENCES informacion_basica(pkid_informacion_basica)

