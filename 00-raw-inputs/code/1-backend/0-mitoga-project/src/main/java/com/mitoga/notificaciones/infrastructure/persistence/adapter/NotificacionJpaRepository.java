package com.mitoga.notificaciones.infrastructure.persistence.adapter;

import com.mitoga.notificaciones.domain.entity.Notificacion;
import com.mitoga.notificaciones.domain.repository.NotificacionRepository;
import com.mitoga.notificaciones.domain.valueobject.NotificationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
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
     * Query Method - Spring Data JPA genera automáticamente la consulta
     */
    List<Notificacion> findByUsuarioIdOrderByCreationDateDesc(UUID usuarioId);

    /**
     * Busca notificaciones por estado
     * Query Method - Spring Data JPA genera automáticamente la consulta
     */
    List<Notificacion> findByEstadoOrderByCreationDateDesc(NotificationStatus estado);

    /**
     * Busca notificaciones fallidas que pueden reintentarse
     * Query Method - Spring Data JPA genera automáticamente la consulta
     */
    List<Notificacion> findByEstadoAndIntentosEnvioLessThanOrderByCreationDateAsc(NotificationStatus estado,
            int maxIntentos);
}