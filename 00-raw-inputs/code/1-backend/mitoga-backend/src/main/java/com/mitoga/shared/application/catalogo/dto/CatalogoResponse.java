package com.mitoga.shared.application.catalogo.dto;

import io.swagger.v3.oas.annotations.media.Schema;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;

/**
 * DTO de respuesta para un Catálogo.
 * 
 * Representa un nodo del catálogo recursivo para ser consumido por el frontend.
 * Incluye todos los campos necesarios para renderizar dropdowns jerárquicos,
 * breadcrumbs, y árboles de navegación.
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.0.0
 */
@Schema(description = "Respuesta con información de un catálogo")
public record CatalogoResponse(

        @Schema(description = "Identificador único del catálogo", example = "550e8400-e29b-41d4-a716-446655440000") UUID id,

        @Schema(description = "Tipo de catálogo", example = "categorias_tutorias") String tipo,

        @Schema(description = "Identificador del catálogo padre (null si es raíz)", example = "650e8400-e29b-41d4-a716-446655440001", nullable = true) UUID padreId,

        @Schema(description = "Nivel en el árbol (0=raíz, 1=hijo, 2=nieto, etc.)", example = "1") Short nivel,

        @Schema(description = "Path completo desde la raíz (/uuid1/uuid2/uuid3)", example = "/550e8400-e29b-41d4-a716-446655440000/650e8400-e29b-41d4-a716-446655440001") String pathCompleto,

        @Schema(description = "Código único del catálogo dentro del tipo", example = "CAT-MATE-ALG") String codigo,

        @Schema(description = "Nombre del catálogo en español", example = "Álgebra") String nombre,

        @Schema(description = "Nombre del catálogo en inglés", example = "Algebra", nullable = true) String nombreEn,

        @Schema(description = "Descripción del catálogo", example = "Operaciones con variables y ecuaciones", nullable = true) String descripcion,

        @Schema(description = "Descripción del catálogo en inglés", example = "Operations with variables and equations", nullable = true) String descripcionEn,

        @Schema(description = "Orden de presentación (0-9998)", example = "1") Short orden,

        @Schema(description = "Clase CSS del ícono FontAwesome", example = "fa-calculator", nullable = true) String icono,

        @Schema(description = "Color hexadecimal (#RRGGBB)", example = "#3498DB", nullable = true) String color,

        @Schema(description = "Indica si el catálogo está activo", example = "true") Boolean activo,

        @Schema(description = "Indica si el catálogo es seleccionable en UI", example = "true") Boolean seleccionable,

        @Schema(description = "Indica si el catálogo tiene nodos hijos", example = "true") Boolean tieneHijos,

        @Schema(description = "Metadatos adicionales en formato JSON", example = "{\"dificultad\": \"basico\", \"tiempo_promedio\": \"45min\"}", nullable = true) Map<String, Object> metadatos,

        @Schema(description = "Fecha de creación", example = "2025-11-12T10:30:00") LocalDateTime creationDate,

        @Schema(description = "Fecha de expiración (null=activo)", example = "null", nullable = true) LocalDateTime expirationDate) {

    /**
     * Constructor para nodos sin metadatos.
     */
    public CatalogoResponse(UUID id, String tipo, UUID padreId, Short nivel, String pathCompleto,
            String codigo, String nombre, String nombreEn, String descripcion, String descripcionEn,
            Short orden, String icono, String color, Boolean activo, Boolean seleccionable,
            Boolean tieneHijos, LocalDateTime creationDate, LocalDateTime expirationDate) {
        this(id, tipo, padreId, nivel, pathCompleto, codigo, nombre, nombreEn, descripcion, descripcionEn,
                orden, icono, color, activo, seleccionable, tieneHijos, null, creationDate, expirationDate);
    }
}
