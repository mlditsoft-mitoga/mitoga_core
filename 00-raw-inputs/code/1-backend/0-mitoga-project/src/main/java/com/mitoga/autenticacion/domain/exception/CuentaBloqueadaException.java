package com.mitoga.autenticacion.domain.exception;

/**
 * CuentaBloqueadaException - La cuenta del usuario está bloqueada
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 */
public class CuentaBloqueadaException extends AutenticacionException {

    public CuentaBloqueadaException(String motivo) {
        super("La cuenta está bloqueada. Motivo: " + motivo);
    }
}
