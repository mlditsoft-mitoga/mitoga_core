package com.mitoga.autenticacion.domain.exception;

/**
 * AutenticacionException - Excepción base para el BC de Autenticación
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - DOMAIN LAYER - EXCEPTION
 * - Excepción de dominio (no técnica)
 * - Representa errores de negocio relacionados con autenticación
 */
public class AutenticacionException extends RuntimeException {

    public AutenticacionException(String mensaje) {
        super(mensaje);
    }

    public AutenticacionException(String mensaje, Throwable causa) {
        super(mensaje, causa);
    }
}
