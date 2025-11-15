-- ============================================================================
-- Consultas Unificadas: Ver Estudiantes y Tutores Registrados
-- Descripción: Queries para consultar todos los registros de usuarios
-- Autor: Database Engineer Senior - ZNS-METHOD
-- Fecha: 2025-11-14
-- ⚠️ IMPORTANTE: Este script está adaptado para V1__init_schema.sql
-- Para funcionalidad completa, ejecutar primero V4__registro_estudiantes_multistep.sql
-- ============================================================================

-- VERIFICACIÓN RÁPIDA: ¿Qué tablas tenemos?
SELECT 
    '📋 VERIFICANDO TABLAS DISPONIBLES' AS mensaje;

SELECT 
    table_schema,
    table_name,
    CASE 
        WHEN table_name IN ('usuarios', 'tutores') THEN '✅ V1 - DISPONIBLE'
        WHEN table_name IN ('perfiles_estudiante', 'proceso_registro', 'verificacion_identidad') THEN '❌ V4 - FALTA'
        WHEN table_name IN ('archivos', 'storage_providers') THEN '❌ V4/V5 - FALTA'
        ELSE '🔧 OTRA'
    END AS estado
FROM information_schema.tables 
WHERE table_schema IN ('autenticacion_schema', 'perfiles_schema', 'marketplace_schema', 'shared_schema', 'storage_schema')
ORDER BY table_schema, table_name;

-- ====================
-- 1. VISTA COMPLETA DE ESTUDIANTES
-- ====================

-- Estudiantes con información disponible en V1 (antes de ejecutar V4)
-- NOTA: Esta consulta usa solo las tablas de V1__init_schema.sql
SELECT 
    -- Datos básicos de usuario
    u.pkid_usuarios,
    u.email,
    u.nombre AS nombre_usuario,
    u.apellido AS apellido_usuario,
    CONCAT(u.nombre, ' ', u.apellido) AS nombre_completo,
    u.rol,
    u.estado AS estado_usuario,
    u.fecha_registro,
    u.ultimo_acceso,
    u.fecha_verificacion_email,
    
    -- Información disponible
    '⚠️ EJECUTAR V4 PARA PERFIL COMPLETO' AS nota_importante,
    
    -- Stats
    CASE 
        WHEN u.ultimo_acceso IS NOT NULL THEN '✅ HA INGRESADO'
        ELSE '❌ NUNCA HA INGRESADO'
    END AS actividad,
    
    CASE 
        WHEN u.fecha_verificacion_email IS NOT NULL THEN '✅ EMAIL VERIFICADO'
        ELSE '❌ EMAIL SIN VERIFICAR'
    END AS estado_email,
    
    -- Días desde registro
    EXTRACT(DAY FROM NOW() - u.fecha_registro) AS dias_desde_registro

FROM autenticacion_schema.usuarios u
WHERE u.rol = 'ESTUDIANTE'
AND u.expiration_date IS NULL
ORDER BY u.fecha_registro DESC;

-- ====================
-- 2. VISTA COMPLETA DE TUTORES
-- ====================

-- Tutores con toda la información
SELECT 
    -- Datos básicos de usuario
    u.pkid_usuarios,
    u.email,
    u.nombre AS nombre_usuario,
    u.apellido AS apellido_usuario,
    u.rol,
    u.estado AS estado_usuario,
    u.fecha_registro,
    u.ultimo_acceso,
    
    -- Perfil de tutor (del marketplace)
    t.pkid_tutores,
    t.titulo_profesional,
    t.años_experiencia,
    t.descripcion,
    t.precio_por_hora,
    t.calificacion_promedio,
    t.total_sesiones,
    t.verificado AS tutor_verificado,
    t.activo AS tutor_activo,
    
    -- Especialidades y modalidades (JSON)
    COALESCE(
        string_agg(DISTINCT (t.especialidades->>0), ', '),
        'Sin especialidades'
    ) AS especialidades_principales,
    
    t.modalidades,
    
    -- Datos geográficos
    t.pais,
    t.ciudad,
    t.zona_horaria,
    
    -- Verificación de identidad
    vi.estado AS estado_verificacion,
    vi.fecha_verificacion,
    
    -- Archivos
    CASE WHEN vi.foto_perfil_id IS NOT NULL THEN '✅ SÍ' ELSE '❌ NO' END AS tiene_foto_perfil

