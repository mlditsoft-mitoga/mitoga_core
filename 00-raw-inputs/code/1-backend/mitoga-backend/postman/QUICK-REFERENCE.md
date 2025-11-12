# 🚀 Quick Reference - Mitoga API Postman Collection

> **TL;DR:** Referencia rápida de comandos y endpoints más usados

---

## ⚡ Comandos Más Usados

### Ejecutar Tests (Local)
```powershell
.\run-newman-tests.ps1 -Environment local
```

### Ejecutar Tests (QA)
```powershell
.\run-newman-tests.ps1 -Environment qa
```

### Ejecutar Solo un Módulo
```powershell
newman run Mitoga-API.postman_collection.json `
  -e Mitoga-Local.postman_environment.json `
  --folder "1. Catálogos Recursivos"
```

### Actualizar Password de Desarrollo
```powershell
# 1. Buscar en logs de Spring Boot:
# Using generated security password: [COPIAR_ESTE_VALOR]

# 2. En Postman:
# Environments → Mitoga - Local → password → Paste
```

---

## 📋 Endpoints Quick List

### Catálogos - Consultas

#### Obtener Árbol Completo
```http
GET /catalogos/{tipo}/arbol?soloActivos=true
```
**Tipos:** `cliente`, `proveedor`, `producto`, `servicio`, `ubicacion`, `categoria`

#### Buscar por Nombre
```http
GET /catalogos/search?nombre=tecnolog&soloActivos=true
```

#### Obtener Ancestros (Breadcrumb)
```http
GET /catalogos/{uuid}/ancestros
```

#### Obtener Descendientes (Subárbol)
```http
GET /catalogos/{uuid}/descendientes?nivel=2
```

---

## 🎯 Shortcuts de Postman

| Acción | Shortcut Windows | Shortcut Mac |
|--------|------------------|--------------|
| Enviar Request | `Ctrl + Enter` | `⌘ + Enter` |
| Guardar Request | `Ctrl + S` | `⌘ + S` |
| Nueva Tab | `Ctrl + T` | `⌘ + T` |
| Cerrar Tab | `Ctrl + W` | `⌘ + W` |
| Buscar | `Ctrl + F` | `⌘ + F` |
| Sidebar Toggle | `Ctrl + \` | `⌘ + \` |
| Console Toggle | `Ctrl + Alt + C` | `⌘ + ⌥ + C` |

---

## 🔧 Variables de Entorno

### Local
```json
{
  "baseUrl": "http://localhost:8082/api/v1",
  "username": "user",
  "password": "e0acd35b-d4b1-4660-986a-2dddb451a8ac"
}
```

### QA
```json
{
  "baseUrl": "https://qa.mitoga.com/api/v1",
  "username": "qa-user",
  "password": "[CONFIGURAR]"
}
```

---

## 🐛 Errores Comunes

### 401 Unauthorized
```
❌ Error: 401 Unauthorized
✅ Solución: Actualizar password en environment
```

### ECONNREFUSED
```
❌ Error: ECONNREFUSED 127.0.0.1:8082
✅ Solución: Iniciar aplicación: .\gradlew.bat bootRun
```

### 404 Not Found
```
❌ Error: 404 Not Found
✅ Solución: Verificar que el catálogo existe en BD
           Ejecutar: V3__catalogo_recursivo_datos.sql
