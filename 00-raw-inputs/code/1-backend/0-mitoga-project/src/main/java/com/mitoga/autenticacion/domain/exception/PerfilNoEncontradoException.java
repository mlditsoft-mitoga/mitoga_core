package com.mitoga.autenticacion.domain.exception;

import com.mitoga.shared.domain.DomainException;

/**
 * Excepción de dominio: Perfil no encontrado
 * 
 * <p>
 * Lanzada cuando se intenta buscar un perfil que no existe en el sistema.
 * </p>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
public class PerfilNoEncontradoException extends DomainException {

    private static final String MESSAGE_TEMPLATE = "El perfil '%s' no fue encontrado en el sistema";

    public PerfilNoEncontradoException(String nombrePerfil) {
        super(String.format(MESSAGE_TEMPLATE, nombrePerfil));
    }

    public PerfilNoEncontradoException(String nombrePerfil, Throwable cause) {
        super(String.format(MESSAGE_TEMPLATE, nombrePerfil), cause);
    }
}
