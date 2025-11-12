# 📊 Resumen de Datos - Catálogos Recursivos

**Fecha:** 12 de noviembre de 2025  
**Script:** V3__catalogo_recursivo_datos.sql  
**Total de Registros:** ~115 nodos

---

## 📚 Catálogos Implementados

### 1. **Categorías de Tutorías** (`categorias_tutorias`)
**4 niveles de profundidad** | **50+ nodos**

```
Matemáticas (CAT-MATE) 🔵
├── Álgebra (CAT-MATE-ALG)
│   ├── Ecuaciones Lineales (CAT-MATE-ALG-ECUA) ✅
│   ├── Ecuaciones Cuadráticas (CAT-MATE-ALG-CUAD) ✅
│   └── Polinomios (CAT-MATE-ALG-POLI) ✅
├── Geometría (CAT-MATE-GEOM) ✅
├── Cálculo (CAT-MATE-CALC)
│   ├── Derivadas (CAT-MATE-CALC-DER) ✅
│   └── Integrales (CAT-MATE-CALC-INT) ✅
└── Estadística (CAT-MATE-ESTA) ✅

Ciencias (CAT-CIEN) 🟢
├── Física (CAT-CIEN-FIS)
│   ├── Mecánica (CAT-CIEN-FIS-MEC) ✅
│   └── Electricidad y Magnetismo (CAT-CIEN-FIS-ELEC) ✅
├── Química (CAT-CIEN-QUIM) ✅
└── Biología (CAT-CIEN-BIO) ✅

Lenguas (CAT-LENG) 🔴
├── Español (CAT-LENG-ESP) ✅
├── Inglés (CAT-LENG-ING)
│   ├── Gramática Inglesa (CAT-LENG-ING-GRAM) ✅
│   └── Conversación (CAT-LENG-ING-CONV) ✅
└── Francés (CAT-LENG-FRAN) ✅

Tecnología (CAT-TECH) 🟣
├── Programación (CAT-TECH-PROG)
│   ├── Java (CAT-TECH-PROG-JAVA)
│   │   ├── Spring Framework (CAT-TECH-PROG-JAVA-SPRING) ✅
│   │   └── JPA/Hibernate (CAT-TECH-PROG-JAVA-JPA) ✅
│   ├── Python (CAT-TECH-PROG-PY) ✅
│   └── JavaScript (CAT-TECH-PROG-JS) ✅
├── Desarrollo Web (CAT-TECH-WEB) ✅
└── Data Science (CAT-TECH-DATA) ✅

Artes (CAT-ARTE) 🟠
```

**Metadatos Incluidos:**
- `nivel_educativo`: Array de niveles (primaria, secundaria, universidad)
- `popularidad`: Puntaje 1-100
- `dificultad`: basico, intermedio, avanzado
- `tiempo_promedio`: Duración típica de tutoría
- `tecnologias`: Array de frameworks/herramientas
- `certificaciones`: Certificaciones relacionadas (TOEFL, IELTS)

---

### 2. **Ubicaciones Geográficas** (`ubicaciones`)
**3 niveles de profundidad** | **15+ nodos**

```
Colombia (UBI-COL) 🇨🇴
├── Cundinamarca (UBI-COL-CUN)
│   ├── Bogotá D.C. (UBI-COL-CUN-BOG) ✅ [7.8M hab]
│   ├── Chía (UBI-COL-CUN-CHIA) ✅ [140K hab]
│   └── Soacha (UBI-COL-CUN-SOACHA) ✅ [650K hab]
├── Antioquia (UBI-COL-ANT)
│   ├── Medellín (UBI-COL-ANT-MED) ✅ [2.6M hab]
│   └── Envigado (UBI-COL-ANT-ENV) ✅ [240K hab]
└── Valle del Cauca (UBI-COL-VAL)

México (UBI-MEX) 🇲🇽
├── Ciudad de México (UBI-MEX-CDMX) ✅ [9.2M hab]
└── Jalisco (UBI-MEX-JAL)

Argentina (UBI-ARG) 🇦🇷

España (UBI-ESP) 🇪🇸
```

