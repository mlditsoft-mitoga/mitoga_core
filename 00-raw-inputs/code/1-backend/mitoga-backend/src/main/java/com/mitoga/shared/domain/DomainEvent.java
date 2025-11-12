package com.mitoga.shared.domain;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Base interface for Domain Events (DDD Tactical Pattern).
 * 
 * <p>
 * Un Domain Event representa un hecho importante que ocurrió en el dominio y
 * que
 * es relevante para el negocio. Los eventos son inmutables (pasado, ya
 * ocurrieron)
 * y se utilizan para comunicación asíncrona entre Bounded Contexts.
 * </p>
 * 
 * <p>
 * <b>Características de los Domain Events:</b>
 * </p>
 * <ul>
 * <li><b>Pasado perfecto:</b> Nombrados en pasado (UsuarioRegistrado,
 * ReservaConfirmada)</li>
 * <li><b>Inmutabilidad:</b> Una vez creado, no puede cambiar (es un hecho
 * histórico)</li>
 * <li><b>Timestamp:</b> Cada evento lleva la fecha/hora en que ocurrió</li>
 * <li><b>Identificador:</b> UUID único para tracking y deduplicación</li>
 * <li><b>Sin lógica de negocio:</b> Solo transportan datos (DTOs del
 * dominio)</li>
 * </ul>
 * 
 * <p>
 * <b>¿Cuándo usar Domain Events?</b>
 * </p>
 * <ul>
 * <li>Comunicación asíncrona entre Bounded Contexts (Reserva →
 * Notificaciones)</li>
 * <li>Auditoría y trazabilidad (Event Sourcing)</li>
 * <li>Integración con sistemas externos (Stripe, Agora, SendGrid)</li>
 * <li>Activar side-effects sin acoplamiento (enviar email al registrar
 * usuario)</li>
 * <li>CQRS (Command Query Responsibility Segregation)</li>
 * </ul>
 * 
 * <p>
 * <b>Ejemplo de implementación con Record:</b>
 * </p>
 * 
 * <pre>{@code
 * public record UsuarioRegistrado(
 *         UUID eventId,
 *         LocalDateTime occurredOn,
 *         UUID usuarioId,
 *         String email,
 *         String nombreCompleto,
 *         RolUsuario rol) implements DomainEvent {
 * 
 *     // Factory method
 *     public static UsuarioRegistrado of(Usuario usuario) {
 *         return new UsuarioRegistrado(
 *                 UUID.randomUUID(),
 *                 LocalDateTime.now(),
 *                 usuario.getId().value(),
 *                 usuario.getEmail().value(),
 *                 usuario.getNombreCompleto(),
 *                 usuario.getRol());
 *     }
 * }
 * 
 * public record ReservaConfirmada(
 *         UUID eventId,
 *         LocalDateTime occurredOn,
 *         UUID reservaId,
 *         UUID estudianteId,
 *         UUID tutorId,
 *         LocalDateTime fechaInicio) implements DomainEvent {
 * 
 *     public static ReservaConfirmada of(Reserva reserva) {
 *         return new ReservaConfirmada(
 *                 UUID.randomUUID(),
 *                 LocalDateTime.now(),
 *                 reserva.getId().value(),
 *                 reserva.getEstudianteId().value(),
 *                 reserva.getTutorId().value(),
 *                 reserva.getFechaInicio());
 *     }
 * }
 * }</pre>
 * 
 * <p>
 * <b>Flujo de Domain Events en MI-TOGA:</b>
 * </p>
 * 
 * <pre>
 * 1. Use Case ejecuta método de negocio en Aggregate Root
 *    → reserva.confirmar()
 * 
 * 2. Aggregate Root registra Domain Event
 *    → registerEvent(new ReservaConfirmada(...))
 * 
 * 3. Repository persiste el Aggregate (transacción)
 *    → reservaRepository.save(reserva)
 * 
 * 4. Infrastructure publica eventos (@TransactionalEventListener)
 *    → eventPublisher.publish(reserva.getDomainEvents())
 * 
 * 5. Event Handlers reaccionan asíncronamente
 *    → NotificacionesEventHandler escucha ReservaConfirmada
 *    → Envía email al estudiante y al tutor
 * </pre>
 * 
 * <p>
 * <b>Ejemplos de Domain Events en MI-TOGA:</b>
 * </p>
 * <ul>
 * <li><code>UsuarioRegistrado</code> → Enviar email de bienvenida</li>
 * <li><code>ReservaConfirmada</code> → Notificar estudiante y tutor</li>
 * <li><code>PagoAprobado</code> → Confirmar reserva automáticamente</li>
 * <li><code>SesionFinalizada</code> → Solicitar calificación</li>
 * <li><code>TutorAprobado</code> → Activar perfil en Marketplace</li>
 * </ul>
 * 
 * <p>
 * <b>Ventajas de Domain Events:</b>
 * </p>
 * <ul>
 * <li>✅ Desacoplamiento entre Bounded Contexts</li>
 * <li>✅ Auditoría automática (Event Store)</li>
 * <li>✅ Escalabilidad (procesamiento asíncrono)</li>
 * <li>✅ Extensibilidad (nuevos handlers sin modificar código existente)</li>
 * <li>✅ Resiliencia (retry, dead letter queue)</li>
 * </ul>
 * 
 * @author MI-TOGA Development Team
 * @see AggregateRoot
 * @see ValueObject
 */
public interface DomainEvent {

    /**
     * Identificador único del evento (para deduplicación y tracking).
     * 
     * @return UUID del evento
     */
    UUID eventId();

    /**
     * Timestamp de cuándo ocurrió el evento en el dominio.
     * 
     * @return Fecha y hora del evento
     */
    LocalDateTime occurredOn();
}
