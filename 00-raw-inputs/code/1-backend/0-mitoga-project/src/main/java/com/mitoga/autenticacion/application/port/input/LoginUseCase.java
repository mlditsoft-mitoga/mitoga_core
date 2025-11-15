package com.mitoga.autenticacion.application.port.input;

import com.mitoga.autenticacion.application.command.LoginCommand;

/**
 * LoginUseCase - PORT de entrada para autenticación de usuarios
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - INPUT PORT (Use Case)
 * - Interfaz (Port) que define el caso de uso de login
 * - Soporta autenticación tradicional (email/password) y OAuth 2.0
 */
public interface LoginUseCase {

    /**
     * Autentica un usuario (tradicional o OAuth)
     * 
     * @return DTO con JWT access token, refresh token y datos del usuario
     */
    AutenticacionResponse login(LoginCommand command);
}
