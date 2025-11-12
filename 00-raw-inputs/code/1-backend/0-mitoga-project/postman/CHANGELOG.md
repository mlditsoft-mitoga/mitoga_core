# Changelog - Colección Postman Mitoga API

Todos los cambios notables en la colección de Postman serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [Unreleased]

### Planeado
- Agregar módulo de Usuarios
- Agregar módulo de Roles y Permisos
- Implementar autenticación JWT
- Agregar tests de carga con k6
- Crear documentación pública en Postman

---

## [1.2.0] - 2025-11-12

### 🎯 CRUD Completo para Catálogos

#### ✅ Agregado
- **4 Nuevos Endpoints CRUD:**
  - `POST /catalogos/crear` - Crear catálogo (raíz o hijo) con validaciones completas
  - `POST /catalogos/actualizar` - Actualizar catálogo existente (parcial)
  - `POST /catalogos/obtener-por-id` - Obtener catálogo por ID
  - `POST /catalogos/eliminar` - Eliminar catálogo (soft delete con cascada opcional)
- **Request DTOs con Jakarta Bean Validation:**
  - `CrearCatalogoRequest` (13 campos con validaciones @NotBlank, @Size, @Pattern, @Min, @Max)
  - `ActualizarCatalogoRequest` (actualización parcial, todos campos opcionales)
  - `ObtenerCatalogoPorIdRequest` (wrapper UUID simple)
  - `EliminarCatalogoRequest` (con flag cascada)
- **Application Services (Use Cases):**
  - `CrearCatalogoService` - Validación código único, padre existente
  - `ActualizarCatalogoService` - Actualización parcial, solo campos informados
  - `ObtenerCatalogoPorIdService` - Query read-only transaccional
  - `EliminarCatalogoService` - Soft delete con lógica cascada
- **8 Métodos de Dominio en Catalogo.java:**
  - `actualizarNombreEn()`, `actualizarDescripcion()`, `actualizarDescripcionEn()`
  - `actualizarIcono()`, `actualizarColor()`, `actualizarCodigo()`, `cambiarPadre()`
- **Factory Methods:**
  - `CatalogoTipo.fromCodigo()` - Conversión string a value object
  - `CatalogoResponse.fromDomain()` - Mapeo domain a DTO
- **Tests en Postman:**
  - Tests automáticos para cada endpoint CRUD
  - Captura de `catalogoId` en variable de colección
  - Validaciones de estructura de respuesta y códigos HTTP

#### 📝 Documentación
- Agregada especificación completa en `CRUD-CATALOGOS-COMPLETADO.md`
- Ejemplos JSON completos para cada endpoint
- Documentación de validaciones y códigos de error
- Guía de uso y casos de prueba

#### 🔒 Validaciones Implementadas
- Código único por tipo de catálogo
- Código solo acepta mayúsculas, números y guiones bajos
- Padre debe existir si se especifica
- Color debe ser formato hexadecimal válido
- Orden entre 1 y 9999
- No permite eliminar nodos con hijos activos (sin flag cascada)

---

## [1.1.0] - 2025-11-12

### 🚀 BREAKING CHANGES - Política POST-Only

#### ✅ Agregado
- **Nueva Política HTTP Methods:**
  - ✅ GET: SOLO para health checks (`/actuator/health`, `/actuator/info`)
  - ✅ POST: TODOS los demás endpoints (consultas, búsquedas, operaciones)
- 4 Request DTOs con validaciones Jakarta Bean Validation:
  - `ObtenerArbolRequest` (tipo, soloActivos, soloSeleccionables)
  - `ObtenerAncestrosRequest` (catalogoId, incluirPropio)
  - `ObtenerDescendientesRequest` (catalogoId, incluirPropio)
  - `BuscarCatalogosRequest` (tipo, nombre)
- Documentación extendida en prompt de desarrollo sobre ventajas POST-only
- Sección completa de política HTTP Methods en `prompt-desarrollador-backend-senior.md`

#### ♻️ Cambiado
- **BREAKING:** `GET /catalogos/{tipo}/arbol` → `POST /catalogos/buscar-arbol`
- **BREAKING:** `GET /catalogos/{id}/ancestros` → `POST /catalogos/buscar-ancestros`
- **BREAKING:** `GET /catalogos/{id}/descendientes` → `POST /catalogos/buscar-descendientes`
- **BREAKING:** `GET /catalogos/search` → `POST /catalogos/buscar`
- Todos los parámetros ahora se envían en request body (JSON)
- URLs simplificadas (sin path variables ni query params)
- Estructura consistente: `/catalogos/buscar-*` para todas las consultas
- Controller refactorizado con `@Valid @RequestBody` en todos los endpoints
- Tests actualizados para usar `POST` con bodies JSON

