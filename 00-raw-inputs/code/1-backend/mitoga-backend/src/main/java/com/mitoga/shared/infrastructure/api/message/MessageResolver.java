package com.mitoga.shared.infrastructure.api.message;

import org.springframework.stereotype.Component;

/**
 * Resolutor de mensajes para uso en servicios y controllers.
 * Proporciona métodos helper para trabajar con enums de mensajes.
 *
 * <p>
 * Preparado para internacionalización futura con MessageSource.
 * </p>
 *
 * <p>
 * <strong>Uso típico:</strong>
 * </p>
 * 
 * <pre>
 * &#64;Service
 * &#64;RequiredArgsConstructor
 * public class UsuarioService {
 *     private final MessageResolver messageResolver;
 * 
 *     public void validarEmail(String email) {
 *         if (existeEmail(email)) {
 *             String message = messageResolver.resolve(
 *                     ErrorMessage.ERR_USER_EMAIL_ALREADY_EXISTS,
 *                     email);
 *             throw new ConflictException(message);
 *         }
 *     }
 * }
 * </pre>
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
@Component
public class MessageResolver {

    /**
     * Resuelve mensaje de éxito con parámetros.
     * Si no se proporcionan parámetros, retorna el mensaje original.
     *
     * @param message Enum de mensaje de éxito
     * @param params  Parámetros para interpolar (opcional)
     * @return Mensaje formateado
     */
    public String resolve(SuccessMessage message, Object... params) {
        if (params == null || params.length == 0) {
            return message.getMessage();
        }
        return message.format(params);
    }

    /**
     * Resuelve mensaje de error con parámetros.
     * Si no se proporcionan parámetros, retorna el mensaje original.
     *
     * @param message Enum de mensaje de error
     * @param params  Parámetros para interpolar (opcional)
     * @return Mensaje formateado
     */
    public String resolve(ErrorMessage message, Object... params) {
        if (params == null || params.length == 0) {
            return message.getMessage();
        }
        return message.format(params);
    }

    /**
     * Obtiene código del mensaje para logging/tracking.
     * Útil para correlacionar errores en logs y monitoreo.
     *
     * <p>
     * <strong>Ejemplo:</strong>
     * </p>
     * 
     * <pre>
     * log.error("Payment failed [{}]: {}",
     *         messageResolver.getCode(ErrorMessage.ERR_PAGO_PAYMENT_FAILED),
     *         ex.getMessage());
     * </pre>
     *
     * @param message Mensaje (SuccessMessage o ErrorMessage)
     * @return Código único del mensaje
     */
    public String getCode(MessageCode message) {
        return message.getCode();
    }

    /**
     * Obtiene severidad del error para alertas y priorización.
     * Solo aplicable a mensajes de error.
     *
     * <p>
     * <strong>Ejemplo:</strong>
     * </p>
     * 
     * <pre>
     * MessageSeverity severity = messageResolver.getSeverity(errorMessage);
     * if (severity == MessageSeverity.CRITICAL) {
     *     alertingService.sendAlert("Critical error detected");
     * }
     * </pre>
     *
     * @param message Mensaje de error
     * @return Nivel de severidad (LOW, MEDIUM, HIGH, CRITICAL)
     */
    public MessageSeverity getSeverity(ErrorMessage message) {
        return message.getSeverity();
    }
}
