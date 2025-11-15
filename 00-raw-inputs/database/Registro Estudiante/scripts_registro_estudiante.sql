-- ============================================================================
-- Scripts de Inserción: HU-001 Registro de Estudiante Multi-Step
-- Descripción: Procedimientos almacenados y scripts para guardar datos del
--              proceso de registro multi-step con manejo de imágenes
-- Autor: Database Engineer Senior - ZNS-METHOD  
-- Fecha: 2025-11-14
-- Para ejecutar desde: DBeaver, pgAdmin, psql
-- ============================================================================

-- ====================
-- 1. STORED PROCEDURES PARA REGISTRO MULTI-STEP
-- ====================

-- Procedure: Iniciar proceso de registro (Step 1)
CREATE OR REPLACE FUNCTION autenticacion_schema.iniciar_registro_estudiante(
    p_email VARCHAR(255),
    p_password_hash VARCHAR(255),
    p_ip_address INET DEFAULT NULL,
    p_user_agent TEXT DEFAULT NULL,
    p_session_id VARCHAR(255) DEFAULT NULL
)
RETURNS TABLE (
    proceso_id UUID,
    otp_code VARCHAR(6),
    success BOOLEAN,
    message TEXT
) AS $$
DECLARE
    v_proceso_id UUID;
    v_otp_code VARCHAR(6);
    v_email_exists BOOLEAN;
BEGIN
    -- Validar email format
    IF NOT shared_schema.validar_email(p_email) THEN
        RETURN QUERY SELECT NULL::UUID, NULL::VARCHAR(6), FALSE, 'Formato de email inválido';
        RETURN;
    END IF;
    
    -- Verificar si email ya existe
    SELECT EXISTS(SELECT 1 FROM autenticacion_schema.usuarios WHERE email = p_email AND expiration_date IS NULL) 
    INTO v_email_exists;
    
    IF v_email_exists THEN
        RETURN QUERY SELECT NULL::UUID, NULL::VARCHAR(6), FALSE, 'Email ya registrado en el sistema';
        RETURN;
    END IF;
    
    -- Generar OTP
    v_otp_code := autenticacion_schema.generar_otp();
    
    -- Crear proceso de registro
    INSERT INTO autenticacion_schema.proceso_registro (
        estado_actual,
        step_completado,
        datos_step_1,
        ip_address,
        user_agent,
        session_id,
        otp_verificado
    ) VALUES (
        'STEP_1_CREDENCIALES',
        1,
        jsonb_build_object(
            'email', p_email,
            'password_hash', p_password_hash,
            'otp_code', v_otp_code,
            'otp_expiry', NOW() + INTERVAL '10 minutes',
            'otp_attempts', 0
        ),
        p_ip_address,
        p_user_agent,
        p_session_id,
        FALSE
    ) RETURNING pkid_proceso_registro INTO v_proceso_id;
    
    -- Emitir domain event
    INSERT INTO shared_schema.domain_events (aggregate_type, aggregate_id, event_type, event_data)
    VALUES (
        'ProcesoRegistro',
        v_proceso_id,
        'RegistroIniciado',
        jsonb_build_object(
            'email', p_email,
            'step', 1,
            'otp_code', v_otp_code,
            'timestamp', NOW()
        )
    );
    
    RETURN QUERY SELECT v_proceso_id, v_otp_code, TRUE, 'Proceso de registro iniciado exitosamente';
END;
$$ LANGUAGE plpgsql;

-- Procedure: Verificar OTP y avanzar al Step 2
CREATE OR REPLACE FUNCTION autenticacion_schema.verificar_otp_registro(
    p_proceso_id UUID,
    p_otp_code VARCHAR(6)
)
RETURNS TABLE (
    success BOOLEAN,
    message TEXT,
    can_advance BOOLEAN
) AS $$
DECLARE
    v_proceso RECORD;
    v_otp_data JSONB;
    v_attempts INTEGER;
