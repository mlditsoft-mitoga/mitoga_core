package com.mitoga.notificaciones.application.usecase;

import com.mitoga.notificaciones.application.command.SendNotificationCommand;
import java.util.UUID;

/**
 * Puerto completo de la capa de aplicación para notificaciones - ARQUITECTURA
 * HEXAGONAL
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - USE CASES
 * - Define los casos de uso del módulo Notificaciones
 * - Puerto que será implementado por adaptadores en infrastructure
 */
public interface NotificationManagementUseCase {

    /**
     * Genera token alfanumérico de 6 dígitos
     */
    String generateVerificationToken();

    /**
     * Almacena token con expiración
     */
    void storeToken(String token, UUID userId, String purpose, int expirationMinutes);

    /**
     * Valida token y lo consume (elimina)
     */
    boolean validateAndConsumeToken(String token, UUID userId, String purpose);

    /**
     * Verifica si un token existe y es válido
     */
    boolean isTokenValid(String token, UUID userId, String purpose);

    /**
     * Invalida todos los tokens de un usuario para un propósito
     */
    void invalidateUserTokens(UUID userId, String purpose);

    /**
     * Envía notificación por email
     */
    void sendVerificationEmail(String email, String token, String userName, String purpose);

    /**
     * Envía notificación por SMS
     */
    void sendVerificationSMS(String phoneNumber, String token, String purpose);

    /**
     * Envía email con credenciales
     */
    void sendCredentialsEmail(String email, String username, String password, String userName);

    /**
     * Envía notificación de aprobación
     */
    void sendApprovalNotification(String email, String userName, String loginUrl);

    /**
     * Envía notificación de rechazo
     */
    void sendRejectionNotification(String email, String userName, String reason);

    /**
     * Envía notificación genérica
     */
    void sendNotification(SendNotificationCommand command);
}