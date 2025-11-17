-- ═══════════════════════════════════════════════════════════════════════════════
-- SCRIPT: V006__crear_tabla_proceso_registro.sql
-- AUTOR: Database Engineer Senior - PostgreSQL Architect
-- FECHA: 2025-11-17
-- VERSION: 1.0.0
-- 
-- DESCRIPCION:
--   Creación de la tabla 'proceso_registro' para seguimiento del proceso de
--   registro multipasos (Step1 → Step2 → Step3 → Step4).
--   
--   Esta tabla almacena el estado del proceso de registro de nuevos usuarios,
--   permitiendo:
--   - Reanudar registro incompleto
--   - Validar que todos los pasos se completen en orden
--   - Auditar tiempos de completación por paso
--   - Identificar puntos de abandono en el funnel
--   - Almacenar datos temporales antes de crear entidades finales
--
-- BOUNDED CONTEXT: Autenticación - Registro de Usuarios
-- PATTERN: Process Tracking / Saga Pattern
-- 
-- DEPENDENCIAS:
--   - V001__crear_tabla_perfiles.sql (tabla perfiles)
--   - PostgreSQL 12+, Extension uuid-ossp
--
-- CRITERIOS DE DISEÑO:
--   ✅ Schema único (appmatch_schema)
--   ✅ Naming convention: pkid_{tabla}, creation_date, expiration_date
--   ✅ Estado del proceso (STEP_1, STEP_2, STEP_3, STEP_4, COMPLETADO, ABANDONADO)
--   ✅ Timestamps por cada paso completado
--   ✅ Datos temporales en JSONB para flexibilidad
--   ✅ TTL configurable para limpiar procesos abandonados
--   ✅ Audit trail completo
--   ✅ Índices para búsquedas frecuentes
-- ═══════════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 1: Verificar prerrequisitos
-- ═══════════════════════════════════════════════════════════════════════════════

-- Verificar que existe appmatch_schema
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'appmatch_schema') THEN
        RAISE EXCEPTION 'Schema appmatch_schema no existe. Ejecutar scripts previos.';
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

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 2: Crear ENUM para estado del proceso
-- ═══════════════════════════════════════════════════════════════════════════════

DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'estado_proceso_registro') THEN
        CREATE TYPE appmatch_schema.estado_proceso_registro AS ENUM (
            'STEP_1_INICIADO',        -- Usuario inició Step 1 (credenciales)
            'STEP_1_COMPLETADO',      -- Step 1 completado, esperando Step 2
            'STEP_2_COMPLETADO',      -- Step 2 completado (datos personales), esperando Step 3
            'STEP_3_COMPLETADO',      -- Step 3 completado (archivos), esperando Step 4
            'STEP_4_COMPLETADO',      -- Step 4 completado (verificación OTP)
            'COMPLETADO',             -- Proceso completado exitosamente
            'ABANDONADO',             -- Usuario abandonó el proceso
            'ERROR'                   -- Error durante el proceso
        );
    END IF;
