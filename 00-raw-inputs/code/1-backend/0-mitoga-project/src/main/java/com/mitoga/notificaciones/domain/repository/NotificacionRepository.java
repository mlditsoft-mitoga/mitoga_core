package com.mitoga.notificaciones.domain.repository;

import com.mitoga.notificaciones.domain.entity.Notificacion;
import com.mitoga.notificaciones.domain.valueobject.NotificationStatus;
import java.util.UUID;
import java.util.Optional;
import java.util.List;

/**
 * Puerto del repositorio para Notificacion - ARQUITECTURA HEXAGONAL
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - DOMAIN LAYER - REPOSITORY PORT
 * - Puerto definido en el dominio
 * - Será implementado por un adaptador en infrastructure
 */
public interface NotificacionRepository {

    /**
     * Guarda una notificación
     */
    Notificacion save(Notificacion notificacion);

    /**
     * Busca notificación por ID
     */
    Optional<Notificacion> findById(UUID id);

    /**
     * Busca notificaciones por usuario ID
     */
    List<Notificacion> findByUsuarioIdOrderByCreationDateDesc(UUID usuarioId);

    /**
     * Busca notificaciones por estado
     */
    List<Notificacion> findByEstadoOrderByCreationDateDesc(NotificationStatus estado);

    /**
     * Busca notificaciones pendientes de reintento
     * 
     * @param estado      Estado de notificación (generalmente FALLIDO)
     * @param maxIntentos Número máximo de intentos permitidos
     */
    List<Notificacion> findByEstadoAndIntentosEnvioLessThanOrderByCreationDateAsc(
            NotificationStatus estado, int maxIntentos);
}