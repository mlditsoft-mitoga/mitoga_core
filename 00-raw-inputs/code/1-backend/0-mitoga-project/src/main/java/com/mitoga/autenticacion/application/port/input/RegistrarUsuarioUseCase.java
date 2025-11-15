package com.mitoga.autenticacion.application.port.input;

import com.mitoga.autenticacion.application.command.RegistrarUsuarioCommand;

/**
 * RegistrarUsuarioUseCase - PORT de entrada para registro de usuarios
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - INPUT PORT (Use Case)
 * - Interfaz (Port) que define el caso de uso de registro
 * - Implementada por servicios en application/service
 * - Soporta registro tradicional y OAuth 2.0
 */
public interface RegistrarUsuarioUseCase {

    /**
     * Registra un nuevo usuario (tradicional o OAuth)
     * 
     * @return DTO con información del usuario y tokens
     */
    AutenticacionResponse registrar(RegistrarUsuarioCommand command);
}
