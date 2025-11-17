package com.mitoga.notificaciones.domain.entity;

import com.mitoga.shared.domain.valueobject.BaseEntity;
import com.mitoga.notificaciones.domain.valueobject.NotificationStatus;
import com.mitoga.notificaciones.domain.valueobject.NotificationType;
import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Entidad Notificación - ARQUITECTURA HEXAGONAL
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - DOMAIN LAYER - ENTITY
 * - Entidad de dominio del módulo Notificaciones
 * - Contiene la lógica de negocio para notificaciones
 * - Registro de notificaciones enviadas (auditoría)
 */
@Entity
@Table(name = "notificaciones", schema = "appmatch_schema")
@AttributeOverride(name = "id", column = @Column(name = "pkid_notificacion"))
@Data
@EqualsAndHashCode(callSuper = true)
public class Notificacion extends BaseEntity {

    @Enumerated(EnumType.STRING)
    @Column(name = "tipo", nullable = false)
    private NotificationType tipo;

    @Column(name = "destinatario", nullable = false)
    private String destinatario; // email o teléfono

    @Column(name = "asunto", length = 255)
    private String asunto;

    @Column(name = "contenido", columnDefinition = "text")
    private String contenido;

    @Enumerated(EnumType.STRING)
    @Column(name = "estado", nullable = false)
    private NotificationStatus estado = NotificationStatus.PENDIENTE;

    @Column(name = "usuario_id")
    private UUID usuarioId;

    @Column(name = "proposito", length = 50)
    private String proposito; // EMAIL_VERIFICATION, PASSWORD_RESET, etc.

    @Column(name = "intentos_envio")
    private Integer intentosEnvio = 0;

    @Column(name = "fecha_envio")
    private LocalDateTime fechaEnvio;

    @Column(name = "error_mensaje", columnDefinition = "text")
    private String errorMensaje;

    /**
     * Marca la notificación como enviada
     */
    public void marcarComoEnviada() {
        this.estado = NotificationStatus.ENVIADO;
        this.fechaEnvio = LocalDateTime.now();
    }

    /**
     * Marca la notificación como fallida
     */
    public void marcarComoFallida(String error) {
        this.estado = NotificationStatus.FALLIDO;
        this.errorMensaje = error;
        this.intentosEnvio++;
    }

    /**
     * Verifica si se puede reintentar el envío
     */
    public boolean puedeReintentar() {
        return intentosEnvio < 3 && estado == NotificationStatus.FALLIDO;
    }
}