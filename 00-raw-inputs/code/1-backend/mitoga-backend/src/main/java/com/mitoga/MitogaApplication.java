package com.mitoga;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

/**
 * MI-TOGA Backend Application - Main Entry Point
 * 
 * <p>
 * Monolito Modular con Arquitectura Hexagonal y Domain-Driven Design (DDD).
 * </p>
 * 
 * <p>
 * <b>Bounded Contexts:</b>
 * </p>
 * <ul>
 * <li>Autenticación - Gestión de usuarios, login, JWT</li>
 * <li>Marketplace - Tutores, categorías, búsqueda</li>
 * <li>Perfiles - Información completa de estudiantes y tutores</li>
 * <li>Reservas - Agendamiento de sesiones, confirmaciones</li>
 * <li>Pagos - Integración Stripe, procesamiento de pagos</li>
 * <li>Videollamadas - Integración Agora.io para sesiones en vivo</li>
 * <li>Notificaciones - Email, push, in-app notifications</li>
 * <li>Admin - Panel administrativo, reportes, estadísticas</li>
 * </ul>
 * 
 * <p>
 * <b>Stack Tecnológico:</b>
 * </p>
 * <ul>
 * <li>Java 21 LTS (Records, Pattern Matching, Virtual Threads)</li>
 * <li>Spring Boot 3.4.0</li>
 * <li>PostgreSQL 16 (esquemas por Bounded Context)</li>
 * <li>Redis 7 (cache, rate limiting)</li>
 * <li>HashiCorp Vault (gestión de secrets)</li>
 * <li>Flyway (migraciones)</li>
 * </ul>
 * 
 * @author MI-TOGA Development Team
 * @version 1.0.0
 * @since 2025-11-08
 */
@SpringBootApplication
@EnableJpaAuditing
public class MitogaApplication {

    public static void main(String[] args) {
        SpringApplication.run(MitogaApplication.class, args);
    }

}
