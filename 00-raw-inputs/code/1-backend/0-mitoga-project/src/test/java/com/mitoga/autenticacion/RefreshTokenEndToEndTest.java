package com.mitoga.autenticacion;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mitoga.autenticacion.domain.model.Token;
import com.mitoga.autenticacion.domain.model.Usuario;
import com.mitoga.autenticacion.domain.model.valueobject.Rol;
import com.mitoga.autenticacion.domain.model.valueobject.TipoToken;
import com.mitoga.autenticacion.domain.repository.TokenRepository;
import com.mitoga.autenticacion.domain.repository.UsuarioRepository;
import com.mitoga.autenticacion.infrastructure.web.dto.request.RefreshTokenRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

import static org.hamcrest.Matchers.notNullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * RefreshTokenEndToEndTest - Integration tests para flujo de refresh token
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 */
@SpringBootTest
@AutoConfigureMockMvc(addFilters = false)
@ActiveProfiles("test")
@Transactional
@DisplayName("Refresh Token - End-to-End Integration Tests")
class RefreshTokenEndToEndTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private TokenRepository tokenRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private Usuario usuario;

    @BeforeEach
    void setUp() {
        // Crear usuario de prueba
        usuario = Usuario.crear(
                "refresh@example.com",
                passwordEncoder.encode("Password123!"),
                "Refresh",
                "User",
                Rol.ESTUDIANTE);
        usuario.verificarEmail("123456");
        usuario = usuarioRepository.guardar(usuario);
    }

    @Test
    @DisplayName("Debe refrescar token exitosamente")
    void debeRefrescarTokenExitosamente() throws Exception {
        // Given - Token válido
        Token refreshToken = Token.crear(
                usuario.getId(),
                "valid-refresh-token-123",
                TipoToken.REFRESH,
                LocalDateTime.now().plusDays(30),
                "Chrome/Windows",
                "192.168.1.100");
        tokenRepository.guardar(refreshToken);

        RefreshTokenRequest request = new RefreshTokenRequest("valid-refresh-token-123");

        // When & Then
        mockMvc.perform(post("/api/v1/auth/refresh")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.accessToken").value(notNullValue()))
                .andExpect(jsonPath("$.refreshToken").value(notNullValue()));
    }

    @Test
    @DisplayName("Debe rechazar token expirado")
    void debeRechazarTokenExpirado() throws Exception {
        // Given - Token expirado
        Token refreshToken = Token.crear(
                usuario.getId(),
                "expired-refresh-token",
                TipoToken.REFRESH,
                LocalDateTime.now().minusDays(1), // Expirado hace 1 día
                "Device",
                "IP");
        tokenRepository.guardar(refreshToken);

        RefreshTokenRequest request = new RefreshTokenRequest("expired-refresh-token");

        // When & Then
        mockMvc.perform(post("/api/v1/auth/refresh")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("Debe rechazar token revocado")
    void debeRechazarTokenRevocado() throws Exception {
        // Given - Token revocado
        Token refreshToken = Token.crear(
                usuario.getId(),
                "revoked-refresh-token",
                TipoToken.REFRESH,
                LocalDateTime.now().plusDays(30),
                "Device",
                "IP");
        refreshToken.revocar();
        tokenRepository.guardar(refreshToken);

        RefreshTokenRequest request = new RefreshTokenRequest("revoked-refresh-token");

        // When & Then
        mockMvc.perform(post("/api/v1/auth/refresh")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("Debe rechazar token inexistente")
    void debeRechazarTokenInexistente() throws Exception {
        // Given - Token que no existe en BD
        RefreshTokenRequest request = new RefreshTokenRequest("token-no-existe-123");

        // When & Then
        mockMvc.perform(post("/api/v1/auth/refresh")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("Debe revocar token antiguo al refrescar")
    void debeRevocarTokenAntiguoAlRefrescar() throws Exception {
        // Given - Token válido
        Token refreshToken = Token.crear(
                usuario.getId(),
                "token-to-revoke-123",
                TipoToken.REFRESH,
                LocalDateTime.now().plusDays(30),
                "Device",
                "IP");
        tokenRepository.guardar(refreshToken);

        RefreshTokenRequest request = new RefreshTokenRequest("token-to-revoke-123");

        // When - Refrescar token
        mockMvc.perform(post("/api/v1/auth/refresh")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk());

        // Then - Token antiguo debe estar revocado
        Token tokenAntiguo = tokenRepository.buscarPorToken("token-to-revoke-123")
                .orElseThrow(() -> new AssertionError("Token antiguo no encontrado"));

        assert tokenAntiguo.isRevocado() : "Token antiguo debería estar revocado";
        assert tokenAntiguo.getFechaRevocacion() != null : "Fecha de revocación debe estar presente";
    }
}
