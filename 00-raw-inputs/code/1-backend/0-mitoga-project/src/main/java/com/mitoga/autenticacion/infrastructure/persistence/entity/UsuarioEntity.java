package com.mitoga.autenticacion.infrastructure.persistence.entity;

import io.hypersistence.utils.hibernate.type.json.JsonBinaryType;
import jakarta.persistence.*;
import org.hibernate.annotations.Type;

import java.time.ZonedDateTime;
import java.util.UUID;

/**
 * Entidad JPA: Tabla appmatch_schema.usuarios
 * 
 * <p>
 * Mapea 1:1 con la estructura de la tabla PostgreSQL.
 * </p>
 * <p>
 * NO contiene lógica de negocio (solo persistencia).
 * </p>
 * <p>
 * Mapper: {@code UsuarioMapper} convierte entre Usuario (domain) ↔
 * UsuarioEntity (persistence).
 * </p>
 * 
 * <p>
 * <b>Diferencias con Usuario (domain):</b>
 * </p>
 * <ul>
 * <li>Usa tipos primitivos/JPA en lugar de Value Objects</li>
 * <li>Anotaciones JPA para mapeo ORM</li>
 * <li>Sin comportamiento de dominio</li>
 * <li>Package infrastructure (no expuesto al dominio)</li>
 * </ul>
 */
@Entity
@Table(name = "usuarios", schema = "appmatch_schema", indexes = {
        @Index(name = "idx_usuarios_email_activos", columnList = "email", unique = true),
        @Index(name = "idx_usuarios_estado_cuenta", columnList = "estado_cuenta"),
        @Index(name = "idx_usuarios_email_verificado", columnList = "email_verificado"),
        @Index(name = "idx_usuarios_fecha_ultimo_acceso", columnList = "fecha_ultimo_acceso"),
        @Index(name = "idx_usuarios_creation_date", columnList = "creation_date"),
        @Index(name = "idx_usuarios_token_recuperacion", columnList = "token_recuperacion_password"),
        @Index(name = "idx_usuarios_fk_informacion_basica", columnList = "fk_pkid_informacion_basica", unique = true)
})
public class UsuarioEntity {

    @Id
    @Column(name = "pkid_usuarios", updatable = false, nullable = false)
    private UUID id;

    @Column(name = "creation_date", nullable = false, updatable = false)
    private ZonedDateTime creationDate;

    @Column(name = "expiration_date")
    private ZonedDateTime expirationDate;

    // Foreign Keys
    @Column(name = "fk_pkid_informacion_basica", unique = true)
    private UUID fkInformacionBasicaId;

    @Column(name = "fk_pkid_proceso_registro")
    private UUID fkProcesoRegistroId;

    // Autenticación
    @Column(name = "email", nullable = false, unique = true, length = 255)
    private String email;

    @Column(name = "password_hash", nullable = false, length = 255)
    private String passwordHash;

    @Column(name = "estado_cuenta", nullable = false, length = 30)
    private String estadoCuenta;

    // Verificación email
    @Column(name = "email_verificado", nullable = false)
    private Boolean emailVerificado;

    @Column(name = "fecha_verificacion_email")
    private ZonedDateTime fechaVerificacionEmail;

    // Seguridad login
    @Column(name = "intentos_fallidos_login", nullable = false)
    private Integer intentosFallidosLogin;

    @Column(name = "fecha_ultimo_intento_fallido")
    private ZonedDateTime fechaUltimoIntentoFallido;

    @Column(name = "fecha_bloqueo_cuenta")
    private ZonedDateTime fechaBloqueCuenta;

    // Acceso
    @Column(name = "fecha_ultimo_acceso")
    private ZonedDateTime fechaUltimoAcceso;

    @Column(name = "ip_ultimo_acceso", length = 45)
    private String ipUltimoAcceso;

