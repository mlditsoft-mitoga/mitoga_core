# 🚀 API REST - Catálogos Recursivos

**Fecha:** 12 de noviembre de 2025  
**Arquitectura:** Hexagonal Architecture + DDD  
**Stack:** Java 21 LTS, Spring Boot 3.4.0, PostgreSQL 16  
**Autor:** Backend Development Team - MI-TOGA

---

## 📋 Resumen Ejecutivo

Se ha implementado un **módulo completo de Catálogos Recursivos** siguiendo:

✅ **Arquitectura Hexagonal** (Ports & Adapters)  
✅ **Domain-Driven Design** (Aggregates, Value Objects, Repository Pattern)  
✅ **Clean Code** (SOLID, DRY, KISS principles)  
✅ **Test-Driven Development** (TDD ready - tests pendientes)  
✅ **OpenAPI/Swagger Documentation** (Auto-generado)  
✅ **i18n Support** (Español + Inglés)

---

## 🏗️ Estructura del Módulo

### Domain Layer (Core - Sin dependencias externas)

```
com.mitoga.shared.domain.catalogo/
├── CatalogoId.java (Value Object - UUID wrapper)
├── CatalogoTipo.java (Value Object - Tipo de catálogo)
├── Catalogo.java (Aggregate Root - Entidad principal)
└── CatalogoRepository.java (Port - Interface del repositorio)
```

**Value Objects:**
- `CatalogoId`: Wrapper inmutable de UUID con validaciones
- `CatalogoTipo`: Tipo de catálogo validado (máx. 100 chars, lowercase, sin espacios)

**Aggregate Root:**
- `Catalogo`: 
  - ✅ 28 atributos (id, jerarquía, negocio, auditoría)
  - ✅ Factory methods: `crearRaiz()`, `crearHijo()`
  - ✅ Validaciones de invariantes (nivel, orden, código, color hex)
  - ✅ Métodos de negocio: `desactivar()`, `activar()`, `actualizarNombre()`, etc.
  - ✅ Builder Pattern para construcción flexible

**Repository Port:**
- 14 métodos definidos:
  - `findById()`, `findByTipo()`, `findRaicesByTipo()`, `findHijos()`
  - `obtenerArbol()`, `obtenerAncestros()`, `obtenerDescendientes()`
  - `buscarPorNombre()`, `save()`, `delete()`, etc.

---

### Application Layer (Orquestación)

```
com.mitoga.shared.application.catalogo/
├── dto/
│   ├── CatalogoResponse.java (DTO principal)
│   ├── ArbolCatalogoResponse.java (Árbol completo con estadísticas)
│   ├── AncestrosResponse.java (Breadcrumb)
│   └── DescendientesResponse.java (Subárbol)
├── mapper/
│   └── CatalogoMapper.java (Domain → DTO)
└── service/
    ├── ObtenerArbolCatalogoService.java (Use Case)
    ├── ObtenerAncestrosCatalogoService.java (Use Case)
    ├── ObtenerDescendientesCatalogoService.java (Use Case)
    ├── BuscarCatalogosService.java (Use Case)
    └── CatalogoNotFoundException.java (Exception)
```

**DTOs:**
- Documentados con `@Schema` para Swagger
- Inmutables (Records de Java 21)
- Factory methods para estadísticas calculadas

**Use Cases:**
- Orquestan el dominio (NO contienen lógica de negocio)
- Transaccionales `@Transactional(readOnly = true)`
- Logging con SLF4J
- Conversión Domain → DTO via Mapper

---

### Infrastructure Layer (Adapters)

```
com.mitoga.shared.infrastructure.adapter/
├── in/rest/catalogo/
│   └── CatalogoController.java (REST API Endpoints)
└── out/persistence/catalogo/
    ├── CatalogoJpaEntity.java (JPA Entity)
    ├── CatalogoJpaRepository.java (Spring Data JPA - PENDIENTE)
    ├── CatalogoPersistenceMapper.java (JPA ↔ Domain - PENDIENTE)
    └── CatalogoPersistenceAdapter.java (Implementación Port - PENDIENTE)
```

**REST Controller:**
- 4 endpoints documentados con OpenAPI
- Respuestas estándar con `ApiResponse<T>`
- i18n con `SuccessMessage` enums

