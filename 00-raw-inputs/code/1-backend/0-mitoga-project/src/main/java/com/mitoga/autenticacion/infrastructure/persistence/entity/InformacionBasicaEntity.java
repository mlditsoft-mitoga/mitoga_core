package com.mitoga.autenticacion.infrastructure.persistence.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * JPA Entity: Información Básica
 * 
 * <p>
 * Mapea la tabla appmatch_schema.informacion_basica
 * </p>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Entity
@Table(name = "informacion_basica", schema = "appmatch_schema")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class InformacionBasicaEntity {

    @Id
    @Column(name = "pkid_informacion_basica", nullable = false)
    private UUID id;

    @Column(name = "primer_nombre", nullable = false, length = 50)
    private String primerNombre;

    @Column(name = "segundo_nombre", length = 50)
    private String segundoNombre;

    @Column(name = "primer_apellido", nullable = false, length = 50)
    private String primerApellido;

    @Column(name = "segundo_apellido", length = 50)
    private String segundoApellido;

    @Column(name = "fk_pkid_catalogo_tipo_documento", nullable = false)
    private UUID fkPkidCatalogoTipoDocumento;

    @Column(name = "numero_identificacion", nullable = false, length = 50)
    private String numeroIdentificacion;

    @Column(name = "email", nullable = false, length = 255)
    private String email;

    @Column(name = "telefono", nullable = false, length = 20)
    private String telefono;

    @Column(name = "fecha_nacimiento", nullable = false)
    private LocalDate fechaNacimiento;

    @Column(name = "fk_pkid_catalogo_genero", nullable = false)
    private UUID fkPkidCatalogoGenero;

    @Column(name = "fk_pkid_catalogo_pais", nullable = false)
    private UUID fkPkidCatalogoPais;

    @Column(name = "fk_pkid_catalogo_ciudad", nullable = false)
    private UUID fkPkidCatalogoCiudad;

    @Column(name = "direccion", length = 255)
    private String direccion;

    @Column(name = "tiene_responsable_legal", nullable = false)
    private Boolean tieneResponsableLegal;

    @Column(name = "responsable_email", length = 255)
    private String responsableEmail;

    @Column(name = "responsable_numero_identificacion", length = 50)
    private String responsableNumeroIdentificacion;

    @Column(name = "responsable_primer_nombre", length = 50)
    private String responsablePrimerNombre;

    @Column(name = "responsable_primer_apellido", length = 50)
    private String responsablePrimerApellido;

    @Column(name = "responsable_telefono", length = 20)
    private String responsableTelefono;

    @Column(name = "ip_registro", length = 45)
    private String ipRegistro;

    @Column(name = "metadata", columnDefinition = "jsonb")
    private String metadata;

    @Column(name = "creation_date", nullable = false)
    private LocalDateTime creationDate;

    @Column(name = "expiration_date")
    private LocalDateTime expirationDate;
}
