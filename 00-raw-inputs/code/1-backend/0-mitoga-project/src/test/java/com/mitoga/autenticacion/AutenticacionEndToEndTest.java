package com.mitoga.autenticacion;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mitoga.autenticacion.domain.model.Usuario;
import com.mitoga.autenticacion.domain.model.valueobject.Rol;
import com.mitoga.autenticacion.domain.repository.UsuarioRepository;
import com.mitoga.autenticacion.infrastructure.web.dto.request.LoginRequest;
import com.mitoga.autenticacion.infrastructure.web.dto.request.RegistroRequest;
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

import static org.hamcrest.Matchers.notNullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * AutenticacionEndToEndTest - Integration tests end-to-end para flujo de
 * autenticación
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * TESTING - END-TO-END - INTEGRATION TEST
 * - @SpringBootTest carga todo el contexto de Spring
 * - Testea el flujo completo: Registro → Verificación → Login
 * - Base de datos H2 en memoria (application-test.yml)
 * - @Transactional para rollback automático
 */
@SpringBootTest
@AutoConfigureMockMvc(addFilters = false)
@ActiveProfiles("test")
@Transactional
@DisplayName("Autenticación - End-to-End Integration Tests")
class AutenticacionEndToEndTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @BeforeEach
    void limpiarBaseDatos() {
        // Limpiar datos de pruebas anteriores (por si @Transactional falla)
        usuarioRepository.buscarPorEmail("test@example.com")
                .ifPresent(usuario -> usuarioRepository.eliminar(usuario.getId()));
    }

    @Test
    @DisplayName("Flujo completo: Registro → Login exitoso")
    void flujosCompletoRegistroYLogin() throws Exception {
        // Given - Datos de registro
        RegistroRequest registroRequest = new RegistroRequest(
                "test@example.com",
                "Password123!",
                "Test",
                "Usuario",
                "ESTUDIANTE");

        // When - Registro
        mockMvc.perform(post("/api/v1/auth/registro")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(registroRequest)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.email").value("test@example.com"))
                .andExpect(jsonPath("$.mensaje").exists());

        // Then - Verificar que el usuario existe en BD
        Usuario usuario = usuarioRepository.buscarPorEmail("test@example.com")
                .orElseThrow(() -> new AssertionError("Usuario no encontrado en BD"));

        // When - Login
        LoginRequest loginRequest = new LoginRequest(
                "test@example.com",
                "Password123!",
                "Chrome/Windows",
                "192.168.1.100");

        // Then - Login exitoso
        mockMvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.accessToken").value(notNullValue()))
                .andExpect(jsonPath("$.refreshToken").value(notNullValue()))
                .andExpect(jsonPath("$.email").value("test@example.com"));
    }

    @Test
    @DisplayName("Registro debe fallar con email duplicado")
    void registroDebeFallarConEmailDuplicado() throws Exception {
        // Given - Usuario ya existe en BD
        Usuario usuarioExistente = Usuario.crear(
                "duplicado@example.com",
                passwordEncoder.encode("Password123!"),
                "Usuario",
                "Existente",
                Rol.ESTUDIANTE);
        usuarioRepository.guardar(usuarioExistente);

        // When - Intento de registro con mismo email
        RegistroRequest registroRequest = new RegistroRequest(
                "duplicado@example.com",
                "OtraPassword123!",
                "Nuevo",
                "Usuario",
                "TUTOR");

        // Then - Debe retornar 409 Conflict
        mockMvc.perform(post("/api/v1/auth/registro")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(registroRequest)))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.mensaje").exists());
    }

    @Test
    @DisplayName("Login debe fallar con credenciales incorrectas")
    void loginDebeFallarConCredencialesIncorrectas() throws Exception {
        // Given - Usuario existe con password correcto
        Usuario usuario = Usuario.crear(
                "login@example.com",
                passwordEncoder.encode("CorrectPassword123!"),
                "Login",
                "User",
                Rol.ESTUDIANTE);
        usuarioRepository.guardar(usuario);

        // When - Login con password incorrecto
        LoginRequest loginRequest = new LoginRequest(
                "login@example.com",
                "PasswordIncorrecto!",
                "Device",
                "IP");

        // Then - Debe retornar 401 Unauthorized
        mockMvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("Login debe fallar cuando usuario no existe")
    void loginDebeFallarCuandoUsuarioNoExiste() throws Exception {
        // Given - Usuario NO existe
        LoginRequest loginRequest = new LoginRequest(
                "noexiste@example.com",
                "Password123!",
                "Device",
                "IP");

        // When & Then - Debe retornar 401 Unauthorized
        mockMvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("Registro debe validar formato de email")
    void registroDebeValidarFormatoEmail() throws Exception {
        // Given - Email inválido
        RegistroRequest registroRequest = new RegistroRequest(
                "email-invalido",
                "Password123!",
                "Test",
                "User",
                "ESTUDIANTE");

        // When & Then - Debe retornar 400 Bad Request
        mockMvc.perform(post("/api/v1/auth/registro")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(registroRequest)))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("Registro debe validar fortaleza de password")
    void registroDebeValidarFortalezaPassword() throws Exception {
        // Given - Password débil
        RegistroRequest registroRequest = new RegistroRequest(
                "test@example.com",
                "123456", // Password sin mayúsculas ni caracteres especiales
                "Test",
                "User",
                "ESTUDIANTE");

        // When & Then - Debe retornar 400 Bad Request
        mockMvc.perform(post("/api/v1/auth/registro")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(registroRequest)))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("Registro debe validar campos obligatorios")
    void registroDebeValidarCamposObligatorios() throws Exception {
        // Given - Request incompleto (sin email)
        String requestIncompleto = """
                {
                    "password": "Password123!",
                    "nombre": "Test",
                    "apellido": "User",
                    "rol": "ESTUDIANTE"
                }
                """;

        // When & Then - Debe retornar 400 Bad Request
        mockMvc.perform(post("/api/v1/auth/registro")
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestIncompleto))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("Registro debe aceptar rol TUTOR")
    void registroDebeAceptarRolTutor() throws Exception {
        // Given - Registro con rol TUTOR
        RegistroRequest registroRequest = new RegistroRequest(
                "tutor@example.com",
                "Password123!",
                "Profesor",
                "Tutor",
                "TUTOR");

        // When & Then - Debe registrar exitosamente
        mockMvc.perform(post("/api/v1/auth/registro")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(registroRequest)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.email").value("tutor@example.com"));
    }
}
