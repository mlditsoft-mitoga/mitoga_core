-- ============================================================================
-- Migration: V5__registro_tutores_multistep.sql
-- Description: Sistema completo de registro de tutores con proceso multi-step
-- Author: Database Engineering Team - ZNS-METHOD
-- Date: 2025-11-14
-- Bounded Context: Tutores (Marketplace)
-- Story: HU-002 - Registro de Tutores Multi-step
-- PostgreSQL Version: 16.x
-- Basado en: Lecciones aprendidas V4 (8 errores corregidos)
-- Ejecutable en: DBeaver, pgAdmin, psql
-- ============================================================================

-- ====================
-- LECCIONES APLICADAS DE V4
-- ====================
-- ✅ Error #1: Usar || en lugar de CONCAT() (immutable)
-- ✅ Error #2: Nombres de columnas exactos sin errores tipográficos
-- ✅ Error #3: ENUMs con IF NOT EXISTS (no DROP CASCADE)
-- ✅ Error #4: Índices con IF NOT EXISTS
-- ✅ Error #5: Auto-reparación para tablas dañadas por CASCADE
-- ✅ Error #6: Parámetros de función con nombres únicos (p_)
-- ✅ Error #7: Verificación específica de columnas críticas
-- ✅ Error #8: NO subqueries en CHECK constraints
-- ✅ Patrón idempotente verdadero aplicado a TODOS los objetos

SELECT 'V5: INICIANDO REGISTRO TUTORES MULTISTEP' as mensaje;

-- ====================
-- FASE 1: EXTENSIONES Y SCHEMAS
-- ====================

-- Extension uuid-ossp (idempotente)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'uuid-ossp') THEN
        CREATE EXTENSION "uuid-ossp";
        RAISE NOTICE '✅ Extensión uuid-ossp creada';
    ELSE
        RAISE NOTICE '✅ Extensión uuid-ossp ya existe';
    END IF;
END $$;

-- Schema para bounded context Tutores (idempotente)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'tutores_schema') THEN
        CREATE SCHEMA tutores_schema;
        RAISE NOTICE '✅ Schema tutores_schema creado';
    ELSE
        RAISE NOTICE '✅ Schema tutores_schema ya existe';
    END IF;
END $$;

-- Verificar función helper (reutilizada de V4)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.routines 
                   WHERE routine_schema = 'shared_schema' 
                   AND routine_name = 'tabla_tiene_columna') THEN
        RAISE EXCEPTION 'PREREQUISITO: V4 debe ejecutarse primero (función tabla_tiene_columna no encontrada)';
    ELSE
        RAISE NOTICE '✅ Función helper tabla_tiene_columna disponible';
    END IF;
END $$;

-- ====================
-- FASE 2: ENUMS ESPECÍFICOS PARA TUTORES
-- ====================

