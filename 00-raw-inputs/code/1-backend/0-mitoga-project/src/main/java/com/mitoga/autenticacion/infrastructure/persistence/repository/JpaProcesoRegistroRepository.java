package com.mitoga.autenticacion.infrastructure.persistence.repository;

import com.mitoga.autenticacion.domain.entity.ProcesoRegistro;
import com.mitoga.autenticacion.infrastructure.persistence.entity.ProcesoRegistroEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository: ProcesoRegistro
 * 
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Repository
public interface JpaProcesoRegistroRepository extends JpaRepository<ProcesoRegistroEntity, UUID> {

        /**
         * Buscar proceso activo por usuario
         * 
         * <p>
         * Query derivado: WHERE fk_id_usuario = ? AND expiration_date IS NULL
         * AND fecha_expiracion_proceso > ? AND estado_actual NOT IN (?)
         * ORDER BY fecha_inicio DESC
         * </p>
         * 
         * @param fkIdUsuario            ID del usuario
         * @param fechaExpiracionProceso Fecha actual (para validar no expirado)
         * @param estadosExcluidos       Estados a excluir (EXPIRADO, CANCELADO,
         *                               COMPLETADO)
         * @return Optional con el proceso más reciente
         */
        Optional<ProcesoRegistroEntity> findFirstByFkIdUsuarioAndExpirationDateIsNullAndFechaExpiracionProcesoAfterAndEstadoActualNotInOrderByFechaInicioDesc(
                        UUID fkIdUsuario,
                        LocalDateTime fechaExpiracionProceso,
                        List<ProcesoRegistro.EstadoProceso> estadosExcluidos);

        /**
         * Buscar procesos expirados para cleanup
         * 
         * <p>
         * Query derivado: WHERE expiration_date IS NULL
         * AND fecha_expiracion_proceso <= ? AND estado_actual NOT IN (?)
         * </p>
         * 
         * @param fechaExpiracionProceso Fecha actual
         * @param estadosExcluidos       Estados ya procesados (EXPIRADO, COMPLETADO,
         *                               CANCELADO)
         * @return Lista de procesos expirados
         */
        List<ProcesoRegistroEntity> findByExpirationDateIsNullAndFechaExpiracionProcesoBeforeAndEstadoActualNotIn(
                        LocalDateTime fechaExpiracionProceso,
                        List<ProcesoRegistro.EstadoProceso> estadosExcluidos);
}
