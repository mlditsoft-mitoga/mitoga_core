# 📚 Documentación Técnica - Tabla Catálogo Recursivo

## 🎯 Información General

**Archivo:** `V2__catalogo_recursivo.sql`  
**Fecha:** 12 de noviembre de 2025  
**Autor:** Database Engineering Team - MI-TOGA  
**Schema:** `shared_schema`  
**PostgreSQL:** 16.x compatible  
**Patrón:** Adjacency List (Lista de Adyacencia)

---

## 📋 Descripción

Tabla recursiva para gestionar catálogos/diccionarios jerárquicos de N niveles. Implementa el patrón **Adjacency List** que permite representar estructuras de árbol (padre-hijo) en una sola tabla relacional.

### Casos de Uso

1. **Categorías de Tutorías**: Matemáticas → Álgebra → Ecuaciones Lineales
2. **Ubicaciones Geográficas**: País → Departamento/Estado → Ciudad
3. **Tipos de Documento**: Identificación → Cédula/Pasaporte/DNI
4. **Especialidades Académicas**: Ciencias → Física → Mecánica Cuántica
5. **Tags/Etiquetas Jerárquicas**: Marketing → Digital → SEO

---

## 🏗️ Estructura de la Tabla

### Campos Core (Obligatorios)

```sql
pkid_catalogo_recursivo UUID    -- Primary Key
creation_date TIMESTAMPTZ        -- Fecha de creación (inmutable)
expiration_date TIMESTAMPTZ      -- Soft delete (NULL = activo)
```

### Campos de Jerarquía

```sql
catalogo_tipo VARCHAR(100)       -- Tipo de catálogo (ej: 'categorias_tutorias')
fkid_padre UUID                  -- FK al nodo padre (NULL = raíz)
nivel SMALLINT                   -- Profundidad (0=raíz, 1=hijo, 2=nieto...)
path_completo TEXT               -- Path desde raíz (/uuid1/uuid2/uuid3)
```

### Campos de Negocio

```sql
codigo VARCHAR(50)               -- Código único (ej: 'MAT-001')
nombre VARCHAR(255)              -- Nombre en español
nombre_en VARCHAR(255)           -- Nombre en inglés (i18n)
descripcion TEXT                 -- Descripción detallada
descripcion_en TEXT              -- Descripción en inglés
orden SMALLINT                   -- Orden de presentación (0-9998)
icono VARCHAR(100)               -- Clase CSS de icono
color CHAR(7)                    -- Color hexadecimal (#RRGGBB)
activo BOOLEAN                   -- Estado activo/inactivo
seleccionable BOOLEAN            -- ¿Se puede seleccionar en UI?
tiene_hijos BOOLEAN              -- ¿Tiene nodos hijos? (denormalizado)
metadatos JSONB                  -- Datos flexibles en JSON
```

### Campos de Auditoría

```sql
created_by UUID                  -- Usuario que creó
updated_at TIMESTAMPTZ           -- Última actualización
updated_by UUID                  -- Usuario que actualizó
```

---

## 🔗 Relaciones

### Self-Referencing FK

```sql
CONSTRAINT fk_catalogo_padre 
    FOREIGN KEY (fkid_padre) 
    REFERENCES shared_schema.catalogo_recursivo(pkid_catalogo_recursivo)
    ON DELETE CASCADE 
    ON UPDATE CASCADE
```

**Comportamiento:**
- Al eliminar un padre → Se eliminan todos los hijos automáticamente (CASCADE)
- Al actualizar el UUID de un padre → Se actualiza en todos los hijos (CASCADE)

---

## 🎯 Constraints y Validaciones

### Unique Constraints

```sql
CONSTRAINT uq_catalogo_codigo 
    UNIQUE (catalogo_tipo, codigo)
```

**Validación:** Un `codigo` debe ser único dentro de cada `catalogo_tipo`.

### Check Constraints

