package com.mitoga.shared.infrastructure.storage.application.usecase;

import com.mitoga.shared.infrastructure.storage.domain.entity.Archivo;
import org.springframework.web.multipart.MultipartFile;
import java.util.UUID;

/**
 * Puerto simplificado para uso desde otros módulos - ARQUITECTURA HEXAGONAL
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - PUBLIC PORT
 * - API simplificada para uso desde módulos externos (Estudiantes, etc.)
 * - Delega en FileManagementUseCase para implementación completa
 * - Facilita comunicación entre bounded contexts
 */
public interface FileUseCase {

    /**
     * Sube un archivo al sistema de almacenamiento
     * Método simplificado para uso desde otros módulos
     */
    UUID uploadFile(MultipartFile file, String category, UUID entityId);

    /**
     * Obtiene URL de descarga de un archivo
     */
    String getFileUrl(UUID fileId);

    /**
     * Elimina un archivo del sistema
     */
    void deleteFile(UUID fileId);

    /**
     * Valida si un archivo es válido (tamaño, formato)
     */
    boolean validateFile(MultipartFile file, String category);

    /**
     * Obtiene información completa del archivo
     */
    Archivo getFileById(UUID fileId);
}
