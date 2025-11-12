package com.mitoga.shared.infrastructure.api.message;

/**
 * Categoría del mensaje para filtrado y procesamiento.
 * Define las principales clasificaciones de mensajes en la aplicación.
 *
 * <p>
 * Se utiliza para:
 * </p>
 * <ul>
 * <li>Filtrar mensajes por tipo en logs</li>
 * <li>Aplicar estilos visuales en UI</li>
 * <li>Categorizar respuestas de API</li>
 * </ul>
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
public enum MessageCategory {

    /**
     * Operación exitosa.
     */
    SUCCESS("Éxito"),

    /**
     * Error en operación.
     */
    ERROR("Error"),

    /**
     * Error de validación de datos.
     */
    VALIDATION("Validación"),

    /**
     * Mensaje informativo.
     */
    INFO("Información"),

    /**
     * Advertencia no crítica.
     */
    WARNING("Advertencia");

    private final String displayName;

    MessageCategory(String displayName) {
        this.displayName = displayName;
    }

    /**
     * Obtiene el nombre para visualización.
     *
     * @return Nombre legible de la categoría
     */
    public String getDisplayName() {
        return displayName;
    }
}
