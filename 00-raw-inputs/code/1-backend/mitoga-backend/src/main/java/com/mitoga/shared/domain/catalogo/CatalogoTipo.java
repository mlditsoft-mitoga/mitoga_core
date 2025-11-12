package com.mitoga.shared.domain.catalogo;

import java.util.Objects;

/**
 * Value Object que representa el tipo de catálogo.
 * 
 * Ejemplos: categorias_tutorias, ubicaciones, tipos_documento, etc.
 * Valida que no sea nulo, no esté vacío y no exceda 100 caracteres.
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.0.0
 */
public record CatalogoTipo(String value) {

    private static final int MAX_LENGTH = 100;

    /**
     * Constructor compacto con validaciones.
     * 
     * @throws IllegalArgumentException si value es nulo, vacío o excede 100
     *                                  caracteres
     */
    public CatalogoTipo {
        Objects.requireNonNull(value, "CatalogoTipo no puede ser nulo");

        String trimmed = value.trim();
        if (trimmed.isEmpty()) {
            throw new IllegalArgumentException("CatalogoTipo no puede estar vacío");
        }

        if (trimmed.length() > MAX_LENGTH) {
            throw new IllegalArgumentException(
                    String.format("CatalogoTipo no puede exceder %d caracteres: %d",
                            MAX_LENGTH, trimmed.length()));
        }

        // Mantener el valor tal como viene (sin normalizar a minúsculas)
        // Esto permite usar TIPO_DOCUMENTO, tipos_documento, etc según la BD
        value = trimmed.replace(" ", "_");
    }

    @Override
    public String toString() {
        return value;
    }
}