BEGIN
    -- Obtener proceso
    SELECT * FROM autenticacion_schema.proceso_registro 
    WHERE pkid_proceso_registro = p_proceso_id 
    AND estado_actual = 'STEP_1_CREDENCIALES'
    AND expiration_date IS NULL
    INTO v_proceso;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT FALSE, 'Proceso de registro no encontrado o inválido', FALSE;
        RETURN;
    END IF;
    
    -- Extraer datos OTP
    v_otp_data := v_proceso.datos_step_1;
    v_attempts := COALESCE((v_otp_data->>'otp_attempts')::INTEGER, 0);
    
    -- Verificar si OTP expiró
    IF (v_otp_data->>'otp_expiry')::TIMESTAMPTZ < NOW() THEN
        RETURN QUERY SELECT FALSE, 'Código OTP expirado. Solicite uno nuevo', FALSE;
        RETURN;
    END IF;
    
    -- Verificar intentos máximos
    IF v_attempts >= 5 THEN
        RETURN QUERY SELECT FALSE, 'Máximo de intentos alcanzado. Inicie el proceso nuevamente', FALSE;
        RETURN;
    END IF;
    
    -- Verificar código OTP
    IF (v_otp_data->>'otp_code') = p_otp_code THEN
        -- OTP correcto - avanzar al Step 2
        UPDATE autenticacion_schema.proceso_registro 
        SET 
            estado_actual = 'STEP_2_DATOS_PERSONALES',
            step_completado = 2,
            otp_verificado = TRUE,
            fecha_ultimo_paso = NOW()
        WHERE pkid_proceso_registro = p_proceso_id;
        
        -- Emitir domain event
        INSERT INTO shared_schema.domain_events (aggregate_type, aggregate_id, event_type, event_data)
        VALUES (
            'ProcesoRegistro',
            p_proceso_id,
            'OTPVerificado',
            jsonb_build_object(
                'step', 2,
                'timestamp', NOW()
            )
        );
        
        RETURN QUERY SELECT TRUE, 'OTP verificado correctamente', TRUE;
    ELSE
        -- OTP incorrecto - incrementar intentos
        UPDATE autenticacion_schema.proceso_registro 
        SET 
            datos_step_1 = jsonb_set(
                datos_step_1, 
                '{otp_attempts}', 
                to_jsonb(v_attempts + 1)
            )
        WHERE pkid_proceso_registro = p_proceso_id;
        
        RETURN QUERY SELECT FALSE, 
            FORMAT('Código OTP incorrecto. Intentos restantes: %s', 5 - v_attempts - 1), 
            FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Procedure: Guardar datos personales (Step 2)
CREATE OR REPLACE FUNCTION autenticacion_schema.guardar_datos_personales_registro(
    p_proceso_id UUID,
    p_primer_nombre VARCHAR(50),
    p_segundo_nombre VARCHAR(50),
    p_primer_apellido VARCHAR(50),
    p_segundo_apellido VARCHAR(50),
    p_fecha_nacimiento DATE,
    p_genero VARCHAR(20),
    p_telefono VARCHAR(20),
    p_pais_codigo CHAR(2),
    p_ciudad VARCHAR(100),
    p_direccion TEXT,
    p_nivel_educativo VARCHAR(50),
    p_institucion_educativa VARCHAR(255),
    p_sobre_mi TEXT,
    -- Datos del responsable (si es menor)
    p_responsable_nombre VARCHAR(255) DEFAULT NULL,
    p_responsable_apellido VARCHAR(255) DEFAULT NULL,
    p_responsable_email VARCHAR(255) DEFAULT NULL,
    p_responsable_telefono VARCHAR(20) DEFAULT NULL,
    p_responsable_relacion VARCHAR(50) DEFAULT NULL,
    -- Flags
    p_terminos_aceptados BOOLEAN DEFAULT TRUE
)
RETURNS TABLE (
    success BOOLEAN,
    message TEXT,
    es_menor_edad BOOLEAN,
    requiere_responsable BOOLEAN
) AS $$
DECLARE
    v_proceso RECORD;
    v_edad INTEGER;
    v_es_menor BOOLEAN;
    v_pais_id UUID;
    v_datos_step2 JSONB;