    // Recuperación password
    @Column(name = "token_recuperacion_password", length = 255)
    private String tokenRecuperacionPassword;

    @Column(name = "fecha_expiracion_token_recuperacion")
    private ZonedDateTime fechaExpiracionTokenRecuperacion;

    @Column(name = "fecha_ultimo_cambio_password")
    private ZonedDateTime fechaUltimoCambioPassword;

    // Two-Factor Authentication
    @Column(name = "two_factor_enabled", nullable = false)
    private Boolean twoFactorEnabled;

    @Column(name = "two_factor_secret", length = 255)
    private String twoFactorSecret;

    @Column(name = "two_factor_backup_codes", columnDefinition = "text[]")
    private String[] twoFactorBackupCodes;

    // Preferencias
    @Column(name = "idioma_preferido", length = 10)
    private String idiomaPreferido;

    @Column(name = "zona_horaria", length = 50)
    private String zonaHoraria;

    @Column(name = "notificaciones_email_habilitadas", nullable = false)
    private Boolean notificacionesEmailHabilitadas;

    @Column(name = "notificaciones_push_habilitadas", nullable = false)
    private Boolean notificacionesPushHabilitadas;

    // Registro
    @Column(name = "ip_registro", length = 45)
    private String ipRegistro;

    @Column(name = "user_agent_registro", columnDefinition = "TEXT")
    private String userAgentRegistro;

    // Metadata JSONB
    @Type(JsonBinaryType.class)
    @Column(name = "metadata", columnDefinition = "jsonb")
    private String metadata;

    // ============ CONSTRUCTORS ============

    public UsuarioEntity() {
        // Constructor vacío requerido por JPA
    }

    // ============ GETTERS & SETTERS ============

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public ZonedDateTime getCreationDate() {
        return creationDate;
    }

    public void setCreationDate(ZonedDateTime creationDate) {
        this.creationDate = creationDate;
    }

    public ZonedDateTime getExpirationDate() {
        return expirationDate;
    }

    public void setExpirationDate(ZonedDateTime expirationDate) {
        this.expirationDate = expirationDate;
    }

    public UUID getFkInformacionBasicaId() {
        return fkInformacionBasicaId;
    }

    public void setFkInformacionBasicaId(UUID fkInformacionBasicaId) {
        this.fkInformacionBasicaId = fkInformacionBasicaId;
    }

    public UUID getFkProcesoRegistroId() {
        return fkProcesoRegistroId;
    }

