package com.mitoga.shared.infrastructure.adapter.in.rest.catalogo.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;

import java.util.UUID;

/**
 * DTO para solicitud de eliminación de catálogo.
 *
 * @author Backend Team - MI-TOGA
 * @since 1.1.0
 */
@Schema(description = "Request para eliminar un catálogo (soft delete)")
public record EliminarCatalogoRequest(

        @Schema(description = "ID del catálogo a eliminar", example = "550e8400-e29b-41d4-a716-446655440000", required = true) @NotNull(message = "El ID del catálogo es obligatorio") UUID catalogoId,

        @Schema(description = "Indica si se deben eliminar también los descendientes (cascada)", example = "false", defaultValue = "false") Boolean eliminarDescendientes) {
    public EliminarCatalogoRequest {
        // Default value for eliminarDescendientes
        if (eliminarDescendientes == null) {
            eliminarDescendientes = false;
        }
    }
}
