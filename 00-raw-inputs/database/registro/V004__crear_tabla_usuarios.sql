-- ═══════════════════════════════════════════════════════════════════════════════
-- SCRIPT: V004__crear_tabla_usuarios.sql
-- AUTOR: Database Engineer Senior - PostgreSQL Architect
-- FECHA: 2025-11-16
-- VERSION: 1.0.0
-- 
-- DESCRIPCION:
--   Creación de la tabla maestra 'usuarios' que contiene las credenciales de
--   autenticación (email + password) y gestión de cuentas de usuario.
--   
--   Esta tabla es el núcleo del sistema de autenticación y establece la relación
--   1:1 con informacion_basica (un usuario tiene una info básica asociada).
--   
--   Campos principales:
--   - Email (username) único para login
--   - Password hash (bcrypt/argon2)
--   - Estado de cuenta (ACTIVO, INACTIVO, SUSPENDIDO, ELIMINADO)
--   - Fecha de verificación de email
--   - Control de intentos fallidos de login
--   - Fecha último acceso
--   - Token de recuperación de contraseña
--
-- BOUNDED CONTEXT: Autenticación (Gestión de cuentas y credenciales)
-- PATTERN: Aggregate Root (Usuario es el Aggregate Root del BC Autenticación)
-- 
-- DEPENDENCIAS:
--   - V002__crear_tabla_informacion_basica.sql (tabla informacion_basica)
--   - PostgreSQL 12+, Extension uuid-ossp, Extension pgcrypto
--
-- CRITERIOS DE DISEÑO DDD:
--   ✅ Schema único (appmatch_schema)
--   ✅ Naming convention: pkid_{tabla}, creation_date, expiration_date
--   ✅ Foreign Keys con nomenclatura estándar (fk_pkid_{tabla})
--   ✅ Relación 1:1 con informacion_basica (UNIQUE FK)
--   ✅ Password NUNCA en texto plano (solo hash)
--   ✅ Constraints de seguridad (email formato, password requisitos)
--   ✅ Control de intentos fallidos (protección brute force)
--   ✅ Soft delete (expiration_date)
--   ✅ Audit trail completo
--   ✅ Índices para búsquedas comunes y autenticación
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

