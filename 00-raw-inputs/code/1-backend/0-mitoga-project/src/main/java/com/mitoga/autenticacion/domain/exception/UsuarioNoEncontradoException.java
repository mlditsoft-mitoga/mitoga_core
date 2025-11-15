package com.mitoga.autenticacion.domain.exception;

import java.util.UUID;

/**
 * UsuarioNoEncontradoException - Excepción cuando un usuario no existe
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - DOMAIN LAYER - EXCEPTION
 * - Excepción de dominio para usuario no encontrado
 * - HTTP 404 - NOT FOUND
 */
public class UsuarioNoEncontradoException extends AutenticacionException {

    public UsuarioNoEncontradoException(String email) {
        super("Usuario no encontrado con email: " + email);
    }

    public UsuarioNoEncontradoException(UUID usuarioId) {
        super("Usuario no encontrado con ID: " + usuarioId);
    }

    public UsuarioNoEncontradoException(String message, Throwable cause) {
        super(message, cause);
    }
}
