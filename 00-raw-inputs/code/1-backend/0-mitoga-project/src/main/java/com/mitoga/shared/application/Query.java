package com.mitoga.shared.application;

/**
 * Marker interface for Queries (CQRS Pattern).
 * 
 * <p>
 * Un Query representa una intención de leer datos del sistema SIN modificar su
 * estado.
 * Es un DTO que transporta criterios de búsqueda/filtrado.
 * </p>
 * 
 * <p>
 * <b>Características:</b>
 * </p>
 * <ul>
 * <li><b>Inmutable:</b> Usar Records de Java</li>
 * <li><b>Idempotente:</b> Ejecutarlo N veces da el mismo resultado</li>
 * <li><b>Nombrado con pregunta:</b> BuscarTutores, ObtenerReserva,
 * ListarCategorias</li>
 * <li><b>Sin side-effects:</b> No cambia el estado del sistema</li>
 * </ul>
 * 
 * <p>
 * <b>Ejemplo:</b>
 * </p>
 * 
 * <pre>{@code
 * public record BuscarTutoresQuery(
 *         UUID categoriaId,
 *         BigDecimal precioMinimo,
 *         BigDecimal precioMaximo,
 *         List<String> idiomas,
 *         int page,
 *         int size) implements Query {
 * }
 * 
 * public record ObtenerReservaQuery(
 *         @NotNull UUID reservaId) implements Query {
 * }
 * }</pre>
 * 
 * @author MI-TOGA Development Team
 * @see Command
 * @see UseCase
 */
public interface Query {
    // Marker interface
}
