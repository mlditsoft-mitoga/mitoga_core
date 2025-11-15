package com.mitoga.autenticacion.infrastructure.web.controller;

import com.mitoga.autenticacion.application.command.*;
import com.mitoga.autenticacion.application.port.input.AutenticacionResponse;
import com.mitoga.autenticacion.application.port.input.VerificacionResponse;
import com.mitoga.autenticacion.application.service.*;
import com.mitoga.autenticacion.infrastructure.web.dto.request.*;
import com.mitoga.autenticacion.infrastructure.web.dto.response.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * AutenticacionController - REST Controller para BC Autenticación
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - WEB LAYER - REST CONTROLLER
 * - Expone 7 endpoints REST para autenticación
 * - Usa Commands del Application Layer (CQRS)
 * - DTOs para Request/Response
 * - Validación con @Valid (Jakarta Validation)
 * 
 * ENDPOINTS:
 * POST /api/v1/auth/registro - Registrar nuevo usuario
 * POST /api/v1/auth/login - Login con email/password
 * POST /api/v1/auth/refresh-token - Refrescar access token
 * POST /api/v1/auth/verificar-email - Verificar código de email
 * POST /api/v1/auth/reenviar-codigo - Reenviar código de verificación
 */
@RestController
@RequestMapping("/api/v1/auth")
public class AutenticacionController {

    private static final Logger logger = LoggerFactory.getLogger(AutenticacionController.class);

    private final RegistrarUsuarioService registrarUsuarioService;
    private final LoginService loginService;
    private final RefreshTokenService refreshTokenService;
    private final VerificarEmailService verificarEmailService;

    public AutenticacionController(
            RegistrarUsuarioService registrarUsuarioService,
            LoginService loginService,
            RefreshTokenService refreshTokenService,
            VerificarEmailService verificarEmailService) {
        this.registrarUsuarioService = registrarUsuarioService;
        this.loginService = loginService;
        this.refreshTokenService = refreshTokenService;
        this.verificarEmailService = verificarEmailService;
    }

    /**
     * POST /api/v1/auth/registro
     * Registrar nuevo usuario con email/password
     */
    @PostMapping("/registro")
    public ResponseEntity<RegistroResponse> registrarUsuario(
            @Valid @RequestBody RegistroRequest request) {
        logger.info("Solicitud de registro para email: {}", request.getEmail());

        RegistrarUsuarioCommand command = new RegistrarUsuarioCommand(
                request.getEmail(),
                request.getPassword(),
                request.getNombre(),
                request.getApellido(),
                request.getRol());

        AutenticacionResponse resultado = registrarUsuarioService.registrar(command);

        RegistroResponse response = new RegistroResponse(
                resultado.getUsuarioId().toString(),
                resultado.getEmail(),
                "Usuario registrado exitosamente. Revisa tu email para verificar tu cuenta.");

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    /**
     * POST /api/v1/auth/login
     * Login con email y password
     */
    @PostMapping("/login")
    public ResponseEntity<TokenResponse> login(
            @Valid @RequestBody LoginRequest request,
            HttpServletRequest httpRequest) {
        logger.info("Solicitud de login para email: {}", request.getEmail());

        String dispositivo = request.getDispositivo() != null
                ? request.getDispositivo()
                : httpRequest.getHeader("User-Agent");

        String ipAddress = request.getIpAddress() != null
                ? request.getIpAddress()
                : httpRequest.getRemoteAddr();

        LoginCommand command = new LoginCommand(
                request.getEmail(),
                request.getPassword(),
                ipAddress,
                dispositivo);

        AutenticacionResponse resultado = loginService.login(command);

        TokenResponse.UsuarioInfoDto usuarioInfo = new TokenResponse.UsuarioInfoDto(
                resultado.getUsuarioId().toString(),
                resultado.getEmail(),
                resultado.getNombre() + " " + resultado.getApellido(),
                resultado.getRol(),
                resultado.getEstadoCuenta().equals("ACTIVA"));

        TokenResponse response = new TokenResponse(
                resultado.getAccessToken(),
                resultado.getRefreshToken(),
                resultado.getExpiresIn(),
                usuarioInfo);

        return ResponseEntity.ok(response);
    }

    /**
     * POST /api/v1/auth/refresh-token
     * Refrescar access token usando refresh token
     */
    @PostMapping("/refresh-token")
    public ResponseEntity<TokenResponse> refreshToken(
            @Valid @RequestBody RefreshTokenRequest request,
            HttpServletRequest httpRequest) {
        logger.info("Solicitud de refresh token");

        String ipAddress = httpRequest.getRemoteAddr();
        String userAgent = httpRequest.getHeader("User-Agent");

        RefreshTokenCommand command = new RefreshTokenCommand(
                request.getRefreshToken(),
                ipAddress,
                userAgent);

        AutenticacionResponse resultado = refreshTokenService.refreshToken(command);

        TokenResponse.UsuarioInfoDto usuarioInfo = new TokenResponse.UsuarioInfoDto(
                resultado.getUsuarioId().toString(),
                resultado.getEmail(),
                resultado.getNombre() + " " + resultado.getApellido(),
                resultado.getRol(),
                resultado.getEstadoCuenta().equals("ACTIVA"));

        TokenResponse response = new TokenResponse(
                resultado.getAccessToken(),
                resultado.getRefreshToken(),
                resultado.getExpiresIn(),
                usuarioInfo);

        return ResponseEntity.ok(response);
    }

    /**
     * POST /api/v1/auth/verificar-email
     * Verificar email con código de 6 dígitos
     */
    @PostMapping("/verificar-email")
    public ResponseEntity<MessageResponse> verificarEmail(
            @Valid @RequestBody VerificarEmailRequest request) {
        logger.info("Solicitud de verificación de email: {}", request.getEmail());

        VerificarEmailCommand command = new VerificarEmailCommand(
                request.getEmail(),
                request.getCodigo());

        VerificacionResponse resultado = verificarEmailService.verificarEmail(command);

        MessageResponse response = new MessageResponse(
                resultado.getMensaje(),
                resultado.getVerificado());

        return ResponseEntity.ok(response);
    }

    /**
     * POST /api/v1/auth/reenviar-codigo
     * Reenviar código de verificación
     */
    @PostMapping("/reenviar-codigo")
    public ResponseEntity<MessageResponse> reenviarCodigo(
            @RequestParam String email) {
        logger.info("Solicitud de reenvío de código para: {}", email);

        // TODO: Implementar servicio ReenviarCodigoService
        // Por ahora retornamos respuesta de ejemplo

        MessageResponse response = new MessageResponse(
                "Código de verificación reenviado a " + email,
                true);

        return ResponseEntity.ok(response);
    }
}
