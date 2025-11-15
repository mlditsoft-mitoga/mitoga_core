package com.mitoga.autenticacion.infrastructure.persistence.adapter;

import com.mitoga.autenticacion.domain.model.Token;
import com.mitoga.autenticacion.domain.repository.TokenRepository;
import com.mitoga.autenticacion.infrastructure.persistence.jpa.TokenJpaRepository;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * TokenPersistenceAdapter - Implementación del port TokenRepository
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - INFRASTRUCTURE LAYER - PERSISTENCE ADAPTER
 * - Implementa el port de dominio TokenRepository
 * - Delega operaciones a TokenJpaRepository (Spring Data JPA)
 * - Gestiona refresh tokens con device tracking
 */
@Component
public class TokenPersistenceAdapter implements TokenRepository {

    private final TokenJpaRepository tokenJpaRepository;

    public TokenPersistenceAdapter(TokenJpaRepository tokenJpaRepository) {
        this.tokenJpaRepository = tokenJpaRepository;
    }

    @Override
    public Token guardar(Token token) {
        return tokenJpaRepository.save(token);
    }

    @Override
    public Optional<Token> buscarPorToken(String tokenValue) {
        return tokenJpaRepository.findByToken(tokenValue);
    }

    @Override
    public List<Token> buscarTokensValidosPorUsuario(UUID usuarioId) {
        return tokenJpaRepository.findTokensValidosPorUsuarioId(usuarioId, LocalDateTime.now());
    }

    @Override
    public void revocarTodosPorUsuario(UUID usuarioId) {
        tokenJpaRepository.revocarTodosPorUsuarioId(usuarioId, LocalDateTime.now());
    }

    @Override
    public void revocar(String tokenValue) {
        tokenJpaRepository.findByToken(tokenValue)
                .ifPresent(token -> {
                    token.revocar();
                    tokenJpaRepository.save(token);
                });
    }

    @Override
    public void eliminarTokensExpirados() {
        tokenJpaRepository.eliminarTokensExpirados(LocalDateTime.now());
    }

    @Override
    public long contarTokensActivosPorUsuario(UUID usuarioId) {
        return tokenJpaRepository.contarTokensActivosPorUsuarioId(usuarioId, LocalDateTime.now());
    }

    @Override
    public List<Token> buscarPorUsuarioYDispositivo(UUID usuarioId, String dispositivo) {
        return tokenJpaRepository.findByUsuarioIdAndDispositivo(usuarioId, dispositivo);
    }
}
