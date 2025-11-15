package com.mitoga.autenticacion.infrastructure.persistence.jpa;

import com.mitoga.autenticacion.domain.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

/**
 * UsuarioJpaRepository - Spring Data JPA Repository para Usuario
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - INFRASTRUCTURE LAYER - JPA REPOSITORY
 * - Extiende JpaRepository para operaciones CRUD automáticas
 * - Define consultas personalizadas con @Query
 * - Usado por UsuarioPersistenceAdapter
 */
@Repository
public interface UsuarioJpaRepository extends JpaRepository<Usuario, UUID> {

    /**
     * Busca un usuario por su email
     */
    @Query("SELECT u FROM Usuario u WHERE u.email = :email")
    Optional<Usuario> findByEmail(@Param("email") String email);

    /**
     * Verifica si existe un usuario con el email dado
     */
    boolean existsByEmail(String email);

    /**
     * Busca usuarios por rol
     */
    @Query("SELECT u FROM Usuario u WHERE u.rol = :rol")
    java.util.List<Usuario> findByRol(@Param("rol") Usuario.Rol rol);

    /**
     * Busca usuarios por estado de cuenta
     */
    @Query("SELECT u FROM Usuario u WHERE u.estadoCuenta = :estado")
    java.util.List<Usuario> findByEstadoCuenta(@Param("estado") Usuario.EstadoCuenta estado);

    /**
     * Busca usuarios con email no verificado
     */
    @Query("SELECT u FROM Usuario u WHERE u.emailVerificado = false")
    java.util.List<Usuario> findUsuariosSinVerificar();

    /**
     * Busca usuarios bloqueados
     */
    @Query("SELECT u FROM Usuario u WHERE u.estadoCuenta = 'BLOQUEADA' AND u.fechaBloqueo IS NOT NULL")
    java.util.List<Usuario> findUsuariosBloqueados();
}
