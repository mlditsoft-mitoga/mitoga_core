package com.mitoga.notificaciones.domain.valueobject;

/**
 * Enum para tipos de notificación - DOMAIN VALUE OBJECT
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - DOMAIN LAYER - VALUE OBJECT
 */
public enum NotificationType {
    EMAIL,
    SMS,
    PUSH,
    IN_APP;

    public boolean requiresExternalService() {
        return this == SMS || this == PUSH;
    }
}