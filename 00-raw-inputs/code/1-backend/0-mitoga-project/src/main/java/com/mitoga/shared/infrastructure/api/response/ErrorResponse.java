package com.mitoga.shared.infrastructure.api.response;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.mitoga.shared.infrastructure.api.message.ErrorMessage;
import io.swagger.v3.oas.annotations.media.Schema;

import java.util.List;

/**
 * Respuesta estándar para errores de la API REST.
 * Compatible con RFC 7807 - Problem Details for HTTP APIs
 * (https://tools.ietf.org/html/rfc7807)
 *
 * <p>
 * Esta clase implementa el patrón de respuesta de error unificada para
 * garantizar consistencia en el manejo de errores HTTP del backend.
 * </p>
 *
 * <p>
 * <strong>Status values:</strong>
 * </p>
 * <ul>
 * <li><code>fail</code>: Error del cliente (4xx) - datos inválidos, recurso no
 * encontrado, etc.</li>
 * <li><code>error</code>: Error del servidor (5xx) - error interno, servicio no
 * disponible, etc.</li>
 * </ul>
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
@Schema(description = "Respuesta estándar de la API para errores (4xx/5xx)")
@JsonInclude(JsonInclude.Include.NON_NULL)
public record ErrorResponse(

        @Schema(description = "Estado de la operación", example = "fail", allowableValues = {
                "fail", "error" }) String status,

        @Schema(description = "Mensaje descriptivo para el usuario", example = "El email ya está registrado") String message,

        @Schema(description = "Tipo de error técnico", example = "ValidationException") String error,

        @Schema(description = "Código de estado HTTP", example = "400") Integer code,

        @Schema(description = "URI donde ocurrió el error", example = "/api/v1/usuarios/registro") String path,

        @Schema(description = "Timestamp Unix en milisegundos", example = "1699468800000") Long timestamp,

        @Schema(description = "Detalles de errores de validación (opcional)") List<ValidationError> details){

    /**
     * Constructor compacto con validaciones de invariantes.
     * Garantiza que el status y código HTTP sean válidos.
     */
    public ErrorResponse {
        if (status == null || (!status.equals("fail") && !status.equals("error"))) {
            throw new IllegalArgumentException("Status debe ser 'fail' o 'error'");
        }
        if (code == null || code < 400 || code >= 600) {
            throw new IllegalArgumentException("Code debe estar entre 400 y 599");
        }
        if (timestamp == null || timestamp <= 0) {
            throw new IllegalArgumentException("Timestamp debe ser un valor positivo");
        }
    }

    /**
     * Factory method para errores del cliente (4xx).
     *
     * @param message Mensaje descriptivo para el usuario
     * @param error   Tipo de error técnico
     * @param code    Código HTTP (400-499)
     * @param path    URI donde ocurrió el error
     * @return Nueva instancia de ErrorResponse con status "fail"
     */
    public static ErrorResponse clientError(String message, String error, int code, String path) {
        return new ErrorResponse(
                "fail",
                message,
                error,
                code,
                path,
                System.currentTimeMillis(),
                null);
    }

    /**
     * Factory method para errores del servidor (5xx).
     *
     * @param message Mensaje descriptivo para el usuario
     * @param error   Tipo de error técnico
     * @param code    Código HTTP (500-599)
     * @param path    URI donde ocurrió el error
     * @return Nueva instancia de ErrorResponse con status "error"
     */
    public static ErrorResponse serverError(String message, String error, int code, String path) {
        return new ErrorResponse(
                "error",
                message,
                error,
                code,
                path,
                System.currentTimeMillis(),
                null);
    }

    /**
     * Factory method para errores de validación con detalles (400 Bad Request).
     *
     * @param message Mensaje descriptivo general
     * @param path    URI donde ocurrió el error
     * @param details Lista de errores de validación específicos
     * @return Nueva instancia de ErrorResponse con detalles de validación
     */
    public static ErrorResponse validationError(String message, String path, List<ValidationError> details) {
        return new ErrorResponse(
                "fail",
                message,
                "ValidationException",
                400,
                path,
                System.currentTimeMillis(),
                details);
    }

    /**
     * Factory method para recurso no encontrado (404 Not Found).
     *
     * @param resourceType Tipo de recurso buscado
     * @param identifier   Identificador del recurso
     * @param path         URI donde ocurrió el error
     * @return Nueva instancia de ErrorResponse para 404
     */
    public static ErrorResponse notFound(String resourceType, String identifier, String path) {
        String message = String.format("%s no encontrado con ID: %s", resourceType, identifier);
        return clientError(message, "ResourceNotFoundException", 404, path);
    }

    /**
     * Factory method para conflicto (409 Conflict).
     *
     * @param message Mensaje descriptivo del conflicto
     * @param path    URI donde ocurrió el error
     * @return Nueva instancia de ErrorResponse para 409
     */
    public static ErrorResponse conflict(String message, String path) {
        return clientError(message, "ConflictException", 409, path);
    }

    /**
     * Factory method para no autorizado (401 Unauthorized).
     *
     * @param message Mensaje descriptivo
     * @param path    URI donde ocurrió el error
     * @return Nueva instancia de ErrorResponse para 401
     */
    public static ErrorResponse unauthorized(String message, String path) {
        return clientError(message, "UnauthorizedException", 401, path);
    }

    /**
     * Factory method para prohibido (403 Forbidden).
     *
     * @param message Mensaje descriptivo
     * @param path    URI donde ocurrió el error
     * @return Nueva instancia de ErrorResponse para 403
     */
    public static ErrorResponse forbidden(String message, String path) {
        return clientError(message, "ForbiddenException", 403, path);
    }

    // ========== MÉTODOS CON SOPORTE PARA ErrorMessage ENUM ==========

    /**
     * Factory method para errores del cliente usando ErrorMessage enum.
     *
     * @param errorMessage Enum ErrorMessage con mensaje predefinido
     * @param code         Código HTTP (400-499)
     * @param path         URI donde ocurrió el error
     * @return Nueva instancia de ErrorResponse con status "fail"
     */
    public static ErrorResponse clientError(ErrorMessage errorMessage, int code, String path) {
        return clientError(
                errorMessage.getMessage(),
                errorMessage.getCode(),
                code,
                path);
    }

    /**
     * Factory method para errores del servidor usando ErrorMessage enum.
     *
     * @param errorMessage Enum ErrorMessage con mensaje predefinido
     * @param code         Código HTTP (500-599)
     * @param path         URI donde ocurrió el error
     * @return Nueva instancia de ErrorResponse con status "error"
     */
    public static ErrorResponse serverError(ErrorMessage errorMessage, int code, String path) {
        return serverError(
                errorMessage.getMessage(),
                errorMessage.getCode(),
                code,
                path);
    }

    /**
     * Factory method para conflicto usando ErrorMessage enum.
     *
     * @param errorMessage Enum ErrorMessage con mensaje predefinido
     * @param path         URI donde ocurrió el error
     * @return Nueva instancia de ErrorResponse para 409
     */
    public static ErrorResponse conflict(ErrorMessage errorMessage, String path) {
        return clientError(errorMessage, 409, path);
    }

    /**
     * Factory method para no autorizado usando ErrorMessage enum.
     *
     * @param errorMessage Enum ErrorMessage con mensaje predefinido
     * @param path         URI donde ocurrió el error
     * @return Nueva instancia de ErrorResponse para 401
     */
    public static ErrorResponse unauthorized(ErrorMessage errorMessage, String path) {
        return clientError(errorMessage, 401, path);
    }

    /**
     * Factory method para prohibido usando ErrorMessage enum.
     *
     * @param errorMessage Enum ErrorMessage con mensaje predefinido
     * @param path         URI donde ocurrió el error
     * @return Nueva instancia de ErrorResponse para 403
     */
    public static ErrorResponse forbidden(ErrorMessage errorMessage, String path) {
        return clientError(errorMessage, 403, path);
    }

    /**
     * Factory method para recurso no encontrado usando ErrorMessage enum.
     *
     * @param errorMessage Enum ErrorMessage con mensaje predefinido
     * @param path         URI donde ocurrió el error
     * @return Nueva instancia de ErrorResponse para 404
     */
    public static ErrorResponse notFound(ErrorMessage errorMessage, String path) {
        return clientError(errorMessage, 404, path);
    }
}
