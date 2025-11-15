package com.mitoga.autenticacion.infrastructure.web.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mitoga.autenticacion.application.command.RegistrarUsuarioCommand;
import com.mitoga.autenticacion.application.port.input.dto.AutenticacionResponse;
import com.mitoga.autenticacion.application.service.RegistrarUsuarioService;
import com.mitoga.autenticacion.domain.exception.UsuarioYaExisteException;
import com.mitoga.autenticacion.infrastructure.web.dto.request.RegistroRequest;
import com.mitoga.autenticacion.infrastructure.web.dto.response.RegistroResponse;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.UUID;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * AutenticacionControllerIntegrationTest - Integration tests para
 * AutenticacionController
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * TESTING - WEB LAYER - INTEGRATION TEST
 * - Spring Boot Test con @WebMvcTest
 * - MockMvc para simular requests HTTP
 * - Verificación de responses HTTP, status codes, JSON
 * - Validación de Jakarta Validation (@Valid)
 */
@WebMvcTest(AutenticacionController.class)
@AutoConfigureMockMvc(addFilters = false) // Desactivar filtros de seguridad para testing
@DisplayName("AutenticacionController - Integration Tests")
class AutenticacionControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private RegistrarUsuarioService registrarUsuarioService;

    @MockBean
    private com.mitoga.autenticacion.application.service.LoginService loginService;

    @MockBean
    private com.mitoga.autenticacion.application.service.RefreshTokenService refreshTokenService;

    @MockBean
    private com.mitoga.autenticacion.application.service.VerificarEmailService verificarEmailService;

    @MockBean
    private com.mitoga.autenticacion.application.service.VincularOAuthService vincularOAuthService;

    @Test
    @DisplayName("POST /api/v1/auth/registro - Debe registrar usuario exitosamente")
    void debeRegistrarUsuarioExitosamente() throws Exception {
        // Given
        RegistroRequest request = new RegistroRequest(
                "juan.perez@example.com",
                "Password123!",
                "Juan",
                "Pérez",
                "ESTUDIANTE");

        UUID usuarioId = UUID.randomUUID();
        AutenticacionResponse response = AutenticacionResponse.builder()
                .usuarioId(usuarioId)
                .email("juan.perez@example.com")
                .accessToken("jwt-token-123")
                .rol("ESTUDIANTE")
                .build();

        when(registrarUsuarioService.execute(any(RegistrarUsuarioCommand.class)))
                .thenReturn(response);

        // When & Then
        mockMvc.perform(post("/api/v1/auth/registro")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.usuarioId").value(usuarioId.toString()))
                .andExpect(jsonPath("$.email").value("juan.perez@example.com"))
                .andExpect(jsonPath("$.accessToken").value("jwt-token-123"));
    }

    @Test
    @DisplayName("POST /api/v1/auth/registro - Debe retornar 400 cuando el email es inválido")
    void debeRetornar400CuandoEmailInvalido() throws Exception {
        // Given
        RegistroRequest request = new RegistroRequest(
                "email-invalido",
                "Password123!",
                "Juan",
                "Pérez",
                "ESTUDIANTE");

        // When & Then
        mockMvc.perform(post("/api/v1/auth/registro")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.status").value(400))
                .andExpect(jsonPath("$.errores.email").exists());
    }

    @Test
    @DisplayName("POST /api/v1/auth/registro - Debe retornar 400 cuando el password no cumple requisitos")
    void debeRetornar400CuandoPasswordInvalido() throws Exception {
        // Given
        RegistroRequest request = new RegistroRequest(
                "juan.perez@example.com",
                "abc123", // Password débil (sin mayúsculas, sin caracteres especiales)
                "Juan",
                "Pérez",
                "ESTUDIANTE");

        // When & Then
        mockMvc.perform(post("/api/v1/auth/registro")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.status").value(400))
                .andExpect(jsonPath("$.errores.password").exists());
    }

    @Test
    @DisplayName("POST /api/v1/auth/registro - Debe retornar 400 cuando faltan campos obligatorios")
    void debeRetornar400CuandoFaltanCampos() throws Exception {
        // Given
        RegistroRequest request = new RegistroRequest(
                null, // Email nulo
                "Password123!",
                "Juan",
                "Pérez",
                "ESTUDIANTE");

        // When & Then
        mockMvc.perform(post("/api/v1/auth/registro")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.errores.email").exists());
    }

    @Test
    @DisplayName("POST /api/v1/auth/registro - Debe retornar 409 cuando el email ya existe")
    void debeRetornar409CuandoEmailDuplicado() throws Exception {
        // Given
        RegistroRequest request = new RegistroRequest(
                "juan.perez@example.com",
                "Password123!",
                "Juan",
                "Pérez",
                "ESTUDIANTE");

        when(registrarUsuarioService.execute(any(RegistrarUsuarioCommand.class)))
                .thenThrow(new UsuarioYaExisteException("juan.perez@example.com"));

        // When & Then
        mockMvc.perform(post("/api/v1/auth/registro")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.status").value(409))
                .andExpect(jsonPath("$.mensaje").exists());
    }

    @Test
    @DisplayName("POST /api/v1/auth/registro - Debe retornar 400 cuando el rol es inválido")
    void debeRetornar400CuandoRolInvalido() throws Exception {
        // Given
        RegistroRequest request = new RegistroRequest(
                "juan.perez@example.com",
                "Password123!",
                "Juan",
                "Pérez",
                "ROL_INVALIDO" // Rol no permitido
        );

        // When & Then
        mockMvc.perform(post("/api/v1/auth/registro")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.errores.rol").exists());
    }

    @Test
    @DisplayName("POST /api/v1/auth/registro - Debe validar longitud mínima del nombre")
    void debeValidarLongitudMinimaDelNombre() throws Exception {
        // Given
        RegistroRequest request = new RegistroRequest(
                "juan.perez@example.com",
                "Password123!",
                "J", // Nombre muy corto (mínimo 2 caracteres)
                "Pérez",
                "ESTUDIANTE");

        // When & Then
        mockMvc.perform(post("/api/v1/auth/registro")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.errores.nombre").exists());
    }

    @Test
    @DisplayName("POST /api/v1/auth/registro - Debe aceptar registro con rol TUTOR")
    void debeAceptarRegistroConRolTutor() throws Exception {
        // Given
        RegistroRequest request = new RegistroRequest(
                "maria.tutor@example.com",
                "Password123!",
                "María",
                "García",
                "TUTOR");

        UUID usuarioId = UUID.randomUUID();
        AutenticacionResponse response = AutenticacionResponse.builder()
                .usuarioId(usuarioId)
                .email("maria.tutor@example.com")
                .accessToken("jwt-token-tutor")
                .rol("TUTOR")
                .build();

        when(registrarUsuarioService.execute(any(RegistrarUsuarioCommand.class)))
                .thenReturn(response);

        // When & Then
        mockMvc.perform(post("/api/v1/auth/registro")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.email").value("maria.tutor@example.com"));
    }
}
