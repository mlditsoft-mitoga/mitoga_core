package com.mitoga.autenticacion.application.service;

import com.mitoga.autenticacion.application.command.LoginCommand;
import com.mitoga.autenticacion.application.port.input.LoginUseCase;
import com.mitoga.autenticacion.application.port.input.AutenticacionResponse;
import com.mitoga.autenticacion.application.port.output.JwtTokenPort;
import com.mitoga.autenticacion.application.port.output.PasswordEncoderPort;
import com.mitoga.autenticacion.domain.exception.CredencialesInvalidasException;
import com.mitoga.autenticacion.domain.exception.CuentaBloqueadaException;
import com.mitoga.autenticacion.domain.model.Token;
import com.mitoga.autenticacion.domain.model.Usuario;
import com.mitoga.autenticacion.domain.repository.TokenRepository;
import com.mitoga.autenticacion.domain.repository.UsuarioRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;
import java.util.Map;

/**
 * LoginService - ImplementaciÃƒÂ³n del caso de uso de login
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - SERVICE
 * - Orquesta el login de usuarios (tradicional y OAuth)
 * - Gestiona refresh tokens y dispositivos
 * - Aplica reglas de seguridad (bloqueo por intentos)
 * - NO contiene lÃƒÂ³gica de negocio (eso es del dominio)
 */
@Service
@Transactional
public class LoginService implements LoginUseCase {

    private final UsuarioRepository usuarioRepository;
    private final TokenRepository tokenRepository;
    private final PasswordEncoderPort passwordEncoder;
    private final JwtTokenPort jwtTokenPort;

    private static final int DIAS_VALIDEZ_REFRESH_TOKEN = 30;

    public LoginService(
            UsuarioRepository usuarioRepository,
            TokenRepository tokenRepository,
            PasswordEncoderPort passwordEncoder,
            JwtTokenPort jwtTokenPort) {
        this.usuarioRepository = usuarioRepository;
        this.tokenRepository = tokenRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtTokenPort = jwtTokenPort;
    }

    /**
     * Login con credenciales tradicionales (email + password)
     */
    @Override
    public AutenticacionResponse login(LoginCommand command) {
        // Buscar usuario por email
        Usuario usuario = usuarioRepository.buscarPorEmail(command.getEmail())
                .orElseThrow(() -> new CredencialesInvalidasException());

        // Verificar si la cuenta estÃƒÂ¡ bloqueada
        if (usuario.getEstadoCuenta() == Usuario.EstadoCuenta.BLOQUEADA) {
            throw new CuentaBloqueadaException(
                    usuario.getMotivoBloqueo() != null ? usuario.getMotivoBloqueo() : "Motivo no especificado");
        }

        // Verificar contraseÃƒÂ±a
        if (!passwordEncoder.matches(command.getPassword(), usuario.getPasswordHash())) {
            usuario.registrarLoginFallido();
            usuarioRepository.guardar(usuario);
            throw new CredencialesInvalidasException();
        }

        // Verificar que el usuario puede hacer login
        if (!usuario.puedeHacerLogin()) {
            throw new IllegalStateException(
                    "Cuenta no verificada. Verifica tu email antes de iniciar sesiÃƒÂ³n.");
        }

        // Login exitoso
        usuario.registrarLoginExitoso();
        usuarioRepository.guardar(usuario);

        // Generar JWT
        String accessToken = jwtTokenPort.generateAccessToken(
                usuario.getId(),
                usuario.getEmail(),
                usuario.getRol().name(),
                Map.of("emailVerificado", usuario.getEmailVerificado()));

        // Generar Refresh Token
        String refreshTokenValue = jwtTokenPort.generateRefreshToken();

        Token refreshToken = Token.crear(
                usuario.getId(),
                refreshTokenValue,
                DIAS_VALIDEZ_REFRESH_TOKEN,
                command.getIpAddress(),
                command.getUserAgent());

        tokenRepository.guardar(refreshToken);

        return AutenticacionResponse.builder()
                .usuarioId(usuario.getId())
                .email(usuario.getEmail())
                .nombre(usuario.getNombre())
                .apellido(usuario.getApellido())
                .rol(usuario.getRol().name())
                .estadoCuenta(usuario.getEstadoCuenta().name())
                .accessToken(accessToken)
                .refreshToken(refreshTokenValue)
                .expiresIn(jwtTokenPort.getAccessTokenExpirationSeconds())
                .cuentaOAuth(false)
                .build();
    }
}
