package com.mitoga.shared.infrastructure.api.message;

/**
 * Interfaz base para todos los códigos de mensaje de la aplicación.
 * Define el contrato que deben cumplir todos los enums de mensajes.
 *
 * <p>
 * <strong>Propósito:</strong> Permitir polimorfismo con diferentes tipos de
 * mensajes
 * (success, error, validation) manteniendo type safety.
 * </p>
 *
 * <p>
 * <strong>Implementaciones:</strong>
 * </p>
 * <ul>
 * <li>{@link SuccessMessage} - Mensajes de éxito</li>
 * <li>{@link ErrorMessage} - Mensajes de error</li>
 * </ul>
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
public interface MessageCode {

    /**
     * Código único del mensaje (ej: "USER_001", "ERR_VAL_002").
     * <p>
     * Formato recomendado: [MODULO]_[NÚMERO] o ERR_[MODULO]_[NÚMERO]
     * </p>
     * 
     * @return Código alfanumérico único
     */
    String getCode();

    /**
     * Mensaje en español (idioma por defecto).
     * Puede contener placeholders para String.format().
     * 
     * @return Mensaje descriptivo en español
     */
    String getMessage();

    /**
     * Categoría del mensaje para clasificación.
     * 
     * @return Categoría (SUCCESS, ERROR, VALIDATION, INFO, WARNING)
     */
    MessageCategory getCategory();

    /**
     * Nivel de severidad del mensaje (solo para errores).
     * <p>
     * Default: {@link MessageSeverity#MEDIUM}
     * </p>
     * 
     * @return Nivel de severidad (LOW, MEDIUM, HIGH, CRITICAL)
     */
    default MessageSeverity getSeverity() {
        return MessageSeverity.MEDIUM;
    }
}
