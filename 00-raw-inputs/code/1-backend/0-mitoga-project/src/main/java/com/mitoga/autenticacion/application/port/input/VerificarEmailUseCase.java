package com.mitoga.autenticacion.application.port.input;

import com.mitoga.autenticacion.application.command.VerificarEmailCommand;

/**
 * VerificarEmailUseCase - PORT de entrada para verificación de email
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - INPUT PORT (Use Case)
 * - Interfaz (Port) que define el caso de uso de verificación de email
 */
public interface VerificarEmailUseCase {

    /**
     * Verifica el email del usuario con el token enviado
     * 
     * @return DTO con resultado de verificación
     */
    VerificacionResponse verificarEmail(VerificarEmailCommand command);
}
