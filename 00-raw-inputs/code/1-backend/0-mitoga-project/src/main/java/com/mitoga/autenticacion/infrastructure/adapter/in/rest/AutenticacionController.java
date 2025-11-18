package com.mitoga.autenticacion.infrastructure.adapter.in.rest;

import com.mitoga.autenticacion.application.dto.RegistroStep1Request;
import com.mitoga.autenticacion.application.dto.RegistroStep1Response;
import com.mitoga.autenticacion.application.dto.RegistroStep1Request;
import com.mitoga.autenticacion.application.dto.RegistroStep1Response;
import com.mitoga.autenticacion.application.dto.RegistroStep2Request;
import com.mitoga.autenticacion.application.dto.RegistroStep2Response;
import com.mitoga.autenticacion.application.service.RegisterStudentStep1UseCase;
import com.mitoga.autenticacion.application.service.RegisterStudentStep2UseCase;
import com.mitoga.autenticacion.application.service.RegisterStudentStep2UseCase;
import com.mitoga.shared.infrastructure.api.response.ApiResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.ZonedDateTime;
import java.util.Map;
import java.util.UUID;

/**
 * REST Controller: Bounded Context Autenticación
 * 
 * <p>
 * Maneja todos los endpoints relacionados con autenticación:
 * - Registro multi-step (estudiantes y tutores)
 * - Verificación de email (OTP)
 * - Login y gestión de tokens JWT
 * - Recuperación de contraseña
 * </p>
 * 
 * <p>
 * <b>Base Path:</b> {@code /api/v1/auth}
 * </p>
 * 
 * <p>
 * <b>Arquitectura Hexagonal:</b>
 * </p>
 * <ul>
 * <li>Este controller es un <b>Adapter IN (Primary)</b></li>
 * <li>Invoca <b>Use Cases</b> de la capa Application</li>
 * <li>No contiene lógica de negocio (solo validación y transformación)</li>
 * </ul>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 * @since Sprint 2
 */