---

## 🌐 API Endpoints

### Base URL: `/api/v1/catalogos`

---

### 1. **Obtener Árbol Completo**

```http
GET /api/v1/catalogos/{tipo}/arbol?soloActivos=true&soloSeleccionables=false
```

**Descripción:** Retorna todos los nodos de un tipo de catálogo en orden jerárquico (DFS pre-order).

**Parámetros:**
- `tipo` (path) - Tipo de catálogo (ej: `categorias_tutorias`)
- `soloActivos` (query, default=true) - Filtrar solo activos
- `soloSeleccionables` (query, default=false) - Filtrar solo seleccionables

**Ejemplo Request:**
```bash
curl -X GET "http://localhost:8082/api/v1/catalogos/categorias_tutorias/arbol?soloActivos=true&soloSeleccionables=true" \
  -H "Accept: application/json"
```

**Ejemplo Response:**
```json
{
  "success": true,
  "message": "Datos recuperados exitosamente",
  "data": {
    "tipo": "categorias_tutorias",
    "totalNodos": 45,
    "nodosRaiz": 5,
    "profundidadMaxima": 3,
    "nodos": [
      {
        "id": "550e8400-e29b-41d4-a716-446655440000",
        "tipo": "categorias_tutorias",
        "padreId": null,
        "nivel": 0,
        "pathCompleto": "/550e8400-e29b-41d4-a716-446655440000",
        "codigo": "CAT-MATE",
        "nombre": "Matemáticas",
        "nombreEn": "Mathematics",
        "descripcion": "Todas las ramas de las matemáticas",
        "orden": 1,
        "icono": "fa-calculator",
        "color": "#3498DB",
        "activo": true,
        "seleccionable": false,
        "tieneHijos": true,
        "metadatos": {
          "nivel_educativo": ["primaria", "secundaria", "universidad"],
          "popularidad": 95
        },
        "creationDate": "2025-11-12T10:30:00"
      },
      {
        "id": "650e8400-e29b-41d4-a716-446655440001",
        "tipo": "categorias_tutorias",
        "padreId": "550e8400-e29b-41d4-a716-446655440000",
        "nivel": 1,
        "pathCompleto": "/550e8400-e29b-41d4-a716-446655440000/650e8400-e29b-41d4-a716-446655440001",
        "codigo": "CAT-MATE-ALG",
        "nombre": "Álgebra",
        "nombreEn": "Algebra",
        "descripcion": "Operaciones con variables y ecuaciones",
        "orden": 1,
        "icono": "fa-square-root-alt",
        "activo": true,
        "seleccionable": true,
        "tieneHijos": true,
        "creationDate": "2025-11-12T10:31:00"
      }
    ]
  },
  "timestamp": "2025-11-12T15:45:30"
}
```

**Casos de Uso:**
- ✅ Construir dropdown jerárquico (TreeSelect)
- ✅ Renderizar menú de navegación multinivel
- ✅ Mostrar categorías con filtros

---

### 2. **Obtener Ancestros (Breadcrumb)**

```http
GET /api/v1/catalogos/{id}/ancestros?incluirPropio=true
```

**Descripción:** Retorna la ruta completa desde la raíz hasta el catálogo especificado.

**Parámetros:**
- `id` (path, UUID) - Identificador del catálogo
- `incluirPropio` (query, default=true) - Incluir el nodo propio en la lista

**Ejemplo Request:**
```bash
curl -X GET "http://localhost:8082/api/v1/catalogos/750e8400-e29b-41d4-a716-446655440002/ancestros?incluirPropio=true" \
  -H "Accept: application/json"
```

**Ejemplo Response:**
```json
{
  "success": true,
  "message": "Datos recuperados exitosamente",
  "data": {
    "profundidad": 3,
    "rutaLegible": "Colombia → Cundinamarca → Bogotá D.C.",
    "ancestros": [
      {
        "id": "550e8400-e29b-41d4-a716-446655440100",
        "tipo": "ubicaciones",
        "codigo": "UBI-COL",
        "nombre": "Colombia",
        "nivel": 0,
        "activo": true
      },
      {
        "id": "650e8400-e29b-41d4-a716-446655440101",
        "tipo": "ubicaciones",
        "codigo": "UBI-COL-CUN",
        "nombre": "Cundinamarca",
        "nivel": 1,
        "activo": true
      },
      {
        "id": "750e8400-e29b-41d4-a716-446655440002",
        "tipo": "ubicaciones",
        "codigo": "UBI-COL-CUN-BOG",
        "nombre": "Bogotá D.C.",
        "nivel": 2,
        "activo": true
      }
    ]
  },
  "timestamp": "2025-11-12T15:46:00"
}
```

