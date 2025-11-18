package com.mitoga.autenticacion.infrastructure.persistence.adapter;

import com.mitoga.autenticacion.domain.entity.InformacionBasica;
import com.mitoga.autenticacion.domain.repository.InformacionBasicaRepository;
import com.mitoga.autenticacion.infrastructure.persistence.entity.InformacionBasicaEntity;
import com.mitoga.autenticacion.infrastructure.persistence.mapper.InformacionBasicaMapper;
import com.mitoga.autenticacion.infrastructure.persistence.repository.JpaInformacionBasicaRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.UUID;

/**
 * Adapter: Implementación de InformacionBasicaRepository usando JPA
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class InformacionBasicaPersistenceAdapter implements InformacionBasicaRepository {

    private final JpaInformacionBasicaRepository jpaRepository;
    private final InformacionBasicaMapper mapper;

    @Override
    public InformacionBasica save(InformacionBasica informacionBasica) {
        log.debug("💾 Guardando InformacionBasica: {}", informacionBasica.getId());
        InformacionBasicaEntity entity = mapper.toEntity(informacionBasica);
        InformacionBasicaEntity saved = jpaRepository.save(entity);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<InformacionBasica> findById(UUID id) {
        log.debug("🔍 Buscando InformacionBasica por ID: {}", id);
        return jpaRepository.findById(id)
                .map(mapper::toDomain);
    }

    @Override
    public Optional<InformacionBasica> findByNumeroIdentificacion(String numeroIdentificacion) {
        log.debug("🔍 Buscando InformacionBasica por numeroIdentificacion: {}", numeroIdentificacion);
        return jpaRepository.findByNumeroIdentificacionAndExpirationDateIsNull(numeroIdentificacion)
                .map(mapper::toDomain);
    }

    @Override
    public Optional<InformacionBasica> findByEmail(String email) {
        log.debug("🔍 Buscando InformacionBasica por email: {}", email);
        return jpaRepository.findByEmailAndExpirationDateIsNull(email)
                .map(mapper::toDomain);
    }

    @Override
    public boolean existsByNumeroIdentificacion(String numeroIdentificacion) {
        log.debug("🔍 Verificando existencia de numeroIdentificacion: {}", numeroIdentificacion);
        return jpaRepository.existsByNumeroIdentificacionAndExpirationDateIsNull(numeroIdentificacion);
    }

    @Override
    public boolean existsByEmail(String email) {
        log.debug("🔍 Verificando existencia de email: {}", email);
        return jpaRepository.existsByEmailAndExpirationDateIsNull(email);
    }
}
