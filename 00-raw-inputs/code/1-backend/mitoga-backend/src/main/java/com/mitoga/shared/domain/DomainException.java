package com.mitoga.shared.domain;

/**
 * Base class for Domain Exceptions (DDD Tactical Pattern).
 * 
 * <p>
 * Las Domain Exceptions representan violaciones de reglas de negocio en el
 * dominio.
 * Son diferentes de las excepciones técnicas (IOException, SQLException) porque
 * comunican problemas del lenguaje ubicuo del negocio.
 * </p>
 * 
 * <p>
 * <b>Características:</b>
 * </p>
 * <ul>
 * <li><b>Lenguaje ubicuo:</b> Nombradas según términos del negocio</li>
 * <li><b>Checked vs Unchecked:</b> Extienden RuntimeException (unchecked)</li>
 * <li><b>Fail Fast:</b> Se lanzan inmediatamente al detectar violación</li>
 * <li><b>Semántica de negocio:</b> Comunican "por qué" falló, no "cómo"</li>
 * </ul>
 * 
 * <p>
 * <b>¿Cuándo lanzar Domain Exceptions?</b>
 * </p>
 * <ul>
 * <li>Violación de invariantes del Aggregate (precio negativo, fecha
 * pasada)</li>
 * <li>Transiciones de estado inválidas (confirmar reserva ya confirmada)</li>
 * <li>Validaciones de Value Objects (email inválido, monto negativo)</li>
 * <li>Business rules específicas (tutor no puede reservar consigo mismo)</li>
 * </ul>
 * 
 * <p>
 * <b>Nomenclatura recomendada:</b>
 * </p>
 * <ul>
 * <li><code>ReservaNoEncontradaException</code> (entidad no existe)</li>
 * <li><code>ReservaYaConfirmadaException</code> (transición de estado
 * inválida)</li>
 * <li><code>FechaReservaInvalidaException</code> (regla de negocio)</li>
 * <li><code>PrecioNegativoException</code> (validación de valor)</li>
 * <li><code>EmailInvalidoException</code> (formato incorrecto)</li>
 * </ul>
 * 
 * <p>
 * <b>Ejemplo de uso:</b>
 * </p>
 * 
 * <pre>{@code
 * public class Reserva extends AggregateRoot<ReservaId> {
 * 
 *     public void confirmar() {
 *         // Validar precondiciones (fail fast)
 *         if (this.estado != EstadoReserva.PENDIENTE) {
 *             throw new ReservaYaConfirmadaException(
 *                     "No se puede confirmar una reserva en estado: " + this.estado);
 *         }
 * 
 *         if (this.fechaInicio.isBefore(LocalDateTime.now())) {
 *             throw new FechaReservaInvalidaException(
 *                     "No se puede confirmar una reserva con fecha pasada");
 *         }
 * 
 *         // Ejecutar lógica de negocio
 *         this.estado = EstadoReserva.CONFIRMADA;
 *         this.fechaConfirmacion = LocalDateTime.now();
 *         registerEvent(new ReservaConfirmada(getId(), LocalDateTime.now()));
 *     }
 * }
 * 
 * // Excepciones específicas
 * public class ReservaYaConfirmadaException extends DomainException {
 *     public ReservaYaConfirmadaException(String message) {
 *         super(message);
 *     }
 * }
 * 
 * public class FechaReservaInvalidaException extends DomainException {
 *     public FechaReservaInvalidaException(String message) {
 *         super(message);
 *     }
 * }
 * }</pre>
 * 
 * <p>
 * <b>Manejo en capas superiores:</b>
 * </p>
 * 
 * <pre>
 * {@code
 * // Application Layer (Use Case)
 * public class ConfirmarReservaService implements ConfirmarReservaUseCase {
 *     
 *     &#64;Override
 *     public ReservaResponse execute(ConfirmarReservaCommand command) {
 *         try {
 *             Reserva reserva = repository.findById(command.reservaId())
 *                 .orElseThrow(() -> new ReservaNoEncontradaException(...));
 *             
 *             reserva.confirmar();  // Puede lanzar DomainException
 *             
 *             repository.save(reserva);
 *             return mapper.toResponse(reserva);
 *             
 *         } catch (ReservaYaConfirmadaException | FechaReservaInvalidaException ex) {
 *             // Capturar excepciones de dominio específicas si se necesita lógica especial
 *             log.warn("Error de negocio al confirmar reserva: {}", ex.getMessage());
 *             throw ex;  // Re-lanzar para que GlobalExceptionHandler lo maneje
 *         }
 *     }
 * }
 * 
 * // Infrastructure Layer (REST Controller)
 * &#64;RestControllerAdvice
 * public class GlobalExceptionHandler {
 *     
 *     @ExceptionHandler(DomainException.class)
 *     public ResponseEntity<ApiResponse> handleDomainException(DomainException ex) {
 *         return ResponseEntity
 *             .badRequest()
 *             .body(ApiResponse.error(ex.getMessage()));
 *     }
 * }
 * }
 * </pre>
 * 
 * <p>
 * <b>Ejemplos de Domain Exceptions en MI-TOGA:</b>
 * </p>
 * <ul>
 * <li><code>UsuarioYaExisteException</code> - Email duplicado</li>
 * <li><code>CredencialesInvalidasException</code> - Login fallido</li>
 * <li><code>ReservaNoDisponibleException</code> - Horario ocupado</li>
 * <li><code>PagoRechazadoException</code> - Stripe rechazó el pago</li>
 * <li><code>MontoInsuficienteException</code> - Saldo insuficiente</li>
 * </ul>
 * 
 * <p>
 * <b>Ventajas de Domain Exceptions:</b>
 * </p>
 * <ul>
 * <li>✅ Comunicación clara de problemas de negocio</li>
 * <li>✅ Fail Fast: errores detectados inmediatamente</li>
 * <li>✅ Type-safe: catch específico por tipo de error</li>
 * <li>✅ Self-documenting: el nombre explica el problema</li>
 * <li>✅ Centralización del manejo en GlobalExceptionHandler</li>
 * </ul>
 * 
 * @author MI-TOGA Development Team
 * @see AggregateRoot
 * @see ValueObject
 */
public abstract class DomainException extends RuntimeException {

    /**
     * Constructor con mensaje de error.
     * 
     * @param message Mensaje descriptivo del error de negocio
     */
    protected DomainException(String message) {
        super(message);
    }

    /**
     * Constructor con mensaje y causa raíz.
     * 
     * @param message Mensaje descriptivo del error de negocio
     * @param cause   Excepción que causó este error
     */
    protected DomainException(String message, Throwable cause) {
        super(message, cause);
    }
}
