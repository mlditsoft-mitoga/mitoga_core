# Mitoga API - Colección de Postman

## 📁 Contenido

Este directorio contiene la colección completa de Postman para el API REST de Mitoga, incluyendo:

- **Mitoga-API.postman_collection.json** - Colección principal con todos los endpoints
- **Mitoga-Local.postman_environment.json** - Variables de entorno para desarrollo local
- **Mitoga-QA.postman_environment.json** - Variables de entorno para QA/Testing
- **Mitoga-Production.postman_environment.json** - Variables de entorno para producción

## 🚀 Importar en Postman

### Opción 1: Importar desde archivo
1. Abre Postman
2. Click en **Import** (esquina superior izquierda)
3. Arrastra y suelta todos los archivos JSON de este directorio
4. Click en **Import**

### Opción 2: Importar desde URL (próximamente)
```
https://github.com/mlditsoft-mitoga/mitoga_web/raw/master/postman/Mitoga-API.postman_collection.json
```

## ⚙️ Configuración Inicial

### 1. Seleccionar Entorno
En Postman, selecciona el entorno apropiado del dropdown en la esquina superior derecha:
- **Mitoga - Local Development** (para desarrollo local)
- **Mitoga - QA/Testing** (para ambiente de pruebas)
- **Mitoga - Production** (para producción - ⚠️ usar con precaución)

### 2. Configurar Credenciales

#### Local Development
```json
{
  "baseUrl": "http://localhost:8082/api/v1",
  "username": "user",
  "password": "e0acd35b-d4b1-4660-986a-2dddb451a8ac"
}
```
> ⚠️ **Nota:** El password se genera automáticamente al iniciar Spring Boot en modo desarrollo.
> Busca en los logs: `Using generated security password: [password]`

#### QA/Production
- Actualiza las variables de entorno con las credenciales correctas
- **NUNCA** commitees passwords de producción al repositorio

## 📚 Estructura de la Colección

### 1. Catálogos Recursivos
Módulo completo de gestión de catálogos con estructura jerárquica.

#### 1.1. Obtener Árbol Completo
```http
GET /catalogos/{tipo}/arbol?soloActivos=true&soloSeleccionables=false
```
- Retorna el árbol jerárquico completo de un tipo de catálogo
- Soporta filtrado por activos y seleccionables

**Tipos soportados:**
- `cliente` - Catálogo de clientes
- `proveedor` - Catálogo de proveedores
- `producto` - Catálogo de productos
- `servicio` - Catálogo de servicios
- `ubicacion` - Catálogo de ubicaciones
- `categoria` - Catálogo de categorías

#### 1.2. Obtener Ancestros
```http
GET /catalogos/{id}/ancestros
```
- Retorna la cadena de padres desde la raíz hasta el catálogo especificado
- Útil para breadcrumbs y navegación jerárquica

#### 1.3. Obtener Descendientes
```http
GET /catalogos/{id}/descendientes?nivel=2&soloActivos=true
```
- Retorna todos los hijos de un catálogo
- Soporta nivel máximo de profundidad
- Útil para cargar subárboles

#### 1.4. Buscar Catálogos
```http
GET /catalogos/search?tipo=cliente&nombre=tecnolog&codigo=CLI&soloActivos=true
```
- Búsqueda flexible con múltiples criterios
- Búsqueda parcial case-insensitive
- Útil para autocompletado

### 2. Health Check
Endpoints de monitoreo y diagnóstico.

#### 2.1. Actuator Health
```http
GET /actuator/health
```
- Estado de salud de la aplicación
- Estado de conexiones (BD, Vault, etc.)

#### 2.2. Actuator Info
```http
GET /actuator/info
```
- Información de la aplicación
- Versión, descripción, etc.

## 🧪 Tests Automatizados

La colección incluye tests automáticos en cada endpoint:

