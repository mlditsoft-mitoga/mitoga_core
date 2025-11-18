package com.mitoga.autenticacion.infrastructure.persistence.adapter;

import com.mitoga.autenticacion.domain.entity.ProcesoRegistro;
import com.mitoga.autenticacion.domain.repository.ProcesoRegistroRepository;
import com.mitoga.autenticacion.infrastructure.persistence.entity.ProcesoRegistroEntity;
import com.mitoga.autenticacion.infrastructure.persistence.repository.JpaProcesoRegistroRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Adapter: ProcesoRegistroRepository (Puerto → JPA)
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Component
@RequiredArgsConstructor
public class ProcesoRegistroRepositoryAdapter implements ProcesoRegistroRepository {

    private final JpaProcesoRegistroRepository jpaRepository;

    @Override
    public ProcesoRegistro save(ProcesoRegistro procesoRegistro) {
        ProcesoRegistroEntity entity = ProcesoRegistroEntity.fromDomain(procesoRegistro);
        ProcesoRegistroEntity savedEntity = jpaRepository.save(entity);
        return savedEntity.toDomain();
    }

    @Override
    public Optional<ProcesoRegistro> findById(UUID procesoId) {
        return jpaRepository.findById(procesoId)
                .map(ProcesoRegistroEntity::toDomain);
    }

    @Override
    public Optional<ProcesoRegistro> findProcesoActivoByUsuario(UUID usuarioId) {
        List<ProcesoRegistro.EstadoProceso> estadosExcluidos = List.of(
                ProcesoRegistro.EstadoProceso.EXPIRADO,
                ProcesoRegistro.EstadoProceso.CANCELADO,
                ProcesoRegistro.EstadoProceso.COMPLETADO);

        return jpaRepository
                .findFirstByFkIdUsuarioAndExpirationDateIsNullAndFechaExpiracionProcesoAfterAndEstadoActualNotInOrderByFechaInicioDesc(
                        usuarioId,
                        LocalDateTime.now(),
                        estadosExcluidos)
                .map(ProcesoRegistroEntity::toDomain);
    }
}
