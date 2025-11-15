package com.mitoga.autenticacion.infrastructure.web.dto.response;

/**
 * RegistroResponse - DTO para respuesta de registro exitoso
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 */
public class RegistroResponse {

    private String usuarioId;
    private String email;
    private String mensaje;

    public RegistroResponse() {
    }

    public RegistroResponse(String usuarioId, String email, String mensaje) {
        this.usuarioId = usuarioId;
        this.email = email;
        this.mensaje = mensaje;
    }

    public String getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(String usuarioId) {
        this.usuarioId = usuarioId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }
}
