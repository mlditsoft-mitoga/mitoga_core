package com.mitoga.autenticacion.application.port.input;

import com.mitoga.autenticacion.application.command.RefreshTokenCommand;

/**
 * RefreshTokenUseCase - PORT de entrada para renovación de tokens
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - INPUT PORT (Use Case)
 * - Interfaz (Port) que define el caso de uso de renovación de JWT
 */
public interface RefreshTokenUseCase {

    /**
     * Renueva el JWT access token usando refresh token
     * 
     * @return DTO con nuevo JWT access token
     */
    AutenticacionResponse refreshToken(RefreshTokenCommand command);
}
