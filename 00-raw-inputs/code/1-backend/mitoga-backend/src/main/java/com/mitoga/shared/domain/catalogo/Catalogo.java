package com.mitoga.shared.domain.catalogo;

import java.time.LocalDateTime;
import java.util.*;

/**
 * Aggregate Root - Catálogo Recursivo.
 * 
 * Representa un nodo en el árbol de catálogos jerárquico.
 * Implementa el patrón Adjacency List para estructuras padre-hijo.
 * 
 * Invariantes:
 * - Un catálogo debe tener código único dentro de su tipo
 * - El nivel debe ser >= 0 y < 100
 * - El orden debe estar entre 0 y 9998
 * - Los nodos raíz tienen padreId null y nivel 0
 * - Los nodos hijos tienen padreId not null y nivel > 0
 * - Un nodo inactivo no se puede seleccionar
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.0.0
 */
public class Catalogo {

    // Identity
    private final CatalogoId id;
    private final LocalDateTime creationDate;
    private LocalDateTime expirationDate;

    // Jerarquía
    private final CatalogoTipo tipo;
    private CatalogoId padreId;
    private Short nivel;
    private String pathCompleto;

    // Datos de negocio
    private String codigo;
    private String nombre;
    private String nombreEn;
    private String descripcion;
    private String descripcionEn;
    private Short orden;
    private String icono;
    private String color;
    private Boolean activo;
    private Boolean seleccionable;
    private Boolean tieneHijos;
    private Map<String, Object> metadatos;

    // Auditoría
    private UUID createdBy;
    private LocalDateTime updatedAt;
    private UUID updatedBy;

    /**
     * Constructor privado - Use factory methods.
     */
    private Catalogo(Builder builder) {
        this.id = builder.id;
        this.creationDate = builder.creationDate;
        this.expirationDate = builder.expirationDate;
        this.tipo = builder.tipo;
        this.padreId = builder.padreId;
        this.nivel = builder.nivel;
        this.pathCompleto = builder.pathCompleto;
        this.codigo = builder.codigo;
        this.nombre = builder.nombre;
        this.nombreEn = builder.nombreEn;
        this.descripcion = builder.descripcion;
        this.descripcionEn = builder.descripcionEn;
        this.orden = builder.orden;
        this.icono = builder.icono;
        this.color = builder.color;
        this.activo = builder.activo;
        this.seleccionable = builder.seleccionable;
        this.tieneHijos = builder.tieneHijos;
        this.metadatos = builder.metadatos;
        this.createdBy = builder.createdBy;
        this.updatedAt = builder.updatedAt;
        this.updatedBy = builder.updatedBy;

        validateInvariants();
    }

    /**
     * Factory method para crear un nuevo catálogo raíz.
     */
    public static Catalogo crearRaiz(
            CatalogoTipo tipo,
            String codigo,
            String nombre,
            Short orden) {

        return new Builder()
                .id(CatalogoId.generate())
                .creationDate(LocalDateTime.now())
                .tipo(tipo)
                .padreId(null)
                .nivel((short) 0)
                .pathCompleto(null)
                .codigo(codigo)
                .nombre(nombre)
                .orden(orden)
                .activo(true)
                .seleccionable(true)
                .tieneHijos(false)
                .metadatos(new HashMap<>())
                .build();
    }

    /**
     * Factory method para crear un catálogo hijo.
     */
    public static Catalogo crearHijo(
            CatalogoTipo tipo,
            CatalogoId padreId,
            String codigo,
            String nombre,
            Short orden) {

        Objects.requireNonNull(padreId, "PadreId no puede ser nulo para un hijo");

        return new Builder()
                .id(CatalogoId.generate())
                .creationDate(LocalDateTime.now())
                .tipo(tipo)
                .padreId(padreId)
                .nivel((short) 1) // Se calculará correctamente en BD por trigger
                .pathCompleto(null) // Se calculará en BD por trigger
                .codigo(codigo)
                .nombre(nombre)
                .orden(orden)
                .activo(true)
                .seleccionable(true)
                .tieneHijos(false)
                .metadatos(new HashMap<>())
                .build();
    }

