# HUT-000-API-01: Estandarización de Respuestas REST API

## 📋 Metadata

- **ID:** HUT-000-API-01
- **Tipo:** API Layer (Cross-Cutting Concern)
- **Bounded Context:** Shared Kernel (aplicable a todos los BCs)
- **Prioridad:** CRÍTICA (Fundacional)
- **Story Points Técnicos:** 2 SP
- **Estimación:** 1 día
- **Dependencias:** Ninguna (es fundacional)
- **Fecha Creación:** 2025-11-08

---

## 🎯 Objetivo Técnico

Implementar un **estándar de respuesta REST** unificado para todas las APIs del backend, siguiendo convenciones internacionales (RFC 7807 Problem Details, JSend) y mejores prácticas de Spring Boot.

**Beneficios:**
- ✅ Consistencia en todas las respuestas HTTP
- ✅ Experiencia predecible para frontend
- ✅ Manejo centralizado de errores
- ✅ Facilita debugging y logging
- ✅ Compatible con OpenAPI/Swagger

---

## 📐 Diseño de Respuesta Estándar (Convención Internacional)

### 1. Respuestas de Éxito (2xx)

#### Estructura JSON Unificada (JSend-inspired)

```java
/**
 * Respuesta estándar para operaciones exitosas.
 * Basado en JSend specification y RFC 7807.
 */
public record ApiResponse<T>(
    String status,        // "success" | "error" | "fail"
    String message,       // Mensaje descriptivo
    T data,              // Payload (puede ser null)
    Meta meta,           // Metadata opcional (paginación, timestamps, etc.)
    Long timestamp       // Unix timestamp en milisegundos
) {
    public static <T> ApiResponse<T> success(T data, String message) {
        return new ApiResponse<>(
            "success",
            message,
            data,
            null,
            System.currentTimeMillis()
        );
    }
    
    public static <T> ApiResponse<T> success(T data) {
        return success(data, "Operación exitosa");
    }
}

/**
 * Metadata adicional (paginación, versión, etc.)
 */
public record Meta(
    Integer page,           // Página actual (pagination)
    Integer pageSize,       // Tamaño de página
    Long totalElements,     // Total de elementos
    Integer totalPages,     // Total de páginas
    String version          // Versión de API
) {}
```

#### Ejemplo 1: GET con Paginación

**Request:** `GET /api/v1/tutores?page=0&size=10`

**Response (200 OK):**
```json
{
  "status": "success",
  "message": "Tutores recuperados exitosamente",
  "data": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "nombre": "Juan Pérez",
      "email": "juan@example.com",
      "especialidad": "Matemáticas"
    }
  ],
  "meta": {
    "page": 0,
    "pageSize": 10,
    "totalElements": 45,
    "totalPages": 5,
    "version": "v1"
  },
  "timestamp": 1699468800000
}
```

#### Ejemplo 2: POST Creación

**Request:** `POST /api/v1/usuarios/registro`

**Response (201 CREATED):**
```json
{
  "status": "success",
  "message": "Usuario registrado exitosamente",
  "data": {
    "id": "660f9500-f39c-52e5-b827-557766551111",
    "nombre": "María López",
    "email": "maria@example.com",
    "rol": "ESTUDIANTE"
  },
  "meta": null,
  "timestamp": 1699468805000
}
```

#### Ejemplo 3: PUT Actualización

**Response (200 OK):**
```json
{
  "status": "success",
  "message": "Perfil actualizado exitosamente",
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "biografia": "Nueva biografía actualizada"
  },
  "meta": null,
  "timestamp": 1699468810000
}
```

#### Ejemplo 4: DELETE

**Response (200 OK):**
```json
{
  "status": "success",
  "message": "Reserva cancelada exitosamente",
  "data": null,
  "meta": null,
  "timestamp": 1699468815000
}
```

---

### 2. Respuestas de Error (4xx, 5xx)

#### Estructura JSON Unificada (RFC 7807 Problem Details)

