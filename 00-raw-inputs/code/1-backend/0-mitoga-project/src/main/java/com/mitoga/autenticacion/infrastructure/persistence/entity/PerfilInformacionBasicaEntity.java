package com.mitoga.autenticacion.infrastructure.persistence.entity;

import io.hypersistence.utils.hibernate.type.json.JsonBinaryType;
import jakarta.persistence.*;
import org.hibernate.annotations.Type;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Entidad JPA: Tabla appmatch_schema.perfil_informacion_basica
 * 
 * <p>
 * Relación N:M entre perfiles y usuarios (con metadata adicional).
 * Un usuario puede tener múltiples perfiles (ESTUDIANTE y TUTOR).
 * </p>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Entity
@Table(name = "perfil_informacion_basica", schema = "appmatch_schema", 
    uniqueConstraints = {
        @UniqueConstraint(
            name = "uq_perfil_informacion_basica", 
            columnNames = {"fk_pkid_perfiles", "fk_pkid_informacion_basica"}
        )
    },
    indexes = {
        @Index(name = "idx_perfil_info_basica_perfiles", columnList = "fk_pkid_perfiles"),
        @Index(name = "idx_perfil_info_basica_informacion", columnList = "fk_pkid_informacion_basica"),
        @Index(name = "idx_perfil_info_basica_estado", columnList = "estado"),
        @Index(name = "idx_perfil_info_basica_principal_activo", 
               columnList = "fk_pkid_informacion_basica, es_perfil_principal, estado"),
        @Index(name = "idx_perfil_info_basica_activos", columnList = "expiration_date")
    }
)
public class PerfilInformacionBasicaEntity {

    @Id
    @Column(name = "pkid_perfil_informacion_basica", updatable = false, nullable = false)
    private UUID id;

    @Column(name = "creation_date", nullable = false, updatable = false)
    private LocalDateTime creationDate;

    @Column(name = "expiration_date")
    private LocalDateTime expirationDate;

    // Foreign Keys
    @Column(name = "fk_pkid_perfiles", nullable = false)
    private UUID fkPkidPerfiles;

    @Column(name = "fk_pkid_informacion_basica")
    private UUID fkPkidInformacionBasica; // NULL en STEP 1, NOT NULL después de STEP 2

    // Atributos de negocio
    @Column(name = "es_perfil_principal", nullable = false)
    private Boolean esPerfilPrincipal;

    @Column(name = "estado", nullable = false, length = 20)
    private String estado; // ACTIVO, INACTIVO, SUSPENDIDO

    @Column(name = "fecha_asignacion", nullable = false)
    private LocalDateTime fechaAsignacion;

    @Type(JsonBinaryType.class)
    @Column(name = "metadata", columnDefinition = "jsonb")
    private String metadata;

    // ========== CONSTRUCTORS ==========

    public PerfilInformacionBasicaEntity() {
    }

    public PerfilInformacionBasicaEntity(
            UUID id,
            LocalDateTime creationDate,
            LocalDateTime expirationDate,
            UUID fkPkidPerfiles,
            UUID fkPkidInformacionBasica,
            Boolean esPerfilPrincipal,
            String estado,
            LocalDateTime fechaAsignacion,
            String metadata) {
        this.id = id;
        this.creationDate = creationDate;
        this.expirationDate = expirationDate;
        this.fkPkidPerfiles = fkPkidPerfiles;
        this.fkPkidInformacionBasica = fkPkidInformacionBasica;
        this.esPerfilPrincipal = esPerfilPrincipal;
        this.estado = estado;
        this.fechaAsignacion = fechaAsignacion;
        this.metadata = metadata;
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

    public UUID getFkPkidPerfiles() {
        return fkPkidPerfiles;
    }

    public void setFkPkidPerfiles(UUID fkPkidPerfiles) {
        this.fkPkidPerfiles = fkPkidPerfiles;
    }

    public UUID getFkPkidInformacionBasica() {
        return fkPkidInformacionBasica;
    }

    public void setFkPkidInformacionBasica(UUID fkPkidInformacionBasica) {
        this.fkPkidInformacionBasica = fkPkidInformacionBasica;
    }

    public Boolean getEsPerfilPrincipal() {
        return esPerfilPrincipal;
    }

    public void setEsPerfilPrincipal(Boolean esPerfilPrincipal) {
        this.esPerfilPrincipal = esPerfilPrincipal;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public LocalDateTime getFechaAsignacion() {
        return fechaAsignacion;
    }

    public void setFechaAsignacion(LocalDateTime fechaAsignacion) {
        this.fechaAsignacion = fechaAsignacion;
    }

    public String getMetadata() {
        return metadata;
    }

    public void setMetadata(String metadata) {
        this.metadata = metadata;
    }
}
