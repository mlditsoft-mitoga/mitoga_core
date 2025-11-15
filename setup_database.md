# 📋 INSTRUCCIONES PARA EJECUTAR EN DBEAVER

## 🎯 **CONFIGURACIÓN DE BASE DE DATOS MITOGA**

### **📊 Conexión a PostgreSQL:**
- **Host:** `192.168.18.126`
- **Puerto:** `5432`
- **Database:** `mitogadb`
- **Usuario:** `admin`
- **Password:** `Shacall1989*`

### **🚀 PASOS DE EJECUCIÓN EN DBEAVER:**

1. **Abrir DBeaver** y conectar a la base de datos con las credenciales arriba

2. **Abrir el archivo SQL:**
   ```
   setup_database_dbeaver.sql
   ```

3. **Ejecutar por secciones** (IMPORTANTE - NO ejecutar todo de una vez):
   - Seleccionar cada `-- PASO X` completo
   - Presionar `Ctrl + Enter` o usar botón "Execute SQL Script"
   - **Verificar que no haya errores** antes de continuar al siguiente paso

### **📝 ORDEN DE EJECUCIÓN:**

1. **PASO 1:** Verificar conexión ✅
2. **PASO 2:** V1 - Schemas iniciales ✅
3. **PASO 3:** Tablas shared kernel básicas ✅
4. **PASO 4:** Tipos ENUM (CRÍTICO) ✅
5. **PASO 5:** Tabla proceso_registro (CRÍTICA) ✅
6. **PASO 6:** Tablas complementarias ✅
7. **PASO 7:** Verificación final ✅

### **⚠️ PUNTOS CRÍTICOS:**

- **PASO 5 es CRÍTICO:** Crea `autenticacion_schema.proceso_registro` que necesita Spring Boot
- **Verificar cada paso:** Los resultados deben mostrar tablas/tipos creados
- **Si hay errores:** Revisar que PostgreSQL 16.x esté configurado correctamente

### **✅ VERIFICACIÓN DE ÉXITO:**

Al final del PASO 7 deberías ver:
```sql
CONFIGURACIÓN COMPLETADA EXITOSAMENTE
```

Y las siguientes tablas/schemas confirmados:
- ✅ `shared_schema` (con países, monedas, archivos)
- ✅ `autenticacion_schema.proceso_registro` 
- ✅ Tipos ENUM: `estado_registro`, `tipo_documento`, `tipo_archivo`

### **🎯 RESULTADO ESPERADO:**
Después de ejecutar este script, **Spring Boot debería iniciar sin errores de Hibernate**.

### **🚨 SI HAY PROBLEMAS:**

1. **Error de conexión:** Verificar credenciales y red
2. **Error de permisos:** Usuario `admin` debe tener permisos CREATE
3. **Error de tipos:** PostgreSQL debe ser 16.x o superior
4. **Tablas ya existen:** Usar sección de limpieza (comentada) si es necesario

---
**🎉 Una vez completado, continuar con:**
```bash
mvn spring-boot:run
```