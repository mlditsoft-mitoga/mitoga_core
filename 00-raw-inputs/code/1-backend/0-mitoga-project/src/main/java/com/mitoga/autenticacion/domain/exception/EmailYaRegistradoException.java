package com.mitoga.autenticacion.domain.exception;

import com.mitoga.shared.domain.DomainException;

/**
 * Exception: Email ya registrado
 * 
 * <p>
 * Lanzada cuando se intenta registrar un email que ya existe en el sistema
 * </p>
 * 
 * @author Backend Team MI-TOGA
 */
public class EmailYaRegistradoException extends DomainException {
    public EmailYaRegistradoException(String email) {
        super(String.format("El email '%s' ya está registrado", email));
    }
}
