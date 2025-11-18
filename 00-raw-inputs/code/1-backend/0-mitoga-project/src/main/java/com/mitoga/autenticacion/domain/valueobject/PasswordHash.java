package com.mitoga.autenticacion.domain.valueobject;

import com.mitoga.shared.domain.DomainException;
import com.mitoga.shared.domain.ValueObject;

import java.util.Objects;

/**
 * Value Object: Password Hash del usuario
 * 
 * <p>
 * Validaciones según constraint DB:
 * </p>
 * <ul>
 * <li>Longitud mínima: 50 caracteres (hash BCrypt/Argon2)</li>
 * <li>No puede estar vacío (trim)</li>
 * <li>Máximo 255 caracteres</li>
 * </ul>
 * 
 * <p>
 * <b>IMPORTANTE:</b> Este Value Object almacena el HASH, no el password en
 * texto plano.
 * </p>
 * <p>
 * El hashing debe hacerse en el Application Service con BCrypt/Argon2.
 * </p>
 * 
 * @param value Hash del password (BCrypt: $2a$10$..., Argon2: $argon2id$...)
 */
public record PasswordHash(String value) implements ValueObject {

    private static final int MIN_LENGTH = 50;
    private static final int MAX_LENGTH = 255;

    /**
     * Constructor compacto con validaciones domain
     */
    public PasswordHash {
        Objects.requireNonNull(value, "PasswordHash no puede ser nulo");

        String trimmed = value.trim();
        if (trimmed.isEmpty()) {
            throw new PasswordHashInvalidoException("PasswordHash no puede estar vacío");
        }

        if (trimmed.length() < MIN_LENGTH) {
            throw new PasswordHashInvalidoException(
                    String.format("PasswordHash debe tener al menos %d caracteres (hash válido)", MIN_LENGTH));
        }

        if (trimmed.length() > MAX_LENGTH) {
            throw new PasswordHashInvalidoException(
                    String.format("PasswordHash excede longitud máxima de %d caracteres", MAX_LENGTH));
        }

        value = trimmed;
    }

    /**
     * Factory method para crear PasswordHash desde string hash
     */
    public static PasswordHash from(String hash) {
        return new PasswordHash(hash);
    }

    /**
     * Verifica si el hash corresponde a un algoritmo BCrypt
     * BCrypt format: $2a$10$... o $2b$12$...
     */
    public boolean isBCrypt() {
        return value.startsWith("$2a$") || value.startsWith("$2b$") || value.startsWith("$2y$");
    }

    /**
     * Verifica si el hash corresponde a un algoritmo Argon2
     * Argon2 format: $argon2id$... o $argon2i$... o $argon2d$...
     */
    public boolean isArgon2() {
        return value.startsWith("$argon2");
    }

    /**
     * Exception específica para PasswordHash inválido
     */
    public static class PasswordHashInvalidoException extends DomainException {
        public PasswordHashInvalidoException(String message) {
            super(message);
        }
    }
}