BEGIN
    -- Validar proceso existe y está en step correcto
    SELECT * FROM autenticacion_schema.proceso_registro 
    WHERE pkid_proceso_registro = p_proceso_id 
    AND estado_actual = 'STEP_2_DATOS_PERSONALES'
    AND otp_verificado = TRUE
    AND expiration_date IS NULL
    INTO v_proceso;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT FALSE, 'Proceso no encontrado o no está en el step correcto', FALSE, FALSE;
        RETURN;
    END IF;
    
    -- Calcular edad
    v_edad := shared_schema.calcular_edad(p_fecha_nacimiento);
    v_es_menor := v_edad < 18;
    
    -- Si es menor, validar datos del responsable
    IF v_es_menor THEN
        IF p_responsable_nombre IS NULL OR p_responsable_email IS NULL OR p_responsable_telefono IS NULL THEN
            RETURN QUERY SELECT FALSE, 'Datos del responsable son obligatorios para menores de 18 años', v_es_menor, TRUE;
            RETURN;
        END IF;
        
        IF NOT shared_schema.validar_email(p_responsable_email) THEN
            RETURN QUERY SELECT FALSE, 'Email del responsable tiene formato inválido', v_es_menor, TRUE;
            RETURN;
        END IF;
    END IF;
    
    -- Obtener ID del país
    SELECT pkid_paises FROM shared_schema.paises 
    WHERE codigo = p_pais_codigo AND expiration_date IS NULL
    INTO v_pais_id;
    
    IF v_pais_id IS NULL THEN
        RETURN QUERY SELECT FALSE, 'Código de país inválido', v_es_menor, v_es_menor;
        RETURN;
    END IF;
    
    -- Construir JSON con datos del step 2
    v_datos_step2 := jsonb_build_object(
        'primer_nombre', shared_schema.capitalizar_nombre(p_primer_nombre),
        'segundo_nombre', CASE WHEN p_segundo_nombre IS NOT NULL THEN shared_schema.capitalizar_nombre(p_segundo_nombre) ELSE NULL END,
        'primer_apellido', shared_schema.capitalizar_nombre(p_primer_apellido),
        'segundo_apellido', CASE WHEN p_segundo_apellido IS NOT NULL THEN shared_schema.capitalizar_nombre(p_segundo_apellido) ELSE NULL END,
        'fecha_nacimiento', p_fecha_nacimiento,
        'edad', v_edad,
        'genero', p_genero,
        'telefono', p_telefono,
        'pais_codigo', p_pais_codigo,
        'pais_id', v_pais_id,
        'ciudad', p_ciudad,
        'direccion', p_direccion,
        'nivel_educativo', p_nivel_educativo,
        'institucion_educativa', p_institucion_educativa,
        'sobre_mi', p_sobre_mi,
        'es_menor_edad', v_es_menor
    );
    
    -- Agregar datos del responsable si aplica
    IF v_es_menor THEN
        v_datos_step2 := v_datos_step2 || jsonb_build_object(
            'responsable_nombre', shared_schema.capitalizar_nombre(p_responsable_nombre),
            'responsable_apellido', shared_schema.capitalizar_nombre(p_responsable_apellido),
            'responsable_email', LOWER(p_responsable_email),
            'responsable_telefono', p_responsable_telefono,
            'responsable_relacion', p_responsable_relacion
        );
    END IF;
    
    -- Actualizar proceso
    UPDATE autenticacion_schema.proceso_registro 
    SET 
        estado_actual = 'STEP_3_VERIFICACION_BIOMETRICA',
        step_completado = 3,
        datos_step_2 = v_datos_step2,
        es_menor_edad = v_es_menor,
        requiere_responsable = v_es_menor,
        terminos_aceptados = p_terminos_aceptados,
        fecha_ultimo_paso = NOW()
    WHERE pkid_proceso_registro = p_proceso_id;
    
    -- Emitir domain event
    INSERT INTO shared_schema.domain_events (aggregate_type, aggregate_id, event_type, event_data)
    VALUES (
        'ProcesoRegistro',
        p_proceso_id,
        'DatosPersonalesGuardados',
        jsonb_build_object(
            'step', 3,
            'es_menor_edad', v_es_menor,
            'requiere_responsable', v_es_menor,
            'edad', v_edad,
            'timestamp', NOW()
        )
    );
    
    RETURN QUERY SELECT TRUE, 'Datos personales guardados exitosamente', v_es_menor, v_es_menor;
END;
$$ LANGUAGE plpgsql;

