package com.mitoga.shared.infrastructure.storage.domain.valueobject;

/**
 * Enum para proveedores de storage - DOMAIN VALUE OBJECT
 * Basado en shared_schema.proveedor_storage del BD V4
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - DOMAIN LAYER - VALUE OBJECT
 */
public enum ProveedorStorage {
    LOCAL,
    AWS_S3,
    CLOUDINARY;

    /**
     * Verifica si es proveedor en la nube
     */
    public boolean esNube() {
        return this == AWS_S3 || this == CLOUDINARY;
    }
}