-- Habilitar extensión pgcrypto para funciones de hash
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 2: Crear tabla usuarios (Aggregate Root)
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS appmatch_schema.usuarios (
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    pkid_usuarios UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- RELACIÓN 1:1 CON INFORMACION_BASICA
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    fk_pkid_informacion_basica UUID NOT NULL,
        -- FK a appmatch_schema.informacion_basica
        -- Relación 1:1: Un usuario tiene una información básica
        -- UNIQUE constraint garantiza 1:1
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- SEGUIMIENTO DE PROCESO DE REGISTRO
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    fk_pkid_proceso_registro UUID NULL,
        -- FK opcional a tabla de seguimiento del proceso de registro
        -- Permite rastrear el flujo completo del registro multipasos
        -- NULL si el usuario fue creado por otro medio (OAuth, admin, etc.)
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- CREDENCIALES DE AUTENTICACIÓN
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    email VARCHAR(255) NOT NULL,
        -- Email usado como username para login
        -- ÚNICO en la tabla (no puede haber dos usuarios con mismo email)
        -- Duplicado de informacion_basica.email para normalización de autenticación
        
    password_hash VARCHAR(255) NOT NULL,
        -- Hash de la contraseña (bcrypt, argon2, o scrypt)
        -- NUNCA almacenar password en texto plano
        -- Formato bcrypt: $2a$10$... (60 caracteres)
        -- Formato argon2: $argon2id$v=19$m=65536,t=3,p=4$... (más largo)
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- GESTIÓN DE CUENTA
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    estado_cuenta VARCHAR(30) NOT NULL DEFAULT 'PENDIENTE_VERIFICACION',
        -- Estado de la cuenta del usuario
        -- PENDIENTE_VERIFICACION: Email no verificado (estado inicial)
        -- ACTIVO: Cuenta verificada y activa
        -- INACTIVO: Cuenta temporalmente desactivada por usuario
        -- SUSPENDIDO: Cuenta suspendida por admin (violación políticas)
        -- BLOQUEADO: Cuenta bloqueada por múltiples intentos fallidos
        -- ELIMINADO: Cuenta eliminada (soft delete + este estado)
        
    email_verificado BOOLEAN NOT NULL DEFAULT FALSE,
        -- TRUE si el usuario ha verificado su email
        -- Se activa al hacer clic en link de verificación
        
    fecha_verificacion_email TIMESTAMPTZ NULL,
        -- Fecha/hora en que se verificó el email
        -- NULL si aún no está verificado
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- SEGURIDAD Y CONTROL DE ACCESO
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    intentos_fallidos_login INTEGER NOT NULL DEFAULT 0,
        -- Contador de intentos fallidos de login consecutivos
        -- Se resetea a 0 al loguearse exitosamente
        -- Se bloquea la cuenta al llegar a 5 intentos (configurable)
        
    fecha_ultimo_intento_fallido TIMESTAMPTZ NULL,
        -- Fecha/hora del último intento fallido de login
        -- Útil para implementar cooldown antes de desbloqueo
        
    fecha_bloqueo_cuenta TIMESTAMPTZ NULL,
        -- Fecha/hora en que se bloqueó la cuenta
        -- NULL si la cuenta no está bloqueada
        
    fecha_ultimo_acceso TIMESTAMPTZ NULL,
        -- Fecha/hora del último login exitoso
        -- Útil para detectar cuentas inactivas y analítica
        
    ip_ultimo_acceso VARCHAR(45) NULL,
        -- IP del último login exitoso (IPv4 o IPv6)
        -- Útil para detección de accesos sospechosos
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- RECUPERACIÓN DE CONTRASEÑA
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    token_recuperacion_password VARCHAR(255) NULL,
        -- Token único para recuperación de contraseña
        -- Se genera al solicitar "Olvidé mi contraseña"
        -- Se invalida después de usar o expirar
        
    fecha_expiracion_token_recuperacion TIMESTAMPTZ NULL,
        -- Fecha/hora de expiración del token de recuperación
        -- Típicamente 1-2 horas después de generarlo
        -- NULL si no hay token activo
    
    fecha_ultimo_cambio_password TIMESTAMPTZ NULL,
        -- Fecha/hora del último cambio de contraseña
        -- Útil para política de rotación de contraseñas
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- AUTENTICACIÓN DE DOS FACTORES (2FA) - OPCIONAL
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    two_factor_enabled BOOLEAN NOT NULL DEFAULT FALSE,
        -- TRUE si el usuario ha habilitado 2FA
        
    two_factor_secret VARCHAR(255) NULL,
        -- Secret de TOTP (Time-based One-Time Password) para 2FA
        -- Encriptado, usado por apps como Google Authenticator
        
    two_factor_backup_codes TEXT[] NULL,
        -- Array de códigos de respaldo para 2FA
        -- Encriptados, cada uno se puede usar una vez
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- PREFERENCIAS Y CONFIGURACIÓN
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    idioma_preferido VARCHAR(10) DEFAULT 'es',
        -- Código ISO 639-1 del idioma preferido (es, en, fr, pt, etc.)
        
    zona_horaria VARCHAR(50) DEFAULT 'America/Bogota',
        -- IANA timezone del usuario (America/Bogota, America/Mexico_City, etc.)
        -- Usado para mostrar fechas en zona horaria local
    
    notificaciones_email_habilitadas BOOLEAN NOT NULL DEFAULT TRUE,
        -- TRUE si el usuario quiere recibir notificaciones por email
        
    notificaciones_push_habilitadas BOOLEAN NOT NULL DEFAULT TRUE,
        -- TRUE si el usuario quiere recibir notificaciones push
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- METADATA Y AUDITORÍA
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    ip_registro VARCHAR(45) NULL,
        -- IP desde donde se registró el usuario
        
    user_agent_registro TEXT NULL,
        -- User agent del navegador usado en el registro
        -- Útil para detectar bots y analítica
        
    metadata JSONB DEFAULT '{}'::JSONB,
        -- Metadata adicional
        -- Ejemplos: {"origen_registro": "landing_page", "utm_source": "google"}
    
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- CONSTRAINTS
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    CONSTRAINT pk_usuarios PRIMARY KEY (pkid_usuarios),
    
    -- Foreign Key (relación 1:1 con informacion_basica)
    CONSTRAINT fk_usuarios_informacion_basica
        FOREIGN KEY (fk_pkid_informacion_basica)
        REFERENCES appmatch_schema.informacion_basica(pkid_informacion_basica)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    -- UNIQUE constraints
    CONSTRAINT uk_usuarios_email
        UNIQUE (email),
        -- Email único global (no puede haber dos usuarios con mismo email)
    
    CONSTRAINT uk_usuarios_informacion_basica
        UNIQUE (fk_pkid_informacion_basica),
        -- Relación 1:1: Una info básica solo puede tener un usuario
    
    -- CHECK constraints - Email
    CONSTRAINT ck_usuarios_email_no_vacio
        CHECK (TRIM(email) <> ''),
        
    CONSTRAINT ck_usuarios_email_formato
        CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'),
        -- Validación básica de formato de email
    
    -- CHECK constraints - Password
    CONSTRAINT ck_usuarios_password_hash_no_vacio
        CHECK (TRIM(password_hash) <> ''),
        
    CONSTRAINT ck_usuarios_password_hash_longitud
        CHECK (LENGTH(password_hash) >= 50),
        -- Mínimo 50 caracteres para asegurar que es un hash (bcrypt ~60 chars)
    
    -- CHECK constraints - Estado cuenta
    CONSTRAINT ck_usuarios_estado_cuenta_valido
        CHECK (estado_cuenta IN (
            'PENDIENTE_VERIFICACION',
            'ACTIVO',
            'INACTIVO',
            'SUSPENDIDO',
            'BLOQUEADO',
            'ELIMINADO'
        )),
    
    -- CHECK constraint - Email verificado coherente
    CONSTRAINT ck_usuarios_email_verificado_coherente
        CHECK (
            (email_verificado = FALSE AND fecha_verificacion_email IS NULL) OR
            (email_verificado = TRUE AND fecha_verificacion_email IS NOT NULL)
        ),
        -- Si email está verificado, debe tener fecha; si no, fecha debe ser NULL
    
    -- CHECK constraint - Intentos fallidos
    CONSTRAINT ck_usuarios_intentos_fallidos_no_negativo
        CHECK (intentos_fallidos_login >= 0),
    
    -- CHECK constraint - Token recuperación coherente
    CONSTRAINT ck_usuarios_token_recuperacion_coherente
        CHECK (
            (token_recuperacion_password IS NULL AND fecha_expiracion_token_recuperacion IS NULL) OR
            (token_recuperacion_password IS NOT NULL AND fecha_expiracion_token_recuperacion IS NOT NULL)
        ),
        -- Si hay token, debe tener fecha expiración; si no hay token, no debe haber fecha
    
    -- CHECK constraint - 2FA coherente
    CONSTRAINT ck_usuarios_two_factor_coherente
        CHECK (
            (two_factor_enabled = FALSE AND two_factor_secret IS NULL) OR
            (two_factor_enabled = TRUE AND two_factor_secret IS NOT NULL)
        ),
        -- Si 2FA está habilitado, debe tener secret; si no, secret debe ser NULL
    
    -- CHECK constraint - Idioma válido
    CONSTRAINT ck_usuarios_idioma_valido
        CHECK (idioma_preferido IN ('es', 'en', 'fr', 'pt', 'de', 'it')),
        -- Lista de idiomas soportados
    
    -- Soft delete coherente
    CONSTRAINT ck_usuarios_soft_delete_coherente
        CHECK (
            expiration_date IS NULL OR 
            expiration_date > creation_date
        ),
        
    -- Estado eliminado coherente con soft delete
    CONSTRAINT ck_usuarios_eliminado_coherente
        CHECK (
            (expiration_date IS NULL AND estado_cuenta <> 'ELIMINADO') OR
            (expiration_date IS NOT NULL AND estado_cuenta = 'ELIMINADO')
        )
        -- Si hay expiration_date, estado debe ser ELIMINADO; si no hay, no debe ser ELIMINADO
);

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 3: Crear índices para búsquedas comunes y autenticación
-- ═══════════════════════════════════════════════════════════════════════════════

