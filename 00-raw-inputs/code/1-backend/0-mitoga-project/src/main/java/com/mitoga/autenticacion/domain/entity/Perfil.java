package com.mitoga.autenticacion.domain.entity;

import com.mitoga.shared.domain.AggregateRoot;
import com.mitoga.autenticacion.domain.valueobject.TipoPerfil;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Objects;
import java.util.UUID;

/**
 * Aggregate Root: Perfil (Catálogo de tipos de perfil)
 * 
 * <p>
 * Representa un tipo de perfil disponible en el sistema (ESTUDIANTE, TUTOR).
 * Esta es una entidad de catálogo maestra.
 * </p>
 * 
 * <p>
 * <b>Invariantes del dominio:</b>
 * </p>
 * <ul>
 * <li>Nombre debe ser único</li>
 * <li>Descripción no puede estar vacía</li>
 * <li>No puede ser eliminado físicamente (soft delete)</li>
 * </ul>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
public class Perfil extends AggregateRoot<UUID> {

    private final String codigo; // APRENDIZ, TUTOR, ADMIN
    private final String nombre;
    private final String descripcion;
    private final LocalDateTime creationDate;
    private final LocalDateTime expirationDate; // NULL = activo (soft delete)

    /**
     * Constructor privado (usar factory methods)
     */
    private Perfil(UUID id, String codigo, String nombre, String descripcion, 
                   LocalDateTime creationDate, LocalDateTime expirationDate) {
        super(id);
        this.codigo = Objects.requireNonNull(codigo, "Código no puede ser nulo");
        this.nombre = Objects.requireNonNull(nombre, "Nombre no puede ser nulo");
        this.descripcion = Objects.requireNonNull(descripcion, "Descripción no puede ser nula");
        this.creationDate = Objects.requireNonNull(creationDate, "Creation date no puede ser nula");
        this.expirationDate = expirationDate;
        
        // Validaciones
        validarCodigo(codigo);
        validarNombre(nombre);
        validarDescripcion(descripcion);
    }

    /**
     * Factory method: Crear nuevo perfil (solo para inicialización del sistema)
     * 
     * @param tipoPerfil Tipo de perfil (APRENDIZ, TUTOR, ADMIN)
     * @return Nueva instancia de Perfil
     */
    public static Perfil crear(TipoPerfil tipoPerfil) {
        Objects.requireNonNull(tipoPerfil, "TipoPerfil no puede ser nulo");
        
        UUID id = UUID.randomUUID();
        ZonedDateTime ahora = ZonedDateTime.now(ZoneId.of("America/Bogota"));
        
        return new Perfil(
            id,
            tipoPerfil.name(), // codigo
            tipoPerfil.getNombreVisual(),
            tipoPerfil.getDescripcion(),
            ahora.toLocalDateTime(),
            null // Activo
        );
    }

    /**
     * Reconstituir perfil desde persistencia
     */
    public static Perfil reconstituir(UUID id, String codigo, String nombre, String descripcion,
                                      LocalDateTime creationDate, LocalDateTime expirationDate) {
        return new Perfil(id, codigo, nombre, descripcion, creationDate, expirationDate);
    }

    // ========== VALIDACIONES ==========
    
    private void validarCodigo(String codigo) {
        if (codigo.isBlank()) {
            throw new IllegalArgumentException("Código no puede estar vacío");
        }
        
        if (codigo.length() > 50) {
            throw new IllegalArgumentException("Código no puede exceder 50 caracteres");
        }
        
        if (!TipoPerfil.esValido(codigo)) {
            throw new IllegalArgumentException("Código de perfil no es válido: " + codigo);
        }
    }
    
    private void validarNombre(String nombre) {
        if (nombre.isBlank()) {
            throw new IllegalArgumentException("Nombre no puede estar vacío");
        }
        
        if (nombre.length() > 100) {
            throw new IllegalArgumentException("Nombre no puede exceder 100 caracteres");
        }
    }
    
    private void validarDescripcion(String descripcion) {
        if (descripcion.isBlank()) {
            throw new IllegalArgumentException("Descripción no puede estar vacía");
        }
        
        if (descripcion.length() > 500) {
            throw new IllegalArgumentException("Descripción no puede exceder 500 caracteres");
        }
    }

    // ========== GETTERS ==========
    
    public String getCodigo() {
        return codigo;
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public TipoPerfil getTipoPerfil() {
        return TipoPerfil.valueOf(codigo);
    }

    public String getDescripcion() {
        return descripcion;
    }

    public LocalDateTime getCreationDate() {
        return creationDate;
    }

    public LocalDateTime getExpirationDate() {
        return expirationDate;
    }
    
    public boolean estaActivo() {
        return expirationDate == null;
    }

    // ========== EQUALS & HASHCODE ==========
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Perfil perfil)) return false;
        return Objects.equals(getId(), perfil.getId());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getId());
    }

    @Override
    public String toString() {
        return "Perfil{" +
                "id=" + getId() +
                ", codigo='" + codigo + '\'' +
                ", nombre='" + nombre + '\'' +
                ", activo=" + estaActivo() +
                '}';
    }
}
