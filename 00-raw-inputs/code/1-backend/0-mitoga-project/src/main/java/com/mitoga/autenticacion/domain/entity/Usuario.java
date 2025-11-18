package com.mitoga.autenticacion.domain.entity;

import com.mitoga.shared.domain.AggregateRoot;
import com.mitoga.shared.domain.DomainException;
import com.mitoga.autenticacion.domain.valueobject.*;

import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Objects;
import java.util.UUID;

/**
 * Aggregate Root: Usuario del sistema
 * 
 * <p>
 * Representa un usuario autenticado en la plataforma MI-TOGA.
 * </p>
 * 
 * <p>
 * <b>Invariantes del dominio:</b>
 * </p>
 * <ul>
 * <li>Email debe ser único y válido</li>
 * <li>PasswordHash debe cumplir longitud mínima (50 chars)</li>
 * <li>EstadoCuenta debe seguir transiciones válidas</li>
 * <li>Email verificado coherente con fecha verificación</li>
 * <li>Intentos fallidos login >= 0</li>
 * <li>Bloqueo automático después de MAX_INTENTOS_FALLIDOS</li>
 * <li>Token recuperación debe tener fecha expiración</li>
 * <li>Two-factor coherente (enabled → secret NOT NULL)</li>
 * </ul>
 * 
 * <p>
 * <b>Domain Events publicados:</b>
 * </p>
 * <ul>
 * <li>UsuarioRegistrado: Al crear nuevo usuario</li>
 * <li>EmailVerificado: Al verificar email</li>
 * <li>UsuarioBloqueado: Al alcanzar máximo intentos fallidos</li>
 * <li>PasswordCambiado: Al cambiar password</li>
 * <li>EstadoCuentaCambiado: Al cambiar estado cuenta</li>
 * </ul>
 */
public class Usuario extends AggregateRoot<UsuarioId> {

    // Constantes de negocio
    private static final int MAX_INTENTOS_FALLIDOS = 5;
    private static final long TOKEN_RECUPERACION_HORAS_VALIDEZ = 24;

    // Identificadores
    private final UsuarioId id;
    private UUID informacionBasicaId;
    private UUID procesoRegistroId;

    // Autenticación
    private Email email;
    private PasswordHash passwordHash;
    private EstadoCuenta estadoCuenta;

    // Verificación email
    private boolean emailVerificado;
    private ZonedDateTime fechaVerificacionEmail;

    // Seguridad login
    private int intentosFallidosLogin;
    private ZonedDateTime fechaUltimoIntentoFallido;
    private ZonedDateTime fechaBloqueCuenta;

    // Acceso
    private ZonedDateTime fechaUltimoAcceso;
    private String ipUltimoAcceso;

    // Recuperación password
    private String tokenRecuperacionPassword;
    private ZonedDateTime fechaExpiracionTokenRecuperacion;
    private ZonedDateTime fechaUltimoCambioPassword;

    // Two-Factor Authentication
    private boolean twoFactorEnabled;
    private String twoFactorSecret;
    private String[] twoFactorBackupCodes;

    // Preferencias
    private IdiomaPreferido idiomaPreferido;
    private ZoneId zonaHoraria;
    private boolean notificacionesEmailHabilitadas;
    private boolean notificacionesPushHabilitadas;

    // Registro
    private String ipRegistro;
    private String userAgentRegistro;

    // Metadata adicional (JSONB)
    private String metadata;

    // Timestamps (soft delete)
    private ZonedDateTime creationDate;
    private ZonedDateTime expirationDate;

    // Timestamps (heredados conceptualmente, pero gestionados aquí)
    // - creationDate: Fecha creación
    // - expirationDate: Fecha soft delete

    /**
     * Constructor privado (usar factory methods)
     */
    private Usuario(UsuarioId id) {
        super(id);
        this.id = id;
    }

