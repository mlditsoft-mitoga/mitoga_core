package com.mitoga.autenticacion.domain.repository;

import com.mitoga.autenticacion.domain.model.Usuario;

import java.util.Optional;
import java.util.UUID;

/**
 * UsuarioRepository - PORT del dominio para persistencia de usuarios
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - DOMAIN LAYER - REPOSITORY PORT
 * - Interfaz (Port) definida en el dominio
 * - Implementada por adaptadores de infraestructura
 * - No tiene dependencias de frameworks (JPA, Spring, etc.)
 */
public interface UsuarioRepository {

    /**
     * Guarda un usuario (insert o update)
     */
    Usuario guardar(Usuario usuario);

    /**
     * Busca un usuario por su ID
     */
    Optional<Usuario> buscarPorId(UUID id);

    /**
     * Busca un usuario por su email
     */
    Optional<Usuario> buscarPorEmail(String email);

    /**
     * Verifica si existe un usuario con el email dado
     */
    boolean existePorEmail(String email);

    /**
     * Elimina un usuario (soft delete)
     */
    void eliminar(UUID id);

    /**
     * Busca usuarios por rol
     */
    java.util.List<Usuario> buscarPorRol(Usuario.Rol rol);

    /**
     * Busca usuarios por estado de cuenta
     */
    java.util.List<Usuario> buscarPorEstadoCuenta(Usuario.EstadoCuenta estado);

    /**
     * Cuenta usuarios por rol
     */
    long contarPorRol(Usuario.Rol rol);
}
