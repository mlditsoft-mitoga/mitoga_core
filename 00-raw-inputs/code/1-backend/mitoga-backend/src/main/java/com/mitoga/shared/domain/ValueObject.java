package com.mitoga.shared.domain;

/**
 * Marker interface for Value Objects (DDD Tactical Pattern).
 * 
 * <p>
 * Un Value Object es un objeto inmutable definido por sus atributos, sin
 * identidad propia.
 * Dos Value Objects son iguales si todos sus atributos son iguales.
 * </p>
 * 
 * <p>
 * <b>Características de los Value Objects:</b>
 * </p>
 * <ul>
 * <li><b>Inmutabilidad:</b> Una vez creado, no puede cambiar (thread-safe por
 * diseño)</li>
 * <li><b>Sin identidad:</b> No tiene ID, su identidad es la suma de sus
 * atributos</li>
 * <li><b>Igualdad por valor:</b> Dos VOs son iguales si sus atributos son
 * iguales</li>
 * <li><b>Validación en constructor:</b> Las reglas de negocio se validan al
 * crear el objeto</li>
 * <li><b>Reemplazables:</b> Si necesitas cambiar un atributo, creas un nuevo
 * VO</li>
 * </ul>
 * 
 * <p>
 * <b>¿Cuándo usar Value Objects?</b>
 * </p>
 * <ul>
 * <li>Conceptos del dominio que NO necesitan identidad (Email, Monto,
 * FechaHora)</li>
 * <li>Tipos que se comparan por sus valores (Dirección, Coordenadas GPS)</li>
 * <li>Objetos que encapsulan validaciones complejas (Password, IBAN, ISBN)</li>
 * <li>Primitivos del dominio que necesitan comportamiento (Temperatura,
 * Distancia)</li>
 * </ul>
 * 
 * <p>
 * <b>Implementación recomendada: Java Records (Java 14+)</b>
 * </p>
 * 
 * <pre>{@code
 * public record Email(String value) implements ValueObject {
 *     // Constructor compacto con validación
 *     public Email {
 *         Objects.requireNonNull(value, "Email no puede ser nulo");
 *         if (!value.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
 *             throw new EmailInvalidoException(value);
 *         }
 *         value = value.toLowerCase().trim();
 *     }
 * }
 * 
 * public record Monto(BigDecimal valor, Moneda moneda) implements ValueObject {
 *     public Monto {
 *         Objects.requireNonNull(valor, "Valor no puede ser nulo");
 *         Objects.requireNonNull(moneda, "Moneda no puede ser nula");
 *         if (valor.compareTo(BigDecimal.ZERO) < 0) {
 *             throw new MontoInvalidoException("El monto no puede ser negativo");
 *         }
 *     }
 * 
 *     public Monto sumar(Monto otro) {
 *         if (!this.moneda.equals(otro.moneda)) {
 *             throw new MonedasIncompatiblesException();
 *         }
 *         return new Monto(this.valor.add(otro.valor), this.moneda);
 *     }
 * }
 * }</pre>
 * 
 * <p>
 * <b>Ejemplos de Value Objects en MI-TOGA:</b>
 * </p>
 * <ul>
 * <li><code>Email</code> - Dirección de correo válida</li>
 * <li><code>Password</code> - Contraseña hasheada con BCrypt</li>
 * <li><code>UsuarioId</code> - Identificador de usuario (UUID)</li>
 * <li><code>Monto</code> - Cantidad monetaria con moneda</li>
 * <li><code>FechaHora</code> - Fecha y hora de una reserva</li>
 * <li><code>Duracion</code> - Duración de una sesión (30, 60, 90 min)</li>
 * <li><code>RangoHorario</code> - Disponibilidad de un tutor</li>
 * </ul>
 * 
 * <p>
 * <b>Ventajas de los Value Objects:</b>
 * </p>
 * <ul>
 * <li>✅ Validación centralizada (no se pueden crear objetos inválidos)</li>
 * <li>✅ Type safety (Email != String, evita errores de tipos primitivos)</li>
 * <li>✅ Inmutabilidad garantiza thread-safety sin sincronización</li>
 * <li>✅ Encapsulación de lógica de negocio (ej: sumar montos, validar
 * fechas)</li>
 * <li>✅ Self-documenting code (el tipo comunica el significado del
 * dominio)</li>
 * </ul>
 * 
 * @author MI-TOGA Development Team
 * @see Entity
 * @see AggregateRoot
 */
public interface ValueObject {
    // Marker interface - no methods required
    // Los Records de Java ya implementan equals(), hashCode(), toString()
    // correctamente
}
