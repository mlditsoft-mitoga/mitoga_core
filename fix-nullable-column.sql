-- ============================================================================
-- Migration: Permitir NULL en fk_pkid_informacion_basica
-- ============================================================================
-- Razón: Registro multi-paso (STEP 1: credenciales, STEP 2: perfil)
-- BC01-Autenticacion | HUT-001

-- Conectarse a PostgreSQL y ejecutar:
psql -h 192.168.18.126 -p 5432 -U mitogauser -d mitogadb -c "ALTER TABLE appmatch_schema.usuarios ALTER COLUMN fk_pkid_informacion_basica DROP NOT NULL;"

-- Verificar cambio:
psql -h 192.168.18.126 -p 5432 -U mitogauser -d mitogadb -c "\d+ appmatch_schema.usuarios" | Select-String "fk_pkid_informacion_basica"
