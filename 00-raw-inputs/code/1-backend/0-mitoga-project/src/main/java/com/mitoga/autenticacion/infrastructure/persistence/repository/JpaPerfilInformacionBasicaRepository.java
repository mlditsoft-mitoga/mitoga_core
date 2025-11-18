package com.mitoga.autenticacion.infrastructure.persistence.repository;

import com.mitoga.autenticacion.infrastructure.persistence.entity.PerfilInformacionBasicaEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Spring Data JPA Repository: PerfilInformacionBasica
 * 
 * <p>
 * Repositorio JPA para acceso a tabla perfil_informacion_basica.
 * Usa exclusivamente queries derivados de Spring Data.
 * </p>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Repository
public interface JpaPerfilInformacionBasicaRepository extends JpaRepository<PerfilInformacionBasicaEntity, UUID> {

    /**
     * Buscar todas las asignaciones de perfiles para una información básica
     * 
     * <p>
     * Query derivado: WHERE fk_pkid_informacion_basica = ? AND expiration_date IS NULL
     * </p>
     * 
     * @param informacionBasicaId UUID de información básica
     * @return Lista de perfiles asignados
     */
    List<PerfilInformacionBasicaEntity> findByFkPkidInformacionBasicaAndExpirationDateIsNull(UUID informacionBasicaId);

    /**
     * Buscar todas las asignaciones de un perfil específico
     * 
     * <p>
     * Query derivado: WHERE fk_pkid_perfiles = ? AND expiration_date IS NULL
     * </p>
     * 
     * @param perfilId UUID del perfil
     * @return Lista de asignaciones
     */
    List<PerfilInformacionBasicaEntity> findByFkPkidPerfilesAndExpirationDateIsNull(UUID perfilId);

    /**
     * Buscar asignación específica de perfil a información básica
     * 
     * <p>
     * Query derivado: WHERE fk_pkid_perfiles = ? AND fk_pkid_informacion_basica = ? AND expiration_date IS NULL
     * </p>
     * 
     * @param perfilId UUID del perfil
     * @param informacionBasicaId UUID de información básica
     * @return Optional con asignación encontrada
     */
    Optional<PerfilInformacionBasicaEntity> findByFkPkidPerfilesAndFkPkidInformacionBasicaAndExpirationDateIsNull(
        UUID perfilId, 
        UUID informacionBasicaId
    );

    /**
     * Buscar el perfil principal de un usuario
     * 
     * <p>
     * Query derivado: WHERE fk_pkid_informacion_basica = ? 
     * AND es_perfil_principal = true 
     * AND estado = 'ACTIVO' 
     * AND expiration_date IS NULL
     * </p>
     * 
     * @param informacionBasicaId UUID de información básica
     * @param esPrincipal true para buscar perfil principal
     * @param estado Estado del perfil (ACTIVO)
     * @return Optional con perfil principal
     */
    Optional<PerfilInformacionBasicaEntity> findFirstByFkPkidInformacionBasicaAndEsPerfilPrincipalAndEstadoAndExpirationDateIsNull(
        UUID informacionBasicaId, 
        Boolean esPrincipal, 
        String estado
    );

    /**
     * Buscar todos los perfiles activos de un usuario
     * 
     * <p>
     * Query derivado: WHERE fk_pkid_informacion_basica = ? 
     * AND estado = 'ACTIVO' 
     * AND expiration_date IS NULL
     * ORDER BY es_perfil_principal DESC, fecha_asignacion DESC
     * </p>
     * 
     * @param informacionBasicaId UUID de información básica
     * @param estado Estado del perfil (ACTIVO)
     * @return Lista de perfiles activos ordenados
     */
    List<PerfilInformacionBasicaEntity> findByFkPkidInformacionBasicaAndEstadoAndExpirationDateIsNullOrderByEsPerfilPrincipalDescFechaAsignacionDesc(
        UUID informacionBasicaId, 
        String estado
    );

    /**
     * Verificar si existe asignación de perfil
     * 
     * <p>
     * Query derivado: SELECT COUNT(*) > 0 FROM perfil_informacion_basica 
     * WHERE fk_pkid_perfiles = ? AND fk_pkid_informacion_basica = ? AND expiration_date IS NULL
     * </p>
     * 
     * @param perfilId UUID del perfil
     * @param informacionBasicaId UUID de información básica
     * @return true si existe
     */
    boolean existsByFkPkidPerfilesAndFkPkidInformacionBasicaAndExpirationDateIsNull(
        UUID perfilId, 
        UUID informacionBasicaId
    );

    /**
     * Buscar asignaciones de perfil por estado
     * 
     * <p>
     * Query derivado: WHERE fk_pkid_informacion_basica = ? AND estado = ? AND expiration_date IS NULL
     * </p>
     * 
     * @param informacionBasicaId UUID de información básica
     * @param estado Estado del perfil
     * @return Lista de perfiles con ese estado
     */
    List<PerfilInformacionBasicaEntity> findByFkPkidInformacionBasicaAndEstadoAndExpirationDateIsNull(
        UUID informacionBasicaId, 
        String estado
    );
    
    /**
     * Buscar asignación pendiente de vincular (STEP 1)
     * 
     * <p>
     * Query derivado: WHERE fk_pkid_perfiles = ? 
     * AND fk_pkid_informacion_basica IS NULL 
     * AND expiration_date IS NULL
     * ORDER BY creation_date DESC
     * LIMIT 1
     * </p>
     * 
     * @param perfilId UUID del perfil
     * @return Optional con asignación más reciente pendiente
     */
    Optional<PerfilInformacionBasicaEntity> findFirstByFkPkidPerfilesAndFkPkidInformacionBasicaIsNullAndExpirationDateIsNullOrderByCreationDateDesc(
        UUID perfilId
    );
}
