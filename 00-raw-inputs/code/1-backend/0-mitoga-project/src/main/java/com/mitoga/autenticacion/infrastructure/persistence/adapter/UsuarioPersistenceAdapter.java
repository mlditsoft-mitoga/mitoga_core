package com.mitoga.autenticacion.infrastructure.persistence.adapter;

import com.mitoga.autenticacion.domain.model.Usuario;
import com.mitoga.autenticacion.domain.repository.UsuarioRepository;
import com.mitoga.autenticacion.infrastructure.persistence.jpa.UsuarioJpaRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * UsuarioPersistenceAdapter - Implementación del port UsuarioRepository
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - INFRASTRUCTURE LAYER - PERSISTENCE ADAPTER
 * - Implementa el port de dominio UsuarioRepository
 * - Delega operaciones a UsuarioJpaRepository (Spring Data JPA)
 * - Adaptador entre el dominio y la infraestructura de persistencia
 * - Garantiza que el dominio NO depende de JPA
 */
@Component
public class UsuarioPersistenceAdapter implements UsuarioRepository {

    private final UsuarioJpaRepository usuarioJpaRepository;

    public UsuarioPersistenceAdapter(UsuarioJpaRepository usuarioJpaRepository) {
        this.usuarioJpaRepository = usuarioJpaRepository;
    }

    @Override
    public Usuario guardar(Usuario usuario) {
        return usuarioJpaRepository.save(usuario);
    }

    @Override
    public Optional<Usuario> buscarPorId(UUID id) {
        return usuarioJpaRepository.findById(id);
    }

    @Override
    public Optional<Usuario> buscarPorEmail(String email) {
        return usuarioJpaRepository.findByEmail(email);
    }

    @Override
    public boolean existePorEmail(String email) {
        return usuarioJpaRepository.existsByEmail(email);
    }

    @Override
    public List<Usuario> buscarPorRol(Usuario.Rol rol) {
        return usuarioJpaRepository.findByRol(rol);
    }

    @Override
    public List<Usuario> buscarPorEstadoCuenta(Usuario.EstadoCuenta estado) {
        return usuarioJpaRepository.findByEstadoCuenta(estado);
    }

    @Override
    public void eliminar(UUID id) {
        usuarioJpaRepository.deleteById(id);
    }

    @Override
    public long contarPorRol(Usuario.Rol rol) {
        return usuarioJpaRepository.findByRol(rol).size();
    }
}