FROM autenticacion_schema.usuarios u
LEFT JOIN marketplace_schema.tutores t ON u.pkid_usuarios = t.usuario_id
LEFT JOIN autenticacion_schema.verificacion_identidad vi ON u.pkid_usuarios = vi.usuario_id
WHERE u.rol = 'TUTOR'
AND u.expiration_date IS NULL
GROUP BY 
    u.pkid_usuarios, u.email, u.nombre, u.apellido, u.rol, u.estado, u.fecha_registro, u.ultimo_acceso,
    t.pkid_tutores, t.titulo_profesional, t.años_experiencia, t.descripcion, t.precio_por_hora, 
    t.calificacion_promedio, t.total_sesiones, t.verificado, t.activo, t.modalidades, 
    t.pais, t.ciudad, t.zona_horaria, vi.estado, vi.fecha_verificacion, vi.foto_perfil_id
ORDER BY u.fecha_registro DESC;

-- ====================
-- 3. RESUMEN ESTADÍSTICO DE REGISTROS
-- ====================

-- Estadísticas de registros por rol
SELECT 
    'RESUMEN DE REGISTROS' AS reporte,
    '=====================' AS separador;

-- ESTADÍSTICAS CON TABLAS V1 (antes de ejecutar V4)
SELECT 
    u.rol,
    COUNT(*) AS total_registrados,
    COUNT(*) FILTER (WHERE u.estado = 'ACTIVO') AS activos,
    COUNT(*) FILTER (WHERE u.estado = 'PENDIENTE_VERIFICACION') AS pendiente_verificacion,
    COUNT(*) FILTER (WHERE u.estado = 'SUSPENDIDO') AS suspendidos,
    COUNT(*) FILTER (WHERE u.estado = 'INACTIVO') AS inactivos,
    COUNT(*) FILTER (WHERE u.fecha_verificacion_email IS NOT NULL) AS email_verificados,
    COUNT(*) FILTER (WHERE u.ultimo_acceso IS NOT NULL) AS han_ingresado,
    MIN(u.fecha_registro) AS primer_registro,
    MAX(u.fecha_registro) AS ultimo_registro,
    '⚠️ Ejecutar V4 para stats completas' AS nota
FROM autenticacion_schema.usuarios u
WHERE u.expiration_date IS NULL
GROUP BY u.rol
ORDER BY u.rol;

-- ====================
-- 4. ESTUDIANTES MENORES DE EDAD CON RESPONSABLES
-- ====================

-- Casos especiales: menores de edad (DISPONIBLE DESPUÉS DE V4)
SELECT 
    'ESTUDIANTES MENORES DE EDAD' AS categoria,
    '===========================' AS separador;

SELECT 
    '⚠️ INFORMACIÓN DE MENORES DISPONIBLE DESPUÉS DE EJECUTAR V4__registro_estudiantes_multistep.sql' AS mensaje,
    'La tabla perfiles_schema.perfiles_estudiante se crea en V4' AS explicacion;

-- VERSIÓN SIMPLIFICADA CON V1:
SELECT 
    u.email,
    CONCAT(u.nombre, ' ', u.apellido) AS nombre_completo,
    u.estado,
    u.fecha_registro,
    'Ejecutar V4 para info detallada de edad' AS nota
FROM autenticacion_schema.usuarios u
WHERE u.rol = 'ESTUDIANTE'
AND u.expiration_date IS NULL
ORDER BY u.fecha_registro DESC;

-- ====================
-- 5. ARCHIVOS SUBIDOS POR USUARIOS
-- ====================

-- Documentos e imágenes por usuario
SELECT 
    'ARCHIVOS SUBIDOS POR USUARIO' AS categoria,
    '=============================' AS separador;

-- NOTA: Tabla shared_schema.archivos se crea en V4__registro_estudiantes_multistep.sql
SELECT 
    '⚠️ ARCHIVOS DISPONIBLES DESPUÉS DE EJECUTAR V4' AS mensaje,
    'Las funciones de gestión de imágenes están en gestion_imagenes_mejores_practicas.sql' AS info;

-- VERSIÓN SIMPLIFICADA: Verificar si existen archivos
SELECT 
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'archivos' AND table_schema = 'shared_schema')
        THEN 'Tabla archivos existe - ejecutar query completa'
        ELSE 'Tabla archivos NO existe - ejecutar V4 primero'
    END AS estado_tabla_archivos;

