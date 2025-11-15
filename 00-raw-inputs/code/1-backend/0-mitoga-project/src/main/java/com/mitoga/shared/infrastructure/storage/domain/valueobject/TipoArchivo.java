package com.mitoga.shared.infrastructure.storage.domain.valueobject;

/**
 * Enum para tipos de archivo - DOMAIN VALUE OBJECT
 * Basado en shared_schema.tipo_archivo del BD V4/V5/V5.1
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - DOMAIN LAYER - VALUE OBJECT
 * - Enum del dominio del módulo Archivos
 * - Define los tipos de archivo soportados
 */
public enum TipoArchivo {
    // Tipos para estudiantes (V4)
    FOTO_PERFIL,
    DOCUMENTO_FRONTAL,
    DOCUMENTO_TRASERO,
    SELFIE_VERIFICACION,
    DOCUMENTO_RESPONSABLE_FRONTAL,
    DOCUMENTO_RESPONSABLE_TRASERO,

    // Tipos para tutores (V5.1)
    FOTO_PERFIL_TUTOR,
    VIDEO_PRESENTACION,
    CERTIFICADO_EDUCATIVO,
    CERTIFICADO_EXPERIENCIA,
    CERTIFICADO_IDIOMA,
    DOCUMENTO_FISCAL,
    PORTAFOLIO_TRABAJO,
    FOTO_WORKSPACE;

    /**
     * Verifica si es un tipo de documento de identidad
     */
    public boolean esDocumentoIdentidad() {
        return this == DOCUMENTO_FRONTAL ||
                this == DOCUMENTO_TRASERO ||
                this == DOCUMENTO_RESPONSABLE_FRONTAL ||
                this == DOCUMENTO_RESPONSABLE_TRASERO;
    }

    /**
     * Verifica si es un tipo de foto/imagen
     */
    public boolean esFoto() {
        return this == FOTO_PERFIL ||
                this == SELFIE_VERIFICACION ||
                this == FOTO_PERFIL_TUTOR ||
                this == FOTO_WORKSPACE;
    }

    /**
     * Verifica si es un certificado
     */
    public boolean esCertificado() {
        return this == CERTIFICADO_EDUCATIVO ||
                this == CERTIFICADO_EXPERIENCIA ||
                this == CERTIFICADO_IDIOMA;
    }
}
