package com.mitoga.autenticacion.application.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

/**
 * DTO: Request para Registro STEP 1 (Credenciales + Selección de Perfil)
 * 
 * <p>
 * HUT-001: Registro de Estudiantes - STEP 1
 * </p>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.1.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RegistroStep1Request {

    @NotBlank(message = "Email es requerido")
    @Email(message = "Email debe ser válido", regexp = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")
    @Size(max = 255, message = "Email no puede exceder 255 caracteres")
    private String email;

    @NotBlank(message = "Password es requerido")
    @Size(min = 8, max = 100, message = "Password debe tener entre 8 y 100 caracteres")
    @Pattern(regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$", message = "Password debe contener al menos: 1 mayúscula, 1 minúscula, 1 número y 1 carácter especial")
    private String password;

    @NotBlank(message = "Confirmación de password es requerida")
    private String confirmPassword;

    @NotNull(message = "ID de perfil es requerido")
    private UUID tipoPerfil; // UUID del perfil (APRENDIZ, TUTOR, ADMIN)

    private MetadataRegistro metadata;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class MetadataRegistro {
        private String ipRegistro;
        private String userAgent;
        private String dispositivo;
        private String navegador;
        private String sistemaOperativo;
    }
}
