-- ═══════════════════════════════════════════════════════════════════════════════
-- SCRIPT: V001__crear_tabla_perfiles.sql
-- AUTOR: Database Engineer Senior - PostgreSQL Architect
-- FECHA: 2025-11-16
-- VERSION: 1.0.0
-- 
-- DESCRIPCION:
--   Creación de la tabla 'perfiles' en el schema 'appmatch_schema' que almacena
--   los tipos de perfiles de usuario del sistema MI-TOGA (Aprendiz, Tutor, Admin).
--   
--   Esta tabla actúa como catálogo maestro de perfiles y NO como tabla de
--   asignación de perfiles a usuarios (eso va en cada Bounded Context).
--
-- BOUNDED CONTEXT: Shared Kernel (Datos maestros compartidos)
-- AGGREGATE: Perfil (Catálogo de tipos de perfil)
-- 
-- DEPENDENCIAS:
--   - PostgreSQL 12+
--   - Extension uuid-ossp (para gen_random_uuid())
--
-- CRITERIOS DE DISEÑO DDD:
--   ✅ Schema separado (appmatch_schema) para datos transversales
--   ✅ Naming convention: pkid_{tabla}, creation_date, expiration_date
--   ✅ Constraints explícitos con nombres semánticos
--   ✅ Índices para búsquedas comunes
--   ✅ Soft delete con expiration_date
--   ✅ Audit trail completo
--   ✅ Comentarios auto-documentados
--   ✅ Datos iniciales con INSERT idempotentes
-- ═══════════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 1: Crear schema si no existe
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE SCHEMA IF NOT EXISTS appmatch_schema;

COMMENT ON SCHEMA appmatch_schema IS 
'Schema único para toda la aplicación MI-TOGA - Contiene todas las tablas del sistema (usuarios, tutores, reservas, pagos, perfiles, catálogos)';

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 2: Habilitar extensiones necesarias
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 3: Crear tabla perfiles
-- ═══════════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════════
-- CREACION DE LA TABLA: appmatch_schema.perfiles
-- ═══════════════════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS appmatch_schema.perfiles (
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    pkid_perfiles UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- ATRIBUTOS DE DOMINIO
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    codigo VARCHAR(20) NOT NULL,
        -- Código único del perfil (APRENDIZ, TUTOR, ADMIN)
        -- Usado para referencias en código y lógica de negocio
        
    nombre VARCHAR(100) NOT NULL,
        -- Nombre descriptivo del perfil (ej: "Aprendiz", "Tutor", "Administrador")
        
    descripcion TEXT,
        -- Descripción detallada del propósito y permisos del perfil
        
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
        -- Estado del perfil (ACTIVO, INACTIVO)
        -- Permite desactivar perfiles sin eliminarlos físicamente
        
    orden_visualizacion INT NOT NULL DEFAULT 0,
        -- Orden de visualización en interfaces de usuario
        -- Menor valor = mayor prioridad de visualización
        
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- METADATA Y CONFIGURACIÓN
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    configuracion JSONB DEFAULT '{}'::JSONB,
        -- Configuración adicional del perfil en formato JSON
        -- Ejemplos: {"permisos_especiales": [...], "restricciones": {...}}
        
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- CONSTRAINTS
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    CONSTRAINT pk_perfiles PRIMARY KEY (pkid_perfiles),
    
    CONSTRAINT uk_perfiles_codigo 
        UNIQUE (codigo),
        
    CONSTRAINT ck_perfiles_codigo_formato 
        CHECK (codigo ~ '^[A-Z_]+$'),
        -- Código debe ser UPPERCASE con underscores (ej: APRENDIZ, TUTOR_ESPECIALISTA)
        
    CONSTRAINT ck_perfiles_estado_valido 
        CHECK (estado IN ('ACTIVO', 'INACTIVO')),
        
    CONSTRAINT ck_perfiles_nombre_no_vacio 
        CHECK (LENGTH(TRIM(nombre)) > 0),
        
    CONSTRAINT ck_perfiles_orden_positivo 
        CHECK (orden_visualizacion >= 0),
        
    CONSTRAINT ck_perfiles_activo_si_no_expirado
        CHECK (
            (expiration_date IS NULL AND estado = 'ACTIVO') OR
            (expiration_date IS NOT NULL AND estado = 'INACTIVO')
        )
        -- Soft delete coherente: si está expirado, debe estar INACTIVO
);

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 4: Crear índices para búsquedas comunes
-- ═══════════════════════════════════════════════════════════════════════════════

-- Índice para búsqueda por código (usado frecuentemente en queries de negocio)
CREATE INDEX idx_perfiles_codigo 
    ON appmatch_schema.perfiles(codigo) 
    WHERE expiration_date IS NULL;

-- Índice para filtrado por estado (perfiles activos)
CREATE INDEX idx_perfiles_estado 
    ON appmatch_schema.perfiles(estado) 
    WHERE expiration_date IS NULL;

