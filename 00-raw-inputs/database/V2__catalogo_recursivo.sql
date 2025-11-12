-- ============================================================================
-- Migration: V2__catalogo_recursivo.sql
-- Description: Tabla recursiva para manejo de catálogos/diccionarios jerárquicos
--              Para dropdown lists del frontend con estructura de árbol (padre-hijo)
--              Ejemplos: categorías, especialidades, ubicaciones, tipos de documento, etc.
-- Author: Database Engineering Team - MI-TOGA
-- Date: 2025-11-12
-- Bounded Context: Shared Kernel
-- Story: Gestión de Catálogos Dinámicos Jerárquicos
-- PostgreSQL Version: 16.x
-- Prompt: prompt-ingeniero-base-datos-senior.md v2.0
-- Ejecutable en: DBeaver, pgAdmin, psql
-- ============================================================================

-- ====================
-- COMENTARIO TÉCNICO
-- ====================
-- Esta tabla implementa un patrón de "Adjacency List" para representar
-- jerarquías de N niveles. Permite construir árboles de catálogos donde:
-- - Un nodo puede tener múltiples hijos
-- - Un nodo tiene exactamente un padre (o NULL si es raíz)
-- - Soporta búsquedas recursivas con CTEs (Common Table Expressions)
-- - Incluye columnas de ordenamiento y configuración por catálogo
--
-- VENTAJAS:
-- ✅ Una sola tabla para todos los catálogos del sistema
-- ✅ Jerarquías ilimitadas (categorías → subcategorías → sub-subcategorías)
-- ✅ Fácil de mantener y consultar con CTEs recursivas de PostgreSQL
-- ✅ Soporte para soft delete en toda la jerarquía
-- ✅ Ordenamiento personalizado por nivel
-- ✅ Metadatos flexibles con JSONB
--
-- CASOS DE USO:
-- 1. Categorías de tutorías (Matemáticas → Álgebra → Ecuaciones)
-- 2. Ubicaciones geográficas (País → Departamento → Ciudad)
-- 3. Tipos de documento (Identificación → Cédula/Pasaporte/DNI)
-- 4. Especialidades académicas (Ciencias → Física → Mecánica)
-- 5. Tags/Etiquetas jerárquicas
-- ====================