    /**
     * Factory method: Crear nuevo usuario (estado inicial PENDIENTE_VERIFICACION)
     * 
     * <p>
     * <b>NOTA:</b> informacionBasicaId puede ser NULL hasta completar STEP 2
     * </p>
     * 
     * @param email               Email del usuario
     * @param passwordHash        Hash del password (BCrypt/Argon2)
     * @param informacionBasicaId FK a informacion_basica (nullable hasta STEP 2)
     * @param ipRegistro          IP desde donde se registró
     * @param userAgent           User agent del navegador
     * @return Usuario creado
     */
    public static Usuario crear(
            Email email,
            PasswordHash passwordHash,
            UUID informacionBasicaId,
            String ipRegistro,
            String userAgent) {
        Objects.requireNonNull(email, "Email es requerido");
        Objects.requireNonNull(passwordHash, "PasswordHash es requerido");
        // informacionBasicaId puede ser NULL hasta STEP 2 del registro

        UsuarioId id = UsuarioId.generate();
        Usuario usuario = new Usuario(id);

        // Datos básicos
        usuario.email = email;
        usuario.passwordHash = passwordHash;
        usuario.informacionBasicaId = informacionBasicaId;
        usuario.estadoCuenta = EstadoCuenta.PENDIENTE_VERIFICACION;

        // Verificación email (inicial: false)
        usuario.emailVerificado = false;
        usuario.fechaVerificacionEmail = null;

        // Seguridad (valores iniciales)
        usuario.intentosFallidosLogin = 0;
        usuario.twoFactorEnabled = false;

        // Preferencias (defaults)
        usuario.idiomaPreferido = IdiomaPreferido.ES;
        usuario.zonaHoraria = ZoneId.of("America/Bogota");
        usuario.notificacionesEmailHabilitadas = true;
        usuario.notificacionesPushHabilitadas = true;

        // Registro
        usuario.ipRegistro = ipRegistro;
        usuario.userAgentRegistro = userAgent;
        usuario.metadata = "{}";

        // Domain Event: UsuarioRegistrado
        // TODO: registerEvent(new UsuarioRegistrado(id, email, LocalDateTime.now()));

        return usuario;
    }

    /**
     * Verifica el email del usuario
     * 
     * <p>
     * Transición: PENDIENTE_VERIFICACION → ACTIVO
     * </p>
     */
    public void verificarEmail() {
        if (this.emailVerificado) {
            throw new EmailYaVerificadoException(this.id);
        }

        if (this.estadoCuenta != EstadoCuenta.PENDIENTE_VERIFICACION) {
            throw new EstadoCuentaInvalidoParaVerificacionException(this.id, this.estadoCuenta);
        }

        this.emailVerificado = true;
        this.fechaVerificacionEmail = ZonedDateTime.now();
        this.estadoCuenta = EstadoCuenta.ACTIVO;

        // Domain Event: EmailVerificado
        // TODO: registerEvent(new EmailVerificado(id, email, fechaVerificacionEmail));
    }

    /**
     * Registra intento de login fallido
     * 
     * <p>
     * Bloquea automáticamente la cuenta después de MAX_INTENTOS_FALLIDOS.
     * </p>
     */
    public void registrarIntentoLoginFallido() {
        this.intentosFallidosLogin++;
        this.fechaUltimoIntentoFallido = ZonedDateTime.now();

        if (this.intentosFallidosLogin >= MAX_INTENTOS_FALLIDOS) {
            bloquearCuenta();
        }
    }

    /**
     * Resetea contador de intentos fallidos (login exitoso)
     */
    public void resetearIntentosFallidos() {
        this.intentosFallidosLogin = 0;
        this.fechaUltimoIntentoFallido = null;
    }

    /**
     * Registra acceso exitoso
     */
    public void registrarAcceso(String ip) {
        this.fechaUltimoAcceso = ZonedDateTime.now();
        this.ipUltimoAcceso = ip;
        resetearIntentosFallidos();
    }