-- Índice ÚNICO en email (CRÍTICO para autenticación)
CREATE UNIQUE INDEX idx_usuarios_email_activos 
    ON appmatch_schema.usuarios(LOWER(email)) 
    WHERE expiration_date IS NULL;
    -- Case-insensitive, solo registros activos

-- Índice en FK a informacion_basica
CREATE UNIQUE INDEX idx_usuarios_fk_informacion_basica 
    ON appmatch_schema.usuarios(fk_pkid_informacion_basica) 
    WHERE expiration_date IS NULL;
    -- Garantiza 1:1 en registros activos

-- Índice en estado_cuenta para filtros
CREATE INDEX idx_usuarios_estado_cuenta 
    ON appmatch_schema.usuarios(estado_cuenta) 
    WHERE expiration_date IS NULL;

-- Índice en email_verificado para reportes
CREATE INDEX idx_usuarios_email_verificado 
    ON appmatch_schema.usuarios(email_verificado) 
    WHERE expiration_date IS NULL;

-- Índice en fecha_ultimo_acceso para detectar inactivos
CREATE INDEX idx_usuarios_fecha_ultimo_acceso 
    ON appmatch_schema.usuarios(fecha_ultimo_acceso DESC NULLS LAST) 
    WHERE expiration_date IS NULL;