    /**
     * Validaciones de invariantes del dominio.
     */
    private void validateInvariants() {
        Objects.requireNonNull(id, "CatalogoId no puede ser nulo");
        Objects.requireNonNull(tipo, "CatalogoTipo no puede ser nulo");
        Objects.requireNonNull(codigo, "Código no puede ser nulo");
        Objects.requireNonNull(nombre, "Nombre no puede ser nulo");
        Objects.requireNonNull(nivel, "Nivel no puede ser nulo");
        Objects.requireNonNull(orden, "Orden no puede ser nulo");
        Objects.requireNonNull(activo, "Activo no puede ser nulo");
        Objects.requireNonNull(seleccionable, "Seleccionable no puede ser nulo");
        Objects.requireNonNull(tieneHijos, "TieneHijos no puede ser nulo");

        if (codigo.trim().isEmpty()) {
            throw new IllegalArgumentException("Código no puede estar vacío");
        }

        if (codigo.length() > 50) {
            throw new IllegalArgumentException("Código no puede exceder 50 caracteres");
        }

        if (nombre.trim().isEmpty()) {
            throw new IllegalArgumentException("Nombre no puede estar vacío");
        }

        if (nombre.length() > 255) {
            throw new IllegalArgumentException("Nombre no puede exceder 255 caracteres");
        }

        if (nivel < 0 || nivel >= 100) {
            throw new IllegalArgumentException("Nivel debe estar entre 0 y 99");
        }

        if (orden < 0 || orden >= 9999) {
            throw new IllegalArgumentException("Orden debe estar entre 0 y 9998");
        }

        // Validar coherencia nivel-padre
        if (nivel == 0 && padreId != null) {
            throw new IllegalArgumentException("Un nodo raíz (nivel 0) no puede tener padre");
        }

        if (nivel > 0 && padreId == null) {
            throw new IllegalArgumentException("Un nodo hijo (nivel > 0) debe tener padre");
        }

        // Validar color hexadecimal si está presente
        if (color != null && !color.matches("^#[0-9A-Fa-f]{6}$")) {
            throw new IllegalArgumentException("Color debe ser un código hexadecimal válido (#RRGGBB)");
        }

        // Validar que un nodo inactivo no sea seleccionable
        if (!activo && seleccionable) {
            throw new IllegalArgumentException("Un catálogo inactivo no puede ser seleccionable");
        }
    }

    // ========== Métodos de Negocio ==========

