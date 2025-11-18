package com.mitoga.autenticacion.application.service;

import com.mitoga.autenticacion.application.dto.RegistroStep1Request;
import com.mitoga.autenticacion.application.dto.RegistroStep1Response;
import com.mitoga.autenticacion.domain.entity.Perfil;
import com.mitoga.autenticacion.domain.entity.PerfilInformacionBasica;
import com.mitoga.autenticacion.domain.entity.ProcesoRegistro;
import com.mitoga.autenticacion.domain.entity.Usuario;
import com.mitoga.autenticacion.domain.exception.EmailYaRegistradoException;
import com.mitoga.autenticacion.domain.exception.PasswordsNoCoinciden;
import com.mitoga.autenticacion.domain.exception.PerfilNoEncontradoException;
import com.mitoga.autenticacion.domain.repository.PerfilInformacionBasicaRepository;
import com.mitoga.autenticacion.domain.repository.PerfilRepository;
import com.mitoga.autenticacion.domain.repository.ProcesoRegistroRepository;
import com.mitoga.autenticacion.domain.repository.UsuarioRepository;
import com.mitoga.autenticacion.domain.valueobject.Email;
import com.mitoga.autenticacion.domain.valueobject.PasswordHash;
import com.mitoga.shared.domain.DomainException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Use Case: Registro de Estudiante STEP 1 (Credenciales + Selección de Perfil)
 * 
 * <p>
 * Implementa la lógica de negocio para el registro inicial de usuarios.
 * </p>
 * 
 * <p>
 * <b>Responsabilidades:</b>
 * </p>
 * <ul>
 * <li>Validar que el email no esté registrado</li>
 * <li>Validar complejidad del password</li>
 * <li>Hashear password con BCrypt</li>
 * <li>Crear entidad Usuario en estado PENDIENTE_VERIFICACION</li>
 * <li>Crear registro de ProcesoRegistro</li>
 * <li>Crear registro de PerfilInformacionBasica (con perfil, sin información básica)</li>
 * <li>Persistir en base de datos</li>
 * <li>Generar y enviar OTP por email (futuro)</li>
 * </ul>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class RegisterStudentStep1UseCase {

    private final UsuarioRepository usuarioRepository;
    private final ProcesoRegistroRepository procesoRegistroRepository;
    private final PerfilRepository perfilRepository;
    private final PerfilInformacionBasicaRepository perfilInformacionBasicaRepository;
    private final PasswordEncoder passwordEncoder;
    // TODO: Inyectar OtpService cuando se implemente
    // private final OtpService otpService;
    // TODO: Inyectar EmailService cuando se implemente
    // private final EmailService emailService;

    /**
     * Ejecuta el caso de uso de registro STEP 1
     * 
     * @param request DTO con datos de registro
     * @return Response con datos del usuario creado
     * @throws DomainException Si el email ya existe o validaciones fallan
     */
    @Transactional
    public RegistroStep1Response execute(RegistroStep1Request request) {
        log.info("🚀 Iniciando registro STEP 1 para email: {} con perfil: {}", 
                request.getEmail(), request.getTipoPerfil());

        // 1. Validar que passwords coincidan
        if (!request.getPassword().equals(request.getConfirmPassword())) {
            throw new PasswordsNoCoinciden();
        }

        // 2. Crear Value Object Email (validación RFC 5322)
        Email email = Email.from(request.getEmail());

        // 3. Validar que email no exista
        usuarioRepository.findByEmail(email).ifPresent(usuario -> {
            throw new EmailYaRegistradoException(email.value());
        });

        // 4. Hashear password con BCrypt
        String hashedPassword = passwordEncoder.encode(request.getPassword());
        PasswordHash passwordHash = PasswordHash.from(hashedPassword);

        // 5. Crear ProcesoRegistro PRIMERO (sin FK a Usuario)
        String metadataProceso = convertirMetadataAJson(request.getMetadata());
        ProcesoRegistro procesoRegistro = ProcesoRegistro.iniciar(
                null, // usuarioId será null temporalmente
                metadataProceso);
        ProcesoRegistro procesoGuardado = procesoRegistroRepository.save(procesoRegistro);
        log.info("✅ Proceso registro creado: {}", procesoGuardado.getPkidProcesoRegistro());

        // 6. Crear Usuario con FK a ProcesoRegistro
        Usuario usuario = Usuario.crear(
                email,
                passwordHash,
                null, // informacionBasicaId será null hasta STEP 2
                request.getMetadata() != null ? request.getMetadata().getIpRegistro() : "0.0.0.0",
                request.getMetadata() != null ? request.getMetadata().getUserAgent() : "Unknown");

        // 7. Persistir Usuario
        Usuario usuarioGuardado = usuarioRepository.save(usuario);
        log.info("✅ Usuario creado en BD: {}", usuarioGuardado.getId().value());

        // 8. Actualizar ProcesoRegistro con FK a Usuario
        procesoGuardado.vincularUsuario(usuarioGuardado.getId().value());
        procesoRegistroRepository.save(procesoGuardado);
        log.info("✅ ProcesoRegistro actualizado con fk_id_usuario: {}", usuarioGuardado.getId().value());

        // 9. Buscar perfil por UUID directo
        Perfil perfil = perfilRepository.findById(request.getTipoPerfil())
                .orElseThrow(() -> new PerfilNoEncontradoException(request.getTipoPerfil().toString()));
        log.info("✅ Perfil encontrado: {} (ID: {})", perfil.getNombre(), perfil.getId());

        // 10. Crear asignación de perfil (sin información básica aún)
        PerfilInformacionBasica perfilInfo = PerfilInformacionBasica.crearEnRegistroStep1(
                perfil.getId(), // fk_pkid_perfiles
                true            // es_perfil_principal
        );
        PerfilInformacionBasica perfilInfoGuardado = perfilInformacionBasicaRepository.save(perfilInfo);
        log.info("✅ PerfilInformacionBasica creado: {} (Perfil: {}, InfoBasica: NULL)", 
                perfilInfoGuardado.getId(), 
                perfilInfoGuardado.getFkPkidPerfiles());

        // 11. TODO: Generar OTP y enviar por email
        // String codigoOtp = otpService.generarYGuardar(usuarioGuardado.getId());
        // emailService.enviarOtpVerificacion(email.value(), codigoOtp());

        // 12. Construir response
        return RegistroStep1Response.builder()
                .usuarioId(usuarioGuardado.getId().value().toString())
                .procesoRegistroId(procesoGuardado.getPkidProcesoRegistro().toString())
                .email(usuarioGuardado.getEmail().value())
                .estadoCuenta(usuarioGuardado.getEstadoCuenta().name())
                .emailVerificado(usuarioGuardado.isEmailVerificado())
                .mensaje("Registro STEP 1 exitoso. Tienes 24 horas para completar el proceso.")
                .tiempoExpiracionHoras(24L)
                .build();
    }

    /**
     * Convierte metadata del request a JSON String
     */
    private String convertirMetadataAJson(RegistroStep1Request.MetadataRegistro metadata) {
        if (metadata == null)
            return "{}";

        return String.format(
                "{\"ipRegistro\":\"%s\",\"userAgent\":\"%s\",\"dispositivo\":\"%s\",\"navegador\":\"%s\",\"sistemaOperativo\":\"%s\"}",
                metadata.getIpRegistro() != null ? metadata.getIpRegistro() : "",
                metadata.getUserAgent() != null ? metadata.getUserAgent() : "",
                metadata.getDispositivo() != null ? metadata.getDispositivo() : "",
                metadata.getNavegador() != null ? metadata.getNavegador() : "",
                metadata.getSistemaOperativo() != null ? metadata.getSistemaOperativo() : "");
    }
}
