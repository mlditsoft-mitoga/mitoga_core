package com.mitoga.autenticacion.application.service;

import com.mitoga.autenticacion.application.command.VerificarEmailCommand;
import com.mitoga.autenticacion.application.port.output.EmailPort;
import com.mitoga.autenticacion.domain.exception.TokenInvalidoException;
import com.mitoga.autenticacion.domain.exception.UsuarioNoEncontradoException;
import com.mitoga.autenticacion.domain.model.Usuario;
import com.mitoga.autenticacion.domain.model.valueobject.EstadoCuenta;
import com.mitoga.autenticacion.domain.model.valueobject.Rol;
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

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

/**
 * VerificarEmailServiceTest - Unit tests para VerificarEmailService
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("VerificarEmailService - Unit Tests")
class VerificarEmailServiceTest {

    @Mock
    private UsuarioRepository usuarioRepository;

    @Mock
    private EmailPort emailPort;

    @InjectMocks
    private VerificarEmailService verificarEmailService;

    private VerificarEmailCommand validCommand;
    private Usuario usuarioSinVerificar;

    @BeforeEach
    void setUp() {
        validCommand = new VerificarEmailCommand(
                "juan.perez@example.com",
                "123456");

        usuarioSinVerificar = Usuario.crear(
                "juan.perez@example.com",
                "hashedPassword",
                "Juan",
                "Pérez",
                Rol.ESTUDIANTE);
        // Simular que se generó un código de verificación
        usuarioSinVerificar.actualizarCodigoVerificacion("123456", LocalDateTime.now().plusMinutes(5));
    }

    @Test
    @DisplayName("Debe verificar email exitosamente con código válido")
    void debeVerificarEmailExitosamente() {
        // Given
        when(usuarioRepository.buscarPorEmail(validCommand.getEmail()))
                .thenReturn(Optional.of(usuarioSinVerificar));
        when(usuarioRepository.guardar(any(Usuario.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // When
        assertDoesNotThrow(() -> verificarEmailService.ejecutar(validCommand));

        // Then
        assertTrue(usuarioSinVerificar.isEmailVerificado());
        assertEquals(EstadoCuenta.ACTIVA, usuarioSinVerificar.getEstadoCuenta());

        // Verificar que se guardó el usuario
        verify(usuarioRepository, times(1)).guardar(usuarioSinVerificar);

        // Verificar que se envió email de bienvenida
        verify(emailPort, times(1)).enviarEmailBienvenida(
                eq(usuarioSinVerificar.getEmail()),
                eq("Juan Pérez"));
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
                () -> verificarEmailService.ejecutar(validCommand));

        assertEquals("Usuario no encontrado con email: juan.perez@example.com", exception.getMessage());

        // Verificar que NO se envió email de bienvenida
        verify(emailPort, never()).enviarEmailBienvenida(anyString(), anyString());
    }

    @Test
    @DisplayName("Debe lanzar TokenInvalidoException cuando el código es incorrecto")
    void debeLanzarExcepcionCuandoCodigoIncorrecto() {
        // Given
        when(usuarioRepository.buscarPorEmail(validCommand.getEmail()))
                .thenReturn(Optional.of(usuarioSinVerificar));

        VerificarEmailCommand comandoInvalido = new VerificarEmailCommand(
                "juan.perez@example.com",
                "999999" // Código incorrecto
        );

        // When & Then
        TokenInvalidoException exception = assertThrows(
                TokenInvalidoException.class,
                () -> verificarEmailService.ejecutar(comandoInvalido));

        assertTrue(exception.getMessage().contains("inválido o expirado"));

        // Verificar que el usuario NO quedó verificado
        assertFalse(usuarioSinVerificar.isEmailVerificado());

        // Verificar que NO se envió email de bienvenida
        verify(emailPort, never()).enviarEmailBienvenida(anyString(), anyString());
    }

    @Test
    @DisplayName("Debe lanzar TokenInvalidoException cuando el código está expirado")
    void debeLanzarExcepcionCuandoCodigoExpirado() {
        // Given
        usuarioSinVerificar.actualizarCodigoVerificacion(
                "123456",
                LocalDateTime.now().minusMinutes(10) // Expirado hace 10 minutos
        );

        when(usuarioRepository.buscarPorEmail(validCommand.getEmail()))
                .thenReturn(Optional.of(usuarioSinVerificar));

        // When & Then
        TokenInvalidoException exception = assertThrows(
                TokenInvalidoException.class,
                () -> verificarEmailService.ejecutar(validCommand));

        assertTrue(exception.getMessage().contains("expirado"));

        // Verificar que el usuario NO quedó verificado
        assertFalse(usuarioSinVerificar.isEmailVerificado());
    }

    @Test
    @DisplayName("Debe permitir verificar email solo una vez")
    void debePermitirVerificarSoloUnaVez() {
        // Given
        usuarioSinVerificar.verificarEmail("123456");
        assertTrue(usuarioSinVerificar.isEmailVerificado());

        when(usuarioRepository.buscarPorEmail(validCommand.getEmail()))
                .thenReturn(Optional.of(usuarioSinVerificar));

        // When
        assertDoesNotThrow(() -> verificarEmailService.ejecutar(validCommand));

        // Then - El usuario ya está verificado, no debería hacer nada adicional
        verify(usuarioRepository, times(1)).guardar(any(Usuario.class));

        // El email de bienvenida solo se envía una vez (cuando se verifica por primera
        // vez)
        verify(emailPort, times(1)).enviarEmailBienvenida(anyString(), anyString());
    }

    @Test
    @DisplayName("Debe manejar error al enviar email de bienvenida sin interrumpir verificación")
    void debeManejareErrorEmailSinInterrumpirVerificacion() {
        // Given
        when(usuarioRepository.buscarPorEmail(validCommand.getEmail()))
                .thenReturn(Optional.of(usuarioSinVerificar));
        when(usuarioRepository.guardar(any(Usuario.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));
        doThrow(new RuntimeException("SMTP error"))
                .when(emailPort).enviarEmailBienvenida(anyString(), anyString());

        // When & Then
        // La verificación debe completarse aunque falle el email
        assertDoesNotThrow(() -> verificarEmailService.ejecutar(validCommand));

        // Verificar que el usuario quedó verificado
        assertTrue(usuarioSinVerificar.isEmailVerificado());
        verify(usuarioRepository, times(1)).guardar(usuarioSinVerificar);
    }

    @Test
    @DisplayName("Debe validar formato del código de verificación")
    void debeValidarFormatoCodigo() {
        // Given
        when(usuarioRepository.buscarPorEmail(validCommand.getEmail()))
                .thenReturn(Optional.of(usuarioSinVerificar));

        VerificarEmailCommand codigoInvalidoFormato = new VerificarEmailCommand(
                "juan.perez@example.com",
                "ABC123" // Formato inválido (debe ser 6 dígitos numéricos)
        );

        // When & Then
        TokenInvalidoException exception = assertThrows(
                TokenInvalidoException.class,
                () -> verificarEmailService.ejecutar(codigoInvalidoFormato));

        assertTrue(exception.getMessage().contains("inválido"));

        // Verificar que el usuario NO quedó verificado
        assertFalse(usuarioSinVerificar.isEmailVerificado());
    }

    @Test
    @DisplayName("Debe actualizar estado de cuenta a ACTIVA después de verificar")
    void debeActualizarEstadoCuentaAActiva() {
        // Given
        assertEquals(EstadoCuenta.PENDIENTE_VERIFICACION, usuarioSinVerificar.getEstadoCuenta());

        when(usuarioRepository.buscarPorEmail(validCommand.getEmail()))
                .thenReturn(Optional.of(usuarioSinVerificar));
        when(usuarioRepository.guardar(any(Usuario.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // When
        verificarEmailService.ejecutar(validCommand);

        // Then
        assertEquals(EstadoCuenta.ACTIVA, usuarioSinVerificar.getEstadoCuenta());
        assertTrue(usuarioSinVerificar.isEmailVerificado());
    }
}
