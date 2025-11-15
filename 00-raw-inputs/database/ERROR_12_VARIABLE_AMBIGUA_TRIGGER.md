# Error #12: Variable Ambigua en Función de Trigger

## 📋 **Descripción del Error**
```
SQL Error [42702]: ERROR: column reference "trigger_name" is ambiguous
Detail: It could refer to either a PL/pgSQL variable or a table column.
Where: PL/pgSQL function tutores_schema.setup_updated_at_trigger(text) line 13 at IF
```

## 🔍 **Causa Raíz**
Variable local `trigger_name` en función PL/pgSQL crea ambiguedad con columna del mismo nombre en `information_schema.triggers`.

## 🐛 **Código Problemático**
```sql
-- MALO: Variable ambigua
DECLARE
    v_trigger_name TEXT := p_table_name || '_updated_at';
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.triggers 
                   WHERE trigger_schema = 'tutores_schema' 
                   AND event_object_table = p_table_name
                   AND trigger_name = v_trigger_name) THEN  -- AMBIGUEDAD AQUÍ
```

## ✅ **Solución Aplicada**
```sql
-- BUENO: Variable con prefijo específico
DECLARE
    -- Lección #11: Prefijo de variables para evitar ambiguedad
    v_trigger_name_local TEXT := p_table_name || '_updated_at';
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.triggers 
                   WHERE trigger_schema = 'tutores_schema' 
                   AND event_object_table = p_table_name
                   AND trigger_name = v_trigger_name_local) THEN  -- SIN AMBIGUEDAD
```

## 🛠️ **Lección #12: Naming Convention Estricto para Variables**

### ✅ Patrón Correcto:
- Variables locales: `v_nombre_descripcion_especifica`
- Parámetros: `p_nombre_parametro`
- Constantes: `c_NOMBRE_CONSTANTE`

### ❌ Evitar:
- Nombres genéricos que coincidan con columnas del sistema
- Variables sin prefijo en funciones complejas
- Reutilizar nombres de columnas de information_schema

## 🎯 **Aplicación en ZNS-METHOD**
1. Todas las variables locales deben tener prefijo `v_` + descripción específica
2. Si el nombre coincide con columna del sistema, agregar sufijo descriptivo
3. Usar `_local`, `_temp`, `_calculated` para diferenciar

## 📊 **Casos Comunes de Ambiguedad**
- `trigger_name` → `v_trigger_name_local`
- `table_name` → `v_table_name_target`
- `column_name` → `v_column_name_new`
- `schema_name` → `v_schema_name_target`

## 🔄 **Patrón de Corrección**
```sql
-- ANTES
DECLARE
    trigger_name TEXT := ...;
    table_name TEXT := ...;

-- DESPUÉS
DECLARE
    v_trigger_name_local TEXT := ...;
    v_table_name_target TEXT := ...;
```

## ⚠️ **Prevención**
- Siempre usar prefijos descriptivos en variables
- Revisar con `information_schema` antes de nombrar variables
- Testing exhaustivo de funciones con variables complejas

---
**Fecha:** 2025-11-14  
**Archivo Afectado:** V5__registro_tutores_multistep.sql  
**Función:** tutores_schema.setup_updated_at_trigger  
**Estado:** ✅ CORREGIDO