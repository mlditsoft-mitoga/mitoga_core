package com.mitoga.autenticacion.infrastructure.persistence.mapper;

import com.mitoga.autenticacion.domain.entity.InformacionBasica;
import com.mitoga.autenticacion.infrastructure.persistence.entity.InformacionBasicaEntity;
import org.springframework.stereotype.Component;

/**
 * Mapper: InformacionBasica Domain <-> Entity
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Component
public class InformacionBasicaMapper {

    /**
     * Convertir Entity JPA → Domain
     */
    public InformacionBasica toDomain(InformacionBasicaEntity entity) {
        if (entity == null) {
            return null;
        }

        return InformacionBasica.reconstituir(
                entity.getId(),
                entity.getPrimerNombre(),
                entity.getSegundoNombre(),
                entity.getPrimerApellido(),
                entity.getSegundoApellido(),
                entity.getFkPkidCatalogoTipoDocumento(),
                entity.getNumeroIdentificacion(),
                entity.getEmail(),
                entity.getTelefono(),
                entity.getFechaNacimiento(),
                entity.getFkPkidCatalogoGenero(),
                entity.getFkPkidCatalogoPais(),
                entity.getFkPkidCatalogoCiudad(),
                entity.getDireccion(),
                entity.getTieneResponsableLegal(),
                entity.getResponsableEmail(),
                entity.getResponsableNumeroIdentificacion(),
                entity.getResponsablePrimerNombre(),
                entity.getResponsablePrimerApellido(),
                entity.getResponsableTelefono(),
                entity.getIpRegistro(),
                entity.getMetadata(),
                entity.getCreationDate(),
                entity.getExpirationDate()
        );
    }

    /**
     * Convertir Domain → Entity JPA
     */
    public InformacionBasicaEntity toEntity(InformacionBasica domain) {
        if (domain == null) {
            return null;
        }

        return new InformacionBasicaEntity(
                domain.getId(),
                domain.getPrimerNombre(),
                domain.getSegundoNombre(),
                domain.getPrimerApellido(),
                domain.getSegundoApellido(),
                domain.getTipoDocumentoId(),
                domain.getNumeroIdentificacion(),
                domain.getEmail(),
                domain.getTelefono(),
                domain.getFechaNacimiento(),
                domain.getGeneroId(),
                domain.getPaisId(),
                domain.getCiudadId(),
                domain.getDireccion(),
                domain.getTieneResponsableLegal(),
                domain.getResponsableEmail(),
                domain.getResponsableNumeroIdentificacion(),
                domain.getResponsablePrimerNombre(),
                domain.getResponsablePrimerApellido(),
                domain.getResponsableTelefono(),
                domain.getIpRegistro(),
                domain.getMetadata(),
                domain.getCreationDate(),
                domain.getExpirationDate()
        );
    }
}
