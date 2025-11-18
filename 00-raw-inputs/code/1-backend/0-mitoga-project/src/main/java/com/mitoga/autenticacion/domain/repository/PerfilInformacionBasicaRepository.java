package com.mitoga.autenticacion.domain.repository;

import com.mitoga.autenticacion.domain.entity.PerfilInformacionBasica;
import com.mitoga.autenticacion.domain.valueobject.EstadoPerfil;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository Port (Domain Layer): Contrato para persistencia de PerfilInformacionBasica
 * 
 * <p>
 * Define las operaciones de persistencia para asignación de perfiles a usuarios.
 * </p>
 * 
 * <p>
 * Implementado por {@code PerfilInformacionBasicaPersistenceAdapter} en infrastructure layer.
 * </p>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
public interface PerfilInformacionBasicaRepository {

    /**
     * Guarda asignación de perfil (INSERT o UPDATE)
     * 
     * @param perfilInfo Asignación de perfil a persistir
     * @return Asignación persistida
     */
    PerfilInformacionBasica save(PerfilInformacionBasica perfilInfo);

    /**
     * Busca asignación por ID
     * 
     * @param id Identificador de la asignación
     * @return Optional con asignación encontrada
     */
    Optional<PerfilInformacionBasica> findById(UUID id);

    /**
     * Busca todas las asignaciones de perfiles para una información básica
     * 
     * @param informacionBasicaId UUID de información básica
     * @return Lista de perfiles asignados
     */
    List<PerfilInformacionBasica> findByInformacionBasicaId(UUID informacionBasicaId);

    /**
     * Busca todas las asignaciones de un perfil específico
     * 
     * @param perfilId UUID del perfil
     * @return Lista de asignaciones
     */
    List<PerfilInformacionBasica> findByPerfilId(UUID perfilId);

    /**
     * Busca asignación específica de perfil a información básica
     * 
     * @param perfilId UUID del perfil
     * @param informacionBasicaId UUID de información básica
     * @return Optional con asignación encontrada
     */
    Optional<PerfilInformacionBasica> findByPerfilIdAndInformacionBasicaId(
        UUID perfilId, 
        UUID informacionBasicaId
    );

    /**
     * Busca el perfil principal de un usuario
     * 
     * @param informacionBasicaId UUID de información básica
     * @return Optional con perfil principal
     */
    Optional<PerfilInformacionBasica> findPerfilPrincipalByInformacionBasicaId(UUID informacionBasicaId);

    /**
     * Busca todos los perfiles activos de un usuario
     * 
     * @param informacionBasicaId UUID de información básica
     * @return Lista de perfiles activos
     */
    List<PerfilInformacionBasica> findActivosByInformacionBasicaId(UUID informacionBasicaId);

    /**
     * Verifica si existe asignación de perfil
     * 
     * @param perfilId UUID del perfil
     * @param informacionBasicaId UUID de información básica
     * @return true si existe
     */
    boolean existsByPerfilIdAndInformacionBasicaId(UUID perfilId, UUID informacionBasicaId);
    
    /**
     * Busca asignaciones de perfil por estado
     * 
     * @param informacionBasicaId UUID de información básica
     * @param estado Estado del perfil
     * @return Lista de perfiles con ese estado
     */
    List<PerfilInformacionBasica> findByInformacionBasicaIdAndEstado(
        UUID informacionBasicaId, 
        EstadoPerfil estado
    );
    
    /**
     * Busca asignación de perfil pendiente de vincular (STEP 1)
     * 
     * <p>
     * Encuentra el registro de perfil_informacion_basica creado en STEP 1
     * que todavía no tiene fk_pkid_informacion_basica asignado.
     * </p>
     * 
     * @param perfilId UUID del perfil
     * @return Optional con asignación pendiente
     */
    Optional<PerfilInformacionBasica> findPendienteDeVincular(UUID perfilId);
}
