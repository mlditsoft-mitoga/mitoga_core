package com.mitoga.shared.infrastructure.api.exception;

import com.mitoga.shared.infrastructure.api.message.ErrorMessage;
import com.mitoga.shared.infrastructure.api.message.MessageResolver;
import com.mitoga.shared.infrastructure.api.response.ErrorResponse;
import com.mitoga.shared.infrastructure.api.response.ValidationError;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.NoHandlerFoundException;

import java.util.List;

/**
 * Controlador global de excepciones para todas las APIs REST.
 * Implementa el patrón de manejo centralizado de errores usando
 * {@link RestControllerAdvice}.
 *
 * <p>
 * Este handler captura todas las excepciones lanzadas por los controllers
 * y las transforma en respuestas {@link ErrorResponse} estandarizadas.
 * </p>
 *
 * <p>
 * <strong>Excepciones manejadas:</strong>
 * </p>
 * <ul>
 * <li>Validación de DTOs (400 Bad Request)</li>
 * <li>Recursos no encontrados (404 Not Found)</li>
 * <li>Conflictos de negocio (409 Conflict)</li>
 * <li>Autenticación (401 Unauthorized)</li>
 * <li>Autorización (403 Forbidden)</li>
 * <li>Errores del servidor (500 Internal Server Error)</li>
 * </ul>
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
@RestControllerAdvice
@RequiredArgsConstructor
@Slf4j
public class GlobalExceptionHandler {

    private final MessageResolver messageResolver;

    /**
     * Maneja errores de validación de @Valid en DTOs (Jakarta Bean Validation).
     * Genera respuesta 400 Bad Request con detalles de cada campo inválido.
     *
     * @param ex      Excepción de validación
     * @param request Request HTTP original
     * @return ResponseEntity con ErrorResponse y código 400
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidationException(
            MethodArgumentNotValidException ex,
            HttpServletRequest request) {
        log.warn("Validation error en {}: {} errores detectados",
                request.getRequestURI(),
                ex.getBindingResult().getErrorCount());

        List<ValidationError> details = ex.getBindingResult()
                .getFieldErrors()
                .stream()
                .map(this::mapFieldError)
                .toList();

        String message = messageResolver.resolve(
                ErrorMessage.ERR_VAL_REQUIRED_FIELD,
                ex.getBindingResult().getErrorCount());

        ErrorResponse response = ErrorResponse.validationError(
                message,
                request.getRequestURI(),
                details);

        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(response);
    }

    /**
     * Maneja errores de tipo de argumento incorrecto (ej: String cuando se espera
     * Integer).
     * Genera respuesta 400 Bad Request.
     *
     * @param ex      Excepción de tipo de argumento
     * @param request Request HTTP original
     * @return ResponseEntity con ErrorResponse y código 400
     */
    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<ErrorResponse> handleTypeMismatch(
            MethodArgumentTypeMismatchException ex,
            HttpServletRequest request) {
        log.warn("Type mismatch en {}: parámetro '{}' con valor '{}'",
                request.getRequestURI(),
                ex.getName(),
                ex.getValue());

        String typeName = ex.getRequiredType() != null
                ? ex.getRequiredType().getSimpleName()
                : "válido";

        String message = messageResolver.resolve(
                ErrorMessage.ERR_GEN_INVALID_REQUEST,
                ex.getName(),
                typeName);

        ErrorResponse response = ErrorResponse.clientError(
                message,
                "TypeMismatchException",
                400,
                request.getRequestURI());

        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(response);
    }

    /**
     * Maneja errores de JSON mal formado o ilegible.
     * Genera respuesta 400 Bad Request.
     *
     * @param ex      Excepción de mensaje no legible
     * @param request Request HTTP original
     * @return ResponseEntity con ErrorResponse y código 400
     */
    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ErrorResponse> handleHttpMessageNotReadable(
            HttpMessageNotReadableException ex,
            HttpServletRequest request) {
        log.warn("JSON mal formado en {}: {}", request.getRequestURI(), ex.getMessage());

        String message = messageResolver.resolve(ErrorMessage.ERR_GEN_INVALID_REQUEST);

        ErrorResponse response = ErrorResponse.clientError(
                message,
                "InvalidJsonException",
                400,
                request.getRequestURI());

        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(response);
    }

    /**
     * Maneja excepciones de recurso no encontrado.
     * Genera respuesta 404 Not Found.
     *
     * @param ex      Excepción de recurso no encontrado
     * @param request Request HTTP original
     * @return ResponseEntity con ErrorResponse y código 404
     */
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleResourceNotFound(
            ResourceNotFoundException ex,
            HttpServletRequest request) {
        log.warn("Recurso no encontrado en {}: {}", request.getRequestURI(), ex.getMessage());

        // Usamos el mensaje de la excepción o el mensaje genérico del enum
        String message = ex.getMessage() != null
                ? ex.getMessage()
                : messageResolver.resolve(ErrorMessage.ERR_GEN_RESOURCE_NOT_FOUND);

        ErrorResponse response = ErrorResponse.clientError(
                message,
                "ResourceNotFoundException",
                404,
                request.getRequestURI());

        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(response);
    }

    /**
     * Maneja handler no encontrado (ruta no existente).
     * Genera respuesta 404 Not Found.
     *
     * @param ex      Excepción de handler no encontrado
     * @param request Request HTTP original
     * @return ResponseEntity con ErrorResponse y código 404
     */
    @ExceptionHandler(NoHandlerFoundException.class)
    public ResponseEntity<ErrorResponse> handleNoHandlerFound(
            NoHandlerFoundException ex,
            HttpServletRequest request) {
        log.warn("Endpoint no encontrado: {} {}", ex.getHttpMethod(), ex.getRequestURL());

        String message = messageResolver.resolve(
                ErrorMessage.ERR_GEN_RESOURCE_NOT_FOUND,
                String.format("Endpoint %s %s", ex.getHttpMethod(), ex.getRequestURL()));

        ErrorResponse response = ErrorResponse.clientError(
                message,
                "EndpointNotFoundException",
                404,
                request.getRequestURI());

        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(response);
    }

    /**
     * Maneja excepciones de conflicto de negocio (ej: email duplicado).
     * Genera respuesta 409 Conflict.
     *
     * @param ex      Excepción de conflicto
     * @param request Request HTTP original
     * @return ResponseEntity con ErrorResponse y código 409
     */
    @ExceptionHandler(ConflictException.class)
    public ResponseEntity<ErrorResponse> handleConflict(
            ConflictException ex,
            HttpServletRequest request) {
        log.warn("Conflicto en {}: {}", request.getRequestURI(), ex.getMessage());

        // Usamos el mensaje de la excepción si está disponible
        String message = ex.getMessage() != null
                ? ex.getMessage()
                : messageResolver.resolve(ErrorMessage.ERR_GEN_INVALID_REQUEST);

        ErrorResponse response = ErrorResponse.conflict(
                message,
                request.getRequestURI());

        return ResponseEntity
                .status(HttpStatus.CONFLICT)
                .body(response);
    }

    /**
     * Maneja excepciones de autenticación (ej: JWT inválido).
     * Genera respuesta 401 Unauthorized.
     *
     * @param ex      Excepción de autenticación
     * @param request Request HTTP original
     * @return ResponseEntity con ErrorResponse y código 401
     */
    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<ErrorResponse> handleAuthentication(
            AuthenticationException ex,
            HttpServletRequest request) {
        log.warn("Error de autenticación en {}: {}", request.getRequestURI(), ex.getMessage());

        String message = messageResolver.resolve(ErrorMessage.ERR_AUTH_INVALID_CREDENTIALS);

        ErrorResponse response = ErrorResponse.unauthorized(
                message,
                request.getRequestURI());

        return ResponseEntity
                .status(HttpStatus.UNAUTHORIZED)
                .body(response);
    }

    /**
     * Maneja excepciones de autorización (ej: sin permisos).
     * Genera respuesta 403 Forbidden.
     *
     * @param ex      Excepción de acceso denegado
     * @param request Request HTTP original
     * @return ResponseEntity con ErrorResponse y código 403
     */
    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ErrorResponse> handleAccessDenied(
            AccessDeniedException ex,
            HttpServletRequest request) {
        log.warn("Acceso denegado en {}: {}", request.getRequestURI(), ex.getMessage());

        String message = messageResolver.resolve(ErrorMessage.ERR_AUTH_UNAUTHORIZED);

        ErrorResponse response = ErrorResponse.forbidden(
                message,
                request.getRequestURI());

        return ResponseEntity
                .status(HttpStatus.FORBIDDEN)
                .body(response);
    }

    /**
     * Maneja cualquier otra excepción no capturada (fallback).
     * Genera respuesta 500 Internal Server Error.
     *
     * <p>
     * <strong>IMPORTANTE:</strong> No se exponen detalles técnicos internos
     * en el mensaje al cliente por razones de seguridad. Los detalles se loggean.
     * </p>
     *
     * @param ex      Excepción genérica
     * @param request Request HTTP original
     * @return ResponseEntity con ErrorResponse y código 500
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGenericException(
            Exception ex,
            HttpServletRequest request) {
        log.error("Error interno del servidor en {}: {}",
                request.getRequestURI(),
                ex.getMessage(),
                ex);

        String message = messageResolver.resolve(ErrorMessage.ERR_GEN_INTERNAL_SERVER);

        ErrorResponse response = ErrorResponse.serverError(
                message,
                "InternalServerError",
                500,
                request.getRequestURI());

        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(response);
    }

    /**
     * Mapea un FieldError de Spring a un ValidationError customizado.
     *
     * @param fieldError Error de campo de Spring Validation
     * @return ValidationError customizado
     */
    private ValidationError mapFieldError(FieldError fieldError) {
        return ValidationError.of(
                fieldError.getField(),
                fieldError.getDefaultMessage() != null
                        ? fieldError.getDefaultMessage()
                        : "Valor inválido",
                fieldError.getRejectedValue());
    }
}
