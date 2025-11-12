-- ============================================================================
-- Migration: V1__init_schema.sql
-- Description: Inicialización de base de datos mitogadb con schemas por Bounded Context
--              Setup inicial para HUT-000-INFRA-01 con arquitectura DDD + Hexagonal
--              Convención: TODA tabla inicia con pkid_{tabla}, creation_date, expiration_date
-- Author: Database Engineering Team - MI-TOGA
-- Date: 2025-11-08
-- Bounded Context: Shared Kernel + 8 Bounded Contexts
-- Story: HUT-000-INFRA-01-setup-proyecto-backend
-- PostgreSQL Version: 16.x
-- Prompt: prompt-ingeniero-base-datos-senior.md v2.0
-- ============================================================================

-- ====================
-- EXTENSIONS (Requeridas)
-- ====================

-- UUID generation (PostgreSQL 13+ tiene gen_random_uuid() nativo, pero por compatibilidad)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Funciones criptográficas (para encriptación de datos sensibles)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Full-text search en español (para búsquedas de tutores)
CREATE EXTENSION IF NOT EXISTS "unaccent";

COMMENT ON EXTENSION "uuid-ossp" IS 'Generación de UUIDs v4 para primary keys';
COMMENT ON EXTENSION "pgcrypto" IS 'Funciones criptográficas para encriptación de datos sensibles';
COMMENT ON EXTENSION "unaccent" IS 'Eliminación de acentos para búsquedas full-text';

-- ====================
-- SCHEMAS (Bounded Contexts)
-- ====================

-- Shared Kernel (Compartido entre todos los BCs)
CREATE SCHEMA IF NOT EXISTS shared_schema;
COMMENT ON SCHEMA shared_schema IS 'Shared Kernel: Building blocks DDD, tablas de referencia, audit log, domain events';

-- Bounded Context 1: Autenticación
CREATE SCHEMA IF NOT EXISTS autenticacion_schema;
COMMENT ON SCHEMA autenticacion_schema IS 'BC Autenticación: Gestión de usuarios, roles, sesiones, autenticación JWT';

-- Bounded Context 2: Marketplace
CREATE SCHEMA IF NOT EXISTS marketplace_schema;
COMMENT ON SCHEMA marketplace_schema IS 'BC Marketplace: Tutores, categorías, especialidades, búsqueda, valoraciones';

-- Bounded Context 3: Perfiles
CREATE SCHEMA IF NOT EXISTS perfiles_schema;
COMMENT ON SCHEMA perfiles_schema IS 'BC Perfiles: Perfiles de estudiantes y tutores, preferencias, curriculum';

-- Bounded Context 4: Reservas
CREATE SCHEMA IF NOT EXISTS reservas_schema;
COMMENT ON SCHEMA reservas_schema IS 'BC Reservas: Disponibilidad, reservas de sesiones, confirmaciones, cancelaciones';

-- Bounded Context 5: Pagos
CREATE SCHEMA IF NOT EXISTS pagos_schema;
COMMENT ON SCHEMA pagos_schema IS 'BC Pagos: Transacciones, métodos de pago, reembolsos, integración Stripe';

-- Bounded Context 6: Videollamadas
CREATE SCHEMA IF NOT EXISTS videollamadas_schema;
COMMENT ON SCHEMA videollamadas_schema IS 'BC Videollamadas: Sesiones en vivo, integración Agora, salas virtuales';

-- Bounded Context 7: Notificaciones
CREATE SCHEMA IF NOT EXISTS notificaciones_schema;
COMMENT ON SCHEMA notificaciones_schema IS 'BC Notificaciones: Email, SMS, push notifications, templates';

-- Bounded Context 8: Admin
CREATE SCHEMA IF NOT EXISTS admin_schema;
COMMENT ON SCHEMA admin_schema IS 'BC Admin: Panel administrativo, reportes, configuraciones del sistema';

-- ====================
-- SHARED KERNEL: TABLAS DE REFERENCIA
-- ====================

-- Tabla: Países (ISO 3166-1 alpha-2)
CREATE TABLE shared_schema.paises (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ========================================
    pkid_paises UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- CAMPOS DE NEGOCIO
    -- ========================================
    codigo CHAR(2) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    nombre_oficial VARCHAR(255),
    codigo_alpha3 CHAR(3) UNIQUE,
    codigo_numerico CHAR(3),
    region VARCHAR(50),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_paises PRIMARY KEY (pkid_paises),
    CONSTRAINT uq_paises_codigo UNIQUE (codigo)
);

CREATE INDEX idx_paises_codigo ON shared_schema.paises(codigo) WHERE expiration_date IS NULL;
CREATE INDEX idx_paises_nombre ON shared_schema.paises(nombre);
CREATE INDEX idx_paises_region ON shared_schema.paises(region) WHERE activo = TRUE AND expiration_date IS NULL;

COMMENT ON TABLE shared_schema.paises IS 'Referencia: Catálogo de países (ISO 3166-1)';
COMMENT ON COLUMN shared_schema.paises.pkid_paises IS 'Primary Key UUID de la tabla paises';
COMMENT ON COLUMN shared_schema.paises.creation_date IS 'Fecha y hora de creación del registro (inmutable)';
COMMENT ON COLUMN shared_schema.paises.expiration_date IS 'Soft delete: NULL = activo, NOT NULL = fecha de eliminación lógica';
COMMENT ON COLUMN shared_schema.paises.codigo IS 'Código ISO 3166-1 alpha-2 (ej: CO, MX, ES)';

-- Tabla: Monedas (ISO 4217)
CREATE TABLE shared_schema.monedas (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ========================================
    pkid_monedas UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- CAMPOS DE NEGOCIO
    -- ========================================
    codigo CHAR(3) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    simbolo VARCHAR(10),
    decimales SMALLINT NOT NULL DEFAULT 2,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_monedas PRIMARY KEY (pkid_monedas),
    CONSTRAINT uq_monedas_codigo UNIQUE (codigo),
    CONSTRAINT ck_monedas_decimales CHECK (decimales >= 0 AND decimales <= 4)
);