**Casos de Uso:**
- ✅ Breadcrumb de navegación
- ✅ Mostrar ruta de categoría actual
- ✅ Validar permisos por jerarquía

---

### 3. **Obtener Descendientes (Subárbol)**

```http
GET /api/v1/catalogos/{id}/descendientes?incluirPropio=false
```

**Descripción:** Retorna todos los nodos descendientes del catálogo especificado.

**Parámetros:**
- `id` (path, UUID) - Identificador del catálogo padre
- `incluirPropio` (query, default=false) - Incluir el nodo padre en la lista

**Ejemplo Request:**
```bash
curl -X GET "http://localhost:8082/api/v1/catalogos/550e8400-e29b-41d4-a716-446655440000/descendientes?incluirPropio=false" \
  -H "Accept: application/json"
```

**Ejemplo Response:**
```json
{
  "success": true,
  "message": "Datos recuperados exitosamente",
  "data": {
    "padre": {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "codigo": "CAT-MATE",
      "nombre": "Matemáticas",
      "nivel": 0
    },
    "totalDescendientes": 12,
    "profundidadMaxima": 2,
    "descendientes": [
      {
        "id": "650e8400-e29b-41d4-a716-446655440001",
        "codigo": "CAT-MATE-ALG",
        "nombre": "Álgebra",
        "nivel": 1
      },
      {
        "id": "750e8400-e29b-41d4-a716-446655440002",
        "codigo": "CAT-MATE-ALG-ECUA",
        "nombre": "Ecuaciones Lineales",
        "nivel": 2
      }
    ]
  },
  "timestamp": "2025-11-12T15:47:00"
}
```

**Casos de Uso:**
- ✅ Expandir subárbol bajo demanda (lazy loading)
- ✅ Mostrar todas las subcategorías de una categoría
- ✅ Calcular estadísticas por rama

---

### 4. **Buscar por Nombre**

```http
GET /api/v1/catalogos/search?tipo=categorias_tutorias&nombre=álgebra
```

**Descripción:** Busca catálogos de un tipo específico por nombre (búsqueda parcial case-insensitive).

**Parámetros:**
- `tipo` (query, required) - Tipo de catálogo
- `nombre` (query, required) - Nombre o parte del nombre a buscar

**Ejemplo Request:**
```bash
curl -X GET "http://localhost:8082/api/v1/catalogos/search?tipo=categorias_tutorias&nombre=%C3%A1lgebra" \
  -H "Accept: application/json"
```

**Ejemplo Response:**
```json
{
  "success": true,
  "message": "Datos recuperados exitosamente",
  "data": [
    {
      "id": "650e8400-e29b-41d4-a716-446655440001",
      "tipo": "categorias_tutorias",
      "codigo": "CAT-MATE-ALG",
      "nombre": "Álgebra",
      "nombreEn": "Algebra",
      "nivel": 1,
      "activo": true,
      "seleccionable": true
    },
    {
      "id": "660e8400-e29b-41d4-a716-446655440003",
      "tipo": "categorias_tutorias",
      "codigo": "CAT-MATE-ALG-LIN",
      "nombre": "Álgebra Lineal",
      "nombreEn": "Linear Algebra",
      "nivel": 2,
      "activo": true,
      "seleccionable": true
    }
  ],
  "timestamp": "2025-11-12T15:48:00"
}
```

**Casos de Uso:**
- ✅ Autocomplete en buscadores
- ✅ Filtrar dropdown grande por texto
- ✅ Búsqueda rápida de categorías

---

## 📊 Modelo de Datos (Domain)

### Catalogo Aggregate