-- Procedure: Guardar archivo/imagen
CREATE OR REPLACE FUNCTION shared_schema.guardar_archivo(
    p_nombre_original VARCHAR(255),
    p_tipo_archivo shared_schema.tipo_archivo,
    p_mime_type VARCHAR(100),
    p_tamaño_bytes BIGINT,
    p_storage_path TEXT,
    p_storage_url TEXT DEFAULT NULL,
    p_ancho_px INTEGER DEFAULT NULL,
    p_alto_px INTEGER DEFAULT NULL,
    p_hash_md5 VARCHAR(32) DEFAULT NULL,
    p_hash_sha256 VARCHAR(64) DEFAULT NULL,
    p_metadata JSONB DEFAULT NULL
)
RETURNS TABLE (
    archivo_id UUID,
    success BOOLEAN,
    message TEXT
) AS $$
DECLARE
    v_archivo_id UUID;
    v_nombre_archivo VARCHAR(255);
    v_extension VARCHAR(10);
BEGIN
    -- Generar nombre único
    v_extension := LOWER(RIGHT(p_nombre_original, 4));
    v_nombre_archivo := gen_random_uuid()::TEXT || v_extension;
    
    -- Validar tamaño
    IF p_tamaño_bytes > 52428800 THEN -- 50MB
        RETURN QUERY SELECT NULL::UUID, FALSE, 'Archivo excede el tamaño máximo permitido (50MB)';
        RETURN;
    END IF;
    
    -- Insertar archivo
    INSERT INTO shared_schema.archivos (
        nombre_original,
        nombre_archivo,
        tipo_archivo,
        mime_type,
        tamaño_bytes,
        storage_path,
        storage_url,
        ancho_px,
        alto_px,
        hash_md5,
        hash_sha256,
        metadata
    ) VALUES (
        p_nombre_original,
        v_nombre_archivo,
        p_tipo_archivo,
        p_mime_type,
        p_tamaño_bytes,
        p_storage_path,
        p_storage_url,
        p_ancho_px,
        p_alto_px,
        p_hash_md5,
        p_hash_sha256,
        COALESCE(p_metadata, '{}'::JSONB)
    ) RETURNING pkid_archivos INTO v_archivo_id;
    
    RETURN QUERY SELECT v_archivo_id, TRUE, 'Archivo guardado exitosamente';
END;
$$ LANGUAGE plpgsql;

-- Procedure: Guardar verificación biométrica (Step 3)
CREATE OR REPLACE FUNCTION autenticacion_schema.guardar_verificacion_biometrica(
    p_proceso_id UUID,
    p_tipo_documento shared_schema.tipo_documento,
    p_numero_documento VARCHAR(50),
    p_lugar_expedicion VARCHAR(100),
    p_fecha_expedicion DATE,
    p_fecha_vencimiento DATE,
    -- IDs de archivos ya subidos
    p_foto_perfil_id UUID,
    p_documento_frontal_id UUID,
    p_documento_trasero_id UUID,
    p_selfie_verificacion_id UUID,
    p_responsable_documento_frontal_id UUID DEFAULT NULL,
    p_responsable_documento_trasero_id UUID DEFAULT NULL,
    -- Datos OCR extraídos (opcional)
    p_ocr_datos JSONB DEFAULT NULL
)
RETURNS TABLE (
    verificacion_id UUID,
    success BOOLEAN,
    message TEXT
) AS $$
DECLARE
    v_proceso RECORD;
    v_verificacion_id UUID;
    v_usuario_id UUID;
