-- ==============================================================================
-- SCRIPT DE CONFIGURACIÓN DE BASE DE DATOS MITOGA PARA DBEAVER
-- ==============================================================================
-- Autor: Backend Senior Developer - ZNS-METHOD
-- Fecha: 15 de noviembre de 2025
-- Propósito: Ejecutar migraciones de BD en orden correcto para resolver startup
-- Base de Datos: PostgreSQL 16.x
-- Host: 192.168.18.126:5432
-- Database: mitogadb
-- ==============================================================================

-- INSTRUCCIONES PARA DBEAVER:
-- 1. Abrir conexión a: 192.168.18.126:5432/mitogadb (usuario: admin, password: Shacall1989*)
-- 2. Ejecutar cada sección por separado en orden (Ctrl+Enter por bloque)
-- 3. Verificar que cada paso se ejecute sin errores antes de continuar
-- ==============================================================================

-- ==============================================================================
-- PASO 1: VERIFICAR CONEXIÓN Y LIMPIAR (OPCIONAL)
-- ==============================================================================

-- Verificar conexión
SELECT 
    current_database() as database_name,
    current_user as connected_user,
    version() as pg_version,
    now() as connection_time;

-- OPCIONAL: Limpiar schemas si necesitas empezar desde cero
-- DESCOMENTA SOLO SI QUIERES RESETEAR TODO
/*
DROP SCHEMA IF EXISTS appmatch_schema CASCADE;
DROP SCHEMA IF EXISTS appmatch_schema CASCADE;
DROP SCHEMA IF EXISTS appmatch_schema CASCADE;
DROP SCHEMA IF EXISTS appmatch_schema CASCADE;
DROP SCHEMA IF EXISTS appmatch_schema CASCADE;
DROP SCHEMA IF EXISTS appmatch_schema CASCADE;
DROP SCHEMA IF EXISTS appmatch_schema CASCADE;
DROP SCHEMA IF EXISTS appmatch_schema CASCADE;
DROP SCHEMA IF EXISTS appmatch_schema CASCADE;
DROP SCHEMA IF EXISTS appmatch_schema CASCADE;
*/

-- ==============================================================================
-- PASO 2: V1 - SCHEMAS INICIALES Y TABLAS BASE
-- ==============================================================================

-- EJECUTAR CONTENIDO DE: V1__init_schema.sql
-- (Copiar y pegar el contenido completo del archivo V1__init_schema.sql aquí)

-- Extensions requeridas
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "unaccent";

-- Schemas principales
CREATE SCHEMA IF NOT EXISTS appmatch_schema;
CREATE SCHEMA IF NOT EXISTS appmatch_schema;
CREATE SCHEMA IF NOT EXISTS appmatch_schema;
CREATE SCHEMA IF NOT EXISTS appmatch_schema;
CREATE SCHEMA IF NOT EXISTS appmatch_schema;
CREATE SCHEMA IF NOT EXISTS appmatch_schema;
CREATE SCHEMA IF NOT EXISTS appmatch_schema;
CREATE SCHEMA IF NOT EXISTS appmatch_schema;
CREATE SCHEMA IF NOT EXISTS appmatch_schema;

-- Verificar que se crearon correctamente
SELECT schema_name FROM information_schema.schemata 
WHERE schema_name IN ('appmatch_schema', 'appmatch_schema', 'appmatch_schema')
ORDER BY schema_name;

-- ==============================================================================
-- PASO 3: TABLAS SHARED KERNEL BÁSICAS
-- ==============================================================================

-- Tabla países
CREATE TABLE IF NOT EXISTS appmatch_schema.paises (
    pkid_paises UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    codigo CHAR(2) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    nombre_oficial VARCHAR(255),
    codigo_alpha3 CHAR(3) UNIQUE,
    codigo_numerico CHAR(3),
    region VARCHAR(50),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_paises PRIMARY KEY (pkid_paises),
    CONSTRAINT uq_paises_codigo UNIQUE (codigo)
);