```java
/**
 * Respuesta estándar para errores.
 * Compatible con RFC 7807 Problem Details for HTTP APIs.
 */
public record ErrorResponse(
    String status,        // "error" (server) | "fail" (client)
    String message,       // Mensaje descriptivo para usuario
    String error,         // Tipo de error técnico
    Integer code,         // HTTP status code
    String path,          // URI donde ocurrió el error
    Long timestamp,       // Unix timestamp
    List<ValidationError> details  // Errores de validación (opcional)
) {
    public static ErrorResponse clientError(String message, String error, int code, String path) {
        return new ErrorResponse(
            "fail",
            message,
            error,
            code,
            path,
            System.currentTimeMillis(),
            null
        );
    }
    
    public static ErrorResponse serverError(String message, String error, int code, String path) {
        return new ErrorResponse(
            "error",
            message,
            error,
            code,
            path,
            System.currentTimeMillis(),
            null
        );
    }
}

/**
 * Detalle de errores de validación.
 */
public record ValidationError(
    String field,      // Campo con error
    String message,    // Mensaje de error
    Object rejectedValue  // Valor rechazado (opcional)
) {}
```

#### Ejemplo 1: Bad Request (400) - Validación

**Request:** `POST /api/v1/usuarios/registro` (email inválido)

**Response (400 BAD REQUEST):**
```json
{
  "status": "fail",
  "message": "Errores de validación en los datos enviados",
  "error": "ValidationException",
  "code": 400,
  "path": "/api/v1/usuarios/registro",
  "timestamp": 1699468820000,
  "details": [
    {
      "field": "email",
      "message": "El email debe tener formato válido",
      "rejectedValue": "email-invalido"
    },
    {
      "field": "password",
      "message": "La contraseña debe tener al menos 8 caracteres",
      "rejectedValue": "123"
    }
  ]
}
```

#### Ejemplo 2: Not Found (404)

**Response (404 NOT FOUND):**
```json
{
  "status": "fail",
  "message": "Usuario no encontrado con ID: 550e8400-e29b-41d4-a716-446655440000",
  "error": "ResourceNotFoundException",
  "code": 404,
  "path": "/api/v1/usuarios/550e8400-e29b-41d4-a716-446655440000",
  "timestamp": 1699468825000,
  "details": null
}
```

#### Ejemplo 3: Conflict (409)

**Response (409 CONFLICT):**
```json
{
  "status": "fail",
  "message": "El email maria@example.com ya está registrado",
  "error": "DuplicateResourceException",
  "code": 409,
  "path": "/api/v1/usuarios/registro",
  "timestamp": 1699468830000,
  "details": null
}
```

#### Ejemplo 4: Internal Server Error (500)

**Response (500 INTERNAL SERVER ERROR):**
```json
{
  "status": "error",
  "message": "Error interno del servidor. Contacte al administrador.",
  "error": "InternalServerError",
  "code": 500,
  "path": "/api/v1/reservas",
  "timestamp": 1699468835000,
  "details": null
}
```

#### Ejemplo 5: Unauthorized (401)

**Response (401 UNAUTHORIZED):**
```json
{
  "status": "fail",
  "message": "Token JWT inválido o expirado",
  "error": "UnauthorizedException",
  "code": 401,
  "path": "/api/v1/perfil",
  "timestamp": 1699468840000,
  "details": null
}
```

#### Ejemplo 6: Forbidden (403)

**Response (403 FORBIDDEN):**
```json
{
  "status": "fail",
  "message": "No tienes permisos para acceder a este recurso",
  "error": "ForbiddenException",
  "code": 403,
  "path": "/api/v1/admin/usuarios",
  "timestamp": 1699468845000,
  "details": null
}
```

---

## 🏗️ Implementación Técnica

### 1. Clases Java (Records)

**Ubicación:** `com.mitoga.shared.infrastructure.api.response`

