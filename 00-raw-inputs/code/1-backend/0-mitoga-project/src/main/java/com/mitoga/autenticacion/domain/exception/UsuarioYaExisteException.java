package com.mitoga.autenticacion.domain.exception;

/**
 * UsuarioYaExisteException - El email ya está registrado
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 */
public class UsuarioYaExisteException extends AutenticacionException {

    public UsuarioYaExisteException(String email) {
        super("Ya existe un usuario registrado con el email: " + email);
    }
}
