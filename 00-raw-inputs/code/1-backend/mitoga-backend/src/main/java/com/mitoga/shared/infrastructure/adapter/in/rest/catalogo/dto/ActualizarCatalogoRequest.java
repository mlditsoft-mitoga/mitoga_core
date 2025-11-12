package com.mitoga.shared.infrastructure.adapter.in.rest.catalogo.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.*;

import java.util.Map;
import java.util.UUID;

/**
 * DTO para solicitud de actualización de catálogo.
 *
 * @author Backend Team - MI-TOGA
 * @since 1.1.0
 */
@Schema(description = "Request para actualizar un catálogo existente")
public record ActualizarCatalogoRequest(

        @Schema(description = "ID del catálogo a actualizar", example = "550e8400-e29b-41d4-a716-446655440000", required = true)
        @NotNull(message = "El ID del catálogo es obligatorio")
        UUID catalogoId,

        @Schema(description = "ID del catálogo padre (null para nodos raíz)", example = "550e8400-e29b-41d4-a716-446655440000")
        UUID padreId,

        @Schema(description = "Código único del catálogo", example = "CO")
        @Size(max = 50, message = "El código no puede exceder 50 caracteres")
        @Pattern(regexp = "^[A-Z0-9_-]+$", message = "El código solo puede contener letras mayúsculas, números, guiones y guiones bajos")
        String codigo,

        @Schema(description = "Nombre del catálogo en español", example = "Colombia")
        @Size(max = 200, message = "El nombre no puede exceder 200 caracteres")
        String nombre,

        @Schema(description = "Nombre del catálogo en inglés", example = "Colombia")
        @Size(max = 200, message = "El nombre en inglés no puede exceder 200 caracteres")
        String nombreEn,

        @Schema(description = "Descripción del catálogo", example = "República de Colombia")
        @Size(max = 500, message = "La descripción no puede exceder 500 caracteres")
        String descripcion,

        @Schema(description = "Descripción en inglés", example = "Republic of Colombia")
        @Size(max = 500, message = "La descripción en inglés no puede exceder 500 caracteres")
        String descripcionEn,

        @Schema(description = "Orden de visualización", example = "1")
        @Min(value = 0, message = "El orden debe ser mayor o igual a 0")
        @Max(value = 9998, message = "El orden no puede exceder 9998")
        Short orden,

        @Schema(description = "Icono Font Awesome", example = "fa-flag")
        @Size(max = 50, message = "El icono no puede exceder 50 caracteres")
        String icono,

        @Schema(description = "Color hexadecimal", example = "#FFD700")
        @Pattern(regexp = "^#[0-9A-Fa-f]{6}$", message = "El color debe estar en formato hexadecimal (#RRGGBB)")
        String color,

        @Schema(description = "Indica si el catálogo está activo", example = "true")
        Boolean activo,

        @Schema(description = "Indica si el catálogo es seleccionable por el usuario", example = "true")
        Boolean seleccionable,

        @Schema(description = "Metadatos adicionales en formato JSON", example = "{\"iso2\": \"CO\", \"iso3\": \"COL\"}")
        Map<String, Object> metadatos
) {
}