**Metadatos Incluidos:**
- `iso_code`: Código ISO del país (CO, MX, AR, ES)
- `continente`: América del Sur, América del Norte, Europa
- `poblacion`: Número de habitantes
- `moneda`: COP, MXN, ARS, EUR
- `zona_horaria`: UTC offset
- `tipo`: Capital, Municipio, Capital Federal

---

### 3. **Tipos de Documento** (`tipos_documento`)
**2 niveles de profundidad** | **9 nodos**

```
Documentos de Identificación (DOC-IDEN) 🪪
├── Cédula de Ciudadanía (DOC-IDEN-CC) ✅
├── Pasaporte (DOC-IDEN-PASS) ✅
└── Cédula de Extranjería (DOC-IDEN-CE) ✅

Documentos Académicos (DOC-ACAD) 🎓
├── Diploma (DOC-ACAD-DIPL) ✅
└── Certificado de Estudios (DOC-ACAD-CERT) ✅

Documentos Financieros (DOC-FINA) 💵
```

**Metadatos Incluidos:**
- `pais`: Colombia, Internacional
- `formato`: numero, alfanumerico
- `longitud`: Cantidad de caracteres
- `valido_hasta`: Duración de validez
- `nivel`: Array de niveles educativos
- `requiere_apostilla`: Boolean

---

### 4. **Estados de Tutoría** (`estados_tutoria`)
**2 niveles de profundidad** | **8 nodos**

```
Pendiente (EST-PEND) ✅ 🟠
Confirmada (EST-CONF) ✅ 🔵
En Progreso (EST-PROG) ✅ 🟣
Completada (EST-COMP) ✅ 🟢
Cancelada (EST-CANC) ❌ 🔴
├── Cancelada por Estudiante (EST-CANC-EST) ✅
├── Cancelada por Tutor (EST-CANC-TUT) ✅
└── Cancelada por Sistema (EST-CANC-SIS) ✅
```

**Metadatos Incluidos:**
- `reembolso`: Boolean - ¿Aplica reembolso?
- `penalizacion`: Boolean - ¿Aplica penalización al responsable?

**Nota:** Los estados cancelados tienen `seleccionable = FALSE` para no aparecer en nuevas tutorías.

---

### 5. **Niveles Educativos** (`niveles_educativos`)
**1 nivel (simple)** | **5 nodos**

```
Primaria (NIV-PRIM) ✅ 🔴 [6-11 años]
Secundaria (NIV-SECU) ✅ 🔵 [12-15 años]
Media (NIV-MEDI) ✅ 🟢 [16-17 años]
Universidad (NIV-UNIV) ✅ 🟠 [18+ años]
Postgrado (NIV-POST) ✅ 🟣 [22+ años]
```

**Metadatos Incluidos:**
- `edad_minima`: Edad mínima recomendada
- `edad_maxima`: Edad máxima (null = sin límite)

---

### 6. **Modalidades de Tutoría** (`modalidades_tutoria`)
**2 niveles de profundidad** | **8 nodos**

```
Virtual (MOD-VIRT) 💻 🔵
├── Virtual Sincrónica (MOD-VIRT-SYNC) ✅
│   Plataformas: Zoom, Google Meet, Microsoft Teams
└── Virtual Asincrónica (MOD-VIRT-ASYNC) ✅
    Plataformas: YouTube, Vimeo, Plataforma Propia

Presencial (MOD-PRES) 🤝 🟢
├── Presencial a Domicilio (MOD-PRES-DOMI) ✅
│   Radio máximo: 15 km | Costo adicional: Sí
└── Presencial en Centro (MOD-PRES-CENT) ✅
    Centros: Biblioteca Luis Ángel Arango, etc.

Híbrida (MOD-HIBR) ✅ 🔄 🟣
```

**Metadatos Incluidos:**
- `plataformas`: Array de herramientas disponibles
- `requiere_camara`: Boolean
- `costo_adicional`: Boolean
- `radio_maximo_km`: Distancia máxima (solo presencial a domicilio)
- `centros_disponibles`: Array de ubicaciones

---

## 📈 Estadísticas Generales

