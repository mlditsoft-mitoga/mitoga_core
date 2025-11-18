package com.mitoga.autenticacion.domain.entity;

import com.mitoga.shared.domain.AggregateRoot;
import com.mitoga.autenticacion.domain.valueobject.EstadoPerfil;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Objects;
import java.util.UUID;

/**
 * Aggregate Root: Asignación de Perfil a Información Básica
 * 
 * <p>
 * Representa la relación entre un perfil (ESTUDIANTE/TUTOR) y la información
 * básica de un usuario. Permite que un usuario tenga múltiples perfiles.
 * </p>
 * 
 * <p>
 * <b>Flujo de creación multi-step:</b>
 * </p>
 * <ul>
 * <li>STEP 1: Se crea con fkPkidPerfiles (selección de perfil), fkPkidInformacionBasica=NULL</li>
 * <li>STEP 2: Se actualiza con fkPkidInformacionBasica (después de crear información básica)</li>
 * </ul>
 * 
 * <p>
 * <b>Invariantes del dominio:</b>
 * </p>
 * <ul>
 * <li>fkPkidPerfiles siempre debe ser NOT NULL (se asigna en STEP 1)</li>
 * <li>fkPkidInformacionBasica puede ser NULL temporalmente (hasta STEP 2)</li>
 * <li>Un usuario puede tener múltiples perfiles, pero solo uno principal por tipo</li>
 * <li>Estado debe ser válido (ACTIVO, INACTIVO, SUSPENDIDO)</li>
 * <li>Fecha asignación no puede ser futura</li>
 * </ul>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
public class PerfilInformacionBasica extends AggregateRoot<UUID> {

    private final UUID fkPkidPerfiles; // NOT NULL (asignado en STEP 1)
    private UUID fkPkidInformacionBasica; // NULL en STEP 1, NOT NULL después de STEP 2
    
    private boolean esPerfilPrincipal;
    private EstadoPerfil estado;
    
    private final LocalDateTime creationDate;
    private final LocalDateTime expirationDate; // NULL = activo (soft delete)
    private final LocalDateTime fechaAsignacion;
    
    private LocalDateTime fechaUltimaActualizacion;
    private String metadata; // JSON serializado

    /**
     * Constructor privado (usar factory methods)
     */
    private PerfilInformacionBasica(
            UUID id,
            UUID fkPkidPerfiles,
            UUID fkPkidInformacionBasica,
            boolean esPerfilPrincipal,
            EstadoPerfil estado,
            LocalDateTime creationDate,
            LocalDateTime expirationDate,
            LocalDateTime fechaAsignacion,
            LocalDateTime fechaUltimaActualizacion,
            String metadata) {
        
        super(id);
        this.fkPkidPerfiles = Objects.requireNonNull(fkPkidPerfiles, "fkPkidPerfiles no puede ser nulo");
        this.fkPkidInformacionBasica = fkPkidInformacionBasica; // Puede ser NULL en STEP 1
        this.esPerfilPrincipal = esPerfilPrincipal;
        this.estado = Objects.requireNonNull(estado, "Estado no puede ser nulo");
        this.creationDate = Objects.requireNonNull(creationDate, "Creation date no puede ser nula");
        this.expirationDate = expirationDate;
        this.fechaAsignacion = Objects.requireNonNull(fechaAsignacion, "Fecha asignación no puede ser nula");
        this.fechaUltimaActualizacion = fechaUltimaActualizacion;
        this.metadata = metadata != null ? metadata : "{}";
        
        // Validaciones
        validarFechaAsignacion(fechaAsignacion);
    }

    /**
     * Factory method: Crear asignación de perfil en STEP 1 del registro
     * 
     * <p>
     * Se crea con fkPkidInformacionBasica=NULL porque la información básica
     * aún no existe. Se actualizará en STEP 2.
     * </p>
     * 
     * @param perfilId UUID del perfil (ESTUDIANTE o TUTOR)
     * @param esPrincipal Si es el perfil principal del usuario
     * @return Nueva instancia de PerfilInformacionBasica
     */
    public static PerfilInformacionBasica crearEnRegistroStep1(UUID perfilId, boolean esPrincipal) {
        Objects.requireNonNull(perfilId, "PerfilId no puede ser nulo");
        
        UUID id = UUID.randomUUID();
        ZonedDateTime ahora = ZonedDateTime.now(ZoneId.of("America/Bogota"));
        
        return new PerfilInformacionBasica(
            id,
            perfilId,                    // fkPkidPerfiles (NOT NULL)
            null,                        // fkPkidInformacionBasica (NULL en STEP 1)
            esPrincipal,
            EstadoPerfil.ACTIVO,         // Nuevo perfil siempre ACTIVO
            ahora.toLocalDateTime(),
            null,                        // expirationDate NULL = activo
            ahora.toLocalDateTime(),
            ahora.toLocalDateTime(),
            "{}"                         // Metadata vacía
        );
    }

    /**
     * Reconstituir desde persistencia
     */
    public static PerfilInformacionBasica reconstituir(
            UUID id,
            UUID fkPkidPerfiles,
            UUID fkPkidInformacionBasica,
            boolean esPerfilPrincipal,
            EstadoPerfil estado,
            LocalDateTime creationDate,
            LocalDateTime expirationDate,
            LocalDateTime fechaAsignacion,
            String metadata) {
        
        return new PerfilInformacionBasica(
            id,
            fkPkidPerfiles,
            fkPkidInformacionBasica,
            esPerfilPrincipal,
            estado,
            creationDate,
            expirationDate,
            fechaAsignacion,
            null, // fecha_ultima_actualizacion eliminada
            metadata
        );
    }

    // ========== MÉTODOS DE NEGOCIO ==========

    /**
     * Vincular información básica después de STEP 2
     * 
     * @param informacionBasicaId UUID de la información básica creada
     * @throws IllegalStateException Si ya está vinculada
     */
    public void vincularInformacionBasica(UUID informacionBasicaId) {
        Objects.requireNonNull(informacionBasicaId, "InformacionBasicaId no puede ser nulo");
        
        if (this.fkPkidInformacionBasica != null) {
            throw new IllegalStateException(
                "PerfilInformacionBasica ya está vinculado a información básica: " + this.fkPkidInformacionBasica
            );
        }
        
        this.fkPkidInformacionBasica = informacionBasicaId;
        this.fechaUltimaActualizacion = ZonedDateTime.now(ZoneId.of("America/Bogota")).toLocalDateTime();
    }

    /**
     * Marcar como perfil principal
     */
    public void marcarComoPrincipal() {
        if (!this.esPerfilPrincipal) {
            this.esPerfilPrincipal = true;
            this.fechaUltimaActualizacion = ZonedDateTime.now(ZoneId.of("America/Bogota")).toLocalDateTime();
        }
    }

    /**
     * Desmarcar como perfil principal
     */
    public void desmarcarComoPrincipal() {
        if (this.esPerfilPrincipal) {
            this.esPerfilPrincipal = false;
            this.fechaUltimaActualizacion = ZonedDateTime.now(ZoneId.of("America/Bogota")).toLocalDateTime();
        }
    }

    /**
     * Cambiar estado del perfil
     * 
     * @param nuevoEstado Estado al que se quiere transicionar
     * @throws IllegalStateException Si la transición no es válida
     */
    public void cambiarEstado(EstadoPerfil nuevoEstado) {
        Objects.requireNonNull(nuevoEstado, "Nuevo estado no puede ser nulo");
        
        if (!this.estado.puedeTransicionarA(nuevoEstado)) {
            throw new IllegalStateException(
                "Transición de estado inválida: " + this.estado + " -> " + nuevoEstado
            );
        }
        
        this.estado = nuevoEstado;
        this.fechaUltimaActualizacion = ZonedDateTime.now(ZoneId.of("America/Bogota")).toLocalDateTime();
    }

    /**
     * Activar perfil
     */
    public void activar() {
        cambiarEstado(EstadoPerfil.ACTIVO);
    }

    /**
     * Desactivar perfil temporalmente
     */
    public void desactivar() {
        cambiarEstado(EstadoPerfil.INACTIVO);
    }

    /**
     * Suspender perfil (acción administrativa)
     */
    public void suspender() {
        cambiarEstado(EstadoPerfil.SUSPENDIDO);
    }

    /**
     * Actualizar metadata (JSON)
     * 
     * @param metadata Metadata en formato JSON
     */
    public void actualizarMetadata(String metadata) {
        Objects.requireNonNull(metadata, "Metadata no puede ser nulo");
        this.metadata = metadata;
        this.fechaUltimaActualizacion = ZonedDateTime.now(ZoneId.of("America/Bogota")).toLocalDateTime();
    }

    // ========== VALIDACIONES ==========
    
    private void validarFechaAsignacion(LocalDateTime fechaAsignacion) {
        ZonedDateTime ahora = ZonedDateTime.now(ZoneId.of("America/Bogota"));
        
        if (fechaAsignacion.isAfter(ahora.toLocalDateTime())) {
            throw new IllegalArgumentException("Fecha de asignación no puede ser futura");
        }
    }

    // ========== GETTERS ==========
    
    public UUID getFkPkidPerfiles() {
        return fkPkidPerfiles;
    }

    public UUID getFkPkidInformacionBasica() {
        return fkPkidInformacionBasica;
    }
    
    public boolean tieneInformacionBasicaVinculada() {
        return fkPkidInformacionBasica != null;
    }

    public boolean isEsPerfilPrincipal() {
        return esPerfilPrincipal;
    }

    public EstadoPerfil getEstado() {
        return estado;
    }
    
    public boolean estaActivo() {
        return estado == EstadoPerfil.ACTIVO;
    }

    public LocalDateTime getCreationDate() {
        return creationDate;
    }

    public LocalDateTime getExpirationDate() {
        return expirationDate;
    }
    
    public boolean estaVigente() {
        return expirationDate == null;
    }

    public LocalDateTime getFechaAsignacion() {
        return fechaAsignacion;
    }

    public LocalDateTime getFechaUltimaActualizacion() {
        return fechaUltimaActualizacion;
    }

    public String getMetadata() {
        return metadata;
    }

    // ========== EQUALS & HASHCODE ==========
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof PerfilInformacionBasica that)) return false;
        return Objects.equals(getId(), that.getId());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getId());
    }

    @Override
    public String toString() {
        return "PerfilInformacionBasica{" +
                "id=" + getId() +
                ", perfilId=" + fkPkidPerfiles +
                ", informacionBasicaId=" + fkPkidInformacionBasica +
                ", esPrincipal=" + esPerfilPrincipal +
                ", estado=" + estado +
                ", vigente=" + estaVigente() +
                '}';
    }
}
