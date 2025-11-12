package com.mitoga.shared.infrastructure.api.message;

/**
 * Diccionario de mensajes de éxito de la aplicación.
 * Centraliza todos los mensajes para operaciones exitosas.
 *
 * <p>
 * <strong>Convención de códigos:</strong>
 * </p>
 * <ul>
 * <li>GEN_xxx: Mensajes genéricos (CRUD)</li>
 * <li>USER_xxx: Módulo de usuarios</li>
 * <li>TUTOR_xxx: Módulo de tutores</li>
 * <li>RESERVA_xxx: Módulo de reservas</li>
 * <li>PAGO_xxx: Módulo de pagos</li>
 * </ul>
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
public enum SuccessMessage implements MessageCode {

    // ========== MENSAJES GENÉRICOS (GEN) ==========

    GEN_CREATED(
            "GEN_001",
            "Recurso creado exitosamente"),

    GEN_UPDATED(
            "GEN_002",
            "Recurso actualizado exitosamente"),

    GEN_DELETED(
            "GEN_003",
            "Recurso eliminado exitosamente"),

    GEN_RETRIEVED(
            "GEN_004",
            "Recurso recuperado exitosamente"),

    GEN_LIST_RETRIEVED(
            "GEN_005",
            "Lista recuperada exitosamente"),

    // ========== MÓDULO USUARIOS (USER) ==========

    USER_REGISTERED(
            "USER_001",
            "Usuario registrado exitosamente. Revisa tu email para activar tu cuenta"),

    USER_ACTIVATED(
            "USER_002",
            "Cuenta activada exitosamente. Ya puedes iniciar sesión"),

    USER_LOGIN_SUCCESS(
            "USER_003",
            "Inicio de sesión exitoso. Bienvenido"),

    USER_LOGOUT_SUCCESS(
            "USER_004",
            "Sesión cerrada exitosamente"),

    USER_PASSWORD_RESET_REQUESTED(
            "USER_005",
            "Se ha enviado un email con instrucciones para restablecer tu contraseña"),

    USER_PASSWORD_RESET_SUCCESS(
            "USER_006",
            "Contraseña restablecida exitosamente"),

    USER_PROFILE_UPDATED(
            "USER_007",
            "Perfil actualizado exitosamente"),

    USER_EMAIL_VERIFIED(
            "USER_008",
            "Email verificado exitosamente"),

    // ========== MÓDULO TUTORES (TUTOR) ==========

    TUTOR_PROFILE_CREATED(
            "TUTOR_001",
            "Perfil de tutor creado exitosamente. Pendiente de aprobación"),

    TUTOR_PROFILE_APPROVED(
            "TUTOR_002",
            "Perfil de tutor aprobado. Ya puedes recibir reservas"),

    TUTOR_DISPONIBILIDAD_UPDATED(
            "TUTOR_003",
            "Disponibilidad actualizada exitosamente"),

    TUTOR_ESPECIALIDAD_ADDED(
            "TUTOR_004",
            "Especialidad agregada exitosamente"),

    // ========== MÓDULO RESERVAS (RESERVA) ==========

    RESERVA_CREATED(
            "RESERVA_001",
            "Reserva creada exitosamente. Pendiente de confirmación del tutor"),

    RESERVA_CONFIRMED(
            "RESERVA_002",
            "Reserva confirmada exitosamente. Te esperamos"),

    RESERVA_CANCELLED(
            "RESERVA_003",
            "Reserva cancelada exitosamente"),

    RESERVA_COMPLETED(
            "RESERVA_004",
            "Sesión completada exitosamente. Por favor califica al tutor"),

    RESERVA_RESCHEDULED(
            "RESERVA_005",
            "Reserva reagendada exitosamente"),

    // ========== MÓDULO PAGOS (PAGO) ==========

    PAGO_PROCESSED(
            "PAGO_001",
            "Pago procesado exitosamente"),

    PAGO_REFUNDED(
            "PAGO_002",
            "Reembolso procesado exitosamente. El dinero estará disponible en 3-5 días hábiles"),

    PAGO_METHOD_ADDED(
            "PAGO_003",
            "Método de pago agregado exitosamente");

    private final String code;
    private final String message;

    SuccessMessage(String code, String message) {
        this.code = code;
        this.message = message;
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
        return MessageCategory.SUCCESS;
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