CREATE INDEX idx_monedas_codigo ON shared_schema.monedas(codigo) WHERE expiration_date IS NULL;

COMMENT ON TABLE shared_schema.monedas IS 'Referencia: Catálogo de monedas (ISO 4217)';
COMMENT ON COLUMN shared_schema.monedas.pkid_monedas IS 'Primary Key UUID de la tabla monedas';
COMMENT ON COLUMN shared_schema.monedas.creation_date IS 'Fecha y hora de creación del registro (inmutable)';
COMMENT ON COLUMN shared_schema.monedas.expiration_date IS 'Soft delete: NULL = activo, NOT NULL = fecha de eliminación lógica';
COMMENT ON COLUMN shared_schema.monedas.codigo IS 'Código ISO 4217 (ej: USD, COP, EUR)';

-- Tabla: Idiomas (ISO 639-1)
CREATE TABLE shared_schema.idiomas (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ========================================
    pkid_idiomas UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- CAMPOS DE NEGOCIO
    -- ========================================
    codigo CHAR(2) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    nombre_nativo VARCHAR(100),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_idiomas PRIMARY KEY (pkid_idiomas),
    CONSTRAINT uq_idiomas_codigo UNIQUE (codigo)
);

CREATE INDEX idx_idiomas_codigo ON shared_schema.idiomas(codigo) WHERE expiration_date IS NULL;

COMMENT ON TABLE shared_schema.idiomas IS 'Referencia: Catálogo de idiomas (ISO 639-1)';
COMMENT ON COLUMN shared_schema.idiomas.pkid_idiomas IS 'Primary Key UUID de la tabla idiomas';
COMMENT ON COLUMN shared_schema.idiomas.creation_date IS 'Fecha y hora de creación del registro (inmutable)';
COMMENT ON COLUMN shared_schema.idiomas.expiration_date IS 'Soft delete: NULL = activo, NOT NULL = fecha de eliminación lógica';
COMMENT ON COLUMN shared_schema.idiomas.codigo IS 'Código ISO 639-1 (ej: es, en, fr)';

-- ====================
-- SHARED KERNEL: DOMAIN EVENTS (Event Store)
-- ====================

CREATE TABLE shared_schema.domain_events (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ========================================
    pkid_domain_events UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- CAMPOS DE NEGOCIO
    -- ========================================
    aggregate_type VARCHAR(100) NOT NULL,
    aggregate_id UUID NOT NULL,
    event_type VARCHAR(255) NOT NULL,
    event_data JSONB NOT NULL,
    occurred_on TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    processed BOOLEAN NOT NULL DEFAULT FALSE,
    processed_at TIMESTAMPTZ,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_domain_events PRIMARY KEY (pkid_domain_events)
);

CREATE INDEX idx_domain_events_aggregate ON shared_schema.domain_events(aggregate_type, aggregate_id);
CREATE INDEX idx_domain_events_type ON shared_schema.domain_events(event_type);
CREATE INDEX idx_domain_events_occurred_on ON shared_schema.domain_events(occurred_on DESC);
CREATE INDEX idx_domain_events_processed ON shared_schema.domain_events(processed) WHERE NOT processed;

COMMENT ON TABLE shared_schema.domain_events IS 'Event Store: Almacena Domain Events para Event Sourcing parcial, integración asíncrona entre BCs y auditoría';
COMMENT ON COLUMN shared_schema.domain_events.pkid_domain_events IS 'Primary Key UUID de la tabla domain_events';
COMMENT ON COLUMN shared_schema.domain_events.creation_date IS 'Fecha y hora de creación del registro (inmutable)';
COMMENT ON COLUMN shared_schema.domain_events.expiration_date IS 'Soft delete: NULL = activo, NOT NULL = fecha de eliminación lógica';
COMMENT ON COLUMN shared_schema.domain_events.aggregate_type IS 'Tipo de Aggregate Root (ej: Usuario, Reserva, Pago)';
COMMENT ON COLUMN shared_schema.domain_events.event_type IS 'Tipo de evento (ej: UsuarioRegistrado, ReservaConfirmada, PagoAprobado)';
COMMENT ON COLUMN shared_schema.domain_events.event_data IS 'Payload del evento en formato JSONB (flexible para evolución)';

-- ====================
-- SHARED KERNEL: AUDIT LOG (Trazabilidad completa)
-- ====================

CREATE TABLE shared_schema.audit_log (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ========================================
    pkid_audit_log BIGSERIAL NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- CAMPOS DE NEGOCIO
    -- ========================================
    schema_name VARCHAR(100) NOT NULL,
    table_name VARCHAR(100) NOT NULL,
    operation VARCHAR(10) NOT NULL,
    record_id UUID NOT NULL,
    old_data JSONB,
    new_data JSONB,
    changed_by UUID,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ip_address INET,
    user_agent TEXT,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_audit_log PRIMARY KEY (pkid_audit_log),
    CONSTRAINT ck_audit_log_operation CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE'))
);

CREATE INDEX idx_audit_log_table ON shared_schema.audit_log(schema_name, table_name);
CREATE INDEX idx_audit_log_record ON shared_schema.audit_log(record_id);
CREATE INDEX idx_audit_log_changed_at ON shared_schema.audit_log(changed_at DESC);
CREATE INDEX idx_audit_log_changed_by ON shared_schema.audit_log(changed_by) WHERE changed_by IS NOT NULL;

