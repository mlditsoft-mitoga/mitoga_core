package com.mitoga.shared.infrastructure.api.response;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.v3.oas.annotations.media.Schema;

/**
 * Metadatos adicionales para respuestas de la API.
 * Incluye información de paginación, versión de API, y otros metadatos
 * contextuales.
 *
 * <p>
 * Esta clase se utiliza en combinación con {@link ApiResponse} para
 * proporcionar
 * información adicional sobre la respuesta, especialmente en operaciones
 * paginadas.
 * </p>
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
@Schema(description = "Metadatos adicionales de la respuesta (paginación, versión, etc.)")
@JsonInclude(JsonInclude.Include.NON_NULL)
public record Meta(

        @Schema(description = "Número de página actual (0-indexed)", example = "0") Integer page,

        @Schema(description = "Tamaño de página (elementos por página)", example = "10") Integer pageSize,

        @Schema(description = "Total de elementos en todas las páginas", example = "45") Long totalElements,

        @Schema(description = "Total de páginas disponibles", example = "5") Integer totalPages,

        @Schema(description = "Versión de la API", example = "v1") String version) {

    /**
     * Constructor compacto con validaciones de invariantes.
     * Garantiza que los valores de paginación sean consistentes.
     */
    public Meta {
        if (page != null && page < 0) {
            throw new IllegalArgumentException("Page debe ser >= 0");
        }
        if (pageSize != null && pageSize <= 0) {
            throw new IllegalArgumentException("PageSize debe ser > 0");
        }
        if (totalElements != null && totalElements < 0) {
            throw new IllegalArgumentException("TotalElements debe ser >= 0");
        }
        if (totalPages != null && totalPages < 0) {
            throw new IllegalArgumentException("TotalPages debe ser >= 0");
        }
    }

    /**
     * Factory method para crear metadatos de paginación.
     *
     * @param page          Número de página actual (0-indexed)
     * @param pageSize      Tamaño de página
     * @param totalElements Total de elementos
     * @param totalPages    Total de páginas
     * @return Nueva instancia de Meta con información de paginación
     */
    public static Meta pagination(Integer page, Integer pageSize, Long totalElements, Integer totalPages) {
        return new Meta(page, pageSize, totalElements, totalPages, "v1");
    }

    /**
     * Factory method para crear metadatos con versión de API únicamente.
     *
     * @param version Versión de la API (ej: "v1", "v2")
     * @return Nueva instancia de Meta solo con versión
     */
    public static Meta version(String version) {
        return new Meta(null, null, null, null, version);
    }
}
