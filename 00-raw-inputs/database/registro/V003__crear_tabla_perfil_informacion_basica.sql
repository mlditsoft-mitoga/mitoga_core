-- ═══════════════════════════════════════════════════════════════════════════════
-- SCRIPT: V003__crear_tabla_perfil_informacion_basica.sql
-- AUTOR: Database Engineer Senior - PostgreSQL Architect
-- FECHA: 2025-11-16
-- VERSION: 1.0.0
-- 
-- DESCRIPCION:
--   Creación de la tabla de relación 'perfil_informacion_basica' que establece
--   la asociación N:M entre perfiles (APRENDIZ, TUTOR, ADMIN) e información básica
--   de usuarios.
--   
--   Esta tabla permite que:
--   - Un usuario (info básica) pueda tener MÚLTIPLES perfiles
--   - Un perfil puede estar asociado a MÚLTIPLES usuarios
--   
--   Ejemplo: Un usuario puede ser APRENDIZ y TUTOR simultáneamente.
--
-- BOUNDED CONTEXT: Autenticación (Gestión de perfiles de usuario)
-- PATTERN: Many-to-Many Relationship Table
-- 
-- DEPENDENCIAS:
--   - V001__crear_tabla_perfiles.sql (tabla perfiles ya existe)
--   - V002__crear_tabla_informacion_basica.sql (tabla informacion_basica ya existe)
--   - PostgreSQL 12+, Extension uuid-ossp
--
-- CRITERIOS DE DISEÑO DDD:
--   ✅ Schema único (appmatch_schema)
--   ✅ Naming convention: pkid_{tabla}, creation_date, expiration_date
--   ✅ Foreign Keys con nomenclatura estándar (fk_pkid_{tabla})
--   ✅ Constraints explícitos
--   ✅ Soft delete (expiration_date)
--   ✅ Audit trail completo
--   ✅ Índices para búsquedas comunes y performance de JOINs
--   ✅ Unique constraint para evitar duplicados (perfil + info_basica)
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

-- Verificar que existe tabla perfiles
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'appmatch_schema' AND table_name = 'perfiles'
    ) THEN
        RAISE EXCEPTION 'Tabla appmatch_schema.perfiles no existe. Ejecutar V001 primero.';
    END IF;
END $$;

-- Verificar que existe tabla informacion_basica
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'appmatch_schema' AND table_name = 'informacion_basica'
    ) THEN
        RAISE EXCEPTION 'Tabla appmatch_schema.informacion_basica no existe. Ejecutar V002 primero.';
    END IF;
END $$;

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 2: Crear tabla perfil_informacion_basica (relación N:M)
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS appmatch_schema.perfil_informacion_basica (
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    pkid_perfil_informacion_basica UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- FOREIGN KEYS (RELACIÓN N:M)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    fk_pkid_perfiles UUID NOT NULL,
        -- FK a appmatch_schema.perfiles
        -- Referencia al perfil (APRENDIZ, TUTOR, ADMIN)
        
    fk_pkid_informacion_basica UUID NOT NULL,
        -- FK a appmatch_schema.informacion_basica
        -- Referencia a la información básica del usuario
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- DATOS ADICIONALES DE LA RELACIÓN
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    es_perfil_principal BOOLEAN NOT NULL DEFAULT FALSE,
        -- TRUE si este es el perfil principal/por defecto del usuario
        -- Solo puede haber UN perfil principal activo por usuario
        
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
        -- Estado de la relación: ACTIVO, INACTIVO, SUSPENDIDO
        -- Permite desactivar un perfil sin eliminarlo
        
    fecha_asignacion TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        -- Fecha en que se asignó el perfil al usuario
        
    fecha_ultima_activacion TIMESTAMPTZ,
        -- Última vez que el usuario usó este perfil
        -- Útil para estadísticas y analítica
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- METADATA Y AUDITORÍA
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    metadata JSONB DEFAULT '{}'::JSONB,
        -- Metadata adicional de la relación
        -- Ejemplos: {"motivo_asignacion": "registro_inicial", "asignado_por": "sistema"}
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- CONSTRAINTS
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    CONSTRAINT pk_perfil_informacion_basica PRIMARY KEY (pkid_perfil_informacion_basica),
    
    -- Foreign Keys
    CONSTRAINT fk_perfil_info_basica_perfiles
        FOREIGN KEY (fk_pkid_perfiles)
        REFERENCES appmatch_schema.perfiles(pkid_perfiles)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
    CONSTRAINT fk_perfil_info_basica_informacion_basica
        FOREIGN KEY (fk_pkid_informacion_basica)
        REFERENCES appmatch_schema.informacion_basica(pkid_informacion_basica)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    -- Unique constraint para evitar duplicados (mismo perfil + usuario)
    CONSTRAINT uk_perfil_informacion_basica_perfil_usuario
        UNIQUE (fk_pkid_perfiles, fk_pkid_informacion_basica),
        -- Un usuario NO puede tener el mismo perfil duplicado
    
    -- Validación de estado
    CONSTRAINT ck_perfil_informacion_basica_estado_valido
        CHECK (estado IN ('ACTIVO', 'INACTIVO', 'SUSPENDIDO')),
    
    -- Soft delete coherente
    CONSTRAINT ck_perfil_informacion_basica_soft_delete_coherente
        CHECK (
            expiration_date IS NULL OR 
            expiration_date > creation_date
        )
);

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 3: Crear índices para búsquedas comunes y performance de JOINs
-- ═══════════════════════════════════════════════════════════════════════════════

