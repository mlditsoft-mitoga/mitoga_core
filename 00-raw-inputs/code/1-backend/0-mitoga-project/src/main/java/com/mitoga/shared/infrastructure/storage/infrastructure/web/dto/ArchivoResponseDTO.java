package com.mitoga.shared.infrastructure.storage.infrastructure.web.dto;

import com.mitoga.shared.infrastructure.storage.domain.valueobject.TipoArchivo;
import lombok.Data;
import lombok.Builder;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * DTO de respuesta para operaciones de archivos
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - INFRASTRUCTURE LAYER - WEB DTO
 * - DTO específico de la capa web del módulo Archivos
 * - Usado para respuestas HTTP
 */
@Data
@Builder
public class ArchivoResponseDTO {
    private UUID archivoId;
    private TipoArchivo tipoArchivo;
    private String nombreOriginal;
    private String storageUrl;
    private String contentType;
    private Long tamanoBytes;
    private String proveedorStorage;
    private Boolean esPublico;
    private String urlTemporal;
    private LocalDateTime fechaCreacion;
    private LocalDateTime fechaActualizacion;
}