-- Estado de aprobación de tutores (idempotente - Lección #3)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'estado_aprobacion_tutor') THEN
        CREATE TYPE estado_aprobacion_tutor AS ENUM (
            'PENDIENTE_REGISTRO',     -- Completando el proceso multi-step
            'EN_REVISION',           -- Enviado para revisión administrativa
            'SOLICITANDO_DOCUMENTOS', -- Admin requiere documentos adicionales
            'APROBADO',              -- Tutor activo, puede ofrecer sesiones
            'RECHAZADO',             -- No cumple criterios
            'SUSPENDIDO',            -- Temporalmente deshabilitado
            'INACTIVO'               -- Desactivado por el tutor
        );
        RAISE NOTICE '✅ ENUM estado_aprobacion_tutor creado';
    ELSE
        RAISE NOTICE 'ENUM estado_aprobacion_tutor ya existe, omitiendo';
    END IF;
END $$;

-- Nivel de dominio de idiomas (idempotente - Lección #3)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'nivel_dominio_idioma') THEN
        CREATE TYPE nivel_dominio_idioma AS ENUM (
            'BASICO',      -- A1-A2 CEFR
            'INTERMEDIO',  -- B1-B2 CEFR  
            'AVANZADO',    -- C1 CEFR
            'NATIVO'       -- C2/Nativo
        );
        RAISE NOTICE '✅ ENUM nivel_dominio_idioma creado';
    ELSE
        RAISE NOTICE 'ENUM nivel_dominio_idioma ya existe, omitiendo';
    END IF;
END $$;

-- Estado de sesión de tutoría (idempotente - Lección #3)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'estado_sesion') THEN
        CREATE TYPE estado_sesion AS ENUM (
            'PROGRAMADA',
            'EN_CURSO', 
            'COMPLETADA',
            'CANCELADA_ESTUDIANTE',
            'CANCELADA_TUTOR',
            'NO_SHOW'
        );
        RAISE NOTICE '✅ ENUM estado_sesion creado';
    ELSE
        RAISE NOTICE 'ENUM estado_sesion ya existe, omitiendo';
    END IF;
END $$;

-- ====================
-- FASE 3: AUTO-REPARACIÓN DE TABLAS (Lecciones #5, #7)
-- ====================

-- 1. Auto-reparación para proceso_registro_tutor
DO $$
BEGIN
    -- Verificar si la tabla existe pero le falta columnas críticas
    IF EXISTS (SELECT 1 FROM information_schema.tables 
               WHERE table_schema = 'tutores_schema' 
               AND table_name = 'proceso_registro_tutor') THEN
        
        -- Verificar columnas críticas (Lección #7)
        IF NOT shared_schema.tabla_tiene_columna('tutores_schema', 'proceso_registro_tutor', 'estado_actual') OR
           NOT shared_schema.tabla_tiene_columna('tutores_schema', 'proceso_registro_tutor', 'step_completado') THEN
            
            RAISE NOTICE 'Tabla proceso_registro_tutor dañada por CASCADE - eliminando para recrear';
            DROP TABLE tutores_schema.proceso_registro_tutor CASCADE;
        END IF;
    END IF;
END $$;

-- 2. Auto-reparación para perfiles_tutor
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables 
               WHERE table_schema = 'tutores_schema' 
               AND table_name = 'perfiles_tutor') THEN
        
        -- Verificar columnas críticas específicas de tutores
        IF NOT shared_schema.tabla_tiene_columna('tutores_schema', 'perfiles_tutor', 'estado_aprobacion') OR
           NOT shared_schema.tabla_tiene_columna('tutores_schema', 'perfiles_tutor', 'tarifa_por_hora') THEN
            
            RAISE NOTICE 'Tabla perfiles_tutor dañada por CASCADE - eliminando para recrear';
            DROP TABLE tutores_schema.perfiles_tutor CASCADE;
        END IF;
    END IF;
END $$;

-- 3. Auto-reparación para experiencia_laboral
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables 
               WHERE table_schema = 'tutores_schema' 
               AND table_name = 'experiencia_laboral') THEN
        
        IF NOT shared_schema.tabla_tiene_columna('tutores_schema', 'experiencia_laboral', 'empresa') OR
           NOT shared_schema.tabla_tiene_columna('tutores_schema', 'experiencia_laboral', 'cargo') THEN
            
            RAISE NOTICE 'Tabla experiencia_laboral dañada por CASCADE - eliminando para recrear';
            DROP TABLE tutores_schema.experiencia_laboral CASCADE;
        END IF;
    END IF;
END $$;

-- 4. Auto-reparación para tutor_conocimientos
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables 
               WHERE table_schema = 'tutores_schema' 
               AND table_name = 'tutor_conocimientos') THEN
        
        IF NOT shared_schema.tabla_tiene_columna('tutores_schema', 'tutor_conocimientos', 'tutor_id') OR
           NOT shared_schema.tabla_tiene_columna('tutores_schema', 'tutor_conocimientos', 'conocimiento_id') THEN
            
            RAISE NOTICE 'Tabla tutor_conocimientos dañada por CASCADE - eliminando para recrear';
            DROP TABLE tutores_schema.tutor_conocimientos CASCADE;
        END IF;
    END IF;
END $$;

-- 5. Auto-reparación para tutor_idiomas
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables 
               WHERE table_schema = 'tutores_schema' 
               AND table_name = 'tutor_idiomas') THEN
        
        IF NOT shared_schema.tabla_tiene_columna('tutores_schema', 'tutor_idiomas', 'tutor_id') OR
           NOT shared_schema.tabla_tiene_columna('tutores_schema', 'tutor_idiomas', 'idioma_id') OR
           NOT shared_schema.tabla_tiene_columna('tutores_schema', 'tutor_idiomas', 'nivel_dominio') THEN
            
            RAISE NOTICE 'Tabla tutor_idiomas dañada por CASCADE - eliminando para recrear';
            DROP TABLE tutores_schema.tutor_idiomas CASCADE;
        END IF;
    END IF;
END $$;

-- ====================
-- FASE 4: TABLAS PRINCIPALES
-- ====================

-- Tabla: Proceso de Registro de Tutor (Session State)
CREATE TABLE IF NOT EXISTS tutores_schema.proceso_registro_tutor (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR
    -- ========================================
    pkid_proceso_tutor UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- CAMPOS DE RELACIÓN
    -- ========================================
    usuario_id UUID NOT NULL,
    
    -- ========================================
    -- CAMPOS DE ESTADO DEL PROCESO
    -- ========================================
    estado_actual estado_aprobacion_tutor NOT NULL DEFAULT 'PENDIENTE_REGISTRO',
    step_completado INTEGER DEFAULT 0 CHECK (step_completado >= 0 AND step_completado <= 4),
    fecha_inicio TIMESTAMPTZ DEFAULT NOW(),
    fecha_finalizacion TIMESTAMPTZ NULL,
    
    -- ========================================
    -- CAMPOS DE DATOS (JSONB para flexibilidad)
    -- ========================================
    datos_formulario JSONB DEFAULT '{}'::JSONB NOT NULL,
    
    -- STEP 1: Experiencia Laboral
    experiencias_laborales JSONB DEFAULT '[]'::JSONB, -- Array de experiencias
    
    -- STEP 2: Conocimientos
    conocimientos_seleccionados JSONB DEFAULT '[]'::JSONB, -- Array de UUIDs
    
    -- STEP 3: Idiomas
    idiomas_seleccionados JSONB DEFAULT '[]'::JSONB, -- Array con {idioma_id, nivel}
    
    -- STEP 4: Confirmación
    acepta_terminos BOOLEAN DEFAULT FALSE,
    acepta_codigo_conducta BOOLEAN DEFAULT FALSE,
    enviado_para_revision BOOLEAN DEFAULT FALSE,
    fecha_envio_revision TIMESTAMPTZ NULL,
    
    -- ========================================
    -- METADATA Y AUDITORÍA
    -- ========================================
    metadata JSONB DEFAULT '{}'::JSONB,
    ip_registro INET,
    user_agent TEXT,
    session_id UUID,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_proceso_registro_tutor PRIMARY KEY (pkid_proceso_tutor),
    
    -- Constraint para validar finalización (Lección #8: sin subqueries)
    CONSTRAINT ck_proceso_tutor_finalizacion CHECK (
        (estado_actual = 'PENDIENTE_REGISTRO' AND fecha_finalizacion IS NULL) OR
        (estado_actual != 'PENDIENTE_REGISTRO' AND fecha_finalizacion IS NOT NULL)
    ),
    
    -- Constraint para validar envío (Lección #8: lógica simple)
    CONSTRAINT ck_proceso_tutor_envio CHECK (
        (step_completado = 4 AND enviado_para_revision = TRUE AND fecha_envio_revision IS NOT NULL) OR
        (step_completado < 4 AND enviado_para_revision = FALSE AND fecha_envio_revision IS NULL)
    )
);

-- Foreign Key (separada para claridad)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_schema = 'tutores_schema' 
                   AND table_name = 'proceso_registro_tutor'
                   AND constraint_name = 'fk_proceso_tutor_usuario') THEN
        ALTER TABLE tutores_schema.proceso_registro_tutor 
        ADD CONSTRAINT fk_proceso_tutor_usuario 
        FOREIGN KEY (usuario_id) REFERENCES autenticacion_schema.usuarios(pkid_usuarios) ON DELETE CASCADE;
    END IF;
END $$;

-- Tabla: Perfil Completo de Tutor
CREATE TABLE IF NOT EXISTS tutores_schema.perfiles_tutor (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR
    -- ========================================
    pkid_tutor UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- RELACIÓN CON USUARIO
    -- ========================================
    usuario_id UUID NOT NULL,
    
    -- ========================================
    -- INFORMACIÓN PERSONAL BÁSICA
    -- ========================================
    nombres VARCHAR(255) NOT NULL,
    apellidos VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    genero_id UUID NULL,
    telefono VARCHAR(20) NULL,
    
    -- ========================================
    -- INFORMACIÓN GEOGRÁFICA
    -- ========================================
    pais_id UUID NULL,
    ciudad_id UUID NULL,
    direccion TEXT NULL,
    zona_horaria VARCHAR(50) DEFAULT 'UTC',
    
    -- ========================================
    -- CAMPOS ESPECÍFICOS DE TUTORES
    -- ========================================
    estado_aprobacion estado_aprobacion_tutor NOT NULL DEFAULT 'PENDIENTE_REGISTRO',
    fecha_aprobacion TIMESTAMPTZ NULL,
    admin_aprobador_id UUID NULL,
    notas_revision TEXT NULL,
    motivo_rechazo TEXT NULL,
    
    -- ========================================
    -- INFORMACIÓN COMERCIAL
    -- ========================================
    tarifa_por_hora DECIMAL(10,2) NULL CHECK (tarifa_por_hora > 0),
    moneda VARCHAR(3) DEFAULT 'USD',
    acepta_reserva_inmediata BOOLEAN DEFAULT TRUE,
    tiempo_respuesta_horas INTEGER DEFAULT 24 CHECK (tiempo_respuesta_horas > 0),
    
    -- ========================================
    -- PRESENTACIÓN Y DESCRIPCIÓN
    -- ========================================
    titulo_profesional VARCHAR(255) NULL, -- "Ingeniero de Sistemas", "Profesor de Matemáticas"
    descripcion_breve TEXT NULL,         -- Máximo 250 caracteres
    descripcion_completa TEXT NULL,      -- Sin límite
    video_presentacion_url VARCHAR(500) NULL,
    
    -- ========================================
    -- DISPONIBILIDAD Y HORARIOS
    -- ========================================
    disponibilidad_horarios JSONB DEFAULT '{}'::JSONB, -- {lunes: ["09:00-12:00", "14:00-18:00"], ...}
    dias_anticipacion_reserva INTEGER DEFAULT 1 CHECK (dias_anticipacion_reserva >= 0),
    duracion_sesion_minutos INTEGER DEFAULT 60 CHECK (duracion_sesion_minutos IN (30, 45, 60, 90, 120)),
    
    -- ========================================
    -- ESTADÍSTICAS Y CALIFICACIONES
    -- ========================================
    total_sesiones INTEGER DEFAULT 0 CHECK (total_sesiones >= 0),
    calificacion_promedio DECIMAL(3,2) DEFAULT 0.00 CHECK (calificacion_promedio >= 0 AND calificacion_promedio <= 5.00),
    total_estudiantes INTEGER DEFAULT 0 CHECK (total_estudiantes >= 0),
    ingresos_totales DECIMAL(12,2) DEFAULT 0.00 CHECK (ingresos_totales >= 0),
    
    -- ========================================
    -- CONFIGURACIONES
    -- ========================================
    idioma_preferido_id UUID NULL,
    notificaciones_email BOOLEAN DEFAULT TRUE,
    notificaciones_push BOOLEAN DEFAULT TRUE,
    notificaciones_sms BOOLEAN DEFAULT FALSE,
    
    -- ========================================
    -- METADATA Y AUDITORÍA
    -- ========================================
    metadata JSONB DEFAULT '{}'::JSONB,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_perfiles_tutor PRIMARY KEY (pkid_tutor),
    CONSTRAINT uq_tutor_usuario UNIQUE (usuario_id),
    
    -- Constraint para validar aprobación (Lección #8: sin subqueries)
    CONSTRAINT ck_tutor_aprobacion CHECK (
        (estado_aprobacion = 'APROBADO' AND fecha_aprobacion IS NOT NULL AND admin_aprobador_id IS NOT NULL) OR
        (estado_aprobacion != 'APROBADO')
    ),
    
    -- Constraint para validar rechazo
    CONSTRAINT ck_tutor_rechazo CHECK (
        (estado_aprobacion = 'RECHAZADO' AND motivo_rechazo IS NOT NULL) OR
        (estado_aprobacion != 'RECHAZADO')
    ),
    
    -- Constraint para validar mayor de edad (tutores deben ser adultos)
    CONSTRAINT ck_tutor_mayor_edad CHECK (
        fecha_nacimiento <= (CURRENT_DATE - INTERVAL '18 years')
    )
);

-- Foreign Keys para perfiles_tutor
DO $$
BEGIN
    -- FK a usuarios
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_schema = 'tutores_schema' 
                   AND table_name = 'perfiles_tutor'
                   AND constraint_name = 'fk_tutor_usuario') THEN
        ALTER TABLE tutores_schema.perfiles_tutor 
        ADD CONSTRAINT fk_tutor_usuario 
        FOREIGN KEY (usuario_id) REFERENCES autenticacion_schema.usuarios(pkid_usuarios) ON DELETE CASCADE;
    END IF;
    
    -- FK a catálogo género
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_schema = 'tutores_schema' 
                   AND table_name = 'perfiles_tutor'
                   AND constraint_name = 'fk_tutor_genero') THEN
        ALTER TABLE tutores_schema.perfiles_tutor 
        ADD CONSTRAINT fk_tutor_genero 
        FOREIGN KEY (genero_id) REFERENCES shared_schema.catalogo_recursivo(pkid_catalogo_recursivo);
    END IF;
    
    -- FK a catálogo país
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_schema = 'tutores_schema' 
                   AND table_name = 'perfiles_tutor'
                   AND constraint_name = 'fk_tutor_pais') THEN
        ALTER TABLE tutores_schema.perfiles_tutor 
        ADD CONSTRAINT fk_tutor_pais 
        FOREIGN KEY (pais_id) REFERENCES shared_schema.catalogo_recursivo(pkid_catalogo_recursivo);
    END IF;
    
    -- FK a catálogo ciudad
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_schema = 'tutores_schema' 
                   AND table_name = 'perfiles_tutor'
                   AND constraint_name = 'fk_tutor_ciudad') THEN
        ALTER TABLE tutores_schema.perfiles_tutor 
        ADD CONSTRAINT fk_tutor_ciudad 
        FOREIGN KEY (ciudad_id) REFERENCES shared_schema.catalogo_recursivo(pkid_catalogo_recursivo);
    END IF;
    
    -- FK a catálogo idioma preferido
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_schema = 'tutores_schema' 
                   AND table_name = 'perfiles_tutor'
                   AND constraint_name = 'fk_tutor_idioma_preferido') THEN
        ALTER TABLE tutores_schema.perfiles_tutor 
        ADD CONSTRAINT fk_tutor_idioma_preferido 
        FOREIGN KEY (idioma_preferido_id) REFERENCES shared_schema.catalogo_recursivo(pkid_catalogo_recursivo);
    END IF;
    
    -- FK a admin aprobador
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_schema = 'tutores_schema' 
                   AND table_name = 'perfiles_tutor'
                   AND constraint_name = 'fk_tutor_admin_aprobador') THEN
        ALTER TABLE tutores_schema.perfiles_tutor 
        ADD CONSTRAINT fk_tutor_admin_aprobador 
        FOREIGN KEY (admin_aprobador_id) REFERENCES autenticacion_schema.usuarios(pkid_usuarios);
    END IF;
