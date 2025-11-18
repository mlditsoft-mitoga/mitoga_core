package com.mitoga.autenticacion.domain.entity;

import com.mitoga.shared.domain.AggregateRoot;
import lombok.Getter;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.util.UUID;

/**
 * Aggregate Root: Información Básica del Usuario
 * 
 * <p>
 * Representa los datos personales completos de un usuario (nombres, documento,
 * contacto, ubicación, responsable legal si es menor).
 * </p>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Getter
public class InformacionBasica extends AggregateRoot<UUID> {

    private final UUID id;
    
    // Nombres
    private final String primerNombre;
    private final String segundoNombre;
    private final String primerApellido;
    private final String segundoApellido;
    
    // Documento de identidad
    private final UUID tipoDocumentoId;
    private final String numeroIdentificacion;
    
    // Contacto
    private final String email;
    private final String telefono;
    
    // Fecha de nacimiento
    private final LocalDate fechaNacimiento;
    
    // Género
    private final UUID generoId;
    
    // Ubicación
    private final UUID paisId;
    private final UUID ciudadId;
    private final String direccion;
    
    // Responsable legal (si es menor de edad)
    private final Boolean tieneResponsableLegal;
    private final String responsableEmail;
    private final String responsableNumeroIdentificacion;
    private final String responsablePrimerNombre;
    private final String responsablePrimerApellido;
    private final String responsableTelefono;
    
    // Metadata
    private final String ipRegistro;
    private final String metadata;
    
    // Auditoría
    private final LocalDateTime creationDate;
    private final LocalDateTime expirationDate;

    /**
     * Constructor privado (usar factory methods)
     */
    private InformacionBasica(
            UUID id,
            String primerNombre,
            String segundoNombre,
            String primerApellido,
            String segundoApellido,
            UUID tipoDocumentoId,
            String numeroIdentificacion,
            String email,
            String telefono,
            LocalDate fechaNacimiento,
            UUID generoId,
            UUID paisId,
            UUID ciudadId,
            String direccion,
            Boolean tieneResponsableLegal,
            String responsableEmail,
            String responsableNumeroIdentificacion,
            String responsablePrimerNombre,
            String responsablePrimerApellido,
            String responsableTelefono,
            String ipRegistro,
            String metadata,
            LocalDateTime creationDate,
            LocalDateTime expirationDate) {
        
        super(id);
        this.id = id;
        this.primerNombre = primerNombre;
        this.segundoNombre = segundoNombre;
        this.primerApellido = primerApellido;
        this.segundoApellido = segundoApellido;
        this.tipoDocumentoId = tipoDocumentoId;
        this.numeroIdentificacion = numeroIdentificacion;
        this.email = email;
        this.telefono = telefono;
        this.fechaNacimiento = fechaNacimiento;
        this.generoId = generoId;
        this.paisId = paisId;
        this.ciudadId = ciudadId;
        this.direccion = direccion;
        this.tieneResponsableLegal = tieneResponsableLegal;
        this.responsableEmail = responsableEmail;
        this.responsableNumeroIdentificacion = responsableNumeroIdentificacion;
        this.responsablePrimerNombre = responsablePrimerNombre;
        this.responsablePrimerApellido = responsablePrimerApellido;
        this.responsableTelefono = responsableTelefono;
        this.ipRegistro = ipRegistro;
        this.metadata = metadata;
        this.creationDate = creationDate;
        this.expirationDate = expirationDate;
    }

    /**
     * Factory Method: Crear InformacionBasica en STEP 2
     */
    public static InformacionBasica crear(
            String primerNombre,
            String segundoNombre,
            String primerApellido,
            String segundoApellido,
            UUID tipoDocumentoId,
            String numeroIdentificacion,
            String email,
            String telefono,
            LocalDate fechaNacimiento,
            UUID generoId,
            UUID paisId,
            UUID ciudadId,
            String direccion,
            Boolean tieneResponsableLegal,
            String responsableEmail,
            String responsableNumeroIdentificacion,
            String responsablePrimerNombre,
            String responsablePrimerApellido,
            String responsableTelefono,
            String ipRegistro,
            String metadata) {

        // Validaciones básicas
        if (primerNombre == null || primerNombre.isBlank()) {
            throw new IllegalArgumentException("primerNombre es requerido");
        }
        if (primerApellido == null || primerApellido.isBlank()) {
            throw new IllegalArgumentException("primerApellido es requerido");
        }
        if (numeroIdentificacion == null || numeroIdentificacion.isBlank()) {
            throw new IllegalArgumentException("numeroIdentificacion es requerido");
        }
        if (email == null || email.isBlank()) {
            throw new IllegalArgumentException("email es requerido");
        }
        if (fechaNacimiento == null) {
            throw new IllegalArgumentException("fechaNacimiento es requerida");
        }

        return new InformacionBasica(
                UUID.randomUUID(),
                primerNombre.trim(),
                segundoNombre != null ? segundoNombre.trim() : null,
                primerApellido.trim(),
                segundoApellido != null ? segundoApellido.trim() : null,
                tipoDocumentoId,
                numeroIdentificacion.trim(),
                email.trim(),
                telefono.trim(),
                fechaNacimiento,
                generoId,
                paisId,
                ciudadId,
                direccion != null ? direccion.trim() : null,
                tieneResponsableLegal,
                responsableEmail,
                responsableNumeroIdentificacion,
                responsablePrimerNombre,
                responsablePrimerApellido,
                responsableTelefono,
                ipRegistro,
                metadata != null ? metadata : "{}",
                LocalDateTime.now(),
                null
        );
    }

    /**
     * Reconstituir desde BD
     */
    public static InformacionBasica reconstituir(
            UUID id,
            String primerNombre,
            String segundoNombre,
            String primerApellido,
            String segundoApellido,
            UUID tipoDocumentoId,
            String numeroIdentificacion,
            String email,
            String telefono,
            LocalDate fechaNacimiento,
            UUID generoId,
            UUID paisId,
            UUID ciudadId,
            String direccion,
            Boolean tieneResponsableLegal,
            String responsableEmail,
            String responsableNumeroIdentificacion,
            String responsablePrimerNombre,
            String responsablePrimerApellido,
            String responsableTelefono,
            String ipRegistro,
            String metadata,
            LocalDateTime creationDate,
            LocalDateTime expirationDate) {

        return new InformacionBasica(
                id, primerNombre, segundoNombre, primerApellido, segundoApellido,
                tipoDocumentoId, numeroIdentificacion, email, telefono, fechaNacimiento,
                generoId, paisId, ciudadId, direccion, tieneResponsableLegal,
                responsableEmail, responsableNumeroIdentificacion, responsablePrimerNombre,
                responsablePrimerApellido, responsableTelefono, ipRegistro, metadata,
                creationDate, expirationDate
        );
    }

    /**
     * Calcular edad en años
     */
    public int calcularEdad() {
        return Period.between(fechaNacimiento, LocalDate.now()).getYears();
    }

    /**
     * Verificar si es mayor de edad (18 años)
     */
    public boolean esMayorDeEdad() {
        return calcularEdad() >= 18;
    }

    /**
     * Obtener nombre completo
     */
    public String getNombreCompleto() {
        StringBuilder nombreCompleto = new StringBuilder(primerNombre);
        if (segundoNombre != null && !segundoNombre.isBlank()) {
            nombreCompleto.append(" ").append(segundoNombre);
        }
        nombreCompleto.append(" ").append(primerApellido);
        if (segundoApellido != null && !segundoApellido.isBlank()) {
            nombreCompleto.append(" ").append(segundoApellido);
        }
        return nombreCompleto.toString();
    }
}
