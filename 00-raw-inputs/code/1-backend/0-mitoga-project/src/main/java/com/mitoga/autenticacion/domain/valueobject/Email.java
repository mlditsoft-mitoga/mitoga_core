package com.mitoga.autenticacion.domain.valueobject;

import com.mitoga.shared.domain.DomainException;
import com.mitoga.shared.domain.ValueObject;

import java.util.Objects;

/**
 * Value Object: Email del usuario
 * 
 * <p>
 * Validaciones según constraint DB:
 * </p>
 * <ul>
 * <li>Formato RFC 5322 simplificado:
 * ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$</li>
 * <li>No puede estar vacío (trim)</li>
 * <li>Máximo 255 caracteres</li>
 * </ul>
 * 
 * @param value Email en formato string (validado)
 */
public record Email(String value) implements ValueObject {

    private static final String EMAIL_REGEX = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$";
    private static final int MAX_LENGTH = 255;

    /**
     * Constructor compacto con validaciones domain
     */
    public Email {
        Objects.requireNonNull(value, "Email no puede ser nulo");

        String trimmed = value.trim();
        if (trimmed.isEmpty()) {
            throw new EmailInvalidoException("Email no puede estar vacío");
        }

        if (trimmed.length() > MAX_LENGTH) {
            throw new EmailInvalidoException(
                    String.format("Email excede longitud máxima de %d caracteres", MAX_LENGTH));
        }

        if (!trimmed.matches(EMAIL_REGEX)) {
            throw new EmailInvalidoException(
                    String.format("Email '%s' no tiene formato válido", trimmed));
        }

        // Normalizar a lowercase para comparaciones
        value = trimmed.toLowerCase();
    }

    /**
     * Factory method para crear Email desde string (con validación)
     */
    public static Email from(String email) {
        return new Email(email);
    }

    /**
     * Factory method para crear Email opcional (null-safe)
     */
    public static Email fromNullable(String email) {
        return email == null ? null : from(email);
    }

    /**
     * Exception específica para Email inválido
     */
    public static class EmailInvalidoException extends DomainException {
        public EmailInvalidoException(String message) {
            super(message);
        }
    }
}