CREATE TABLE shared_schema.catalogo_recursivo (
    -- ========================================
    -- CAMPOS OBLIGATORIOS ESTÁNDAR (SIEMPRE PRIMEROS 3)
    -- ========================================
    pkid_catalogo_recursivo UUID DEFAULT gen_random_uuid() NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ NULL,
    
    -- ========================================
    -- CAMPOS DE JERARQUÍA (Core del patrón recursivo)
    -- ========================================
    
    -- Identificador del catálogo al que pertenece este nodo
    -- Ejemplo: 'categorias_tutorias', 'ubicaciones', 'tipos_documento'
    catalogo_tipo VARCHAR(100) NOT NULL,
    
    -- Referencia al nodo padre (NULL = nodo raíz)
    -- Self-referencing FK para construir la jerarquía
    fkid_padre UUID NULL,
    
    -- Nivel de profundidad en el árbol (0 = raíz, 1 = primer nivel, etc.)
    -- Calculado automáticamente por trigger para optimizar consultas
    nivel SMALLINT NOT NULL DEFAULT 0,
    
    -- Path completo desde la raíz (ej: '/1/5/12' para navegación rápida)
    -- Útil para consultas de "todos los descendientes" sin recursión
    path_completo TEXT,
    
    -- ========================================
    -- CAMPOS DE NEGOCIO
    -- ========================================
    
    -- Código único dentro del catálogo (ej: 'MAT-001', 'COL-BOG', 'DNI')
    -- Útil para integraciones y referencias en código
    codigo VARCHAR(50) NOT NULL,
    
    -- Nombre visible para el usuario (español por defecto)
    nombre VARCHAR(255) NOT NULL,
    
    -- Nombre en inglés (para i18n)
    nombre_en VARCHAR(255),
    
    -- Descripción detallada del elemento
    descripcion TEXT,
    
    -- Descripción en inglés (para i18n)
    descripcion_en TEXT,
    
    -- Orden de presentación dentro del mismo nivel y padre
    -- 0 = primero, mayor número = más abajo
    orden SMALLINT NOT NULL DEFAULT 0,
    
    -- Icono o clase CSS para el frontend (ej: 'fa-book', 'icon-math')
    icono VARCHAR(100),
    
    -- Color hexadecimal para UI (ej: '#FF5733')
    color CHAR(7),
    
    -- Estado activo/inactivo (filtro en consultas del frontend)
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- Indica si el nodo es seleccionable en el frontend
    -- FALSE = solo agrupador (ej: "Matemáticas" no seleccionable, pero "Álgebra" sí)
    seleccionable BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- Indica si el nodo tiene hijos (denormalizado para performance)
    -- Actualizado por trigger automáticamente
    tiene_hijos BOOLEAN NOT NULL DEFAULT FALSE,
    
    -- Metadatos adicionales en formato JSON (flexible)
    -- Ejemplo: {"min_edad": 18, "requiere_certificado": true}
    metadatos JSONB,
    
    -- ========================================
    -- CAMPOS DE AUDITORÍA (Opcionales)
    -- ========================================
    created_by UUID,
    updated_at TIMESTAMPTZ,
    updated_by UUID,
    
    -- ========================================
    -- CONSTRAINTS
    -- ========================================
    CONSTRAINT pk_catalogo_recursivo PRIMARY KEY (pkid_catalogo_recursivo),
    
    -- Un código debe ser único dentro de cada tipo de catálogo
    CONSTRAINT uq_catalogo_codigo UNIQUE (catalogo_tipo, codigo),
    
    -- Self-referencing FK para la jerarquía
    CONSTRAINT fk_catalogo_padre FOREIGN KEY (fkid_padre) 
        REFERENCES shared_schema.catalogo_recursivo(pkid_catalogo_recursivo)
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Validación de nivel (no puede ser negativo)
    CONSTRAINT ck_catalogo_nivel CHECK (nivel >= 0 AND nivel < 100),
    
    -- Validación de orden (rango razonable)
    CONSTRAINT ck_catalogo_orden CHECK (orden >= 0 AND orden < 9999),
    
    -- Validación de color hexadecimal (si se proporciona)
    CONSTRAINT ck_catalogo_color CHECK (color IS NULL OR color ~ '^#[0-9A-Fa-f]{6}$'),
    
    -- Restricción: nodos raíz no pueden tener padre
    CONSTRAINT ck_catalogo_raiz CHECK (
        (nivel = 0 AND fkid_padre IS NULL) OR 
        (nivel > 0 AND fkid_padre IS NOT NULL)
    )
);

-- ========================================
-- ÍNDICES (Performance)
-- ========================================

-- Índice principal: búsquedas por tipo de catálogo y estado
CREATE INDEX idx_catalogo_tipo_activo 
    ON shared_schema.catalogo_recursivo(catalogo_tipo, activo) 
    WHERE expiration_date IS NULL;

-- Índice para navegación jerárquica (obtener hijos de un padre)
CREATE INDEX idx_catalogo_padre 
    ON shared_schema.catalogo_recursivo(fkid_padre) 
    WHERE expiration_date IS NULL AND fkid_padre IS NOT NULL;

-- Índice para nodos raíz
CREATE INDEX idx_catalogo_raiz 
    ON shared_schema.catalogo_recursivo(catalogo_tipo) 
    WHERE expiration_date IS NULL AND fkid_padre IS NULL;

-- Índice para búsquedas por código
CREATE INDEX idx_catalogo_codigo 
    ON shared_schema.catalogo_recursivo(codigo) 
    WHERE expiration_date IS NULL;

-- Índice para ordenamiento
CREATE INDEX idx_catalogo_orden 
    ON shared_schema.catalogo_recursivo(catalogo_tipo, fkid_padre, orden) 
    WHERE expiration_date IS NULL AND activo = TRUE;

-- Índice GIN para búsquedas en metadatos JSONB
CREATE INDEX idx_catalogo_metadatos 
    ON shared_schema.catalogo_recursivo USING GIN(metadatos) 
    WHERE expiration_date IS NULL;

-- Índice para búsquedas full-text en nombre y descripción
CREATE INDEX idx_catalogo_fulltext 
    ON shared_schema.catalogo_recursivo 
    USING GIN(to_tsvector('spanish', nombre || ' ' || COALESCE(descripcion, '')))
    WHERE expiration_date IS NULL;

