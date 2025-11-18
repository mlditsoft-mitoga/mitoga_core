package com.mitoga.autenticacion.infrastructure.persistence.mapper;

import com.mitoga.autenticacion.domain.entity.PerfilInformacionBasica;
import com.mitoga.autenticacion.domain.valueobject.EstadoPerfil;
import com.mitoga.autenticacion.infrastructure.persistence.entity.PerfilInformacionBasicaEntity;
import org.springframework.stereotype.Component;

/**
 * Mapper: PerfilInformacionBasica (Domain) ↔ PerfilInformacionBasicaEntity (Persistence)
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Component
public class PerfilInformacionBasicaMapper {

    /**
     * Convierte PerfilInformacionBasicaEntity (JPA) → PerfilInformacionBasica (Domain)
     * 
     * @param entity Entidad JPA persistida
     * @return PerfilInformacionBasica del dominio
     */
    public PerfilInformacionBasica toDomain(PerfilInformacionBasicaEntity entity) {
        if (entity == null) {
            return null;
        }

        return PerfilInformacionBasica.reconstituir(
            entity.getId(),
            entity.getFkPkidPerfiles(),
            entity.getFkPkidInformacionBasica(),
            entity.getEsPerfilPrincipal(),
            EstadoPerfil.valueOf(entity.getEstado()),
            entity.getCreationDate(),
            entity.getExpirationDate(),
            entity.getFechaAsignacion(),
            entity.getMetadata()
        );
    }

    /**
     * Convierte PerfilInformacionBasica (Domain) → PerfilInformacionBasicaEntity (JPA)
     * 
     * @param perfilInfo Agregado del dominio
     * @return Entidad JPA para persistencia
     */
    public PerfilInformacionBasicaEntity toEntity(PerfilInformacionBasica perfilInfo) {
        if (perfilInfo == null) {
            return null;
        }

        return new PerfilInformacionBasicaEntity(
            perfilInfo.getId(),
            perfilInfo.getCreationDate(),
            perfilInfo.getExpirationDate(),
            perfilInfo.getFkPkidPerfiles(),
            perfilInfo.getFkPkidInformacionBasica(),
            perfilInfo.isEsPerfilPrincipal(),
            perfilInfo.getEstado().name(),
            perfilInfo.getFechaAsignacion(),
            perfilInfo.getMetadata()
        );
    }
}