    /**
     * Bloquea la cuenta por intentos fallidos
     * 
     * <p>
     * Transición: * → BLOQUEADO
     * </p>
     */
    private void bloquearCuenta() {
        this.estadoCuenta.validarTransicion(EstadoCuenta.BLOQUEADO);
        this.estadoCuenta = EstadoCuenta.BLOQUEADO;
        this.fechaBloqueCuenta = ZonedDateTime.now();

        // Domain Event: UsuarioBloqueado
        // TODO: registerEvent(new UsuarioBloqueado(id, fechaBloqueCuenta,
        // intentosFallidosLogin));
    }

    /**
     * Cambia el password del usuario
     * 
     * @param nuevoPasswordHash Nuevo hash del password
     */
    public void cambiarPassword(PasswordHash nuevoPasswordHash) {
        Objects.requireNonNull(nuevoPasswordHash, "Nuevo password hash es requerido");

        this.passwordHash = nuevoPasswordHash;
        this.fechaUltimoCambioPassword = ZonedDateTime.now();

        // Invalidar token recuperación si existe
        this.tokenRecuperacionPassword = null;
        this.fechaExpiracionTokenRecuperacion = null;

        // Domain Event: PasswordCambiado
        // TODO: registerEvent(new PasswordCambiado(id, fechaUltimoCambioPassword));
    }

    /**
     * Genera token de recuperación de password
     * 
     * @param token Token generado (UUID o JWT)
     * @return Fecha expiración del token
     */
    public ZonedDateTime generarTokenRecuperacion(String token) {
        Objects.requireNonNull(token, "Token es requerido");

        this.tokenRecuperacionPassword = token;
        this.fechaExpiracionTokenRecuperacion = ZonedDateTime.now()
                .plusHours(TOKEN_RECUPERACION_HORAS_VALIDEZ);

        return this.fechaExpiracionTokenRecuperacion;
    }

    /**
     * Valida si el token de recuperación es válido
     */
    public boolean esTokenRecuperacionValido(String token) {
        if (this.tokenRecuperacionPassword == null || !this.tokenRecuperacionPassword.equals(token)) {
            return false;
        }

        return ZonedDateTime.now().isBefore(this.fechaExpiracionTokenRecuperacion);
    }

    /**
     * Vincula información básica al usuario (STEP 2)
     * 
     * @param informacionBasicaId UUID de informacion_basica
     */
    public void vincularInformacionBasica(UUID informacionBasicaId) {
        Objects.requireNonNull(informacionBasicaId, "informacionBasicaId es requerido");
        this.informacionBasicaId = informacionBasicaId;
    }

    /**
     * Vincula proceso de registro al usuario
     * 
     * @param procesoRegistroId UUID del proceso_registro
     */
    public void vincularProcesoRegistro(UUID procesoRegistroId) {
        Objects.requireNonNull(procesoRegistroId, "procesoRegistroId es requerido");
        this.procesoRegistroId = procesoRegistroId;
    }

    /**
     * Cambia el estado de la cuenta
     * 
     * @param nuevoEstado Nuevo estado (validado por transiciones)
     */
    public void cambiarEstadoCuenta(EstadoCuenta nuevoEstado) {
        Objects.requireNonNull(nuevoEstado, "Nuevo estado es requerido");

        EstadoCuenta estadoAnterior = this.estadoCuenta;
        estadoAnterior.validarTransicion(nuevoEstado);

        this.estadoCuenta = nuevoEstado;

        // Domain Event: EstadoCuentaCambiado
        // TODO: registerEvent(new EstadoCuentaCambiado(id, estadoAnterior,
        // nuevoEstado));
    }

    /**
     * Habilita Two-Factor Authentication
     */
    public void habilitarTwoFactor(String secret) {
        Objects.requireNonNull(secret, "Secret 2FA es requerido");

        this.twoFactorEnabled = true;
        this.twoFactorSecret = secret;
    }

    /**
     * Deshabilita Two-Factor Authentication
     */
    public void deshabilitarTwoFactor() {
        this.twoFactorEnabled = false;
        this.twoFactorSecret = null;
        this.twoFactorBackupCodes = null;
    }

