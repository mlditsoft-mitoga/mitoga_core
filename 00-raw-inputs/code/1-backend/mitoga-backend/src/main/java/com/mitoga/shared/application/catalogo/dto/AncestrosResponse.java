package com.mitoga.shared.application.catalogo.dto;

import io.swagger.v3.oas.annotations.media.Schema;

import java.util.List;

/**
 * DTO de respuesta para ruta de breadcrumb (ancestros).
 * 
 * Contiene la ruta completa desde la raíz hasta un nodo específico,
 * útil para construir breadcrumbs de navegación.
 * 
 * Ejemplo: Colombia → Cundinamarca → Bogotá D.C.
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.0.0
 */
@Schema(description = "Respuesta con la ruta de ancestros (breadcrumb) de un catálogo")
public record AncestrosResponse(

        @Schema(description = "Lista de ancestros ordenados desde raíz hasta hijo") List<CatalogoResponse> ancestros,

        @Schema(description = "Cantidad de niveles en la ruta", example = "3") Integer profundidad,

        @Schema(description = "Ruta legible (nombres separados por →)", example = "Colombia → Cundinamarca → Bogotá D.C.") String rutaLegible) {

    /**
     * Construye la respuesta de ancestros.
     */
    public static AncestrosResponse from(List<CatalogoResponse> ancestros) {
        String rutaLegible = ancestros.stream()
                .map(CatalogoResponse::nombre)
                .reduce((a, b) -> a + " → " + b)
                .orElse("");

        return new AncestrosResponse(
                ancestros,
                ancestros.size(),
                rutaLegible);
    }
}
