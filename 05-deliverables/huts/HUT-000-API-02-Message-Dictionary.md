# HUT-000-API-02: Diccionarios de Mensajes con Enums

## 📋 Metadata

- **ID:** HUT-000-API-02
- **Tipo:** API Layer (Cross-Cutting Concern)
- **Bounded Context:** Shared Kernel (aplicable a todos los BCs)
- **Prioridad:** CRÍTICA (Fundacional)
- **Story Points Técnicos:** 2 SP
- **Estimación:** 1 día
- **Dependencias:** HUT-000-API-01 (Standard Response)
- **Fecha Creación:** 2025-11-08

---

## 🎯 Objetivo Técnico

Implementar un **sistema de diccionarios de mensajes** centralizado mediante **Java Enums**, que controle todos los mensajes de éxito y error de la aplicación de forma consistente, internacionalizable y type-safe.

**Beneficios:**
- ✅ **Consistencia:** Mensajes estandarizados en toda la aplicación
- ✅ **Type Safety:** Enums previenen typos y referencias inexistentes
- ✅ **Centralización:** Un solo lugar para gestionar mensajes
- ✅ **i18n Ready:** Preparado para internacionalización (ES, EN, PT)
- ✅ **Trazabilidad:** Códigos únicos para tracking y logging
- ✅ **Mantenibilidad:** Cambios de mensajes sin tocar lógica de negocio

---

## 📐 Diseño de Enums de Mensajes

### 1. Estructura Base - MessageCode Interface

```java
/**
 * Interfaz base para todos los códigos de mensaje de la aplicación.
 * Define el contrato que deben cumplir todos los enums de mensajes.
 *
 * <p>Propósito: Permitir polimorfismo con diferentes tipos de mensajes
 * (success, error, validation) manteniendo type safety.</p>
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
public interface MessageCode {
    
    /**
     * Código único del mensaje (ej: "USER_001", "VAL_002").
     * Formato: [MODULO]_[NÚMERO]
     * 
     * @return Código alfanumérico único
     */
    String getCode();
    
    /**
     * Mensaje en español (idioma por defecto).
     * 
     * @return Mensaje descriptivo en español
     */
    String getMessage();
    
    /**
     * Categoría del mensaje para clasificación.
     * 
     * @return Categoría (SUCCESS, ERROR, VALIDATION, INFO, WARNING)
     */
    MessageCategory getCategory();
    
    /**
     * Nivel de severidad del mensaje (solo para errores).
     * 
     * @return Nivel de severidad (LOW, MEDIUM, HIGH, CRITICAL)
     */
    default MessageSeverity getSeverity() {
        return MessageSeverity.MEDIUM;
    }
}
```

### 2. Enums de Clasificación

```java
/**
 * Categoría del mensaje para filtrado y procesamiento.
 */
public enum MessageCategory {
    SUCCESS("Éxito"),
    ERROR("Error"),
    VALIDATION("Validación"),
    INFO("Información"),
    WARNING("Advertencia");
    
    private final String displayName;
    
    MessageCategory(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
}

/**
 * Nivel de severidad para mensajes de error.
 */
public enum MessageSeverity {
    LOW("Baja"),
    MEDIUM("Media"),
    HIGH("Alta"),
    CRITICAL("Crítica");
    
    private final String displayName;
    
    MessageSeverity(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
}
```

### 3. Enum de Mensajes de Éxito - SuccessMessage