```sql
-- Validación de nivel
CONSTRAINT ck_catalogo_nivel 
    CHECK (nivel >= 0 AND nivel < 100)

-- Validación de orden
CONSTRAINT ck_catalogo_orden 
    CHECK (orden >= 0 AND orden < 9999)

-- Validación de color hexadecimal
CONSTRAINT ck_catalogo_color 
    CHECK (color IS NULL OR color ~ '^#[0-9A-Fa-f]{6}$')

-- Validación de nodos raíz
CONSTRAINT ck_catalogo_raiz 
    CHECK (
        (nivel = 0 AND fkid_padre IS NULL) OR 
        (nivel > 0 AND fkid_padre IS NOT NULL)
    )
```

---

## 🚀 Índices (Performance)

### Índices Principales

```sql
-- Búsquedas por tipo y estado
CREATE INDEX idx_catalogo_tipo_activo 
    ON shared_schema.catalogo_recursivo(catalogo_tipo, activo) 
    WHERE expiration_date IS NULL;

-- Navegación jerárquica (obtener hijos)
CREATE INDEX idx_catalogo_padre 
    ON shared_schema.catalogo_recursivo(fkid_padre) 
    WHERE expiration_date IS NULL AND fkid_padre IS NOT NULL;

-- Nodos raíz
CREATE INDEX idx_catalogo_raiz 
    ON shared_schema.catalogo_recursivo(catalogo_tipo) 
    WHERE expiration_date IS NULL AND fkid_padre IS NULL;

-- Búsquedas por código
CREATE INDEX idx_catalogo_codigo 
    ON shared_schema.catalogo_recursivo(codigo) 
    WHERE expiration_date IS NULL;

-- Ordenamiento
CREATE INDEX idx_catalogo_orden 
    ON shared_schema.catalogo_recursivo(catalogo_tipo, fkid_padre, orden) 
    WHERE expiration_date IS NULL AND activo = TRUE;
```

### Índices Especializados

```sql
-- Búsquedas en metadatos JSONB (GIN)
CREATE INDEX idx_catalogo_metadatos 
    ON shared_schema.catalogo_recursivo USING GIN(metadatos) 
    WHERE expiration_date IS NULL;

-- Búsquedas full-text (GIN)
CREATE INDEX idx_catalogo_fulltext 
    ON shared_schema.catalogo_recursivo 
    USING GIN(to_tsvector('spanish', nombre || ' ' || COALESCE(descripcion, '')))
    WHERE expiration_date IS NULL;
```

---

## ⚙️ Triggers Automáticos

### Trigger 1: Calcular Nivel y Path

```sql
CREATE TRIGGER trg_catalogo_calcular_nivel_path
    BEFORE INSERT OR UPDATE OF fkid_padre
    ON shared_schema.catalogo_recursivo
    FOR EACH ROW
    EXECUTE FUNCTION shared_schema.catalogo_calcular_nivel_path();
```

**Funcionalidad:**
- Calcula `nivel` automáticamente basándose en el padre
- Construye `path_completo` concatenando UUIDs desde la raíz
- Ejecuta en INSERT y cuando cambia `fkid_padre`

**Ejemplo:**
```
Padre: /uuid-raiz (nivel 0)
Hijo:  /uuid-raiz/uuid-hijo (nivel 1)
Nieto: /uuid-raiz/uuid-hijo/uuid-nieto (nivel 2)
```

### Trigger 2: Actualizar Campo tiene_hijos

```sql
CREATE TRIGGER trg_catalogo_actualizar_tiene_hijos
    AFTER INSERT OR UPDATE OR DELETE
    ON shared_schema.catalogo_recursivo
    FOR EACH ROW
    EXECUTE FUNCTION shared_schema.catalogo_actualizar_tiene_hijos();
```

**Funcionalidad:**
- Marca `tiene_hijos = TRUE` cuando se inserta un hijo
- Recalcula `tiene_hijos` cuando se elimina un hijo
- Recalcula en soft delete (UPDATE expiration_date)

**Beneficio:** Frontend puede mostrar íconos de expand/collapse sin consultar la BD.

### Trigger 3: Actualizar Timestamp