    /**
     * Actualiza preferencias de idioma
     */
    public void cambiarIdiomaPreferido(IdiomaPreferido nuevoIdioma) {
        Objects.requireNonNull(nuevoIdioma, "Idioma es requerido");
        this.idiomaPreferido = nuevoIdioma;
    }

    /**
     * Actualiza zona horaria
     */
    public void cambiarZonaHoraria(ZoneId nuevaZona) {
        Objects.requireNonNull(nuevaZona, "Zona horaria es requerida");
        this.zonaHoraria = nuevaZona;
    }

    /**
     * Soft delete del usuario
     * 
     * <p>
     * Transición: * → ELIMINADO
     * </p>
     */
    public void eliminar() {
        this.estadoCuenta.validarTransicion(EstadoCuenta.ELIMINADO);
        this.estadoCuenta = EstadoCuenta.ELIMINADO;
        this.expirationDate = ZonedDateTime.now();
    }

    // ============ GETTERS ============

    @Override
    public UsuarioId getId() {
        return id;
    }

    public UUID getInformacionBasicaId() {
        return informacionBasicaId;
    }

    public UUID getProcesoRegistroId() {
        return procesoRegistroId;
    }

    public Email getEmail() {
        return email;
    }

    public PasswordHash getPasswordHash() {
        return passwordHash;
    }

    public EstadoCuenta getEstadoCuenta() {
        return estadoCuenta;
    }

    public boolean isEmailVerificado() {
        return emailVerificado;
    }

    public ZonedDateTime getFechaVerificacionEmail() {
        return fechaVerificacionEmail;
    }

    public int getIntentosFallidosLogin() {
        return intentosFallidosLogin;
    }

    public ZonedDateTime getFechaUltimoIntentoFallido() {
        return fechaUltimoIntentoFallido;
    }

    public ZonedDateTime getFechaBloqueCuenta() {
        return fechaBloqueCuenta;
    }

    public ZonedDateTime getFechaUltimoAcceso() {
        return fechaUltimoAcceso;
    }

    public String getIpUltimoAcceso() {
        return ipUltimoAcceso;
    }

    public String getTokenRecuperacionPassword() {
        return tokenRecuperacionPassword;
    }

    public ZonedDateTime getFechaExpiracionTokenRecuperacion() {
        return fechaExpiracionTokenRecuperacion;
    }

    public ZonedDateTime getFechaUltimoCambioPassword() {
        return fechaUltimoCambioPassword;
    }

    public boolean isTwoFactorEnabled() {
        return twoFactorEnabled;
    }

    public String getTwoFactorSecret() {
        return twoFactorSecret;
    }

    public String[] getTwoFactorBackupCodes() {
        return twoFactorBackupCodes;
    }

    public IdiomaPreferido getIdiomaPreferido() {
        return idiomaPreferido;
    }

    public ZoneId getZonaHoraria() {
        return zonaHoraria;
    }

    public boolean isNotificacionesEmailHabilitadas() {
        return notificacionesEmailHabilitadas;
    }

    public boolean isNotificacionesPushHabilitadas() {
        return notificacionesPushHabilitadas;
    }

    public String getIpRegistro() {
        return ipRegistro;
    }

    public String getUserAgentRegistro() {
        return userAgentRegistro;
    }

    public String getMetadata() {
        return metadata;
    }

    public ZonedDateTime getCreationDate() {
        return creationDate;
    }

    public ZonedDateTime getExpirationDate() {
        return expirationDate;
    }

    // ============ SETTERS (Public para Persistence Mapper - NO usar en lógica de
    // negocio) ============

    /**
     * ⚠️ SOLO para UsuarioMapper (reconstrucción desde DB)
     */
    public void setInformacionBasicaId(UUID informacionBasicaId) {
        this.informacionBasicaId = informacionBasicaId;
    }

    public void setProcesoRegistroId(UUID procesoRegistroId) {
        this.procesoRegistroId = procesoRegistroId;
    }

    public void setEmail(Email email) {
        this.email = email;
    }

    public void setPasswordHash(PasswordHash passwordHash) {
        this.passwordHash = passwordHash;
    }

