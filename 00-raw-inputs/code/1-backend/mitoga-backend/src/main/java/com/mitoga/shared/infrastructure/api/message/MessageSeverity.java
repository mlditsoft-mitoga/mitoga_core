package com.mitoga.shared.infrastructure.api.message;

/**
 * Nivel de severidad para mensajes de error.
 * Define la criticidad de un error para priorización y alertas.
 *
 * <p>
 * <strong>Niveles de severidad:</strong>
 * </p>
 * <ul>
 * <li><strong>LOW:</strong> Errores de validación, campos faltantes</li>
 * <li><strong>MEDIUM:</strong> Recursos no encontrados, conflictos de
 * negocio</li>
 * <li><strong>HIGH:</strong> Errores de autenticación/autorización</li>
 * <li><strong>CRITICAL:</strong> Errores de sistema, BD, servicios
 * externos</li>
 * </ul>
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
public enum MessageSeverity {

    /**
     * Severidad baja - errores de validación de entrada.
     */
    LOW("Baja"),

    /**
     * Severidad media - errores de negocio recuperables.
     */
    MEDIUM("Media"),

    /**
     * Severidad alta - errores de seguridad.
     */
    HIGH("Alta"),

    /**
     * Severidad crítica - errores de sistema.
     */
    CRITICAL("Crítica");

    private final String displayName;

    MessageSeverity(String displayName) {
        this.displayName = displayName;
    }

    /**
     * Obtiene el nombre para visualización.
     *
     * @return Nombre legible de la severidad
     */
    public String getDisplayName() {
        return displayName;
    }
}