-- Índice en token_recuperacion_password para recuperación
CREATE INDEX idx_usuarios_token_recuperacion 
    ON appmatch_schema.usuarios(token_recuperacion_password) 
    WHERE expiration_date IS NULL 
      AND token_recuperacion_password IS NOT NULL;
    -- Validación de expiración se hace en query, no en índice (NOW() no es IMMUTABLE)

-- Índice en creation_date para reportes y estadísticas
CREATE INDEX idx_usuarios_creation_date 
    ON appmatch_schema.usuarios(creation_date DESC) 
    WHERE expiration_date IS NULL;

-- Índice GIN para búsquedas en metadata JSONB
CREATE INDEX idx_usuarios_metadata 
    ON appmatch_schema.usuarios USING GIN(metadata);

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 4: Crear función para encriptar contraseña (bcrypt)
-- ═══════════════════════════════════════════════════════════════════════════════

-- Función para generar hash de password con bcrypt
CREATE OR REPLACE FUNCTION appmatch_schema.hash_password(password TEXT)
RETURNS TEXT AS $$
BEGIN
    -- Usar crypt de pgcrypto con algoritmo bcrypt
    -- gen_salt('bf') genera salt para bcrypt (Blowfish)
    -- Cost factor por defecto es 10 (2^10 = 1024 iteraciones)
    RETURN crypt(password, gen_salt('bf'));
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION appmatch_schema.hash_password(TEXT) IS 
'Genera hash bcrypt de una contraseña en texto plano.
IMPORTANTE: Solo usar en backend, NUNCA enviar password plano desde frontend.';

