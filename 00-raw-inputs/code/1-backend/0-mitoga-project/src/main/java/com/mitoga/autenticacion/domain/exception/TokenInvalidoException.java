package com.mitoga.autenticacion.domain.exception;

/**
 * TokenInvalidoException - Token de verificación o refresh inválido
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 */
public class TokenInvalidoException extends AutenticacionException {

    public TokenInvalidoException() {
        super("Token inválido o expirado");
    }

    public TokenInvalidoException(String mensaje) {
        super(mensaje);
    }
}
