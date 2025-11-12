package com.mitoga.shared.infrastructure.adapter.in.rest.catalogo.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

/**
 * Request DTO para obtener árbol completo de catálogos.
 * 
 * @param tipo               Tipo de catálogo (ej: "categorias_tutorias",
 *                           "pais", "estado")
 * @param soloActivos        Filtrar solo catálogos activos
 * @param soloSeleccionables Filtrar solo catálogos seleccionables
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.1.0 - POST-only policy
 */
@Schema(description = "Request para obtener árbol completo de catálogos")
public record ObtenerArbolRequest(

        @Schema(description = "Tipo de catálogo", example = "categorias_tutorias", requiredMode = Schema.RequiredMode.REQUIRED) @NotBlank(message = "Tipo de catálogo es obligatorio") String tipo,

        @Schema(description = "Filtrar solo catálogos activos", example = "true", defaultValue = "true") @NotNull(message = "soloActivos es obligatorio") Boolean soloActivos,

        @Schema(description = "Filtrar solo catálogos seleccionables", example = "false", defaultValue = "false") @NotNull(message = "soloSeleccionables es obligatorio") Boolean soloSeleccionables

) {
    /**
     * Constructor compacto con valores por defecto.
     */
    public ObtenerArbolRequest {
        if (soloActivos == null) {
            soloActivos = true;
        }
        if (soloSeleccionables == null) {
            soloSeleccionables = false;
        }
    }
}
