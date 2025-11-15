package com.mitoga.autenticacion.application.command;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * RegistrarUsuarioCommand - Comando para registrar nuevo usuario
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - APPLICATION LAYER - COMMAND (CQRS)
 * - Comando inmutable que representa la intención de registrar un usuario
 * - Usado por el caso de uso de registro
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class RegistrarUsuarioCommand {
    private String email;
    private String password;
    private String nombre;
    private String apellido;
    private String rol; // ESTUDIANTE, TUTOR
}