END $$;

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 3: Crear tabla proceso_registro
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS appmatch_schema.proceso_registro (
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    pkid_proceso_registro UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- ESTADO DEL PROCESO
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    estado appmatch_schema.estado_proceso_registro NOT NULL DEFAULT 'STEP_1_INICIADO',
        -- Estado actual del proceso de registro
        -- Indica en qué paso se encuentra el usuario
    
    paso_actual INTEGER NOT NULL DEFAULT 1,
        -- Número del paso actual (1-4)
        -- Facilita validaciones y control de flujo
        
    paso_completado INTEGER NOT NULL DEFAULT 0,
        -- Último paso completado exitosamente (0-4)
        -- 0 = ninguno, 4 = todos
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- RELACIONES CON ENTIDADES FINALES
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    fk_pkid_perfiles UUID NOT NULL,
        -- FK a appmatch_schema.perfiles
        -- Define qué tipo de usuario se está registrando (APRENDIZ, TUTOR, etc.)
        -- Determina qué campos son obligatorios en cada paso
    
    fk_pkid_usuario_creado UUID NULL,
        -- FK a appmatch_schema.usuarios (creado en Step 2)
        -- NULL hasta que se cree el usuario
        -- Se llena al completar Step 2
    
    fk_pkid_informacion_basica_creada UUID NULL,
        -- FK a appmatch_schema.informacion_basica (creado en Step 2)
        -- NULL hasta que se creen los datos personales
        -- Se llena al completar Step 2
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- TIMESTAMPS DE COMPLETACIÓN POR PASO
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    fecha_inicio_step1 TIMESTAMPTZ NULL DEFAULT NOW(),
        -- Fecha/hora en que el usuario inició Step 1
        -- Se setea automáticamente al crear el proceso
    
    fecha_completado_step1 TIMESTAMPTZ NULL,
        -- Fecha/hora en que completó Step 1 (credenciales guardadas en Redis)
        
    fecha_completado_step2 TIMESTAMPTZ NULL,
        -- Fecha/hora en que completó Step 2 (usuario e info básica creados)
        
    fecha_completado_step3 TIMESTAMPTZ NULL,
        -- Fecha/hora en que completó Step 3 (archivos subidos)
        
    fecha_completado_step4 TIMESTAMPTZ NULL,
        -- Fecha/hora en que completó Step 4 (email verificado con OTP)
    
    fecha_completado_total TIMESTAMPTZ NULL,
        -- Fecha/hora en que completó TODO el proceso
        -- Se setea cuando estado = 'COMPLETADO'
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- DATOS TEMPORALES DEL PROCESO (JSONB)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    datos_step1 JSONB NULL,
        -- Datos temporales de Step 1 (antes de guardar en Redis)
        -- Ejemplo: {"email": "...", "password_hash": "..."}
        -- Se limpia después de Step 2
    
    datos_step2 JSONB NULL,
        -- Datos temporales de Step 2 (antes de crear entidades)
        -- Contiene todos los campos de informacion_basica
        -- Se limpia después de Step 2 exitoso
    
    datos_step3 JSONB NULL,
        -- Datos temporales de Step 3 (referencias a archivos subidos)
        -- Ejemplo: {"archivos": [{"tipo": "FOTO_PERFIL", "url": "..."}, ...]}
        -- Se limpia después de Step 3
    
    datos_step4 JSONB NULL,
        -- Datos temporales de Step 4 (código OTP, intentos)
        -- Ejemplo: {"codigo_enviado": "123456", "intentos": 1, "fecha_envio": "..."}
        -- Se limpia después de verificación exitosa
    
    metadata JSONB DEFAULT '{}'::JSONB,
        -- Metadata adicional del proceso
        -- Ejemplos:
        -- - IP de inicio de registro
        -- - User agent
        -- - UTM parameters (origen de marketing)
        -- - Tiempos de respuesta por paso
        -- - Intentos fallidos por paso
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- CONTROL DE EXPIRACIÓN Y ABANDONO
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    fecha_ultima_actividad TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        -- Fecha/hora de la última actividad del usuario en el proceso
        -- Se actualiza en cada paso
        -- Usado para detectar abandonos
    
    ttl_minutos INTEGER NOT NULL DEFAULT 60,
        -- Time To Live en minutos
        -- Después de este tiempo sin actividad, el proceso se marca como ABANDONADO
        -- Por defecto 60 minutos (1 hora)
        -- Configurable según políticas de negocio
    
    fecha_expiracion_calculada TIMESTAMPTZ GENERATED ALWAYS AS (
        fecha_ultima_actividad + (ttl_minutos || ' minutes')::INTERVAL
    ) STORED,
        -- Fecha de expiración calculada automáticamente
        -- Si NOW() > fecha_expiracion_calculada → proceso abandonado
    
    motivo_abandono TEXT NULL,
        -- Razón del abandono (si aplica)
        -- Ejemplos: "timeout", "usuario_canceló", "error_validacion"
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- CONSTRAINTS
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    CONSTRAINT pk_proceso_registro PRIMARY KEY (pkid_proceso_registro),
    
    -- Foreign Keys
    CONSTRAINT fk_proceso_registro_perfiles
        FOREIGN KEY (fk_pkid_perfiles)
        REFERENCES appmatch_schema.perfiles(pkid_perfiles)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_proceso_registro_usuario
        FOREIGN KEY (fk_pkid_usuario_creado)
        REFERENCES appmatch_schema.usuarios(pkid_usuarios)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_proceso_registro_informacion_basica
        FOREIGN KEY (fk_pkid_informacion_basica_creada)
        REFERENCES appmatch_schema.informacion_basica(pkid_informacion_basica)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    
    -- CHECK constraints - Pasos válidos
    CONSTRAINT ck_proceso_registro_paso_actual_valido
        CHECK (paso_actual >= 1 AND paso_actual <= 4),
    
    CONSTRAINT ck_proceso_registro_paso_completado_valido
        CHECK (paso_completado >= 0 AND paso_completado <= 4),
    
    CONSTRAINT ck_proceso_registro_paso_completado_menor_igual_actual
        CHECK (paso_completado <= paso_actual),
    
    -- CHECK constraint - TTL positivo
    CONSTRAINT ck_proceso_registro_ttl_positivo
        CHECK (ttl_minutos > 0),
    
    -- CHECK constraint - Coherencia de timestamps
    CONSTRAINT ck_proceso_registro_timestamps_orden
        CHECK (
            (fecha_completado_step1 IS NULL OR fecha_completado_step1 >= fecha_inicio_step1) AND
            (fecha_completado_step2 IS NULL OR fecha_completado_step2 >= fecha_completado_step1) AND
            (fecha_completado_step3 IS NULL OR fecha_completado_step3 >= fecha_completado_step2) AND
            (fecha_completado_step4 IS NULL OR fecha_completado_step4 >= fecha_completado_step3) AND
            (fecha_completado_total IS NULL OR fecha_completado_total >= fecha_completado_step4)
        ),
    
    -- CHECK constraint - Usuario creado coherente con estado
    CONSTRAINT ck_proceso_registro_usuario_creado_coherente
        CHECK (
            (paso_completado < 2 AND fk_pkid_usuario_creado IS NULL) OR
            (paso_completado >= 2 AND fk_pkid_usuario_creado IS NOT NULL)
        ),
    
    -- CHECK constraint - Info básica creada coherente con estado
    CONSTRAINT ck_proceso_registro_info_basica_coherente
        CHECK (
            (paso_completado < 2 AND fk_pkid_informacion_basica_creada IS NULL) OR
            (paso_completado >= 2 AND fk_pkid_informacion_basica_creada IS NOT NULL)
        ),
    
    -- CHECK constraint - Completado total requiere Step 4
    CONSTRAINT ck_proceso_registro_completado_requiere_step4
        CHECK (
            (estado = 'COMPLETADO' AND paso_completado = 4 AND fecha_completado_step4 IS NOT NULL) OR
            (estado != 'COMPLETADO')
        )
);

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 4: Crear índices
-- ═══════════════════════════════════════════════════════════════════════════════

