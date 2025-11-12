package com.mitoga.shared.infrastructure.adapter.in.rest.catalogo.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

/**
 * Request DTO para obtener ancestros (breadcrumb) de un catálogo.
 * 
 * @param catalogoId    ID del catálogo (UUID)
 * @param incluirPropio Incluir el nodo propio en la lista de ancestros
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.1.0 - POST-only policy
 */
@Schema(description = "Request para obtener ancestros (breadcrumb) de un catálogo")
public record ObtenerAncestrosRequest(

        @Schema(description = "ID del catálogo (UUID)", example = "550e8400-e29b-41d4-a716-446655440000", requiredMode = Schema.RequiredMode.REQUIRED) @NotBlank(message = "ID del catálogo es obligatorio") String catalogoId,

        @Schema(description = "Incluir el nodo propio en la lista", example = "true", defaultValue = "true") @NotNull(message = "incluirPropio es obligatorio") Boolean incluirPropio

) {
    /**
     * Constructor compacto con valores por defecto.
     */
    public ObtenerAncestrosRequest {
        if (incluirPropio == null) {
            incluirPropio = true;
        }
    }
}