    public void setFkProcesoRegistroId(UUID fkProcesoRegistroId) {
        this.fkProcesoRegistroId = fkProcesoRegistroId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getEstadoCuenta() {
        return estadoCuenta;
    }

    public void setEstadoCuenta(String estadoCuenta) {
        this.estadoCuenta = estadoCuenta;
    }

    public Boolean getEmailVerificado() {
        return emailVerificado;
    }

    public void setEmailVerificado(Boolean emailVerificado) {
        this.emailVerificado = emailVerificado;
    }

    public ZonedDateTime getFechaVerificacionEmail() {
        return fechaVerificacionEmail;
    }

    public void setFechaVerificacionEmail(ZonedDateTime fechaVerificacionEmail) {
        this.fechaVerificacionEmail = fechaVerificacionEmail;
    }

    public Integer getIntentosFallidosLogin() {
        return intentosFallidosLogin;
    }

    public void setIntentosFallidosLogin(Integer intentosFallidosLogin) {
        this.intentosFallidosLogin = intentosFallidosLogin;
    }

    public ZonedDateTime getFechaUltimoIntentoFallido() {
        return fechaUltimoIntentoFallido;
    }

    public void setFechaUltimoIntentoFallido(ZonedDateTime fechaUltimoIntentoFallido) {
        this.fechaUltimoIntentoFallido = fechaUltimoIntentoFallido;
    }

    public ZonedDateTime getFechaBloqueCuenta() {
        return fechaBloqueCuenta;
    }

    public void setFechaBloqueCuenta(ZonedDateTime fechaBloqueCuenta) {
        this.fechaBloqueCuenta = fechaBloqueCuenta;
    }

    public ZonedDateTime getFechaUltimoAcceso() {
        return fechaUltimoAcceso;
    }

    public void setFechaUltimoAcceso(ZonedDateTime fechaUltimoAcceso) {
        this.fechaUltimoAcceso = fechaUltimoAcceso;
    }

    public String getIpUltimoAcceso() {
        return ipUltimoAcceso;
    }

    public void setIpUltimoAcceso(String ipUltimoAcceso) {
        this.ipUltimoAcceso = ipUltimoAcceso;
    }

    public String getTokenRecuperacionPassword() {
        return tokenRecuperacionPassword;
    }

    public void setTokenRecuperacionPassword(String tokenRecuperacionPassword) {
        this.tokenRecuperacionPassword = tokenRecuperacionPassword;
    }

    public ZonedDateTime getFechaExpiracionTokenRecuperacion() {
        return fechaExpiracionTokenRecuperacion;
    }

    public void setFechaExpiracionTokenRecuperacion(ZonedDateTime fechaExpiracionTokenRecuperacion) {
        this.fechaExpiracionTokenRecuperacion = fechaExpiracionTokenRecuperacion;
    }

    public ZonedDateTime getFechaUltimoCambioPassword() {
        return fechaUltimoCambioPassword;
    }

    public void setFechaUltimoCambioPassword(ZonedDateTime fechaUltimoCambioPassword) {
        this.fechaUltimoCambioPassword = fechaUltimoCambioPassword;
    }

    public Boolean getTwoFactorEnabled() {
        return twoFactorEnabled;
    }

    public void setTwoFactorEnabled(Boolean twoFactorEnabled) {
        this.twoFactorEnabled = twoFactorEnabled;
    }

    public String getTwoFactorSecret() {
        return twoFactorSecret;
    }

    public void setTwoFactorSecret(String twoFactorSecret) {
        this.twoFactorSecret = twoFactorSecret;
    }

    public String[] getTwoFactorBackupCodes() {
        return twoFactorBackupCodes;
    }

    public void setTwoFactorBackupCodes(String[] twoFactorBackupCodes) {
        this.twoFactorBackupCodes = twoFactorBackupCodes;
    }

    public String getIdiomaPreferido() {
        return idiomaPreferido;
    }

    public void setIdiomaPreferido(String idiomaPreferido) {
        this.idiomaPreferido = idiomaPreferido;
    }

    public String getZonaHoraria() {
        return zonaHoraria;
    }

    public void setZonaHoraria(String zonaHoraria) {
        this.zonaHoraria = zonaHoraria;
    }

    public Boolean getNotificacionesEmailHabilitadas() {
        return notificacionesEmailHabilitadas;
    }

    public void setNotificacionesEmailHabilitadas(Boolean notificacionesEmailHabilitadas) {
        this.notificacionesEmailHabilitadas = notificacionesEmailHabilitadas;
    }

    public Boolean getNotificacionesPushHabilitadas() {
        return notificacionesPushHabilitadas;
    }

    public void setNotificacionesPushHabilitadas(Boolean notificacionesPushHabilitadas) {
        this.notificacionesPushHabilitadas = notificacionesPushHabilitadas;
    }

    public String getIpRegistro() {
        return ipRegistro;
    }

    public void setIpRegistro(String ipRegistro) {
        this.ipRegistro = ipRegistro;
    }

    public String getUserAgentRegistro() {
        return userAgentRegistro;
    }

    public void setUserAgentRegistro(String userAgentRegistro) {
        this.userAgentRegistro = userAgentRegistro;
    }

    public String getMetadata() {
        return metadata;
    }

    public void setMetadata(String metadata) {
        this.metadata = metadata;
    }
}
