package com.mitoga.shared.infrastructure.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * Configuración AWS S3 para almacenamiento de archivos - SHARED INFRASTRUCTURE
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - SHARED KERNEL
 * - Properties compartidas para configuración S3
 * - Define límites de tamaño y tipos de archivos permitidos
 * - Configuraciones específicas por tipo de usuario (estudiantes, tutores)
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "aws.s3")
public class S3Properties {

    private String accessKeyId;
    private String secretAccessKey;
    private String region = "us-east-1";
    private String bucketName;
    private String baseUrl;
    private Long maxFileSize = 10485760L; // 10MB por defecto
    private String[] allowedImageTypes = { "jpg", "jpeg", "png", "webp" };
    private String[] allowedDocumentTypes = { "pdf", "doc", "docx" };

    // Configuración para diferentes tipos de archivos
    private FileTypeConfig estudiantes = new FileTypeConfig();
    private FileTypeConfig tutores = new FileTypeConfig();

    @Data
    public static class FileTypeConfig {
        private String prefix = "";
        private Long maxSize = 10485760L; // 10MB
        private String[] allowedTypes = { "jpg", "jpeg", "png", "pdf" };
        private boolean enableCompression = true;
        private int maxWidth = 1920;
        private int maxHeight = 1080;
    }
}
