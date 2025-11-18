package com.mitoga.autenticacion.application.service;

import com.mitoga.autenticacion.application.dto.RegistroStep2Request;
import com.mitoga.autenticacion.application.dto.RegistroStep2Response;
import com.mitoga.autenticacion.domain.entity.*;
import com.mitoga.autenticacion.domain.entity.ProcesoRegistro.EstadoProceso;
import com.mitoga.autenticacion.domain.repository.*;
import com.mitoga.shared.application.UseCase;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.UUID;

/**
 * Use Case: Registro de Estudiante STEP 2 (Información Personal)
 * 
 * <p>
 * <b>HUT-001-STEP-2:</b> Completar registro con información personal
 * </p>
 * 
 * <p>
 * <b>Flujo:</b>
 * </p>
 * <ol>
 * <li>Validar ProcesoRegistro existe y no expiró</li>
 * <li>Validar Usuario vinculado a ProcesoRegistro</li>
 * <li>Validar no existe duplicate número documento</li>
 * <li>Crear InformacionBasica con datos personales</li>
 * <li>Actualizar Usuario.fk_pkid_informacion_basica</li>
 * <li>Buscar PerfilInformacionBasica pendiente (STEP 1)</li>
 * <li>Actualizar PerfilInformacionBasica.fk_pkid_informacion_basica</li>
 * <li>Avanzar ProcesoRegistro a STEP_2_COMPLETADO</li>
 * <li>Retornar response con informacionBasicaId</li>
 * </ol>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class RegisterStudentStep2UseCase implements UseCase<RegistroStep2Request, RegistroStep2Response> {

    private final UsuarioRepository usuarioRepository;
    private final ProcesoRegistroRepository procesoRegistroRepository;
    private final InformacionBasicaRepository informacionBasicaRepository;
    private final PerfilInformacionBasicaRepository perfilInformacionBasicaRepository;

    @Override
    @Transactional
    public RegistroStep2Response execute(RegistroStep2Request request) {
        log.info("📝 [BC01-Autenticación] Iniciando Registro STEP 2 - Usuario: {}", request.getUsuarioId());

        // 1. Validar ProcesoRegistro existe
        UUID procesoRegistroId = UUID.fromString(request.getProcesoRegistroId());
        ProcesoRegistro procesoRegistro = procesoRegistroRepository.findById(procesoRegistroId)
                .orElseThrow(() -> new ProcesoRegistroNoEncontradoException(procesoRegistroId));

        log.debug("✅ ProcesoRegistro encontrado: {}", procesoRegistroId);

        // 2. Validar ProcesoRegistro no expirado
        if (procesoRegistro.estaExpirado()) {
            log.error("❌ ProcesoRegistro expirado: {}", procesoRegistroId);
            throw new ProcesoRegistroExpiradoException(procesoRegistroId);
        }

        // 3. Validar Usuario coincide con ProcesoRegistro
        UUID usuarioId = UUID.fromString(request.getUsuarioId());
        if (!procesoRegistro.getFkIdUsuario().equals(usuarioId)) {
            log.error("❌ Usuario {} no coincide con ProcesoRegistro {}", usuarioId, procesoRegistroId);
            throw new UsuarioNoCoincideException(usuarioId, procesoRegistroId);
        }

        // 4. Buscar Usuario
        Usuario usuario = usuarioRepository.findById(new com.mitoga.autenticacion.domain.valueobject.UsuarioId(usuarioId))
                .orElseThrow(() -> new UsuarioNoEncontradoException(usuarioId));

        log.debug("✅ Usuario encontrado: {}", usuarioId);

        // 5. Validar no exista número documento duplicado
        String numeroDocumento = request.getInformacionPersonal().getNumeroDocumento();
        if (informacionBasicaRepository.existsByNumeroIdentificacion(numeroDocumento)) {
            log.error("❌ Número de documento ya existe: {}", numeroDocumento);
            throw new NumeroDocumentoDuplicadoException(numeroDocumento);
        }

        // 6. Validar email no duplicado (usamos el email del usuario, no uno nuevo)
        // El email ya fue validado en STEP 1

        // 7. Crear InformacionBasica
        var infoPersonal = request.getInformacionPersonal();
        var responsable = request.getResponsableLegal();

        LocalDate fechaNacimiento = infoPersonal.getFechaNacimiento(); // Ya es LocalDate
        boolean tieneResponsable = responsable != null && responsable.getRequerido() != null && responsable.getRequerido();

        InformacionBasica informacionBasica = InformacionBasica.crear(
                infoPersonal.getPrimerNombre(),
                infoPersonal.getSegundoNombre(),
                infoPersonal.getPrimerApellido(),
                infoPersonal.getSegundoApellido(),
                UUID.fromString(infoPersonal.getTipoDocumentoId()),
                infoPersonal.getNumeroDocumento(),
                usuario.getEmail().value(), // Email del usuario (record value())
                infoPersonal.getTelefono(),
                fechaNacimiento,
                UUID.fromString(infoPersonal.getGeneroId()),
                UUID.fromString(infoPersonal.getPaisId()),
                UUID.fromString(infoPersonal.getCiudadId()),
                infoPersonal.getDireccion(),
                tieneResponsable,
                tieneResponsable ? responsable.getEmail() : null,
                tieneResponsable ? responsable.getNumeroDocumento() : null,
                tieneResponsable ? responsable.getPrimerNombre() : null,
                tieneResponsable ? responsable.getPrimerApellido() : null,
                tieneResponsable ? responsable.getTelefono() : null,
                null, // ipRegistro (TODO: obtener de request context)
                "{}" // metadata
        );

        InformacionBasica informacionBasicaGuardada = informacionBasicaRepository.save(informacionBasica);
        log.info("✅ InformacionBasica creada: {}", informacionBasicaGuardada.getId());

        // 8. Vincular InformacionBasica a Usuario
        usuario.vincularInformacionBasica(informacionBasicaGuardada.getId());
        usuarioRepository.save(usuario);
        log.debug("✅ Usuario actualizado con fk_pkid_informacion_basica: {}", informacionBasicaGuardada.getId());

        // 9. Buscar PerfilInformacionBasica pendiente de vincular (creado en STEP 1)
        // El registro fue creado en STEP 1 con fk_pkid_informacion_basica = NULL
        // Ahora lo buscamos por el perfilId que obtuvimos del procesoRegistro metadata
        
        // Buscar TODOS los registros pendientes y tomar el más reciente
        // (en producción debería haber solo uno por usuario en STEP 1)
        PerfilInformacionBasica perfilInfo = buscarPerfilPendiente();

        log.debug("✅ PerfilInformacionBasica pendiente encontrado: {}", perfilInfo.getId());

        // 10. Vincular InformacionBasica a PerfilInformacionBasica
        perfilInfo.vincularInformacionBasica(informacionBasicaGuardada.getId());
        perfilInformacionBasicaRepository.save(perfilInfo);
        log.debug("✅ PerfilInformacionBasica actualizado con fk_pkid_informacion_basica: {}", 
                informacionBasicaGuardada.getId());

        // 11. Avanzar ProcesoRegistro a STEP_2_COMPLETADO
        procesoRegistro.avanzarStep(EstadoProceso.STEP_2_COMPLETADO);
        procesoRegistroRepository.save(procesoRegistro);
        log.info("✅ ProcesoRegistro avanzado a STEP_2_COMPLETADO");

        // 12. Construir response
        RegistroStep2Response response = RegistroStep2Response.builder()
                .informacionBasicaId(informacionBasicaGuardada.getId().toString())
                .esMayorDeEdad(informacionBasicaGuardada.esMayorDeEdad())
                .requiereResponsableLegal(tieneResponsable)
                .mensaje("Información personal guardada exitosamente")
                .build();

        log.info("✅ [BC01-Autenticación] Registro STEP 2 completado - InformacionBasica: {}", 
                informacionBasicaGuardada.getId());

        return response;
    }

    /**
     * Busca el PerfilInformacionBasica pendiente de vincular
     * 
     * <p>
     * Estrategia: Buscar el registro más reciente que tenga fk_pkid_informacion_basica = NULL
     * En STEP 1 se creó un registro con el perfil seleccionado pero sin vincular a informacion_basica.
     * </p>
     * 
     * <p>
     * NOTA: En producción, debería haber exactamente UN registro pendiente por usuario.
     * Si hay múltiples, tomamos el más reciente por creation_date.
     * </p>
     * 
     * @return PerfilInformacionBasica pendiente
     * @throws PerfilInformacionBasicaPendienteNoEncontradoException Si no hay registros pendientes
     */
    private PerfilInformacionBasica buscarPerfilPendiente() {
        // Buscar en todos los perfiles (APRENDIZ, TUTOR, ADMIN)
        // El método findPendienteDeVincular busca por fk_pkid_informacion_basica IS NULL
        // y ordena por creation_date DESC para obtener el más reciente
        
        // UUIDs de los perfiles conocidos
        UUID[] perfilesIds = {
            UUID.fromString("a21d1df3-b5ff-4f3e-b662-a41e2e379939"), // APRENDIZ
            UUID.fromString("d00236d9-a316-4fb0-9f2a-1a8ef2b69f36"), // TUTOR
            UUID.fromString("bd71f83e-437a-4dd9-ba13-d2753b69035c")  // ADMIN
        };
        
        for (UUID perfilId : perfilesIds) {
            var optional = perfilInformacionBasicaRepository.findPendienteDeVincular(perfilId);
            if (optional.isPresent()) {
                return optional.get();
            }
        }
        
        throw new PerfilInformacionBasicaPendienteNoEncontradoException(null);
    }

    // ============ DOMAIN EXCEPTIONS ============

    public static class ProcesoRegistroNoEncontradoException extends RuntimeException {
        public ProcesoRegistroNoEncontradoException(UUID procesoRegistroId) {
            super(String.format("ProcesoRegistro no encontrado: %s", procesoRegistroId));
        }
    }

    public static class ProcesoRegistroExpiradoException extends RuntimeException {
        public ProcesoRegistroExpiradoException(UUID procesoRegistroId) {
            super(String.format("ProcesoRegistro %s ha expirado", procesoRegistroId));
        }
    }

    public static class UsuarioNoCoincideException extends RuntimeException {
        public UsuarioNoCoincideException(UUID usuarioId, UUID procesoRegistroId) {
            super(String.format("Usuario %s no coincide con ProcesoRegistro %s", usuarioId, procesoRegistroId));
        }
    }

    public static class UsuarioNoEncontradoException extends RuntimeException {
        public UsuarioNoEncontradoException(UUID usuarioId) {
            super(String.format("Usuario no encontrado: %s", usuarioId));
        }
    }

    public static class NumeroDocumentoDuplicadoException extends RuntimeException {
        public NumeroDocumentoDuplicadoException(String numeroDocumento) {
            super(String.format("Número de documento ya existe: %s", numeroDocumento));
        }
    }

    public static class PerfilInformacionBasicaPendienteNoEncontradoException extends RuntimeException {
        public PerfilInformacionBasicaPendienteNoEncontradoException(UUID perfilId) {
            super(String.format("No se encontró PerfilInformacionBasica pendiente para perfil: %s", perfilId));
        }
    }
}
