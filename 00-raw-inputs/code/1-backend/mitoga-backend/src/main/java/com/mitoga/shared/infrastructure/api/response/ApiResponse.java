package com.mitoga.shared.infrastructure.api.response;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.mitoga.shared.infrastructure.api.message.SuccessMessage;
import io.swagger.v3.oas.annotations.media.Schema;

/**
 * Respuesta estándar para operaciones exitosas de la API REST.
 * Basado en JSend specification (https://github.com/omniti-labs/jsend)
 * y mejores prácticas de diseño de APIs RESTful.
 *
 * <p>
 * Esta clase implementa el patrón de respuesta unificada para garantizar
 * consistencia en todas las respuestas HTTP exitosas del backend.
 * </p>
 *
 * @param <T> Tipo del payload de datos (puede ser cualquier objeto
 *            serializable)
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
@Schema(description = "Respuesta estándar de la API para operaciones exitosas")
@JsonInclude(JsonInclude.Include.NON_NULL)
public record ApiResponse<T>(

        @Schema(description = "Estado de la operación", example = "success", allowableValues = {
                "success" }) String status,

        @Schema(description = "Mensaje descriptivo de la operación", example = "Usuario creado exitosamente") String message,

        @Schema(description = "Datos de respuesta (payload)") T data,

        @Schema(description = "Metadatos adicionales (paginación, versión, etc.)") Meta meta,

        @Schema(description = "Timestamp Unix en milisegundos", example = "1699468800000") Long timestamp){

    /**
     * Constructor compacto con validaciones de invariantes.
     * Garantiza que el status sea "success" y el timestamp sea válido.
     */
    public ApiResponse {
        if (status == null || !status.equals("success")) {
            throw new IllegalArgumentException("Status debe ser 'success' para ApiResponse");
        }
        if (timestamp == null || timestamp <= 0) {
            throw new IllegalArgumentException("Timestamp debe ser un valor positivo");
        }
    }

    /**
     * Factory method para crear respuesta exitosa con datos y mensaje
     * personalizado.
     *
     * @param data    Payload de datos
     * @param message Mensaje descriptivo
     * @param <T>     Tipo del payload
     * @return Nueva instancia de ApiResponse
     */
    public static <T> ApiResponse<T> success(T data, String message) {
        return new ApiResponse<>(
                "success",
                message,
                data,
                null,
                System.currentTimeMillis());
    }

    /**
     * Factory method para crear respuesta exitosa con datos y mensaje por defecto.
     *
     * @param data Payload de datos
     * @param <T>  Tipo del payload
     * @return Nueva instancia de ApiResponse
     */
    public static <T> ApiResponse<T> success(T data) {
        return success(data, "Operación exitosa");
    }

    /**
     * Factory method para crear respuesta exitosa sin datos (ej: DELETE).
     *
     * @param message Mensaje descriptivo
     * @param <T>     Tipo del payload
     * @return Nueva instancia de ApiResponse con data = null
     */
    public static <T> ApiResponse<T> successNoContent(String message) {
        return new ApiResponse<>(
                "success",
                message,
                null,
                null,
                System.currentTimeMillis());
    }

    /**
     * Factory method para crear respuesta exitosa con datos y metadata
     * (paginación).
     *
     * @param data    Payload de datos
     * @param message Mensaje descriptivo
     * @param meta    Metadatos (paginación, versión, etc.)
     * @param <T>     Tipo del payload
     * @return Nueva instancia de ApiResponse con metadata
     */
    public static <T> ApiResponse<T> successWithMeta(T data, String message, Meta meta) {
        return new ApiResponse<>(
                "success",
                message,
                data,
                meta,
                System.currentTimeMillis());
    }

    // ========== MÉTODOS CON SOPORTE PARA SuccessMessage ENUM ==========

    /**
     * Factory method para crear respuesta exitosa usando SuccessMessage enum.
     *
     * @param data           Payload de datos
     * @param successMessage Enum SuccessMessage con mensaje predefinido
     * @param <T>            Tipo del payload
     * @return Nueva instancia de ApiResponse
     */
    public static <T> ApiResponse<T> success(T data, SuccessMessage successMessage) {
        return success(data, successMessage.getMessage());
    }

    /**
     * Factory method para crear respuesta exitosa sin datos usando SuccessMessage
     * enum.
     *
     * @param successMessage Enum SuccessMessage con mensaje predefinido
     * @param <T>            Tipo del payload
     * @return Nueva instancia de ApiResponse con data = null
     */
    public static <T> ApiResponse<T> successNoContent(SuccessMessage successMessage) {
        return successNoContent(successMessage.getMessage());
    }

    /**
     * Factory method para crear respuesta exitosa con datos y metadata usando
     * SuccessMessage enum.
     *
     * @param data           Payload de datos
     * @param successMessage Enum SuccessMessage con mensaje predefinido
     * @param meta           Metadatos (paginación, versión, etc.)
     * @param <T>            Tipo del payload
     * @return Nueva instancia de ApiResponse con metadata
     */
    public static <T> ApiResponse<T> successWithMeta(T data, SuccessMessage successMessage, Meta meta) {
        return successWithMeta(data, successMessage.getMessage(), meta);
    }
}
