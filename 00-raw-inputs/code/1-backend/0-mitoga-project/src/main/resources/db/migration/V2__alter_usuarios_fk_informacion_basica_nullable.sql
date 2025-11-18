-- Migration: Permitir NULL en fk_pkid_informacion_basica
-- Razón: El registro multi-paso crea el usuario en STEP 1 (credenciales)
--        pero la información básica se completa en STEP 2 (perfil)
--
-- BC01-Autenticacion | HUT-001 | Registro Estudiantes STEP 1

ALTER TABLE appmatch_schema.usuarios
    ALTER COLUMN fk_pkid_informacion_basica DROP NOT NULL;

COMMENT ON COLUMN appmatch_schema.usuarios.fk_pkid_informacion_basica IS 
    'FK a informacion_basica. NULL hasta que se complete STEP 2 del registro.';