```sql
CREATE TRIGGER trg_catalogo_actualizar_timestamp
    BEFORE UPDATE
    ON shared_schema.catalogo_recursivo
    FOR EACH ROW
    EXECUTE FUNCTION shared_schema.catalogo_actualizar_timestamp();
```

**Funcionalidad:**
- Actualiza `updated_at` automáticamente en cada UPDATE

---

## 🛠️ Funciones de Utilidad

### 1. Obtener Descendientes (Hijos, Nietos, etc.)

```sql
SELECT * FROM shared_schema.catalogo_obtener_descendientes(
    p_padre_id := 'UUID-DEL-PADRE',
    p_incluir_padre := FALSE
);
```

**Retorna:** Todos los nodos descendientes (recursivo) ordenados por nivel.

**Ejemplo de Uso:**
```sql
-- Obtener todas las subcategorías de "Matemáticas"
SELECT * FROM shared_schema.catalogo_obtener_descendientes(
    (SELECT pkid_catalogo_recursivo 
     FROM shared_schema.catalogo_recursivo 
     WHERE codigo = 'CAT-MATE'),
    FALSE
);
```

### 2. Obtener Ancestros (Padres, Abuelos, etc.)

```sql
SELECT * FROM shared_schema.catalogo_obtener_ancestros(
    p_hijo_id := 'UUID-DEL-HIJO',
    p_incluir_hijo := FALSE
);
```

**Retorna:** Todos los nodos ancestros (recursivo) ordenados por nivel (raíz primero).

**Ejemplo de Uso (Breadcrumb):**
```sql
-- Obtener ruta completa: Colombia > Cundinamarca > Bogotá
SELECT * FROM shared_schema.catalogo_obtener_ancestros(
    (SELECT pkid_catalogo_recursivo 
     FROM shared_schema.catalogo_recursivo 
     WHERE codigo = 'COL-CUN-BOG'),
    TRUE  -- Incluir Bogotá en el resultado
);
```

### 3. Obtener Árbol Completo de un Catálogo

```sql
SELECT * FROM shared_schema.catalogo_obtener_arbol(
    p_catalogo_tipo := 'categorias_tutorias',
    p_solo_activos := TRUE,
    p_solo_seleccionables := FALSE
);
```

**Retorna:** Todos los nodos del catálogo ordenados para construir un dropdown jerárquico.

**Parámetros:**
- `p_catalogo_tipo`: Tipo de catálogo a obtener
- `p_solo_activos`: Filtrar solo activos (TRUE/FALSE)
- `p_solo_seleccionables`: Filtrar solo seleccionables (TRUE/FALSE)

---

## 📊 Ejemplos de Consultas

### Consulta 1: Obtener Nodos Raíz

```sql
SELECT * 
FROM shared_schema.catalogo_recursivo
WHERE catalogo_tipo = 'categorias_tutorias'
  AND fkid_padre IS NULL
  AND expiration_date IS NULL
  AND activo = TRUE
ORDER BY orden;
```

### Consulta 2: Obtener Hijos Directos de un Nodo

```sql
SELECT * 
FROM shared_schema.catalogo_recursivo
WHERE fkid_padre = 'UUID-DEL-PADRE'
  AND expiration_date IS NULL
  AND activo = TRUE
ORDER BY orden, nombre;
```

### Consulta 3: Búsqueda Full-Text

```sql
SELECT * 
FROM shared_schema.catalogo_recursivo
WHERE catalogo_tipo = 'categorias_tutorias'
  AND to_tsvector('spanish', nombre || ' ' || COALESCE(descripcion, '')) 
      @@ to_tsquery('spanish', 'matemática | álgebra')
  AND expiration_date IS NULL
  AND activo = TRUE;
```

### Consulta 4: Contar Nodos por Nivel

```sql
SELECT nivel, COUNT(*) as total_nodos
FROM shared_schema.catalogo_recursivo
WHERE catalogo_tipo = 'categorias_tutorias'
  AND expiration_date IS NULL
GROUP BY nivel
ORDER BY nivel;
```

### Consulta 5: Búsqueda en Metadatos JSONB

