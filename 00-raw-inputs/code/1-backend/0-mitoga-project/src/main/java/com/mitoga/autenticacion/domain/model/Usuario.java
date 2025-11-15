package com.mitoga.autenticacion.domain.model;

import com.mitoga.shared.domain.valueobject.BaseEntity;
import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.Objects;

/**
 * Usuario - AGGREGATE ROOT del BC de Autenticación
 * Tabla: autenticacion_schema.usuarios
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - DOMAIN LAYER - AGGREGATE ROOT
 * - Entidad raíz del agregado de Usuario
 * - Contiene lógica de negocio de autenticación y registro
 * - Independiente de infraestructura (NO usa anotaciones Spring)
 * - Maneja credenciales, roles y estado de cuenta
 * 
 * POLÍTICA NO LOMBOK:
 * - ❌ NO usa @Data (genera setters que rompen encapsulación)
 * - ✅ Constructores privados + Factory Methods
 * - ✅ Solo getters públicos (sin setters)
 * - ✅ Comportamiento de dominio encapsulado
 * - ✅ Igualdad por ID (no por campos)
 */
@Entity
@Table(name = "usuarios", schema = "autenticacion_schema")
public class Usuario extends BaseEntity {

    @Column(name = "email", nullable = false, unique = true, length = 255)
    private String email;

    @Column(name = "password_hash", nullable = false, length = 255)
    private String passwordHash;

    @Column(name = "nombre", nullable = false, length = 100)
    private String nombre;

    @Column(name = "apellido", nullable = false, length = 100)
    private String apellido;

    @Enumerated(EnumType.STRING)
    @Column(name = "rol", nullable = false)
    private Rol rol;

    @Enumerated(EnumType.STRING)
    @Column(name = "estado_cuenta", nullable = false)
    private EstadoCuenta estadoCuenta = EstadoCuenta.PENDIENTE_VERIFICACION;

    @Column(name = "email_verificado", nullable = false)
    private Boolean emailVerificado = false;

    @Column(name = "fecha_verificacion_email")
    private LocalDateTime fechaVerificacionEmail;

    @Column(name = "token_verificacion", length = 6)
    private String tokenVerificacion;

    @Column(name = "fecha_envio_token")
    private LocalDateTime fechaEnvioToken;

    @Column(name = "intentos_verificacion")
    private Integer intentosVerificacion = 0;

    @Column(name = "max_intentos_verificacion")
    private Integer maxIntentosVerificacion = 3;

    @Column(name = "ultimo_acceso")
    private LocalDateTime ultimoAcceso;

    @Column(name = "fecha_bloqueo")
    private LocalDateTime fechaBloqueo;

    @Column(name = "motivo_bloqueo", length = 500)
    private String motivoBloqueo;

    @Column(name = "intentos_login_fallidos")
    private Integer intentosLoginFallidos = 0;

    @Column(name = "max_intentos_login")
    private Integer maxIntentosLogin = 5;

    public enum Rol {
        ESTUDIANTE,
        TUTOR,
        ADMIN,
        SUPERADMIN
    }

    public enum EstadoCuenta {
        PENDIENTE_VERIFICACION,
        ACTIVA,
        SUSPENDIDA,
        BLOQUEADA,
        ELIMINADA
    }

    // ==================== CONSTRUCTORES ====================

    /**
     * Constructor protegido para JPA (NO usar directamente)
     */
    protected Usuario() {
        super();
    }

    /**
     * Constructor privado completo (solo para factory methods)
     */
    private Usuario(String email, String passwordHash, String nombre, String apellido, Rol rol) {
        super();
        this.email = Objects.requireNonNull(email, "Email es requerido");
        this.passwordHash = Objects.requireNonNull(passwordHash, "Password hash es requerido");
        this.nombre = Objects.requireNonNull(nombre, "Nombre es requerido");
        this.apellido = Objects.requireNonNull(apellido, "Apellido es requerido");
        this.rol = Objects.requireNonNull(rol, "Rol es requerido");
        this.estadoCuenta = EstadoCuenta.PENDIENTE_VERIFICACION;
        this.emailVerificado = false;
        this.intentosVerificacion = 0;
        this.intentosLoginFallidos = 0;
    }

    // ==================== FACTORY METHODS ====================

    /**
     * Registra un nuevo usuario con datos básicos
     * Factory Method principal con validaciones de negocio
     */
    public static Usuario registrar(String email, String passwordHash, String nombre, String apellido, Rol rol) {
        validarEmail(email);
        validarNombre(nombre, "Nombre");
        validarNombre(apellido, "Apellido");

        return new Usuario(email, passwordHash, nombre, apellido, rol);
    }

    // ==================== GETTERS (solo lectura) ====================