@Slf4j
@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AutenticacionController {

    private final RegisterStudentStep1UseCase registerStudentStep1UseCase;
    private final RegisterStudentStep2UseCase registerStudentStep2UseCase;
    // TODO: Inyectar otros Use Cases cuando se implementen
    // private final VerifyEmailUseCase verifyEmailUseCase;
    // private final LoginUseCase loginUseCase;

    /**
     * HUT-001: Registro Estudiante - STEP 1 (Credenciales)
     * 
     * <p>
     * Inicia el proceso de registro multi-step creando el usuario con
     * credenciales básicas (email + password).
     * </p>
     * 
     * <p>
     * <b>Validaciones:</b>
     * </p>
     * <ul>
     * <li>Email único (no registrado previamente)</li>
     * <li>Email válido (RFC 5322)</li>
     * <li>Password ≥ 8 caracteres con complejidad</li>
     * <li>ConfirmPassword debe coincidir</li>
     * </ul>
     * 
     * <p>
     * <b>Estado Inicial:</b> {@code PENDIENTE_VERIFICACION}
     * </p>
     * 
     * @param request DTO con credenciales (email, password, metadata)
     * @return ApiResponse con usuarioId, procesoRegistroId y email
     */
    @PostMapping("/registro/estudiante/step1")
    public ResponseEntity<ApiResponse<RegistroStep1Response>> registroEstudianteStep1(
            @Valid @RequestBody RegistroStep1Request request) {

        log.info("📝 [BC01-Autenticación] Registro Estudiante STEP 1 - Email: {}",
                request.getEmail());

        // Ejecutar Use Case
        RegistroStep1Response response = registerStudentStep1UseCase.execute(request);

        log.info("✅ Usuario creado en BD: {}", response.getUsuarioId());

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(response, "Registro STEP 1 completado exitosamente"));
    }

    /**
     * HUT-001: Registro Estudiante - STEP 2 (Información Personal)
     * 
     * @param request DTO con información personal
     * @return ApiResponse con informacionBasicaId
     */
    @PostMapping("/registro/estudiante/step2")
    public ResponseEntity<ApiResponse<RegistroStep2Response>> registroEstudianteStep2(
            @Valid @RequestBody RegistroStep2Request request) {

        log.info("📝 [BC01-Autenticación] Registro Estudiante STEP 2 - Usuario: {}",
                request.getUsuarioId());

        RegistroStep2Response response = registerStudentStep2UseCase.execute(request);

        return ResponseEntity.ok(
                ApiResponse.success(response, "Registro STEP 2 completado exitosamente"));
    }

    /**
     * HUT-003: Verificación Email con OTP
     * 
     * @param request DTO con usuarioId, email y codigoOTP
     * @return ApiResponse con tokens JWT
     */
    @PostMapping("/verificar-email")
    public ResponseEntity<ApiResponse<Map<String, Object>>> verificarEmail(
            @Valid @RequestBody Map<String, Object> request) {

        log.info("📧 [BC01-Autenticación] Verificar Email - Usuario: {}",
                request.get("usuarioId"));

        // TODO: Implementar Use Case

        Map<String, Object> tokens = Map.of(
                "accessToken", "mock-access-token-" + UUID.randomUUID(),
                "refreshToken", "mock-refresh-token-" + UUID.randomUUID(),
                "tokenType", "Bearer",
                "expiresIn", 900,
                "refreshExpiresIn", 604800);

        Map<String, Object> responseData = Map.of(
                "tokens", tokens,
                "emailVerificado", true,
                "mensaje", "Email verificado exitosamente");

        return ResponseEntity.ok(
                ApiResponse.success(responseData, "Email verificado exitosamente"));
    }

    /**
     * HUT-006: Login con JWT
     * 
     * @param request DTO con email y password
     * @return ApiResponse con tokens JWT y datos de sesión
     */
    @PostMapping("/login")
    public ResponseEntity<ApiResponse<Map<String, Object>>> login(
            @Valid @RequestBody Map<String, Object> request) {

        log.info("🔐 [BC01-Autenticación] Login - Email: {}", request.get("email"));

        // TODO: Implementar Use Case

        Map<String, Object> tokens = Map.of(
                "accessToken", "mock-access-token-" + UUID.randomUUID(),
                "refreshToken", "mock-refresh-token-" + UUID.randomUUID(),
                "tokenType", "Bearer",
                "expiresIn", 900,
                "refreshExpiresIn", 604800);

        Map<String, Object> sesion = Map.of(
                "sesionId", UUID.randomUUID().toString(),
                "dispositivo", request.getOrDefault("dispositivo", Map.of()),
                "ubicacion", "Bogotá, Colombia",
                "fechaCreacion", ZonedDateTime.now());

        Map<String, Object> usuario = Map.of(
                "usuarioId", UUID.randomUUID().toString(),
                "email", request.get("email"),
                "nombreCompleto", "Usuario Test",
                "rol", "ESTUDIANTE",
                "fotoPerfil", null);

        Map<String, Object> responseData = Map.of(
                "tokens", tokens,
                "sesion", sesion,
                "usuario", usuario);

        return ResponseEntity.ok(
                ApiResponse.success(responseData, "Login exitoso"));
    }

    /**
     * HUT-006: Refresh Token (Renovar Access Token)
     * 
     * @param request DTO con refreshToken
     * @return ApiResponse con nuevo par de tokens
     */
    @PostMapping("/refresh")
    public ResponseEntity<ApiResponse<Map<String, Object>>> refreshToken(
            @Valid @RequestBody Map<String, Object> request) {

        log.info("🔄 [BC01-Autenticación] Refresh Token");

        // TODO: Implementar Use Case

        Map<String, Object> responseData = Map.of(
                "accessToken", "mock-new-access-token-" + UUID.randomUUID(),
                "refreshToken", "mock-new-refresh-token-" + UUID.randomUUID(),
                "tokenType", "Bearer",
                "expiresIn", 900,
                "refreshExpiresIn", 604800);

        return ResponseEntity.ok(
                ApiResponse.success(responseData, "Tokens renovados exitosamente"));
    }

    /**
     * Health Check - Verificar que el módulo de autenticación está activo
     * 
     * @return ApiResponse con estado del módulo
     */
    @GetMapping("/health")
    public ResponseEntity<ApiResponse<Map<String, Object>>> health() {

        Map<String, Object> responseData = Map.of(
                "modulo", "BC01-Autenticacion",
                "estado", "ACTIVO",
                "version", "1.0.0",
                "timestamp", ZonedDateTime.now());

        return ResponseEntity.ok(
                ApiResponse.success(responseData, "Módulo de autenticación operativo"));
    }
}