#### ❌ Eliminado
- Path variables (`{tipo}`, `{id}`) en endpoints de catálogos
- Query parameters (`?soloActivos=true&soloSeleccionables=false`)
- Método GET para operaciones de consulta (excepto health checks)
- `@PathVariable` y `@RequestParam` en CatalogoController

#### 🎯 Ventajas de la Nueva Política
1. **Seguridad:** Datos en body (no en URL/logs)
2. **Flexibilidad:** Request bodies complejos sin limitación de tamaño
3. **Consistencia:** Mismo patrón para todos los endpoints
4. **Validación:** `@Valid` + Jakarta Bean Validation robusta
5. **Monitoreo:** Logs más limpios sin sensitive data en URLs

#### 📊 Estadísticas v1.1.0
- Endpoints totales: 6 (2 GET health checks + 4 POST catálogos)
- Tests automatizados: 13
- Request DTOs: 4 (con validaciones completas)
- Response DTOs: 4 (inmutables - records)
- Líneas de código DTO: 150+
- Líneas de documentación: 500+ (actualizado con política POST-only)

---

## [1.0.0] - 2025-11-12

### ✨ Agregado

#### Colección Principal
- Colección inicial `Mitoga-API.postman_collection.json` con 9 endpoints
- Estructura de módulos: Catálogos Recursivos, Health Check
- Autenticación Basic Auth a nivel de colección
- Pre-request scripts globales para timestamp automático
- Post-response scripts globales para logging

#### Módulo 1: Catálogos Recursivos (6 endpoints)
- **1.1. Obtener Árbol Completo** - `GET /catalogos/{tipo}/arbol`
  - Soporte para 6 tipos de catálogos
  - Filtrado por activos y seleccionables
  - 4 tests automatizados
  - 1 ejemplo de respuesta

- **1.2. Obtener Ancestros** - `GET /catalogos/{id}/ancestros`
  - Cadena de ancestros desde raíz
  - 3 tests automatizados
  - 1 ejemplo de respuesta

- **1.3. Obtener Descendientes** - `GET /catalogos/{id}/descendientes`
  - Filtrado por nivel máximo
  - Filtrado por activos
  - 3 tests automatizados
  - 1 ejemplo de respuesta

- **1.4. Buscar Catálogos** - `GET /catalogos/search`
  - Búsqueda multi-criterio (tipo, nombre, código)
  - Case-insensitive
  - 3 tests automatizados
  - 2 ejemplos de respuesta (éxito y sin resultados)

- **1.5. Error - Catálogo No Encontrado**
  - Ejemplo de manejo de errores 404
  - 2 tests automatizados
  - 1 ejemplo de respuesta de error

#### Módulo 2: Health Check (2 endpoints)
- **2.1. Actuator Health** - `GET /actuator/health`
  - Estado de aplicación y conexiones
  - 1 ejemplo de respuesta

- **2.2. Actuator Info** - `GET /actuator/info`
  - Información de la aplicación
  - Sin tests específicos

#### Entornos (Environments)
- **Mitoga-Local.postman_environment.json**
  - baseUrl: http://localhost:8082/api/v1
  - Credenciales de desarrollo
  - Variables: username, password, catalogoId, timestamp

- **Mitoga-QA.postman_environment.json**
  - baseUrl: https://qa.mitoga.com/api/v1
  - Configuración para ambiente de pruebas
  - Variables configurables

- **Mitoga-Production.postman_environment.json**
  - baseUrl: https://api.mitoga.com/api/v1
  - Configuración para producción (valores vacíos por seguridad)
  - Variables protegidas

#### Tests Automatizados (16 tests)
- Validación de status codes (200, 404)
- Validación de estructura `ApiResponse<T>`
- Validación de Content-Type headers
- Validación de tiempos de respuesta (< 2000ms)
- Validación de tipos de datos en respuestas
- Validación de jerarquías (niveles, orden)
- Tests específicos por endpoint

#### Scripts de Automatización
- **run-newman-tests.sh** (Linux/Mac)
  - Ejecutar tests con Newman
  - Selección de ambiente
  - Generación de reportes HTML/JSON/JUnit
  - Confirmación para producción
  - Apertura automática de reportes

- **run-newman-tests.ps1** (Windows/PowerShell)
  - Mismas funcionalidades que versión Linux
  - Sintaxis PowerShell
  - Validación de parámetros