```
src/main/java/com/mitoga/shared/infrastructure/api/response/
├── ApiResponse.java          # Respuesta de éxito
├── ErrorResponse.java        # Respuesta de error
├── Meta.java                 # Metadata (paginación, etc.)
└── ValidationError.java      # Detalle de validación
```

### 2. Global Exception Handler

**Ubicación:** `com.mitoga.shared.infrastructure.api.exception`

```java
@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(
        MethodArgumentNotValidException ex,
        HttpServletRequest request
    ) {
        List<ValidationError> details = ex.getBindingResult()
            .getFieldErrors()
            .stream()
            .map(error -> new ValidationError(
                error.getField(),
                error.getDefaultMessage(),
                error.getRejectedValue()
            ))
            .toList();
            
        ErrorResponse response = new ErrorResponse(
            "fail",
            "Errores de validación en los datos enviados",
            "ValidationException",
            400,
            request.getRequestURI(),
            System.currentTimeMillis(),
            details
        );
        
        return ResponseEntity.badRequest().body(response);
    }
    
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(
        ResourceNotFoundException ex,
        HttpServletRequest request
    ) {
        ErrorResponse response = ErrorResponse.clientError(
            ex.getMessage(),
            "ResourceNotFoundException",
            404,
            request.getRequestURI()
        );
        
        return ResponseEntity.status(404).body(response);
    }
    
    // Más handlers...
}
```

### 3. Uso en Controllers

```java
@RestController
@RequestMapping("/api/v1/usuarios")
public class UsuarioController {

    @PostMapping("/registro")
    public ResponseEntity<ApiResponse<UsuarioResponse>> registrar(
        @Valid @RequestBody RegistrarUsuarioRequest request
    ) {
        UsuarioResponse usuario = registrarUsuarioUseCase.ejecutar(request);
        
        ApiResponse<UsuarioResponse> response = ApiResponse.success(
            usuario,
            "Usuario registrado exitosamente"
        );
        
        return ResponseEntity.status(201).body(response);
    }
    
    @GetMapping
    public ResponseEntity<ApiResponse<Page<TutorResponse>>> listarTutores(
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "10") int size
    ) {
        Page<TutorResponse> tutores = listarTutoresQuery.ejecutar(page, size);
        
        Meta meta = new Meta(
            tutores.getNumber(),
            tutores.getSize(),
            tutores.getTotalElements(),
            tutores.getTotalPages(),
            "v1"
        );
        
        ApiResponse<Page<TutorResponse>> response = new ApiResponse<>(
            "success",
            "Tutores recuperados exitosamente",
            tutores,
            meta,
            System.currentTimeMillis()
        );
        
        return ResponseEntity.ok(response);
    }
}
```

---

## ✅ Criterios de Aceptación Técnicos (Given-When-Then)

### Escenario 1: Respuesta de éxito sin datos
```gherkin
Given el endpoint "/api/v1/usuarios/123" existe
When se ejecuta DELETE /api/v1/usuarios/123
Then la respuesta tiene HTTP 200
And el JSON tiene estructura:
  | campo     | valor           |
  | status    | "success"       |
  | message   | "Usuario eliminado exitosamente" |
  | data      | null            |
  | meta      | null            |
  | timestamp | <número positivo> |
```

### Escenario 2: Respuesta con paginación
```gherkin
Given existen 45 tutores en BD
When se ejecuta GET /api/v1/tutores?page=0&size=10
Then la respuesta tiene HTTP 200
And el JSON contiene:
  - status: "success"
  - data: array con 10 elementos
  - meta.page: 0
  - meta.pageSize: 10
  - meta.totalElements: 45
  - meta.totalPages: 5
```

### Escenario 3: Error de validación (400)
```gherkin
Given el endpoint "/api/v1/usuarios/registro" espera email válido
When se envía POST con email inválido "email-invalido"
Then la respuesta tiene HTTP 400
And el JSON contiene:
  - status: "fail"
  - error: "ValidationException"
  - details[0].field: "email"
  - details[0].message contiene "formato válido"
```

