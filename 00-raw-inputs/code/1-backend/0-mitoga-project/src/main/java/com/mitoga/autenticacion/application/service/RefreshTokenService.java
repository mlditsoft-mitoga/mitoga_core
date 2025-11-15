package com.mitoga.autenticacion.application.service;

import com.mitoga.autenticacion.application.command.RefreshTokenCommand;
import com.mitoga.autenticacion.application.port.input.RefreshTokenUseCase;
import com.mitoga.autenticacion.application.port.input.AutenticacionResponse;
import com.mitoga.autenticacion.application.port.output.JwtTokenPort;
import com.mitoga.autenticacion.domain.exception.TokenInvalidoException;
import com.mitoga.autenticacion.domain.model.Token;
import com.mitoga.autenticacion.domain.model.Usuario;
import com.mitoga.autenticacion.domain.repository.TokenRepository;
import com.mitoga.autenticacion.domain.repository.UsuarioRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

/**
 * RefreshTokenService - ImplementaciÃ³n del caso de uso de renovaciÃ³n de tokens
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - SERVICE
 * - Renueva access tokens usando refresh tokens vÃ¡lidos
 * - Valida que el refresh token no estÃ© revocado ni expirado
 * - Genera nuevo par de tokens (access + refresh)
 * - NO contiene lÃ³gica de negocio (eso es del dominio)
 */
@Service
@Transactional
public class RefreshTokenService implements RefreshTokenUseCase {

    private final TokenRepository tokenRepository;
    private final UsuarioRepository usuarioRepository;
    private final JwtTokenPort jwtTokenPort;

    private static final int DIAS_VALIDEZ_REFRESH_TOKEN = 30;

    public RefreshTokenService(
            TokenRepository tokenRepository,
            UsuarioRepository usuarioRepository,
            JwtTokenPort jwtTokenPort) {
        this.tokenRepository = tokenRepository;
        this.usuarioRepository = usuarioRepository;
        this.jwtTokenPort = jwtTokenPort;
    }

    /**
     * Renueva el access token usando un refresh token vÃ¡lido
     */
    @Override
    public AutenticacionResponse refreshToken(RefreshTokenCommand command) {
        // Buscar refresh token
        Token refreshToken = tokenRepository.buscarPorToken(command.getRefreshToken())
                .orElseThrow(() -> new TokenInvalidoException("Refresh token no encontrado"));

        // Validar que el token estÃ¡ activo
        if (!refreshToken.esValido()) {
            throw new TokenInvalidoException("Refresh token invÃ¡lido o expirado");
        }

        // Buscar usuario
        Usuario usuario = usuarioRepository.buscarPorId(refreshToken.getUsuarioId())
                .orElseThrow(() -> new TokenInvalidoException("Usuario no encontrado"));

        // Verificar que el usuario puede hacer login
        if (!usuario.puedeHacerLogin()) {
            throw new IllegalStateException("Cuenta no activa. Contacta soporte.");
        }

        // Revocar el refresh token anterior (rotation)
        refreshToken.revocar();
        tokenRepository.guardar(refreshToken);

        // Generar nuevo access token
        String nuevoAccessToken = jwtTokenPort.generateAccessToken(
                usuario.getId(),
                usuario.getEmail(),
                usuario.getRol().name(),
                Map.of("emailVerificado", usuario.getEmailVerificado()));

        // Generar nuevo refresh token (rotation)
        String nuevoRefreshTokenValue = jwtTokenPort.generateRefreshToken();

        Token nuevoRefreshToken = Token.crear(
                usuario.getId(),
                nuevoRefreshTokenValue,
                DIAS_VALIDEZ_REFRESH_TOKEN,
                refreshToken.getIpAddress(), // Mantener IP original
                refreshToken.getUserAgent()); // Mantener User-Agent original

        tokenRepository.guardar(nuevoRefreshToken);

        return AutenticacionResponse.builder()
                .usuarioId(usuario.getId())
                .email(usuario.getEmail())
                .nombre(usuario.getNombre())
                .apellido(usuario.getApellido())
                .rol(usuario.getRol().name())
                .estadoCuenta(usuario.getEstadoCuenta().name())
                .accessToken(nuevoAccessToken)
                .refreshToken(nuevoRefreshTokenValue)
                .expiresIn(jwtTokenPort.getAccessTokenExpirationSeconds())
                .cuentaOAuth(false)
                .build();
    }
}
