package com.mitoga.autenticacion.application.command;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * RefreshTokenCommand - Comando para renovar token de acceso
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - COMMAND (CQRS)
 * - Comando para renovar JWT usando refresh token
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class RefreshTokenCommand {
    private String refreshToken;
    private String ipAddress;
    private String userAgent;
}
