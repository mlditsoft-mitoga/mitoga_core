package com.mitoga.autenticacion.domain.repository;

import com.mitoga.autenticacion.domain.entity.Perfil;
import com.mitoga.autenticacion.domain.valueobject.TipoPerfil;

import java.util.Optional;
import java.util.UUID;

/**
 * Repository Port (Domain Layer): Contrato para persistencia de Perfil
 * 
 * <p>
 * Define las operaciones de persistencia para catálogo de perfiles del sistema.
 * </p>
 * 
 * <p>
 * Implementado por {@code PerfilPersistenceAdapter} en infrastructure layer.
 * </p>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
public interface PerfilRepository {

    /**
     * Guarda un perfil (INSERT o UPDATE)
     * 
     * @param perfil Perfil a persistir
     * @return Perfil persistido
     */
    Perfil save(Perfil perfil);

    /**
     * Busca perfil por ID
     * 
     * @param id Identificador del perfil
     * @return Optional con perfil encontrado
     */
    Optional<Perfil> findById(UUID id);

    /**
     * Busca perfil por código exacto
     * 
     * <p>
     * Usado para lookup de UUIDs en registro: APRENDIZ → UUID
     * </p>
     * 
     * @param codigo Código del perfil (APRENDIZ, TUTOR, ADMIN)
     * @return Optional con perfil encontrado
     */
    Optional<Perfil> findByCodigo(String codigo);
    
    /**
     * Busca perfil por tipo
     * 
     * @param tipoPerfil Tipo de perfil
     * @return Optional con perfil encontrado
     */
    default Optional<Perfil> findByTipo(TipoPerfil tipoPerfil) {
        return findByCodigo(tipoPerfil.name());
    }

    /**
     * Verifica si existe un perfil con el código dado
     * 
     * @param codigo Código del perfil
     * @return true si existe
     */
    boolean existsByCodigo(String codigo);
}
