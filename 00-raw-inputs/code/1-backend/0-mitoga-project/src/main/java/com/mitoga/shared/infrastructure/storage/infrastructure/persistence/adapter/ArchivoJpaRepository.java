package com.mitoga.shared.infrastructure.storage.infrastructure.persistence.adapter;

import com.mitoga.shared.infrastructure.storage.domain.entity.Archivo;
import com.mitoga.shared.infrastructure.storage.domain.repository.ArchivoRepository;
import com.mitoga.shared.infrastructure.storage.domain.valueobject.TipoArchivo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;
import java.util.Optional;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Adaptador de persistencia JPA para Archivo - ARQUITECTURA HEXAGONAL
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - INFRASTRUCTURE LAYER - PERSISTENCE ADAPTER
 * - Adaptador que implementa el puerto del repositorio
 * - Extiende JpaRepository para operaciones CRUD estándar
 * - Usa Query Methods derivados (sin SQL quemado en código)
 */
@Repository
public interface ArchivoJpaRepository extends JpaRepository<Archivo, UUID>, ArchivoRepository {

    /**
     * Busca archivos activos por tipo
     * Query Method derivado: WHERE tipo_archivo = ? AND expiration_date IS NULL
     * ORDER BY creation_date DESC
     */
    List<Archivo> findByTipoArchivoAndExpirationDateIsNullOrderByCreationDateDesc(TipoArchivo tipoArchivo);

    /**
     * Busca archivo por hash (activo)
     * Query Method derivado: WHERE hash_archivo = ? AND expiration_date IS NULL
     */
    Optional<Archivo> findByHashArchivoAndExpirationDateIsNull(String hash);

    /**
     * Verifica si existe archivo activo con storage key
     * Query Method derivado: COUNT WHERE storage_key = ? AND expiration_date IS
     * NULL > 0
     */
    boolean existsByStorageKeyAndExpirationDateIsNull(String storageKey);

    /**
     * Busca todos los archivos activos (sin expiración)
     * La lógica de filtrado JSONB se hace en Service/Adapter con stream()
     */
    List<Archivo> findByExpirationDateIsNull();

    /**
     * Busca archivos activos por entidad relacionada (metadatos JSONB)
     * Implementación: Cargar archivos activos y filtrar en memoria por entityId en
     * metadatos JSON
     * Más mantenible que SQL nativo, eficiente para datasets pequeños/medianos
     */
    default List<Archivo> findActiveFilesByEntityId(UUID entityId) {
        String entityIdStr = entityId.toString();
        return findByExpirationDateIsNull().stream()
                .filter(archivo -> {
                    String metadatos = archivo.getMetadatosAdicionales();
                    // Búsqueda simple en JSON string: contiene "entityId":"<uuid>"
                    return metadatos != null && metadatos.contains("\"entityId\":\"" + entityIdStr + "\"");
                })
                .collect(Collectors.toList());
    }
}
