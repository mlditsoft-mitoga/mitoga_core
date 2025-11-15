package com.mitoga.autenticacion.infrastructure.persistence;

import com.mitoga.autenticacion.domain.model.Token;
import com.mitoga.autenticacion.domain.model.Usuario;
import com.mitoga.autenticacion.domain.model.valueobject.Rol;
import com.mitoga.autenticacion.domain.model.valueobject.TipoToken;
import com.mitoga.autenticacion.infrastructure.persistence.jpa.TokenJpaRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * TokenJpaRepositoryIntegrationTest - Integration tests para TokenJpaRepository
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 */
@DataJpaTest
@ActiveProfiles("test")
@DisplayName("TokenJpaRepository - Integration Tests")
class TokenJpaRepositoryIntegrationTest {

    @Autowired
    private TokenJpaRepository tokenJpaRepository;

    @Autowired
    private TestEntityManager entityManager;

    private UUID usuarioId;

    @BeforeEach
    void setUp() {
        Usuario usuario = Usuario.crear(
                "juan.perez@example.com",
                "hashedPassword",
                "Juan",
                "Pérez",
                Rol.ESTUDIANTE);
        entityManager.persist(usuario);
        entityManager.flush();
        usuarioId = usuario.getId();
    }

    @Test
    @DisplayName("Debe guardar y recuperar token correctamente")
    void debeGuardarYRecuperarToken() {
        // Given
        Token token = Token.crear(
                usuarioId,
                "refresh-token-123",
                TipoToken.REFRESH,
                LocalDateTime.now().plusDays(30),
                "Chrome/Windows",
                "192.168.1.100");

        // When
        Token tokenGuardado = tokenJpaRepository.save(token);
        entityManager.flush();
        entityManager.clear();

        Optional<Token> tokenRecuperado = tokenJpaRepository.findById(tokenGuardado.getId());

        // Then
        assertThat(tokenRecuperado).isPresent();
        assertThat(tokenRecuperado.get().getToken()).isEqualTo("refresh-token-123");
        assertThat(tokenRecuperado.get().getUsuarioId()).isEqualTo(usuarioId);
        assertThat(tokenRecuperado.get().getTipo()).isEqualTo(TipoToken.REFRESH);
        assertThat(tokenRecuperado.get().getDispositivo()).isEqualTo("Chrome/Windows");
    }

    @Test
    @DisplayName("Debe buscar token por valor del token")
    void debeBuscarTokenPorValor() {
        // Given
        Token token = Token.crear(
                usuarioId,
                "token-abc-123",
                TipoToken.REFRESH,
                LocalDateTime.now().plusDays(30),
                "Firefox",
                "10.0.0.1");
        entityManager.persist(token);
        entityManager.flush();

        // When
        Optional<Token> resultado = tokenJpaRepository.findByToken("token-abc-123");

        // Then
        assertThat(resultado).isPresent();
        assertThat(resultado.get().getToken()).isEqualTo("token-abc-123");
        assertThat(resultado.get().getDispositivo()).isEqualTo("Firefox");
    }

    @Test
    @DisplayName("Debe buscar tokens por usuario ID")
    void debeBuscarTokensPorUsuarioId() {
        // Given
        Token token1 = Token.crear(usuarioId, "token-1", TipoToken.REFRESH,
                LocalDateTime.now().plusDays(30), "Device1", "IP1");
        Token token2 = Token.crear(usuarioId, "token-2", TipoToken.REFRESH,
                LocalDateTime.now().plusDays(30), "Device2", "IP2");

        entityManager.persist(token1);
        entityManager.persist(token2);
        entityManager.flush();

        // When
        List<Token> tokens = tokenJpaRepository.findByUsuarioId(usuarioId);

        // Then
        assertThat(tokens).hasSize(2);
        assertThat(tokens).allMatch(t -> t.getUsuarioId().equals(usuarioId));
    }

    @Test
    @DisplayName("Debe buscar tokens válidos por usuario ID")
    void debeBuscarTokensValidosPorUsuarioId() {
        // Given
        Token tokenValido = Token.crear(usuarioId, "token-valido", TipoToken.REFRESH,
                LocalDateTime.now().plusDays(30), "Device1", "IP1");

        Token tokenRevocado = Token.crear(usuarioId, "token-revocado", TipoToken.REFRESH,
                LocalDateTime.now().plusDays(30), "Device2", "IP2");
        tokenRevocado.revocar();

        Token tokenExpirado = Token.crear(usuarioId, "token-expirado", TipoToken.REFRESH,
                LocalDateTime.now().minusDays(1), "Device3", "IP3");

        entityManager.persist(tokenValido);
        entityManager.persist(tokenRevocado);
        entityManager.persist(tokenExpirado);
        entityManager.flush();

        // When
        List<Token> tokensValidos = tokenJpaRepository.findTokensValidosPorUsuarioId(
                usuarioId,
                LocalDateTime.now());

        // Then
        assertThat(tokensValidos).hasSize(1);
        assertThat(tokensValidos.get(0).getToken()).isEqualTo("token-valido");
        assertThat(tokensValidos.get(0).isRevocado()).isFalse();
    }

