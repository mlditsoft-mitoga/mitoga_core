package com.mitoga.autenticacion.application.port.output;

/**
 * PasswordEncoderPort - PORT de salida para encriptación de passwords
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - OUTPUT PORT
 * - Interfaz (Port) para delegar encriptación a infraestructura
 * - Implementada por adaptadores (ej: BCryptPasswordAdapter)
 */
public interface PasswordEncoderPort {

    /**
     * Encripta un password en texto plano
     */
    String encode(String rawPassword);

    /**
     * Verifica si un password coincide con el hash
     */
    boolean matches(String rawPassword, String encodedPassword);
}
