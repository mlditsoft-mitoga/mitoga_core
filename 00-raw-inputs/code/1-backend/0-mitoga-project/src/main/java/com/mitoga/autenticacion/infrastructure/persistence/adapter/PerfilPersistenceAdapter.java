package com.mitoga.autenticacion.infrastructure.persistence.adapter;

import com.mitoga.autenticacion.domain.entity.Perfil;
import com.mitoga.autenticacion.domain.repository.PerfilRepository;
import com.mitoga.autenticacion.infrastructure.persistence.mapper.PerfilMapper;
import com.mitoga.autenticacion.infrastructure.persistence.repository.JpaPerfilRepository;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.UUID;

/**
 * Adapter de persistencia: Implementa PerfilRepository (port del dominio)
 * 
 * <p>
 * Traduce operaciones del dominio a operaciones JPA.
 * </p>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Component
public class PerfilPersistenceAdapter implements PerfilRepository {

    private final JpaPerfilRepository jpaRepository;
    private final PerfilMapper mapper;

    public PerfilPersistenceAdapter(
            JpaPerfilRepository jpaRepository,
            PerfilMapper mapper) {
        this.jpaRepository = jpaRepository;
        this.mapper = mapper;
    }

    @Override
    public Perfil save(Perfil perfil) {
        var entity = mapper.toEntity(perfil);
        var savedEntity = jpaRepository.save(entity);
        return mapper.toDomain(savedEntity);
    }

    @Override
    public Optional<Perfil> findById(UUID id) {
        return jpaRepository.findById(id)
                .filter(entity -> entity.getExpirationDate() == null)
                .map(mapper::toDomain);
    }

    @Override
    public Optional<Perfil> findByCodigo(String codigo) {
        return jpaRepository.findByCodigoAndExpirationDateIsNull(codigo)
                .map(mapper::toDomain);
    }

    @Override
    public boolean existsByCodigo(String codigo) {
        return jpaRepository.existsByCodigoAndExpirationDateIsNull(codigo);
    }
}