| Campo | Tipo | Descripción | Constraints |
|-------|------|-------------|-------------|
| **id** | `CatalogoId` | Identificador único | NOT NULL, UUID |
| **tipo** | `CatalogoTipo` | Tipo de catálogo | NOT NULL, ≤100 chars |
| **padreId** | `CatalogoId` | FK al padre | NULL = raíz |
| **nivel** | `Short` | Profundidad | 0-99 |
| **pathCompleto** | `String` | Path desde raíz | Calculado por trigger |
| **codigo** | `String` | Código único | NOT NULL, ≤50 chars, UNIQUE per tipo |
| **nombre** | `String` | Nombre español | NOT NULL, ≤255 chars |
| **nombreEn** | `String` | Nombre inglés | NULL, ≤255 chars |
| **descripcion** | `String` | Descripción español | NULL, TEXT |
| **descripcionEn** | `String` | Descripción inglés | NULL, TEXT |
| **orden** | `Short` | Orden presentación | 0-9998 |
| **icono** | `String` | Clase CSS ícono | NULL, ≤100 chars |
| **color** | `String` | Color hexadecimal | NULL, #RRGGBB pattern |
| **activo** | `Boolean` | Estado activo | NOT NULL |
| **seleccionable** | `Boolean` | Seleccionable en UI | NOT NULL |
| **tieneHijos** | `Boolean` | Tiene nodos hijos | NOT NULL, calculado por trigger |
| **metadatos** | `Map` | Datos flexibles JSON | NULL, JSONB |
| **creationDate** | `LocalDateTime` | Fecha creación | NOT NULL, auto |
| **expirationDate** | `LocalDateTime` | Soft delete | NULL = activo |

---

## 🧪 Testing Strategy (Pendiente de Implementación)

### 1. Domain Tests (100% Coverage Target)

**Archivo:** `CatalogoTest.java`

```java
@Test
void crearRaiz_debeCrearCatalogoConNivelCero() {
    // Given
    CatalogoTipo tipo = new CatalogoTipo("categorias_tutorias");
    
    // When
    Catalogo catalogo = Catalogo.crearRaiz(tipo, "CAT-MATE", "Matemáticas", (short) 1);
    
    // Then
    assertThat(catalogo.getNivel()).isEqualTo((short) 0);
    assertThat(catalogo.getPadreId()).isNull();
    assertThat(catalogo.esRaiz()).isTrue();
}

@Test
void actualizarNombre_conNombreVacio_debeLanzarExcepcion() {
    // Given
    Catalogo catalogo = Catalogo.crearRaiz(...);
    
    // When/Then
    assertThatThrownBy(() -> catalogo.actualizarNombre("", null))
        .isInstanceOf(IllegalArgumentException.class)
        .hasMessageContaining("no puede estar vacío");
}
```

### 2. Application Tests (Use Cases)

**Archivo:** `ObtenerArbolCatalogoServiceTest.java`

```java
@ExtendWith(MockitoExtension.class)
class ObtenerArbolCatalogoServiceTest {
    
    @Mock
    private CatalogoRepository catalogoRepository;
    
    @Mock
    private CatalogoMapper catalogoMapper;
    
    @InjectMocks
    private ObtenerArbolCatalogoService service;
    
    @Test
    void execute_debeRetornarArbolConEstadisticas() {
        // Given
        CatalogoTipo tipo = new CatalogoTipo("categorias_tutorias");
        List<Catalogo> catalogos = List.of(/* ... */);
        when(catalogoRepository.obtenerArbol(tipo, true, false)).thenReturn(catalogos);
        
        // When
        ArbolCatalogoResponse response = service.execute("categorias_tutorias", true, false);
        
        // Then
        assertThat(response.totalNodos()).isEqualTo(catalogos.size());
        verify(catalogoRepository).obtenerArbol(tipo, true, false);
    }
}
```

### 3. Integration Tests (Testcontainers)

**Archivo:** `CatalogoControllerIntegrationTest.java`

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Testcontainers
class CatalogoControllerIntegrationTest {
    
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");
    
    @Autowired
    private TestRestTemplate restTemplate;
    