```java
package com.mitoga.shared.infrastructure.api.message;

import lombok.Getter;

/**
 * Diccionario de mensajes de éxito de la aplicación.
 * Centraliza todos los mensajes para operaciones exitosas.
 *
 * <p><strong>Convención de códigos:</strong></p>
 * <ul>
 *   <li>GEN_xxx: Mensajes genéricos (CRUD)</li>
 *   <li>USER_xxx: Módulo de usuarios</li>
 *   <li>TUTOR_xxx: Módulo de tutores</li>
 *   <li>RESERVA_xxx: Módulo de reservas</li>
 *   <li>PAGO_xxx: Módulo de pagos</li>
 * </ul>
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
@Getter
public enum SuccessMessage implements MessageCode {
    
    // ========== MENSAJES GENÉRICOS (GEN) ==========
    
    GEN_CREATED(
        "GEN_001",
        "Recurso creado exitosamente"
    ),
    
    GEN_UPDATED(
        "GEN_002",
        "Recurso actualizado exitosamente"
    ),
    
    GEN_DELETED(
        "GEN_003",
        "Recurso eliminado exitosamente"
    ),
    
    GEN_RETRIEVED(
        "GEN_004",
        "Recurso recuperado exitosamente"
    ),
    
    GEN_LIST_RETRIEVED(
        "GEN_005",
        "Lista recuperada exitosamente"
    ),
    
    // ========== MÓDULO USUARIOS (USER) ==========
    
    USER_REGISTERED(
        "USER_001",
        "Usuario registrado exitosamente. Revisa tu email para activar tu cuenta"
    ),
    
    USER_ACTIVATED(
        "USER_002",
        "Cuenta activada exitosamente. Ya puedes iniciar sesión"
    ),
    
    USER_LOGIN_SUCCESS(
        "USER_003",
        "Inicio de sesión exitoso. Bienvenido"
    ),
    
    USER_LOGOUT_SUCCESS(
        "USER_004",
        "Sesión cerrada exitosamente"
    ),
    
    USER_PASSWORD_RESET_REQUESTED(
        "USER_005",
        "Se ha enviado un email con instrucciones para restablecer tu contraseña"
    ),
    
    USER_PASSWORD_RESET_SUCCESS(
        "USER_006",
        "Contraseña restablecida exitosamente"
    ),
    
    USER_PROFILE_UPDATED(
        "USER_007",
        "Perfil actualizado exitosamente"
    ),
    
    USER_EMAIL_VERIFIED(
        "USER_008",
        "Email verificado exitosamente"
    ),
    
    // ========== MÓDULO TUTORES (TUTOR) ==========
    
    TUTOR_PROFILE_CREATED(
        "TUTOR_001",
        "Perfil de tutor creado exitosamente. Pendiente de aprobación"
    ),
    
    TUTOR_PROFILE_APPROVED(
        "TUTOR_002",
        "Perfil de tutor aprobado. Ya puedes recibir reservas"
    ),
    
    TUTOR_DISPONIBILIDAD_UPDATED(
        "TUTOR_003",
        "Disponibilidad actualizada exitosamente"
    ),
    
    TUTOR_ESPECIALIDAD_ADDED(
        "TUTOR_004",
        "Especialidad agregada exitosamente"
    ),
    
    // ========== MÓDULO RESERVAS (RESERVA) ==========
    
    RESERVA_CREATED(
        "RESERVA_001",
        "Reserva creada exitosamente. Pendiente de confirmación del tutor"
    ),
    
    RESERVA_CONFIRMED(
        "RESERVA_002",
        "Reserva confirmada exitosamente. Te esperamos"
    ),
    
    RESERVA_CANCELLED(
        "RESERVA_003",
        "Reserva cancelada exitosamente"
    ),
    
    RESERVA_COMPLETED(
        "RESERVA_004",
        "Sesión completada exitosamente. Por favor califica al tutor"
    ),
    
    RESERVA_RESCHEDULED(
        "RESERVA_005",
        "Reserva reagendada exitosamente"
    ),
    
    // ========== MÓDULO PAGOS (PAGO) ==========
    
    PAGO_PROCESSED(
        "PAGO_001",
        "Pago procesado exitosamente"
    ),
    
    PAGO_REFUNDED(
        "PAGO_002",
        "Reembolso procesado exitosamente. El dinero estará disponible en 3-5 días hábiles"
    ),
    
    PAGO_METHOD_ADDED(
        "PAGO_003",
        "Método de pago agregado exitosamente"
    );
    
    private final String code;
    private final String message;
    
    SuccessMessage(String code, String message) {
        this.code = code;
        this.message = message;
    }
    
    @Override
    public MessageCategory getCategory() {
        return MessageCategory.SUCCESS;
    }
    
    /**
     * Factory method para crear mensaje con parámetros dinámicos.
     *
     * @param params Parámetros para interpolar en el mensaje
     * @return Mensaje formateado
     */
    public String format(Object... params) {
        return String.format(this.message, params);
    }
}
```

