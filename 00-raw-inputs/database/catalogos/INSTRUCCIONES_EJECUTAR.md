# 🚀 INSTRUCCIONES PARA SOLUCIONAR ERROR DE FUNCIONES CATÁLOGO

## ❌ **Problema Actual**

La función `catalogo_obtener_arbol` en la base de datos usa nombres de columnas **INCORRECTOS** que no coinciden con la tabla real:

| ❌ Nombre en Función (INCORRECTO) | ✅ Nombre Real en Tabla |
|-----------------------------------|-------------------------|
| `pkid_catalogo`                   | `pkid_catalogo_recursivo` |
| `fk_pkid_padre`                   | `fkid_padre` |
| `tipo`                            | `catalogo_tipo` |
| `orden_visualizacion`             | `orden` |
| `es_seleccionable`                | `seleccionable` |
| `metadata`                        | `metadatos` |

Por eso el `SELECT * FROM appmatch_schema.catalogo_obtener_arbol('TIPO_DOCUMENTO', TRUE, TRUE);` **NO trae ningún resultado**.

---

## ✅ **Solución: Ejecutar Script de Recreación**

### **PASO 1: Abrir el Script en DBeaver**

1. Abrir DBeaver
2. Conectar a la base de datos `mitogadb` (192.168.18.126:5432)
3. Ir a la ruta del workspace:
   ```
   00-raw-inputs/database/catalogos/FORZAR_RECREACION_FUNCIONES_CATALOGO.sql
   ```
4. Abrir el archivo (doble clic o botón derecho → Open SQL Script)

---

### **PASO 2: Ejecutar TODO el Script**

#### **Opción A: Ejecutar Todo (Recomendado)**
1. Con el script abierto, presionar **Ctrl+Alt+X** (o clic en el icono "Execute SQL Script")
2. Confirmar la ejecución
3. Esperar a que termine (debería tomar 2-3 segundos)

#### **Opción B: Ejecutar por Bloques**
Si prefieres ver el progreso paso por paso:
1. Seleccionar TODO el texto del script (Ctrl+A)
2. Presionar **Ctrl+Enter** (Execute SQL Statement)
3. Ver los mensajes en la consola

---

### **PASO 3: Verificar Mensajes de Éxito**

En la consola de DBeaver deberías ver:

```
════════════════════════════════════════════════════════════════
PASO 1: Eliminando TODAS las funciones catalogo_* existentes...
════════════════════════════════════════════════════════════════
  🗑️  Eliminando: appmatch_schema.catalogo_obtener_arbol(...)
  🗑️  Eliminando: appmatch_schema.catalogo_obtener_ancestros(...)
  🗑️  Eliminando: appmatch_schema.catalogo_obtener_descendientes(...)
✅ Funciones eliminadas exitosamente

════════════════════════════════════════════════════════════════
PASO 2: Verificación post-eliminación
════════════════════════════════════════════════════════════════
Funciones catalogo_* restantes: 0
✅ Todas las funciones eliminadas correctamente

[... Creación de las 3 funciones ...]

════════════════════════════════════════════════════════════════
PASO 6: Verificación de creación
════════════════════════════════════════════════════════════════
Funciones creadas en appmatch_schema: 3
✅✅✅ LAS 3 FUNCIONES CREADAS EXITOSAMENTE

Prueba ejecutar:
  SELECT * FROM appmatch_schema.catalogo_obtener_arbol('TIPO_DOCUMENTO', TRUE, TRUE);
════════════════════════════════════════════════════════════════
```

---

### **PASO 4: Probar la Función**

Ejecutar esta query en DBeaver:

```sql
SELECT * FROM appmatch_schema.catalogo_obtener_arbol('TIPO_DOCUMENTO', TRUE, TRUE);
```

**Resultado esperado:**
- Si hay datos en `catalogo_recursivo` del tipo 'TIPO_DOCUMENTO', debe traer filas
- Si no hay datos, debe retornar 0 filas (pero SIN errores)
- **NO debe dar error de columnas inexistentes**

---

### **PASO 5: Verificar Datos en la Tabla**

Si no trae resultados, verifica que existan datos:

```sql
-- Ver todos los tipos de catálogo disponibles
SELECT DISTINCT catalogo_tipo, COUNT(*) AS cantidad
FROM appmatch_schema.catalogo_recursivo
WHERE expiration_date IS NULL
GROUP BY catalogo_tipo
ORDER BY catalogo_tipo;

-- Ver todos los catálogos de tipo TIPO_DOCUMENTO
SELECT 
    pkid_catalogo_recursivo,
    codigo,
    nombre,
    fkid_padre,
    nivel,
    orden,
    activo,
    seleccionable
FROM appmatch_schema.catalogo_recursivo
WHERE catalogo_tipo = 'TIPO_DOCUMENTO'
  AND expiration_date IS NULL
ORDER BY nivel, orden;
```

---

## 🔍 **Diagnóstico (Opcional)**

Si quieres ver qué funciones existen actualmente **ANTES** de ejecutar el script de recreación:

```sql
-- Ver TODAS las funciones relacionadas con catálogos
SELECT 
    n.nspname AS esquema,
    p.proname AS nombre_funcion,
    pg_get_function_identity_arguments(p.oid) AS argumentos
FROM pg_proc p
INNER JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE p.proname LIKE 'catalogo_%'
ORDER BY n.nspname, p.proname;
```

O ejecutar el script completo de diagnóstico:
```
00-raw-inputs/database/catalogos/DEBUG_verificar_funciones.sql
```

---

## ⚠️ **Posibles Errores y Soluciones**

### Error 1: "Permission denied"
**Causa:** Usuario sin permisos de DROP/CREATE FUNCTION
**Solución:** Ejecutar como usuario `admin` (Shacall1989*)

### Error 2: "Function does not exist" al intentar DROP
**Causa:** Funciones ya fueron eliminadas manualmente
**Solución:** Ignorar, el script continuará y creará las funciones

### Error 3: "Relation catalogo_recursivo does not exist"
**Causa:** Tabla no existe en el esquema
**Solución:** Ejecutar primero `V2__catalogo_recursivo.sql`

---

## 📝 **Después de Ejecutar el Script**

1. ✅ Probar la función con diferentes tipos de catálogo
2. ✅ Reiniciar la aplicación Spring Boot si estaba corriendo
3. ✅ Probar el endpoint `/api/v1/catalogos/buscar-arbol` desde Postman/curl
4. ✅ Verificar logs de la aplicación (no debe haber errores de columnas)

---

## 🎯 **Resultado Final Esperado**

```sql
-- Esta query debe funcionar SIN errores
SELECT * FROM appmatch_schema.catalogo_obtener_arbol('TIPO_DOCUMENTO', TRUE, TRUE);

-- Esta query también debe funcionar
SELECT * FROM appmatch_schema.catalogo_obtener_ancestros('uuid-de-un-catalogo'::UUID, TRUE);

-- Y esta también
SELECT * FROM appmatch_schema.catalogo_obtener_descendientes('uuid-de-un-catalogo'::UUID, TRUE);
```

**Si alguna falla con error de columnas, significa que el script NO se ejecutó correctamente.**

---

## 🆘 **¿Necesitas Ayuda?**

Si después de ejecutar el script sigues teniendo problemas:

1. Copiar el **mensaje completo de error** de DBeaver
2. Ejecutar el script de diagnóstico y copiar los resultados
3. Reportar ambos outputs para análisis

---

**Fecha de creación:** 2025-11-17  
**Autor:** Database Engineer Senior - PostgreSQL Architect  
**Versión:** 1.0.0
