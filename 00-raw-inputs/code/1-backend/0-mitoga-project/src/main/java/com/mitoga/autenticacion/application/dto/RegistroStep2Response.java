package com.mitoga.autenticacion.application.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO: Response para Registro STEP 2
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
public class RegistroStep2Response {
    
    private String informacionBasicaId;
    private Boolean esMayorDeEdad;
    private Boolean requiereResponsableLegal;
    private String mensaje;
}
