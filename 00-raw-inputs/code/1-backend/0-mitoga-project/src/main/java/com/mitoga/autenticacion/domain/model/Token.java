package com.mitoga.autenticacion.domain.model;

import com.mitoga.shared.domain.valueobject.BaseEntity;
import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.Objects;
import java.util.UUID;

/**
 * Token - Entity del agregado Usuario para Refresh Tokens
 * Tabla: autenticacion_schema.refresh_tokens
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - DOMAIN LAYER - ENTITY
 * - Entity dentro del agregado de Usuario
 * - Gestiona los tokens de actualización (refresh tokens)
 * - Permite invalidar sesiones específicas
 * 
 * POLÍTICA NO LOMBOK:
 * - ❌ NO usa @Data (genera setters que rompen encapsulación)
 * - ✅ Constructor privado + Factory Method
 * - ✅ Solo getters públicos (sin setters)
 * - ✅ Comportamiento de dominio encapsulado
 */
@Entity
@Table(name = "refresh_tokens", schema = "autenticacion_schema")
public class Token extends BaseEntity {

    @Column(name = "usuario_id", nullable = false)
    private UUID usuarioId;

    @Column(name = "token", nullable = false, unique = true, length = 500)
    private String token;

    @Column(name = "fecha_expiracion", nullable = false)
    private LocalDateTime fechaExpiracion;

    @Column(name = "fecha_revocacion")
    private LocalDateTime fechaRevocacion;

    @Column(name = "revocado", nullable = false)
    private Boolean revocado = false;

    @Column(name = "ip_address", length = 45)
    private String ipAddress;

    @Column(name = "user_agent", length = 500)
    private String userAgent;

    @Column(name = "dispositivo", length = 100)
    private String dispositivo;

    // ==================== CONSTRUCTORES ====================

    /**
     * Constructor protegido para JPA (NO usar directamente)
     */
    protected Token() {
        super();
    }

    /**
     * Constructor privado completo (solo para factory method)
     */
    private Token(UUID usuarioId, String tokenValue, int diasValidez, String ipAddress, String userAgent) {
        super();
        this.usuarioId = Objects.requireNonNull(usuarioId, "Usuario ID es requerido");
        this.token = Objects.requireNonNull(tokenValue, "Token es requerido");
        this.fechaExpiracion = LocalDateTime.now().plusDays(diasValidez);
        this.revocado = false;
        this.ipAddress = ipAddress;
        this.userAgent = userAgent;
        this.extraerDispositivo(userAgent);
    }

    // ==================== FACTORY METHOD ====================

    /**
     * Crea un nuevo token de actualización con validación
     */
    public static Token crear(UUID usuarioId, String tokenValue, int diasValidez,
            String ipAddress, String userAgent) {

        if (diasValidez <= 0) {
            throw new IllegalArgumentException("Días de validez debe ser mayor a 0");
        }

        return new Token(usuarioId, tokenValue, diasValidez, ipAddress, userAgent);
    }

    // ==================== GETTERS (solo lectura) ====================

    public UUID getUsuarioId() {
        return usuarioId;
    }

    public String getToken() {
        return token;
    }

    public LocalDateTime getFechaExpiracion() {
        return fechaExpiracion;
    }

    public LocalDateTime getFechaRevocacion() {
        return fechaRevocacion;
    }

    public Boolean getRevocado() {
        return revocado;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public String getDispositivo() {
        return dispositivo;
    }

    // ==================== MÉTODOS DE NEGOCIO (DDD) ====================

    /**
     * Verifica si el token está activo y válido
     */
    public boolean esValido() {
        return !revocado &&
                fechaExpiracion.isAfter(LocalDateTime.now());
    }

    /**
     * Revoca el token
     */
    public void revocar() {
        if (this.revocado) {
            throw new IllegalStateException("Token ya está revocado");
        }
        this.revocado = true;
        this.fechaRevocacion = LocalDateTime.now();
    }

    /**
     * Verifica si el token está expirado
     */
    public boolean estaExpirado() {
        return LocalDateTime.now().isAfter(fechaExpiracion);
    }

    /**
     * Renueva el token extendiendo su vigencia
     */
    public void renovar(int diasValidez) {
        if (revocado) {
            throw new IllegalStateException("No se puede renovar un token revocado");
        }
        if (estaExpirado()) {
            throw new IllegalStateException("No se puede renovar un token expirado");
        }
        if (diasValidez <= 0) {
            throw new IllegalArgumentException("Días de validez debe ser mayor a 0");
        }

        this.fechaExpiracion = LocalDateTime.now().plusDays(diasValidez);
    }

    // ==================== MÉTODOS PRIVADOS ====================

    /**
     * Extrae el tipo de dispositivo del User-Agent
     */
    private void extraerDispositivo(String userAgent) {
        if (userAgent == null || userAgent.isBlank()) {
            this.dispositivo = "Desconocido";
            return;
        }

        String ua = userAgent.toLowerCase();
        if (ua.contains("mobile") || ua.contains("android") || ua.contains("iphone")) {
            this.dispositivo = "Mobile";
        } else if (ua.contains("tablet") || ua.contains("ipad")) {
            this.dispositivo = "Tablet";
        } else {
            this.dispositivo = "Desktop";
        }
    }

    // ==================== EQUALS & HASHCODE (por ID) ====================

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (!(o instanceof Token))
            return false;
        Token token = (Token) o;
        return getId() != null && Objects.equals(getId(), token.getId());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getId());
    }

    @Override
    public String toString() {
        return "Token{" +
                "id=" + getId() +
                ", usuarioId=" + usuarioId +
                ", dispositivo='" + dispositivo + '\'' +
                ", fechaExpiracion=" + fechaExpiracion +
                ", revocado=" + revocado +
                '}';
    }
}
