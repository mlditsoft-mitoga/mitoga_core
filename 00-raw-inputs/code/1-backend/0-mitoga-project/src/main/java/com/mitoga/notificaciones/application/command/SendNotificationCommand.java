package com.mitoga.notificaciones.application.command;

import lombok.Data;
import lombok.Builder;
import java.util.UUID;

/**
 * Command para enviar notificación
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - COMMAND
 */
@Data
@Builder
public class SendNotificationCommand {
    private String destinatario; // email o teléfono
    private String asunto;
    private String contenido;
    private String tipo; // EMAIL, SMS, etc.
    private UUID usuarioId;
    private String proposito;
}