-- ====================
-- 6. PROCESOS DE REGISTRO EN CURSO
-- ====================

-- Registros incompletos o abandonados
SELECT 
    'PROCESOS DE REGISTRO EN CURSO' AS categoria,
    '==============================' AS separador;

SELECT 
    pr.pkid_proceso_registro,
    pr.datos_step_1->>'email' AS email_intento,
    pr.estado_actual,
    pr.step_completado,
    pr.es_menor_edad,
    pr.otp_verificado,
    pr.terminos_aceptados,
    pr.fecha_inicio,
    pr.fecha_ultimo_paso,
    pr.fecha_expiracion,
    CASE 
        WHEN pr.fecha_expiracion < NOW() THEN '⏰ EXPIRADO'
        WHEN pr.estado_actual = 'COMPLETADO' THEN '✅ COMPLETADO'
        WHEN pr.estado_actual = 'ABANDONADO' THEN '❌ ABANDONADO'
        ELSE '🔄 EN PROGRESO'
    END AS status,
    EXTRACT(EPOCH FROM (pr.fecha_ultimo_paso - pr.fecha_inicio))/60 AS duracion_minutos
FROM autenticacion_schema.proceso_registro pr
WHERE pr.expiration_date IS NULL
ORDER BY pr.fecha_ultimo_paso DESC
LIMIT 20;

-- ====================
-- 7. CONSULTA RÁPIDA DE BÚSQUEDA
-- ====================

-- Función para buscar usuario por email o nombre
-- Uso: Cambiar 'term_busqueda' por el texto a buscar
WITH term_busqueda AS (
    SELECT 'juan' AS search_term  -- ← CAMBIAR AQUÍ PARA BUSCAR
)
SELECT 
    '🔍 RESULTADOS DE BÚSQUEDA' AS categoria,
    '========================' AS separador;

-- BÚSQUEDA CON TABLAS V1
SELECT 
    u.pkid_usuarios,
    u.email,
    u.rol,
    CONCAT(u.nombre, ' ', u.apellido) AS nombre_completo,
    u.estado,
    u.fecha_registro,
    CASE 
        WHEN u.fecha_verificacion_email IS NOT NULL THEN '✅ Email verificado'
        ELSE '❌ Email pendiente'
    END AS estado_verificacion,
    '⚠️ Ejecutar V4 para teléfono y más datos' AS nota
FROM autenticacion_schema.usuarios u
CROSS JOIN term_busqueda tb
WHERE u.expiration_date IS NULL
AND (
    LOWER(u.email) LIKE LOWER('%' || tb.search_term || '%')
    OR LOWER(u.nombre) LIKE LOWER('%' || tb.search_term || '%') 
    OR LOWER(u.apellido) LIKE LOWER('%' || tb.search_term || '%')
)
ORDER BY u.fecha_registro DESC;

-- ====================
-- COMENTARIOS PARA USO EN DBEAVER
-- ====================

/*
📋 GUÍA DE USO EN DBEAVER:

1. **Ver todos los estudiantes:**
   - Ejecutar la primera query (VISTA COMPLETA DE ESTUDIANTES)
   
2. **Ver todos los tutores:**
   - Ejecutar la segunda query (VISTA COMPLETA DE TUTORES)
   
3. **Estadísticas generales:**
   - Ejecutar la tercera query (RESUMEN ESTADÍSTICO)
   
4. **Buscar un usuario específico:**
   - Ir a la sección 7 (CONSULTA RÁPIDA DE BÚSQUEDA)
   - Cambiar 'juan' por el nombre/email que busques
   - Ejecutar

5. **Ver menores de edad:**
   - Ejecutar la cuarta query (ESTUDIANTES MENORES DE EDAD)

6. **Ver archivos subidos:**
   - Ejecutar la quinta query (ARCHIVOS SUBIDOS)

7. **Ver registros incompletos:**
   - Ejecutar la sexta query (PROCESOS DE REGISTRO EN CURSO)

💡 TIPS:
- Todas las queries están optimizadas para performance
- Los resultados incluyen iconos visuales (✅❌🔄) para fácil identificación
- Puedes copiar/pegar queries individuales según necesites
*/