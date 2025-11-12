package com.mitoga.shared.application;

/**
 * Marker interface for Commands (CQRS Pattern).
 * 
 * <p>
 * Un Command representa una intención de cambiar el estado del sistema.
 * Es un DTO que transporta los datos necesarios para ejecutar un Use Case de
 * escritura.
 * </p>
 * 
 * <p>
 * <b>Características:</b>
 * </p>
 * <ul>
 * <li><b>Inmutable:</b> Usar Records de Java</li>
 * <li><b>Validado:</b> Con Bean Validation (@NotNull, @Email, etc.)</li>
 * <li><b>Nombrado en imperativo:</b> RegistrarUsuario, ConfirmarReserva,
 * ProcesarPago</li>
 * <li><b>Sin lógica de negocio:</b> Solo transporta datos</li>
 * </ul>
 * 
 * <p>
 * <b>Ejemplo:</b>
 * </p>
 * 
 * <pre>
 * {
 *     &#64;code
 *     public record RegistrarUsuarioCommand(
 *             &#64;NotBlank @Email String email,
 *             &#64;NotBlank @Size(min = 8) String password,
 *             &#64;NotBlank String nombre,
 *             &#64;NotBlank String apellido,
 *             &#64;NotNull RolUsuario rol) implements Command {
 *     }
 * 
 *     public record ConfirmarReservaCommand(
 *             &#64;NotNull UUID reservaId,
 *             @NotNull UUID tutorId) implements Command {
 *     }
 * }
 * </pre>
 * 
 * @author MI-TOGA Development Team
 * @see Query
 * @see UseCase
 */
public interface Command {
    // Marker interface
}
