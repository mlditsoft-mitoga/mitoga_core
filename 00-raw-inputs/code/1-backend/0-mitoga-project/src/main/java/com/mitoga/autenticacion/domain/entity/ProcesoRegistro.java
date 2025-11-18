package com.mitoga.autenticacion.domain.entity;

import com.mitoga.shared.domain.AggregateRoot;
import lombok.Getter;

import java.time.LocalDateTime;
import java.util.Objects;
import java.util.UUID;

/**
 * Aggregate Root: ProcesoRegistro
 * 
 * <p>
 * Gestiona el estado de un proceso de registro multi-paso.
 * </p>
 * <p>
 * Permite trazabilidad y control de tiempo entre pasos.
 * </p>
 * 
 * <p>
 * <strong>Reglas de Negocio:</strong>
 * </p>
 * <ul>
 * <li>Cada proceso tiene TTL de 24 horas desde creación</li>
 * <li>Solo puede avanzar secuencialmente (STEP 1 → STEP 2 → ...)</li>
 * <li>No se puede retroceder a un paso anterior</li>
 * <li>Proceso expirado no puede continuar</li>
 * </ul>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Getter
public class ProcesoRegistro extends AggregateRoot<UUID> {

    // ═══════════════════════════════════════════════════════════════════════════
    // CAMPOS ESTÁNDAR (3 primeros obligatorios)
    // ═══════════════════════════════════════════════════════════════════════════
    private final UUID pkidProcesoRegistro;
    private final LocalDateTime creationDate;
    private LocalDateTime expirationDate; // Soft delete

    // ═══════════════════════════════════════════════════════════════════════════
    // CAMPOS DE NEGOCIO
    // ═══════════════════════════════════════════════════════════════════════════
    private UUID fkIdUsuario; // No final: se vincula después de crear Usuario
    private EstadoProceso estadoActual;
    private final LocalDateTime fechaInicio;
    private LocalDateTime fechaExpiracionProceso; // TTL del proceso (24 horas)
    private LocalDateTime fechaUltimaActualizacion;
    private Integer stepActual;
    private String metadataProceso; // JSONB: IP, user-agent, etc.
    
    /**
     * Constructor completo (para mappers)
     */
    public ProcesoRegistro(
            UUID pkidProcesoRegistro,
            LocalDateTime creationDate,
            LocalDateTime expirationDate,
            UUID fkIdUsuario,
            EstadoProceso estadoActual,
            LocalDateTime fechaInicio,
            LocalDateTime fechaExpiracionProceso,
            LocalDateTime fechaUltimaActualizacion,
            Integer stepActual,
            String metadataProceso) {
        super(pkidProcesoRegistro); // Pasar ID a AggregateRoot
        this.pkidProcesoRegistro = pkidProcesoRegistro;
        this.creationDate = creationDate;
        this.expirationDate = expirationDate;
        this.fkIdUsuario = fkIdUsuario;
        this.estadoActual = estadoActual;
        this.fechaInicio = fechaInicio;
        this.fechaExpiracionProceso = fechaExpiracionProceso;
        this.fechaUltimaActualizacion = fechaUltimaActualizacion;
        this.stepActual = stepActual;
        this.metadataProceso = metadataProceso;
    }

    /**
     * Estados del proceso de registro
     */
    public enum EstadoProceso {
        STEP_1_COMPLETADO,
        STEP_2_COMPLETADO,
        STEP_3_COMPLETADO,
        STEP_4_COMPLETADO,
        COMPLETADO,
        EXPIRADO,
        CANCELADO
    }

    /**
     * Factory Method: Iniciar proceso de registro en STEP 1
     * 
     * @param usuarioId       ID del usuario (puede ser null si se vincula después)
     * @param metadataProceso Metadata del proceso (IP, user-agent, etc.)
     * @return ProcesoRegistro en estado STEP_1_COMPLETADO
     */
    public static ProcesoRegistro iniciar(UUID usuarioId, String metadataProceso) {
        UUID procesoId = UUID.randomUUID();
        LocalDateTime ahora = LocalDateTime.now();
        LocalDateTime expiracionProceso = ahora.plusHours(24); // TTL: 24 horas

        return new ProcesoRegistro(
                procesoId, // pkidProcesoRegistro
                ahora, // creationDate
                null, // expirationDate (soft delete, NULL = activo)
                usuarioId, // fkIdUsuario (puede ser null temporalmente)
                EstadoProceso.STEP_1_COMPLETADO,
                ahora, // fechaInicio
                expiracionProceso, // fechaExpiracionProceso (24 horas)
                ahora, // fechaUltimaActualizacion
                1, // stepActual
                metadataProceso);
    }

    /**
     * Vincular proceso con usuario (cuando se crea después del proceso)
     * 
     * @param usuarioId ID del usuario a vincular
     */
    public void vincularUsuario(UUID usuarioId) {
        Objects.requireNonNull(usuarioId, "UsuarioId es requerido");
        if (this.fkIdUsuario != null) {
            throw new IllegalStateException("ProcesoRegistro ya está vinculado a un usuario");
        }
        this.fkIdUsuario = usuarioId;
        this.fechaUltimaActualizacion = LocalDateTime.now();
    }

    /**
     * Avanzar al siguiente paso del registro
     * 
     * @param nuevoEstado Estado del nuevo paso completado
     * @throws IllegalStateException si el proceso está expirado o cancelado
     */
    public void avanzarStep(EstadoProceso nuevoEstado) {
        validarPuedeAvanzar();

        this.estadoActual = nuevoEstado;
        this.stepActual++;
        this.fechaUltimaActualizacion = LocalDateTime.now();
    }

    /**
     * Validar si el proceso puede avanzar al siguiente paso
     * 
     * @throws IllegalStateException si está expirado o cancelado
     */
    private void validarPuedeAvanzar() {
        if (estaExpirado()) {
            throw new IllegalStateException("Proceso de registro expirado");
        }
        if (this.estadoActual == EstadoProceso.CANCELADO) {
            throw new IllegalStateException("Proceso de registro cancelado");
        }
        if (this.estadoActual == EstadoProceso.COMPLETADO) {
            throw new IllegalStateException("Proceso de registro ya completado");
        }
    }

    /**
     * Verificar si el proceso está expirado
     * 
     * @return true si la fecha de expiración ya pasó
     */
    public boolean estaExpirado() {
        return LocalDateTime.now().isAfter(this.fechaExpiracionProceso);
    }

    /**
     * Cancelar el proceso de registro
     */
    public void cancelar() {
        if (this.estadoActual != EstadoProceso.COMPLETADO) {
            this.estadoActual = EstadoProceso.CANCELADO;
            this.fechaUltimaActualizacion = LocalDateTime.now();
        }
    }

    /**
     * Extender el tiempo de expiración (en casos excepcionales)
     * 
     * @param horas Horas adicionales
     */
    public void extenderExpiracion(int horas) {
        if (!estaExpirado()) {
            this.fechaExpiracionProceso = this.fechaExpiracionProceso.plusHours(horas);
            this.fechaUltimaActualizacion = LocalDateTime.now();
        }
    }
}
