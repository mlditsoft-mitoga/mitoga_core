-- ============================================================================
-- SCRIPT: Inicialización de base de datos para Mitoga
-- Purpose: Crear database, user y permisos necesarios
-- ============================================================================

-- Crear database si no existe
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'mitoga_db') THEN
        PERFORM dblink_exec('dbname=' || current_database(), 'CREATE DATABASE mitoga_db');
    END IF;
END
$$;

-- Crear usuario si no existe
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'mitoga_user') THEN
        CREATE USER mitoga_user WITH ENCRYPTED PASSWORD 'changeme_mitoga_2025';
    END IF;
END
$$;

-- Otorgar permisos
GRANT ALL PRIVILEGES ON DATABASE mitoga_db TO mitoga_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO mitoga_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO mitoga_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO mitoga_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO mitoga_user;

-- Crear extensiones necesarias
\c mitoga_db
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Confirmar creación
\l mitoga_db
\du mitoga_user
