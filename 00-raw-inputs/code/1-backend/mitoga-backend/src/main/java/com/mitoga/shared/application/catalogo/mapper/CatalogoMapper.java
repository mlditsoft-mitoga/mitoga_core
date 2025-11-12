package com.mitoga.shared.application.catalogo.mapper;

import com.mitoga.shared.application.catalogo.dto.CatalogoResponse;
import com.mitoga.shared.domain.catalogo.Catalogo;
import org.springframework.stereotype.Component;

/**
 * Mapper para convertir entre entidades de dominio Catalogo y DTOs.
 * 
 * Siguiendo Hexagonal Architecture: El mapper está en la capa de Application
 * para transformar objetos de dominio en objetos de presentación (DTOs).
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.0.0
 */
@Component
public class CatalogoMapper {

    /**
     * Convierte un Catalogo (domain) a CatalogoResponse (DTO).
     * 
     * @param catalogo entidad de dominio
     * @return DTO para respuesta API
     */
    public CatalogoResponse toResponse(Catalogo catalogo) {
        if (catalogo == null) {
            return null;
        }

        return new CatalogoResponse(
                catalogo.getId().value(),
                catalogo.getTipo().value(),
                catalogo.getPadreId() != null ? catalogo.getPadreId().value() : null,
                catalogo.getNivel(),
                catalogo.getPathCompleto(),
                catalogo.getCodigo(),
                catalogo.getNombre(),
                catalogo.getNombreEn(),
                catalogo.getDescripcion(),
                catalogo.getDescripcionEn(),
                catalogo.getOrden(),
                catalogo.getIcono(),
                catalogo.getColor(),
                catalogo.getActivo(),
                catalogo.getSeleccionable(),
                catalogo.getTieneHijos(),
                catalogo.getMetadatos(),
                catalogo.getCreationDate(),
                catalogo.getExpirationDate());
    }
}