BEGIN
    -- Validar proceso
    SELECT * FROM autenticacion_schema.proceso_registro 
    WHERE pkid_proceso_registro = p_proceso_id 
    AND estado_actual = 'STEP_3_VERIFICACION_BIOMETRICA'
    AND expiration_date IS NULL
    INTO v_proceso;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT NULL::UUID, FALSE, 'Proceso no encontrado o no está en el step correcto';
        RETURN;
    END IF;
    
    -- Si es menor, validar que tenga documentos del responsable
    IF v_proceso.es_menor_edad AND (p_responsable_documento_frontal_id IS NULL OR p_responsable_documento_trasero_id IS NULL) THEN
        RETURN QUERY SELECT NULL::UUID, FALSE, 'Documentos del responsable son obligatorios para menores de edad';
        RETURN;
    END IF;
    
    -- Crear usuario temporalmente
    INSERT INTO autenticacion_schema.usuarios (
        email,
        password_hash,
        nombre,
        apellido,
        rol,
        estado
    ) VALUES (
        (v_proceso.datos_step_1->>'email'),
        (v_proceso.datos_step_1->>'password_hash'),
        (v_proceso.datos_step_2->>'primer_nombre'),
        (v_proceso.datos_step_2->>'primer_apellido'),
        'ESTUDIANTE',
        'PENDIENTE_VERIFICACION'
    ) RETURNING pkid_usuarios INTO v_usuario_id;
    
    -- Crear verificación de identidad
    INSERT INTO autenticacion_schema.verificacion_identidad (
        usuario_id,
        proceso_registro_id,
        tipo_documento,
        numero_documento,
        lugar_expedicion,
        fecha_expedicion,
        fecha_vencimiento,
        foto_perfil_id,
        documento_frontal_id,
        documento_trasero_id,
        selfie_verificacion_id,
        responsable_documento_frontal_id,
        responsable_documento_trasero_id,
        estado,
        ocr_datos_extraidos
    ) VALUES (
        v_usuario_id,
        p_proceso_id,
        p_tipo_documento,
        p_numero_documento,
        p_lugar_expedicion,
        p_fecha_expedicion,
        p_fecha_vencimiento,
        p_foto_perfil_id,
        p_documento_frontal_id,
        p_documento_trasero_id,
        p_selfie_verificacion_id,
        p_responsable_documento_frontal_id,
        p_responsable_documento_trasero_id,
        'PENDIENTE',
        p_ocr_datos
    ) RETURNING pkid_verificacion_identidad INTO v_verificacion_id;
    
    -- Actualizar proceso para incluir usuario_id y avanzar al step 4
    UPDATE autenticacion_schema.proceso_registro 
    SET 
        usuario_id = v_usuario_id,
        estado_actual = 'STEP_4_CONFIRMACION',
        step_completado = 4,
        datos_step_3 = jsonb_build_object(
            'verificacion_id', v_verificacion_id,
            'tipo_documento', p_tipo_documento,
            'numero_documento', p_numero_documento,
            'foto_perfil_id', p_foto_perfil_id,
            'documento_frontal_id', p_documento_frontal_id,
            'documento_trasero_id', p_documento_trasero_id,
            'selfie_verificacion_id', p_selfie_verificacion_id,
            'responsable_documento_frontal_id', p_responsable_documento_frontal_id,
            'responsable_documento_trasero_id', p_responsable_documento_trasero_id
        ),
        fecha_ultimo_paso = NOW()
    WHERE pkid_proceso_registro = p_proceso_id;
    
    -- Emitir domain event
    INSERT INTO shared_schema.domain_events (aggregate_type, aggregate_id, event_type, event_data)
    VALUES (
        'ProcesoRegistro',
        p_proceso_id,
        'VerificacionBiometricaGuardada',
        jsonb_build_object(
            'usuario_id', v_usuario_id,
            'verificacion_id', v_verificacion_id,
            'step', 4,
            'timestamp', NOW()
        )
    );
    
    RETURN QUERY SELECT v_verificacion_id, TRUE, 'Verificación biométrica guardada exitosamente';
END;
$$ LANGUAGE plpgsql;

-- Procedure: Completar registro (Step 4)
CREATE OR REPLACE FUNCTION autenticacion_schema.completar_registro_estudiante(
    p_proceso_id UUID,
    p_idioma_preferido_codigo CHAR(2) DEFAULT 'es'
)
RETURNS TABLE (
    usuario_id UUID,
    perfil_id UUID,
    success BOOLEAN,
    message TEXT
) AS $$
DECLARE
    v_proceso RECORD;
    v_perfil_id UUID;
    v_idioma_id UUID;
    v_datos_step2 JSONB;