COMMENT ON TABLE shared_schema.audit_log IS 'Audit Trail: Registro completo de cambios (INSERT/UPDATE/DELETE) para compliance y trazabilidad';
COMMENT ON COLUMN shared_schema.audit_log.pkid_audit_log IS 'Primary Key BIGSERIAL de la tabla audit_log';
COMMENT ON COLUMN shared_schema.audit_log.creation_date IS 'Fecha y hora de creación del registro (inmutable)';
COMMENT ON COLUMN shared_schema.audit_log.expiration_date IS 'Soft delete: NULL = activo, NOT NULL = fecha de eliminación lógica';
COMMENT ON COLUMN shared_schema.audit_log.old_data IS 'Estado anterior del registro (solo UPDATE/DELETE)';
COMMENT ON COLUMN shared_schema.audit_log.new_data IS 'Estado nuevo del registro (INSERT/UPDATE)';

-- ====================
-- SHARED KERNEL: FUNCTIONS (Reutilizables)
-- ====================

-- Function: Audit Trigger (reutilizable para todas las tablas)
CREATE OR REPLACE FUNCTION shared_schema.audit_trigger_func()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO shared_schema.audit_log(schema_name, table_name, operation, record_id, old_data)
        VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, TG_OP, OLD.pkid_usuarios, row_to_json(OLD)::jsonb);
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO shared_schema.audit_log(schema_name, table_name, operation, record_id, old_data, new_data)
        VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, TG_OP, NEW.pkid_usuarios, row_to_json(OLD)::jsonb, row_to_json(NEW)::jsonb);
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO shared_schema.audit_log(schema_name, table_name, operation, record_id, new_data)
        VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, TG_OP, NEW.pkid_usuarios, row_to_json(NEW)::jsonb);
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION shared_schema.audit_trigger_func() IS 'Trigger function: Registra todos los cambios (INSERT/UPDATE/DELETE) en audit_log';

-- Function: Incrementar version (Optimistic Locking)
CREATE OR REPLACE FUNCTION shared_schema.increment_version()
RETURNS TRIGGER AS $$
BEGIN
    NEW.version = OLD.version + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION shared_schema.increment_version() IS 'Trigger function: Incrementa columna version en UPDATE para control de concurrencia optimista';

-- ====================
-- BC AUTENTICACIÓN: TABLAS
-- ====================

-- Aggregate Root: Usuario
CREATE TABLE autenticacion_schema.usuarios (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ========================================
    pkid_usuarios UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- VALUE OBJECTS (Embebidos)
    -- ========================================
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    
    -- ========================================
    -- ATRIBUTOS BÁSICOS
    -- ========================================
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    
    -- ========================================
    -- ESTADO Y ROL
    -- ========================================
    rol VARCHAR(50) NOT NULL DEFAULT 'ESTUDIANTE',
    estado VARCHAR(50) NOT NULL DEFAULT 'ACTIVO',
    
    -- ========================================
    -- METADATA TEMPORAL
    -- ========================================
    fecha_registro TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ultimo_acceso TIMESTAMPTZ,
    fecha_verificacion_email TIMESTAMPTZ,
    
    -- ========================================
    -- OPTIMISTIC LOCKING
    -- ========================================
    version INT NOT NULL DEFAULT 1,
    
    -- ========================================
    -- CONSTRAINTS (Business Rules)
    -- ========================================
    CONSTRAINT pk_usuarios PRIMARY KEY (pkid_usuarios),
    CONSTRAINT uq_usuarios_email UNIQUE (email),
    CONSTRAINT ck_usuarios_email_formato CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'),
    CONSTRAINT ck_usuarios_rol CHECK (rol IN ('ESTUDIANTE', 'TUTOR', 'ADMIN')),
    CONSTRAINT ck_usuarios_estado CHECK (estado IN ('ACTIVO', 'SUSPENDIDO', 'INACTIVO', 'PENDIENTE_VERIFICACION'))
);

-- Indexes (Performance)
CREATE INDEX idx_usuarios_email ON autenticacion_schema.usuarios(email) WHERE expiration_date IS NULL;
CREATE INDEX idx_usuarios_rol ON autenticacion_schema.usuarios(rol) WHERE expiration_date IS NULL;
CREATE INDEX idx_usuarios_estado ON autenticacion_schema.usuarios(estado);
CREATE INDEX idx_usuarios_fecha_registro ON autenticacion_schema.usuarios(fecha_registro DESC);

-- Triggers
CREATE TRIGGER trg_usuarios_increment_version
    BEFORE UPDATE ON autenticacion_schema.usuarios
    FOR EACH ROW
    EXECUTE FUNCTION shared_schema.increment_version();

CREATE TRIGGER trg_usuarios_audit
    AFTER INSERT OR UPDATE OR DELETE ON autenticacion_schema.usuarios
    FOR EACH ROW
    EXECUTE FUNCTION shared_schema.audit_trigger_func();

-- Comments (Documentation)
COMMENT ON TABLE autenticacion_schema.usuarios IS 'Aggregate Root: Usuario del sistema (Estudiante, Tutor o Admin). Core del BC Autenticación.';
COMMENT ON COLUMN autenticacion_schema.usuarios.pkid_usuarios IS 'Primary Key UUID de la tabla usuarios';
COMMENT ON COLUMN autenticacion_schema.usuarios.creation_date IS 'Fecha y hora de creación del registro (inmutable)';
COMMENT ON COLUMN autenticacion_schema.usuarios.expiration_date IS 'Soft delete: NULL = activo, NOT NULL = fecha de eliminación lógica';
COMMENT ON COLUMN autenticacion_schema.usuarios.email IS 'Value Object: Email único, usado para login (validado con regex)';
COMMENT ON COLUMN autenticacion_schema.usuarios.password_hash IS 'Password hasheado con BCrypt (cost factor 12, OWASP compliant)';
COMMENT ON COLUMN autenticacion_schema.usuarios.rol IS 'Rol del usuario: ESTUDIANTE (default), TUTOR, ADMIN';
COMMENT ON COLUMN autenticacion_schema.usuarios.estado IS 'Estado: ACTIVO (puede usar sistema), SUSPENDIDO (bloqueado temporal), INACTIVO (bloqueado permanente), PENDIENTE_VERIFICACION (email no verificado)';
COMMENT ON COLUMN autenticacion_schema.usuarios.version IS 'Optimistic locking: incrementa en cada UPDATE para detectar conflictos (JPA lo usa en WHERE)';

