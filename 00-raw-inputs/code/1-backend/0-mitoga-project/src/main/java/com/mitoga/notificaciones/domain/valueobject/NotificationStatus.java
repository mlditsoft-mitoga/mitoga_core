package com.mitoga.notificaciones.domain.valueobject;

/**
 * Enum para estado de notificación - DOMAIN VALUE OBJECT
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - DOMAIN LAYER - VALUE OBJECT
 */
public enum NotificationStatus {
    PENDIENTE,
    ENVIADO,
    FALLIDO,
    CANCELADO;

    public boolean esTerminal() {
        return this == ENVIADO || this == CANCELADO;
    }
}