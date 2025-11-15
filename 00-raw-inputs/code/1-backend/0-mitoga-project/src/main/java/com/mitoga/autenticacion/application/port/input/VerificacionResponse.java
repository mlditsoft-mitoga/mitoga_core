package com.mitoga.autenticacion.application.port.input;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

/**
 * VerificacionResponse - DTO de respuesta para verificación de email
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - DTO
 * - DTO para respuesta de verificación de email
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VerificacionResponse {
    private UUID usuarioId;
    private String email;
    private Boolean verificado;
    private String mensaje;
    private Boolean cuentaActivada;
}
