package com.mitoga.autenticacion.application.port.input;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * AutenticacionResponse - DTO de respuesta para autenticación y registro
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - DTO
 * - DTO que cruza la frontera hexagonal
 * - Contiene JWT access token, refresh token y datos del usuario
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AutenticacionResponse {
    private UUID usuarioId;
    private String email;
    private String nombre;
    private String apellido;
    private String rol;
    private String estadoCuenta;

    // JWT Tokens
    private String accessToken;
    private String refreshToken;
    private LocalDateTime accessTokenExpiration;
    private Long expiresIn; // Segundos hasta expiración

    // OAuth Info (si aplica)
    private String proveedorOAuth;
    private Boolean cuentaOAuth;

    private LocalDateTime fechaRegistro;
    private LocalDateTime ultimoAcceso;
}
