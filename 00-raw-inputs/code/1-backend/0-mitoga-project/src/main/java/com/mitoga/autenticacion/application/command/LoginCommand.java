package com.mitoga.autenticacion.application.command;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * LoginCommand - Comando para iniciar sesión
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - COMMAND (CQRS)
 * - Comando para autenticación de usuario
 * - Soporta login tradicional y OAuth 2.0
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginCommand {
    private String email;
    private String password;
    private String ipAddress;
    private String userAgent;
}