    /**
     * Desactiva el catálogo (soft delete).
     */
    public void desactivar() {
        if (!activo) {
            throw new IllegalStateException("El catálogo ya está inactivo");
        }
        this.activo = false;
        this.seleccionable = false;
        this.expirationDate = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Activa el catálogo.
     */
    public void activar() {
        if (activo) {
            throw new IllegalStateException("El catálogo ya está activo");
        }
        this.activo = true;
        this.expirationDate = null;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Actualiza el nombre del catálogo.
     */
    public void actualizarNombre(String nuevoNombre, String nuevoNombreEn) {
        Objects.requireNonNull(nuevoNombre, "Nuevo nombre no puede ser nulo");
        if (nuevoNombre.trim().isEmpty()) {
            throw new IllegalArgumentException("Nuevo nombre no puede estar vacío");
        }
        if (nuevoNombre.length() > 255) {
            throw new IllegalArgumentException("Nuevo nombre no puede exceder 255 caracteres");
        }

        this.nombre = nuevoNombre.trim();
        this.nombreEn = nuevoNombreEn != null ? nuevoNombreEn.trim() : null;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Actualiza el orden del catálogo.
     */
    public void actualizarOrden(Short nuevoOrden) {
        Objects.requireNonNull(nuevoOrden, "Nuevo orden no puede ser nulo");
        if (nuevoOrden < 0 || nuevoOrden >= 9999) {
            throw new IllegalArgumentException("Orden debe estar entre 0 y 9998");
        }

        this.orden = nuevoOrden;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Marca que el catálogo es seleccionable en UI.
     */
    public void marcarComoSeleccionable() {
        if (!activo) {
            throw new IllegalStateException("No se puede marcar como seleccionable un catálogo inactivo");
        }
        this.seleccionable = true;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Marca que el catálogo NO es seleccionable en UI (solo categoría padre).
     */
    public void marcarComoNoSeleccionable() {
        this.seleccionable = false;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Actualiza los metadatos del catálogo.
     */
    public void actualizarMetadatos(Map<String, Object> nuevosMetadatos) {
        this.metadatos = nuevosMetadatos != null ? new HashMap<>(nuevosMetadatos) : new HashMap<>();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Verifica si el catálogo es un nodo raíz.
     */
    public boolean esRaiz() {
        return nivel == 0 && padreId == null;
    }

    /**
     * Verifica si el catálogo es un nodo hoja (sin hijos).
     */
    public boolean esHoja() {
        return !tieneHijos;
    }

    /**
     * Verifica si el catálogo está activo.
     */
    public boolean estaActivo() {
        return activo && expirationDate == null;
    }

    // ========== Getters ==========

    public CatalogoId getId() {
        return id;
    }

    public LocalDateTime getCreationDate() {
        return creationDate;
    }

    public LocalDateTime getExpirationDate() {
        return expirationDate;
    }

    public CatalogoTipo getTipo() {
        return tipo;
    }

    public CatalogoId getPadreId() {
        return padreId;
    }

    public Short getNivel() {
        return nivel;
    }

    public String getPathCompleto() {
        return pathCompleto;
    }

    public String getCodigo() {
        return codigo;
    }

    public String getNombre() {
        return nombre;
    }

    public String getNombreEn() {
        return nombreEn;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public String getDescripcionEn() {
        return descripcionEn;
    }

    public Short getOrden() {
        return orden;
    }

    public String getIcono() {
        return icono;
    }

    public String getColor() {
        return color;
    }

    public Boolean getActivo() {
        return activo;
    }

    public Boolean getSeleccionable() {
        return seleccionable;
    }

    public Boolean getTieneHijos() {
        return tieneHijos;
    }

    public Map<String, Object> getMetadatos() {
        return metadatos != null ? new HashMap<>(metadatos) : new HashMap<>();
    }

    public UUID getCreatedBy() {
        return createdBy;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public UUID getUpdatedBy() {
        return updatedBy;
    }

    // ========== Builder Pattern ==========

    public static class Builder {
        private CatalogoId id;
        private LocalDateTime creationDate;
        private LocalDateTime expirationDate;
        private CatalogoTipo tipo;
        private CatalogoId padreId;
        private Short nivel;
        private String pathCompleto;
        private String codigo;
        private String nombre;
        private String nombreEn;
        private String descripcion;
        private String descripcionEn;
        private Short orden;
        private String icono;
        private String color;
        private Boolean activo;
        private Boolean seleccionable;
        private Boolean tieneHijos;
        private Map<String, Object> metadatos;
        private UUID createdBy;
        private LocalDateTime updatedAt;
        private UUID updatedBy;

        public Builder id(CatalogoId id) {
            this.id = id;
            return this;
        }

        public Builder creationDate(LocalDateTime creationDate) {
            this.creationDate = creationDate;
            return this;
        }

        public Builder expirationDate(LocalDateTime expirationDate) {
            this.expirationDate = expirationDate;
            return this;
        }

        public Builder tipo(CatalogoTipo tipo) {
            this.tipo = tipo;
            return this;
        }

        public Builder padreId(CatalogoId padreId) {
            this.padreId = padreId;
            return this;
        }

        public Builder nivel(Short nivel) {
            this.nivel = nivel;
            return this;
        }

        public Builder pathCompleto(String pathCompleto) {
            this.pathCompleto = pathCompleto;
            return this;
        }

        public Builder codigo(String codigo) {
            this.codigo = codigo;
            return this;
        }

        public Builder nombre(String nombre) {
            this.nombre = nombre;
            return this;
        }

        public Builder nombreEn(String nombreEn) {
            this.nombreEn = nombreEn;
            return this;
        }

        public Builder descripcion(String descripcion) {
            this.descripcion = descripcion;
            return this;
        }

        public Builder descripcionEn(String descripcionEn) {
            this.descripcionEn = descripcionEn;
            return this;
        }

        public Builder orden(Short orden) {
            this.orden = orden;
            return this;
        }

        public Builder icono(String icono) {
            this.icono = icono;
            return this;
        }

        public Builder color(String color) {
            this.color = color;
            return this;
        }

        public Builder activo(Boolean activo) {
            this.activo = activo;
            return this;
        }

        public Builder seleccionable(Boolean seleccionable) {
            this.seleccionable = seleccionable;
            return this;
        }

        public Builder tieneHijos(Boolean tieneHijos) {
            this.tieneHijos = tieneHijos;
            return this;
        }

        public Builder metadatos(Map<String, Object> metadatos) {
            this.metadatos = metadatos;
            return this;
        }

        public Builder createdBy(UUID createdBy) {
            this.createdBy = createdBy;
            return this;
        }

        public Builder updatedAt(LocalDateTime updatedAt) {
            this.updatedAt = updatedAt;
            return this;
        }

        public Builder updatedBy(UUID updatedBy) {
            this.updatedBy = updatedBy;
            return this;
        }

        public Catalogo build() {
            return new Catalogo(this);
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (o == null || getClass() != o.getClass())
            return false;
        Catalogo catalogo = (Catalogo) o;
        return Objects.equals(id, catalogo.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return "Catalogo{" +
                "id=" + id +
                ", tipo=" + tipo +
                ", codigo='" + codigo + '\'' +
                ", nombre='" + nombre + '\'' +
                ", nivel=" + nivel +
                ", activo=" + activo +
                '}';
    }
}