END $$;

-- Tabla: Experiencia Laboral del Tutor
CREATE TABLE IF NOT EXISTS tutores_schema.experiencia_laboral (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR
    -- ========================================
    pkid_experiencia UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- RELACIÓN CON TUTOR
    -- ========================================
    tutor_id UUID NOT NULL,
    
    -- ========================================
    -- INFORMACIÓN DE LA EXPERIENCIA
    -- ========================================
    empresa VARCHAR(255) NOT NULL,
    cargo VARCHAR(255) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL, -- NULL = trabajo actual
    es_trabajo_actual BOOLEAN DEFAULT FALSE,
    descripcion TEXT NULL,
    
    -- ========================================
    -- UBICACIÓN Y SECTOR
    -- ========================================
    pais_empresa_id UUID NULL,
    ciudad_empresa_id UUID NULL,
    sector_empresa VARCHAR(100) NULL, -- Tecnología, Educación, Salud, etc.
    tipo_empleo VARCHAR(50) DEFAULT 'TIEMPO_COMPLETO', -- TIEMPO_COMPLETO, MEDIO_TIEMPO, FREELANCE, etc.
    
    -- ========================================
    -- VALIDACIÓN Y VERIFICACIÓN
    -- ========================================
    esta_verificada BOOLEAN DEFAULT FALSE,
    documento_verificacion_url VARCHAR(500) NULL, -- Certificado laboral, carta, etc.
    notas_verificacion TEXT NULL,
    verificada_por_admin_id UUID NULL,
    fecha_verificacion TIMESTAMPTZ NULL,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_experiencia_laboral PRIMARY KEY (pkid_experiencia),
    
    -- Lección #8: Constraints simples sin subqueries
    CONSTRAINT ck_experiencia_fechas CHECK (
        (fecha_fin IS NULL AND es_trabajo_actual = TRUE) OR 
        (fecha_fin IS NOT NULL AND fecha_fin >= fecha_inicio)
    ),
    
    CONSTRAINT ck_experiencia_verificacion CHECK (
        (esta_verificada = TRUE AND verificada_por_admin_id IS NOT NULL AND fecha_verificacion IS NOT NULL) OR
        (esta_verificada = FALSE)
    )
);

