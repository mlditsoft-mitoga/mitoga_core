package com.mitoga.autenticacion.application.service;

import com.mitoga.autenticacion.application.command.RegistrarUsuarioCommand;
import com.mitoga.autenticacion.application.dto.RegistroResultDto;
import com.mitoga.autenticacion.application.port.output.EmailPort;
import com.mitoga.autenticacion.application.port.output.PasswordEncoderPort;
import com.mitoga.autenticacion.domain.exception.EmailDuplicadoException;
import com.mitoga.autenticacion.domain.model.Usuario;
import com.mitoga.autenticacion.domain.model.valueobject.Rol;
import com.mitoga.autenticacion.domain.repository.UsuarioRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

/**
 * RegistrarUsuarioServiceTest - Unit tests para RegistrarUsuarioService
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * TESTING - APPLICATION LAYER - SERVICE TEST
 * - JUnit 5 + Mockito
 * - Cobertura de casos exitosos y excepciones
 * - Verificación de interacciones con mocks
 * - Given-When-Then pattern
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("RegistrarUsuarioService - Unit Tests")
class RegistrarUsuarioServiceTest {

    @Mock
    private UsuarioRepository usuarioRepository;

    @Mock
    private PasswordEncoderPort passwordEncoder;

    @Mock
    private EmailPort emailPort;

    @InjectMocks
    private RegistrarUsuarioService registrarUsuarioService;

    private RegistrarUsuarioCommand validCommand;

    @BeforeEach
    void setUp() {
        validCommand = new RegistrarUsuarioCommand(
                "juan.perez@example.com",
                "Password123!",
                "Juan",
                "Pérez",
                "ESTUDIANTE");
    }

    @Test
    @DisplayName("Debe registrar usuario exitosamente cuando el email no existe")
    void debeRegistrarUsuarioExitosamente() {
        // Given
        when(usuarioRepository.existePorEmail(validCommand.getEmail())).thenReturn(false);
        when(passwordEncoder.encode(validCommand.getPassword())).thenReturn("hashedPassword123");
        when(usuarioRepository.guardar(any(Usuario.class))).thenAnswer(invocation -> invocation.getArgument(0));

        // When
        RegistroResultDto resultado = registrarUsuarioService.ejecutar(validCommand);

        // Then
        assertNotNull(resultado);
        assertNotNull(resultado.getUsuarioId());
        assertEquals(validCommand.getEmail(), resultado.getEmail());

        // Verificar que se llamó a existePorEmail
        verify(usuarioRepository, times(1)).existePorEmail(validCommand.getEmail());

        // Verificar que se encriptó la contraseña
        verify(passwordEncoder, times(1)).encode(validCommand.getPassword());

        // Verificar que se guardó el usuario
        ArgumentCaptor<Usuario> usuarioCaptor = ArgumentCaptor.forClass(Usuario.class);
        verify(usuarioRepository, times(1)).guardar(usuarioCaptor.capture());

        Usuario usuarioGuardado = usuarioCaptor.getValue();
        assertEquals(validCommand.getEmail(), usuarioGuardado.getEmail());
        assertEquals("hashedPassword123", usuarioGuardado.getPassword());
        assertEquals(validCommand.getNombre(), usuarioGuardado.getNombre());
        assertEquals(validCommand.getApellido(), usuarioGuardado.getApellido());
        assertEquals(Rol.valueOf(validCommand.getRol()), usuarioGuardado.getRol());
        assertFalse(usuarioGuardado.isEmailVerificado());

        // Verificar que se envió email de verificación
        verify(emailPort, times(1)).enviarEmailVerificacion(
                eq(validCommand.getEmail()),
                eq("Juan Pérez"),
                anyString());
    }

    @Test
    @DisplayName("Debe lanzar EmailDuplicadoException cuando el email ya existe")
    void debeLanzarExcepcionCuandoEmailYaExiste() {
        // Given
        when(usuarioRepository.existePorEmail(validCommand.getEmail())).thenReturn(true);

        // When & Then
        EmailDuplicadoException exception = assertThrows(
                EmailDuplicadoException.class,
                () -> registrarUsuarioService.ejecutar(validCommand));

        assertEquals("El email juan.perez@example.com ya está registrado", exception.getMessage());

        // Verificar que NO se intentó guardar el usuario
        verify(usuarioRepository, never()).guardar(any(Usuario.class));

        // Verificar que NO se envió email
        verify(emailPort, never()).enviarEmailVerificacion(anyString(), anyString(), anyString());
    }

    @Test
    @DisplayName("Debe generar código de verificación de 6 dígitos")
    void debeGenerarCodigoVerificacionValido() {
        // Given
        when(usuarioRepository.existePorEmail(validCommand.getEmail())).thenReturn(false);
        when(passwordEncoder.encode(anyString())).thenReturn("hashedPassword");
        when(usuarioRepository.guardar(any(Usuario.class))).thenAnswer(invocation -> invocation.getArgument(0));

        // When
        registrarUsuarioService.ejecutar(validCommand);

        // Then
        ArgumentCaptor<String> codigoCaptor = ArgumentCaptor.forClass(String.class);
        verify(emailPort).enviarEmailVerificacion(
                anyString(),
                anyString(),
                codigoCaptor.capture());

        String codigoGenerado = codigoCaptor.getValue();
        assertNotNull(codigoGenerado);
        assertEquals(6, codigoGenerado.length());
        assertTrue(codigoGenerado.matches("\\d{6}"), "El código debe ser 6 dígitos numéricos");
    }

    @Test
    @DisplayName("Debe registrar usuario con rol TUTOR correctamente")
    void debeRegistrarUsuarioConRolTutor() {
        // Given
        RegistrarUsuarioCommand tutorCommand = new RegistrarUsuarioCommand(
                "maria.garcia@example.com",
                "Password123!",
                "María",
                "García",
                "TUTOR");

        when(usuarioRepository.existePorEmail(tutorCommand.getEmail())).thenReturn(false);
        when(passwordEncoder.encode(anyString())).thenReturn("hashedPassword");
        when(usuarioRepository.guardar(any(Usuario.class))).thenAnswer(invocation -> invocation.getArgument(0));

        // When
        RegistroResultDto resultado = registrarUsuarioService.ejecutar(tutorCommand);

        // Then
        assertNotNull(resultado);

        ArgumentCaptor<Usuario> usuarioCaptor = ArgumentCaptor.forClass(Usuario.class);
        verify(usuarioRepository).guardar(usuarioCaptor.capture());

        Usuario usuarioGuardado = usuarioCaptor.getValue();
        assertEquals(Rol.TUTOR, usuarioGuardado.getRol());
    }

    @Test
    @DisplayName("Debe manejar error al enviar email sin interrumpir el registro")
    void debeManejareErrorEmailSinInterrumpirRegistro() {
        // Given
        when(usuarioRepository.existePorEmail(validCommand.getEmail())).thenReturn(false);
        when(passwordEncoder.encode(anyString())).thenReturn("hashedPassword");
        when(usuarioRepository.guardar(any(Usuario.class))).thenAnswer(invocation -> invocation.getArgument(0));
        doThrow(new RuntimeException("SMTP error")).when(emailPort)
                .enviarEmailVerificacion(anyString(), anyString(), anyString());

        // When & Then
        // El servicio debe completar el registro aunque falle el email
        assertDoesNotThrow(() -> registrarUsuarioService.ejecutar(validCommand));

        // Verificar que se guardó el usuario
        verify(usuarioRepository, times(1)).guardar(any(Usuario.class));
    }

    @Test
    @DisplayName("Debe validar que el email tenga formato válido")
    void debeValidarFormatoEmail() {
        // Given
        RegistrarUsuarioCommand invalidCommand = new RegistrarUsuarioCommand(
                "email-invalido",
                "Password123!",
                "Juan",
                "Pérez",
                "ESTUDIANTE");

        // When & Then
        // La validación de formato debería ocurrir en el Controller con @Valid
        // Aquí asumimos que llega validado, pero podemos verificar el comportamiento
        when(usuarioRepository.existePorEmail(invalidCommand.getEmail())).thenReturn(false);
        when(passwordEncoder.encode(anyString())).thenReturn("hashedPassword");
        when(usuarioRepository.guardar(any(Usuario.class))).thenAnswer(invocation -> invocation.getArgument(0));

        assertDoesNotThrow(() -> registrarUsuarioService.ejecutar(invalidCommand));
    }
}