-- Tabla monedas
CREATE TABLE IF NOT EXISTS appmatch_schema.monedas (
    pkid_monedas UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    codigo CHAR(3) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    simbolo VARCHAR(10),
    decimales SMALLINT NOT NULL DEFAULT 2,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_monedas PRIMARY KEY (pkid_monedas),
    CONSTRAINT uq_monedas_codigo UNIQUE (codigo),
    CONSTRAINT ck_monedas_decimales CHECK (decimales >= 0 AND decimales <= 4)
);

-- Verificar tablas creadas
SELECT schemaname, tablename 
FROM pg_tables 
WHERE schemaname = 'appmatch_schema'
ORDER BY tablename;

-- ==============================================================================
-- PASO 4: TIPOS ENUM PARA REGISTRO ESTUDIANTES (CRÍTICO)
-- ==============================================================================

-- Estados del proceso de registro
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'estado_registro' 
                   AND typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'appmatch_schema')) THEN
        CREATE TYPE appmatch_schema.estado_registro AS ENUM (
            'STEP_1_CREDENCIALES',
            'STEP_2_DATOS_PERSONALES', 
            'STEP_3_VERIFICACION_BIOMETRICA',
            'STEP_4_CONFIRMACION',
            'COMPLETADO',
            'ABANDONADO',
            'RECHAZADO'
        );
    END IF;
END $$;

-- Tipos de documento
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'tipo_documento' 
                   AND typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'appmatch_schema')) THEN
        CREATE TYPE appmatch_schema.tipo_documento AS ENUM (
            'CEDULA',
            'TARJETA_IDENTIDAD',
            'PASAPORTE',
            'REGISTRO_CIVIL'
        );
    END IF;
END $$;

-- Verificar tipos creados
SELECT typname, nspname 
FROM pg_type t JOIN pg_namespace n ON t.typnamespace = n.oid 
WHERE nspname = 'appmatch_schema' AND typtype = 'e';

-- ==============================================================================
-- PASO 5: TABLA CRÍTICA - PROCESO DE REGISTRO (AUTENTICACIÓN SCHEMA)
-- ==============================================================================

-- ESTA ES LA TABLA QUE NECESITA SPRING BOOT PARA INICIAR
CREATE TABLE IF NOT EXISTS appmatch_schema.proceso_registro (
    -- Campos obligatorios estándar
    pkid_proceso_registro UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- Relaciones
    usuario_id UUID, -- NULL hasta completar registro
    
    -- Estado del proceso
    estado_actual appmatch_schema.estado_registro NOT NULL DEFAULT 'STEP_1_CREDENCIALES',
    step_completado INTEGER NOT NULL DEFAULT 0,
    
    -- Datos temporales (JSON por flexibilidad)
    datos_step_1 JSONB, -- email, password_hash, otp_code, otp_expiry
    datos_step_2 JSONB, -- información personal + responsable si menor
    datos_step_3 JSONB, -- referencias a archivos subidos
    datos_step_4 JSONB, -- confirmación y términos
    
    -- Metadata de sesión
    ip_address INET,
    user_agent TEXT,
    session_id VARCHAR(255),
    fecha_inicio TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    fecha_ultimo_paso TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    fecha_expiracion TIMESTAMPTZ NOT NULL DEFAULT (NOW() + INTERVAL '7 days'),
    
    -- Flags de control
    es_menor_edad BOOLEAN NOT NULL DEFAULT FALSE,
    requiere_responsable BOOLEAN NOT NULL DEFAULT FALSE,
    otp_verificado BOOLEAN NOT NULL DEFAULT FALSE,
    terminos_aceptados BOOLEAN NOT NULL DEFAULT FALSE,
    
    -- Constraints
    CONSTRAINT pk_proceso_registro PRIMARY KEY (pkid_proceso_registro),
    CONSTRAINT ck_proceso_registro_step CHECK (step_completado >= 0 AND step_completado <= 4),
    CONSTRAINT ck_proceso_registro_menor_responsable CHECK (
        NOT es_menor_edad OR (es_menor_edad AND requiere_responsable)
    )
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_proceso_registro_estado ON appmatch_schema.proceso_registro(estado_actual);
CREATE INDEX IF NOT EXISTS idx_proceso_registro_session ON appmatch_schema.proceso_registro(session_id);

-- ==============================================================================
-- PASO 6: TABLAS COMPLEMENTARIAS PARA ARCHIVOS
-- ==============================================================================

-- Tipos de archivo
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'tipo_archivo' 
                   AND typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'appmatch_schema')) THEN
        CREATE TYPE appmatch_schema.tipo_archivo AS ENUM (
            'DOCUMENTO_FRONTAL',
            'DOCUMENTO_TRASERO', 
            'SELFIE_VERIFICACION',
            'FOTO_PERFIL',
            'CERTIFICADO_ESTUDIO'
        );
    END IF;