| Catálogo | Total Nodos | Niveles | Raíces | Hojas | Seleccionables |
|----------|-------------|---------|--------|-------|----------------|
| **categorias_tutorias** | ~50 | 4 | 5 | ~35 | ~40 |
| **ubicaciones** | ~15 | 3 | 4 | ~8 | ~8 |
| **tipos_documento** | 9 | 2 | 3 | 5 | 5 |
| **estados_tutoria** | 8 | 2 | 5 | 3 | 7 |
| **niveles_educativos** | 5 | 1 | 5 | 5 | 5 |
| **modalidades_tutoria** | 8 | 2 | 3 | 4 | 5 |
| **TOTAL** | **~115** | **4 max** | **25** | **~60** | **~70** |

---

## 🎨 Códigos de Colores Utilizados

| Color | Hex | Uso |
|-------|-----|-----|
| 🔵 Azul | #3498DB | Matemáticas, Confirmada, Virtual |
| 🟢 Verde | #27AE60 | Ciencias, Completada, Presencial, Media |
| 🔴 Rojo | #E74C3C | Lenguas, Cancelada, Primaria |
| 🟣 Morado | #9B59B6 | Tecnología, En Progreso, Híbrida, Postgrado |
| 🟠 Naranja | #E67E22 | Artes, Pendiente, Universidad |
| 🟡 Amarillo | #F39C12 | Pendiente (estado) |

---

## 🧪 Consultas de Prueba

### 1. Obtener árbol completo de Categorías de Tutorías

```sql
SELECT * 
FROM shared_schema.catalogo_obtener_arbol('categorias_tutorias', TRUE, TRUE);
```

**Resultado esperado:** ~40 nodos seleccionables ordenados jerárquicamente.

### 2. Obtener ciudades de Colombia

```sql
SELECT c.*
FROM shared_schema.catalogo_recursivo c
INNER JOIN shared_schema.catalogo_recursivo p 
    ON c.fkid_padre = p.pkid_catalogo_recursivo
WHERE p.codigo = 'UBI-COL'
  AND c.expiration_date IS NULL
  AND c.activo = TRUE
ORDER BY c.orden;
```

**Resultado esperado:** Cundinamarca, Antioquia, Valle del Cauca.

### 3. Obtener path completo de "Spring Framework"

```sql
SELECT * 
FROM shared_schema.catalogo_obtener_ancestros(
    (SELECT pkid_catalogo_recursivo 
     FROM shared_schema.catalogo_recursivo 
     WHERE codigo = 'CAT-TECH-PROG-JAVA-SPRING'),
    TRUE
);
```

**Resultado esperado:**
```
Tecnología → Programación → Java → Spring Framework
```

### 4. Buscar tutorías de nivel avanzado

```sql
SELECT *
FROM shared_schema.catalogo_recursivo
WHERE catalogo_tipo = 'categorias_tutorias'
  AND metadatos->>'dificultad' = 'avanzado'
  AND expiration_date IS NULL
  AND activo = TRUE;
```

**Resultado esperado:** Derivadas, Integrales, Electricidad y Magnetismo.

### 5. Obtener todas las modalidades con sus sub-modalidades

```sql
WITH RECURSIVE arbol AS (
    -- Raíces
    SELECT 
        pkid_catalogo_recursivo,
        fkid_padre,
        codigo,
        nombre,
        nivel,
        ARRAY[nombre] as ruta
    FROM shared_schema.catalogo_recursivo
    WHERE catalogo_tipo = 'modalidades_tutoria'
      AND fkid_padre IS NULL
      AND expiration_date IS NULL
    
    UNION ALL
    
    -- Hijos
    SELECT 
        c.pkid_catalogo_recursivo,
        c.fkid_padre,
        c.codigo,
        c.nombre,
        c.nivel,
        a.ruta || c.nombre
    FROM shared_schema.catalogo_recursivo c
    INNER JOIN arbol a ON c.fkid_padre = a.pkid_catalogo_recursivo
    WHERE c.expiration_date IS NULL
)
SELECT 
    nivel,
    REPEAT('  ', nivel) || nombre as nombre_indentado,
    codigo,
    array_to_string(ruta, ' → ') as ruta_completa
FROM arbol
ORDER BY ruta;
```

---

## 🚀 Casos de Uso Frontend

### Dropdown de Categorías (React)