### Tests Globales (todos los endpoints)
- ✅ Status code correcto
- ✅ Content-Type header presente
- ✅ Response body no vacío
- ✅ Tiempo de respuesta < 2000ms

### Tests Específicos
- ✅ Estructura de `ApiResponse<T>` válida
- ✅ Campo `success` correcto
- ✅ Validación de tipos de datos
- ✅ Validación de jerarquías (niveles, orden)

### Ejecutar Tests
1. **Un request:** Click en **Send** y ver pestaña **Test Results**
2. **Toda la colección:** Click derecho en la colección → **Run collection**
3. **Con Newman (CLI):**
   ```bash
   newman run Mitoga-API.postman_collection.json \
     -e Mitoga-Local.postman_environment.json
   ```

## 📊 Scripts Pre-request y Post-response

### Pre-request Script (Global)
```javascript
// Se ejecuta ANTES de cada request
console.log('Ejecutando request a: ' + pm.request.url);
pm.environment.set('timestamp', new Date().toISOString());
```

### Post-response Script (Global)
```javascript
// Se ejecuta DESPUÉS de cada request
console.log('Response status: ' + pm.response.code);
console.log('Response time: ' + pm.response.responseTime + 'ms');
```

## 🔐 Autenticación

La colección usa **Basic Authentication** a nivel de colección:
- **Username:** Variable `{{username}}`
- **Password:** Variable `{{password}}`

Las credenciales se configuran en cada entorno.

### Actualizar Password (Local)
1. Inicia la aplicación: `./gradlew.bat bootRun`
2. Busca en los logs: `Using generated security password: [password]`
3. Copia el password
4. En Postman → Environments → Mitoga - Local Development
5. Actualiza la variable `password`

## 📝 Variables de Entorno

### Variables Disponibles

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `baseUrl` | URL base del API | `http://localhost:8082/api/v1` |
| `username` | Usuario de autenticación | `user` |
| `password` | Password de autenticación | `e0acd35b-d4b1-4660-986a-2dddb451a8ac` |
| `catalogoId` | UUID de catálogo para pruebas | `550e8400-e29b-41d4-a716-446655440002` |
| `timestamp` | Timestamp automático | `2025-11-12T14:00:00.000Z` |

### Extraer Variables de Respuestas
Usa scripts para guardar valores de respuestas:

```javascript
// En la pestaña Tests de un request
var jsonData = pm.response.json();
if (jsonData.success && jsonData.data.length > 0) {
    pm.environment.set('catalogoId', jsonData.data[0].id);
    console.log('Guardado catalogoId: ' + jsonData.data[0].id);
}
```

## 🎯 Ejemplos de Uso

### Caso 1: Obtener árbol de clientes activos
1. Selecciona endpoint: **1.1. Obtener Árbol Completo**
2. Cambia variable de path `tipo` a: `cliente`
3. Query params:
   - `soloActivos`: `true`
   - `soloSeleccionables`: `false`
4. Click **Send**

### Caso 2: Buscar catálogos por nombre
1. Selecciona endpoint: **1.4. Buscar Catálogos**
2. Query params:
   - `tipo`: `cliente`
   - `nombre`: `tecnolog`
   - `soloActivos`: `true`
3. Click **Send**

### Caso 3: Obtener breadcrumb de un catálogo
1. Obtén un ID de catálogo (del árbol o búsqueda)
2. Copia el UUID
3. Selecciona endpoint: **1.2. Obtener Ancestros**
4. Pega el UUID en variable de path `id`
5. Click **Send**

## 🔄 Actualización y Versionamiento

### Agregar Nuevos Endpoints
1. Abre la colección en Postman
2. Click derecho en la carpeta apropiada → **Add Request**
3. Configura el nuevo endpoint
4. Agrega tests automáticos
5. Agrega ejemplos de respuesta (tab **Save Response**)
6. Exporta la colección: Click derecho → **Export** → Collection v2.1
7. Reemplaza el archivo JSON en este directorio

