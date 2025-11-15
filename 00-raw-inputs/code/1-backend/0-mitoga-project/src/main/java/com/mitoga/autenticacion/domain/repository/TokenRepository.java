package com.mitoga.autenticacion.domain.repository;

import com.mitoga.autenticacion.domain.model.Token;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * TokenRepository - PORT del dominio para persistencia de tokens
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - DOMAIN LAYER - REPOSITORY PORT
 * - Interfaz (Port) definida en el dominio
 * - Gestiona refresh tokens de usuarios
 * - Permite invalidar sesiones y gestionar dispositivos
 */
public interface TokenRepository {

    /**
     * Guarda un token
     */
    Token guardar(Token token);

    /**
     * Busca un token por su valor
     */
    Optional<Token> buscarPorToken(String tokenValue);

    /**
     * Busca todos los tokens válidos de un usuario
     */
    List<Token> buscarTokensValidosPorUsuario(UUID usuarioId);

    /**
     * Revoca todos los tokens de un usuario
     */
    void revocarTodosPorUsuario(UUID usuarioId);

    /**
     * Revoca un token específico
     */
    void revocar(String tokenValue);

    /**
     * Elimina tokens expirados (limpieza periódica)
     */
    void eliminarTokensExpirados();

    /**
     * Cuenta tokens activos de un usuario
     */
    long contarTokensActivosPorUsuario(UUID usuarioId);

    /**
     * Busca tokens por usuario y dispositivo
     */
    List<Token> buscarPorUsuarioYDispositivo(UUID usuarioId, String dispositivo);
}