-- Índice por estado (para queries de monitoreo)
CREATE INDEX idx_proceso_registro_estado 
    ON appmatch_schema.proceso_registro(estado) 
    WHERE expiration_date IS NULL;

-- Índice por perfil (para estadísticas por tipo de usuario)
CREATE INDEX idx_proceso_registro_perfil 
    ON appmatch_schema.proceso_registro(fk_pkid_perfiles) 
    WHERE expiration_date IS NULL;

-- Índice por usuario creado (para buscar proceso por usuario)
CREATE INDEX idx_proceso_registro_usuario_creado 
    ON appmatch_schema.proceso_registro(fk_pkid_usuario_creado) 
    WHERE fk_pkid_usuario_creado IS NOT NULL AND expiration_date IS NULL;

-- Índice por fecha de última actividad (para limpieza de abandonados)
CREATE INDEX idx_proceso_registro_ultima_actividad 
    ON appmatch_schema.proceso_registro(fecha_ultima_actividad DESC) 
    WHERE estado NOT IN ('COMPLETADO', 'ABANDONADO') AND expiration_date IS NULL;

-- Índice por fecha de expiración calculada (para job de limpieza)
CREATE INDEX idx_proceso_registro_expiracion 
    ON appmatch_schema.proceso_registro(fecha_expiracion_calculada) 
    WHERE estado NOT IN ('COMPLETADO', 'ABANDONADO') AND expiration_date IS NULL;

-- Índice GIN en metadata para búsquedas flexibles
CREATE INDEX idx_proceso_registro_metadata 
    ON appmatch_schema.proceso_registro USING GIN(metadata);

-- Índice compuesto para queries de analítica (funnel de conversión)
CREATE INDEX idx_proceso_registro_estado_creacion 
    ON appmatch_schema.proceso_registro(estado, creation_date DESC) 
    WHERE expiration_date IS NULL;

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 5: Crear funciones auxiliares
-- ═══════════════════════════════════════════════════════════════════════════════

