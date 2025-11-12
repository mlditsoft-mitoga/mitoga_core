package com.mitoga.shared.application.catalogo.dto;

import io.swagger.v3.oas.annotations.media.Schema;

import java.util.List;

/**
 * DTO de respuesta para descendientes de un catálogo.
 * 
 * Contiene todos los nodos descendientes (hijos, nietos, bisnietos, etc.)
 * de un nodo padre específico.
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.0.0
 */
@Schema(description = "Respuesta con los descendientes de un catálogo")
public record DescendientesResponse(

        @Schema(description = "Catálogo padre") CatalogoResponse padre,

        @Schema(description = "Lista de descendientes ordenados jerárquicamente") List<CatalogoResponse> descendientes,

        @Schema(description = "Cantidad total de descendientes", example = "12") Integer totalDescendientes,

        @Schema(description = "Profundidad máxima del subárbol", example = "2") Integer profundidadMaxima) {

    /**
     * Construye la respuesta de descendientes.
     */
    public static DescendientesResponse from(CatalogoResponse padre, List<CatalogoResponse> descendientes) {
        int profundidadMaxima = descendientes.stream()
                .mapToInt(d -> d.nivel() - padre.nivel())
                .max()
                .orElse(0);

        return new DescendientesResponse(
                padre,
                descendientes,
                descendientes.size(),
                profundidadMaxima);
    }
}