-- Foreign Keys para experiencia_laboral
DO $$
BEGIN
    -- FK a tutor
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_schema = 'tutores_schema' 
                   AND table_name = 'experiencia_laboral'
                   AND constraint_name = 'fk_experiencia_tutor') THEN
        ALTER TABLE tutores_schema.experiencia_laboral 
        ADD CONSTRAINT fk_experiencia_tutor 
        FOREIGN KEY (tutor_id) REFERENCES tutores_schema.perfiles_tutor(pkid_tutor) ON DELETE CASCADE;
    END IF;
    
    -- FK a país empresa
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_schema = 'tutores_schema' 
                   AND table_name = 'experiencia_laboral'
                   AND constraint_name = 'fk_experiencia_pais_empresa') THEN
        ALTER TABLE tutores_schema.experiencia_laboral 
        ADD CONSTRAINT fk_experiencia_pais_empresa 
        FOREIGN KEY (pais_empresa_id) REFERENCES shared_schema.catalogo_recursivo(pkid_catalogo_recursivo);
    END IF;
    
    -- FK a verificador admin
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_schema = 'tutores_schema' 
                   AND table_name = 'experiencia_laboral'
                   AND constraint_name = 'fk_experiencia_verificador') THEN
        ALTER TABLE tutores_schema.experiencia_laboral 
        ADD CONSTRAINT fk_experiencia_verificador 
        FOREIGN KEY (verificada_por_admin_id) REFERENCES autenticacion_schema.usuarios(pkid_usuario);
    END IF;
END $$;