-- Tabla: Sesiones Inválidas (Tokens JWT invalidados - Blacklist)
CREATE TABLE autenticacion_schema.sesiones_invalidas (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ========================================
    pkid_sesiones_invalidas UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- CAMPOS DE NEGOCIO
    -- ========================================
    usuario_id UUID NOT NULL,
    token_jti VARCHAR(255) NOT NULL UNIQUE,
    fecha_expiracion TIMESTAMPTZ NOT NULL,
    razon VARCHAR(100),
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_sesiones_invalidas PRIMARY KEY (pkid_sesiones_invalidas),
    CONSTRAINT fk_sesiones_invalidas_usuarios FOREIGN KEY (usuario_id) 
        REFERENCES autenticacion_schema.usuarios(pkid_usuarios) ON DELETE CASCADE,
    CONSTRAINT uq_sesiones_invalidas_token UNIQUE (token_jti),
    CONSTRAINT ck_sesiones_razon CHECK (razon IN ('LOGOUT', 'PASSWORD_CHANGED', 'FORCED_LOGOUT', 'EXPIRED'))
);

CREATE INDEX idx_sesiones_invalidas_token ON autenticacion_schema.sesiones_invalidas(token_jti);
CREATE INDEX idx_sesiones_invalidas_expiracion ON autenticacion_schema.sesiones_invalidas(fecha_expiracion);
CREATE INDEX idx_sesiones_invalidas_usuario ON autenticacion_schema.sesiones_invalidas(usuario_id);

COMMENT ON TABLE autenticacion_schema.sesiones_invalidas IS 'Blacklist de tokens JWT invalidados (logout, cambio de password)';
COMMENT ON COLUMN autenticacion_schema.sesiones_invalidas.pkid_sesiones_invalidas IS 'Primary Key UUID de la tabla sesiones_invalidas';
COMMENT ON COLUMN autenticacion_schema.sesiones_invalidas.creation_date IS 'Fecha y hora de creación del registro (inmutable)';
COMMENT ON COLUMN autenticacion_schema.sesiones_invalidas.expiration_date IS 'Soft delete: NULL = activo, NOT NULL = fecha de eliminación lógica';
COMMENT ON COLUMN autenticacion_schema.sesiones_invalidas.token_jti IS 'JWT ID (claim jti) único del token invalidado';

-- Tabla: Tokens de Verificación (Email, Password Reset)
CREATE TABLE autenticacion_schema.tokens_verificacion (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ========================================
    pkid_tokens_verificacion UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- CAMPOS DE NEGOCIO
    -- ========================================
    usuario_id UUID NOT NULL,
    token VARCHAR(255) NOT NULL UNIQUE,
    tipo VARCHAR(50) NOT NULL,
    fecha_expiracion TIMESTAMPTZ NOT NULL,
    usado BOOLEAN NOT NULL DEFAULT FALSE,
    fecha_uso TIMESTAMPTZ,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_tokens_verificacion PRIMARY KEY (pkid_tokens_verificacion),
    CONSTRAINT fk_tokens_verificacion_usuarios FOREIGN KEY (usuario_id) 
        REFERENCES autenticacion_schema.usuarios(pkid_usuarios) ON DELETE CASCADE,
    CONSTRAINT uq_tokens_verificacion_token UNIQUE (token),
    CONSTRAINT ck_tokens_tipo CHECK (tipo IN ('EMAIL_VERIFICATION', 'PASSWORD_RESET', 'TWO_FACTOR'))
);

CREATE INDEX idx_tokens_verificacion_token ON autenticacion_schema.tokens_verificacion(token) WHERE NOT usado;
CREATE INDEX idx_tokens_verificacion_usuario ON autenticacion_schema.tokens_verificacion(usuario_id);
CREATE INDEX idx_tokens_verificacion_expiracion ON autenticacion_schema.tokens_verificacion(fecha_expiracion);

COMMENT ON TABLE autenticacion_schema.tokens_verificacion IS 'Tokens temporales para verificación de email, reset de password, 2FA';
COMMENT ON COLUMN autenticacion_schema.tokens_verificacion.pkid_tokens_verificacion IS 'Primary Key UUID de la tabla tokens_verificacion';
COMMENT ON COLUMN autenticacion_schema.tokens_verificacion.creation_date IS 'Fecha y hora de creación del registro (inmutable)';
COMMENT ON COLUMN autenticacion_schema.tokens_verificacion.expiration_date IS 'Soft delete: NULL = activo, NOT NULL = fecha de eliminación lógica';

-- ====================
-- BC MARKETPLACE: TABLAS
-- ====================

-- Tabla: Categorías (Taxonomy)
CREATE TABLE marketplace_schema.categorias (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ========================================
    pkid_categorias UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- CAMPOS DE NEGOCIO
    -- ========================================
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    slug VARCHAR(100) NOT NULL UNIQUE,
    icono VARCHAR(50),
    orden SMALLINT NOT NULL DEFAULT 0,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_categorias PRIMARY KEY (pkid_categorias),
    CONSTRAINT uq_categorias_nombre UNIQUE (nombre),
    CONSTRAINT uq_categorias_slug UNIQUE (slug)
);

CREATE INDEX idx_categorias_slug ON marketplace_schema.categorias(slug) WHERE expiration_date IS NULL;
CREATE INDEX idx_categorias_orden ON marketplace_schema.categorias(orden) WHERE activo = TRUE AND expiration_date IS NULL;

