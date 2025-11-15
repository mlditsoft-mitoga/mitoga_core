package com.mitoga.autenticacion.application.service;

import com.mitoga.autenticacion.application.command.RefreshTokenCommand;
import com.mitoga.autenticacion.application.dto.TokenRefreshResultDto;
import com.mitoga.autenticacion.application.port.output.JwtTokenPort;
import com.mitoga.autenticacion.domain.exception.TokenInvalidoException;
import com.mitoga.autenticacion.domain.exception.UsuarioNoEncontradoException;
import com.mitoga.autenticacion.domain.model.Token;
import com.mitoga.autenticacion.domain.model.Usuario;
import com.mitoga.autenticacion.domain.model.valueobject.Rol;
import com.mitoga.autenticacion.domain.model.valueobject.TipoToken;
import com.mitoga.autenticacion.domain.repository.TokenRepository;
import com.mitoga.autenticacion.domain.repository.UsuarioRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * RefreshTokenServiceTest - Unit tests para RefreshTokenService
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("RefreshTokenService - Unit Tests")
class RefreshTokenServiceTest {

    @Mock
    private TokenRepository tokenRepository;

    @Mock
    private UsuarioRepository usuarioRepository;

    @Mock
    private JwtTokenPort jwtTokenProvider;

    @InjectMocks
    private RefreshTokenService refreshTokenService;

    private RefreshTokenCommand validCommand;
    private Token validToken;
    private Usuario usuario;

    @BeforeEach
    void setUp() {
        validCommand = new RefreshTokenCommand("valid-refresh-token-123");

        usuario = Usuario.crear(
                "juan.perez@example.com",
                "hashedPassword",
                "Juan",
                "Pérez",
                Rol.ESTUDIANTE);
        usuario.verificarEmail("123456");

        validToken = Token.crear(
                usuario.getId(),
                "valid-refresh-token-123",
                TipoToken.REFRESH,
                LocalDateTime.now().plusDays(30),
                "Chrome/Windows",
                "192.168.1.100");
    }

