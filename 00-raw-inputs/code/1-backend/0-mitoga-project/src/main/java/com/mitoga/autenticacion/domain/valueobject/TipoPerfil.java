package com.mitoga.autenticacion.domain.valueobject;

import com.mitoga.shared.domain.ValueObject;

/**
 * Value Object: Tipo de perfil de usuario
 * 
 * <p>
 * Define los tipos de perfil que un usuario puede tener en el sistema.
 * </p>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
public enum TipoPerfil implements ValueObject {
    
    /**
     * Usuario aprendiz/estudiante
     */
    APRENDIZ("Aprendiz", "Usuario estudiante que busca y reserva tutorías"),
    
    /**
     * Usuario tutor/instructor
     */
    TUTOR("Tutor", "Usuario experto que ofrece tutorías en áreas específicas"),
    
    /**
     * Usuario administrador
     */
    ADMIN("Administrador", "Usuario con permisos completos para gestionar la plataforma");
    
    private final String nombreVisual;
    private final String descripcion;
    
    TipoPerfil(String nombreVisual, String descripcion) {
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
     * Valida si el nombre corresponde a un tipo de perfil válido
     * 
     * @param nombre Nombre del tipo de perfil
     * @return true si es válido
     */
    public static boolean esValido(String nombre) {
        if (nombre == null || nombre.isBlank()) {
            return false;
        }
        try {
            TipoPerfil.valueOf(nombre.toUpperCase());
            return true;
        } catch (IllegalArgumentException e) {
            return false;
        }
    }
}