-- Índices en Foreign Keys (CRÍTICO para performance de JOINs)
CREATE INDEX idx_perfil_info_basica_fk_perfiles 
    ON appmatch_schema.perfil_informacion_basica(fk_pkid_perfiles) 
    WHERE expiration_date IS NULL;

CREATE INDEX idx_perfil_info_basica_fk_informacion_basica 
    ON appmatch_schema.perfil_informacion_basica(fk_pkid_informacion_basica) 
    WHERE expiration_date IS NULL;

-- Índice único compuesto (previene duplicados en registros activos)
CREATE UNIQUE INDEX idx_perfil_info_basica_unique_activos 
    ON appmatch_schema.perfil_informacion_basica(fk_pkid_perfiles, fk_pkid_informacion_basica) 
    WHERE expiration_date IS NULL;

-- Índice para búsqueda de perfil principal por usuario
CREATE INDEX idx_perfil_info_basica_principal 
    ON appmatch_schema.perfil_informacion_basica(fk_pkid_informacion_basica, es_perfil_principal) 
    WHERE expiration_date IS NULL AND es_perfil_principal = TRUE;

-- Índice para búsqueda por estado
CREATE INDEX idx_perfil_info_basica_estado 
    ON appmatch_schema.perfil_informacion_basica(estado) 
    WHERE expiration_date IS NULL;

-- Índice para ordenamiento por fecha de asignación
CREATE INDEX idx_perfil_info_basica_fecha_asignacion 
    ON appmatch_schema.perfil_informacion_basica(fecha_asignacion DESC) 
    WHERE expiration_date IS NULL;

-- Índice GIN para búsquedas en metadata JSONB
CREATE INDEX idx_perfil_info_basica_metadata 
    ON appmatch_schema.perfil_informacion_basica USING GIN(metadata);

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 4: Insertar relación de datos de prueba
-- ═══════════════════════════════════════════════════════════════════════════════

-- Asignar perfil APRENDIZ al usuario de prueba
INSERT INTO appmatch_schema.perfil_informacion_basica (
    pkid_perfil_informacion_basica,
    creation_date,
    expiration_date,
    fk_pkid_perfiles,
    fk_pkid_informacion_basica,
    es_perfil_principal,
    estado,
    fecha_asignacion,
    fecha_ultima_activacion,
    metadata
) VALUES (
    gen_random_uuid(),
    NOW(),
    NULL,
    (SELECT pkid_perfiles FROM appmatch_schema.perfiles WHERE codigo = 'APRENDIZ' AND expiration_date IS NULL LIMIT 1),
    'aabee5d7-14bb-4d90-8e4b-347b736b6485'::UUID,  -- UUID del usuario Wilmer Torres
    TRUE,  -- Es perfil principal
    'ACTIVO',
    NOW(),
    NULL,
    '{"motivo_asignacion": "registro_inicial", "asignado_por": "sistema"}'::JSONB
) ON CONFLICT (fk_pkid_perfiles, fk_pkid_informacion_basica) DO NOTHING;

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 5: Documentación (COMMENTS)
-- ═══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE appmatch_schema.perfil_informacion_basica IS 
'Tabla de relación N:M entre perfiles e información básica de usuarios.
Permite que un usuario tenga múltiples perfiles (ej: APRENDIZ + TUTOR simultáneamente).
Incluye estado de la relación, perfil principal, fechas de asignación/activación.';