    @Test
    @DisplayName("Debe refrescar token exitosamente con refresh token válido")
    void debeRefrescarTokenExitosamente() {
        // Given
        when(tokenRepository.buscarPorToken(validCommand.getRefreshToken()))
                .thenReturn(Optional.of(validToken));
        when(usuarioRepository.buscarPorId(usuario.getId()))
                .thenReturn(Optional.of(usuario));
        when(jwtTokenProvider.generateAccessToken(any(), anyString(), anyString(), anyBoolean()))
                .thenReturn("new-access-token");
        when(jwtTokenProvider.generateRefreshToken(any()))
                .thenReturn("new-refresh-token");
        when(tokenRepository.guardar(any(Token.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // When
        TokenRefreshResultDto resultado = refreshTokenService.ejecutar(validCommand);

        // Then
        assertNotNull(resultado);
        assertEquals("new-access-token", resultado.getAccessToken());
        assertEquals("new-refresh-token", resultado.getRefreshToken());
        assertEquals(usuario.getId(), resultado.getUsuarioId());
        assertEquals(usuario.getEmail(), resultado.getEmail());
        assertEquals("Juan Pérez", resultado.getNombreCompleto());
        assertEquals("ESTUDIANTE", resultado.getRol());
        assertTrue(resultado.isEmailVerificado());

        // Verificar que el token anterior fue revocado
        assertTrue(validToken.isRevocado());
        verify(tokenRepository, times(1)).guardar(validToken);

        // Verificar que se guardó el nuevo token
        verify(tokenRepository, times(2)).guardar(any(Token.class));
    }

    @Test
    @DisplayName("Debe lanzar TokenInvalidoException cuando el token no existe")
    void debeLanzarExcepcionCuandoTokenNoExiste() {
        // Given
        when(tokenRepository.buscarPorToken(validCommand.getRefreshToken()))
                .thenReturn(Optional.empty());

        // When & Then
        TokenInvalidoException exception = assertThrows(
                TokenInvalidoException.class,
                () -> refreshTokenService.ejecutar(validCommand));

        assertEquals("Token inválido o expirado", exception.getMessage());

        // Verificar que NO se generaron nuevos tokens
        verify(jwtTokenProvider, never()).generateAccessToken(any(), anyString(), anyString(), anyBoolean());
        verify(jwtTokenProvider, never()).generateRefreshToken(any());
    }

    @Test
    @DisplayName("Debe lanzar TokenInvalidoException cuando el token está revocado")
    void debeLanzarExcepcionCuandoTokenRevocado() {
        // Given
        validToken.revocar();

        when(tokenRepository.buscarPorToken(validCommand.getRefreshToken()))
                .thenReturn(Optional.of(validToken));

        // When & Then
        TokenInvalidoException exception = assertThrows(
                TokenInvalidoException.class,
                () -> refreshTokenService.ejecutar(validCommand));

        assertEquals("Token inválido o expirado", exception.getMessage());

        // Verificar que NO se generaron nuevos tokens
        verify(jwtTokenProvider, never()).generateAccessToken(any(), anyString(), anyString(), anyBoolean());
    }

    @Test
    @DisplayName("Debe lanzar TokenInvalidoException cuando el token está expirado")
    void debeLanzarExcepcionCuandoTokenExpirado() {
        // Given
        Token tokenExpirado = Token.crear(
                usuario.getId(),
                "expired-token",
                TipoToken.REFRESH,
                LocalDateTime.now().minusDays(1), // Expirado hace 1 día
                "Chrome",
                "127.0.0.1");

        when(tokenRepository.buscarPorToken("expired-token"))
                .thenReturn(Optional.of(tokenExpirado));

        RefreshTokenCommand expiredCommand = new RefreshTokenCommand("expired-token");

        // When & Then
        TokenInvalidoException exception = assertThrows(
                TokenInvalidoException.class,
                () -> refreshTokenService.ejecutar(expiredCommand));

        assertEquals("Token inválido o expirado", exception.getMessage());
    }

    @Test
    @DisplayName("Debe lanzar UsuarioNoEncontradoException cuando el usuario no existe")
    void debeLanzarExcepcionCuandoUsuarioNoExiste() {
        // Given
        when(tokenRepository.buscarPorToken(validCommand.getRefreshToken()))
                .thenReturn(Optional.of(validToken));
        when(usuarioRepository.buscarPorId(usuario.getId()))
                .thenReturn(Optional.empty());

        // When & Then
        UsuarioNoEncontradoException exception = assertThrows(
                UsuarioNoEncontradoException.class,
                () -> refreshTokenService.ejecutar(validCommand));

        assertTrue(exception.getMessage().contains("Usuario no encontrado"));

        // Verificar que NO se generaron nuevos tokens
        verify(jwtTokenProvider, never()).generateAccessToken(any(), anyString(), anyString(), anyBoolean());
    }

    @Test
    @DisplayName("Debe revocar el refresh token anterior al generar uno nuevo")
    void debeRevocarTokenAnterior() {
        // Given
        assertFalse(validToken.isRevocado(), "Token debe estar no revocado inicialmente");

        when(tokenRepository.buscarPorToken(validCommand.getRefreshToken()))
                .thenReturn(Optional.of(validToken));
        when(usuarioRepository.buscarPorId(usuario.getId()))
                .thenReturn(Optional.of(usuario));
        when(jwtTokenProvider.generateAccessToken(any(), anyString(), anyString(), anyBoolean()))
                .thenReturn("new-access-token");
        when(jwtTokenProvider.generateRefreshToken(any()))
                .thenReturn("new-refresh-token");
        when(tokenRepository.guardar(any(Token.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // When
        refreshTokenService.ejecutar(validCommand);

        // Then
        assertTrue(validToken.isRevocado(), "Token debe estar revocado después del refresh");
        assertNotNull(validToken.getFechaRevocacion());
        verify(tokenRepository).guardar(validToken);
    }

    @Test
    @DisplayName("Debe generar nuevo access token con los datos actualizados del usuario")
    void debeGenerarAccessTokenConDatosActualizados() {
        // Given
        when(tokenRepository.buscarPorToken(validCommand.getRefreshToken()))
                .thenReturn(Optional.of(validToken));
        when(usuarioRepository.buscarPorId(usuario.getId()))
                .thenReturn(Optional.of(usuario));
        when(jwtTokenProvider.generateAccessToken(any(), anyString(), anyString(), anyBoolean()))
                .thenReturn("new-access-token");
        when(jwtTokenProvider.generateRefreshToken(any()))
                .thenReturn("new-refresh-token");
        when(tokenRepository.guardar(any(Token.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // When
        refreshTokenService.ejecutar(validCommand);

        // Then
        verify(jwtTokenProvider).generateAccessToken(
                eq(usuario.getId()),
                eq(usuario.getEmail()),
                eq(usuario.getRol().name()),
                eq(usuario.isEmailVerificado()));
    }

    @Test
    @DisplayName("Debe preservar información del dispositivo del token original")
    void debePreservarInformacionDispositivo() {
        // Given
        when(tokenRepository.buscarPorToken(validCommand.getRefreshToken()))
                .thenReturn(Optional.of(validToken));
        when(usuarioRepository.buscarPorId(usuario.getId()))
                .thenReturn(Optional.of(usuario));
        when(jwtTokenProvider.generateAccessToken(any(), anyString(), anyString(), anyBoolean()))
                .thenReturn("new-access-token");
        when(jwtTokenProvider.generateRefreshToken(any()))
                .thenReturn("new-refresh-token-456");
        when(tokenRepository.guardar(any(Token.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // When
        refreshTokenService.ejecutar(validCommand);

        // Then
        verify(tokenRepository).guardar(argThat(token -> token.getToken().equals("new-refresh-token-456") &&
                token.getDispositivo().equals("Chrome/Windows") &&
                token.getIpAddress().equals("192.168.1.100") &&
                token.getTipo() == TipoToken.REFRESH));
    }
}