#### Documentación
- **README.md**
  - Guía completa de uso (20 min lectura)
  - Instrucciones de importación
  - Configuración de entornos
  - Estructura de la colección
  - Tests automatizados
  - Scripts pre-request y post-response
  - Variables de entorno
  - Ejemplos de uso
  - Troubleshooting
  - CI/CD con Newman

- **RESUMEN-EJECUTIVO.md**
  - Overview del proyecto
  - Métricas de cobertura
  - Plan de mantenimiento
  - Roadmap
  - Quick start guides
  - Estadísticas actuales

- **EJEMPLO-EJECUCION.md**
  - Ejemplos de output de Newman
  - Casos de éxito y error
  - Métricas de rendimiento
  - Benchmarks y objetivos
  - Comandos útiles
  - Descripción de reportes HTML

- **CHANGELOG.md** (este archivo)
  - Historial de versiones
  - Seguimiento de cambios

#### Configuración
- **.gitignore**
  - Exclusión de archivos de producción
  - Exclusión de reportes Newman
  - Exclusión de backups temporales
  - Exclusión de archivos locales

### 🔧 Configurado

#### Variables de Colección
- `baseUrl` - URL base del API
- `username` - Usuario de autenticación
- `password` - Password de autenticación
- `catalogoId` - UUID de ejemplo para pruebas
- `timestamp` - Generado automáticamente

#### Opciones de Newman
- Timeout request: 10000ms
- Timeout script: 5000ms
- Reportes: CLI, HTML, JSON, JUnit
- Color output: Habilitado
- Bail on error: Habilitado

### 📊 Estadísticas Iniciales
- **Endpoints documentados:** 9
- **Tests automatizados:** 16
- **Ejemplos de respuesta:** 12
- **Entornos configurados:** 3
- **Scripts de automatización:** 2
- **Documentos creados:** 5
- **Cobertura de tests:** 100% de endpoints con al menos 1 test
- **Tamaño colección:** ~27 KB

### 🎯 Alcance v1.0.0
- ✅ Módulo Catálogos Recursivos - Operaciones de lectura
- ✅ Health checks básicos
- ✅ Tests automatizados
- ✅ Documentación completa
- ✅ Scripts de ejecución
- ✅ 3 entornos configurados
- ✅ Ejemplos de respuestas

---

## Tipos de Cambios

### Categorías Usadas en este Changelog

- **Agregado** (`✨ Added`) - Para nuevas funcionalidades
- **Cambiado** (`🔄 Changed`) - Para cambios en funcionalidades existentes
- **Deprecado** (`⚠️ Deprecated`) - Para funcionalidades que serán removidas
- **Removido** (`🗑️ Removed`) - Para funcionalidades removidas
- **Corregido** (`🐛 Fixed`) - Para corrección de bugs
- **Seguridad** (`🔐 Security`) - Para vulnerabilidades de seguridad

---

## Guía para Actualizar el Changelog

### Al agregar un nuevo endpoint:
```markdown
## [Unreleased]
### ✨ Agregado
- Endpoint `POST /catalogos` para crear catálogos
  - Validación de campos requeridos
  - 5 tests automatizados
  - 2 ejemplos de respuesta (201, 400)
```

### Al modificar un endpoint existente:
```markdown
## [Unreleased]
### 🔄 Cambiado
- Endpoint `GET /catalogos/search` ahora soporta ordenamiento
  - Agregado parámetro `orderBy` (opcional)
  - Actualizado test de validación de respuesta
  - Actualizado ejemplo de respuesta
```

### Al corregir un error:
```markdown
## [Unreleased]
### 🐛 Corregido
- Endpoint `GET /catalogos/{id}/ancestros` devolvía orden incorrecto
  - Corregido ordenamiento de ancestros (ahora de raíz a padre)
  - Actualizado test de validación de orden
```

### Al crear una nueva versión:
1. Mover contenido de `[Unreleased]` a nueva sección con fecha
2. Actualizar número de versión siguiendo Semantic Versioning
3. Agregar link de comparación al final del archivo

---

## Links de Versiones

[Unreleased]: https://github.com/mlditsoft-mitoga/mitoga_web/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/mlditsoft-mitoga/mitoga_web/releases/tag/v1.0.0

---

**Nota sobre Versionamiento:**

### MAJOR (X.0.0)
- Cambios incompatibles con versiones anteriores
- Reestructuración completa de la colección
- Cambio de autenticación (Basic Auth → JWT)

### MINOR (1.X.0)
- Nuevas funcionalidades compatibles con versión anterior
- Nuevos módulos (Usuarios, Roles, etc.)
- Nuevos endpoints en módulos existentes

### PATCH (1.0.X)
- Corrección de bugs
- Actualización de tests
- Actualización de ejemplos de respuestas
- Mejoras en documentación
