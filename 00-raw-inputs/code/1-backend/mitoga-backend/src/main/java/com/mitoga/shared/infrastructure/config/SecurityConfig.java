package com.mitoga.shared.infrastructure.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Configuración de Spring Security.
 * 
 * IMPORTANTE: Esta es una configuración TEMPORAL para desarrollo.
 * En producción, se debe implementar autenticación JWT completa.
 * 
 * @author Mitoga Development Team
 * @version 1.0.0
 * @since 2025-01-15
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    /**
     * Configuración de seguridad DESHABILITADA para desarrollo.
     * 
     * ⚠️ WARNING: Esta configuración permite acceso COMPLETO sin autenticación.
     * Solo debe usarse en entorno de desarrollo local.
     * 
     * TODO: Implementar autenticación JWT con las siguientes características:
     * - JWT/JWE para tokens (ver prompt-desarrollador-backend-senior.md)
     * - Refresh tokens con rotación
     * - Rate limiting con Redis
     * - CORS configurado correctamente
     * - CSRF protection habilitado
     * - Session management stateless
     * 
     * @param http HttpSecurity object para configurar reglas de seguridad
     * @return SecurityFilterChain configurado
     * @throws Exception si hay error en configuración
     */
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                // Deshabilitar CSRF (solo para desarrollo con API REST stateless)
                .csrf(AbstractHttpConfigurer::disable)

                // Permitir TODOS los endpoints sin autenticación
                .authorizeHttpRequests(auth -> auth
                        .anyRequest().permitAll())

                // Session stateless (REST API no debe usar sesiones)
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS))

                // Deshabilitar formulario de login por defecto
                .formLogin(AbstractHttpConfigurer::disable)

                // Deshabilitar HTTP Basic Auth
                .httpBasic(AbstractHttpConfigurer::disable);

        return http.build();
    }
}
