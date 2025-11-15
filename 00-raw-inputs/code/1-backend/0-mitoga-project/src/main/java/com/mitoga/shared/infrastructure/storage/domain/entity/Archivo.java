package com.mitoga.shared.infrastructure.storage.domain.entity;

import com.mitoga.shared.domain.valueobject.BaseEntity;
import com.mitoga.shared.infrastructure.storage.domain.valueobject.ProveedorStorage;
import com.mitoga.shared.infrastructure.storage.domain.valueobject.TipoArchivo;
import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.UUID;

/**
 * Entidad Archivo - shared_schema.archivos
 * Basado en modelo de BD V4 con extensiones V5.1
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - DOMAIN LAYER - ENTITY
 * - Entidad de dominio del módulo Archivos
 * - Contiene la lógica de negocio para gestión de archivos
 * - Independiente de infraestructura (S3, BD)
 */
@Entity
@Table(name = "archivos", schema = "shared_schema")
@Data
@EqualsAndHashCode(callSuper = true)
public class Archivo extends BaseEntity {

    @Column(name = "pkid_archivos")
    private UUID pkidArchivos;

    @Enumerated(EnumType.STRING)
    @Column(name = "tipo_archivo", nullable = false)
    private TipoArchivo tipoArchivo;

    @Column(name = "nombre_original", nullable = false, length = 255)
    private String nombreOriginal;

    @Column(name = "storage_url", nullable = false, length = 500)
    private String storageUrl;

    @Column(name = "storage_key", nullable = false, length = 255)
    private String storageKey;

    @Column(name = "content_type", length = 100)
    private String contentType;

    @Column(name = "tamano_bytes")
    private Long tamanoBytes;

    @Enumerated(EnumType.STRING)
    @Column(name = "proveedor_storage", nullable = false)
    private ProveedorStorage proveedorStorage = ProveedorStorage.AWS_S3;

    @Column(name = "metadatos_adicionales", columnDefinition = "jsonb")
    private String metadatosAdicionales;

    @Column(name = "hash_archivo", length = 64)
    private String hashArchivo;

    @Column(name = "es_publico")
    private Boolean esPublico = false;

    @Column(name = "url_temporal", length = 500)
    private String urlTemporal;

    @PrePersist
    protected void onCreate() {
        super.onCreate();
        if (pkidArchivos == null) {
            pkidArchivos = getId();
        }
    }

    /**
     * Verifica si el archivo requiere URL temporal para acceso
     */
    public boolean requiereUrlTemporal() {
        return !esPublico && proveedorStorage == ProveedorStorage.AWS_S3;
    }

    /**
     * Marca el archivo como público
     */
    public void marcarComoPublico() {
        this.esPublico = true;
    }

    /**
     * Actualiza la URL temporal
     */
    public void actualizarUrlTemporal(String url) {
        this.urlTemporal = url;
    }
}