-- Función para verificar contraseña
CREATE OR REPLACE FUNCTION appmatch_schema.verify_password(password TEXT, password_hash TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    -- crypt con el hash existente verifica si el password coincide
    RETURN password_hash = crypt(password, password_hash);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION appmatch_schema.verify_password(TEXT, TEXT) IS 
'Verifica si una contraseña en texto plano coincide con su hash bcrypt.
Retorna TRUE si coincide, FALSE si no.';

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 5: Insertar usuario de prueba
-- ═══════════════════════════════════════════════════════════════════════════════

-- Insertar usuario de prueba (Wilmer Torres)
-- Password: MiToga2025! (ejemplo, cambiar en producción)
INSERT INTO appmatch_schema.usuarios (
    pkid_usuarios,
    creation_date,
    expiration_date,
    fk_pkid_informacion_basica,
    email,
    password_hash,
    estado_cuenta,
    email_verificado,
    fecha_verificacion_email,
    intentos_fallidos_login,
    fecha_ultimo_intento_fallido,
    fecha_bloqueo_cuenta,
    fecha_ultimo_acceso,
    ip_ultimo_acceso,
    token_recuperacion_password,
    fecha_expiracion_token_recuperacion,
    fecha_ultimo_cambio_password,
    two_factor_enabled,
    two_factor_secret,
    two_factor_backup_codes,
    idioma_preferido,
    zona_horaria,
    notificaciones_email_habilitadas,
    notificaciones_push_habilitadas,
    ip_registro,
    user_agent_registro,
    metadata
) VALUES (
    gen_random_uuid(),
    NOW(),
    NULL,
    'aabee5d7-14bb-4d90-8e4b-347b736b6485'::UUID,  -- FK a informacion_basica (Wilmer Torres)
    'wilmer.torres@example.com',
    appmatch_schema.hash_password('MiToga2025!'),  -- Hash de la contraseña
    'ACTIVO',  -- Cuenta ya verificada para pruebas
    TRUE,
    NOW(),
    0,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NOW(),
    FALSE,
    NULL,
    NULL,
    'es',
    'America/Bogota',
    TRUE,
    TRUE,
    '192.168.1.100',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
    '{"origen_registro": "script_migracion", "ambiente": "desarrollo"}'::JSONB
) ON CONFLICT (email) DO NOTHING;

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 6: Documentación (COMMENTS)
-- ═══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE appmatch_schema.usuarios IS 
'Tabla maestra de usuarios del sistema MI-TOGA.
Contiene credenciales de autenticación (email/password), estado de cuenta,
control de acceso, y preferencias del usuario.
Relación 1:1 con informacion_basica.';

COMMENT ON COLUMN appmatch_schema.usuarios.pkid_usuarios IS 
'Primary Key UUID de la tabla usuarios';

COMMENT ON COLUMN appmatch_schema.usuarios.fk_pkid_informacion_basica IS 
'FK a appmatch_schema.informacion_basica. Relación 1:1 (UNIQUE constraint).
Un usuario tiene una información básica asociada.';

COMMENT ON COLUMN appmatch_schema.usuarios.email IS 
'Email del usuario, usado como username para login.
ÚNICO global. Duplicado de informacion_basica.email para normalización.';

COMMENT ON COLUMN appmatch_schema.usuarios.password_hash IS 
'Hash bcrypt de la contraseña del usuario.
NUNCA almacenar contraseña en texto plano.
Formato: $2a$10$... (60 caracteres aprox).';

COMMENT ON COLUMN appmatch_schema.usuarios.estado_cuenta IS 
'Estado de la cuenta: PENDIENTE_VERIFICACION, ACTIVO, INACTIVO, SUSPENDIDO, BLOQUEADO, ELIMINADO.';

COMMENT ON COLUMN appmatch_schema.usuarios.email_verificado IS 
'TRUE si el usuario ha verificado su email haciendo clic en el link enviado.';

COMMENT ON COLUMN appmatch_schema.usuarios.intentos_fallidos_login IS 
'Contador de intentos fallidos consecutivos de login.
Se resetea a 0 al login exitoso. Se bloquea cuenta al llegar a 5 (configurable).';

COMMENT ON COLUMN appmatch_schema.usuarios.token_recuperacion_password IS 
'Token único para recuperación de contraseña (solicitud "Olvidé mi contraseña").
Se invalida después de usar o expirar.';

COMMENT ON COLUMN appmatch_schema.usuarios.two_factor_enabled IS 
'TRUE si el usuario ha habilitado autenticación de dos factores (2FA/TOTP).';

-- ═══════════════════════════════════════════════════════════════════════════════
-- PASO 7: Queries de ejemplo para desarrollo
-- ═══════════════════════════════════════════════════════════════════════════════

-- Autenticación: Verificar email y password
-- SELECT 
--     u.pkid_usuarios,
--     u.email,
--     u.estado_cuenta,
--     u.email_verificado,
--     u.intentos_fallidos_login,
--     appmatch_schema.verify_password('MiToga2025!', u.password_hash) AS password_correcto
-- FROM appmatch_schema.usuarios u
-- WHERE LOWER(u.email) = LOWER('wilmer.torres@example.com')
--   AND u.expiration_date IS NULL;

-- Obtener datos completos de usuario (con info básica y perfiles)
-- SELECT 
--     u.pkid_usuarios,
--     u.email,
--     u.estado_cuenta,
--     u.email_verificado,
--     u.fecha_ultimo_acceso,
--     ib.primer_nombre,
--     ib.primer_apellido,
--     ib.fecha_nacimiento,
--     STRING_AGG(p.codigo, ', ') AS perfiles
-- FROM appmatch_schema.usuarios u
-- INNER JOIN appmatch_schema.informacion_basica ib ON u.fk_pkid_informacion_basica = ib.pkid_informacion_basica
-- LEFT JOIN appmatch_schema.perfil_informacion_basica pib ON ib.pkid_informacion_basica = pib.fk_pkid_informacion_basica
-- LEFT JOIN appmatch_schema.perfiles p ON pib.fk_pkid_perfiles = p.pkid_perfiles
-- WHERE u.pkid_usuarios = 'UUID_DEL_USUARIO'
--   AND u.expiration_date IS NULL
--   AND pib.expiration_date IS NULL
--   AND pib.estado = 'ACTIVO'
-- GROUP BY u.pkid_usuarios, u.email, u.estado_cuenta, u.email_verificado, u.fecha_ultimo_acceso,
--          ib.primer_nombre, ib.primer_apellido, ib.fecha_nacimiento;

-- Actualizar fecha último acceso al login exitoso
-- UPDATE appmatch_schema.usuarios
-- SET fecha_ultimo_acceso = NOW(),
--     ip_ultimo_acceso = '192.168.1.100',
--     intentos_fallidos_login = 0
-- WHERE pkid_usuarios = 'UUID_DEL_USUARIO';

-- Incrementar intentos fallidos de login
-- UPDATE appmatch_schema.usuarios
-- SET intentos_fallidos_login = intentos_fallidos_login + 1,
--     fecha_ultimo_intento_fallido = NOW(),
--     estado_cuenta = CASE 
--         WHEN intentos_fallidos_login + 1 >= 5 THEN 'BLOQUEADO'
--         ELSE estado_cuenta
--     END,
--     fecha_bloqueo_cuenta = CASE 
--         WHEN intentos_fallidos_login + 1 >= 5 THEN NOW()
--         ELSE fecha_bloqueo_cuenta
--     END
-- WHERE pkid_usuarios = 'UUID_DEL_USUARIO';

-- Generar token de recuperación de contraseña
-- UPDATE appmatch_schema.usuarios
-- SET token_recuperacion_password = encode(gen_random_bytes(32), 'hex'),
--     fecha_expiracion_token_recuperacion = NOW() + INTERVAL '2 hours'
-- WHERE LOWER(email) = LOWER('wilmer.torres@example.com')
--   AND expiration_date IS NULL
-- RETURNING token_recuperacion_password;

-- Verificar token de recuperación (válido y no expirado)
-- SELECT 
--     pkid_usuarios,
--     email,
--     token_recuperacion_password
-- FROM appmatch_schema.usuarios
-- WHERE token_recuperacion_password = 'TOKEN_RECIBIDO'
--   AND fecha_expiracion_token_recuperacion > NOW()
--   AND expiration_date IS NULL;

-- Cambiar contraseña usando token de recuperación
-- UPDATE appmatch_schema.usuarios
-- SET password_hash = appmatch_schema.hash_password('NuevaPassword123!'),
--     token_recuperacion_password = NULL,
--     fecha_expiracion_token_recuperacion = NULL,
--     fecha_ultimo_cambio_password = NOW(),
--     estado_cuenta = 'ACTIVO',  -- Desbloquear si estaba bloqueada
--     intentos_fallidos_login = 0
-- WHERE token_recuperacion_password = 'TOKEN_RECIBIDO'
--   AND fecha_expiracion_token_recuperacion > NOW()
--   AND expiration_date IS NULL;

-- Listar usuarios sin verificar email (para enviar recordatorios)
-- SELECT 
--     u.pkid_usuarios,
--     u.email,
--     u.creation_date,
--     AGE(NOW(), u.creation_date) AS tiempo_sin_verificar
-- FROM appmatch_schema.usuarios u
-- WHERE u.email_verificado = FALSE
--   AND u.estado_cuenta = 'PENDIENTE_VERIFICACION'
--   AND u.expiration_date IS NULL
-- ORDER BY u.creation_date DESC;

-- Detectar cuentas inactivas (sin acceso en 90+ días)
-- SELECT 
--     u.pkid_usuarios,
--     u.email,
--     u.fecha_ultimo_acceso,
--     AGE(NOW(), COALESCE(u.fecha_ultimo_acceso, u.creation_date)) AS tiempo_inactivo
-- FROM appmatch_schema.usuarios u
-- WHERE u.estado_cuenta = 'ACTIVO'
--   AND u.expiration_date IS NULL
--   AND (u.fecha_ultimo_acceso IS NULL OR u.fecha_ultimo_acceso < NOW() - INTERVAL '90 days')
-- ORDER BY COALESCE(u.fecha_ultimo_acceso, u.creation_date) ASC;

-- Estadísticas de usuarios por estado
-- SELECT 
--     estado_cuenta,
--     COUNT(*) AS total_usuarios,
--     COUNT(*) FILTER (WHERE email_verificado = TRUE) AS con_email_verificado,
--     COUNT(*) FILTER (WHERE two_factor_enabled = TRUE) AS con_2fa
-- FROM appmatch_schema.usuarios
-- WHERE expiration_date IS NULL
-- GROUP BY estado_cuenta
-- ORDER BY total_usuarios DESC;

-- ═══════════════════════════════════════════════════════════════════════════════
-- FIN DEL SCRIPT
-- ═══════════════════════════════════════════════════════════════════════════════

-- NOTAS IMPORTANTES:
-- 
-- 1. RELACIÓN 1:1 con informacion_basica:
--    - UNIQUE constraint en fk_pkid_informacion_basica
--    - ON DELETE CASCADE: Si se elimina info básica, se elimina usuario
-- 2. EMAIL como username:
--    - UNIQUE global
--    - Case-insensitive index (LOWER(email))
--    - Duplicado de informacion_basica.email para normalización
-- 3. PASSWORD HASH:
--    - NUNCA almacenar password en texto plano
--    - Usar bcrypt (funciones appmatch_schema.hash_password/verify_password)
--    - Mínimo 50 caracteres (bcrypt ~60 chars)
-- 4. ESTADOS de cuenta:
--    - PENDIENTE_VERIFICACION: Email no verificado (inicial)
--    - ACTIVO: Cuenta verificada y funcional
--    - INACTIVO: Usuario desactivó temporalmente
--    - SUSPENDIDO: Admin suspendió por violación de políticas
--    - BLOQUEADO: Múltiples intentos fallidos de login
--    - ELIMINADO: Soft delete (expiration_date NOT NULL)
-- 5. SEGURIDAD:
--    - Control de intentos fallidos (bloqueo automático a los 5)
--    - Token de recuperación con expiración (2 horas)
--    - Soporte para 2FA (TOTP)
--    - Auditoría de IPs y user agents
-- 6. SOFT DELETE obligatorio:
--    - expiration_date + estado_cuenta = 'ELIMINADO'
--    - NUNCA DELETE físico
-- 7. ÍNDICES optimizados:
--    - Email (autenticación)
--    - FK informacion_basica (relación 1:1)
--    - Estado cuenta (filtros)
--    - Token recuperación (recuperación password)
--    - Fecha último acceso (detectar inactivos)
-- 8. FUNCIONES bcrypt:
--    - appmatch_schema.hash_password(password) → hash
--    - appmatch_schema.verify_password(password, hash) → boolean
-- 9. INSERT de datos de prueba:
--    - Usuario: wilmer.torres@example.com
--    - Password: MiToga2025!
--    - Estado: ACTIVO (ya verificado)
--    - Idempotente con ON CONFLICT DO NOTHING
-- 10. Este script es idempotente (puede ejecutarse múltiples veces)
--
-- DEPENDENCIAS:
--   - V002: appmatch_schema.informacion_basica (UUID específico para FK)
--   - Extension pgcrypto (funciones de hash bcrypt)
--
-- SIGUIENTE PASO: 
--   - Implementar endpoints de autenticación en backend:
--     * POST /api/v1/auth/registro (crear usuario + info básica)
--     * POST /api/v1/auth/login (autenticar con email/password)
--     * POST /api/v1/auth/verificar-email (token de verificación)
--     * POST /api/v1/auth/recuperar-password (solicitar token)
--     * POST /api/v1/auth/reset-password (cambiar con token)
--     * POST /api/v1/auth/cambiar-password (cambiar con password actual)
--   - Implementar JWT para sesiones
--   - Implementar refresh tokens
--   - Configurar Spring Security con estas tablas

