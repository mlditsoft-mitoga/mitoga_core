package com.mitoga.autenticacion.domain.exception;

/**
 * CredencialesInvalidasException - Credenciales incorrectas en login
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 */
public class CredencialesInvalidasException extends AutenticacionException {

    public CredencialesInvalidasException() {
        super("Email o contraseña incorrectos");
    }

    public CredencialesInvalidasException(String mensaje) {
        super(mensaje);
    }
}