```javascript
// API Call
const response = await fetch('/api/catalogo/arbol?tipo=categorias_tutorias&soloActivos=true&soloSeleccionables=true');
const categorias = await response.json();

// TreeSelect Component
<TreeSelect
    treeData={buildTree(categorias)}
    placeholder="Selecciona una categoría"
    showSearch
    filterTreeNode={(input, treeNode) => 
        treeNode.title.toLowerCase().includes(input.toLowerCase())
    }
    treeDefaultExpandAll={false}
/>
```

### Selector de Ubicación en Cascada

```javascript
// Países
const paises = await fetch('/api/catalogo/raiz?tipo=ubicaciones');

// Al seleccionar país
const departamentos = await fetch(`/api/catalogo/hijos/${paisId}`);

// Al seleccionar departamento
const ciudades = await fetch(`/api/catalogo/hijos/${departamentoId}`);

// Cascade Component
<Cascader
    options={ubicaciones}
    placeholder="País → Departamento → Ciudad"
    expandTrigger="hover"
    displayRender={(labels) => labels.join(' → ')}
/>
```

### Breadcrumb de Navegación

```javascript
// Obtener ancestros del nodo actual
const ancestros = await fetch(`/api/catalogo/${nodoId}/ancestros?incluirHijo=true`);

// Render
<Breadcrumb>
    {ancestros.map(nodo => (
        <Breadcrumb.Item key={nodo.pkid}>
            <span style={{color: nodo.color}}>
                <i className={nodo.icono} /> {nodo.nombre}
            </span>
        </Breadcrumb.Item>
    ))}
</Breadcrumb>
```

---

## 📝 Notas Importantes

### Campos Automáticos (Triggers)

Los siguientes campos se calculan **automáticamente** por triggers:

- ✅ `nivel` - Se calcula basado en la profundidad del padre
- ✅ `path_completo` - Se construye concatenando UUIDs desde la raíz
- ✅ `tiene_hijos` - Se actualiza cuando se insertan/eliminan hijos
- ✅ `updated_at` - Se actualiza en cada UPDATE

### Soft Delete

Todos los nodos usan **soft delete**:
- `expiration_date IS NULL` = Nodo activo
- `expiration_date IS NOT NULL` = Nodo eliminado

**Siempre filtrar por:**
```sql
WHERE expiration_date IS NULL
```

### Seleccionables vs No Seleccionables

- `seleccionable = TRUE` → Aparece en dropdowns del frontend
- `seleccionable = FALSE` → Solo categoría padre (no se puede seleccionar)

**Ejemplo:**
- "Matemáticas" → `seleccionable = FALSE` (es categoría)
- "Álgebra" → `seleccionable = TRUE` (se puede seleccionar para tutoría)

---

## 🔧 Mantenimiento

### Agregar nueva categoría

```sql
INSERT INTO shared_schema.catalogo_recursivo 
(catalogo_tipo, fkid_padre, codigo, nombre, nombre_en, orden, seleccionable, metadatos) 
SELECT 
    'categorias_tutorias',
    pkid_catalogo_recursivo,
    'CAT-MATE-TRIG',
    'Trigonometría',
    'Trigonometry',
    5,
    TRUE,
    '{"dificultad": "intermedio", "tiempo_promedio": "60min"}'::JSONB
FROM shared_schema.catalogo_recursivo 
WHERE codigo = 'CAT-MATE' AND expiration_date IS NULL;
```

### Mover nodo a otro padre

```sql
-- Mover "Geometría" de Matemáticas a Ciencias (ejemplo ficticio)
UPDATE shared_schema.catalogo_recursivo
SET fkid_padre = (
    SELECT pkid_catalogo_recursivo 
    FROM shared_schema.catalogo_recursivo 
    WHERE codigo = 'CAT-CIEN'
)
WHERE codigo = 'CAT-MATE-GEOM';

-- Los triggers se encargarán de recalcular nivel y path automáticamente
```

### Soft delete de nodo

```sql
-- Eliminar "Francés" (y todos sus hijos por CASCADE)
UPDATE shared_schema.catalogo_recursivo
SET expiration_date = NOW()
WHERE codigo = 'CAT-LENG-FRAN';
```

---

**Documentación generada:** 12 de noviembre de 2025  
**Próxima revisión:** Cuando se agreguen nuevos catálogos  
**Autor:** Database Engineering Team - MI-TOGA
