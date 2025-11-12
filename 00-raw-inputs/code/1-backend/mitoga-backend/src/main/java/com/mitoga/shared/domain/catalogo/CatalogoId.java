package com.mitoga.shared.domain.catalogo;

import java.util.Objects;
import java.util.UUID;

/**
 * Value Object que representa el identificador único de un Catálogo.
 * 
 * Inmutable por naturaleza (record de Java 21).
 * Valida que el UUID no sea nulo.
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.0.0
 */
public record CatalogoId(UUID value) {

    /**
     * Constructor compacto con validación.
     * 
     * @throws IllegalArgumentException si value es nulo
     */
    public CatalogoId {
        Objects.requireNonNull(value, "CatalogoId no puede ser nulo");
    }

    /**
     * Genera un nuevo CatalogoId aleatorio.
     * 
     * @return nuevo CatalogoId con UUID aleatorio
     */
    public static CatalogoId generate() {
        return new CatalogoId(UUID.randomUUID());
    }

    /**
     * Crea un CatalogoId a partir de un String.
     * 
     * @param value String representando un UUID
     * @return CatalogoId
     * @throws IllegalArgumentException si el string no es un UUID válido
     */
    public static CatalogoId fromString(String value) {
        Objects.requireNonNull(value, "El string del UUID no puede ser nulo");
        try {
            return new CatalogoId(UUID.fromString(value));
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("String no es un UUID válido: " + value, e);
        }
    }

    @Override
    public String toString() {
        return value.toString();
    }
}