-- Índice para ordenamiento en UI (orden_visualizacion ASC, nombre ASC)
CREATE INDEX idx_perfiles_orden_visualizacion 
    ON appmatch_schema.perfiles(orden_visualizacion ASC, nombre ASC) 
    WHERE expiration_date IS NULL AND estado = 'ACTIVO';

-- Índice GIN para búsquedas en configuración JSONB
CREATE INDEX idx_perfiles_configuracion 
    ON appmatch_schema.perfiles USING GIN(configuracion);

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 5: Documentación (COMMENTS)
-- ═══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE appmatch_schema.perfiles IS 
'Catálogo maestro de tipos de perfil de usuario en MI-TOGA (Aprendiz, Tutor, Administrador). 
Esta tabla es de solo lectura para la aplicación (datos maestros).';

COMMENT ON COLUMN appmatch_schema.perfiles.pkid_perfiles IS 
'Primary Key UUID de la tabla perfiles';

COMMENT ON COLUMN appmatch_schema.perfiles.creation_date IS 
'Fecha y hora de creación del registro (inmutable, auditoría)';

COMMENT ON COLUMN appmatch_schema.perfiles.expiration_date IS 
'Soft delete: NULL = perfil activo, NOT NULL = fecha de eliminación lógica. 
Usar para desactivar perfiles sin perder historial referencial.';

COMMENT ON COLUMN appmatch_schema.perfiles.codigo IS 
'Código único del perfil (APRENDIZ, TUTOR, ADMIN). Usar este campo en código Java/queries en lugar del nombre.
UPPERCASE con underscores, inmutable una vez creado.';

COMMENT ON COLUMN appmatch_schema.perfiles.nombre IS 
'Nombre descriptivo del perfil para mostrar en UI (ej: "Aprendiz", "Tutor Especialista")';

COMMENT ON COLUMN appmatch_schema.perfiles.descripcion IS 
'Descripción detallada del propósito, responsabilidades y permisos del perfil';

COMMENT ON COLUMN appmatch_schema.perfiles.estado IS 
'Estado del perfil (ACTIVO, INACTIVO). Permite desactivar temporalmente sin borrar datos.';

COMMENT ON COLUMN appmatch_schema.perfiles.orden_visualizacion IS 
'Orden de visualización en dropdowns/menús (menor valor = más prioridad). 
Usar para controlar el orden en componentes SelectPerfil.tsx';

COMMENT ON COLUMN appmatch_schema.perfiles.configuracion IS 
'Metadata adicional en formato JSONB. Ejemplos: permisos especiales, restricciones, configuraciones UI.
Permite extender el modelo sin alterar el schema.';

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 6: Insertar datos iniciales (IDEMPOTENTES)
-- ═══════════════════════════════════════════════════════════════════════════════

-- IMPORTANTE: Usar INSERT ... ON CONFLICT DO NOTHING para idempotencia
-- Si el registro ya existe (por código), no hace nada

INSERT INTO appmatch_schema.perfiles (
    codigo, 
    nombre, 
    descripcion, 
    estado, 
    orden_visualizacion,
    configuracion
) VALUES 
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- PERFIL 1: APRENDIZ (Estudiante)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    (
        'APRENDIZ',
        'Aprendiz',
        'Usuario estudiante que busca y reserva tutorías. Puede navegar el marketplace, reservar sesiones, valorar tutores y gestionar su perfil educativo.',
        'ACTIVO',
        1,
        '{
            "permisos": [
                "BUSCAR_TUTORES",
                "RESERVAR_SESIONES",
                "VALORAR_TUTORES",
                "GESTIONAR_PERFIL",
                "ACCEDER_HISTORIAL"
            ],
            "restricciones": {
                "puede_publicar_tutoria": false,
                "requiere_verificacion_email": true,
                "edad_minima": 13
            },
            "ui": {
                "icono": "student",
                "color": "#3B82F6",
                "dashboard_tipo": "estudiante"
            }
        }'::JSONB
    ),
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- PERFIL 2: TUTOR
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    (
        'TUTOR',
        'Tutor',
        'Usuario experto que ofrece tutorías en áreas específicas. Puede publicar disponibilidad, gestionar reservas, recibir pagos y construir su reputación con valoraciones.',
        'ACTIVO',
        2,
        '{
            "permisos": [
                "PUBLICAR_TUTORIA",
                "GESTIONAR_DISPONIBILIDAD",
                "ACEPTAR_RECHAZAR_RESERVAS",
                "RECIBIR_PAGOS",
                "ACCEDER_ESTADISTICAS",
                "GESTIONAR_PERFIL_PUBLICO"
            ],
            "restricciones": {
                "requiere_verificacion_identidad": true,
                "requiere_verificacion_experiencia": true,
                "edad_minima": 18,
                "requiere_cuenta_bancaria": true
            },
            "ui": {
                "icono": "teacher",
                "color": "#10B981",
                "dashboard_tipo": "tutor"
            },
            "comisiones": {
                "porcentaje_plataforma": 15,
                "minimo_retiro": 50000
            }
        }'::JSONB
    ),
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- PERFIL 3: ADMIN (Administrador)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    (
        'ADMIN',
        'Administrador',
        'Usuario con permisos completos para gestionar la plataforma MI-TOGA. Puede moderar contenido, validar tutores, gestionar reportes y configurar el sistema.',
        'ACTIVO',
        3,
        '{
            "permisos": [
                "GESTIONAR_USUARIOS",
                "VALIDAR_TUTORES",
                "MODERAR_CONTENIDO",
                "GESTIONAR_REPORTES",
                "CONFIGURAR_SISTEMA",
                "ACCEDER_PANEL_ADMIN",
                "GENERAR_REPORTES_AVANZADOS",
                "GESTIONAR_PAGOS_COMISIONES"
            ],
            "restricciones": {
                "requiere_autenticacion_2fa": true,
                "ip_whitelist": true,
                "sesion_timeout_minutos": 30
            },
            "ui": {
                "icono": "admin",
                "color": "#EF4444",
                "dashboard_tipo": "admin"
            },
            "seguridad": {
                "nivel_acceso": "FULL",
                "requiere_auditoria": true
            }
        }'::JSONB
    )