-- Función para actualizar fecha_ultima_actividad automáticamente
CREATE OR REPLACE FUNCTION appmatch_schema.proceso_registro_actualizar_actividad()
RETURNS TRIGGER AS $$
BEGIN
    NEW.fecha_ultima_actividad = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para actualizar fecha_ultima_actividad en cada UPDATE
CREATE TRIGGER trigger_proceso_registro_actualizar_actividad
    BEFORE UPDATE ON appmatch_schema.proceso_registro
    FOR EACH ROW
    WHEN (OLD.estado IS DISTINCT FROM NEW.estado OR 
          OLD.paso_completado IS DISTINCT FROM NEW.paso_completado)
    EXECUTE FUNCTION appmatch_schema.proceso_registro_actualizar_actividad();

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 6: Función para marcar procesos abandonados (ejecutar en job)
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION appmatch_schema.marcar_procesos_abandonados()
RETURNS TABLE (
    procesos_marcados INTEGER,
    ids_marcados UUID[]
) AS $$
DECLARE
    v_count INTEGER;
    v_ids UUID[];
BEGIN
    -- Actualizar procesos expirados que no están completados ni abandonados
    WITH procesos_expirados AS (
        UPDATE appmatch_schema.proceso_registro
        SET 
            estado = 'ABANDONADO',
            motivo_abandono = 'timeout_expiracion'
        WHERE 
            estado NOT IN ('COMPLETADO', 'ABANDONADO', 'ERROR')
            AND expiration_date IS NULL
            AND NOW() > fecha_expiracion_calculada
        RETURNING pkid_proceso_registro
    )
    SELECT 
        COUNT(*)::INTEGER,
        ARRAY_AGG(pkid_proceso_registro)
    INTO v_count, v_ids
    FROM procesos_expirados;
    
    RETURN QUERY SELECT v_count, v_ids;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION appmatch_schema.marcar_procesos_abandonados() IS 
'Marca como ABANDONADO todos los procesos de registro que excedieron su TTL.
Debe ejecutarse periódicamente (cada 5-15 minutos) mediante un job programado.
Retorna el número de procesos marcados y sus IDs para logging.';

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 7: Función para limpiar procesos abandonados antiguos (GDPR compliance)
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION appmatch_schema.limpiar_procesos_abandonados_antiguos(
    dias_antiguedad INTEGER DEFAULT 30
)
RETURNS TABLE (
    procesos_eliminados INTEGER,
    ids_eliminados UUID[]
) AS $$
DECLARE
    v_count INTEGER;
    v_ids UUID[];
BEGIN
    -- Soft delete de procesos abandonados con más de X días
    WITH procesos_antiguos AS (
        UPDATE appmatch_schema.proceso_registro
        SET expiration_date = NOW()
        WHERE 
            estado = 'ABANDONADO'
            AND expiration_date IS NULL
            AND fecha_ultima_actividad < (NOW() - (dias_antiguedad || ' days')::INTERVAL)
        RETURNING pkid_proceso_registro
    )
    SELECT 
        COUNT(*)::INTEGER,
        ARRAY_AGG(pkid_proceso_registro)
    INTO v_count, v_ids
    FROM procesos_antiguos;
    
    RETURN QUERY SELECT v_count, v_ids;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION appmatch_schema.limpiar_procesos_abandonados_antiguos(INTEGER) IS 
'Realiza soft delete de procesos abandonados con más de X días de antigüedad.
Cumplimiento GDPR: eliminar datos personales temporales no utilizados.
Por defecto elimina procesos abandonados hace más de 30 días.
Debe ejecutarse periódicamente (diario/semanal) mediante un job programado.';

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 8: Vistas útiles para analítica y monitoreo
-- ═══════════════════════════════════════════════════════════════════════════════

-- Vista: Resumen de procesos activos
CREATE OR REPLACE VIEW appmatch_schema.v_procesos_registro_activos AS
SELECT 
    pr.pkid_proceso_registro,
    pr.estado,
    pr.paso_actual,
    pr.paso_completado,
    p.codigo AS perfil_codigo,
    p.nombre AS perfil_nombre,
    pr.creation_date AS fecha_inicio,
    pr.fecha_ultima_actividad,
    pr.fecha_expiracion_calculada,
    EXTRACT(EPOCH FROM (NOW() - pr.creation_date))/60 AS minutos_transcurridos,
    EXTRACT(EPOCH FROM (pr.fecha_expiracion_calculada - NOW()))/60 AS minutos_restantes,
    CASE 
        WHEN NOW() > pr.fecha_expiracion_calculada THEN 'EXPIRADO'
        WHEN EXTRACT(EPOCH FROM (pr.fecha_expiracion_calculada - NOW()))/60 < 10 THEN 'PROXIMO_EXPIRA'
        ELSE 'ACTIVO'
    END AS estado_tiempo
