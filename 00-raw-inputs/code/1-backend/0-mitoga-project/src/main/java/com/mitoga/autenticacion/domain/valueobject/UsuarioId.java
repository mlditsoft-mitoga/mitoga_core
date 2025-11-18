package com.mitoga.autenticacion.domain.valueobject;

import com.mitoga.shared.domain.ValueObject;

import java.util.Objects;
import java.util.UUID;

/**
 * Value Object: Identificador único del usuario
 * 
 * <p>
 * Wraps UUID para type safety y domain semantics.
 * </p>
 * <p>
 * Corresponde a la columna pkid_usuarios (UUID PRIMARY KEY).
 * </p>
 * 
 * @param value UUID del usuario
 */
public record UsuarioId(UUID value) implements ValueObject {

    /**
     * Constructor compacto con validación
     */
    public UsuarioId {
        Objects.requireNonNull(value, "UsuarioId no puede ser nulo");
    }

    /**
     * Factory method para generar nuevo UsuarioId (UUID random)
     */
    public static UsuarioId generate() {
        return new UsuarioId(UUID.randomUUID());
    }

    /**
     * Factory method para crear UsuarioId desde UUID existente
     */
    public static UsuarioId from(UUID uuid) {
        return new UsuarioId(uuid);
    }

    /**
     * Factory method para crear UsuarioId desde string UUID
     */
    public static UsuarioId from(String uuid) {
        Objects.requireNonNull(uuid, "UUID string no puede ser nulo");
        try {
            return new UsuarioId(UUID.fromString(uuid));
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException(
                    String.format("String '%s' no es un UUID válido", uuid), e);
        }
    }

    @Override
    public String toString() {
        return value.toString();
    }
}
