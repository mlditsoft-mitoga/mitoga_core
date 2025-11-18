package com.mitoga.autenticacion.domain.exception;

import com.mitoga.shared.domain.DomainException;

/**
 * Exception: Contraseñas no coinciden
 * 
 * <p>
 * Lanzada cuando password y confirmPassword no son iguales
 * </p>
 * 
 * @author Backend Team MI-TOGA
 */
public class PasswordsNoCoinciden extends DomainException {
    public PasswordsNoCoinciden() {
        super("Las contraseñas no coinciden");
    }
}
