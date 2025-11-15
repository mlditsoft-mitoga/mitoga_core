package com.mitoga.notificaciones.application.usecase;

import java.util.UUID;

/**
 * Puerto simplificado para uso desde otros módulos - ARQUITECTURA HEXAGONAL
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - PUBLIC PORT
 * - API simplificada para uso desde módulos externos (Estudiantes, etc.)
 * - Delega en NotificationManagementUseCase para implementación completa
 * - Facilita comunicación entre bounded contexts
 */
public interface NotificationUseCase {

    /**
     * Genera un token de verificación de 6 dígitos
     */
    String generateVerificationToken();

    /**
     * Almacena token de verificación con tiempo de expiración
     */
    void storeToken(String token, UUID entityId, String type, int expirationMinutes);

    /**
     * Envía email de verificación con token
     */
    void sendVerificationEmail(String email, String token, String userName, String type);

    /**
     * Envía notificación de proceso aprobado
     */
    void sendApprovalNotification(String email, String userName);

    /**
     * Envía notificación de proceso rechazado
     */
    void sendRejectionNotification(String email, String userName, String reason);

    /**
     * Valida si un token es válido
     */
    boolean validateToken(String token, UUID entityId, String type);
}