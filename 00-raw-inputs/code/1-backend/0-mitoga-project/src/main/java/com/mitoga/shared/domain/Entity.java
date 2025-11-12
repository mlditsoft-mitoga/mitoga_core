package com.mitoga.shared.domain;

import java.util.Objects;

/**
 * Base class for all Domain Entities (DDD Tactical Pattern).
 * 
 * <p>
 * Una Entity es un objeto de dominio con identidad única que persiste a través
 * del tiempo.
 * A diferencia de los Value Objects, dos entities son iguales si tienen el
 * mismo ID,
 * independientemente de sus atributos.
 * </p>
 * 
 * <p>
 * <b>Principios DDD:</b>
 * </p>
 * <ul>
 * <li><b>Identidad:</b> Cada entity tiene un ID único que la identifica</li>
 * <li><b>Continuidad:</b> La identidad persiste a través de todo el ciclo de
 * vida</li>
 * <li><b>Mutabilidad:</b> Los atributos pueden cambiar, pero la identidad
 * permanece</li>
 * <li><b>Igualdad por ID:</b> equals() y hashCode() basados solo en el ID</li>
 * </ul>
 * 
 * <p>
 * <b>Ejemplos de Entities:</b>
 * </p>
 * <ul>
 * <li>Usuario (tiene UsuarioId, puede cambiar email/nombre, pero sigue siendo
 * el mismo usuario)</li>
 * <li>Reserva (tiene ReservaId, puede cambiar estado, pero es la misma
 * reserva)</li>
 * <li>Pago (tiene PagoId único para tracking)</li>
 * </ul>
 * 
 * @param <ID> Tipo del identificador (debe ser un Value Object, ej: UsuarioId,
 *             ReservaId)
 * 
 * @author MI-TOGA Development Team
 * @see AggregateRoot
 * @see ValueObject
 */
public abstract class Entity<ID> {

    /**
     * Identificador único de la entidad (Value Object).
     * Inmutable una vez asignado.
     */
    private final ID id;

    /**
     * Constructor protegido para forzar uso en subclases.
     * 
     * @param id Identificador único (no puede ser null)
     * @throws IllegalArgumentException si el ID es null
     */
    protected Entity(ID id) {
        this.id = Objects.requireNonNull(id, "Entity ID cannot be null");
    }

    /**
     * Obtiene el identificador de la entidad.
     * 
     * @return ID único de la entidad
     */
    public ID getId() {
        return id;
    }

    /**
     * Dos entities son iguales si tienen el mismo ID (identidad).
     * Los atributos NO importan para la igualdad.
     * 
     * @param other Objeto a comparar
     * @return true si tienen el mismo ID, false en caso contrario
     */
    @Override
    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (other == null || getClass() != other.getClass()) {
            return false;
        }
        Entity<?> entity = (Entity<?>) other;
        return Objects.equals(id, entity.id);
    }

    /**
     * HashCode basado solo en el ID para mantener consistencia con equals().
     * 
     * @return hash code del ID
     */
    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    /**
     * Representación en string para debugging.
     * 
     * @return String con el tipo y el ID de la entidad
     */
    @Override
    public String toString() {
        return getClass().getSimpleName() + "[id=" + id + "]";
    }
}