COMMENT ON TABLE marketplace_schema.categorias IS 'Categorías de tutorías (ej: Matemáticas, Idiomas, Programación)';
COMMENT ON COLUMN marketplace_schema.categorias.pkid_categorias IS 'Primary Key UUID de la tabla categorias';
COMMENT ON COLUMN marketplace_schema.categorias.creation_date IS 'Fecha y hora de creación del registro (inmutable)';
COMMENT ON COLUMN marketplace_schema.categorias.expiration_date IS 'Soft delete: NULL = activo, NOT NULL = fecha de eliminación lógica';
COMMENT ON COLUMN marketplace_schema.categorias.slug IS 'URL-friendly identifier (ej: matematicas, idiomas)';

-- Aggregate Root: Tutor
CREATE TABLE marketplace_schema.tutores (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ========================================
    pkid_tutores UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- FOREIGN KEYS
    -- ========================================
    usuario_id UUID NOT NULL UNIQUE,
    moneda_codigo CHAR(3) NOT NULL DEFAULT 'USD',
    
    -- ========================================
    -- ATRIBUTOS DE NEGOCIO
    -- ========================================
    biografia TEXT,
    experiencia_anos SMALLINT,
    titulo_profesional VARCHAR(255),
    precio_por_hora DECIMAL(10,2) NOT NULL,
    
    -- ========================================
    -- VALUE OBJECTS (JSONB para flexibilidad)
    -- ========================================
    certificaciones JSONB,
    idiomas JSONB,
    horario_disponibilidad JSONB,
    
    -- ========================================
    -- ESTADÍSTICAS (Denormalized para performance)
    -- ========================================
    total_sesiones INT NOT NULL DEFAULT 0,
    valoracion_promedio DECIMAL(3,2),
    total_valoraciones INT NOT NULL DEFAULT 0,
    
    -- ========================================
    -- ESTADO
    -- ========================================
    estado VARCHAR(50) NOT NULL DEFAULT 'PENDIENTE_APROBACION',
    fecha_aprobacion TIMESTAMPTZ,
    
    -- ========================================
    -- OPTIMISTIC LOCKING
    -- ========================================
    version INT NOT NULL DEFAULT 1,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_tutores PRIMARY KEY (pkid_tutores),
    CONSTRAINT fk_tutores_usuarios FOREIGN KEY (usuario_id) 
        REFERENCES autenticacion_schema.usuarios(pkid_usuarios) ON DELETE RESTRICT,
    CONSTRAINT fk_tutores_monedas FOREIGN KEY (moneda_codigo) 
        REFERENCES shared_schema.monedas(codigo),
    CONSTRAINT uq_tutores_usuario UNIQUE (usuario_id),
    CONSTRAINT ck_tutores_experiencia CHECK (experiencia_anos >= 0 AND experiencia_anos <= 50),
    CONSTRAINT ck_tutores_precio CHECK (precio_por_hora > 0),
    CONSTRAINT ck_tutores_valoracion CHECK (valoracion_promedio >= 0 AND valoracion_promedio <= 5),
    CONSTRAINT ck_tutores_estado CHECK (estado IN ('PENDIENTE_APROBACION', 'ACTIVO', 'SUSPENDIDO', 'INACTIVO'))
);

CREATE INDEX idx_tutores_usuario ON marketplace_schema.tutores(usuario_id) WHERE expiration_date IS NULL;
CREATE INDEX idx_tutores_estado ON marketplace_schema.tutores(estado);
CREATE INDEX idx_tutores_precio ON marketplace_schema.tutores(precio_por_hora);
CREATE INDEX idx_tutores_valoracion ON marketplace_schema.tutores(valoracion_promedio DESC NULLS LAST);
CREATE INDEX idx_tutores_certificaciones ON marketplace_schema.tutores USING GIN (certificaciones);
CREATE INDEX idx_tutores_idiomas ON marketplace_schema.tutores USING GIN (idiomas);

CREATE TRIGGER trg_tutores_increment_version
    BEFORE UPDATE ON marketplace_schema.tutores
    FOR EACH ROW
    EXECUTE FUNCTION shared_schema.increment_version();

COMMENT ON TABLE marketplace_schema.tutores IS 'Aggregate Root: Tutor con especialidades, precios, disponibilidad';
COMMENT ON COLUMN marketplace_schema.tutores.pkid_tutores IS 'Primary Key UUID de la tabla tutores';
COMMENT ON COLUMN marketplace_schema.tutores.creation_date IS 'Fecha y hora de creación del registro (inmutable)';
COMMENT ON COLUMN marketplace_schema.tutores.expiration_date IS 'Soft delete: NULL = activo, NOT NULL = fecha de eliminación lógica';
COMMENT ON COLUMN marketplace_schema.tutores.certificaciones IS 'JSONB: Lista de certificaciones [{nombre, institucion, fecha_obtencion, url_credencial}]';
COMMENT ON COLUMN marketplace_schema.tutores.idiomas IS 'JSONB: Idiomas que domina [{codigo: ES, nivel: Nativo}, {codigo: EN, nivel: Avanzado}]';
COMMENT ON COLUMN marketplace_schema.tutores.horario_disponibilidad IS 'JSONB: Horarios por día {lunes: [09:00-12:00, 14:00-18:00], ...}';

-- Tabla: Especialidades de Tutores (many-to-many)
CREATE TABLE marketplace_schema.tutor_especialidades (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ========================================
    pkid_tutor_especialidades UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- FOREIGN KEYS
    -- ========================================
    tutor_id UUID NOT NULL,
    categoria_id UUID NOT NULL,
    
    -- ========================================
    -- CAMPOS DE NEGOCIO
    -- ========================================
    nivel VARCHAR(50) NOT NULL,
    anos_experiencia SMALLINT,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_tutor_especialidades PRIMARY KEY (pkid_tutor_especialidades),
    CONSTRAINT fk_tutor_especialidades_tutores FOREIGN KEY (tutor_id) 
        REFERENCES marketplace_schema.tutores(pkid_tutores) ON DELETE CASCADE,
    CONSTRAINT fk_tutor_especialidades_categorias FOREIGN KEY (categoria_id) 
        REFERENCES marketplace_schema.categorias(pkid_categorias) ON DELETE RESTRICT,
    CONSTRAINT uq_tutor_especialidades UNIQUE(tutor_id, categoria_id),
    CONSTRAINT ck_tutor_especialidades_nivel CHECK (nivel IN ('BASICO', 'INTERMEDIO', 'AVANZADO', 'EXPERTO'))
);

