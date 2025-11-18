package com.mitoga.autenticacion.infrastructure.persistence.repository;

import com.mitoga.autenticacion.infrastructure.persistence.entity.InformacionBasicaEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

/**
 * Spring Data JPA Repository: Información Básica
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Repository
public interface JpaInformacionBasicaRepository extends JpaRepository<InformacionBasicaEntity, UUID> {

    /**
     * Buscar por número de identificación activo
     */
    Optional<InformacionBasicaEntity> findByNumeroIdentificacionAndExpirationDateIsNull(
            String numeroIdentificacion);

    /**
     * Buscar por email activo
     */
    Optional<InformacionBasicaEntity> findByEmailAndExpirationDateIsNull(String email);

    /**
     * Verificar existencia de número de identificación
     */
    boolean existsByNumeroIdentificacionAndExpirationDateIsNull(String numeroIdentificacion);

    /**
     * Verificar existencia de email
     */
    boolean existsByEmailAndExpirationDateIsNull(String email);
}
