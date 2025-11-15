package com.mitoga.shared.infrastructure.storage.application.usecase;

import com.mitoga.shared.infrastructure.storage.application.command.UploadFileCommand;
import com.mitoga.shared.infrastructure.storage.domain.entity.Archivo;
import com.mitoga.shared.infrastructure.storage.domain.valueobject.TipoArchivo;
import java.util.List;
import java.util.UUID;

/**
 * Puerto de la capa de aplicación para gestión de archivos - ARQUITECTURA
 * HEXAGONAL
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - USE CASES
 * - Define los casos de uso del módulo Archivos
 * - Puerto que será implementado por adaptadores en infrastructure
 * - Módulo reutilizable para gestión centralizada de archivos
 */
public interface FileManagementUseCase {

    /**
     * Sube un archivo al sistema de almacenamiento
     */
    Archivo uploadFile(UploadFileCommand command);

    /**
     * Obtiene un archivo por ID
     */
    Archivo getFileById(UUID archivoId);

    /**
     * Obtiene archivos por tipo
     */
    List<Archivo> getFilesByType(TipoArchivo tipoArchivo);

    /**
     * Genera URL temporal para acceso al archivo
     */
    String generatePresignedUrl(UUID archivoId, int expirationMinutes);

    /**
     * Elimina archivo del sistema (soft delete)
     */
    void deleteFile(UUID archivoId);

    /**
     * Obtiene archivos de una entidad (estudiante, tutor, etc.)
     */
    List<Archivo> getEntityFiles(UUID entityId);
}
