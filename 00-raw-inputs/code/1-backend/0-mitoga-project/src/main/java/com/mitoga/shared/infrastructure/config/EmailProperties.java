package com.mitoga.shared.infrastructure.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * Configuración para envío de emails - SHARED INFRASTRUCTURE
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - SHARED KERNEL
 * - Properties compartidas para envío de notificaciones por email
 * - Usada por BC Notificaciones
 * - Configuración SMTP y templates
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "spring.mail")
public class EmailProperties {

    private String host;
    private Integer port;
    private String username;
    private String password;
    private String from;
    private String loginUrl = "https://app.zns-method.com/login";

    // Configuración de templates
    private String templatePath = "classpath:/templates/email/";
    private String supportEmail = "soporte@zns-method.com";

    // Configuración de intentos y timeouts
    private int maxRetries = 3;
    private long retryDelay = 1000; // milisegundos
}