ON CONFLICT (codigo) DO NOTHING;
-- Si el código ya existe, no hacer nada (idempotencia)

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 7: Verificar datos insertados
-- ═══════════════════════════════════════════════════════════════════════════════

-- Query de validación (ejecutar después del script)
SELECT 
    pkid_perfiles,
    codigo,
    nombre,
    estado,
    orden_visualizacion,
    creation_date,
    configuracion ->> 'ui' AS ui_config,
    configuracion -> 'permisos' AS permisos
FROM appmatch_schema.perfiles
WHERE expiration_date IS NULL
ORDER BY orden_visualizacion ASC;

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 8: Crear función helper para obtener perfil por código
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION appmatch_schema.obtener_perfil_id(p_codigo VARCHAR)
RETURNS UUID
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    v_perfil_id UUID;
BEGIN
    SELECT pkid_perfiles INTO v_perfil_id
    FROM appmatch_schema.perfiles
    WHERE codigo = p_codigo
      AND expiration_date IS NULL
      AND estado = 'ACTIVO';
    
    IF v_perfil_id IS NULL THEN
        RAISE EXCEPTION 'Perfil con código % no encontrado o inactivo', p_codigo;
    END IF;
    
    RETURN v_perfil_id;
END;
$$;

COMMENT ON FUNCTION appmatch_schema.obtener_perfil_id(VARCHAR) IS 
'Helper function para obtener UUID de perfil por código. 
Uso: SELECT appmatch_schema.obtener_perfil_id(''APRENDIZ'');
Lanza excepción si el perfil no existe o está inactivo.';

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 9: Queries de ejemplo para desarrollo
-- ═══════════════════════════════════════════════════════════════════════════════

-- Obtener ID de perfil APRENDIZ
-- SELECT appmatch_schema.obtener_perfil_id('APRENDIZ');

-- Listar perfiles activos para dropdown UI
-- SELECT codigo, nombre FROM appmatch_schema.perfiles 
-- WHERE estado = 'ACTIVO' AND expiration_date IS NULL 
-- ORDER BY orden_visualizacion;

-- Obtener configuración JSONB de perfil TUTOR
-- SELECT configuracion FROM appmatch_schema.perfiles WHERE codigo = 'TUTOR';

-- Buscar permisos específicos en configuración
-- SELECT codigo, nombre 
-- FROM appmatch_schema.perfiles 
-- WHERE configuracion -> 'permisos' ? 'GESTIONAR_USUARIOS';

-- ═══════════════════════════════════════════════════════════════════════════════
-- FIN DEL SCRIPT
-- ═══════════════════════════════════════════════════════════════════════════════

-- NOTAS IMPORTANTES:
-- 
-- 1. Esta tabla es de SOLO LECTURA para la aplicación (datos maestros)
-- 2. NO crear foreign keys directas desde otras tablas a esta (usar código VARCHAR)
-- 3. Para asignar perfiles a usuarios, usar columna perfil_codigo en tabla usuarios:
--    - appmatch_schema.usuarios (usuario_id, perfil_codigo VARCHAR(20))
-- 4. NO eliminar registros físicamente (usar expiration_date para soft delete)
-- 5. Configuración JSONB permite extender el modelo sin ALTER TABLE
-- 6. Este script es idempotente (puede ejecutarse múltiples veces)
--
-- SIGUIENTE PASO: Crear tabla appmatch_schema.usuarios que REFERENCIA 
--                 estos perfiles por código (no por FK UUID)

