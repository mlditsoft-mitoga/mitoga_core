package com.mitoga.shared.infrastructure.adapter.in.rest.catalogo.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

/**
 * Request DTO para obtener descendientes (subárbol) de un catálogo.
 * 
 * @param catalogoId    ID del catálogo padre (UUID)
 * @param incluirPropio Incluir el nodo padre en la lista de descendientes
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.1.0 - POST-only policy
 */
@Schema(description = "Request para obtener descendientes (subárbol) de un catálogo")
public record ObtenerDescendientesRequest(

        @Schema(description = "ID del catálogo padre (UUID)", example = "550e8400-e29b-41d4-a716-446655440000", requiredMode = Schema.RequiredMode.REQUIRED) @NotBlank(message = "ID del catálogo es obligatorio") String catalogoId,

        @Schema(description = "Incluir el nodo padre en la lista", example = "false", defaultValue = "false") @NotNull(message = "incluirPropio es obligatorio") Boolean incluirPropio

) {
    /**
     * Constructor compacto con valores por defecto.
     */
    public ObtenerDescendientesRequest {
        if (incluirPropio == null) {
            incluirPropio = false;
        }
    }
}