### 4. Enum de Mensajes de Error - ErrorMessage

```java
package com.mitoga.shared.infrastructure.api.message;

import lombok.Getter;

/**
 * Diccionario de mensajes de error de la aplicación.
 * Centraliza todos los mensajes de error con códigos únicos y severidad.
 *
 * <p><strong>Convención de códigos:</strong></p>
 * <ul>
 *   <li>ERR_GEN_xxx: Errores genéricos del sistema</li>
 *   <li>ERR_AUTH_xxx: Errores de autenticación</li>
 *   <li>ERR_VAL_xxx: Errores de validación</li>
 *   <li>ERR_USER_xxx: Errores del módulo usuarios</li>
 *   <li>ERR_TUTOR_xxx: Errores del módulo tutores</li>
 *   <li>ERR_RESERVA_xxx: Errores del módulo reservas</li>
 *   <li>ERR_PAGO_xxx: Errores del módulo pagos</li>
 * </ul>
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
@Getter
public enum ErrorMessage implements MessageCode {
    
    // ========== ERRORES GENÉRICOS (ERR_GEN) ==========
    
    ERR_GEN_INTERNAL_SERVER(
        "ERR_GEN_001",
        "Error interno del servidor. Por favor contacte al administrador",
        MessageSeverity.CRITICAL
    ),
    
    ERR_GEN_RESOURCE_NOT_FOUND(
        "ERR_GEN_002",
        "%s no encontrado con ID: %s",
        MessageSeverity.MEDIUM
    ),
    
    ERR_GEN_INVALID_REQUEST(
        "ERR_GEN_003",
        "La solicitud es inválida o está mal formada",
        MessageSeverity.LOW
    ),
    
    ERR_GEN_DATABASE_CONNECTION(
        "ERR_GEN_004",
        "Error de conexión con la base de datos",
        MessageSeverity.CRITICAL
    ),
    
    // ========== ERRORES DE AUTENTICACIÓN (ERR_AUTH) ==========
    
    ERR_AUTH_INVALID_CREDENTIALS(
        "ERR_AUTH_001",
        "Email o contraseña incorrectos",
        MessageSeverity.MEDIUM
    ),
    
    ERR_AUTH_TOKEN_EXPIRED(
        "ERR_AUTH_002",
        "Tu sesión ha expirado. Por favor inicia sesión nuevamente",
        MessageSeverity.MEDIUM
    ),
    
    ERR_AUTH_TOKEN_INVALID(
        "ERR_AUTH_003",
        "Token de autenticación inválido",
        MessageSeverity.HIGH
    ),
    
    ERR_AUTH_UNAUTHORIZED(
        "ERR_AUTH_004",
        "No tienes permisos para acceder a este recurso",
        MessageSeverity.HIGH
    ),
    
    ERR_AUTH_ACCOUNT_DISABLED(
        "ERR_AUTH_005",
        "Tu cuenta está deshabilitada. Contacta al administrador",
        MessageSeverity.HIGH
    ),
    
    ERR_AUTH_ACCOUNT_NOT_ACTIVATED(
        "ERR_AUTH_006",
        "Tu cuenta no está activada. Revisa tu email para activarla",
        MessageSeverity.MEDIUM
    ),
    
    // ========== ERRORES DE VALIDACIÓN (ERR_VAL) ==========
    
    ERR_VAL_REQUIRED_FIELD(
        "ERR_VAL_001",
        "El campo '%s' es obligatorio",
        MessageSeverity.LOW
    ),
    
    ERR_VAL_INVALID_EMAIL(
        "ERR_VAL_002",
        "El email '%s' no tiene formato válido",
        MessageSeverity.LOW
    ),
    
    ERR_VAL_PASSWORD_TOO_SHORT(
        "ERR_VAL_003",
        "La contraseña debe tener al menos %d caracteres",
        MessageSeverity.LOW
    ),
    
    ERR_VAL_PASSWORD_WEAK(
        "ERR_VAL_004",
        "La contraseña debe contener mayúsculas, minúsculas, números y caracteres especiales",
        MessageSeverity.LOW
    ),
    
    ERR_VAL_DATE_INVALID(
        "ERR_VAL_005",
        "La fecha '%s' no es válida",
        MessageSeverity.LOW
    ),
    
    ERR_VAL_DATE_PAST(
        "ERR_VAL_006",
        "La fecha no puede ser en el pasado",
        MessageSeverity.LOW
    ),
    
    // ========== ERRORES USUARIOS (ERR_USER) ==========
    
    ERR_USER_EMAIL_ALREADY_EXISTS(
        "ERR_USER_001",
        "El email '%s' ya está registrado",
        MessageSeverity.MEDIUM
    ),
    
    ERR_USER_NOT_FOUND(
        "ERR_USER_002",
        "Usuario no encontrado con ID: %s",
        MessageSeverity.MEDIUM
    ),
    
    ERR_USER_ACTIVATION_TOKEN_INVALID(
        "ERR_USER_003",
        "El token de activación es inválido o ha expirado",
        MessageSeverity.MEDIUM
    ),
    
    // ========== ERRORES TUTORES (ERR_TUTOR) ==========
    
    ERR_TUTOR_NOT_FOUND(
        "ERR_TUTOR_001",
        "Tutor no encontrado con ID: %s",
        MessageSeverity.MEDIUM
    ),
    
    ERR_TUTOR_NOT_APPROVED(
        "ERR_TUTOR_002",
        "El tutor no está aprobado para recibir reservas",
        MessageSeverity.MEDIUM
    ),
    
    ERR_TUTOR_NOT_AVAILABLE(
        "ERR_TUTOR_003",
        "El tutor no está disponible en el horario seleccionado",
        MessageSeverity.MEDIUM
    ),
    
    // ========== ERRORES RESERVAS (ERR_RESERVA) ==========
    
    ERR_RESERVA_NOT_FOUND(
        "ERR_RESERVA_001",
        "Reserva no encontrada con ID: %s",
        MessageSeverity.MEDIUM
    ),
    
    ERR_RESERVA_SLOT_NOT_AVAILABLE(
        "ERR_RESERVA_002",
        "El horario seleccionado ya no está disponible",
        MessageSeverity.MEDIUM
    ),
    
    ERR_RESERVA_CANNOT_CANCEL(
        "ERR_RESERVA_003",
        "No se puede cancelar la reserva. Debe hacerse con al menos %d horas de anticipación",
        MessageSeverity.MEDIUM
    ),
    
    ERR_RESERVA_ALREADY_CONFIRMED(
        "ERR_RESERVA_004",
        "La reserva ya está confirmada",
        MessageSeverity.LOW
    ),
    
    // ========== ERRORES PAGOS (ERR_PAGO) ==========
    
    ERR_PAGO_PAYMENT_FAILED(
        "ERR_PAGO_001",
        "El pago no pudo ser procesado. Por favor intenta con otro método de pago",
        MessageSeverity.HIGH
    ),
    
    ERR_PAGO_INSUFFICIENT_FUNDS(
        "ERR_PAGO_002",
        "Fondos insuficientes",
        MessageSeverity.MEDIUM
    ),
    
    ERR_PAGO_INVALID_CARD(
        "ERR_PAGO_003",
        "La tarjeta es inválida o ha sido rechazada",
        MessageSeverity.MEDIUM
    );
    
    private final String code;
    private final String message;
    private final MessageSeverity severity;
    
    ErrorMessage(String code, String message, MessageSeverity severity) {
        this.code = code;
        this.message = message;
        this.severity = severity;
    }
    
    @Override
    public MessageCategory getCategory() {
        return MessageCategory.ERROR;
    }
    
    /**
     * Factory method para crear mensaje con parámetros dinámicos.
     *
     * @param params Parámetros para interpolar en el mensaje
     * @return Mensaje formateado
     */
    public String format(Object... params) {
        return String.format(this.message, params);
    }
}
```

