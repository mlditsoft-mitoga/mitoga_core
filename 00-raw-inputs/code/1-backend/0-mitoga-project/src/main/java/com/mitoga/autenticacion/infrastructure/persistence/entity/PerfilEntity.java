package com.mitoga.autenticacion.infrastructure.persistence.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Entidad JPA: Tabla appmatch_schema.perfiles
 * 
 * <p>
 * Catálogo maestro de tipos de perfil (ESTUDIANTE, TUTOR).
 * Mapea 1:1 con la tabla PostgreSQL.
 * </p>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Entity
@Table(name = "perfiles", schema = "appmatch_schema", indexes = {
    @Index(name = "idx_perfiles_codigo", columnList = "codigo", unique = true),
    @Index(name = "idx_perfiles_activos", columnList = "expiration_date")
})
public class PerfilEntity {

    @Id
    @Column(name = "pkid_perfiles", updatable = false, nullable = false)
    private UUID id;

    @Column(name = "creation_date", nullable = false, updatable = false)
    private LocalDateTime creationDate;

    @Column(name = "expiration_date")
    private LocalDateTime expirationDate;

    @Column(name = "codigo", nullable = false, unique = true, length = 50)
    private String codigo; // APRENDIZ, TUTOR, ADMIN

    @Column(name = "nombre", nullable = false, length = 100)
    private String nombre;

    @Column(name = "descripcion", length = 500)
    private String descripcion;

    // ========== CONSTRUCTORS ==========

    public PerfilEntity() {
    }

    public PerfilEntity(UUID id, LocalDateTime creationDate, LocalDateTime expirationDate,
                        String codigo, String nombre, String descripcion) {
        this.id = id;
        this.creationDate = creationDate;
        this.expirationDate = expirationDate;
        this.codigo = codigo;
        this.nombre = nombre;
        this.descripcion = descripcion;
    }

    // ========== GETTERS & SETTERS ==========

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public LocalDateTime getCreationDate() {
        return creationDate;
    }

    public void setCreationDate(LocalDateTime creationDate) {
        this.creationDate = creationDate;
    }

    public LocalDateTime getExpirationDate() {
        return expirationDate;
    }

    public void setExpirationDate(LocalDateTime expirationDate) {
        this.expirationDate = expirationDate;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }
}