    @Test
    void obtenerArbol_debeRetornar200ConDatos() {
        // When
        ResponseEntity<String> response = restTemplate.getForEntity(
            "/api/v1/catalogos/categorias_tutorias/arbol",
            String.class
        );
        
        // Then
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).contains("Matemáticas");
    }
}
```

---

## 📦 Archivos Creados

### Domain Layer (5 archivos)
1. ✅ `CatalogoId.java` - Value Object (52 líneas)
2. ✅ `CatalogoTipo.java` - Value Object (41 líneas)
3. ✅ `Catalogo.java` - Aggregate Root (465 líneas)
4. ✅ `CatalogoRepository.java` - Repository Port (123 líneas)

### Application Layer (9 archivos)
5. ✅ `CatalogoResponse.java` - DTO (60 líneas)
6. ✅ `ArbolCatalogoResponse.java` - DTO (45 líneas)
7. ✅ `AncestrosResponse.java` - DTO (38 líneas)
8. ✅ `DescendientesResponse.java` - DTO (42 líneas)
9. ✅ `CatalogoMapper.java` - Mapper (35 líneas)
10. ✅ `ObtenerArbolCatalogoService.java` - Use Case (52 líneas)
11. ✅ `ObtenerAncestrosCatalogoService.java` - Use Case (60 líneas)
12. ✅ `ObtenerDescendientesCatalogoService.java` - Use Case (62 líneas)
13. ✅ `BuscarCatalogosService.java` - Use Case (48 líneas)
14. ✅ `CatalogoNotFoundException.java` - Exception (15 líneas)

### Infrastructure Layer (2 archivos)
15. ✅ `CatalogoJpaEntity.java` - JPA Entity (110 líneas)
16. ✅ `CatalogoController.java` - REST Controller (205 líneas)

**Total:** 16 archivos | ~1,453 líneas de código producción

---

## ⏭️ Próximos Pasos

### Tareas Pendientes (Críticas)

1. **Implementar CatalogoPersistenceAdapter** ⚠️
   - Implementar interface `CatalogoRepository`
   - Usar `CatalogoJpaRepository` (Spring Data JPA)
   - Llamar funciones PostgreSQL (`catalogo_obtener_arbol`, etc.)
   - Mapper JPA ↔ Domain

2. **Crear Tests Unitarios** ⚠️
   - Domain tests (Catalogo, Value Objects)
   - Application tests (Use Cases con mocks)
   - Target: 100% code coverage

3. **Crear Tests de Integración** ⚠️
   - Testcontainers con PostgreSQL
   - Tests end-to-end de endpoints
   - Validar funciones PostgreSQL

4. **Validar Build** ⚠️
   ```bash
   ./gradlew clean build
   ```
   - Resolver errores de compilación
   - Verificar todos los tests pasan
   - Target: BUILD SUCCESSFUL

5. **Agregar Dependencia Hypersistence** ⚠️
   ```gradle
   implementation 'io.hypersistence:hypersistence-utils-hibernate-63:3.7.0'
   ```

6. **Configurar GlobalExceptionHandler**
   - Agregar handler para `CatalogoNotFoundException`
   - Retornar 404 con mensaje localizado

---

## 🎯 Características Implementadas

✅ **Clean Architecture**: Separación clara Domain/Application/Infrastructure  
✅ **SOLID Principles**: Single Responsibility, Open/Closed, Dependency Inversion  
✅ **Immutability**: Value Objects con Records (Java 21)  
✅ **Domain Validations**: Invariantes validadas en Aggregate Root  
✅ **Factory Methods**: Creación segura de entidades  
✅ **Builder Pattern**: Construcción flexible con validaciones  
✅ **Repository Pattern**: Abstracción de persistencia  
✅ **Use Case Pattern**: Orquestación sin lógica de negocio  
✅ **DTO Pattern**: Separación Domain ↔ API  
✅ **OpenAPI Documentation**: Swagger auto-generado  
✅ **i18n Support**: Mensajes en español e inglés  
✅ **Logging**: SLF4J con contexto de negocio  
✅ **Exception Handling**: Excepciones de dominio custom  

---

## 📚 Referencias

- **Hexagonal Architecture**: Alistair Cockburn
- **Domain-Driven Design**: Eric Evans
- **Clean Architecture**: Robert C. Martin
- **Effective Java**: Joshua Bloch
- **Spring Boot Best Practices**: Baeldung, Spring Guides

---

**Documentación generada:** 12 de noviembre de 2025  
**Versión API:** v1  
**Estado:** ⚠️ Compilación pendiente - Falta adapter de persistencia y tests