    public String getEmail() {
        return email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public String getNombre() {
        return nombre;
    }

    public String getApellido() {
        return apellido;
    }

    public Rol getRol() {
        return rol;
    }

    public EstadoCuenta getEstadoCuenta() {
        return estadoCuenta;
    }

    public Boolean getEmailVerificado() {
        return emailVerificado;
    }

    public LocalDateTime getFechaVerificacionEmail() {
        return fechaVerificacionEmail;
    }

    public String getTokenVerificacion() {
        return tokenVerificacion;
    }

    public LocalDateTime getFechaEnvioToken() {
        return fechaEnvioToken;
    }

    public Integer getIntentosVerificacion() {
        return intentosVerificacion;
    }

    public Integer getMaxIntentosVerificacion() {
        return maxIntentosVerificacion;
    }

    public LocalDateTime getUltimoAcceso() {
        return ultimoAcceso;
    }

    public LocalDateTime getFechaBloqueo() {
        return fechaBloqueo;
    }

    public String getMotivoBloqueo() {
        return motivoBloqueo;
    }

    public Integer getIntentosLoginFallidos() {
        return intentosLoginFallidos;
    }

    public Integer getMaxIntentosLogin() {
        return maxIntentosLogin;
    }

    // ==================== MÉTODOS DE NEGOCIO (DDD) ====================

    /**
     * Genera y asigna un token de verificación de email
     */
    public void generarTokenVerificacion(String token) {
        Objects.requireNonNull(token, "Token no puede ser nulo");
        this.tokenVerificacion = token;
        this.fechaEnvioToken = LocalDateTime.now();
    }

    /**
     * Verifica si el token aún es válido (5 minutos)
     */
    public boolean isTokenValido() {
        if (tokenVerificacion == null || fechaEnvioToken == null) {
            return false;
        }
        return fechaEnvioToken.isAfter(LocalDateTime.now().minusMinutes(5));
    }

    /**
     * Verifica el email del usuario
     */
    public void verificarEmail(String token) {
        if (!tokenVerificacion.equals(token)) {
            incrementarIntentosVerificacion();
            throw new IllegalArgumentException("Token inválido");
        }

        if (!isTokenValido()) {
            throw new IllegalStateException("Token expirado");
        }

        this.emailVerificado = true;
        this.fechaVerificacionEmail = LocalDateTime.now();
        this.estadoCuenta = EstadoCuenta.ACTIVA;
        this.tokenVerificacion = null;
        this.intentosVerificacion = 0;
    }

    /**
     * Incrementa los intentos de verificación y bloquea si excede el límite
     */
    private void incrementarIntentosVerificacion() {
        this.intentosVerificacion++;
        if (this.intentosVerificacion >= this.maxIntentosVerificacion) {
            bloquearCuenta("Máximo de intentos de verificación excedidos");
        }
    }

    /**
     * Registra un login exitoso
     */
    public void registrarLoginExitoso() {
        this.ultimoAcceso = LocalDateTime.now();
        this.intentosLoginFallidos = 0;
    }

    /**
     * Registra un intento de login fallido y bloquea si excede el límite
     */
    public void registrarLoginFallido() {
        this.intentosLoginFallidos++;
        if (this.intentosLoginFallidos >= this.maxIntentosLogin) {
            bloquearCuenta("Máximo de intentos de login excedidos");
        }
    }

    /**
     * Bloquea la cuenta del usuario
     */
    public void bloquearCuenta(String motivo) {
        this.estadoCuenta = EstadoCuenta.BLOQUEADA;
        this.fechaBloqueo = LocalDateTime.now();
        this.motivoBloqueo = motivo;
    }

    /**
     * Reactiva la cuenta del usuario
     */
    public void reactivarCuenta() {
        if (this.estadoCuenta == EstadoCuenta.BLOQUEADA || this.estadoCuenta == EstadoCuenta.SUSPENDIDA) {
            this.estadoCuenta = EstadoCuenta.ACTIVA;
            this.intentosLoginFallidos = 0;
            this.intentosVerificacion = 0;
            this.fechaBloqueo = null;
            this.motivoBloqueo = null;
        }
    }

    /**
     * Verifica si la cuenta está activa y puede hacer login
     */
    public boolean puedeHacerLogin() {
        return this.emailVerificado &&
                this.estadoCuenta == EstadoCuenta.ACTIVA;
    }

    /**
     * Actualiza la contraseña del usuario
     */
    public void cambiarPassword(String nuevoPasswordHash) {
        Objects.requireNonNull(nuevoPasswordHash, "Password hash no puede ser nulo");
        this.passwordHash = nuevoPasswordHash;
    }

    /**
     * Obtiene el nombre completo del usuario
     */
    public String getNombreCompleto() {
        return this.nombre + " " + this.apellido;
    }

    /**
     * Verifica si el usuario tiene un rol específico
     */
    public boolean tieneRol(Rol rol) {
        return this.rol == rol;
    }

    /**
     * Verifica si el usuario es administrador
     */
    public boolean esAdmin() {
        return this.rol == Rol.ADMIN || this.rol == Rol.SUPERADMIN;
    }

    // ==================== VALIDACIONES PRIVADAS ====================

    private static void validarEmail(String email) {
        if (email == null || email.isBlank()) {
            throw new IllegalArgumentException("Email no puede estar vacío");
        }
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new IllegalArgumentException("Email inválido: " + email);
        }
    }

    private static void validarNombre(String nombre, String campo) {
        if (nombre == null || nombre.isBlank()) {
            throw new IllegalArgumentException(campo + " no puede estar vacío");
        }
        if (nombre.length() < 2) {
            throw new IllegalArgumentException(campo + " debe tener al menos 2 caracteres");
        }
    }

    // ==================== EQUALS & HASHCODE (por ID) ====================

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (!(o instanceof Usuario))
            return false;
        Usuario usuario = (Usuario) o;
        return getId() != null && Objects.equals(getId(), usuario.getId());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getId());
    }

    @Override
    public String toString() {
        return "Usuario{" +
                "id=" + getId() +
                ", email='" + email + '\'' +
                ", nombre='" + nombre + '\'' +
                ", apellido='" + apellido + '\'' +
                ", rol=" + rol +
                ", estadoCuenta=" + estadoCuenta +
                '}';
    }
}
