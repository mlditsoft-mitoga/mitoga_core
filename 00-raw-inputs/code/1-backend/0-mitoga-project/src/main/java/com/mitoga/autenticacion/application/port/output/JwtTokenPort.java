package com.mitoga.autenticacion.application.port.output;

import java.util.Map;
import java.util.UUID;

/**
 * JwtTokenPort - PORT de salida para generación y validación de JWT
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - OUTPUT PORT
 * - Interfaz (Port) para delegar JWT a infraestructura
 * - Implementada por JwtTokenAdapter usando library JWT
 */
public interface JwtTokenPort {

    /**
     * Genera un JWT access token para un usuario
     */
    String generateAccessToken(UUID usuarioId, String email, String rol, Map<String, Object> claims);

    /**
     * Genera un refresh token aleatorio
     */
    String generateRefreshToken();

    /**
     * Valida un JWT access token
     * 
     * @return usuarioId si es válido, null si es inválido
     */
    UUID validateAccessToken(String token);

    /**
     * Extrae información del JWT sin validar firma
     */
    Map<String, Object> extractClaims(String token);

    /**
     * Obtiene el tiempo de expiración del access token en segundos
     */
    Long getAccessTokenExpirationSeconds();
}
