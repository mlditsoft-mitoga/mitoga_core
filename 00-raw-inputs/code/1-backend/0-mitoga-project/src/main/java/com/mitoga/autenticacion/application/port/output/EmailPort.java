package com.mitoga.autenticacion.application.port.output;

import java.util.UUID;

/**
 * EmailPort - PORT de salida para envío de emails
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - OUTPUT PORT
 * - Interfaz (Port) para delegar envío de emails a infraestructura
 * - Implementada por EmailAdapter (SMTP, SendGrid, etc.)
 */
public interface EmailPort {

    /**
     * Envía email de verificación con token
     */
    void enviarEmailVerificacion(String destinatario, String nombre, String token);

    /**
     * Envía email de bienvenida
     */
    void enviarEmailBienvenida(String destinatario, String nombre);

    /**
     * Envía email de recuperación de contraseña
     */
    void enviarEmailRecuperacionPassword(String destinatario, String nombre, String token);

    /**
     * Envía email de cambio de contraseña exitoso
     */
    void enviarEmailCambioPassword(String destinatario, String nombre);

    /**
     * Envía email de nueva sesión detectada
     */
    void enviarEmailNuevaSesion(String destinatario, String nombre, String dispositivo, String ipAddress);
}