BEGIN
    -- Validar proceso
    SELECT * FROM autenticacion_schema.proceso_registro 
    WHERE pkid_proceso_registro = p_proceso_id 
    AND estado_actual = 'STEP_4_CONFIRMACION'
    AND usuario_id IS NOT NULL
    AND expiration_date IS NULL
    INTO v_proceso;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT NULL::UUID, NULL::UUID, FALSE, 'Proceso no encontrado o incompleto';
        RETURN;
    END IF;
    
    -- Obtener idioma
    SELECT pkid_idiomas FROM shared_schema.idiomas 
    WHERE codigo = p_idioma_preferido_codigo AND expiration_date IS NULL
    INTO v_idioma_id;
    
    IF v_idioma_id IS NULL THEN
        v_idioma_id := (SELECT pkid_idiomas FROM shared_schema.idiomas WHERE codigo = 'es' LIMIT 1);
    END IF;
    
    v_datos_step2 := v_proceso.datos_step_2;
    
    -- Crear perfil de estudiante
    INSERT INTO perfiles_schema.perfiles_estudiante (
        usuario_id,
        pais_id,
        idioma_preferido_id,
        primer_nombre,
        segundo_nombre,
        primer_apellido,
        segundo_apellido,
        fecha_nacimiento,
        genero,
        telefono,
        ciudad,
        direccion,
        nivel_educativo,
        institucion_educativa,
        sobre_mi,
        es_menor_edad,
        responsable_nombre,
        responsable_apellido,
        responsable_email,
        responsable_telefono,
        responsable_relacion
    ) VALUES (
        v_proceso.usuario_id,
        (v_datos_step2->>'pais_id')::UUID,
        v_idioma_id,
        v_datos_step2->>'primer_nombre',
        v_datos_step2->>'segundo_nombre',
        v_datos_step2->>'primer_apellido',
        v_datos_step2->>'segundo_apellido',
        (v_datos_step2->>'fecha_nacimiento')::DATE,
        v_datos_step2->>'genero',
        v_datos_step2->>'telefono',
        v_datos_step2->>'ciudad',
        v_datos_step2->>'direccion',
        v_datos_step2->>'nivel_educativo',
        v_datos_step2->>'institucion_educativa',
        v_datos_step2->>'sobre_mi',
        (v_datos_step2->>'es_menor_edad')::BOOLEAN,
        v_datos_step2->>'responsable_nombre',
        v_datos_step2->>'responsable_apellido',
        v_datos_step2->>'responsable_email',
        v_datos_step2->>'responsable_telefono',
        v_datos_step2->>'responsable_relacion'
    ) RETURNING pkid_perfiles_estudiante INTO v_perfil_id;
    
    -- Marcar proceso como completado
    UPDATE autenticacion_schema.proceso_registro 
    SET 
        estado_actual = 'COMPLETADO',
        datos_step_4 = jsonb_build_object(
            'perfil_id', v_perfil_id,
            'idioma_preferido', p_idioma_preferido_codigo,
            'fecha_completado', NOW()
        ),
        fecha_ultimo_paso = NOW()
    WHERE pkid_proceso_registro = p_proceso_id;
    
    -- Activar usuario
    UPDATE autenticacion_schema.usuarios 
    SET estado = 'ACTIVO'
    WHERE pkid_usuarios = v_proceso.usuario_id;
    
    -- Emitir domain event
    INSERT INTO shared_schema.domain_events (aggregate_type, aggregate_id, event_type, event_data)
    VALUES (
        'EstudianteRegistrado',
        v_proceso.usuario_id,
        'RegistroCompletado',
        jsonb_build_object(
            'proceso_id', p_proceso_id,
            'perfil_id', v_perfil_id,
            'es_menor_edad', v_proceso.es_menor_edad,
            'timestamp', NOW()
        )
    );
    
    RETURN QUERY SELECT v_proceso.usuario_id, v_perfil_id, TRUE, 'Registro completado exitosamente';
END;
$$ LANGUAGE plpgsql;

-- ====================
-- 2. SCRIPTS PARA TESTING (Ejecutar en DBeaver)
-- ====================

-- Script de ejemplo: Registro completo de estudiante mayor de edad
DO $$
DECLARE
    v_proceso_id UUID;
    v_otp_code VARCHAR(6);
    v_archivo_foto UUID;
    v_archivo_doc_frontal UUID;
    v_archivo_doc_trasero UUID;
    v_archivo_selfie UUID;
    v_verificacion_id UUID;
    v_usuario_id UUID;
    v_perfil_id UUID;
    resultado RECORD;