    public void setEstadoCuenta(EstadoCuenta estadoCuenta) {
        this.estadoCuenta = estadoCuenta;
    }

    public void setEmailVerificado(boolean emailVerificado) {
        this.emailVerificado = emailVerificado;
    }

    public void setFechaVerificacionEmail(ZonedDateTime fechaVerificacionEmail) {
        this.fechaVerificacionEmail = fechaVerificacionEmail;
    }

    public void setIntentosFallidosLogin(int intentosFallidosLogin) {
        this.intentosFallidosLogin = intentosFallidosLogin;
    }

    public void setFechaUltimoIntentoFallido(ZonedDateTime fechaUltimoIntentoFallido) {
        this.fechaUltimoIntentoFallido = fechaUltimoIntentoFallido;
    }

    public void setFechaBloqueCuenta(ZonedDateTime fechaBloqueCuenta) {
        this.fechaBloqueCuenta = fechaBloqueCuenta;
    }

    public void setFechaUltimoAcceso(ZonedDateTime fechaUltimoAcceso) {
        this.fechaUltimoAcceso = fechaUltimoAcceso;
    }

    public void setIpUltimoAcceso(String ipUltimoAcceso) {
        this.ipUltimoAcceso = ipUltimoAcceso;
    }

    public void setTokenRecuperacionPassword(String tokenRecuperacionPassword) {
        this.tokenRecuperacionPassword = tokenRecuperacionPassword;
    }

    public void setFechaExpiracionTokenRecuperacion(ZonedDateTime fechaExpiracionTokenRecuperacion) {
        this.fechaExpiracionTokenRecuperacion = fechaExpiracionTokenRecuperacion;
    }

    public void setFechaUltimoCambioPassword(ZonedDateTime fechaUltimoCambioPassword) {
        this.fechaUltimoCambioPassword = fechaUltimoCambioPassword;
    }

    public void setTwoFactorEnabled(boolean twoFactorEnabled) {
        this.twoFactorEnabled = twoFactorEnabled;
    }

    public void setTwoFactorSecret(String twoFactorSecret) {
        this.twoFactorSecret = twoFactorSecret;
    }

    public void setTwoFactorBackupCodes(String[] twoFactorBackupCodes) {
        this.twoFactorBackupCodes = twoFactorBackupCodes;
    }

    public void setIdiomaPreferido(IdiomaPreferido idiomaPreferido) {
        this.idiomaPreferido = idiomaPreferido;
    }

    public void setZonaHoraria(ZoneId zonaHoraria) {
        this.zonaHoraria = zonaHoraria;
    }

    public void setNotificacionesEmailHabilitadas(boolean notificacionesEmailHabilitadas) {
        this.notificacionesEmailHabilitadas = notificacionesEmailHabilitadas;
    }

    public void setNotificacionesPushHabilitadas(boolean notificacionesPushHabilitadas) {
        this.notificacionesPushHabilitadas = notificacionesPushHabilitadas;
    }

    public void setIpRegistro(String ipRegistro) {
        this.ipRegistro = ipRegistro;
    }

    public void setUserAgentRegistro(String userAgentRegistro) {
        this.userAgentRegistro = userAgentRegistro;
    }

    public void setMetadata(String metadata) {
        this.metadata = metadata;
    }

    public void setCreationDate(ZonedDateTime creationDate) {
        this.creationDate = creationDate;
    }

    public void setExpirationDate(ZonedDateTime expirationDate) {
        this.expirationDate = expirationDate;
    }

    // ============ DOMAIN EXCEPTIONS ============

    public static class EmailYaVerificadoException extends DomainException {
        public EmailYaVerificadoException(UsuarioId usuarioId) {
            super(String.format("El email del usuario %s ya está verificado", usuarioId));
        }
    }

    public static class EstadoCuentaInvalidoParaVerificacionException extends DomainException {
        public EstadoCuentaInvalidoParaVerificacionException(UsuarioId usuarioId, EstadoCuenta estado) {
            super(String.format("El usuario %s no puede verificar email en estado %s", usuarioId, estado));
        }
    }
}
