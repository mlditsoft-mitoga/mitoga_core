package com.mitoga.shared.infrastructure.adapter.in.rest.catalogo.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;

import java.util.UUID;

/**
 * DTO para solicitud de obtener un catálogo por ID.
 *
 * @author Backend Team - MI-TOGA
 * @since 1.1.0
 */
@Schema(description = "Request para obtener un catálogo por su ID")
public record ObtenerCatalogoPorIdRequest(

        @Schema(description = "ID del catálogo a obtener", example = "550e8400-e29b-41d4-a716-446655440000", required = true) @NotNull(message = "El ID del catálogo es obligatorio") UUID catalogoId) {
}