BEGIN
    RAISE NOTICE '=== INICIANDO REGISTRO DE ESTUDIANTE MAYOR DE EDAD ===';
    
    -- Step 1: Iniciar registro
    SELECT * FROM autenticacion_schema.iniciar_registro_estudiante(
        'juan.perez@email.com',
        '$2a$12$LQv3c1yqBwlVHpfEOUP/g.YnBs4Qg7p4Vf8qf8p4Vf8qf8p4Vf8qf8',
        '192.168.1.100'::INET,
        'Mozilla/5.0 Test Browser',
        'session_123'
    ) INTO resultado;
    
    IF resultado.success THEN
        v_proceso_id := resultado.proceso_id;
        v_otp_code := resultado.otp_code;
        RAISE NOTICE 'Step 1 OK - Proceso ID: %, OTP: %', v_proceso_id, v_otp_code;
    ELSE
        RAISE EXCEPTION 'Error en Step 1: %', resultado.message;
    END IF;
    
    -- Verificar OTP
    SELECT * FROM autenticacion_schema.verificar_otp_registro(v_proceso_id, v_otp_code) INTO resultado;
    
    IF resultado.success THEN
        RAISE NOTICE 'OTP verificado OK';
    ELSE
        RAISE EXCEPTION 'Error verificando OTP: %', resultado.message;
    END IF;
    
    -- Step 2: Datos personales
    SELECT * FROM autenticacion_schema.guardar_datos_personales_registro(
        v_proceso_id,
        'juan carlos',           -- primer_nombre
        'antonio',               -- segundo_nombre  
        'pérez',                 -- primer_apellido
        'garcía',                -- segundo_apellido
        '1995-03-15'::DATE,      -- fecha_nacimiento (28 años)
        'M',                     -- genero
        '+57300123456',          -- telefono
        'CO',                    -- pais_codigo
        'Bogotá',                -- ciudad
        'Carrera 15 #45-67',     -- direccion
        'Universitario',         -- nivel_educativo
        'Universidad Nacional',   -- institucion_educativa
        'Estudiante de ingeniería interesado en matemáticas', -- sobre_mi
        NULL, NULL, NULL, NULL, NULL, -- responsable (no aplica)
        TRUE                     -- terminos_aceptados
    ) INTO resultado;
    
    IF resultado.success THEN
        RAISE NOTICE 'Step 2 OK - Es menor: %, Requiere responsable: %', resultado.es_menor_edad, resultado.requiere_responsable;
    ELSE
        RAISE EXCEPTION 'Error en Step 2: %', resultado.message;
    END IF;
    
    -- Simular subida de archivos
    SELECT archivo_id FROM shared_schema.guardar_archivo(
        'foto_perfil_juan.jpg',
        'FOTO_PERFIL',
        'image/jpeg',
        524288, -- 512KB
        '/uploads/2025/11/14/foto_perfil_juan.jpg',
        'https://cdn.mitoga.com/uploads/2025/11/14/foto_perfil_juan.jpg',
        800, 600,
        'abc123def456',
        'sha256hash'
    ) INTO v_archivo_foto;
    
    SELECT archivo_id FROM shared_schema.guardar_archivo(
        'cedula_frontal_juan.jpg',
        'DOCUMENTO_FRONTAL', 
        'image/jpeg',
        1048576, -- 1MB
        '/uploads/2025/11/14/cedula_frontal_juan.jpg'
    ) INTO v_archivo_doc_frontal;
    
    SELECT archivo_id FROM shared_schema.guardar_archivo(
        'cedula_trasera_juan.jpg',
        'DOCUMENTO_TRASERO',
        'image/jpeg', 
        1048576,
        '/uploads/2025/11/14/cedula_trasera_juan.jpg'
    ) INTO v_archivo_doc_trasero;
    
    SELECT archivo_id FROM shared_schema.guardar_archivo(
        'selfie_juan.jpg',
        'SELFIE_VERIFICACION',
        'image/jpeg',
        768432,
        '/uploads/2025/11/14/selfie_juan.jpg'
    ) INTO v_archivo_selfie;
    
    RAISE NOTICE 'Archivos creados - Foto: %, Doc F: %, Doc T: %, Selfie: %', 
        v_archivo_foto, v_archivo_doc_frontal, v_archivo_doc_trasero, v_archivo_selfie;
    
    -- Step 3: Verificación biométrica
    SELECT * FROM autenticacion_schema.guardar_verificacion_biometrica(
        v_proceso_id,
        'CEDULA_CIUDADANIA',
        '1234567890',
        'BOGOTA',
        '2013-05-10'::DATE,
        '2023-05-10'::DATE,
        v_archivo_foto,
        v_archivo_doc_frontal,
        v_archivo_doc_trasero,
        v_archivo_selfie,
        NULL, NULL, -- responsable docs (no aplica)
        '{"nombres": "JUAN CARLOS ANTONIO", "apellidos": "PEREZ GARCIA", "numero": "1234567890"}'::JSONB
    ) INTO resultado;
    
    IF resultado.success THEN
        v_verificacion_id := resultado.verificacion_id;
        RAISE NOTICE 'Step 3 OK - Verificación ID: %', v_verificacion_id;
    ELSE
        RAISE EXCEPTION 'Error en Step 3: %', resultado.message;
    END IF;
    
    -- Step 4: Completar registro
    SELECT * FROM autenticacion_schema.completar_registro_estudiante(
        v_proceso_id,
        'es'
    ) INTO resultado;
    
    IF resultado.success THEN
        v_usuario_id := resultado.usuario_id;
        v_perfil_id := resultado.perfil_id;
        RAISE NOTICE 'Step 4 OK - Usuario ID: %, Perfil ID: %', v_usuario_id, v_perfil_id;
        RAISE NOTICE '=== REGISTRO COMPLETADO EXITOSAMENTE ===';
    ELSE
        RAISE EXCEPTION 'Error en Step 4: %', resultado.message;
    END IF;
    
