package com.mitoga.autenticacion.infrastructure.persistence.mapper;

import com.mitoga.autenticacion.domain.entity.Usuario;
import com.mitoga.autenticacion.domain.valueobject.*;
import com.mitoga.autenticacion.infrastructure.persistence.entity.UsuarioEntity;
import org.springframework.stereotype.Component;

import java.time.ZoneId;
import java.time.ZonedDateTime;

/**
 * Mapper: Usuario (Domain) ↔ UsuarioEntity (Persistence)
 * 
 * <p>
 * Convierte entre el modelo de dominio rico (Value Objects, comportamiento)
 * y el modelo de persistencia (entidad JPA plana).
 * </p>
 * 
 * <p>
 * <b>Responsabilidades:</b>
 * </p>
 * <ul>
 * <li>toDomain(): UsuarioEntity → Usuario (reconstrucción desde DB)</li>
 * <li>toEntity(): Usuario → UsuarioEntity (mapeo para persistencia)</li>
 * <li>Conversión de Value Objects ↔ primitivos</li>
 * <li>Manejo de nulls y valores default</li>
 * </ul>
 * 
 * <p>
 * <b>IMPORTANTE:</b> El mapper NO valida reglas de negocio,
 * solo traduce entre capas.
 * </p>
 */
@Component
public class UsuarioMapper {

    /**
     * Convierte UsuarioEntity (JPA) → Usuario (Domain)
     * 
     * <p>
     * Reconstruye el agregado desde la base de datos.
     * </p>
     * 
     * @param entity Entidad JPA persistida
     * @return Usuario del dominio (con Value Objects)
     */
    public Usuario toDomain(UsuarioEntity entity) {
        if (entity == null) {
            return null;
        }

        // Crear Usuario con factory method
        Usuario usuario = Usuario.crear(
                Email.from(entity.getEmail()),
                PasswordHash.from(entity.getPasswordHash()),
                entity.getFkInformacionBasicaId(),
                entity.getIpRegistro(),
                entity.getUserAgentRegistro());

        // Reconstruir estado desde DB (usar setters public)
        usuario.setInformacionBasicaId(entity.getFkInformacionBasicaId());
        usuario.setProcesoRegistroId(entity.getFkProcesoRegistroId());
        usuario.setEmail(Email.from(entity.getEmail()));
        usuario.setPasswordHash(PasswordHash.from(entity.getPasswordHash()));
        usuario.setEstadoCuenta(EstadoCuenta.from(entity.getEstadoCuenta()));

        // Verificación email
        usuario.setEmailVerificado(entity.getEmailVerificado());
        usuario.setFechaVerificacionEmail(entity.getFechaVerificacionEmail());

        // Seguridad
        usuario.setIntentosFallidosLogin(entity.getIntentosFallidosLogin());
        usuario.setFechaUltimoIntentoFallido(entity.getFechaUltimoIntentoFallido());
        usuario.setFechaBloqueCuenta(entity.getFechaBloqueCuenta());

        // Acceso
        usuario.setFechaUltimoAcceso(entity.getFechaUltimoAcceso());
        usuario.setIpUltimoAcceso(entity.getIpUltimoAcceso());

        // Recuperación password
        usuario.setTokenRecuperacionPassword(entity.getTokenRecuperacionPassword());
        usuario.setFechaExpiracionTokenRecuperacion(entity.getFechaExpiracionTokenRecuperacion());
        usuario.setFechaUltimoCambioPassword(entity.getFechaUltimoCambioPassword());

        // Two-Factor
        usuario.setTwoFactorEnabled(entity.getTwoFactorEnabled());
        usuario.setTwoFactorSecret(entity.getTwoFactorSecret());
        usuario.setTwoFactorBackupCodes(entity.getTwoFactorBackupCodes());

        // Preferencias
        usuario.setIdiomaPreferido(
                entity.getIdiomaPreferido() != null
                        ? IdiomaPreferido.from(entity.getIdiomaPreferido())
                        : IdiomaPreferido.ES);
        usuario.setZonaHoraria(
                entity.getZonaHoraria() != null
                        ? ZoneId.of(entity.getZonaHoraria())
                        : ZoneId.of("America/Bogota"));
        usuario.setNotificacionesEmailHabilitadas(entity.getNotificacionesEmailHabilitadas());
        usuario.setNotificacionesPushHabilitadas(entity.getNotificacionesPushHabilitadas());

        // Metadata
        usuario.setMetadata(entity.getMetadata() != null ? entity.getMetadata() : "{}");

        // Timestamps (heredados de AggregateRoot)
        usuario.setCreationDate(entity.getCreationDate());
        usuario.setExpirationDate(entity.getExpirationDate());

        return usuario;
    }

