package com.mitoga.autenticacion.infrastructure.persistence.jpa;

import com.mitoga.autenticacion.domain.model.Token;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * TokenJpaRepository - Spring Data JPA Repository para Token (Refresh Tokens)
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - INFRASTRUCTURE LAYER - JPA REPOSITORY
 * - Gestiona refresh tokens con device tracking
 * - Operaciones de revocación y limpieza
 * - Usado por TokenPersistenceAdapter
 */
@Repository
public interface TokenJpaRepository extends JpaRepository<Token, UUID> {

    /**
     * Busca un token por su valor (para validación)
     */
    @Query("SELECT t FROM Token t WHERE t.token = :token")
    Optional<Token> findByToken(@Param("token") String token);

    /**
     * Busca todos los tokens de un usuario
     */
    @Query("SELECT t FROM Token t WHERE t.usuarioId = :usuarioId ORDER BY t.creationDate DESC")
    List<Token> findByUsuarioId(@Param("usuarioId") UUID usuarioId);

    /**
     * Busca tokens válidos (no revocados y no expirados) de un usuario
     */
    @Query("SELECT t FROM Token t WHERE t.usuarioId = :usuarioId " +
            "AND t.revocado = false " +
            "AND t.fechaExpiracion > :ahora " +
            "ORDER BY t.creationDate DESC")
    List<Token> findTokensValidosPorUsuarioId(
            @Param("usuarioId") UUID usuarioId,
            @Param("ahora") LocalDateTime ahora);

    /**
     * Busca tokens por dispositivo de un usuario
     */
    @Query("SELECT t FROM Token t WHERE t.usuarioId = :usuarioId " +
            "AND t.dispositivo = :dispositivo " +
            "ORDER BY t.creationDate DESC")
    List<Token> findByUsuarioIdAndDispositivo(
            @Param("usuarioId") UUID usuarioId,
            @Param("dispositivo") String dispositivo);

    /**
     * Revoca todos los tokens de un usuario (logout de todos los dispositivos)
     */
    @Modifying
    @Query("UPDATE Token t SET t.revocado = true, t.fechaRevocacion = :fechaRevocacion " +
            "WHERE t.usuarioId = :usuarioId AND t.revocado = false")
    void revocarTodosPorUsuarioId(
            @Param("usuarioId") UUID usuarioId,
            @Param("fechaRevocacion") LocalDateTime fechaRevocacion);

    /**
     * Elimina tokens expirados (limpieza periódica)
     */
    @Modifying
    @Query("DELETE FROM Token t WHERE t.fechaExpiracion < :fecha")
    void eliminarTokensExpirados(@Param("fecha") LocalDateTime fecha);

    /**
     * Cuenta tokens activos por usuario
     */
    @Query("SELECT COUNT(t) FROM Token t WHERE t.usuarioId = :usuarioId " +
            "AND t.revocado = false " +
            "AND t.fechaExpiracion > :ahora")
    Long contarTokensActivosPorUsuarioId(
            @Param("usuarioId") UUID usuarioId,
            @Param("ahora") LocalDateTime ahora);
}