CREATE INDEX idx_tutor_especialidades_tutor ON marketplace_schema.tutor_especialidades(tutor_id);
CREATE INDEX idx_tutor_especialidades_categoria ON marketplace_schema.tutor_especialidades(categoria_id);

COMMENT ON TABLE marketplace_schema.tutor_especialidades IS 'Relación N:M entre Tutores y Categorías con nivel de experticia';
COMMENT ON COLUMN marketplace_schema.tutor_especialidades.pkid_tutor_especialidades IS 'Primary Key UUID de la tabla tutor_especialidades';
COMMENT ON COLUMN marketplace_schema.tutor_especialidades.creation_date IS 'Fecha y hora de creación del registro (inmutable)';
COMMENT ON COLUMN marketplace_schema.tutor_especialidades.expiration_date IS 'Soft delete: NULL = activo, NOT NULL = fecha de eliminación lógica';

-- ====================
-- BC RESERVAS: TABLAS
-- ====================

-- Aggregate Root: Reserva
CREATE TABLE reservas_schema.reservas (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ========================================
    pkid_reservas UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- FOREIGN KEYS
    -- ========================================
    estudiante_id UUID NOT NULL,
    tutor_id UUID NOT NULL,
    categoria_id UUID NOT NULL,
    
    -- ========================================
    -- VALUE OBJECTS
    -- ========================================
    fecha_hora_inicio TIMESTAMPTZ NOT NULL,
    fecha_hora_fin TIMESTAMPTZ NOT NULL,
    duracion_minutos SMALLINT NOT NULL,
    
    -- ========================================
    -- ATRIBUTOS DE NEGOCIO
    -- ========================================
    tema VARCHAR(255) NOT NULL,
    descripcion TEXT,
    
    -- ========================================
    -- PRICING (snapshot al momento de reserva)
    -- ========================================
    precio_total DECIMAL(10,2) NOT NULL,
    moneda_codigo CHAR(3) NOT NULL,
    
    -- ========================================
    -- STATE MACHINE
    -- ========================================
    estado VARCHAR(50) NOT NULL DEFAULT 'PENDIENTE',
    fecha_confirmacion TIMESTAMPTZ,
    fecha_cancelacion TIMESTAMPTZ,
    motivo_cancelacion TEXT,
    
    -- ========================================
    -- OPTIMISTIC LOCKING
    -- ========================================
    version INT NOT NULL DEFAULT 1,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_reservas PRIMARY KEY (pkid_reservas),
    CONSTRAINT fk_reservas_estudiantes FOREIGN KEY (estudiante_id) 
        REFERENCES autenticacion_schema.usuarios(pkid_usuarios) ON DELETE RESTRICT,
    CONSTRAINT fk_reservas_tutores FOREIGN KEY (tutor_id) 
        REFERENCES marketplace_schema.tutores(pkid_tutores) ON DELETE RESTRICT,
    CONSTRAINT fk_reservas_categorias FOREIGN KEY (categoria_id) 
        REFERENCES marketplace_schema.categorias(pkid_categorias) ON DELETE RESTRICT,
    CONSTRAINT fk_reservas_monedas FOREIGN KEY (moneda_codigo) 
        REFERENCES shared_schema.monedas(codigo),
    CONSTRAINT ck_reservas_duracion CHECK (duracion_minutos >= 30 AND duracion_minutos <= 240),
    CONSTRAINT ck_reservas_precio CHECK (precio_total > 0),
    CONSTRAINT ck_reservas_fechas CHECK (fecha_hora_fin > fecha_hora_inicio),
    CONSTRAINT ck_reservas_estado CHECK (estado IN ('PENDIENTE', 'CONFIRMADA', 'CANCELADA', 'COMPLETADA', 'EN_CURSO'))
);

CREATE INDEX idx_reservas_estudiante ON reservas_schema.reservas(estudiante_id) WHERE expiration_date IS NULL;
CREATE INDEX idx_reservas_tutor ON reservas_schema.reservas(tutor_id) WHERE expiration_date IS NULL;
CREATE INDEX idx_reservas_estado ON reservas_schema.reservas(estado);
CREATE INDEX idx_reservas_fecha_inicio ON reservas_schema.reservas(fecha_hora_inicio DESC);
CREATE INDEX idx_reservas_categoria ON reservas_schema.reservas(categoria_id);

CREATE TRIGGER trg_reservas_increment_version
    BEFORE UPDATE ON reservas_schema.reservas
    FOR EACH ROW
    EXECUTE FUNCTION shared_schema.increment_version();

COMMENT ON TABLE reservas_schema.reservas IS 'Aggregate Root: Reserva de sesión de tutoría (State Machine: PENDIENTE → CONFIRMADA → EN_CURSO → COMPLETADA)';
COMMENT ON COLUMN reservas_schema.reservas.pkid_reservas IS 'Primary Key UUID de la tabla reservas';
COMMENT ON COLUMN reservas_schema.reservas.creation_date IS 'Fecha y hora de creación del registro (inmutable)';
COMMENT ON COLUMN reservas_schema.reservas.expiration_date IS 'Soft delete: NULL = activo, NOT NULL = fecha de eliminación lógica';
COMMENT ON COLUMN reservas_schema.reservas.estado IS 'Estado: PENDIENTE (creada), CONFIRMADA (tutor aceptó), CANCELADA, COMPLETADA (finalizada), EN_CURSO (activa)';
COMMENT ON COLUMN reservas_schema.reservas.precio_total IS 'Snapshot del precio al momento de reserva (inmutable)';

