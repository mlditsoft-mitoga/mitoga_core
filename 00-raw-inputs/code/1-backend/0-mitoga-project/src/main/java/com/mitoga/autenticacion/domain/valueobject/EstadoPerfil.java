package com.mitoga.autenticacion.domain.valueobject;

import com.mitoga.shared.domain.ValueObject;

/**
 * Value Object: Estado de un perfil de usuario
 * 
 * <p>
 * Define los posibles estados en el ciclo de vida de un perfil.
 * </p>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
public enum EstadoPerfil implements ValueObject {
    
    /**
     * Perfil activo y operativo
     */
    ACTIVO("Activo", "Perfil habilitado para uso normal"),
    
    /**
     * Perfil temporalmente desactivado por el usuario
     */
    INACTIVO("Inactivo", "Perfil desactivado temporalmente"),
    
    /**
     * Perfil suspendido por razones administrativas
     */
    SUSPENDIDO("Suspendido", "Perfil bloqueado por incumplimiento o revisión");
    
    private final String nombreVisual;
    private final String descripcion;
    
    EstadoPerfil(String nombreVisual, String descripcion) {
        this.nombreVisual = nombreVisual;
        this.descripcion = descripcion;
    }
    
    public String getNombreVisual() {
        return nombreVisual;
    }
    
    public String getDescripcion() {
        return descripcion;
    }
    
    /**
     * Verifica si el perfil puede realizar acciones
     * 
     * @return true si está ACTIVO
     */
    public boolean puedeOperar() {
        return this == ACTIVO;
    }
    
    /**
     * Valida si la transición a otro estado es permitida
     * 
     * @param estadoDestino Estado al que se quiere transicionar
     * @return true si la transición es válida
     */
    public boolean puedeTransicionarA(EstadoPerfil estadoDestino) {
        if (estadoDestino == null) {
            return false;
        }
        
        return switch (this) {
            case ACTIVO -> estadoDestino == INACTIVO || estadoDestino == SUSPENDIDO;
            case INACTIVO -> estadoDestino == ACTIVO || estadoDestino == SUSPENDIDO;
            case SUSPENDIDO -> estadoDestino == ACTIVO; // Solo admin puede reactivar
        };
    }
}
