package com.mitoga.autenticacion.application.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO: Response para Registro STEP 1
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RegistroStep1Response {
    private String usuarioId;
    private String procesoRegistroId;
    private String email;
    private String estadoCuenta;
    private Boolean emailVerificado;
    private String mensaje;
    private Long tiempoExpiracionHoras;
}
