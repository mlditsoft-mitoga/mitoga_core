package com.mitoga.shared.infrastructure.api.exception;

/**
 * Excepción de dominio para recursos no encontrados.
 * Se lanza cuando se intenta acceder a un recurso que no existe en el sistema.
 *
 * <p>
 * Esta excepción genera respuestas HTTP 404 Not Found cuando es
 * capturada por {@link GlobalExceptionHandler}.
 * </p>
 *
 * <p>
 * Ejemplo de uso:
 * </p>
 * 
 * <pre>
 * throw new ResourceNotFoundException("Usuario", usuarioId.value());
 * </pre>
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
public class ResourceNotFoundException extends RuntimeException {

    /**
     * Constructor con mensaje personalizado.
     *
     * @param message Mensaje descriptivo del error
     */
    public ResourceNotFoundException(String message) {
        super(message);
    }

    /**
     * Constructor convenience para recursos con ID.
     *
     * @param resourceType Tipo de recurso (ej: "Usuario", "Tutor")
     * @param identifier   Identificador del recurso
     */
    public ResourceNotFoundException(String resourceType, String identifier) {
        super(String.format("%s no encontrado con ID: %s", resourceType, identifier));
    }

    /**
     * Constructor con mensaje y causa.
     *
     * @param message Mensaje descriptivo
     * @param cause   Causa raíz
     */
    public ResourceNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }
}
