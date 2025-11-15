package com.mitoga.autenticacion.application.service;

import com.mitoga.autenticacion.application.command.VerificarEmailCommand;
import com.mitoga.autenticacion.application.port.input.VerificarEmailUseCase;
import com.mitoga.autenticacion.application.port.input.VerificacionResponse;
import com.mitoga.autenticacion.application.port.output.EmailPort;
import com.mitoga.autenticacion.domain.model.Usuario;
import com.mitoga.autenticacion.domain.repository.UsuarioRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * VerificarEmailService - ImplementaciÃ³n del caso de uso de verificaciÃ³n de
 * email
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - SERVICE
 * - Verifica el email del usuario con token numÃ©rico
 * - Activa la cuenta tras verificaciÃ³n exitosa
 * - EnvÃ­a email de bienvenida post-verificaciÃ³n
 * - NO contiene lÃ³gica de negocio (eso es del dominio)
 */
@Service
@Transactional
public class VerificarEmailService implements VerificarEmailUseCase {

    private final UsuarioRepository usuarioRepository;
    private final EmailPort emailPort;

    public VerificarEmailService(
            UsuarioRepository usuarioRepository,
            EmailPort emailPort) {
        this.usuarioRepository = usuarioRepository;
        this.emailPort = emailPort;
    }

    /**
     * Verifica el email del usuario con el token recibido
     */
    @Override
    public VerificacionResponse verificarEmail(VerificarEmailCommand command) {
        // Buscar usuario por email
        Usuario usuario = usuarioRepository.buscarPorEmail(command.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("Usuario no encontrado"));

        // Verificar si ya estÃ¡ verificado
        if (usuario.getEmailVerificado()) {
            return VerificacionResponse.builder()
                    .usuarioId(usuario.getId())
                    .email(usuario.getEmail())
                    .verificado(true)
                    .mensaje("Email ya verificado previamente")
                    .cuentaActivada(true)
                    .build();
        }

        // Verificar email (lÃ³gica en el dominio)
        try {
            usuario.verificarEmail(command.getToken());
            usuarioRepository.guardar(usuario);

            // Enviar email de bienvenida
            emailPort.enviarEmailBienvenida(
                    usuario.getEmail(),
                    usuario.getNombreCompleto());

            return VerificacionResponse.builder()
                    .usuarioId(usuario.getId())
                    .email(usuario.getEmail())
                    .verificado(true)
                    .mensaje("Email verificado exitosamente. Cuenta activada.")
                    .cuentaActivada(true)
                    .build();

        } catch (IllegalArgumentException e) {
            return VerificacionResponse.builder()
                    .usuarioId(usuario.getId())
                    .email(usuario.getEmail())
                    .verificado(false)
                    .mensaje(e.getMessage())
                    .cuentaActivada(false)
                    .build();

        } catch (IllegalStateException e) {
            return VerificacionResponse.builder()
                    .usuarioId(usuario.getId())
                    .email(usuario.getEmail())
                    .verificado(false)
                    .mensaje(e.getMessage())
                    .cuentaActivada(false)
                    .build();
        }
    }
}