FROM appmatch_schema.proceso_registro pr
INNER JOIN appmatch_schema.perfiles p ON pr.fk_pkid_perfiles = p.pkid_perfiles
WHERE pr.expiration_date IS NULL
  AND pr.estado NOT IN ('COMPLETADO', 'ABANDONADO');

COMMENT ON VIEW appmatch_schema.v_procesos_registro_activos IS
'Vista de procesos de registro activos con información de tiempo y estado.
Útil para monitoreo en tiempo real y detección de procesos próximos a expirar.';

-- Vista: Métricas del funnel de conversión
CREATE OR REPLACE VIEW appmatch_schema.v_metricas_funnel_registro AS
SELECT 
    p.codigo AS perfil,
    COUNT(*) AS total_iniciados,
    COUNT(*) FILTER (WHERE pr.paso_completado >= 1) AS completaron_step1,
    COUNT(*) FILTER (WHERE pr.paso_completado >= 2) AS completaron_step2,
    COUNT(*) FILTER (WHERE pr.paso_completado >= 3) AS completaron_step3,
    COUNT(*) FILTER (WHERE pr.paso_completado = 4) AS completaron_step4,
    COUNT(*) FILTER (WHERE pr.estado = 'COMPLETADO') AS procesos_completados,
    COUNT(*) FILTER (WHERE pr.estado = 'ABANDONADO') AS procesos_abandonados,
    ROUND(100.0 * COUNT(*) FILTER (WHERE pr.paso_completado >= 1) / NULLIF(COUNT(*), 0), 2) AS tasa_step1_pct,
    ROUND(100.0 * COUNT(*) FILTER (WHERE pr.paso_completado >= 2) / NULLIF(COUNT(*), 0), 2) AS tasa_step2_pct,
    ROUND(100.0 * COUNT(*) FILTER (WHERE pr.paso_completado >= 3) / NULLIF(COUNT(*), 0), 2) AS tasa_step3_pct,
    ROUND(100.0 * COUNT(*) FILTER (WHERE pr.paso_completado = 4) / NULLIF(COUNT(*), 0), 2) AS tasa_step4_pct,
    ROUND(100.0 * COUNT(*) FILTER (WHERE pr.estado = 'COMPLETADO') / NULLIF(COUNT(*), 0), 2) AS tasa_completado_pct
FROM appmatch_schema.proceso_registro pr
INNER JOIN appmatch_schema.perfiles p ON pr.fk_pkid_perfiles = p.pkid_perfiles
WHERE pr.expiration_date IS NULL
GROUP BY p.codigo, p.pkid_perfiles
ORDER BY total_iniciados DESC;

COMMENT ON VIEW appmatch_schema.v_metricas_funnel_registro IS
'Vista con métricas del funnel de conversión del registro por perfil.
Muestra tasas de conversión por cada step para análisis de abandono.';

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 9: Comentarios en la tabla
-- ═══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE appmatch_schema.proceso_registro IS 
'Tabla de seguimiento del proceso de registro multipasos (Step1-4).
Permite rastrear el progreso, detectar abandonos y almacenar datos temporales.';

COMMENT ON COLUMN appmatch_schema.proceso_registro.estado IS 
'Estado actual del proceso (STEP_1_INICIADO, STEP_1_COMPLETADO, ..., COMPLETADO, ABANDONADO, ERROR)';

COMMENT ON COLUMN appmatch_schema.proceso_registro.paso_actual IS 
'Número del paso actual en el que se encuentra el usuario (1-4)';

COMMENT ON COLUMN appmatch_schema.proceso_registro.paso_completado IS 
'Último paso completado exitosamente (0-4). 0=ninguno, 4=todos completados';

COMMENT ON COLUMN appmatch_schema.proceso_registro.fk_pkid_usuario_creado IS 
'FK al usuario creado en Step 2. NULL hasta completar Step 2';