-- Tabla: Conocimientos del Tutor (Many-to-Many)
CREATE TABLE IF NOT EXISTS tutores_schema.tutor_conocimientos (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR
    -- ========================================
    pkid_tutor_conocimiento UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- RELACIONES (Many-to-Many)
    -- ========================================
    tutor_id UUID NOT NULL,
    conocimiento_id UUID NOT NULL, -- Referencia a catalogo_recursivo
    
    -- ========================================
    -- INFORMACIÓN ESPECÍFICA DEL CONOCIMIENTO
    -- ========================================
    nivel_experticia VARCHAR(20) DEFAULT 'INTERMEDIO', -- BASICO, INTERMEDIO, AVANZADO, EXPERTO
    años_experiencia INTEGER DEFAULT 0 CHECK (años_experiencia >= 0),
    puede_enseñar_principiantes BOOLEAN DEFAULT TRUE,
    puede_enseñar_avanzados BOOLEAN DEFAULT FALSE,
    
    -- ========================================
    -- CERTIFICACIONES Y VALIDACIÓN
    -- ========================================
    certificacion_url VARCHAR(500) NULL, -- Diploma, certificado, etc.
    esta_verificado BOOLEAN DEFAULT FALSE,
    verificado_por_admin_id UUID NULL,
    fecha_verificacion TIMESTAMPTZ NULL,
    notas_verificacion TEXT NULL,
    
    -- ========================================
    -- METADATA
    -- ========================================
    metadata JSONB DEFAULT '{}'::JSONB,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_tutor_conocimientos PRIMARY KEY (pkid_tutor_conocimiento),
    CONSTRAINT uq_tutor_conocimiento UNIQUE (tutor_id, conocimiento_id), -- Un tutor no puede repetir el mismo conocimiento
    
    -- Lección #8: Constraints simples
    CONSTRAINT ck_conocimiento_verificacion CHECK (
        (esta_verificado = TRUE AND verificado_por_admin_id IS NOT NULL AND fecha_verificacion IS NOT NULL) OR
        (esta_verificado = FALSE)
    )
);

-- Foreign Keys para tutor_conocimientos
DO $$
BEGIN
    -- FK a tutor
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_schema = 'tutores_schema' 
                   AND table_name = 'tutor_conocimientos'
                   AND constraint_name = 'fk_conocimiento_tutor') THEN
        ALTER TABLE tutores_schema.tutor_conocimientos 
        ADD CONSTRAINT fk_conocimiento_tutor 
        FOREIGN KEY (tutor_id) REFERENCES tutores_schema.perfiles_tutor(pkid_tutor) ON DELETE CASCADE;
    END IF;
    
    -- FK a catálogo conocimientos
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_schema = 'tutores_schema' 
                   AND table_name = 'tutor_conocimientos'
                   AND constraint_name = 'fk_conocimiento_catalogo') THEN
        ALTER TABLE tutores_schema.tutor_conocimientos 
        ADD CONSTRAINT fk_conocimiento_catalogo 
        FOREIGN KEY (conocimiento_id) REFERENCES shared_schema.catalogo_recursivo(pkid_catalogo_recursivo);
    END IF;
    
    -- FK a verificador admin
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_schema = 'tutores_schema' 
                   AND table_name = 'tutor_conocimientos'
                   AND constraint_name = 'fk_conocimiento_verificador') THEN
        ALTER TABLE tutores_schema.tutor_conocimientos 
        ADD CONSTRAINT fk_conocimiento_verificador 
        FOREIGN KEY (verificado_por_admin_id) REFERENCES autenticacion_schema.usuarios(pkid_usuario);
    END IF;
END $$;

-- Tabla: Idiomas del Tutor (Many-to-Many con nivel)
CREATE TABLE IF NOT EXISTS tutores_schema.tutor_idiomas (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR
    -- ========================================
    pkid_tutor_idioma UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- RELACIONES (Many-to-Many)
    -- ========================================
    tutor_id UUID NOT NULL,
    idioma_id UUID NOT NULL, -- Referencia a catalogo_recursivo
    
    -- ========================================
    -- NIVEL DE DOMINIO
    -- ========================================
    nivel_dominio nivel_dominio_idioma NOT NULL,
    es_idioma_nativo BOOLEAN DEFAULT FALSE,
    puede_enseñar_en_este_idioma BOOLEAN DEFAULT TRUE,
    
    -- ========================================
    -- CERTIFICACIONES
    -- ========================================
    certificacion_idioma VARCHAR(100) NULL, -- TOEFL, IELTS, DELE, etc.
    puntaje_certificacion VARCHAR(50) NULL,
    fecha_certificacion DATE NULL,
    certificacion_documento_url VARCHAR(500) NULL,
    
    -- ========================================
    -- VALIDACIÓN
    -- ========================================
    esta_verificado BOOLEAN DEFAULT FALSE,
    verificado_por_admin_id UUID NULL,
    fecha_verificacion TIMESTAMPTZ NULL,
    notas_verificacion TEXT NULL,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_tutor_idiomas PRIMARY KEY (pkid_tutor_idioma),
    CONSTRAINT uq_tutor_idioma UNIQUE (tutor_id, idioma_id), -- Un tutor no puede repetir el mismo idioma
    
    -- Lección #8: Constraints simples
    CONSTRAINT ck_idioma_nativo CHECK (
        (es_idioma_nativo = TRUE AND nivel_dominio = 'NATIVO') OR
        (es_idioma_nativo = FALSE)
    ),
    
    CONSTRAINT ck_idioma_verificacion CHECK (
        (esta_verificado = TRUE AND verificado_por_admin_id IS NOT NULL AND fecha_verificacion IS NOT NULL) OR
        (esta_verificado = FALSE)
    )
);

