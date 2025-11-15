package com.mitoga.notificaciones.infrastructure.persistence.adapter;

import com.mitoga.notificaciones.domain.entity.Notificacion;
import com.mitoga.notificaciones.domain.repository.NotificacionRepository;
import com.mitoga.notificaciones.domain.valueobject.NotificationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.UUID;
import java.util.List;

/**
 * Adaptador de persistencia JPA para Notificacion - ARQUITECTURA HEXAGONAL
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - INFRASTRUCTURE LAYER - PERSISTENCE ADAPTER
 */
@Repository
public interface NotificacionJpaRepository extends JpaRepository<Notificacion, UUID>, NotificacionRepository {

    /**
     * Busca notificaciones por usuario ID
     */
    @Query("SELECT n FROM Notificacion n WHERE n.usuarioId = :usuarioId ORDER BY n.creationDate DESC")
    List<Notificacion> findByUsuarioId(@Param("usuarioId") UUID usuarioId);

    /**
     * Busca notificaciones por estado
     */
    @Query("SELECT n FROM Notificacion n WHERE n.estado = :estado ORDER BY n.creationDate DESC")
    List<Notificacion> findByEstado(@Param("estado") NotificationStatus estado);

    /**
     * Busca notificaciones fallidas que pueden reintentarse
     */
    @Query("SELECT n FROM Notificacion n WHERE n.estado = 'FALLIDO' AND n.intentosEnvio < 3 ORDER BY n.creationDate ASC")
    List<Notificacion> findPendingRetries();
}