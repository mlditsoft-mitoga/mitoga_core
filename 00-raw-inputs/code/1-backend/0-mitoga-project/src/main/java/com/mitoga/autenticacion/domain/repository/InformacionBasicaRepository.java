package com.mitoga.autenticacion.domain.repository;

import com.mitoga.autenticacion.domain.entity.InformacionBasica;

import java.util.Optional;
import java.util.UUID;

/**
 * Port (Repository): Información Básica
 * 
 * <p>
 * Define el contrato para persistencia de InformacionBasica.
 * </p>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
public interface InformacionBasicaRepository {

    /**
     * Guardar InformacionBasica
     */
    InformacionBasica save(InformacionBasica informacionBasica);

    /**
     * Buscar por ID
     */
    Optional<InformacionBasica> findById(UUID id);

    /**
     * Buscar por número de identificación
     */
    Optional<InformacionBasica> findByNumeroIdentificacion(String numeroIdentificacion);

    /**
     * Buscar por email
     */
    Optional<InformacionBasica> findByEmail(String email);

    /**
     * Verificar si existe un número de identificación
     */
    boolean existsByNumeroIdentificacion(String numeroIdentificacion);

    /**
     * Verificar si existe un email
     */
    boolean existsByEmail(String email);
}
