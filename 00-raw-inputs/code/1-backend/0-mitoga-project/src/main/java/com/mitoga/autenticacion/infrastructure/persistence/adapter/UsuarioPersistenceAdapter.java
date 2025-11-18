package com.mitoga.autenticacion.infrastructure.persistence.adapter;

import com.mitoga.autenticacion.domain.entity.Usuario;
import com.mitoga.autenticacion.domain.repository.UsuarioRepository;
import com.mitoga.autenticacion.domain.valueobject.Email;
import com.mitoga.autenticacion.domain.valueobject.EstadoCuenta;
import com.mitoga.autenticacion.domain.valueobject.UsuarioId;
import com.mitoga.autenticacion.infrastructure.persistence.entity.UsuarioEntity;
import com.mitoga.autenticacion.infrastructure.persistence.mapper.UsuarioMapper;
import org.springframework.stereotype.Component;

import java.time.ZonedDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Adapter de persistencia: Implementa UsuarioRepository (port del dominio)
 * 
 * <p>
 * Traduce operaciones del dominio a operaciones JPA usando:
 * </p>
 * <ul>
 * <li><b>UsuarioMapper</b>: Conversión domain ↔ persistence</li>
 * </ul>
 * 
 * <p>
 * <b>Arquitectura Hexagonal:</b>
 * </p>
 * 
 * <pre>
 * Domain Layer (Usuario, UsuarioId, Email)
 *      ↑ implements
 * Port (UsuarioRepository interface)
 *      ↓ implements
 * Adapter (UsuarioPersistenceAdapter) ← ESTA CLASE
 *      ↓ uses
 * Infrastructure (UsuarioJpaRepository, UsuarioEntity)
 * </pre>
 * 
 * <p>
 * <b>Responsabilidades:</b>
 * </p>
 * <ul>
 * <li>Implementar contrato UsuarioRepository</li>
 * <li>Delegar a UsuarioJpaRepository (Query Methods ONLY)</li>
 * <li>Mapear domain ↔ persistence via UsuarioMapper</li>
 * <li>Manejar Optional y conversiones de colecciones</li>
 * </ul>
 */
@Component
public class UsuarioPersistenceAdapter implements UsuarioRepository {

    private final UsuarioJpaRepository jpaRepository;
    private final UsuarioMapper mapper;

    public UsuarioPersistenceAdapter(
            UsuarioJpaRepository jpaRepository,
            UsuarioMapper mapper) {
        this.jpaRepository = jpaRepository;
        this.mapper = mapper;
    }

    @Override
    @SuppressWarnings("null")
    public Usuario save(Usuario usuario) {
        UsuarioEntity entity = mapper.toEntity(usuario);
        UsuarioEntity savedEntity = jpaRepository.save(entity);
        return mapper.toDomain(savedEntity);
    }

    @Override
    @SuppressWarnings("null")
    public Optional<Usuario> findById(UsuarioId id) {
        return jpaRepository.findById(id.value())
                .filter(entity -> entity.getExpirationDate() == null) // Filtrar soft-deleted
                .map(mapper::toDomain);
    }

    @Override
    public Optional<Usuario> findByEmail(Email email) {
        return jpaRepository.findByEmailAndExpirationDateIsNull(email.value())
                .map(mapper::toDomain);
    }

    @Override
    public boolean existsByEmail(Email email) {
        return jpaRepository.existsByEmailAndExpirationDateIsNull(email.value());
    }

    @Override
    public Optional<Usuario> findByTokenRecuperacion(String token) {
        return jpaRepository
                .findByTokenRecuperacionPasswordAndExpirationDateIsNullAndTokenRecuperacionPasswordIsNotNull(token)
                .map(mapper::toDomain);
    }

    @Override
    public List<Usuario> findByEstadoCuenta(EstadoCuenta estadoCuenta) {
        return jpaRepository
                .findByEstadoCuentaAndExpirationDateIsNullOrderByCreationDateDesc(estadoCuenta.name())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Usuario> findByEmailNoVerificado() {
        return jpaRepository
                .findByEmailVerificadoFalseAndExpirationDateIsNullOrderByCreationDateDesc()
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Usuario> findByIntentosFallidosGreaterThanEqual(int limite) {
        return jpaRepository
                .findByIntentosFallidosLoginGreaterThanEqualAndExpirationDateIsNullOrderByIntentosFallidosLoginDesc(
                        limite)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Usuario> findByFechaUltimoAccesoBefore(ZonedDateTime fecha) {
        return jpaRepository
                .findByFechaUltimoAccesoBeforeAndExpirationDateIsNullOrderByFechaUltimoAccesoAsc(fecha)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public long countByEstadoCuenta(EstadoCuenta estadoCuenta) {
        return jpaRepository.countByEstadoCuentaAndExpirationDateIsNull(estadoCuenta.name());
    }

    @Override
    public void delete(Usuario usuario) {
        // Soft delete: marcar como eliminado y establecer expiration_date
        usuario.eliminar();
        save(usuario);
    }

    @Override
    public List<Usuario> findAll() {
        return jpaRepository
                .findByExpirationDateIsNullOrderByCreationDateDesc()
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }
}