-- ====================
-- BC PAGOS: TABLAS
-- ====================

-- Aggregate Root: Pago
CREATE TABLE pagos_schema.pagos (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ========================================
    pkid_pagos UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- FOREIGN KEYS
    -- ========================================
    reserva_id UUID NOT NULL UNIQUE,
    
    -- ========================================
    -- VALUE OBJECT: MONTO
    -- ========================================
    monto DECIMAL(10,2) NOT NULL,
    moneda_codigo CHAR(3) NOT NULL,
    
    -- ========================================
    -- INTEGRACIÓN STRIPE
    -- ========================================
    stripe_payment_intent_id VARCHAR(255) UNIQUE,
    stripe_charge_id VARCHAR(255),
    metodo_pago VARCHAR(50) NOT NULL,
    
    -- ========================================
    -- STATE MACHINE
    -- ========================================
    estado VARCHAR(50) NOT NULL DEFAULT 'PENDIENTE',
    fecha_procesamiento TIMESTAMPTZ,
    fecha_confirmacion TIMESTAMPTZ,
    
    -- ========================================
    -- METADATA
    -- ========================================
    ip_origen VARCHAR(45),
    user_agent TEXT,
    
    -- ========================================
    -- OPTIMISTIC LOCKING
    -- ========================================
    version INT NOT NULL DEFAULT 1,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_pagos PRIMARY KEY (pkid_pagos),
    CONSTRAINT fk_pagos_reservas FOREIGN KEY (reserva_id) 
        REFERENCES reservas_schema.reservas(pkid_reservas) ON DELETE RESTRICT,
    CONSTRAINT fk_pagos_monedas FOREIGN KEY (moneda_codigo) 
        REFERENCES shared_schema.monedas(codigo),
    CONSTRAINT uq_pagos_reserva UNIQUE (reserva_id),
    CONSTRAINT ck_pagos_monto CHECK (monto > 0),
    CONSTRAINT ck_pagos_estado CHECK (estado IN ('PENDIENTE', 'PROCESANDO', 'COMPLETADO', 'FALLIDO', 'REEMBOLSADO')),
    CONSTRAINT ck_pagos_metodo CHECK (metodo_pago IN ('STRIPE_CARD', 'STRIPE_TRANSFER', 'PAYPAL', 'WALLET'))
);

CREATE INDEX idx_pagos_reserva ON pagos_schema.pagos(reserva_id) WHERE expiration_date IS NULL;
CREATE INDEX idx_pagos_estado ON pagos_schema.pagos(estado);
CREATE INDEX idx_pagos_stripe_intent ON pagos_schema.pagos(stripe_payment_intent_id);
CREATE INDEX idx_pagos_fecha_procesamiento ON pagos_schema.pagos(fecha_procesamiento DESC);

CREATE TRIGGER trg_pagos_increment_version
    BEFORE UPDATE ON pagos_schema.pagos
    FOR EACH ROW
    EXECUTE FUNCTION shared_schema.increment_version();

COMMENT ON TABLE pagos_schema.pagos IS 'Aggregate Root: Pago de reserva integrado con Stripe (State Machine: PENDIENTE → PROCESANDO → COMPLETADO)';
COMMENT ON COLUMN pagos_schema.pagos.pkid_pagos IS 'Primary Key UUID de la tabla pagos';
COMMENT ON COLUMN pagos_schema.pagos.creation_date IS 'Fecha y hora de creación del registro (inmutable)';
COMMENT ON COLUMN pagos_schema.pagos.expiration_date IS 'Soft delete: NULL = activo, NOT NULL = fecha de eliminación lógica';
COMMENT ON COLUMN pagos_schema.pagos.stripe_payment_intent_id IS 'ID del PaymentIntent de Stripe (idempotencia)';
COMMENT ON COLUMN pagos_schema.pagos.estado IS 'Estado: PENDIENTE, PROCESANDO, COMPLETADO, FALLIDO, REEMBOLSADO';

-- ====================
-- BC NOTIFICACIONES: TABLAS
-- ====================

CREATE TABLE notificaciones_schema.notificaciones (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ========================================
    pkid_notificaciones UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- FOREIGN KEYS
    -- ========================================
    usuario_id UUID NOT NULL,
    
    -- ========================================
    -- CONTENIDO
    -- ========================================
    tipo VARCHAR(50) NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    mensaje TEXT NOT NULL,
    
    -- ========================================
    -- CANAL
    -- ========================================
    canal VARCHAR(50) NOT NULL,
    email_enviado BOOLEAN NOT NULL DEFAULT FALSE,
    push_enviado BOOLEAN NOT NULL DEFAULT FALSE,
    
    -- ========================================
    -- ESTADO
    -- ========================================
    leida BOOLEAN NOT NULL DEFAULT FALSE,
    fecha_lectura TIMESTAMPTZ,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_notificaciones PRIMARY KEY (pkid_notificaciones),
    CONSTRAINT fk_notificaciones_usuarios FOREIGN KEY (usuario_id) 
        REFERENCES autenticacion_schema.usuarios(pkid_usuarios) ON DELETE CASCADE,
    CONSTRAINT ck_notificaciones_tipo CHECK (tipo IN ('RESERVA', 'PAGO', 'MENSAJE', 'RECORDATORIO', 'SISTEMA')),
    CONSTRAINT ck_notificaciones_canal CHECK (canal IN ('EMAIL', 'PUSH', 'IN_APP', 'ALL'))
);

CREATE INDEX idx_notificaciones_usuario ON notificaciones_schema.notificaciones(usuario_id) WHERE expiration_date IS NULL;
CREATE INDEX idx_notificaciones_leida ON notificaciones_schema.notificaciones(leida) WHERE NOT leida AND expiration_date IS NULL;
CREATE INDEX idx_notificaciones_created ON notificaciones_schema.notificaciones(creation_date DESC);

