package com.mitoga.autenticacion.domain.valueobject;

import com.mitoga.shared.domain.DomainException;
import com.mitoga.shared.domain.ValueObject;

import java.util.Arrays;
import java.util.Objects;

/**
 * Value Object: Estado de la cuenta del usuario
 * 
 * <p>
 * Estados válidos según constraint DB:
 * </p>
 * <ul>
 * <li><b>PENDIENTE_VERIFICACION</b>: Usuario registrado, email no verificado
 * (estado inicial)</li>
 * <li><b>ACTIVO</b>: Usuario verificado y activo</li>
 * <li><b>INACTIVO</b>: Usuario temporalmente inactivo (puede reactivarse)</li>
 * <li><b>SUSPENDIDO</b>: Suspendido por violación términos/política</li>
 * <li><b>BLOQUEADO</b>: Bloqueado por múltiples intentos fallidos login</li>
 * <li><b>ELIMINADO</b>: Soft delete (expiration_date NOT NULL)</li>
 * </ul>
 * 
 * <p>
 * <b>Transiciones válidas:</b>
 * </p>
 * <ul>
 * <li>PENDIENTE_VERIFICACION → ACTIVO (verificación email)</li>
 * <li>ACTIVO ↔ INACTIVO (suspensión temporal)</li>
 * <li>ACTIVO → SUSPENDIDO (violación políticas)</li>
 * <li>ACTIVO → BLOQUEADO (intentos fallidos)</li>
 * <li>* → ELIMINADO (soft delete irreversible)</li>
 * </ul>
 */
public enum EstadoCuenta implements ValueObject {

    PENDIENTE_VERIFICACION("Usuario registrado, pendiente verificación email"),
    ACTIVO("Usuario verificado y activo"),
    INACTIVO("Usuario temporalmente inactivo"),
    SUSPENDIDO("Usuario suspendido por violación políticas"),
    BLOQUEADO("Usuario bloqueado por intentos fallidos login"),
    ELIMINADO("Usuario eliminado (soft delete)");

    private final String descripcion;

    EstadoCuenta(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getDescripcion() {
        return descripcion;
    }

    /**
     * Factory method para crear EstadoCuenta desde string (case-insensitive)
     */
    public static EstadoCuenta from(String value) {
        Objects.requireNonNull(value, "EstadoCuenta no puede ser nulo");

        try {
            return EstadoCuenta.valueOf(value.toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new EstadoCuentaInvalidoException(
                    String.format("Estado cuenta '%s' no es válido. Valores permitidos: %s",
                            value, Arrays.toString(EstadoCuenta.values())));
        }
    }

    /**
     * Verifica si el estado permite login
     */
    public boolean permiteLogin() {
        return this == ACTIVO;
    }

    /**
     * Verifica si el estado requiere verificación email
     */
    public boolean requiereVerificacion() {
        return this == PENDIENTE_VERIFICACION;
    }

    /**
     * Verifica si el estado es terminal (no permite transiciones)
     */
    public boolean esEstadoTerminal() {
        return this == ELIMINADO;
    }

    /**
     * Verifica si el estado permite reactivación
     */
    public boolean permiteReactivacion() {
        return this == INACTIVO || this == SUSPENDIDO || this == BLOQUEADO;
    }

    /**
     * Valida transición de estado (reglas de negocio)
     * 
     * @param nuevoEstado Estado destino
     * @throws TransicionEstadoInvalidaException Si la transición no es válida
     */
    public void validarTransicion(EstadoCuenta nuevoEstado) {
        Objects.requireNonNull(nuevoEstado, "Nuevo estado no puede ser nulo");

        // ELIMINADO es terminal, no permite transiciones
        if (this.esEstadoTerminal()) {
            throw new TransicionEstadoInvalidaException(
                    String.format("No se puede cambiar estado desde %s (estado terminal)", this));
        }

        // Validar transiciones específicas
        boolean transicionValida = switch (this) {
            case PENDIENTE_VERIFICACION -> nuevoEstado == ACTIVO || nuevoEstado == ELIMINADO;
            case ACTIVO -> nuevoEstado == INACTIVO || nuevoEstado == SUSPENDIDO
                    || nuevoEstado == BLOQUEADO || nuevoEstado == ELIMINADO;
            case INACTIVO -> nuevoEstado == ACTIVO || nuevoEstado == ELIMINADO;
            case SUSPENDIDO -> nuevoEstado == ACTIVO || nuevoEstado == ELIMINADO;
            case BLOQUEADO -> nuevoEstado == ACTIVO || nuevoEstado == ELIMINADO;
            case ELIMINADO -> false; // Ya validado arriba
        };

        if (!transicionValida) {
            throw new TransicionEstadoInvalidaException(
                    String.format("Transición de estado inválida: %s → %s", this, nuevoEstado));
        }
    }

    /**
     * Exception para estado cuenta inválido
     */
    public static class EstadoCuentaInvalidoException extends DomainException {
        public EstadoCuentaInvalidoException(String message) {
            super(message);
        }
    }

    /**
     * Exception para transición de estado inválida
     */
    public static class TransicionEstadoInvalidaException extends DomainException {
        public TransicionEstadoInvalidaException(String message) {
            super(message);
        }
    }
}