-- ========================================
-- COMENTARIOS (Documentación)
-- ========================================

COMMENT ON TABLE shared_schema.catalogo_recursivo IS 
'Tabla recursiva para catálogos/diccionarios jerárquicos. Patrón Adjacency List.
Casos de uso: categorías, ubicaciones, tipos de documento, especialidades, tags.
Soporta jerarquías N-niveles con búsquedas recursivas vía CTEs.
Incluye soft delete, i18n (es/en), ordenamiento y metadatos JSONB flexibles.';

COMMENT ON COLUMN shared_schema.catalogo_recursivo.pkid_catalogo_recursivo IS 
'Primary Key UUID de la tabla catalogo_recursivo';

COMMENT ON COLUMN shared_schema.catalogo_recursivo.creation_date IS 
'Fecha y hora de creación del registro (inmutable)';

COMMENT ON COLUMN shared_schema.catalogo_recursivo.expiration_date IS 
'Soft delete: NULL = activo, NOT NULL = fecha de eliminación lógica. 
Al eliminar un padre, se propaga a todos los hijos por CASCADE.';

COMMENT ON COLUMN shared_schema.catalogo_recursivo.catalogo_tipo IS 
'Identificador del tipo de catálogo. Ejemplos: categorias_tutorias, ubicaciones, tipos_documento.
Permite tener múltiples catálogos independientes en una sola tabla.';

COMMENT ON COLUMN shared_schema.catalogo_recursivo.fkid_padre IS 
'Foreign Key al nodo padre. NULL = nodo raíz (nivel 0).
Self-referencing FK para construir la jerarquía.';

COMMENT ON COLUMN shared_schema.catalogo_recursivo.nivel IS 
'Nivel de profundidad en el árbol. 0 = raíz, 1 = primer nivel hijo, etc.
Calculado automáticamente por trigger para optimizar consultas.';

COMMENT ON COLUMN shared_schema.catalogo_recursivo.path_completo IS 
'Path completo desde la raíz usando PKIDs separados por /. 
Ejemplo: /uuid-raiz/uuid-hijo/uuid-nieto. 
Optimiza consultas de "todos los descendientes" sin recursión.';

COMMENT ON COLUMN shared_schema.catalogo_recursivo.codigo IS 
'Código único dentro del catálogo_tipo. Útil para referencias en código.
Ejemplos: MAT-001 (Matemáticas), COL-BOG (Bogotá), DNI (Cédula).';

COMMENT ON COLUMN shared_schema.catalogo_recursivo.nombre IS 
'Nombre visible en español (idioma por defecto). 
Ejemplos: "Matemáticas", "Bogotá", "Documento Nacional de Identidad".';

COMMENT ON COLUMN shared_schema.catalogo_recursivo.nombre_en IS 
'Nombre visible en inglés (internacionalización). 
Ejemplos: "Mathematics", "Bogota", "National Identity Document".';

COMMENT ON COLUMN shared_schema.catalogo_recursivo.orden IS 
'Orden de presentación dentro del mismo nivel y padre.
0 = primero, 1 = segundo, etc. Usado en ORDER BY para dropdowns.';

COMMENT ON COLUMN shared_schema.catalogo_recursivo.icono IS 
'Clase CSS o identificador de icono para el frontend.
Ejemplos: "fa-book", "icon-math", "material-icons:location_on".';

COMMENT ON COLUMN shared_schema.catalogo_recursivo.color IS 
'Color hexadecimal para UI (#RRGGBB). 
Ejemplos: #FF5733 (rojo), #3498DB (azul).';

COMMENT ON COLUMN shared_schema.catalogo_recursivo.activo IS 
'Estado del nodo. TRUE = visible en frontend, FALSE = oculto.
Filtrar en consultas con WHERE activo = TRUE.';

COMMENT ON COLUMN shared_schema.catalogo_recursivo.seleccionable IS 
'Indica si el nodo puede ser seleccionado en el frontend.
FALSE = solo agrupador/categoría (ej: "Ciencias" no seleccionable).
TRUE = elemento final seleccionable (ej: "Física Cuántica" seleccionable).';