    /**
     * Convierte Usuario (Domain) → UsuarioEntity (JPA)
     * 
     * <p>
     * Mapea el agregado a entidad JPA para persistencia.
     * </p>
     * 
     * @param usuario Usuario del dominio
     * @return Entidad JPA para persistir
     */
    public UsuarioEntity toEntity(Usuario usuario) {
        if (usuario == null) {
            return null;
        }

        UsuarioEntity entity = new UsuarioEntity();

        // ID
        entity.setId(usuario.getId().value());

        // Timestamps
        entity.setCreationDate(
                usuario.getCreationDate() != null
                        ? usuario.getCreationDate()
                        : ZonedDateTime.now());
        entity.setExpirationDate(usuario.getExpirationDate());

        // Foreign Keys
        entity.setFkInformacionBasicaId(usuario.getInformacionBasicaId());
        entity.setFkProcesoRegistroId(usuario.getProcesoRegistroId());

        // Autenticación
        entity.setEmail(usuario.getEmail().value());
        entity.setPasswordHash(usuario.getPasswordHash().value());
        entity.setEstadoCuenta(usuario.getEstadoCuenta().name());

        // Verificación email
        entity.setEmailVerificado(usuario.isEmailVerificado());
        entity.setFechaVerificacionEmail(usuario.getFechaVerificacionEmail());

        // Seguridad
        entity.setIntentosFallidosLogin(usuario.getIntentosFallidosLogin());
        entity.setFechaUltimoIntentoFallido(usuario.getFechaUltimoIntentoFallido());
        entity.setFechaBloqueCuenta(usuario.getFechaBloqueCuenta());

        // Acceso
        entity.setFechaUltimoAcceso(usuario.getFechaUltimoAcceso());
        entity.setIpUltimoAcceso(usuario.getIpUltimoAcceso());

        // Recuperación password
        entity.setTokenRecuperacionPassword(usuario.getTokenRecuperacionPassword());
        entity.setFechaExpiracionTokenRecuperacion(usuario.getFechaExpiracionTokenRecuperacion());
        entity.setFechaUltimoCambioPassword(usuario.getFechaUltimoCambioPassword());

        // Two-Factor
        entity.setTwoFactorEnabled(usuario.isTwoFactorEnabled());
        entity.setTwoFactorSecret(usuario.getTwoFactorSecret());
        entity.setTwoFactorBackupCodes(usuario.getTwoFactorBackupCodes());

        // Preferencias
        entity.setIdiomaPreferido(usuario.getIdiomaPreferido().getCodigo());
        entity.setZonaHoraria(usuario.getZonaHoraria().getId());
        entity.setNotificacionesEmailHabilitadas(usuario.isNotificacionesEmailHabilitadas());
        entity.setNotificacionesPushHabilitadas(usuario.isNotificacionesPushHabilitadas());

        // Registro
        entity.setIpRegistro(usuario.getIpRegistro());
        entity.setUserAgentRegistro(usuario.getUserAgentRegistro());

        // Metadata
        entity.setMetadata(usuario.getMetadata());

        return entity;
    }
}