### 5. Helper - MessageResolver

```java
package com.mitoga.shared.infrastructure.api.message;

import org.springframework.stereotype.Component;

/**
 * Resolutor de mensajes para uso en servicios y controllers.
 * Proporciona métodos helper para trabajar con enums de mensajes.
 *
 * <p>Preparado para internacionalización futura con MessageSource.</p>
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
@Component
public class MessageResolver {
    
    /**
     * Resuelve mensaje de éxito con parámetros.
     *
     * @param message Enum de mensaje de éxito
     * @param params Parámetros para interpolar
     * @return Mensaje formateado
     */
    public String resolve(SuccessMessage message, Object... params) {
        return params.length > 0 ? message.format(params) : message.getMessage();
    }
    
    /**
     * Resuelve mensaje de error con parámetros.
     *
     * @param message Enum de mensaje de error
     * @param params Parámetros para interpolar
     * @return Mensaje formateado
     */
    public String resolve(ErrorMessage message, Object... params) {
        return params.length > 0 ? message.format(params) : message.getMessage();
    }
    
    /**
     * Obtiene código del mensaje para logging/tracking.
     *
     * @param message Mensaje
     * @return Código único
     */
    public String getCode(MessageCode message) {
        return message.getCode();
    }
    
    /**
     * Obtiene severidad del error para alertas.
     *
     * @param message Mensaje de error
     * @return Nivel de severidad
     */
    public MessageSeverity getSeverity(ErrorMessage message) {
        return message.getSeverity();
    }
}
```