COMMENT ON COLUMN shared_schema.catalogo_recursivo.tiene_hijos IS 
'Denormalizado para performance. TRUE = tiene nodos hijos.
Actualizado automáticamente por trigger. 
Útil para mostrar iconos de expand/collapse en UI.';

COMMENT ON COLUMN shared_schema.catalogo_recursivo.metadatos IS 
'Metadatos flexibles en formato JSONB.
Ejemplos:
- {"min_edad": 18, "requiere_certificado": true}
- {"poblacion": 8000000, "codigo_postal_inicio": "110"}
- {"nivel_dificultad": "avanzado", "horas_estimadas": 40}';

-- ========================================
-- TRIGGERS (Automatización)
-- ========================================

-- Trigger 1: Calcular nivel y path automáticamente
CREATE OR REPLACE FUNCTION shared_schema.catalogo_calcular_nivel_path()
RETURNS TRIGGER AS $$
DECLARE
    v_nivel SMALLINT;
    v_path TEXT;
BEGIN
    IF NEW.fkid_padre IS NULL THEN
        -- Es un nodo raíz
        NEW.nivel = 0;
        NEW.path_completo = '/' || NEW.pkid_catalogo_recursivo::TEXT;
    ELSE
        -- Obtener nivel y path del padre
        SELECT nivel + 1, path_completo || '/' || NEW.pkid_catalogo_recursivo::TEXT
        INTO v_nivel, v_path
        FROM shared_schema.catalogo_recursivo
        WHERE pkid_catalogo_recursivo = NEW.fkid_padre
          AND expiration_date IS NULL;
        
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Padre con ID % no existe o está eliminado', NEW.fkid_padre;
        END IF;
        
        NEW.nivel = v_nivel;
        NEW.path_completo = v_path;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_catalogo_calcular_nivel_path
    BEFORE INSERT OR UPDATE OF fkid_padre
    ON shared_schema.catalogo_recursivo
    FOR EACH ROW
    EXECUTE FUNCTION shared_schema.catalogo_calcular_nivel_path();

COMMENT ON FUNCTION shared_schema.catalogo_calcular_nivel_path() IS 
'Trigger function: Calcula automáticamente nivel y path_completo basándose en el padre.
Ejecuta en INSERT y UPDATE de fkid_padre.';

-- Trigger 2: Actualizar campo tiene_hijos en el padre
CREATE OR REPLACE FUNCTION shared_schema.catalogo_actualizar_tiene_hijos()
RETURNS TRIGGER AS $$
BEGIN
    -- Cuando se inserta un hijo, marcar padre como tiene_hijos = TRUE
    IF TG_OP = 'INSERT' AND NEW.fkid_padre IS NOT NULL THEN
        UPDATE shared_schema.catalogo_recursivo
        SET tiene_hijos = TRUE
        WHERE pkid_catalogo_recursivo = NEW.fkid_padre
          AND NOT tiene_hijos;
    END IF;
    
    -- Cuando se elimina un hijo, verificar si el padre sigue teniendo hijos
    IF TG_OP = 'DELETE' AND OLD.fkid_padre IS NOT NULL THEN
        UPDATE shared_schema.catalogo_recursivo
        SET tiene_hijos = EXISTS (
            SELECT 1 
            FROM shared_schema.catalogo_recursivo 
            WHERE fkid_padre = OLD.fkid_padre 
              AND expiration_date IS NULL
              AND pkid_catalogo_recursivo != OLD.pkid_catalogo_recursivo
        )
        WHERE pkid_catalogo_recursivo = OLD.fkid_padre;
    END IF;
    
    -- Cuando se hace soft delete (UPDATE expiration_date)
    IF TG_OP = 'UPDATE' AND NEW.expiration_date IS NOT NULL AND OLD.expiration_date IS NULL THEN
        IF OLD.fkid_padre IS NOT NULL THEN
            UPDATE shared_schema.catalogo_recursivo
            SET tiene_hijos = EXISTS (
                SELECT 1 
                FROM shared_schema.catalogo_recursivo 
                WHERE fkid_padre = OLD.fkid_padre 
                  AND expiration_date IS NULL
                  AND pkid_catalogo_recursivo != OLD.pkid_catalogo_recursivo
            )
            WHERE pkid_catalogo_recursivo = OLD.fkid_padre;
        END IF;
    END IF;
    
    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_catalogo_actualizar_tiene_hijos
    AFTER INSERT OR UPDATE OR DELETE
    ON shared_schema.catalogo_recursivo
    FOR EACH ROW
    EXECUTE FUNCTION shared_schema.catalogo_actualizar_tiene_hijos();

