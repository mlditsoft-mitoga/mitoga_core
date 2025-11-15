package com.mitoga.autenticacion.infrastructure.web.exception;

import com.mitoga.autenticacion.domain.exception.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * AutenticacionExceptionHandler - Manejo de excepciones de BC Autenticación
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - WEB LAYER - EXCEPTION HANDLER
 * - RestControllerAdvice para excepciones del BC Autenticación
 * - Mapeo de excepciones del dominio a HTTP Status codes apropiados
 * - Formato consistente de respuestas de error
 * 
 * HTTP STATUS CODES:
 * - 400 BAD_REQUEST: Validación fallida, datos inválidos
 * - 401 UNAUTHORIZED: Credenciales inválidas, token expirado
 * - 403 FORBIDDEN: Cuenta bloqueada, email no verificado
 * - 404 NOT_FOUND: Usuario no encontrado, token no encontrado
 * - 409 CONFLICT: Email duplicado
 * - 500 INTERNAL_SERVER_ERROR: Errores inesperados
 */
@RestControllerAdvice(basePackages = "com.mitoga.autenticacion")
public class AutenticacionExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(AutenticacionExceptionHandler.class);

    /**
     * Manejo de excepciones de validación de Jakarta Validation
     * HTTP 400 - BAD REQUEST
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidationException(MethodArgumentNotValidException ex) {
        logger.warn("Errores de validación: {}", ex.getMessage());

        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach(error -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });

        ErrorResponse errorResponse = new ErrorResponse(
                HttpStatus.BAD_REQUEST.value(),
                "Errores de validación",
                LocalDateTime.now(),
                errors);

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorResponse);
    }

    /**
     * Manejo de UsuarioYaExisteException
     * HTTP 409 - CONFLICT
     */
    @ExceptionHandler(UsuarioYaExisteException.class)
    public ResponseEntity<ErrorResponse> handleUsuarioYaExisteException(UsuarioYaExisteException ex) {
        logger.warn("Usuario ya existe: {}", ex.getMessage());

        ErrorResponse errorResponse = new ErrorResponse(
                HttpStatus.CONFLICT.value(),
                ex.getMessage(),
                LocalDateTime.now(),
                null);

        return ResponseEntity.status(HttpStatus.CONFLICT).body(errorResponse);
    }

    /**
     * Manejo de UsuarioNoEncontradoException
     * HTTP 404 - NOT FOUND
     */
    @ExceptionHandler(UsuarioNoEncontradoException.class)
    public ResponseEntity<ErrorResponse> handleUsuarioNoEncontradoException(UsuarioNoEncontradoException ex) {
        logger.warn("Usuario no encontrado: {}", ex.getMessage());

        ErrorResponse errorResponse = new ErrorResponse(
                HttpStatus.NOT_FOUND.value(),
                ex.getMessage(),
                LocalDateTime.now(),
                null);

        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
    }

    /**
     * Manejo de CredencialesInvalidasException
     * HTTP 401 - UNAUTHORIZED
     */
    @ExceptionHandler(CredencialesInvalidasException.class)
    public ResponseEntity<ErrorResponse> handleCredencialesInvalidasException(CredencialesInvalidasException ex) {
        logger.warn("Credenciales inválidas: {}", ex.getMessage());

        ErrorResponse errorResponse = new ErrorResponse(
                HttpStatus.UNAUTHORIZED.value(),
                ex.getMessage(),
                LocalDateTime.now(),
                null);

        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
    }

    /**
     * Manejo de CuentaBloqueadaException
     * HTTP 403 - FORBIDDEN
     */
    @ExceptionHandler(CuentaBloqueadaException.class)
    public ResponseEntity<ErrorResponse> handleCuentaBloqueadaException(CuentaBloqueadaException ex) {
        logger.warn("Cuenta bloqueada: {}", ex.getMessage());

        ErrorResponse errorResponse = new ErrorResponse(
                HttpStatus.FORBIDDEN.value(),
                ex.getMessage(),
                LocalDateTime.now(),
                null);

        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(errorResponse);
    }

    /**
     * Manejo de TokenInvalidoException
     * HTTP 401 - UNAUTHORIZED
     */
    @ExceptionHandler(TokenInvalidoException.class)
    public ResponseEntity<ErrorResponse> handleTokenInvalidoException(TokenInvalidoException ex) {
        logger.warn("Token inválido: {}", ex.getMessage());

        ErrorResponse errorResponse = new ErrorResponse(
                HttpStatus.UNAUTHORIZED.value(),
                ex.getMessage(),
                LocalDateTime.now(),
                null);

        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
    }

    /**
     * Manejo de IllegalArgumentException
     * HTTP 400 - BAD REQUEST
     */
    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ErrorResponse> handleIllegalArgumentException(IllegalArgumentException ex) {
        logger.warn("Argumento ilegal: {}", ex.getMessage());

        ErrorResponse errorResponse = new ErrorResponse(
                HttpStatus.BAD_REQUEST.value(),
                ex.getMessage(),
                LocalDateTime.now(),
                null);

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorResponse);
    }

    /**
     * Manejo de excepciones genéricas
     * HTTP 500 - INTERNAL SERVER ERROR
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGenericException(Exception ex) {
        logger.error("Error interno del servidor: {}", ex.getMessage(), ex);

        ErrorResponse errorResponse = new ErrorResponse(
                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                "Ha ocurrido un error interno. Por favor, intenta nuevamente más tarde.",
                LocalDateTime.now(),
                null);

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
    }

    /**
     * ErrorResponse - DTO para respuestas de error consistentes
     */
    public static class ErrorResponse {
        private int status;
        private String mensaje;
        private LocalDateTime timestamp;
        private Map<String, String> errores;

        public ErrorResponse() {
        }

        public ErrorResponse(int status, String mensaje, LocalDateTime timestamp, Map<String, String> errores) {
            this.status = status;
            this.mensaje = mensaje;
            this.timestamp = timestamp;
            this.errores = errores;
        }

        public int getStatus() {
            return status;
        }

        public void setStatus(int status) {
            this.status = status;
        }

        public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }

        public LocalDateTime getTimestamp() {
            return timestamp;
        }

        public void setTimestamp(LocalDateTime timestamp) {
            this.timestamp = timestamp;
        }

        public Map<String, String> getErrores() {
            return errores;
        }

        public void setErrores(Map<String, String> errores) {
            this.errores = errores;
        }
    }
}