```sql
-- Buscar ubicaciones con población > 5 millones
SELECT * 
FROM shared_schema.catalogo_recursivo
WHERE catalogo_tipo = 'ubicaciones'
  AND (metadatos->>'poblacion')::BIGINT > 5000000
  AND expiration_date IS NULL;

-- Buscar categorías de nivel avanzado
SELECT * 
FROM shared_schema.catalogo_recursivo
WHERE catalogo_tipo = 'categorias_tutorias'
  AND metadatos->>'nivel_dificultad' = 'avanzado'
  AND expiration_date IS NULL;
```

---

## 🎨 Ejemplo de Datos: Categorías de Tutorías

```sql
-- Nivel 0 (Raíz)
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, codigo, nombre, nombre_en, orden, seleccionable, icono, color) 
VALUES
('categorias_tutorias', 'CAT-MATE', 'Matemáticas', 'Mathematics', 1, FALSE, 'fa-calculator', '#3498DB'),
('categorias_tutorias', 'CAT-CIEN', 'Ciencias', 'Sciences', 2, FALSE, 'fa-flask', '#27AE60'),
('categorias_tutorias', 'CAT-LENG', 'Lenguas', 'Languages', 3, FALSE, 'fa-language', '#E74C3C');

-- Nivel 1 (Hijos de Matemáticas)
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, orden, seleccionable) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-MATE-ALG',
    'Álgebra',
    'Algebra',
    1,
    TRUE
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-MATE';

INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, orden, seleccionable) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-MATE-GEOM',
    'Geometría',
    'Geometry',
    2,
    TRUE
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-MATE';

-- Nivel 2 (Hijos de Álgebra)
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, orden, seleccionable, descripcion) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-MATE-ALG-ECUA',
    'Ecuaciones Lineales',
    'Linear Equations',
    1,
    TRUE,
    'Resolución de ecuaciones de primer grado con una o más variables'
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-MATE-ALG';
```

---

## 🌐 Integración con Frontend

### Ejemplo: Dropdown Jerárquico en React

```javascript
// Obtener árbol completo
const response = await fetch('/api/catalogo/arbol?tipo=categorias_tutorias');
const arbol = await response.json();

// Construir estructura jerárquica
function construirArbol(nodos, padreId = null) {
    return nodos
        .filter(n => n.fkid_padre === padreId)
        .map(n => ({
            value: n.pkid,
            label: n.nombre,
            icon: n.icono,
            color: n.color,
            disabled: !n.seleccionable,
            children: construirArbol(nodos, n.pkid)
        }));
}

const arbolJerarquico = construirArbol(arbol);

// Renderizar con componente TreeSelect
<TreeSelect
    treeData={arbolJerarquico}
    placeholder="Selecciona categoría"
    showSearch
    treeDefaultExpandAll
/>
```

### Ejemplo: Breadcrumb (Ruta de Navegación)

```javascript
// Obtener ancestros de un nodo
const response = await fetch(`/api/catalogo/${nodoId}/ancestros?incluirHijo=true`);
const ancestros = await response.json();

// Renderizar breadcrumb
<Breadcrumb>
    {ancestros.map(nodo => (
        <Breadcrumb.Item key={nodo.pkid}>
            <Link to={`/catalogo/${nodo.pkid}`}>
                {nodo.nombre}
            </Link>
        </Breadcrumb.Item>
    ))}
</Breadcrumb>
```

---

## 🔒 Seguridad y Permisos

### Row-Level Security (RLS)

```sql
-- Ejemplo: Solo administradores pueden ver catálogos inactivos
ALTER TABLE shared_schema.catalogo_recursivo ENABLE ROW LEVEL SECURITY;

CREATE POLICY catalogo_activos_publicos ON shared_schema.catalogo_recursivo
    FOR SELECT
    USING (
        activo = TRUE 
        OR current_setting('app.user_role') = 'admin'
    );
```

### Permisos por Schema

```sql
-- Lectura para aplicación
GRANT SELECT ON shared_schema.catalogo_recursivo TO app_readonly;
GRANT EXECUTE ON FUNCTION shared_schema.catalogo_obtener_arbol TO app_readonly;

-- Escritura solo para administradores
GRANT INSERT, UPDATE, DELETE ON shared_schema.catalogo_recursivo TO app_admin;
```

