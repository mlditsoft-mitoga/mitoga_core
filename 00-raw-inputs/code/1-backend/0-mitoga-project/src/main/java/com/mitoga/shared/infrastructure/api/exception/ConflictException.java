package com.mitoga.shared.infrastructure.api.exception;

/**
 * Excepción de dominio para conflictos de negocio.
 * Se lanza cuando una operación viola una regla de negocio o constraint.
 *
 * <p>
 * Esta excepción genera respuestas HTTP 409 Conflict cuando es
 * capturada por {@link GlobalExceptionHandler}.
 * </p>
 *
 * <p>
 * Ejemplos de uso:
 * </p>
 * <ul>
 * <li>Email duplicado en registro</li>
 * <li>Reserva en horario ya ocupado</li>
 * <li>Acción no permitida por estado del aggregate</li>
 * </ul>
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
public class ConflictException extends RuntimeException {

    /**
     * Constructor con mensaje personalizado.
     *
     * @param message Mensaje descriptivo del conflicto
     */
    public ConflictException(String message) {
        super(message);
    }

    /**
     * Constructor con mensaje y causa.
     *
     * @param message Mensaje descriptivo
     * @param cause   Causa raíz
     */
    public ConflictException(String message, Throwable cause) {
        super(message, cause);
    }
}
