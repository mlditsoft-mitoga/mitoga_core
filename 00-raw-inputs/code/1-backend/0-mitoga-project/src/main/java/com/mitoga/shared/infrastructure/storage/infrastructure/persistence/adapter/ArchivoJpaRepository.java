package com.mitoga.shared.infrastructure.storage.infrastructure.persistence.adapter;

import com.mitoga.shared.infrastructure.storage.domain.entity.Archivo;
import com.mitoga.shared.infrastructure.storage.domain.repository.ArchivoRepository;
import com.mitoga.shared.infrastructure.storage.domain.valueobject.TipoArchivo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.UUID;
import java.util.Optional;
import java.util.List;

/**
 * Adaptador de persistencia JPA para Archivo - ARQUITECTURA HEXAGONAL
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - INFRASTRUCTURE LAYER - PERSISTENCE ADAPTER
 * - Adaptador que implementa el puerto del repositorio
 * - Extiende JpaRepository para operaciones CRUD estándar
 * - Contiene queries específicas del dominio Archivos
 */
@Repository
public interface ArchivoJpaRepository extends JpaRepository<Archivo, UUID>, ArchivoRepository {

    /**
     * Busca archivos activos por tipo
     */
    @Query("SELECT a FROM Archivo a WHERE a.tipoArchivo = :tipoArchivo AND a.expirationDate IS NULL ORDER BY a.creationDate DESC")
    List<Archivo> findByTipoArchivoAndExpirationDateIsNull(@Param("tipoArchivo") TipoArchivo tipoArchivo);

    /**
     * Busca archivos activos por entidad relacionada (usando metadatos)
     */
    @Query(value = "SELECT a.* FROM shared_schema.archivos a WHERE a.metadatos_adicionales::jsonb @> jsonb_build_object('entityId', :entityId::text) AND a.expiration_date IS NULL", nativeQuery = true)
    List<Archivo> findActiveFilesByEntityId(@Param("entityId") UUID entityId);

    /**
     * Busca archivo por hash
     */
    @Query("SELECT a FROM Archivo a WHERE a.hashArchivo = :hash AND a.expirationDate IS NULL")
    Optional<Archivo> findByHashArchivo(@Param("hash") String hash);

    /**
     * Verifica si existe archivo activo con storage key
     */
    @Query("SELECT COUNT(a) > 0 FROM Archivo a WHERE a.storageKey = :storageKey AND a.expirationDate IS NULL")
    boolean existsByStorageKeyAndExpirationDateIsNull(@Param("storageKey") String storageKey);
}