COMMENT ON FUNCTION shared_schema.catalogo_actualizar_tiene_hijos() IS 
'Trigger function: Actualiza automáticamente el campo tiene_hijos del padre.
Ejecuta en INSERT, UPDATE y DELETE de nodos hijos.';

-- Trigger 3: Actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION shared_schema.catalogo_actualizar_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_catalogo_actualizar_timestamp
    BEFORE UPDATE
    ON shared_schema.catalogo_recursivo
    FOR EACH ROW
    EXECUTE FUNCTION shared_schema.catalogo_actualizar_timestamp();

COMMENT ON FUNCTION shared_schema.catalogo_actualizar_timestamp() IS 
'Trigger function: Actualiza automáticamente updated_at en cada UPDATE.';

-- ========================================
-- FUNCIONES DE UTILIDAD (Consultas recursivas)
-- ========================================

-- Función 1: Obtener todos los hijos (descendientes) de un nodo
CREATE OR REPLACE FUNCTION shared_schema.catalogo_obtener_descendientes(
    p_padre_id UUID,
    p_incluir_padre BOOLEAN DEFAULT FALSE
)
RETURNS TABLE (
    pkid UUID,
    catalogo_tipo VARCHAR,
    codigo VARCHAR,
    nombre VARCHAR,
    nivel SMALLINT,
    fkid_padre UUID,
    path_completo TEXT,
    activo BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    WITH RECURSIVE descendientes AS (
        -- Caso base: el nodo padre
        SELECT 
            c.pkid_catalogo_recursivo,
            c.catalogo_tipo,
            c.codigo,
            c.nombre,
            c.nivel,
            c.fkid_padre,
            c.path_completo,
            c.activo
        FROM shared_schema.catalogo_recursivo c
        WHERE c.pkid_catalogo_recursivo = p_padre_id
          AND c.expiration_date IS NULL
        
        UNION ALL
        
        -- Caso recursivo: hijos de cada nodo
        SELECT 
            c.pkid_catalogo_recursivo,
            c.catalogo_tipo,
            c.codigo,
            c.nombre,
            c.nivel,
            c.fkid_padre,
            c.path_completo,
            c.activo
        FROM shared_schema.catalogo_recursivo c
        INNER JOIN descendientes d ON c.fkid_padre = d.pkid_catalogo_recursivo
        WHERE c.expiration_date IS NULL
    )
    SELECT 
        d.pkid_catalogo_recursivo,
        d.catalogo_tipo,
        d.codigo,
        d.nombre,
        d.nivel,
        d.fkid_padre,
        d.path_completo,
        d.activo
    FROM descendientes d
    WHERE p_incluir_padre OR d.pkid_catalogo_recursivo != p_padre_id
    ORDER BY d.nivel, d.codigo;
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION shared_schema.catalogo_obtener_descendientes IS 
'Obtiene todos los descendientes (hijos, nietos, etc.) de un nodo específico.
Parámetros:
- p_padre_id: UUID del nodo padre
- p_incluir_padre: TRUE para incluir el nodo padre en el resultado
Retorna: Tabla con todos los descendientes ordenados por nivel y código.';

-- Función 2: Obtener todos los ancestros (padres) de un nodo
CREATE OR REPLACE FUNCTION shared_schema.catalogo_obtener_ancestros(
    p_hijo_id UUID,
    p_incluir_hijo BOOLEAN DEFAULT FALSE
)
RETURNS TABLE (
    pkid UUID,
    catalogo_tipo VARCHAR,
    codigo VARCHAR,
    nombre VARCHAR,
    nivel SMALLINT,
    fkid_padre UUID,
    path_completo TEXT
) AS $$
BEGIN
    RETURN QUERY
    WITH RECURSIVE ancestros AS (
        -- Caso base: el nodo hijo
        SELECT 
            c.pkid_catalogo_recursivo,
            c.catalogo_tipo,
            c.codigo,
            c.nombre,
            c.nivel,
            c.fkid_padre,
            c.path_completo
        FROM shared_schema.catalogo_recursivo c
        WHERE c.pkid_catalogo_recursivo = p_hijo_id
          AND c.expiration_date IS NULL
        
        UNION ALL
        
        -- Caso recursivo: padres de cada nodo
        SELECT 
            c.pkid_catalogo_recursivo,
            c.catalogo_tipo,
            c.codigo,
            c.nombre,
            c.nivel,
            c.fkid_padre,
            c.path_completo
        FROM shared_schema.catalogo_recursivo c
        INNER JOIN ancestros a ON c.pkid_catalogo_recursivo = a.fkid_padre
        WHERE c.expiration_date IS NULL
    )
    SELECT 
        a.pkid_catalogo_recursivo,
        a.catalogo_tipo,
        a.codigo,
        a.nombre,
        a.nivel,
        a.fkid_padre,
        a.path_completo
    FROM ancestros a
    WHERE p_incluir_hijo OR a.pkid_catalogo_recursivo != p_hijo_id
    ORDER BY a.nivel;
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION shared_schema.catalogo_obtener_ancestros IS 
'Obtiene todos los ancestros (padres, abuelos, etc.) de un nodo específico.
Parámetros:
- p_hijo_id: UUID del nodo hijo
- p_incluir_hijo: TRUE para incluir el nodo hijo en el resultado
Retorna: Tabla con todos los ancestros ordenados por nivel (raíz primero).';

-- Función 3: Obtener árbol completo de un catálogo (para dropdown jerárquico)
-- Primero eliminamos la función existente para poder cambiar su firma
DROP FUNCTION IF EXISTS shared_schema.catalogo_obtener_arbol(VARCHAR, BOOLEAN, BOOLEAN);

CREATE OR REPLACE FUNCTION shared_schema.catalogo_obtener_arbol(
    p_catalogo_tipo VARCHAR,
    p_solo_activos BOOLEAN DEFAULT TRUE,
    p_solo_seleccionables BOOLEAN DEFAULT FALSE
)
RETURNS TABLE (
    pkid_catalogo_recursivo UUID,
    creation_date TIMESTAMPTZ,
    expiration_date TIMESTAMPTZ,
    catalogo_tipo VARCHAR,
    fkid_padre UUID,
    nivel SMALLINT,
    path_completo TEXT,
    codigo VARCHAR,
    nombre VARCHAR,
    nombre_en VARCHAR,
    descripcion TEXT,
    descripcion_en TEXT,
    orden SMALLINT,
    icono VARCHAR,
    color CHAR,
    activo BOOLEAN,
    seleccionable BOOLEAN,
    tiene_hijos BOOLEAN,
    metadatos JSONB,
    created_by UUID,
    updated_at TIMESTAMPTZ,
    updated_by UUID
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.pkid_catalogo_recursivo,
        c.creation_date,
        c.expiration_date,
        c.catalogo_tipo,
        c.fkid_padre,
        c.nivel,
        c.path_completo,
        c.codigo,
        c.nombre,
        c.nombre_en,
        c.descripcion,
        c.descripcion_en,
        c.orden,
        c.icono,
        c.color,
        c.activo,
        c.seleccionable,
        c.tiene_hijos,
        c.metadatos,
        c.created_by,
        c.updated_at,
        c.updated_by
    FROM shared_schema.catalogo_recursivo c
    WHERE c.catalogo_tipo = p_catalogo_tipo
      AND c.expiration_date IS NULL
      AND (NOT p_solo_activos OR c.activo = TRUE)
      AND (NOT p_solo_seleccionables OR c.seleccionable = TRUE)
    ORDER BY c.nivel, c.fkid_padre NULLS FIRST, c.orden, c.nombre;
END;
$$ LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION shared_schema.catalogo_obtener_arbol IS 
'Obtiene el árbol completo de un catálogo para construir dropdowns jerárquicos.
Parámetros:
- p_catalogo_tipo: Tipo de catálogo (ej: categorias_tutorias)
- p_solo_activos: TRUE para filtrar solo activos
- p_solo_seleccionables: TRUE para filtrar solo seleccionables
Retorna: Tabla ordenada por nivel, padre y orden para construir UI jerárquica.';

-- ========================================
-- DATOS DE EJEMPLO (Comentados - descomenta para testing)
-- ========================================

-- Ejemplo 1: Categorías de tutorías (3 niveles)
/*
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, codigo, nombre, nombre_en, orden, seleccionable, activo) 
VALUES
-- Nivel 0 (Raíces)
('categorias_tutorias', 'CAT-MATE', 'Matemáticas', 'Mathematics', 1, FALSE, TRUE),
('categorias_tutorias', 'CAT-CIEN', 'Ciencias', 'Sciences', 2, FALSE, TRUE),
('categorias_tutorias', 'CAT-LENG', 'Lenguas', 'Languages', 3, FALSE, TRUE);

-- Nivel 1 (Hijos de Matemáticas)
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, orden, seleccionable, activo) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-MATE-ALG',
    'Álgebra',
    'Algebra',
    1,
    TRUE,
    TRUE
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-MATE';

-- Nivel 2 (Hijos de Álgebra)
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, orden, seleccionable, activo, icono, color) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-MATE-ALG-ECUA',
    'Ecuaciones Lineales',
    'Linear Equations',
    1,
    TRUE,
    TRUE,
    'fa-calculator',
    '#3498DB'
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-MATE-ALG';
*/

-- Ejemplo 2: Ubicaciones geográficas (País → Departamento → Ciudad)
/*
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, codigo, nombre, nombre_en, orden, seleccionable, metadatos) 
VALUES
('ubicaciones', 'COL', 'Colombia', 'Colombia', 1, FALSE, '{"codigo_iso": "CO", "continente": "America"}');

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, orden, seleccionable, metadatos) 
SELECT 
    'ubicaciones',
    pkid_catalogo_recursivo,
    'COL-CUN',
    'Cundinamarca',
    1,
    FALSE,
    '{"codigo_dane": "25", "capital": "Bogotá"}'
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'COL';

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, orden, seleccionable, metadatos) 
SELECT 
    'ubicaciones',
    pkid_catalogo_recursivo,
    'COL-CUN-BOG',
    'Bogotá',
    1,
    TRUE,
    '{"poblacion": 8000000, "codigo_postal": "110"}'
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'COL-CUN';
*/

-- ========================================
-- CONSULTAS DE EJEMPLO (Testing en DBeaver)
-- ========================================

-- 1. Obtener todos los nodos raíz de un catálogo
/*
SELECT * 
FROM shared_schema.catalogo_recursivo
WHERE catalogo_tipo = 'categorias_tutorias'
  AND fkid_padre IS NULL
  AND expiration_date IS NULL
  AND activo = TRUE
ORDER BY orden;
*/

-- 2. Obtener hijos directos de un nodo
/*
SELECT * 
FROM shared_schema.catalogo_recursivo
WHERE fkid_padre = 'UUID-DEL-PADRE'
  AND expiration_date IS NULL
  AND activo = TRUE
ORDER BY orden;
*/

-- 3. Obtener todo el árbol de un catálogo (usando función)
/*
SELECT * FROM shared_schema.catalogo_obtener_arbol('categorias_tutorias', TRUE, FALSE);
*/

-- 4. Obtener todos los descendientes de un nodo (usando función)
/*
SELECT * FROM shared_schema.catalogo_obtener_descendientes('UUID-DEL-PADRE', FALSE);
*/

-- 5. Obtener breadcrumb/ruta completa de un nodo (usando función)
/*
SELECT * FROM shared_schema.catalogo_obtener_ancestros('UUID-DEL-HIJO', TRUE);
*/

-- 6. Búsqueda full-text en nombres
/*
SELECT * 
FROM shared_schema.catalogo_recursivo
WHERE catalogo_tipo = 'categorias_tutorias'
  AND to_tsvector('spanish', nombre || ' ' || COALESCE(descripcion, '')) @@ to_tsquery('spanish', 'matemática')
  AND expiration_date IS NULL
  AND activo = TRUE;
*/

-- 7. Contar nodos por nivel en un catálogo
/*
SELECT nivel, COUNT(*) as total_nodos
FROM shared_schema.catalogo_recursivo
WHERE catalogo_tipo = 'categorias_tutorias'
  AND expiration_date IS NULL
GROUP BY nivel
ORDER BY nivel;
*/

-- ============================================================================
-- FIN DEL SCRIPT
-- ============================================================================