### Escenario 4: Recurso no encontrado (404)
```gherkin
Given el usuario con ID "uuid-inexistente" no existe
When se ejecuta GET /api/v1/usuarios/uuid-inexistente
Then la respuesta tiene HTTP 404
And el JSON contiene:
  - status: "fail"
  - error: "ResourceNotFoundException"
  - message contiene "no encontrado"
```

### Escenario 5: Error de servidor (500)
```gherkin
Given la BD PostgreSQL está caída
When se ejecuta GET /api/v1/tutores
Then la respuesta tiene HTTP 500
And el JSON contiene:
  - status: "error"
  - error: "InternalServerError"
  - message: "Error interno del servidor"
And NO se exponen detalles técnicos internos
```

---

## 🧪 Tests

### 1. Unit Tests (ApiResponse, ErrorResponse)

```java
@Test
void deberiaCrearRespuestaExitosaSinMeta() {
    var data = Map.of("id", "123", "nombre", "Test");
    var response = ApiResponse.success(data, "Test exitoso");
    
    assertThat(response.status()).isEqualTo("success");
    assertThat(response.message()).isEqualTo("Test exitoso");
    assertThat(response.data()).isEqualTo(data);
    assertThat(response.meta()).isNull();
    assertThat(response.timestamp()).isPositive();
}

@Test
void deberiaCrearErrorResponseConDetalles() {
    var details = List.of(
        new ValidationError("email", "Email inválido", "test")
    );
    
    var response = new ErrorResponse(
        "fail",
        "Validación fallida",
        "ValidationException",
        400,
        "/api/v1/test",
        System.currentTimeMillis(),
        details
    );
    
    assertThat(response.status()).isEqualTo("fail");
    assertThat(response.code()).isEqualTo(400);
    assertThat(response.details()).hasSize(1);
}
```

### 2. Integration Tests (GlobalExceptionHandler)

```java
@WebMvcTest
@Import(GlobalExceptionHandler.class)
class GlobalExceptionHandlerTest {

    @Autowired
    private MockMvc mockMvc;
    
    @Test
    void deberiaManejarValidationException() throws Exception {
        mockMvc.perform(post("/api/v1/usuarios/registro")
            .contentType(APPLICATION_JSON)
            .content("{\"email\":\"invalido\"}"))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.status").value("fail"))
            .andExpect(jsonPath("$.error").value("ValidationException"))
            .andExpect(jsonPath("$.details").isArray());
    }
}
```

---

## 📝 Definition of Done

- [ ] Records creados: `ApiResponse`, `ErrorResponse`, `Meta`, `ValidationError`
- [ ] `GlobalExceptionHandler` implementado con todos los handlers
- [ ] Unit tests para records (cobertura >90%)
- [ ] Integration tests para exception handler (cobertura >80%)
- [ ] Documentación OpenAPI actualizada con ejemplos de respuesta
- [ ] Todos los controllers existentes migrados al nuevo estándar
- [ ] Code review aprobado por Tech Lead
- [ ] Documentación técnica en `docs/api-response-standard.md`

---

## 📚 Referencias

- **RFC 7807:** Problem Details for HTTP APIs (https://tools.ietf.org/html/rfc7807)
- **JSend Specification:** https://github.com/omniti-labs/jsend
- **Spring Boot Error Handling:** https://spring.io/blog/2013/11/01/exception-handling-in-spring-mvc
- **OpenAPI 3.0 Response Object:** https://swagger.io/specification/#response-object

---

## 🔗 Trazabilidad

- **Relacionada con:** Todas las HUs de API (HUT-XXX-API-XX)
- **Bloquea:** Ninguna (es fundacional, otras HUTs la usan)
- **Dependencias:** Ninguna

---

**Fecha:** 2025-11-08  
**Autor:** Arquitecto Técnico Senior  
**Versión:** 1.0