END $$;

-- Tabla archivos
CREATE TABLE IF NOT EXISTS appmatch_schema.archivos (
    pkid_archivos UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    nombre_original VARCHAR(255) NOT NULL,
    nombre_archivo VARCHAR(255) NOT NULL,
    ruta_storage VARCHAR(500) NOT NULL,
    tipo_archivo appmatch_schema.tipo_archivo NOT NULL,
    tamaño_bytes BIGINT NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    hash_sha256 VARCHAR(64),
    
    -- Metadata
    descripcion TEXT,
    es_temporal BOOLEAN DEFAULT FALSE,
    fecha_expiracion_temporal TIMESTAMPTZ,
    
    CONSTRAINT pk_archivos PRIMARY KEY (pkid_archivos)
);

-- ==============================================================================
-- PASO 7: VERIFICACIÓN FINAL
-- ==============================================================================

-- Verificar que la tabla crítica existe
SELECT 
    schemaname, 
    tablename,
    tableowner
FROM pg_tables 
WHERE schemaname = 'appmatch_schema' 
AND tablename = 'proceso_registro';

-- Verificar estructura de la tabla crítica
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_schema = 'appmatch_schema' 
AND table_name = 'proceso_registro'
ORDER BY ordinal_position;

-- Verificar tipos ENUM creados
SELECT 
    t.typname as enum_name,
    n.nspname as schema_name,
    string_agg(e.enumlabel, ', ' ORDER BY e.enumsortorder) as enum_values
FROM pg_type t 
JOIN pg_namespace n ON t.typnamespace = n.oid
LEFT JOIN pg_enum e ON t.oid = e.enumtypid
WHERE n.nspname = 'appmatch_schema' 
AND t.typtype = 'e'
GROUP BY t.typname, n.nspname
ORDER BY t.typname;

-- Insertar un registro de prueba para verificar que todo funciona
INSERT INTO appmatch_schema.proceso_registro 
(estado_actual, step_completado, datos_step_1, session_id)
VALUES 
('STEP_1_CREDENCIALES', 0, '{"email": "test@example.com"}', 'test-session-123');

-- Verificar que se insertó correctamente
SELECT 
    pkid_proceso_registro,
    estado_actual,
    step_completado,
    creation_date,
    session_id
FROM appmatch_schema.proceso_registro 
WHERE session_id = 'test-session-123';

-- Limpiar registro de prueba
DELETE FROM appmatch_schema.proceso_registro WHERE session_id = 'test-session-123';

-- ==============================================================================
-- RESULTADO ESPERADO
-- ==============================================================================

-- Si todo está correcto, deberías ver:
-- ✅ Schemas creados: appmatch_schema, appmatch_schema, etc.
-- ✅ Tipos ENUM creados: estado_registro, tipo_documento, tipo_archivo
-- ✅ Tabla crítica: appmatch_schema.proceso_registro
-- ✅ Inserción y eliminación de prueba exitosa

-- AHORA SPRING BOOT DEBERÍA INICIAR SIN ERRORES DE HIBERNATE

SELECT 'CONFIGURACIÓN COMPLETADA EXITOSAMENTE' as resultado;