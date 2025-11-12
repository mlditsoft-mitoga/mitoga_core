package com.mitoga.shared.domain;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Base class for Aggregate Roots (DDD Tactical Pattern).
 * 
 * <p>
 * Un Aggregate Root es una Entity especial que actúa como punto de entrada
 * único
 * para acceder a un cluster de objetos relacionados (el Aggregate). Es el
 * guardián
 * de las invariantes de consistencia del Aggregate.
 * </p>
 * 
 * <p>
 * <b>Principios de Aggregates (Eric Evans):</b>
 * </p>
 * <ul>
 * <li><b>Boundary de consistencia:</b> Define un límite transaccional
 * claro</li>
 * <li><b>Acceso exclusivo por Root:</b> Nadie accede directamente a entidades
 * internas</li>
 * <li><b>Referencias por ID:</b> Aggregates se referencian entre sí solo por
 * ID, no por objeto</li>
 * <li><b>Transacciones pequeñas:</b> Una transacción modifica un solo
 * Aggregate</li>
 * <li><b>Consistencia eventual entre Aggregates:</b> Usa Domain Events para
 * sincronización</li>
 * </ul>
 * 
 * <p>
 * <b>¿Cuándo es un Aggregate Root?</b>
 * </p>
 * <ul>
 * <li>Tiene identidad independiente (no es parte de otro objeto)</li>
 * <li>Tiene ciclo de vida propio (se crea, modifica, elimina
 * independientemente)</li>
 * <li>Encapsula invariantes de negocio (ej: Reserva no puede tener precio
 * negativo)</li>
 * <li>Publica Domain Events cuando cambia su estado</li>
 * </ul>
 * 
 * <p>
 * <b>Ejemplos de Aggregate Roots en MI-TOGA:</b>
 * </p>
 * <ul>
 * <li><b>Usuario:</b> Raíz del aggregate {Usuario, Perfil, Preferencias}</li>
 * <li><b>Tutor:</b> Raíz del aggregate {Tutor, Especialidades,
 * Disponibilidad}</li>
 * <li><b>Reserva:</b> Raíz del aggregate {Reserva, Sesión, Calificación}</li>
 * <li><b>Pago:</b> Raíz del aggregate {Pago, Reembolso, TransacciónStripe}</li>
 * </ul>
 * 
 * <p>
 * <b>Domain Events:</b>
 * </p>
 * <p>
 * Los Aggregate Roots publican eventos de dominio cuando ocurren cambios
 * importantes:
 * </p>
 * 
 * <pre>{@code
 * public class Reserva extends AggregateRoot<ReservaId> {
 * 
 *     public void confirmar() {
 *         if (this.estado != EstadoReserva.PENDIENTE) {
 *             throw new ReservaYaConfirmadaException(getId());
 *         }
 *         this.estado = EstadoReserva.CONFIRMADA;
 *         this.fechaConfirmacion = LocalDateTime.now();
 * 
 *         // Domain Event: Notificar a otros Bounded Contexts
 *         registerEvent(new ReservaConfirmada(
 *                 getId(),
 *                 getEstudianteId(),
 *                 getTutorId(),
 *                 LocalDateTime.now()));
 *     }
 * }
 * }</pre>
 * 
 * @param <ID> Tipo del identificador del Aggregate Root (Value Object)
 * 
 * @author MI-TOGA Development Team
 * @see Entity
 * @see DomainEvent
 * @see ValueObject
 */
public abstract class AggregateRoot<ID> extends Entity<ID> {

    /**
     * Lista de Domain Events pendientes de publicación.
     * Se registran durante la ejecución de métodos de negocio y se publican
     * después del commit de la transacción.
     */
    private final List<DomainEvent> domainEvents = new ArrayList<>();

    /**
     * Constructor protegido.
     * 
     * @param id Identificador único del Aggregate Root
     */
    protected AggregateRoot(ID id) {
        super(id);
    }

    /**
     * Registra un Domain Event que será publicado tras el commit.
     * 
     * <p>
     * Los eventos se publican DESPUÉS de que la transacción persista exitosamente,
     * garantizando consistencia (no se publican eventos si la transacción falla).
     * </p>
     * 
     * @param event Domain Event a registrar
     */
    protected void registerEvent(DomainEvent event) {
        if (event != null) {
            this.domainEvents.add(event);
        }
    }

    /**
     * Obtiene los Domain Events pendientes de publicación (inmutable).
     * 
     * @return Lista inmutable de eventos
     */
    public List<DomainEvent> getDomainEvents() {
        return Collections.unmodifiableList(domainEvents);
    }

    /**
     * Limpia los Domain Events ya publicados.
     * 
     * <p>
     * Este método es invocado por la infraestructura después de publicar
     * los eventos exitosamente, evitando re-publicaciones.
     * </p>
     */
    public void clearDomainEvents() {
        this.domainEvents.clear();
    }

    /**
     * Indica si el Aggregate tiene Domain Events pendientes.
     * 
     * @return true si hay eventos pendientes, false en caso contrario
     */
    public boolean hasDomainEvents() {
        return !domainEvents.isEmpty();
    }
}