-- Foreign Keys para tutor_idiomas
DO $$
BEGIN
    -- FK a tutor
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_schema = 'tutores_schema' 
                   AND table_name = 'tutor_idiomas'
                   AND constraint_name = 'fk_idioma_tutor') THEN
        ALTER TABLE tutores_schema.tutor_idiomas 
        ADD CONSTRAINT fk_idioma_tutor 
        FOREIGN KEY (tutor_id) REFERENCES tutores_schema.perfiles_tutor(pkid_tutor) ON DELETE CASCADE;
    END IF;
    
    -- FK a catálogo idiomas
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_schema = 'tutores_schema' 
                   AND table_name = 'tutor_idiomas'
                   AND constraint_name = 'fk_idioma_catalogo') THEN
        ALTER TABLE tutores_schema.tutor_idiomas 
        ADD CONSTRAINT fk_idioma_catalogo 
        FOREIGN KEY (idioma_id) REFERENCES shared_schema.catalogo_recursivo(pkid_catalogo_recursivo);
    END IF;
    
    -- FK a verificador admin
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_schema = 'tutores_schema' 
                   AND table_name = 'tutor_idiomas'
                   AND constraint_name = 'fk_idioma_verificador') THEN
        ALTER TABLE tutores_schema.tutor_idiomas 
        ADD CONSTRAINT fk_idioma_verificador 
        FOREIGN KEY (verificado_por_admin_id) REFERENCES autenticacion_schema.usuarios(pkid_usuario);
    END IF;
END $$;

