package com.mitoga.shared.infrastructure.api.message;

/**
 * Diccionario de mensajes de error de la aplicación.
 * Centraliza todos los mensajes de error con códigos únicos y severidad.
 *
 * <p>
 * <strong>Convención de códigos:</strong>
 * </p>
 * <ul>
 * <li>ERR_GEN_xxx: Errores genéricos del sistema</li>
 * <li>ERR_AUTH_xxx: Errores de autenticación</li>
 * <li>ERR_VAL_xxx: Errores de validación</li>
 * <li>ERR_USER_xxx: Errores del módulo usuarios</li>
 * <li>ERR_TUTOR_xxx: Errores del módulo tutores</li>
 * <li>ERR_RESERVA_xxx: Errores del módulo reservas</li>
 * <li>ERR_PAGO_xxx: Errores del módulo pagos</li>
 * </ul>
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
public enum ErrorMessage implements MessageCode {

    // ========== ERRORES GENÉRICOS (ERR_GEN) ==========

    ERR_GEN_INTERNAL_SERVER(
            "ERR_GEN_001",
            "Error interno del servidor. Por favor contacte al administrador",
            MessageSeverity.CRITICAL),

    ERR_GEN_RESOURCE_NOT_FOUND(
            "ERR_GEN_002",
            "%s no encontrado con ID: %s",
            MessageSeverity.MEDIUM),

    ERR_GEN_INVALID_REQUEST(
            "ERR_GEN_003",
            "La solicitud es inválida o está mal formada",
            MessageSeverity.LOW),

    ERR_GEN_DATABASE_CONNECTION(
            "ERR_GEN_004",
            "Error de conexión con la base de datos",
            MessageSeverity.CRITICAL),

    // ========== ERRORES DE AUTENTICACIÓN (ERR_AUTH) ==========

    ERR_AUTH_INVALID_CREDENTIALS(
            "ERR_AUTH_001",
            "Email o contraseña incorrectos",
            MessageSeverity.MEDIUM),

    ERR_AUTH_TOKEN_EXPIRED(
            "ERR_AUTH_002",
            "Tu sesión ha expirado. Por favor inicia sesión nuevamente",
            MessageSeverity.MEDIUM),

    ERR_AUTH_TOKEN_INVALID(
            "ERR_AUTH_003",
            "Token de autenticación inválido",
            MessageSeverity.HIGH),

    ERR_AUTH_UNAUTHORIZED(
            "ERR_AUTH_004",
            "No tienes permisos para acceder a este recurso",
            MessageSeverity.HIGH),

    ERR_AUTH_ACCOUNT_DISABLED(
            "ERR_AUTH_005",
            "Tu cuenta está deshabilitada. Contacta al administrador",
            MessageSeverity.HIGH),

    ERR_AUTH_ACCOUNT_NOT_ACTIVATED(
            "ERR_AUTH_006",
            "Tu cuenta no está activada. Revisa tu email para activarla",
            MessageSeverity.MEDIUM),

    // ========== ERRORES DE VALIDACIÓN (ERR_VAL) ==========

    ERR_VAL_REQUIRED_FIELD(
            "ERR_VAL_001",
            "El campo '%s' es obligatorio",
            MessageSeverity.LOW),

    ERR_VAL_INVALID_EMAIL(
            "ERR_VAL_002",
            "El email '%s' no tiene formato válido",
            MessageSeverity.LOW),

    ERR_VAL_PASSWORD_TOO_SHORT(
            "ERR_VAL_003",
            "La contraseña debe tener al menos %d caracteres",
            MessageSeverity.LOW),

    ERR_VAL_PASSWORD_WEAK(
            "ERR_VAL_004",
            "La contraseña debe contener mayúsculas, minúsculas, números y caracteres especiales",
            MessageSeverity.LOW),

    ERR_VAL_DATE_INVALID(
            "ERR_VAL_005",
            "La fecha '%s' no es válida",
            MessageSeverity.LOW),

    ERR_VAL_DATE_PAST(
            "ERR_VAL_006",
            "La fecha no puede ser en el pasado",
            MessageSeverity.LOW),

    // ========== ERRORES USUARIOS (ERR_USER) ==========

    ERR_USER_EMAIL_ALREADY_EXISTS(
            "ERR_USER_001",
            "El email '%s' ya está registrado",
            MessageSeverity.MEDIUM),

    ERR_USER_NOT_FOUND(
            "ERR_USER_002",
            "Usuario no encontrado con ID: %s",
            MessageSeverity.MEDIUM),

    ERR_USER_ACTIVATION_TOKEN_INVALID(
            "ERR_USER_003",
            "El token de activación es inválido o ha expirado",
            MessageSeverity.MEDIUM),

    // ========== ERRORES TUTORES (ERR_TUTOR) ==========

    ERR_TUTOR_NOT_FOUND(
            "ERR_TUTOR_001",
            "Tutor no encontrado con ID: %s",
            MessageSeverity.MEDIUM),

    ERR_TUTOR_NOT_APPROVED(
            "ERR_TUTOR_002",
            "El tutor no está aprobado para recibir reservas",
            MessageSeverity.MEDIUM),

    ERR_TUTOR_NOT_AVAILABLE(
            "ERR_TUTOR_003",
            "El tutor no está disponible en el horario seleccionado",
            MessageSeverity.MEDIUM),

    // ========== ERRORES RESERVAS (ERR_RESERVA) ==========

    ERR_RESERVA_NOT_FOUND(
            "ERR_RESERVA_001",
            "Reserva no encontrada con ID: %s",
            MessageSeverity.MEDIUM),

    ERR_RESERVA_SLOT_NOT_AVAILABLE(
            "ERR_RESERVA_002",
            "El horario seleccionado ya no está disponible",
            MessageSeverity.MEDIUM),

    ERR_RESERVA_CANNOT_CANCEL(
            "ERR_RESERVA_003",
            "No se puede cancelar la reserva. Debe hacerse con al menos %d horas de anticipación",
            MessageSeverity.MEDIUM),

    ERR_RESERVA_ALREADY_CONFIRMED(
            "ERR_RESERVA_004",
            "La reserva ya está confirmada",
            MessageSeverity.LOW),

    // ========== ERRORES PAGOS (ERR_PAGO) ==========

    ERR_PAGO_PAYMENT_FAILED(
            "ERR_PAGO_001",
            "El pago no pudo ser procesado. Por favor intenta con otro método de pago",
            MessageSeverity.HIGH),

    ERR_PAGO_INSUFFICIENT_FUNDS(
            "ERR_PAGO_002",
            "Fondos insuficientes",
            MessageSeverity.MEDIUM),

    ERR_PAGO_INVALID_CARD(
            "ERR_PAGO_003",
            "La tarjeta es inválida o ha sido rechazada",
            MessageSeverity.MEDIUM),

    ERR_PAGO_REFUND_FAILED(
            "ERR_PAGO_004",
            "No se pudo procesar el reembolso. Por favor contacte al soporte",
            MessageSeverity.HIGH);

    private final String code;
    private final String message;
    private final MessageSeverity severity;

    ErrorMessage(String code, String message, MessageSeverity severity) {
        this.code = code;
        this.message = message;
        this.severity = severity;
    }

    @Override
    public String getCode() {
        return code;
    }

    @Override
    public String getMessage() {
        return message;
    }

    @Override
    public MessageCategory getCategory() {
        return MessageCategory.ERROR;
    }

    @Override
    public MessageSeverity getSeverity() {
        return severity;
    }

    /**
     * Factory method para crear mensaje con parámetros dinámicos.
     * Usa String.format() para interpolar parámetros en el mensaje.
     *
     * @param params Parámetros para interpolar en el mensaje
     * @return Mensaje formateado
     */
    public String format(Object... params) {
        if (params == null || params.length == 0) {
            return this.message;
        }
        return String.format(this.message, params);
    }
}
