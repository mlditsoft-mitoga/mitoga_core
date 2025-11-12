package com.mitoga.shared.application.catalogo.dto;

import io.swagger.v3.oas.annotations.media.Schema;

import java.util.List;

/**
 * DTO de respuesta para el árbol completo de un tipo de catálogo.
 * 
 * Contiene todos los nodos ordenados jerárquicamente (DFS pre-order)
 * listos para construir un dropdown jerárquico o un árbol de navegación.
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.0.0
 */
@Schema(description = "Respuesta con el árbol completo de un tipo de catálogo")
public record ArbolCatalogoResponse(

        @Schema(description = "Tipo de catálogo", example = "categorias_tutorias") String tipo,

        @Schema(description = "Lista de catálogos ordenados jerárquicamente") List<CatalogoResponse> nodos,

        @Schema(description = "Cantidad total de nodos en el árbol", example = "45") Integer totalNodos,

        @Schema(description = "Cantidad de nodos raíz (nivel 0)", example = "5") Integer nodosRaiz,

        @Schema(description = "Profundidad máxima del árbol", example = "3") Integer profundidadMaxima) {

    /**
     * Calcula estadísticas del árbol.
     */
    public static ArbolCatalogoResponse from(String tipo, List<CatalogoResponse> nodos) {
        int totalNodos = nodos.size();
        long nodosRaiz = nodos.stream().filter(n -> n.nivel() == 0).count();
        int profundidadMaxima = nodos.stream()
                .mapToInt(CatalogoResponse::nivel)
                .max()
                .orElse(0);

        return new ArbolCatalogoResponse(
                tipo,
                nodos,
                totalNodos,
                (int) nodosRaiz,
                profundidadMaxima);
    }
}