COMMENT ON COLUMN appmatch_schema.perfil_informacion_basica.pkid_perfil_informacion_basica IS 
'Primary Key UUID de la tabla perfil_informacion_basica';

COMMENT ON COLUMN appmatch_schema.perfil_informacion_basica.fk_pkid_perfiles IS 
'FK a appmatch_schema.perfiles. Referencia al perfil asignado (APRENDIZ, TUTOR, ADMIN).';

COMMENT ON COLUMN appmatch_schema.perfil_informacion_basica.fk_pkid_informacion_basica IS 
'FK a appmatch_schema.informacion_basica. Referencia a la información básica del usuario.';

COMMENT ON COLUMN appmatch_schema.perfil_informacion_basica.es_perfil_principal IS 
'TRUE si este es el perfil principal/por defecto del usuario. 
Solo puede haber UN perfil principal activo por usuario.';

COMMENT ON COLUMN appmatch_schema.perfil_informacion_basica.estado IS 
'Estado de la relación perfil-usuario. Valores: ACTIVO, INACTIVO, SUSPENDIDO.
Permite desactivar temporalmente un perfil sin eliminarlo.';

COMMENT ON COLUMN appmatch_schema.perfil_informacion_basica.fecha_asignacion IS 
'Fecha y hora en que se asignó el perfil al usuario (timestamp con zona horaria).';

COMMENT ON COLUMN appmatch_schema.perfil_informacion_basica.fecha_ultima_activacion IS 
'Última fecha y hora en que el usuario utilizó este perfil. 
Útil para analítica y estadísticas de uso de perfiles.';

COMMENT ON COLUMN appmatch_schema.perfil_informacion_basica.metadata IS 
'Metadata adicional en formato JSONB. Ejemplos: motivo_asignacion, asignado_por, notas.
Permite extender el modelo sin ALTER TABLE.';

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 6: Queries de ejemplo para desarrollo
-- ═══════════════════════════════════════════════════════════════════════════════

-- Obtener todos los perfiles de un usuario con información completa
-- SELECT 
--     pib.pkid_perfil_informacion_basica,
--     p.codigo AS codigo_perfil,
--     p.nombre AS nombre_perfil,
--     pib.es_perfil_principal,
--     pib.estado,
--     pib.fecha_asignacion,
--     pib.fecha_ultima_activacion,
--     ib.email,
--     TRIM(CONCAT_WS(' ', ib.primer_nombre, ib.primer_apellido)) AS nombre_usuario
-- FROM appmatch_schema.perfil_informacion_basica pib
-- INNER JOIN appmatch_schema.perfiles p ON pib.fk_pkid_perfiles = p.pkid_perfiles
-- INNER JOIN appmatch_schema.informacion_basica ib ON pib.fk_pkid_informacion_basica = ib.pkid_informacion_basica
-- WHERE pib.fk_pkid_informacion_basica = 'aabee5d7-14bb-4d90-8e4b-347b736b6485'::UUID
--   AND pib.expiration_date IS NULL
--   AND pib.estado = 'ACTIVO'
-- ORDER BY pib.es_perfil_principal DESC, pib.fecha_asignacion ASC;

-- Obtener el perfil principal de un usuario
-- SELECT 
--     p.codigo,
--     p.nombre,
--     pib.estado
-- FROM appmatch_schema.perfil_informacion_basica pib
-- INNER JOIN appmatch_schema.perfiles p ON pib.fk_pkid_perfiles = p.pkid_perfiles
-- WHERE pib.fk_pkid_informacion_basica = 'aabee5d7-14bb-4d90-8e4b-347b736b6485'::UUID
--   AND pib.expiration_date IS NULL
--   AND pib.es_perfil_principal = TRUE
--   AND pib.estado = 'ACTIVO';