---

## 📈 Rendimiento y Optimización

### Mejores Prácticas

1. **Usar funciones predefinidas** en lugar de CTEs manuales
2. **Filtrar por `expiration_date IS NULL`** en todos los queries
3. **Usar `activo = TRUE`** para consultas del frontend
4. **Aprovechar índices parciales** (WHERE clauses en índices)
5. **Limitar profundidad** de recursión (nivel < 10 para UX)

### Métricas Esperadas

- **Consulta de nodos raíz:** < 5ms
- **Consulta de hijos directos:** < 10ms
- **Consulta de árbol completo (100 nodos):** < 50ms
- **Consulta recursiva (descendientes):** < 100ms

---

## 🐛 Troubleshooting

### Problema 1: Nodo no se puede eliminar

**Síntoma:** Error de FK constraint violation

**Causa:** El nodo tiene hijos activos

**Solución:**
```sql
-- Verificar hijos
SELECT * FROM shared_schema.catalogo_recursivo
WHERE fkid_padre = 'UUID-DEL-NODO';

-- Eliminar hijos primero (CASCADE se encarga automáticamente)
-- O hacer soft delete
UPDATE shared_schema.catalogo_recursivo
SET expiration_date = NOW()
WHERE pkid_catalogo_recursivo = 'UUID-DEL-NODO';
```

### Problema 2: Campo `tiene_hijos` no se actualiza

**Síntoma:** `tiene_hijos` muestra FALSE pero sí tiene hijos

**Causa:** Trigger deshabilitado

**Solución:**
```sql
-- Verificar estado del trigger
SELECT * FROM pg_trigger 
WHERE tgname = 'trg_catalogo_actualizar_tiene_hijos';

-- Recalcular manualmente
UPDATE shared_schema.catalogo_recursivo p
SET tiene_hijos = EXISTS (
    SELECT 1 FROM shared_schema.catalogo_recursivo c
    WHERE c.fkid_padre = p.pkid_catalogo_recursivo
      AND c.expiration_date IS NULL
);
```

### Problema 3: Path incorrecto después de mover nodos

**Síntoma:** `path_completo` no refleja la jerarquía actual

**Causa:** Cambio de padre sin recalcular path

**Solución:**
```sql
-- Recalcular path para todo el catálogo
WITH RECURSIVE recalcular AS (
    -- Raíces
    SELECT 
        pkid_catalogo_recursivo,
        '/' || pkid_catalogo_recursivo::TEXT as nuevo_path,
        0 as nuevo_nivel
    FROM shared_schema.catalogo_recursivo
    WHERE fkid_padre IS NULL
      AND catalogo_tipo = 'MI_CATALOGO'
    
    UNION ALL
    
    -- Hijos
    SELECT 
        c.pkid_catalogo_recursivo,
        r.nuevo_path || '/' || c.pkid_catalogo_recursivo::TEXT,
        r.nuevo_nivel + 1
    FROM shared_schema.catalogo_recursivo c
    INNER JOIN recalcular r ON c.fkid_padre = r.pkid_catalogo_recursivo
)
UPDATE shared_schema.catalogo_recursivo c
SET 
    path_completo = r.nuevo_path,
    nivel = r.nuevo_nivel
FROM recalcular r
WHERE c.pkid_catalogo_recursivo = r.pkid_catalogo_recursivo;
```

---

## 📚 Referencias

- **Patrón Adjacency List:** [SQL Antipatterns - Bill Karwin](https://pragprog.com/titles/bksqla/sql-antipatterns/)
- **PostgreSQL CTEs:** [PostgreSQL WITH Queries (CTE)](https://www.postgresql.org/docs/current/queries-with.html)
- **PostgreSQL Triggers:** [PostgreSQL Trigger Functions](https://www.postgresql.org/docs/current/plpgsql-trigger.html)

---

**Autor:** Database Engineering Team - MI-TOGA  
**Versión:** 1.0  
**Fecha:** 12 de noviembre de 2025
