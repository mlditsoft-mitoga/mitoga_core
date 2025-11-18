package com.mitoga.autenticacion.infrastructure.persistence.repository;

import com.mitoga.autenticacion.infrastructure.persistence.entity.PerfilEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

/**
 * Spring Data JPA Repository: Perfil
 * 
 * <p>
 * Repositorio JPA para acceso a tabla perfiles.
 * Queries derivados automáticamente por Spring Data.
 * </p>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Repository
public interface JpaPerfilRepository extends JpaRepository<PerfilEntity, UUID> {

    /**
     * Buscar perfil por código exacto
     * 
     * <p>
     * Query derivado: WHERE codigo = ? AND expiration_date IS NULL
     * </p>
     * 
     * @param codigo Código del perfil (APRENDIZ, TUTOR, ADMIN)
     * @return Optional con perfil encontrado
     */
    Optional<PerfilEntity> findByCodigoAndExpirationDateIsNull(String codigo);

    /**
     * Verificar existencia de perfil por código
     * 
     * <p>
     * Query derivado: SELECT COUNT(*) > 0 FROM perfiles WHERE codigo = ? AND expiration_date IS NULL
     * </p>
     * 
     * @param codigo Código del perfil
     * @return true si existe
     */
    boolean existsByCodigoAndExpirationDateIsNull(String codigo);
}