END $$;

-- ====================
-- 3. CONSULTAS DE VALIDACIÓN
-- ====================

-- Consultar proceso de registro
SELECT 
    pr.pkid_proceso_registro,
    pr.estado_actual,
    pr.step_completado,
    pr.es_menor_edad,
    pr.otp_verificado,
    pr.terminos_aceptados,
    u.email,
    u.estado AS usuario_estado,
    pe.nombre_completo,
    pe.edad
FROM autenticacion_schema.proceso_registro pr
LEFT JOIN autenticacion_schema.usuarios u ON pr.usuario_id = u.pkid_usuarios
LEFT JOIN perfiles_schema.perfiles_estudiante pe ON u.pkid_usuarios = pe.usuario_id
WHERE pr.estado_actual = 'COMPLETADO'
ORDER BY pr.creation_date DESC
LIMIT 5;

-- Consultar archivos subidos
SELECT 
    a.pkid_archivos,
    a.nombre_original,
    a.tipo_archivo,
    a.tamaño_bytes,
    a.storage_path,
    a.ancho_px,
    a.alto_px
FROM shared_schema.archivos a
ORDER BY a.creation_date DESC
LIMIT 10;

-- Consultar verificaciones de identidad pendientes
SELECT 
    vi.pkid_verificacion_identidad,
    u.email,
    pe.nombre_completo,
    vi.tipo_documento,
    vi.numero_documento,
    vi.estado,
    vi.creation_date
FROM autenticacion_schema.verificacion_identidad vi
JOIN autenticacion_schema.usuarios u ON vi.usuario_id = u.pkid_usuarios
JOIN perfiles_schema.perfiles_estudiante pe ON u.pkid_usuarios = pe.usuario_id
WHERE vi.estado = 'PENDIENTE'
ORDER BY vi.creation_date DESC;

-- Domain Events recientes
SELECT 
    de.aggregate_type,
    de.aggregate_id,
    de.event_type,
    de.event_data,
    de.occurred_on
FROM shared_schema.domain_events de
WHERE de.aggregate_type IN ('ProcesoRegistro', 'EstudianteRegistrado')
ORDER BY de.occurred_on DESC
LIMIT 10;

-- ====================
-- 4. STORED PROCEDURE DE LIMPIEZA (Mantenimiento)
-- ====================

-- Ejecutar limpieza de procesos expirados
SELECT autenticacion_schema.limpiar_procesos_expirados();

COMMENT ON FUNCTION autenticacion_schema.iniciar_registro_estudiante IS 'Inicia proceso multi-step de registro de estudiante (Step 1)';
COMMENT ON FUNCTION autenticacion_schema.verificar_otp_registro IS 'Verifica código OTP y avanza al Step 2';
COMMENT ON FUNCTION autenticacion_schema.guardar_datos_personales_registro IS 'Guarda datos personales y responsable (Step 2)';
COMMENT ON FUNCTION autenticacion_schema.guardar_verificacion_biometrica IS 'Guarda verificación biométrica (Step 3)';
COMMENT ON FUNCTION autenticacion_schema.completar_registro_estudiante IS 'Completa registro creando perfil (Step 4)';
COMMENT ON FUNCTION shared_schema.guardar_archivo IS 'Guarda metadata de archivo/imagen en storage externo';