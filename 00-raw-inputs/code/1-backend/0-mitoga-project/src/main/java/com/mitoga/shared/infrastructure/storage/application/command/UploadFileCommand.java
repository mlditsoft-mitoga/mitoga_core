package com.mitoga.shared.infrastructure.storage.application.command;

import com.mitoga.shared.infrastructure.storage.domain.valueobject.TipoArchivo;
import lombok.Data;
import lombok.Builder;
import org.springframework.web.multipart.MultipartFile;

import java.util.UUID;

/**
 * Command para subir archivo
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - COMMAND
 * - DTO específico para casos de uso del módulo Archivos
 * - Encapsula los datos necesarios para el comando
 */
@Data
@Builder
public class UploadFileCommand {
    private MultipartFile file;
    private TipoArchivo tipoArchivo;
    private String descripcion;
    private UUID entityId; // ID de la entidad relacionada (estudiante, tutor, etc.)
    private String category; // Categoría adicional si es necesario
}