### Buenas Prácticas
- ✅ Usa variables de entorno en lugar de valores hardcodeados
- ✅ Agrega tests a cada endpoint nuevo
- ✅ Documenta los parámetros en la descripción
- ✅ Incluye ejemplos de respuestas exitosas y errores
- ✅ Agrupa endpoints relacionados en folders
- ✅ Usa nombres descriptivos para los requests

### Control de Versiones
```bash
# Después de actualizar la colección
git add postman/
git commit -m "feat(postman): Agregado endpoint X para módulo Y"
git push origin master
```

## 🐛 Troubleshooting

### Error: "Could not get any response"
- ✅ Verifica que la aplicación esté corriendo: `./gradlew.bat bootRun`
- ✅ Verifica el puerto: `netstat -ano | findstr :8082`
- ✅ Verifica la URL base en el entorno

### Error: 401 Unauthorized
- ✅ Verifica que el entorno esté seleccionado
- ✅ Actualiza el password en las variables de entorno
- ✅ El password cambia cada vez que reinicias la aplicación en modo desarrollo

### Error: 404 Not Found
- ✅ Verifica la ruta del endpoint
- ✅ Verifica que el context path sea `/api/v1`
- ✅ Verifica que el catálogo exista en la base de datos

### Tests Fallan
- ✅ Verifica que la respuesta tenga la estructura esperada
- ✅ Revisa la consola de Postman para logs detallados
- ✅ Verifica que existan datos en la base de datos

## 📦 Exportar/Compartir

### Exportar Colección
1. Click derecho en la colección → **Export**
2. Selecciona **Collection v2.1**
3. Guarda el archivo

### Compartir con el Equipo
#### Opción 1: Repositorio Git
```bash
# La colección ya está en el repositorio
git pull origin master
# Importar en Postman
```

#### Opción 2: Postman Workspace (recomendado)
1. Click derecho en la colección → **Share Collection**
2. Crea un Team Workspace
3. Invita a los miembros del equipo
4. Los cambios se sincronizan automáticamente

#### Opción 3: Link Público
1. Click derecho en la colección → **Share Collection**
2. Activa **Public Link**
3. Copia y comparte el link

## 🚢 CI/CD con Newman

Para ejecutar tests en pipelines:

```bash
# Instalar Newman
npm install -g newman

# Ejecutar colección
newman run postman/Mitoga-API.postman_collection.json \
  -e postman/Mitoga-QA.postman_environment.json \
  --reporters cli,json,html \
  --reporter-html-export newman-report.html

# Ejecutar con timeout personalizado
newman run postman/Mitoga-API.postman_collection.json \
  -e postman/Mitoga-Local.postman_environment.json \
  --timeout-request 5000 \
  --bail
```

### Integración con GitHub Actions
```yaml
# .github/workflows/api-tests.yml
name: API Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install Newman
        run: npm install -g newman
      - name: Run API Tests
        run: |
          newman run postman/Mitoga-API.postman_collection.json \
            -e postman/Mitoga-QA.postman_environment.json
```

## 📖 Recursos Adicionales

- [Documentación oficial de Postman](https://learning.postman.com/docs/)
- [Newman CLI](https://www.npmjs.com/package/newman)
- [Postman API](https://www.postman.com/postman/workspace/postman-public-workspace/documentation/12959542-c8142d51-e97c-46b6-bd77-52bb66712c9a)
- [Best Practices](https://blog.postman.com/postman-api-development-best-practices/)

## 📞 Soporte

Para reportar problemas o sugerir mejoras:
1. Crea un issue en GitHub: https://github.com/mlditsoft-mitoga/mitoga_web/issues
2. Contacta al equipo de desarrollo

---

**Versión:** 1.0.0  
**Última actualización:** 12 de noviembre de 2025  
**Mantenido por:** Equipo de Desarrollo Mitoga