---

## 📝 Ejemplos de Uso

### Ejemplo 1: En Controller con ApiResponse

```java
@RestController
@RequestMapping("/api/v1/usuarios")
@RequiredArgsConstructor
public class UsuarioController {

    private final RegistrarUsuarioUseCase registrarUsuarioUseCase;
    private final MessageResolver messageResolver;
    
    @PostMapping("/registro")
    public ResponseEntity<ApiResponse<UsuarioResponse>> registrarUsuario(
        @Valid @RequestBody RegistrarUsuarioRequest request
    ) {
        UsuarioResponse usuario = registrarUsuarioUseCase.ejecutar(request);
        
        // Usar enum de mensaje de éxito
        String message = messageResolver.resolve(SuccessMessage.USER_REGISTERED);
        
        ApiResponse<UsuarioResponse> response = ApiResponse.success(usuario, message);
        
        return ResponseEntity.status(201).body(response);
    }
}
```

### Ejemplo 2: En Domain Service lanzando excepción

```java
@Service
@RequiredArgsConstructor
public class UsuarioDomainService {

    private final UsuarioRepository usuarioRepository;
    private final MessageResolver messageResolver;
    
    public void validarEmailUnico(Email email) {
        if (usuarioRepository.existsByEmail(email.value())) {
            // Usar enum de mensaje de error con parámetro
            String message = messageResolver.resolve(
                ErrorMessage.ERR_USER_EMAIL_ALREADY_EXISTS,
                email.value()
            );
            
            throw new ConflictException(message);
        }
    }
}
```

