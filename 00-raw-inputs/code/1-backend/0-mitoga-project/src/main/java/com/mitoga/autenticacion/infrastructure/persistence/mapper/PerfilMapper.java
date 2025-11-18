package com.mitoga.autenticacion.infrastructure.persistence.mapper;

import com.mitoga.autenticacion.domain.entity.Perfil;
import com.mitoga.autenticacion.infrastructure.persistence.entity.PerfilEntity;
import org.springframework.stereotype.Component;

/**
 * Mapper: Perfil (Domain) ↔ PerfilEntity (Persistence)
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Component
public class PerfilMapper {

    /**
     * Convierte PerfilEntity (JPA) → Perfil (Domain)
     * 
     * @param entity Entidad JPA persistida
     * @return Perfil del dominio
     */
    public Perfil toDomain(PerfilEntity entity) {
        if (entity == null) {
            return null;
        }

        return Perfil.reconstituir(
            entity.getId(),
            entity.getCodigo(),
            entity.getNombre(),
            entity.getDescripcion(),
            entity.getCreationDate(),
            entity.getExpirationDate()
        );
    }

    /**
     * Convierte Perfil (Domain) → PerfilEntity (JPA)
     * 
     * @param perfil Agregado del dominio
     * @return Entidad JPA para persistencia
     */
    public PerfilEntity toEntity(Perfil perfil) {
        if (perfil == null) {
            return null;
        }

        return new PerfilEntity(
            perfil.getId(),
            perfil.getCreationDate(),
            perfil.getExpirationDate(),
            perfil.getCodigo(),
            perfil.getNombre(),
            perfil.getDescripcion()
        );
    }
}
