package com.mitoga.autenticacion.application.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

/**
 * DTO: Request para Registro STEP 2 (Información Personal)
 * 
 * <p>
 * HUT-001: Registro de Estudiantes - STEP 2
 * </p>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RegistroStep2Request {

    @NotBlank(message = "usuarioId es requerido")
    private String usuarioId;

    @NotBlank(message = "procesoRegistroId es requerido")
    private String procesoRegistroId;

    @NotNull(message = "informacionPersonal es requerida")
    @Valid
    private InformacionPersonal informacionPersonal;

    @Valid
    private ResponsableLegal responsableLegal;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class InformacionPersonal {

        @NotBlank(message = "primerNombre es requerido")
        @Size(min = 2, max = 50, message = "primerNombre debe tener entre 2 y 50 caracteres")
        @Pattern(regexp = "^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]+$", message = "primerNombre solo puede contener letras")
        private String primerNombre;

        @Size(max = 50, message = "segundoNombre no puede exceder 50 caracteres")
        @Pattern(regexp = "^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]*$", message = "segundoNombre solo puede contener letras")
        private String segundoNombre;

        @NotBlank(message = "primerApellido es requerido")
        @Size(min = 2, max = 50, message = "primerApellido debe tener entre 2 y 50 caracteres")
        @Pattern(regexp = "^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]+$", message = "primerApellido solo puede contener letras")
        private String primerApellido;

        @Size(max = 50, message = "segundoApellido no puede exceder 50 caracteres")
        @Pattern(regexp = "^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]*$", message = "segundoApellido solo puede contener letras")
        private String segundoApellido;

        @NotNull(message = "fechaNacimiento es requerida")
        @Past(message = "fechaNacimiento debe ser una fecha pasada")
        private LocalDate fechaNacimiento; // LocalDate para validación @Past

        @NotBlank(message = "generoId es requerido")
        private String generoId;

        @NotBlank(message = "tipoDocumentoId es requerido")
        private String tipoDocumentoId;

        @NotBlank(message = "numeroDocumento es requerido")
        @Size(min = 5, max = 20, message = "numeroDocumento debe tener entre 5 y 20 caracteres")
        private String numeroDocumento;

        @NotBlank(message = "telefono es requerido")
        @Pattern(regexp = "^\\+?[0-9]{10,15}$", message = "telefono debe ser válido (10-15 dígitos)")
        private String telefono;

        @NotBlank(message = "paisId es requerido")
        private String paisId;

        @NotBlank(message = "ciudadId es requerido")
        private String ciudadId;

        @NotBlank(message = "direccion es requerida")
        @Size(min = 10, max = 200, message = "direccion debe tener entre 10 y 200 caracteres")
        private String direccion;

        @Size(max = 10, message = "codigoPostal no puede exceder 10 caracteres")
        private String codigoPostal;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ResponsableLegal {

        @NotNull(message = "requerido es obligatorio")
        private Boolean requerido;

        @Size(max = 50, message = "primerNombre no puede exceder 50 caracteres")
        private String primerNombre;

        @Size(max = 50, message = "primerApellido no puede exceder 50 caracteres")
        private String primerApellido;

        @Email(message = "email debe ser válido")
        private String email;

        @Pattern(regexp = "^\\+?[0-9]{10,15}$|^$", message = "telefono debe ser válido")
        private String telefono;

        private String tipoDocumentoId;

        @Size(max = 20, message = "numeroDocumento no puede exceder 20 caracteres")
        private String numeroDocumento;
    }
}