### Ejemplo 3: En GlobalExceptionHandler

```java
@RestControllerAdvice
@Slf4j
@RequiredArgsConstructor
public class GlobalExceptionHandler {
    
    private final MessageResolver messageResolver;
    
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleResourceNotFound(
        ResourceNotFoundException ex,
        HttpServletRequest request
    ) {
        // Log con código de error para tracking
        log.warn("Resource not found [{}]: {}", 
            ErrorMessage.ERR_GEN_RESOURCE_NOT_FOUND.getCode(),
            ex.getMessage()
        );
        
        ErrorResponse response = ErrorResponse.clientError(
            ex.getMessage(),
            "ResourceNotFoundException",
            404,
            request.getRequestURI()
        );
        
        return ResponseEntity.status(404).body(response);
    }
}
```

### Ejemplo 4: Logging con código de mensaje

```java
@Service
@Slf4j
@RequiredArgsConstructor
public class PagoService {
    
    private final MessageResolver messageResolver;
    
    public void procesarPago(PagoId pagoId) {
        try {
            // lógica de pago...
            
            log.info("Pago procesado exitosamente [{}]: {}", 
                SuccessMessage.PAGO_PROCESSED.getCode(),
                pagoId.value()
            );
            
        } catch (PaymentGatewayException ex) {
            log.error("Error procesando pago [{}]: {}", 
                ErrorMessage.ERR_PAGO_PAYMENT_FAILED.getCode(),
                ex.getMessage()
            );
            
            throw new PaymentException(
                messageResolver.resolve(ErrorMessage.ERR_PAGO_PAYMENT_FAILED)
            );
        }
    }
}
```

---

## ✅ Criterios de Aceptación (Given-When-Then)

### Escenario 1: Resolver mensaje de éxito sin parámetros
```gherkin
Given el enum SuccessMessage.USER_LOGIN_SUCCESS existe
When se invoca messageResolver.resolve(SuccessMessage.USER_LOGIN_SUCCESS)
Then el mensaje retornado es "Inicio de sesión exitoso. Bienvenido"
And el código es "USER_003"
And la categoría es MessageCategory.SUCCESS
```

### Escenario 2: Resolver mensaje con parámetros
```gherkin
Given el enum ErrorMessage.ERR_USER_EMAIL_ALREADY_EXISTS con template
When se invoca messageResolver.resolve(ErrorMessage.ERR_USER_EMAIL_ALREADY_EXISTS, "test@example.com")
Then el mensaje retornado es "El email 'test@example.com' ya está registrado"
And el código es "ERR_USER_001"
And la severidad es MessageSeverity.MEDIUM
```

### Escenario 3: Obtener código para logging
```gherkin
Given un mensaje SuccessMessage.RESERVA_CREATED
When se invoca messageResolver.getCode(SuccessMessage.RESERVA_CREATED)
Then el código retornado es "RESERVA_001"
```

### Escenario 4: Obtener severidad de error
```gherkin
Given un mensaje ErrorMessage.ERR_GEN_INTERNAL_SERVER
When se invoca messageResolver.getSeverity(ErrorMessage.ERR_GEN_INTERNAL_SERVER)
Then la severidad retornada es MessageSeverity.CRITICAL
```

### Escenario 5: Type safety en compilación
```gherkin
Given un controller que usa SuccessMessage
When se intenta usar un código de mensaje no existente
Then el código NO compila (type safety garantizado por enum)
```

---

## 🧪 Tests Unitarios

### 1. MessageResolverTest