COMMENT ON TABLE notificaciones_schema.notificaciones IS 'Notificaciones del sistema (email, push, in-app)';
COMMENT ON COLUMN notificaciones_schema.notificaciones.pkid_notificaciones IS 'Primary Key UUID de la tabla notificaciones';
COMMENT ON COLUMN notificaciones_schema.notificaciones.creation_date IS 'Fecha y hora de creación del registro (inmutable)';
COMMENT ON COLUMN notificaciones_schema.notificaciones.expiration_date IS 'Soft delete: NULL = activo, NOT NULL = fecha de eliminación lógica';

-- ====================
-- INITIAL DATA (Reference Data)
-- ====================

-- Monedas principales
INSERT INTO shared_schema.monedas (codigo, nombre, simbolo, decimales) VALUES
    ('USD', 'Dólar Estadounidense', '$', 2),
    ('COP', 'Peso Colombiano', '$', 0),
    ('EUR', 'Euro', '€', 2),
    ('MXN', 'Peso Mexicano', '$', 2),
    ('ARS', 'Peso Argentino', '$', 2)
ON CONFLICT (codigo) DO NOTHING;

-- Países principales (muestra)
INSERT INTO shared_schema.paises (codigo, nombre, codigo_alpha3, region) VALUES
    ('CO', 'Colombia', 'COL', 'South America'),
    ('MX', 'México', 'MEX', 'North America'),
    ('AR', 'Argentina', 'ARG', 'South America'),
    ('ES', 'España', 'ESP', 'Europe'),
    ('US', 'Estados Unidos', 'USA', 'North America')
ON CONFLICT (codigo) DO NOTHING;

-- Idiomas principales
INSERT INTO shared_schema.idiomas (codigo, nombre, nombre_nativo) VALUES
    ('es', 'Español', 'Español'),
    ('en', 'Inglés', 'English'),
    ('fr', 'Francés', 'Français'),
    ('de', 'Alemán', 'Deutsch'),
    ('pt', 'Portugués', 'Português')
ON CONFLICT (codigo) DO NOTHING;

-- Categorías iniciales (se usará pkid_categorias generado automáticamente)
INSERT INTO marketplace_schema.categorias (nombre, descripcion, slug, orden) VALUES
    ('Matemáticas', 'Álgebra, Cálculo, Geometría, Estadística', 'matematicas', 1),
    ('Idiomas', 'Inglés, Francés, Alemán, Italiano', 'idiomas', 2),
    ('Programación', 'Python, Java, JavaScript, Web Development', 'programacion', 3),
    ('Ciencias', 'Física, Química, Biología', 'ciencias', 4),
    ('Música', 'Piano, Guitarra, Canto, Teoría Musical', 'musica', 5)
ON CONFLICT (slug) DO NOTHING;

-- Usuario admin (password: Admin123! hasheado con BCrypt cost 12)
-- Se usará pkid_usuarios generado automáticamente
INSERT INTO autenticacion_schema.usuarios (email, password_hash, nombre, apellido, rol, estado)
VALUES (
    'admin@mitoga.com',
    '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LxDNj3K.UhEoVlNjK',
    'Admin',
    'Sistema',
    'ADMIN',
    'ACTIVO'
)
ON CONFLICT (email) DO NOTHING;

-- ====================
-- ROLES Y PERMISOS (Security)
-- ====================

-- Rol de aplicación (no usar superusuario en app)
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'mitoga_app_user') THEN
        CREATE ROLE mitoga_app_user WITH LOGIN PASSWORD 'changeme_in_production';
    END IF;
END
$$;

-- Permisos por schema
GRANT USAGE ON SCHEMA shared_schema TO mitoga_app_user;
GRANT USAGE ON SCHEMA autenticacion_schema TO mitoga_app_user;
GRANT USAGE ON SCHEMA marketplace_schema TO mitoga_app_user;
GRANT USAGE ON SCHEMA perfiles_schema TO mitoga_app_user;
GRANT USAGE ON SCHEMA reservas_schema TO mitoga_app_user;
GRANT USAGE ON SCHEMA pagos_schema TO mitoga_app_user;
GRANT USAGE ON SCHEMA videollamadas_schema TO mitoga_app_user;
GRANT USAGE ON SCHEMA notificaciones_schema TO mitoga_app_user;
GRANT USAGE ON SCHEMA admin_schema TO mitoga_app_user;

-- Permisos de tablas (SELECT, INSERT, UPDATE, DELETE)
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA shared_schema TO mitoga_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA autenticacion_schema TO mitoga_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA marketplace_schema TO mitoga_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA perfiles_schema TO mitoga_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA reservas_schema TO mitoga_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA pagos_schema TO mitoga_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA videollamadas_schema TO mitoga_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA notificaciones_schema TO mitoga_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA admin_schema TO mitoga_app_user;

-- Permisos de sequences
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA shared_schema TO mitoga_app_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA autenticacion_schema TO mitoga_app_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA marketplace_schema TO mitoga_app_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA perfiles_schema TO mitoga_app_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA reservas_schema TO mitoga_app_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA pagos_schema TO mitoga_app_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA videollamadas_schema TO mitoga_app_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA notificaciones_schema TO mitoga_app_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA admin_schema TO mitoga_app_user;

-- Revocar permisos de public
REVOKE ALL ON DATABASE mitogadb FROM PUBLIC;

-- ====================
-- FIN DE MIGRACIÓN
-- ====================

-- Verificación de estructura
SELECT 
    schemaname AS schema,
    COUNT(*) AS total_tables
FROM pg_tables
WHERE schemaname LIKE '%_schema'
GROUP BY schemaname
ORDER BY schemaname;

COMMENT ON DATABASE mitogadb IS 'MI-TOGA Backend Database - DDD + Hexagonal Architecture - PostgreSQL 16.x';
