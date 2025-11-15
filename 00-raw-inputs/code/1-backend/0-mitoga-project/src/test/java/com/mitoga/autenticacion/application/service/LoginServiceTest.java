package com.mitoga.autenticacion.application.service;

import com.mitoga.autenticacion.application.command.LoginCommand;
import com.mitoga.autenticacion.application.dto.LoginResultDto;
import com.mitoga.autenticacion.application.port.output.JwtTokenPort;
import com.mitoga.autenticacion.application.port.output.PasswordEncoderPort;
import com.mitoga.autenticacion.domain.exception.CuentaBloqueadaException;
import com.mitoga.autenticacion.domain.exception.CredencialesInvalidasException;
import com.mitoga.autenticacion.domain.exception.UsuarioNoEncontradoException;
import com.mitoga.autenticacion.domain.model.Token;
import com.mitoga.autenticacion.domain.model.Usuario;
import com.mitoga.autenticacion.domain.model.valueobject.EstadoCuenta;
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
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

/**
 * LoginServiceTest - Unit tests para LoginService
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("LoginService - Unit Tests")
class LoginServiceTest {

    @Mock
    private UsuarioRepository usuarioRepository;

    @Mock
    private TokenRepository tokenRepository;

    @Mock
    private PasswordEncoderPort passwordEncoder;

    @Mock
    private JwtTokenPort jwtTokenProvider;

    @InjectMocks
    private LoginService loginService;

    private LoginCommand validCommand;
    private Usuario usuarioActivo;

    @BeforeEach
    void setUp() {
        validCommand = new LoginCommand(
                "juan.perez@example.com",
                "Password123!",
                "Chrome/Windows",
                "192.168.1.100");

        usuarioActivo = Usuario.crear(
                "juan.perez@example.com",
                "hashedPassword123",
                "Juan",
                "Pérez",
                Rol.ESTUDIANTE);
        usuarioActivo.verificarEmail("123456");
    }

    @Test
    @DisplayName("Debe realizar login exitosamente con credenciales válidas")
    void debeRealizarLoginExitosamente() {
        // Given
        when(usuarioRepository.buscarPorEmail(validCommand.getEmail()))
                .thenReturn(Optional.of(usuarioActivo));
        when(passwordEncoder.matches(validCommand.getPassword(), usuarioActivo.getPassword()))
                .thenReturn(true);
        when(jwtTokenProvider.generateAccessToken(any(), anyString(), anyString(), anyBoolean()))
                .thenReturn("access-token-123");
        when(jwtTokenProvider.generateRefreshToken(any()))
                .thenReturn("refresh-token-456");
        when(tokenRepository.guardar(any(Token.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // When
        LoginResultDto resultado = loginService.ejecutar(validCommand);

        // Then
        assertNotNull(resultado);
        assertEquals("access-token-123", resultado.getAccessToken());
        assertEquals("refresh-token-456", resultado.getRefreshToken());
        assertEquals(usuarioActivo.getId(), resultado.getUsuarioId());
        assertEquals(usuarioActivo.getEmail(), resultado.getEmail());
        assertEquals("Juan Pérez", resultado.getNombreCompleto());
        assertEquals("ESTUDIANTE", resultado.getRol());
        assertTrue(resultado.isEmailVerificado());

        // Verificar interacciones
        verify(usuarioRepository, times(1)).buscarPorEmail(validCommand.getEmail());
        verify(passwordEncoder, times(1)).matches(validCommand.getPassword(), usuarioActivo.getPassword());
        verify(tokenRepository, times(1)).guardar(any(Token.class));
        verify(usuarioRepository, times(1)).guardar(usuarioActivo);
    }

    @Test
    @DisplayName("Debe lanzar UsuarioNoEncontradoException cuando el email no existe")
    void debeLanzarExcepcionCuandoUsuarioNoExiste() {
        // Given
        when(usuarioRepository.buscarPorEmail(validCommand.getEmail()))
                .thenReturn(Optional.empty());

        // When & Then
        UsuarioNoEncontradoException exception = assertThrows(
                UsuarioNoEncontradoException.class,
                () -> loginService.ejecutar(validCommand));

        assertEquals("Usuario no encontrado con email: juan.perez@example.com", exception.getMessage());

        // Verificar que NO se intentaron otras operaciones
        verify(passwordEncoder, never()).matches(anyString(), anyString());
        verify(jwtTokenProvider, never()).generateAccessToken(any(), anyString(), anyString(), anyBoolean());
    }

    @Test
    @DisplayName("Debe lanzar CredencialesInvalidasException cuando la contraseña es incorrecta")
    void debeLanzarExcepcionCuandoPasswordIncorrecto() {
        // Given
        when(usuarioRepository.buscarPorEmail(validCommand.getEmail()))
                .thenReturn(Optional.of(usuarioActivo));
        when(passwordEncoder.matches(validCommand.getPassword(), usuarioActivo.getPassword()))
                .thenReturn(false);

        // When & Then
        CredencialesInvalidasException exception = assertThrows(
                CredencialesInvalidasException.class,
                () -> loginService.ejecutar(validCommand));

        assertEquals("Credenciales inválidas", exception.getMessage());

        // Verificar que NO se generaron tokens
        verify(jwtTokenProvider, never()).generateAccessToken(any(), anyString(), anyString(), anyBoolean());
        verify(tokenRepository, never()).guardar(any(Token.class));
    }

    @Test
    @DisplayName("Debe lanzar CuentaBloqueadaException cuando la cuenta está bloqueada")
    void debeLanzarExcepcionCuandoCuentaBloqueada() {
        // Given
        usuarioActivo.bloquearCuenta("Demasiados intentos fallidos");

        when(usuarioRepository.buscarPorEmail(validCommand.getEmail()))
                .thenReturn(Optional.of(usuarioActivo));
        when(passwordEncoder.matches(validCommand.getPassword(), usuarioActivo.getPassword()))
                .thenReturn(true);

        // When & Then
        CuentaBloqueadaException exception = assertThrows(
                CuentaBloqueadaException.class,
                () -> loginService.ejecutar(validCommand));

        assertTrue(exception.getMessage().contains("bloqueada"));

        // Verificar que NO se generaron tokens
        verify(jwtTokenProvider, never()).generateAccessToken(any(), anyString(), anyString(), anyBoolean());
    }

    @Test
    @DisplayName("Debe actualizar último acceso del usuario al hacer login")
    void debeActualizarUltimoAcceso() {
        // Given
        LocalDateTime fechaAnterior = usuarioActivo.getUltimoAcceso();

        when(usuarioRepository.buscarPorEmail(validCommand.getEmail()))
                .thenReturn(Optional.of(usuarioActivo));
        when(passwordEncoder.matches(anyString(), anyString())).thenReturn(true);
        when(jwtTokenProvider.generateAccessToken(any(), anyString(), anyString(), anyBoolean()))
                .thenReturn("access-token");
        when(jwtTokenProvider.generateRefreshToken(any())).thenReturn("refresh-token");
        when(tokenRepository.guardar(any(Token.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // When
        loginService.ejecutar(validCommand);

        // Then
        verify(usuarioRepository, times(1)).guardar(usuarioActivo);
        assertNotNull(usuarioActivo.getUltimoAcceso());
    }

    @Test
    @DisplayName("Debe guardar refresh token con información del dispositivo")
    void debeGuardarRefreshTokenConInfoDispositivo() {
        // Given
        when(usuarioRepository.buscarPorEmail(validCommand.getEmail()))
                .thenReturn(Optional.of(usuarioActivo));
        when(passwordEncoder.matches(anyString(), anyString())).thenReturn(true);
        when(jwtTokenProvider.generateAccessToken(any(), anyString(), anyString(), anyBoolean()))
                .thenReturn("access-token");
        when(jwtTokenProvider.generateRefreshToken(any())).thenReturn("refresh-token-123");
        when(tokenRepository.guardar(any(Token.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // When
        loginService.ejecutar(validCommand);

        // Then
        verify(tokenRepository, times(1)).guardar(argThat(token -> token.getToken().equals("refresh-token-123") &&
                token.getDispositivo().equals("Chrome/Windows") &&
                token.getIpAddress().equals("192.168.1.100") &&
                token.getTipo() == TipoToken.REFRESH &&
                !token.isRevocado()));
    }

    @Test
    @DisplayName("Debe permitir login aunque el email no esté verificado")
    void debePermitirLoginConEmailNoVerificado() {
        // Given
        Usuario usuarioSinVerificar = Usuario.crear(
                "nuevo@example.com",
                "hashedPassword",
                "Nuevo",
                "Usuario",
                Rol.ESTUDIANTE);

        when(usuarioRepository.buscarPorEmail("nuevo@example.com"))
                .thenReturn(Optional.of(usuarioSinVerificar));
        when(passwordEncoder.matches(anyString(), anyString())).thenReturn(true);
        when(jwtTokenProvider.generateAccessToken(any(), anyString(), anyString(), anyBoolean()))
                .thenReturn("access-token");
        when(jwtTokenProvider.generateRefreshToken(any())).thenReturn("refresh-token");
        when(tokenRepository.guardar(any(Token.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        LoginCommand command = new LoginCommand(
                "nuevo@example.com",
                "Password123!",
                "Chrome",
                "127.0.0.1");

        // When
        LoginResultDto resultado = loginService.ejecutar(command);

        // Then
        assertNotNull(resultado);
        assertFalse(resultado.isEmailVerificado());
        verify(jwtTokenProvider).generateAccessToken(
                any(),
                eq("nuevo@example.com"),
                eq("ESTUDIANTE"),
                eq(false) // emailVerificado = false
        );
    }
}
