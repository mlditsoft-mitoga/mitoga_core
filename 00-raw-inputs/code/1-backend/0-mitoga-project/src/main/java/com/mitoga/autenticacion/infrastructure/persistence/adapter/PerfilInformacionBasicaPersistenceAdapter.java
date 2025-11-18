package com.mitoga.autenticacion.infrastructure.persistence.adapter;

import com.mitoga.autenticacion.domain.entity.PerfilInformacionBasica;
import com.mitoga.autenticacion.domain.repository.PerfilInformacionBasicaRepository;
import com.mitoga.autenticacion.domain.valueobject.EstadoPerfil;
import com.mitoga.autenticacion.infrastructure.persistence.mapper.PerfilInformacionBasicaMapper;
import com.mitoga.autenticacion.infrastructure.persistence.repository.JpaPerfilInformacionBasicaRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Adapter de persistencia: Implementa PerfilInformacionBasicaRepository (port del dominio)
 * 
 * <p>
 * Traduce operaciones del dominio a operaciones JPA.
 * </p>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Component
public class PerfilInformacionBasicaPersistenceAdapter implements PerfilInformacionBasicaRepository {

    private final JpaPerfilInformacionBasicaRepository jpaRepository;
    private final PerfilInformacionBasicaMapper mapper;

    public PerfilInformacionBasicaPersistenceAdapter(
            JpaPerfilInformacionBasicaRepository jpaRepository,
            PerfilInformacionBasicaMapper mapper) {
        this.jpaRepository = jpaRepository;
        this.mapper = mapper;
    }

    @Override
    public PerfilInformacionBasica save(PerfilInformacionBasica perfilInfo) {
        var entity = mapper.toEntity(perfilInfo);
        var savedEntity = jpaRepository.save(entity);
        return mapper.toDomain(savedEntity);
    }

    @Override
    public Optional<PerfilInformacionBasica> findById(UUID id) {
        return jpaRepository.findById(id)
                .filter(entity -> entity.getExpirationDate() == null)
                .map(mapper::toDomain);
    }

    @Override
    public List<PerfilInformacionBasica> findByInformacionBasicaId(UUID informacionBasicaId) {
        return jpaRepository.findByFkPkidInformacionBasicaAndExpirationDateIsNull(informacionBasicaId)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<PerfilInformacionBasica> findByPerfilId(UUID perfilId) {
        return jpaRepository.findByFkPkidPerfilesAndExpirationDateIsNull(perfilId)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<PerfilInformacionBasica> findByPerfilIdAndInformacionBasicaId(
            UUID perfilId, 
            UUID informacionBasicaId) {
        return jpaRepository.findByFkPkidPerfilesAndFkPkidInformacionBasicaAndExpirationDateIsNull(
                perfilId, 
                informacionBasicaId)
                .map(mapper::toDomain);
    }

    @Override
    public Optional<PerfilInformacionBasica> findPerfilPrincipalByInformacionBasicaId(UUID informacionBasicaId) {
        return jpaRepository.findFirstByFkPkidInformacionBasicaAndEsPerfilPrincipalAndEstadoAndExpirationDateIsNull(
                informacionBasicaId, 
                true, 
                EstadoPerfil.ACTIVO.name())
                .map(mapper::toDomain);
    }

    @Override
    public List<PerfilInformacionBasica> findActivosByInformacionBasicaId(UUID informacionBasicaId) {
        return jpaRepository.findByFkPkidInformacionBasicaAndEstadoAndExpirationDateIsNullOrderByEsPerfilPrincipalDescFechaAsignacionDesc(
                informacionBasicaId, 
                EstadoPerfil.ACTIVO.name())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsByPerfilIdAndInformacionBasicaId(UUID perfilId, UUID informacionBasicaId) {
        return jpaRepository.existsByFkPkidPerfilesAndFkPkidInformacionBasicaAndExpirationDateIsNull(
                perfilId, 
                informacionBasicaId);
    }

    @Override
    public List<PerfilInformacionBasica> findByInformacionBasicaIdAndEstado(
            UUID informacionBasicaId, 
            EstadoPerfil estado) {
        return jpaRepository.findByFkPkidInformacionBasicaAndEstadoAndExpirationDateIsNull(
                informacionBasicaId, 
                estado.name())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<PerfilInformacionBasica> findPendienteDeVincular(UUID perfilId) {
        return jpaRepository.findFirstByFkPkidPerfilesAndFkPkidInformacionBasicaIsNullAndExpirationDateIsNullOrderByCreationDateDesc(
                perfilId)
                .map(mapper::toDomain);
    }
}