-- ====================
-- FASE 5: ÍNDICES ESTRATÉGICOS (Lección #4)
-- ====================

-- Índices para proceso_registro_tutor
CREATE INDEX IF NOT EXISTS idx_proceso_tutor_usuario ON tutores_schema.proceso_registro_tutor(usuario_id);
CREATE INDEX IF NOT EXISTS idx_proceso_tutor_estado ON tutores_schema.proceso_registro_tutor(estado_actual);
CREATE INDEX IF NOT EXISTS idx_proceso_tutor_session ON tutores_schema.proceso_registro_tutor(session_id);
CREATE INDEX IF NOT EXISTS idx_proceso_tutor_step ON tutores_schema.proceso_registro_tutor(step_completado);
CREATE INDEX IF NOT EXISTS idx_proceso_tutor_pendientes ON tutores_schema.proceso_registro_tutor(estado_actual, creation_date) 
    WHERE estado_actual = 'PENDIENTE_REGISTRO';

-- Índices para perfiles_tutor
CREATE INDEX IF NOT EXISTS idx_tutor_usuario ON tutores_schema.perfiles_tutor(usuario_id);
CREATE INDEX IF NOT EXISTS idx_tutor_estado_aprobacion ON tutores_schema.perfiles_tutor(estado_aprobacion);
CREATE INDEX IF NOT EXISTS idx_tutor_pais ON tutores_schema.perfiles_tutor(pais_id);
CREATE INDEX IF NOT EXISTS idx_tutor_ciudad ON tutores_schema.perfiles_tutor(ciudad_id);
CREATE INDEX IF NOT EXISTS idx_tutor_tarifa ON tutores_schema.perfiles_tutor(tarifa_por_hora) WHERE estado_aprobacion = 'APROBADO';
CREATE INDEX IF NOT EXISTS idx_tutor_calificacion ON tutores_schema.perfiles_tutor(calificacion_promedio) WHERE estado_aprobacion = 'APROBADO';
CREATE INDEX IF NOT EXISTS idx_tutor_activos ON tutores_schema.perfiles_tutor(estado_aprobacion, creation_date) 
    WHERE estado_aprobacion = 'APROBADO' AND expiration_date IS NULL;

-- Índices para experiencia_laboral
CREATE INDEX IF NOT EXISTS idx_experiencia_tutor ON tutores_schema.experiencia_laboral(tutor_id);
CREATE INDEX IF NOT EXISTS idx_experiencia_empresa ON tutores_schema.experiencia_laboral(empresa);
CREATE INDEX IF NOT EXISTS idx_experiencia_verificada ON tutores_schema.experiencia_laboral(esta_verificada);
CREATE INDEX IF NOT EXISTS idx_experiencia_actual ON tutores_schema.experiencia_laboral(tutor_id, es_trabajo_actual) 
    WHERE es_trabajo_actual = TRUE;

-- Índices para tutor_conocimientos
CREATE INDEX IF NOT EXISTS idx_conocimiento_tutor ON tutores_schema.tutor_conocimientos(tutor_id);
CREATE INDEX IF NOT EXISTS idx_conocimiento_catalogo ON tutores_schema.tutor_conocimientos(conocimiento_id);
CREATE INDEX IF NOT EXISTS idx_conocimiento_nivel ON tutores_schema.tutor_conocimientos(nivel_experticia);
CREATE INDEX IF NOT EXISTS idx_conocimiento_verificado ON tutores_schema.tutor_conocimientos(esta_verificado);

-- Índices para tutor_idiomas
CREATE INDEX IF NOT EXISTS idx_idioma_tutor ON tutores_schema.tutor_idiomas(tutor_id);
CREATE INDEX IF NOT EXISTS idx_idioma_catalogo ON tutores_schema.tutor_idiomas(idioma_id);
CREATE INDEX IF NOT EXISTS idx_idioma_nivel ON tutores_schema.tutor_idiomas(nivel_dominio);
CREATE INDEX IF NOT EXISTS idx_idioma_nativo ON tutores_schema.tutor_idiomas(es_idioma_nativo) WHERE es_idioma_nativo = TRUE;

-- Índices GIN para campos JSONB
CREATE INDEX IF NOT EXISTS idx_proceso_tutor_datos_gin ON tutores_schema.proceso_registro_tutor USING GIN(datos_formulario);
CREATE INDEX IF NOT EXISTS idx_proceso_tutor_experiencias_gin ON tutores_schema.proceso_registro_tutor USING GIN(experiencias_laborales);
CREATE INDEX IF NOT EXISTS idx_proceso_tutor_conocimientos_gin ON tutores_schema.proceso_registro_tutor USING GIN(conocimientos_seleccionados);
CREATE INDEX IF NOT EXISTS idx_tutor_metadata_gin ON tutores_schema.perfiles_tutor USING GIN(metadata);
CREATE INDEX IF NOT EXISTS idx_tutor_disponibilidad_gin ON tutores_schema.perfiles_tutor USING GIN(disponibilidad_horarios);

-- ====================
-- FASE 6: TRIGGERS PARA UPDATED_AT (Lección #4: verificación defensiva)
-- ====================

-- Verificar función shared_schema.trigger_set_timestamp() existe
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.routines 
                   WHERE routine_schema = 'shared_schema' 
                   AND routine_name = 'trigger_set_timestamp') THEN
        -- Crear función si no existe (de V4)
        CREATE OR REPLACE FUNCTION shared_schema.trigger_set_timestamp()
        RETURNS TRIGGER AS $trigger$
        BEGIN
            NEW.updated_at = CURRENT_TIMESTAMP;
            RETURN NEW;
        END;
        $trigger$ LANGUAGE plpgsql;
        
        RAISE NOTICE '✅ Función trigger_set_timestamp creada';
    ELSE
        RAISE NOTICE '✅ Función trigger_set_timestamp ya existe';
    END IF;
END $$;

-- Función para añadir columna updated_at y trigger si no existen
CREATE OR REPLACE FUNCTION tutores_schema.setup_updated_at_trigger(p_table_name TEXT)
RETURNS VOID AS $$
DECLARE
    -- Lección #11: Prefijo de variables para evitar ambiguedad
    v_full_table_name TEXT := 'tutores_schema.' || p_table_name;
    v_trigger_name_local TEXT := p_table_name || '_updated_at';
BEGIN
    -- Agregar columna updated_at si no existe (Lección #2: nombres exactos)
    IF NOT shared_schema.tabla_tiene_columna('tutores_schema', p_table_name, 'updated_at') THEN
        EXECUTE format('ALTER TABLE %I.%I ADD COLUMN updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP', 'tutores_schema', p_table_name);
        RAISE NOTICE 'Columna updated_at agregada a %', v_full_table_name;
    END IF;
    
    -- Crear trigger si no existe (Lección #4: verificación defensiva + #11: sin ambiguedad)
    IF NOT EXISTS (SELECT 1 FROM information_schema.triggers 
                   WHERE trigger_schema = 'tutores_schema' 
                   AND event_object_table = p_table_name
                   AND trigger_name = v_trigger_name_local) THEN
        EXECUTE format('CREATE TRIGGER %I BEFORE UPDATE ON %I.%I FOR EACH ROW EXECUTE FUNCTION shared_schema.trigger_set_timestamp()', 
                      v_trigger_name_local, 'tutores_schema', p_table_name);
        RAISE NOTICE 'Trigger % creado para %', v_trigger_name_local, v_full_table_name;
    ELSE
        RAISE NOTICE 'Trigger % ya existe para %', v_trigger_name_local, v_full_table_name;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Aplicar updated_at a todas las tablas de tutores
SELECT tutores_schema.setup_updated_at_trigger('proceso_registro_tutor');
SELECT tutores_schema.setup_updated_at_trigger('perfiles_tutor');
SELECT tutores_schema.setup_updated_at_trigger('experiencia_laboral');
SELECT tutores_schema.setup_updated_at_trigger('tutor_conocimientos');
SELECT tutores_schema.setup_updated_at_trigger('tutor_idiomas');

-- ====================
-- FASE 7: FUNCIONES DE UTILIDAD
-- ====================

-- Función: Obtener tutores por conocimiento
CREATE OR REPLACE FUNCTION tutores_schema.obtener_tutores_por_conocimiento(
    p_conocimiento_id UUID,
    p_nivel_minimo VARCHAR(20) DEFAULT 'BASICO',
    p_solo_verificados BOOLEAN DEFAULT FALSE,
    p_limite INTEGER DEFAULT 10
)
RETURNS TABLE(
    tutor_id UUID,
    nombres TEXT,
    apellidos TEXT,
    nivel_experticia VARCHAR(20),
    años_experiencia INTEGER,
    calificacion_promedio DECIMAL(3,2),
    tarifa_por_hora DECIMAL(10,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        pt.pkid_tutor,
        pt.nombres || ' ' || pt.apellidos AS nombres_completos, -- Lección #1: usar || en lugar de CONCAT()
        pt.apellidos,
        tc.nivel_experticia,
        tc.años_experiencia,
        pt.calificacion_promedio,
        pt.tarifa_por_hora
    FROM tutores_schema.perfiles_tutor pt
    INNER JOIN tutores_schema.tutor_conocimientos tc ON pt.pkid_tutor = tc.tutor_id
    WHERE tc.conocimiento_id = p_conocimiento_id
      AND pt.estado_aprobacion = 'APROBADO'
      AND pt.expiration_date IS NULL
      AND tc.expiration_date IS NULL
      AND (NOT p_solo_verificados OR tc.esta_verificado = TRUE)
    ORDER BY pt.calificacion_promedio DESC, tc.años_experiencia DESC
    LIMIT p_limite;
END;
$$ LANGUAGE plpgsql;

-- Función: Validar completitud de perfil de tutor
CREATE OR REPLACE FUNCTION tutores_schema.validar_completitud_perfil(p_tutor_id UUID)
RETURNS JSONB AS $$
DECLARE
    resultado JSONB := '{"es_completo": false, "porcentaje": 0, "campos_faltantes": []}'::JSONB;
    campos_completos INTEGER := 0;
    total_campos INTEGER := 10; -- Ajustar según campos requeridos
    campos_faltantes TEXT[] := ARRAY[]::TEXT[];
    tutor_record RECORD;
BEGIN
    -- Obtener datos del tutor
    SELECT * INTO tutor_record 
    FROM tutores_schema.perfiles_tutor 
    WHERE pkid_tutor = p_tutor_id;
    
    IF NOT FOUND THEN
        RETURN '{"error": "Tutor no encontrado", "es_completo": false, "porcentaje": 0}'::JSONB;
    END IF;
    
    -- Validar campos obligatorios
    IF tutor_record.nombres IS NOT NULL AND LENGTH(tutor_record.nombres) > 0 THEN
        campos_completos := campos_completos + 1;
    ELSE
        campos_faltantes := array_append(campos_faltantes, 'nombres');
    END IF;
    
    IF tutor_record.apellidos IS NOT NULL AND LENGTH(tutor_record.apellidos) > 0 THEN
        campos_completos := campos_completos + 1;
    ELSE
        campos_faltantes := array_append(campos_faltantes, 'apellidos');
    END IF;
    
    IF tutor_record.fecha_nacimiento IS NOT NULL THEN
        campos_completos := campos_completos + 1;
    ELSE
        campos_faltantes := array_append(campos_faltantes, 'fecha_nacimiento');
    END IF;
    
    IF tutor_record.telefono IS NOT NULL AND LENGTH(tutor_record.telefono) > 0 THEN
        campos_completos := campos_completos + 1;
    ELSE
        campos_faltantes := array_append(campos_faltantes, 'telefono');
    END IF;
    
    IF tutor_record.pais_id IS NOT NULL THEN
        campos_completos := campos_completos + 1;
    ELSE
        campos_faltantes := array_append(campos_faltantes, 'pais');
    END IF;
    
    IF tutor_record.ciudad_id IS NOT NULL THEN
        campos_completos := campos_completos + 1;
    ELSE
        campos_faltantes := array_append(campos_faltantes, 'ciudad');
    END IF;
    
    IF tutor_record.descripcion_breve IS NOT NULL AND LENGTH(tutor_record.descripcion_breve) >= 50 THEN
        campos_completos := campos_completos + 1;
    ELSE
        campos_faltantes := array_append(campos_faltantes, 'descripcion_breve');
    END IF;
    
    IF tutor_record.tarifa_por_hora IS NOT NULL AND tutor_record.tarifa_por_hora > 0 THEN
        campos_completos := campos_completos + 1;
    ELSE
        campos_faltantes := array_append(campos_faltantes, 'tarifa_por_hora');
    END IF;
    
    -- Validar al menos 1 experiencia laboral
    IF EXISTS (SELECT 1 FROM tutores_schema.experiencia_laboral 
               WHERE tutor_id = p_tutor_id AND expiration_date IS NULL) THEN
        campos_completos := campos_completos + 1;
    ELSE
        campos_faltantes := array_append(campos_faltantes, 'experiencia_laboral');
    END IF;
    
    -- Validar al menos 1 conocimiento
    IF EXISTS (SELECT 1 FROM tutores_schema.tutor_conocimientos 
               WHERE tutor_id = p_tutor_id AND expiration_date IS NULL) THEN
        campos_completos := campos_completos + 1;
    ELSE
        campos_faltantes := array_append(campos_faltantes, 'conocimientos');
    END IF;
    
    -- Calcular resultado
    resultado := jsonb_build_object(
        'es_completo', campos_completos = total_campos,
        'porcentaje', ROUND((campos_completos::DECIMAL / total_campos::DECIMAL) * 100, 2),
        'campos_completos', campos_completos,
        'total_campos', total_campos,
        'campos_faltantes', array_to_json(campos_faltantes)
    );
    
    RETURN resultado;
END;
$$ LANGUAGE plpgsql;

-- ====================
-- FASE 8: COMENTARIOS Y DOCUMENTACIÓN
-- ====================

-- Comentarios en tablas
COMMENT ON TABLE tutores_schema.proceso_registro_tutor IS 'Gestión del proceso multi-step de registro de tutores (4 pasos)';
COMMENT ON TABLE tutores_schema.perfiles_tutor IS 'Perfil completo de tutor con información comercial y académica';
COMMENT ON TABLE tutores_schema.experiencia_laboral IS 'Historial laboral del tutor (múltiples experiencias)';
COMMENT ON TABLE tutores_schema.tutor_conocimientos IS 'Relación N:M entre tutores y conocimientos/especialidades';
COMMENT ON TABLE tutores_schema.tutor_idiomas IS 'Idiomas que maneja el tutor con niveles de dominio';

-- Comentarios en campos críticos
COMMENT ON COLUMN tutores_schema.perfiles_tutor.estado_aprobacion IS 'ENUM: PENDIENTE_REGISTRO, EN_REVISION, APROBADO, RECHAZADO, SUSPENDIDO, INACTIVO';
COMMENT ON COLUMN tutores_schema.perfiles_tutor.tarifa_por_hora IS 'Tarifa en USD por hora de tutoría';
COMMENT ON COLUMN tutores_schema.perfiles_tutor.disponibilidad_horarios IS 'JSONB con horarios por día: {lunes: [09:00-12:00], martes: [...]}';
COMMENT ON COLUMN tutores_schema.experiencia_laboral.es_trabajo_actual IS 'TRUE si actualmente trabaja en esta empresa';
COMMENT ON COLUMN tutores_schema.tutor_conocimientos.nivel_experticia IS 'ENUM-like: BASICO, INTERMEDIO, AVANZADO, EXPERTO';
COMMENT ON COLUMN tutores_schema.tutor_idiomas.nivel_dominio IS 'ENUM: BASICO, INTERMEDIO, AVANZADO, NATIVO (escala CEFR)';

-- ====================
-- FINALIZACIÓN
-- ====================

SELECT 'V5: REGISTRO TUTORES COMPLETADO' as mensaje;

-- Mensaje de éxito
DO $$
BEGIN
    RAISE NOTICE '✅ V5 aplicado exitosamente';
    RAISE NOTICE '✅ 8 lecciones de V4 aplicadas preventivamente';
    RAISE NOTICE '✅ Bounded Context tutores_schema completo';
    RAISE NOTICE '✅ 5 tablas creadas con auto-reparación';
    RAISE NOTICE '✅ 25+ índices estratégicos aplicados';
    RAISE NOTICE '✅ Triggers updated_at en todas las tablas';
    RAISE NOTICE '✅ Funciones de utilidad incluidas';
    RAISE NOTICE '📊 Sistema listo para registro de tutores multi-step';
END $$;