package com.mitoga.shared.infrastructure.api.response;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.v3.oas.annotations.media.Schema;

/**
 * Detalle de un error de validación específico.
 * Se utiliza en {@link ErrorResponse} para proporcionar información
 * granular sobre errores de validación de campos.
 *
 * <p>
 * Ejemplo de uso en respuesta 400 Bad Request con múltiples
 * errores de validación en diferentes campos.
 * </p>
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
@Schema(description = "Detalle de error de validación de un campo específico")
@JsonInclude(JsonInclude.Include.NON_NULL)
public record ValidationError(

        @Schema(description = "Nombre del campo con error", example = "email") String field,

        @Schema(description = "Mensaje de error descriptivo", example = "El email debe tener formato válido") String message,

        @Schema(description = "Valor rechazado (opcional)", example = "email-invalido") Object rejectedValue) {

    /**
     * Constructor compacto con validaciones de invariantes.
     * Garantiza que field y message sean no nulos.
     */
    public ValidationError {
        if (field == null || field.isBlank()) {
            throw new IllegalArgumentException("Field no puede ser nulo o vacío");
        }
        if (message == null || message.isBlank()) {
            throw new IllegalArgumentException("Message no puede ser nulo o vacío");
        }
    }

    /**
     * Factory method para crear error de validación sin valor rechazado.
     *
     * @param field   Nombre del campo
     * @param message Mensaje de error
     * @return Nueva instancia de ValidationError
     */
    public static ValidationError of(String field, String message) {
        return new ValidationError(field, message, null);
    }

    /**
     * Factory method para crear error de validación con valor rechazado.
     *
     * @param field         Nombre del campo
     * @param message       Mensaje de error
     * @param rejectedValue Valor que fue rechazado
     * @return Nueva instancia de ValidationError
     */
    public static ValidationError of(String field, String message, Object rejectedValue) {
        return new ValidationError(field, message, rejectedValue);
    }
}