```

### Empty Response
```
❌ Error: Response data array is empty
✅ Solución: Poblar datos de prueba en PostgreSQL
```

---

## 📊 Tests - Estructura Básica

### Test Simple de Status Code
```javascript
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});
```

### Test de Estructura de Respuesta
```javascript
pm.test("Response has success structure", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property('success');
    pm.expect(jsonData).to.have.property('data');
    pm.expect(jsonData.success).to.eql(true);
});
```

### Guardar Variable de Respuesta
```javascript
// En tab Tests
var jsonData = pm.response.json();
if (jsonData.success && jsonData.data.length > 0) {
    pm.environment.set('catalogoId', jsonData.data[0].id);
}
```

---

## 🎨 Snippets Útiles

### Obtener Timestamp
```javascript
pm.environment.set('timestamp', new Date().toISOString());
```

### Log de Request
```javascript
console.log('Request URL:', pm.request.url);
console.log('Request Method:', pm.request.method);
```

### Log de Response
```javascript
console.log('Status:', pm.response.code);
console.log('Time:', pm.response.responseTime + 'ms');
console.log('Body:', pm.response.json());
```

---

## 📁 Estructura de Archivos

```
postman/
├── Mitoga-API.postman_collection.json     ⭐ Importar este
├── Mitoga-Local.postman_environment.json  🏠 Y este
├── run-newman-tests.ps1                   🤖 Ejecutar tests
└── README.md                              📖 Guía completa
```

---

## 🔗 Links Rápidos

| Documento | Link |
|-----------|------|
| Guía Completa | [README.md](./README.md) |
| Resumen Ejecutivo | [RESUMEN-EJECUTIVO.md](./RESUMEN-EJECUTIVO.md) |
| Ejemplos Newman | [EJEMPLO-EJECUCION.md](./EJEMPLO-EJECUCION.md) |
| Changelog | [CHANGELOG.md](./CHANGELOG.md) |
| Índice | [INDEX.md](./INDEX.md) |

---

## ⚙️ Setup en 3 Pasos

### 1️⃣ Importar en Postman
```
Postman → Import → 
Arrastrar: Mitoga-API.postman_collection.json
Arrastrar: Mitoga-Local.postman_environment.json
```

### 2️⃣ Configurar Environment
```
Dropdown superior derecha → "Mitoga - Local Development"
Actualizar password con el de los logs de Spring Boot
```

### 3️⃣ Probar
```
1. Catálogos Recursivos → 1.1. Obtener Árbol → Send
```

---

## 📞 Ayuda Rápida

### ¿Cómo...?

**...importar la colección?**
→ Ver sección "Setup en 3 Pasos" arriba

**...ejecutar todos los tests?**
→ `.\run-newman-tests.ps1 -Environment local`

**...agregar un nuevo endpoint?**
→ Ver [README.md](./README.md) - Sección "Agregar Nuevos Endpoints"

**...solucionar error 401?**
→ Actualizar password en environment (ver "Errores Comunes")

**...obtener más ayuda?**
→ Canal #backend-support o desarrollo@mitoga.com

---

## 🎯 Checklist Pre-Commit

```
[ ] Tests ejecutados con Newman (todos pasan)
[ ] Colección exportada (si hubo cambios)
[ ] CHANGELOG.md actualizado
[ ] Ejemplos de respuesta agregados (endpoints nuevos)
[ ] Tests agregados (mínimo 3 por endpoint nuevo)
[ ] Variables hardcodeadas reemplazadas por {{variables}}
[ ] Password de producción NO commiteado
```

---

## 🚨 Emergencias

### Aplicación No Responde
```powershell
# 1. Verificar que esté corriendo
netstat -ano | findstr :8082

# 2. Si no está, iniciar
cd [ruta-backend]
.\gradlew.bat bootRun

# 3. Esperar mensaje: "Started MitogaApplication"
```

### Tests Fallan Todos
```powershell
# 1. Verificar aplicación corriendo (arriba)
# 2. Verificar password actualizado
# 3. Verificar datos en BD
psql -U postgres -d mitoga_db
SELECT COUNT(*) FROM shared_schema.catalogo_recursivo;
# Debe retornar > 0
```

### No Puedo Importar Colección
```
1. Verificar versión de Postman (>= 10.0)
2. Usar Import → File → Select Files
3. NO usar Import → Link (archivo local)
```

---

## 📈 Performance Targets

| Métrica | Target | Crítico |
|---------|--------|---------|
| Response Time (avg) | < 200ms | < 500ms |
| Test Pass Rate | 100% | > 95% |
| Test Duration | < 2s | < 5s |

---

**Última actualización:** 12 de noviembre de 2025  
**Versión:** 1.0.0  
**Contacto:** desarrollo@mitoga.com