COMMENT ON COLUMN appmatch_schema.proceso_registro.fk_pkid_informacion_basica_creada IS 
'FK a informacion_basica creada en Step 2. NULL hasta completar Step 2';

COMMENT ON COLUMN appmatch_schema.proceso_registro.ttl_minutos IS 
'Time To Live en minutos. Después de este tiempo sin actividad, el proceso expira';

COMMENT ON COLUMN appmatch_schema.proceso_registro.fecha_expiracion_calculada IS 
'Fecha de expiración calculada automáticamente (fecha_ultima_actividad + ttl_minutos)';

COMMENT ON COLUMN appmatch_schema.proceso_registro.datos_step1 IS 
'Datos temporales de Step 1 (credenciales antes de Redis). Se limpia después de Step 2';

COMMENT ON COLUMN appmatch_schema.proceso_registro.datos_step2 IS 
'Datos temporales de Step 2 (datos personales antes de crear entidades). Se limpia después de Step 2';

COMMENT ON COLUMN appmatch_schema.proceso_registro.datos_step3 IS 
'Datos temporales de Step 3 (referencias a archivos subidos). Se limpia después de Step 3';

COMMENT ON COLUMN appmatch_schema.proceso_registro.datos_step4 IS 
'Datos temporales de Step 4 (código OTP, intentos). Se limpia después de verificación';

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 10: Agregar FK en tabla usuarios (referencia inversa)
-- ═══════════════════════════════════════════════════════════════════════════════

-- Verificar y agregar FK en usuarios hacia proceso_registro
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'fk_usuarios_proceso_registro' 
        AND table_name = 'usuarios'
        AND table_schema = 'appmatch_schema'
    ) THEN
        ALTER TABLE appmatch_schema.usuarios
        ADD CONSTRAINT fk_usuarios_proceso_registro
            FOREIGN KEY (fk_pkid_proceso_registro)
            REFERENCES appmatch_schema.proceso_registro(pkid_proceso_registro)
            ON DELETE SET NULL
            ON UPDATE CASCADE;
        
        RAISE NOTICE 'FK fk_usuarios_proceso_registro agregada exitosamente';
    ELSE
        RAISE NOTICE 'FK fk_usuarios_proceso_registro ya existe';
    END IF;
END $$;

-- Crear índice en usuarios.fk_pkid_proceso_registro
CREATE INDEX IF NOT EXISTS idx_usuarios_proceso_registro 
    ON appmatch_schema.usuarios(fk_pkid_proceso_registro) 
    WHERE fk_pkid_proceso_registro IS NOT NULL AND expiration_date IS NULL;

-- ═══════════════════════════════════════════════════════════════════════════════
-- VERIFICACIÓN FINAL
-- ═══════════════════════════════════════════════════════════════════════════════

DO $$
DECLARE
    v_table_exists BOOLEAN;
    v_enum_exists BOOLEAN;
    v_indexes_count INTEGER;
BEGIN
    -- Verificar tabla
    SELECT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'appmatch_schema' 
        AND table_name = 'proceso_registro'
    ) INTO v_table_exists;
    
    -- Verificar enum
    SELECT EXISTS (
        SELECT 1 FROM pg_type 
        WHERE typname = 'estado_proceso_registro'
    ) INTO v_enum_exists;
    
    -- Contar índices
    SELECT COUNT(*) INTO v_indexes_count
    FROM pg_indexes 
    WHERE schemaname = 'appmatch_schema' 
    AND tablename = 'proceso_registro';
    
    RAISE NOTICE '════════════════════════════════════════════════════════════════';
    RAISE NOTICE '✅ VERIFICACIÓN DE CREACIÓN DE TABLA proceso_registro';
    RAISE NOTICE '════════════════════════════════════════════════════════════════';
    RAISE NOTICE 'Tabla proceso_registro creada: %', v_table_exists;
    RAISE NOTICE 'ENUM estado_proceso_registro creado: %', v_enum_exists;
    RAISE NOTICE 'Índices creados: %', v_indexes_count;
    RAISE NOTICE '════════════════════════════════════════════════════════════════';
    
    IF v_table_exists AND v_enum_exists AND v_indexes_count >= 7 THEN
        RAISE NOTICE '✅ SCRIPT V006 EJECUTADO EXITOSAMENTE';
    ELSE
        RAISE WARNING '⚠️  Verificar que todos los objetos se hayan creado correctamente';
    END IF;
END $$;
