package com.mitoga.shared.infrastructure.storage.domain.repository;

import com.mitoga.shared.infrastructure.storage.domain.entity.Archivo;
import com.mitoga.shared.infrastructure.storage.domain.valueobject.TipoArchivo;
import java.util.UUID;
import java.util.Optional;
import java.util.List;

/**
 * Puerto del repositorio para Archivo - ARQUITECTURA HEXAGONAL
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - DOMAIN LAYER - REPOSITORY PORT
 * - Puerto definido en el dominio
 * - Será implementado por un adaptador en infrastructure
 * - Define el contrato para persistencia de archivos
 */
public interface ArchivoRepository {

    /**
     * Guarda un archivo
     */
    Archivo save(Archivo archivo);

    /**
     * Busca archivo por ID
     */
    Optional<Archivo> findById(UUID id);

    /**
     * Busca archivos por tipo
     */
    List<Archivo> findByTipoArchivoAndExpirationDateIsNull(TipoArchivo tipoArchivo);

    /**
     * Busca archivos activos por entidad relacionada
     */
    List<Archivo> findActiveFilesByEntityId(UUID entityId);

    /**
     * Busca archivos por hash (para detectar duplicados)
     */
    Optional<Archivo> findByHashArchivo(String hash);

    /**
     * Elimina archivo por ID
     */
    void deleteById(UUID id);

    /**
     * Verifica si existe archivo activo con storage key
     */
    boolean existsByStorageKeyAndExpirationDateIsNull(String storageKey);
}
