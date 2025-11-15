package com.mitoga.autenticacion.application.service;

import com.mitoga.autenticacion.application.command.RegistrarUsuarioCommand;
import com.mitoga.autenticacion.application.port.input.RegistrarUsuarioUseCase;
import com.mitoga.autenticacion.application.port.input.AutenticacionResponse;
import com.mitoga.autenticacion.application.port.output.EmailPort;
import com.mitoga.autenticacion.application.port.output.JwtTokenPort;
import com.mitoga.autenticacion.application.port.output.PasswordEncoderPort;
import com.mitoga.autenticacion.domain.exception.UsuarioYaExisteException;
import com.mitoga.autenticacion.domain.model.Usuario;
import com.mitoga.autenticacion.domain.repository.UsuarioRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;
import java.util.UUID;
import java.util.Map;
import java.security.SecureRandom;

/**
 * RegistrarUsuarioService - ImplementaciÃ³n del caso de uso de registro
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - SERVICE
 * - Orquesta el registro de usuarios (tradicional y OAuth)
 * - Utiliza ports para interactuar con dominio e infraestructura
 * - Transaccional para garantizar consistencia
 * - NO contiene lÃ³gica de negocio (eso es del dominio)
 */
@Service
@Transactional
public class RegistrarUsuarioService implements RegistrarUsuarioUseCase {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoderPort passwordEncoder;
    private final JwtTokenPort jwtTokenPort;
    private final EmailPort emailPort;

    public RegistrarUsuarioService(
            UsuarioRepository usuarioRepository,
            PasswordEncoderPort passwordEncoder,
            JwtTokenPort jwtTokenPort,
            EmailPort emailPort) {
        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtTokenPort = jwtTokenPort;
        this.emailPort = emailPort;
    }

    /**
     * Registra un nuevo usuario con credenciales tradicionales
     */
    @Override
    public AutenticacionResponse registrar(RegistrarUsuarioCommand command) {
        // Validar que no exista usuario con ese email
        if (usuarioRepository.existePorEmail(command.getEmail())) {
            throw new UsuarioYaExisteException(command.getEmail());
        }

        // Crear usuario usando factory method del dominio
        String passwordEncriptado = passwordEncoder.encode(command.getPassword());
        Usuario.Rol rol = Usuario.Rol.valueOf(command.getRol().toUpperCase());
        Usuario usuario = Usuario.registrar(
                command.getEmail(),
                passwordEncriptado,
                command.getNombre(),
                command.getApellido(),
                rol);

        // Generar y asignar token de verificaciÃ³n
        String tokenVerificacion = generarTokenNumerico();
        usuario.generarTokenVerificacion(tokenVerificacion);

        // Persistir usuario
        usuario = usuarioRepository.guardar(usuario);

        // Enviar email de verificaciÃ³n (asÃ­ncrono)
        emailPort.enviarEmailVerificacion(
                usuario.getEmail(),
                usuario.getNombreCompleto(),
                tokenVerificacion);

        // Generar JWT para acceso inmediato (aunque requiere verificaciÃ³n)
        String accessToken = jwtTokenPort.generateAccessToken(
                usuario.getId(),
                usuario.getEmail(),
                usuario.getRol().name(),
                Map.of("emailVerificado", usuario.getEmailVerificado()));

        return AutenticacionResponse.builder()
                .usuarioId(usuario.getId())
                .email(usuario.getEmail())
                .nombre(usuario.getNombre())
                .apellido(usuario.getApellido())
                .rol(usuario.getRol().name())
                .estadoCuenta(usuario.getEstadoCuenta().name())
                .accessToken(accessToken)
                .cuentaOAuth(false)
                .build();
    }

    /**
     * Genera un token numérico de 6 dígitos para verificación de email
     */
    private String generarTokenNumerico() {
        SecureRandom random = new SecureRandom();
        int token = 100000 + random.nextInt(900000); // Genera número entre 100000 y 999999
        return String.valueOf(token);
    }
}
