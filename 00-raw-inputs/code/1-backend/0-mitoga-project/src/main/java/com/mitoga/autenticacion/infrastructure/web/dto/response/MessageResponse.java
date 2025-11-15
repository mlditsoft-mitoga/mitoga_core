package com.mitoga.autenticacion.infrastructure.web.dto.response;

/**
 * MessageResponse - DTO genérico para respuestas simples con mensaje
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 */
public class MessageResponse {

    private String mensaje;
    private boolean exito;

    public MessageResponse() {
    }

    public MessageResponse(String mensaje, boolean exito) {
        this.mensaje = mensaje;
        this.exito = exito;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public boolean isExito() {
        return exito;
    }

    public void setExito(boolean exito) {
        this.exito = exito;
    }
}
