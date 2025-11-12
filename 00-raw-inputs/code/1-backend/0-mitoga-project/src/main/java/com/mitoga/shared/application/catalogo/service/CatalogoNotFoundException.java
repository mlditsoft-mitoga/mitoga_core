package com.mitoga.shared.application.catalogo.service;

import com.mitoga.shared.domain.catalogo.CatalogoId;

/**
 * Excepción lanzada cuando un catálogo no existe.
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.0.0
 */
public class CatalogoNotFoundException extends RuntimeException {

    public CatalogoNotFoundException(CatalogoId id) {
        super(String.format("Catálogo no encontrado con ID: %s", id.value()));
    }

    public CatalogoNotFoundException(String message) {
        super(message);
    }
}