    @Test
    @DisplayName("Debe revocar todos los tokens de un usuario")
    void debeRevocarTodosLosTokensDeUnUsuario() {
        // Given
        Token token1 = Token.crear(usuarioId, "token-1", TipoToken.REFRESH,
                LocalDateTime.now().plusDays(30), "Device1", "IP1");
        Token token2 = Token.crear(usuarioId, "token-2", TipoToken.REFRESH,
                LocalDateTime.now().plusDays(30), "Device2", "IP2");

        entityManager.persist(token1);
        entityManager.persist(token2);
        entityManager.flush();
        entityManager.clear();

        // When
        int tokensRevocados = tokenJpaRepository.revocarTodosPorUsuarioId(
                usuarioId,
                LocalDateTime.now());
        entityManager.flush();
        entityManager.clear();

        // Then
        assertThat(tokensRevocados).isEqualTo(2);

        List<Token> tokensRecuperados = tokenJpaRepository.findByUsuarioId(usuarioId);
        assertThat(tokensRecuperados).allMatch(Token::isRevocado);
    }

    @Test
    @DisplayName("Debe eliminar tokens expirados")
    void debeEliminarTokensExpirados() {
        // Given
        Token tokenValido = Token.crear(usuarioId, "token-valido", TipoToken.REFRESH,
                LocalDateTime.now().plusDays(30), "Device1", "IP1");

        Token tokenExpirado1 = Token.crear(usuarioId, "token-exp-1", TipoToken.REFRESH,
                LocalDateTime.now().minusDays(5), "Device2", "IP2");

        Token tokenExpirado2 = Token.crear(usuarioId, "token-exp-2", TipoToken.REFRESH,
                LocalDateTime.now().minusDays(10), "Device3", "IP3");

        entityManager.persist(tokenValido);
        entityManager.persist(tokenExpirado1);
        entityManager.persist(tokenExpirado2);
        entityManager.flush();
        entityManager.clear();

        // When
        int tokensEliminados = tokenJpaRepository.eliminarTokensExpirados(LocalDateTime.now());
        entityManager.flush();
        entityManager.clear();

        // Then
        assertThat(tokensEliminados).isEqualTo(2);

        List<Token> tokensRestantes = tokenJpaRepository.findByUsuarioId(usuarioId);
        assertThat(tokensRestantes).hasSize(1);
        assertThat(tokensRestantes.get(0).getToken()).isEqualTo("token-valido");
    }

    @Test
    @DisplayName("Debe contar tokens activos por usuario")
    void debeContarTokensActivosPorUsuario() {
        // Given
        Token token1 = Token.crear(usuarioId, "token-1", TipoToken.REFRESH,
                LocalDateTime.now().plusDays(30), "Device1", "IP1");
        Token token2 = Token.crear(usuarioId, "token-2", TipoToken.REFRESH,
                LocalDateTime.now().plusDays(30), "Device2", "IP2");
        Token tokenRevocado = Token.crear(usuarioId, "token-revocado", TipoToken.REFRESH,
                LocalDateTime.now().plusDays(30), "Device3", "IP3");
        tokenRevocado.revocar();

        entityManager.persist(token1);
        entityManager.persist(token2);
        entityManager.persist(tokenRevocado);
        entityManager.flush();

        // When
        long count = tokenJpaRepository.contarTokensActivosPorUsuarioId(
                usuarioId,
                LocalDateTime.now());

        // Then
        assertThat(count).isEqualTo(2);
    }

    @Test
    @DisplayName("Debe persistir timestamps de auditoría")
    void debePersistirTimestampsAuditoria() {
        // Given
        Token token = Token.crear(
                usuarioId,
                "token-timestamps",
                TipoToken.REFRESH,
                LocalDateTime.now().plusDays(30),
                "Device",
                "IP");

        // When
        Token tokenGuardado = entityManager.persist(token);
        entityManager.flush();

        // Then
        assertThat(tokenGuardado.getFechaCreacion()).isNotNull();
    }

    @Test
    @DisplayName("Debe actualizar fecha de revocación al revocar token")
    void debeActualizarFechaRevocacionAlRevocarToken() {
        // Given
        Token token = Token.crear(
                usuarioId,
                "token-to-revoke",
                TipoToken.REFRESH,
                LocalDateTime.now().plusDays(30),
                "Device",
                "IP");
        entityManager.persist(token);
        entityManager.flush();
        entityManager.clear();

        // When
        Token tokenRecuperado = tokenJpaRepository.findByToken("token-to-revoke").get();
        tokenRecuperado.revocar();
        tokenJpaRepository.save(tokenRecuperado);
        entityManager.flush();
        entityManager.clear();

        // Then
        Token tokenRevocado = tokenJpaRepository.findByToken("token-to-revoke").get();
        assertThat(tokenRevocado.isRevocado()).isTrue();
        assertThat(tokenRevocado.getFechaRevocacion()).isNotNull();
    }
}