-- Listar todos los usuarios con un perfil específico (ej: TUTOR)
-- SELECT 
--     ib.pkid_informacion_basica,
--     ib.email,
--     TRIM(CONCAT_WS(' ', ib.primer_nombre, ib.primer_apellido)) AS nombre_completo,
--     pib.estado AS estado_perfil,
--     pib.fecha_asignacion,
--     pib.fecha_ultima_activacion
-- FROM appmatch_schema.perfil_informacion_basica pib
-- INNER JOIN appmatch_schema.informacion_basica ib ON pib.fk_pkid_informacion_basica = ib.pkid_informacion_basica
-- INNER JOIN appmatch_schema.perfiles p ON pib.fk_pkid_perfiles = p.pkid_perfiles
-- WHERE p.codigo = 'TUTOR'
--   AND pib.expiration_date IS NULL
--   AND pib.estado = 'ACTIVO';

-- Verificar si un usuario tiene un perfil específico
-- SELECT EXISTS (
--     SELECT 1 
--     FROM appmatch_schema.perfil_informacion_basica pib
--     INNER JOIN appmatch_schema.perfiles p ON pib.fk_pkid_perfiles = p.pkid_perfiles
--     WHERE pib.fk_pkid_informacion_basica = 'aabee5d7-14bb-4d90-8e4b-347b736b6485'::UUID
--       AND p.codigo = 'APRENDIZ'
--       AND pib.expiration_date IS NULL
--       AND pib.estado = 'ACTIVO'
-- ) AS tiene_perfil_aprendiz;

-- Estadísticas: Conteo de usuarios por perfil
-- SELECT 
--     p.codigo,
--     p.nombre,
--     COUNT(DISTINCT pib.fk_pkid_informacion_basica) AS total_usuarios
-- FROM appmatch_schema.perfil_informacion_basica pib
-- INNER JOIN appmatch_schema.perfiles p ON pib.fk_pkid_perfiles = p.pkid_perfiles
-- WHERE pib.expiration_date IS NULL
--   AND pib.estado = 'ACTIVO'
-- GROUP BY p.pkid_perfiles, p.codigo, p.nombre
-- ORDER BY total_usuarios DESC;

-- ═══════════════════════════════════════════════════════════════════════════════
-- FIN DEL SCRIPT
-- ═══════════════════════════════════════════════════════════════════════════════

-- NOTAS IMPORTANTES:
-- 
-- 1. RELACIÓN N:M: Esta tabla permite múltiples perfiles por usuario
--    - Un usuario puede ser APRENDIZ y TUTOR simultáneamente
--    - Un perfil puede estar asignado a múltiples usuarios
-- 2. UNIQUE CONSTRAINT compuesto: (fk_pkid_perfiles + fk_pkid_informacion_basica)
--    - Previene que un usuario tenga el mismo perfil duplicado
-- 3. PERFIL PRINCIPAL: Solo puede haber UNO activo por usuario
--    - Validación a nivel aplicación (backend) para garantizar unicidad
-- 4. ESTADO de la relación:
--    - ACTIVO: Usuario puede usar el perfil normalmente
--    - INACTIVO: Perfil temporalmente desactivado (no eliminado)
--    - SUSPENDIDO: Perfil bloqueado (requiere revisión)
-- 5. ON DELETE CASCADE en FK a informacion_basica:
--    - Si se elimina la info básica, se eliminan sus perfiles asociados
-- 6. ON DELETE RESTRICT en FK a perfiles:
--    - No se puede eliminar un perfil si está asignado a usuarios
-- 7. Soft delete obligatorio (expiration_date) - nunca DELETE físico
-- 8. Índices optimizados para:
--    - JOINs con perfiles e informacion_basica (FKs)
--    - Búsqueda de perfil principal por usuario
--    - Filtrado por estado
--    - Ordenamiento por fecha de asignación
-- 9. INSERT de datos de prueba incluido:
--    - Asigna perfil APRENDIZ al usuario Wilmer Torres como principal
--    - Idempotente con ON CONFLICT DO NOTHING
-- 10. Este script es idempotente (puede ejecutarse múltiples veces)
--
-- DEPENDENCIAS:
--   - V001: appmatch_schema.perfiles (debe tener perfil APRENDIZ con codigo='APRENDIZ')
--   - V002: appmatch_schema.informacion_basica (debe tener usuario con UUID específico)
--
-- SIGUIENTE PASO: 
--   - Crear funcionalidad en backend para:
--     * Asignar/remover perfiles a usuarios
--     * Cambiar perfil principal
--     * Cambiar estado de perfil (activar/desactivar/suspender)
--     * Validar que solo haya UN perfil principal activo por usuario