```java
@DisplayName("MessageResolver - Resolutor de Mensajes")
class MessageResolverTest {
    
    private MessageResolver messageResolver;
    
    @BeforeEach
    void setUp() {
        messageResolver = new MessageResolver();
    }
    
    @Nested
    @DisplayName("Mensajes de Éxito")
    class SuccessMessageTests {
        
        @Test
        @DisplayName("Debe resolver mensaje de éxito sin parámetros")
        void shouldResolveSuccessMessageWithoutParams() {
            // When
            String message = messageResolver.resolve(SuccessMessage.USER_LOGIN_SUCCESS);
            
            // Then
            assertThat(message).isEqualTo("Inicio de sesión exitoso. Bienvenido");
        }
        
        @Test
        @DisplayName("Debe obtener código de mensaje de éxito")
        void shouldGetSuccessMessageCode() {
            // When
            String code = messageResolver.getCode(SuccessMessage.USER_REGISTERED);
            
            // Then
            assertThat(code).isEqualTo("USER_001");
        }
    }
    
    @Nested
    @DisplayName("Mensajes de Error")
    class ErrorMessageTests {
        
        @Test
        @DisplayName("Debe resolver mensaje de error con parámetros")
        void shouldResolveErrorMessageWithParams() {
            // When
            String message = messageResolver.resolve(
                ErrorMessage.ERR_USER_EMAIL_ALREADY_EXISTS,
                "test@example.com"
            );
            
            // Then
            assertThat(message).isEqualTo("El email 'test@example.com' ya está registrado");
        }
        
        @Test
        @DisplayName("Debe obtener severidad de error")
        void shouldGetErrorSeverity() {
            // When
            MessageSeverity severity = messageResolver.getSeverity(
                ErrorMessage.ERR_GEN_INTERNAL_SERVER
            );
            
            // Then
            assertThat(severity).isEqualTo(MessageSeverity.CRITICAL);
        }
    }
}
```

---

## 📝 Definition of Done

- [ ] Interface `MessageCode` creada con contrato
- [ ] Enums `MessageCategory` y `MessageSeverity` creados
- [ ] Enum `SuccessMessage` implementado con mensajes genéricos + por módulo
- [ ] Enum `ErrorMessage` implementado con códigos de error únicos
- [ ] Clase `MessageResolver` implementada como Spring Component
- [ ] Tests unitarios para MessageResolver (cobertura >90%)
- [ ] Integración con `ApiResponse` y `ErrorResponse`
- [ ] Actualización de GlobalExceptionHandler para usar enums
- [ ] Documentación en Javadoc completa
- [ ] Ejemplo de uso en controller funcional
- [ ] Code review aprobado por Tech Lead
- [ ] Documentación técnica en `docs/message-dictionary.md`

---

## 📚 Convenciones y Estándares

### Nomenclatura de Códigos

| Prefijo | Módulo | Ejemplo |
|---------|--------|---------|
| `GEN_xxx` | Genérico | `GEN_001` |
| `USER_xxx` | Usuarios | `USER_001` |
| `TUTOR_xxx` | Tutores | `TUTOR_001` |
| `RESERVA_xxx` | Reservas | `RESERVA_001` |
| `PAGO_xxx` | Pagos | `PAGO_001` |
| `ERR_GEN_xxx` | Error genérico | `ERR_GEN_001` |
| `ERR_AUTH_xxx` | Error autenticación | `ERR_AUTH_001` |
| `ERR_VAL_xxx` | Error validación | `ERR_VAL_001` |

### Niveles de Severidad

- **LOW:** Errores de validación de entrada, campos faltantes
- **MEDIUM:** Recursos no encontrados, conflictos de negocio
- **HIGH:** Errores de autenticación/autorización
- **CRITICAL:** Errores de sistema, BD, servicios externos

---

## 🔗 Trazabilidad

- **Depende de:** HUT-000-API-01 (Standard Response)
- **Bloquea:** Todas las HUTs de implementación de casos de uso
- **Relacionada con:** HUT-000-API-03 (i18n Messages), HUT-000-LOG-01 (Logging Strategy)

---

**Fecha:** 2025-11-08  
**Autor:** Arquitecto Técnico Senior  
**Versión:** 1.0
