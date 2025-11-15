package com.mitoga.shared.domain.valueobject;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * DTO de respuesta para operaciones de registro - SHARED KERNEL
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - SHARED KERNEL
 * - Value Object compartido entre módulos
 * - Utilizado para comunicación entre bounded contexts
 * - Mantiene contratos estables entre módulos
 */
@Data
@Builder
public class RegistroResponseDTO {

    private UUID procesoId;
    private String estado;
    private Integer pasoActual;
    private Integer totalPasos;
    private String mensaje;
    private Boolean exitoso;

    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime fechaCreacion;

    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime fechaActualizacion;

    // URL para continuar el proceso (opcional)
    private String siguientePasoUrl;

    // Tiempo restante para completar el paso actual (en minutos)
    private Integer tiempoRestanteMinutos;

    // Archivos subidos en este proceso
    private ArchivoInfoDTO documentoFrontal;
    private ArchivoInfoDTO documentoTrasero;
    private ArchivoInfoDTO selfieVerificacion;

    @Data
    @Builder
    public static class ArchivoInfoDTO {
        private UUID archivoId;
        private String nombreOriginal;
        private String storageUrl;
        private String tipoArchivo;
        private Long tamanoBytes;
        private Boolean esPublico;

        @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
        private LocalDateTime fechaSubida;
    }
}