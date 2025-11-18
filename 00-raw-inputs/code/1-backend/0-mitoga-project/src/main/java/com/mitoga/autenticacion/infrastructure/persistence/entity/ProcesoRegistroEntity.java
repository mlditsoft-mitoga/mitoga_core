package com.mitoga.autenticacion.infrastructure.persistence.entity;

import com.mitoga.autenticacion.domain.entity.ProcesoRegistro;
import io.hypersistence.utils.hibernate.type.json.JsonBinaryType;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.Type;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * JPA Entity: proceso_registro
 * 
 * <p>
 * Tabla para gestionar el estado de procesos de registro multi-paso.
 * </p>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Entity
@Table(name = "proceso_registro", schema = "appmatch_schema")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProcesoRegistroEntity {

    // ═══════════════════════════════════════════════════════════════════════════
    // CAMPOS ESTÁNDAR (3 primeros obligatorios)
    // ═══════════════════════════════════════════════════════════════════════════

    @Id
    @Column(name = "pkid_proceso_registro", nullable = false)
    private UUID pkidProcesoRegistro;

    @Column(name = "creation_date", nullable = false)
    private LocalDateTime creationDate;

    @Column(name = "expiration_date")
    private LocalDateTime expirationDate; // Soft delete

    // ═══════════════════════════════════════════════════════════════════════════
    // CAMPOS DE NEGOCIO
    // ═══════════════════════════════════════════════════════════════════════════

    @Column(name = "fk_id_usuario", nullable = false)
    private UUID fkIdUsuario;

    @Enumerated(EnumType.STRING)
    @Column(name = "estado_actual", nullable = false, length = 50)
    private ProcesoRegistro.EstadoProceso estadoActual;

    @Column(name = "fecha_inicio", nullable = false)
    private LocalDateTime fechaInicio;

    @Column(name = "fecha_expiracion_proceso", nullable = false)
    private LocalDateTime fechaExpiracionProceso;

    @Column(name = "fecha_ultima_actualizacion", nullable = false)
    private LocalDateTime fechaUltimaActualizacion;

    @Column(name = "step_actual", nullable = false)
    private Integer stepActual;

    @Type(JsonBinaryType.class)
    @Column(name = "metadata_proceso", columnDefinition = "jsonb")
    private String metadataProceso;

    /**
     * Mapper: Domain → Entity
     */
    public static ProcesoRegistroEntity fromDomain(ProcesoRegistro procesoRegistro) {
        return ProcesoRegistroEntity.builder()
                .pkidProcesoRegistro(procesoRegistro.getPkidProcesoRegistro())
                .creationDate(procesoRegistro.getCreationDate())
                .expirationDate(procesoRegistro.getExpirationDate())
                .fkIdUsuario(procesoRegistro.getFkIdUsuario())
                .estadoActual(procesoRegistro.getEstadoActual())
                .fechaInicio(procesoRegistro.getFechaInicio())
                .fechaExpiracionProceso(procesoRegistro.getFechaExpiracionProceso())
                .fechaUltimaActualizacion(procesoRegistro.getFechaUltimaActualizacion())
                .stepActual(procesoRegistro.getStepActual())
                .metadataProceso(procesoRegistro.getMetadataProceso())
                .build();
    }

    /**
     * Mapper: Entity → Domain
     */
    public ProcesoRegistro toDomain() {
        return new ProcesoRegistro(
                this.pkidProcesoRegistro,
                this.creationDate,
                this.expirationDate,
                this.fkIdUsuario,
                this.estadoActual,
                this.fechaInicio,
                this.fechaExpiracionProceso,
                this.fechaUltimaActualizacion,
                this.stepActual,
                this.metadataProceso);
    }
}
