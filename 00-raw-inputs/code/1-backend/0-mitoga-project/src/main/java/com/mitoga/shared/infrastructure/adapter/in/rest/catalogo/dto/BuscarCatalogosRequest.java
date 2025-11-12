package com.mitoga.shared.infrastructure.adapter.in.rest.catalogo.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

/**
 * Request DTO para buscar catálogos por nombre.
 * 
 * @param tipo   Tipo de catálogo (ej: "categorias_tutorias", "pais", "estado")
 * @param nombre Nombre o parte del nombre a buscar (case-insensitive)
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.1.0 - POST-only policy
 */
@Schema(description = "Request para buscar catálogos por nombre")
public record BuscarCatalogosRequest(

        @Schema(description = "Tipo de catálogo", example = "categorias_tutorias", requiredMode = Schema.RequiredMode.REQUIRED) @NotBlank(message = "Tipo de catálogo es obligatorio") String tipo,

        @Schema(description = "Nombre o parte del nombre a buscar (case-insensitive)", example = "álgebra", requiredMode = Schema.RequiredMode.REQUIRED) @NotBlank(message = "Nombre a buscar es obligatorio") String nombre

) {
}
