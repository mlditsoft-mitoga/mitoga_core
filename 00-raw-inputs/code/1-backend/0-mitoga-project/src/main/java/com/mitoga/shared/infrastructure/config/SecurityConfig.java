package com.mitoga.shared.infrastructure.config;

// import com.mitoga.autenticacion.infrastructure.security.JwtAuthenticationFilter; // BC Autenticación eliminado
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
// import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter; // Ya no se usa
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

/**
 * SecurityConfig - Configuración de Spring Security
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - SHARED INFRASTRUCTURE - SECURITY CONFIG
 * - SecurityFilterChain con JWT Authentication
 * - OAuth 2.0 Client Registration (Google, Facebook, Microsoft, GitHub, Apple)
 * - CORS configurado para desarrollo y producción
 * - Endpoints públicos y protegidos
 * - Stateless session (JWT-based authentication)
 * 
 * @author Mitoga Development Team
 * @version 2.0.0
 * @since 2025-01-15
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

        // private final JwtAuthenticationFilter jwtAuthenticationFilter; // BC Autenticación eliminado

        public SecurityConfig() {
                // this.jwtAuthenticationFilter = jwtAuthenticationFilter; // BC Autenticación eliminado
        }

        @Bean
        public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
                http
                                // CSRF deshabilitado (usamos JWT tokens)
                                .csrf(csrf -> csrf.disable())

                                // CORS configurado
                                .cors(cors -> cors.configurationSource(corsConfigurationSource()))

                                // Session Management - Stateless (JWT)
                                .sessionManagement(session -> session
                                                .sessionCreationPolicy(SessionCreationPolicy.STATELESS))

                                // Autorización de requests
                                .authorizeHttpRequests(auth -> auth
                                                // Endpoints públicos - BC Autenticación
                                                .requestMatchers(HttpMethod.POST, "/api/v1/auth/registro/**")
                                                .permitAll()
                                                .requestMatchers(HttpMethod.POST, "/api/v1/auth/login").permitAll()
                                                .requestMatchers(HttpMethod.POST, "/api/v1/auth/refresh-token")
                                                .permitAll()
                                                .requestMatchers(HttpMethod.POST, "/api/v1/auth/verificar-email")
                                                .permitAll()
                                                .requestMatchers(HttpMethod.POST, "/api/v1/auth/reenviar-codigo")
                                                .permitAll()
                                                .requestMatchers(HttpMethod.POST, "/api/v1/auth/oauth/*/login")
                                                .permitAll()

                                                // Endpoints públicos - Documentación (OpenAPI/Swagger)
                                                .requestMatchers(
                                                                "/swagger-ui/**",
                                                                "/swagger-ui.html",
                                                                "/v3/api-docs/**",
                                                                "/api-docs/**",
                                                                "/swagger-resources/**",
                                                                "/webjars/**")
                                                .permitAll()

                                                // Endpoints públicos - Actuator (solo health)
                                                .requestMatchers("/actuator/**").permitAll()

                                                // Endpoints públicos - Estáticos (si aplica)
                                                .requestMatchers("/public/**", "/static/**", "/images/**", "/css/**",
                                                                "/js/**")
                                                .permitAll()

                                                // Endpoints públicos - BC Shared (Catálogos - Solo consultas)
                                                .requestMatchers(HttpMethod.POST, "/api/v1/catalogos/buscar-arbol")
                                                .permitAll()
                                                .requestMatchers(HttpMethod.POST, "/api/v1/catalogos/buscar")
                                                .permitAll()
                                                .requestMatchers(HttpMethod.POST, "/api/v1/catalogos/buscar-ancestros")
                                                .permitAll()
                                                .requestMatchers(HttpMethod.POST,
                                                                "/api/v1/catalogos/buscar-descendientes")
                                                .permitAll()
                                                .requestMatchers(HttpMethod.GET, "/api/v1/catalogos/*").permitAll() // Obtener
                                                                                                                    // por
                                                                                                                    // ID

                                                // Endpoints protegidos - BC Shared (Catálogos - Gestión)
                                                .requestMatchers(HttpMethod.POST, "/api/v1/catalogos").authenticated() // Crear
                                                .requestMatchers(HttpMethod.PUT, "/api/v1/catalogos/**").authenticated() // Actualizar
                                                .requestMatchers(HttpMethod.DELETE, "/api/v1/catalogos/**")
                                                .authenticated() // Eliminar

                                                // Endpoints protegidos - BC Autenticación
                                                .requestMatchers(HttpMethod.POST, "/api/v1/auth/vincular-oauth")
                                                .authenticated()
                                                .requestMatchers(HttpMethod.POST, "/api/v1/auth/logout").authenticated()
                                                .requestMatchers(HttpMethod.GET, "/api/v1/auth/perfil").authenticated()

                                                // Endpoints protegidos - Otros BCs (Tutores, Estudiantes, Pagos, etc.)
                                                .requestMatchers("/api/v1/tutores/**").authenticated()
                                                .requestMatchers("/api/v1/estudiantes/**").authenticated()
                                                .requestMatchers("/api/v1/pagos/**").authenticated()
                                                .requestMatchers("/api/v1/sesiones/**").authenticated()
                                                .requestMatchers("/api/v1/videoconferencias/**").authenticated()

                                                // Admin endpoints (futura implementación)
                                                .requestMatchers("/api/v1/admin/**").hasRole("ADMIN")

                                // Cualquier otro request requiere autenticación
                                .anyRequest().authenticated());

                                // JWT Authentication Filter (antes de UsernamePasswordAuthenticationFilter)
                                // .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class); // BC Autenticación eliminado
                
                return http.build();
        }

        /**
         * Configuración CORS
         * Permite requests desde frontend (React en localhost:3000 o dominio de
         * producción)
         */
        @Bean
        public CorsConfigurationSource corsConfigurationSource() {
                CorsConfiguration configuration = new CorsConfiguration();

                // Orígenes permitidos (ajustar según ambiente)
                // Usar allowedOriginPatterns para permitir localhost con cualquier puerto +
                // Swagger UI
                configuration.setAllowedOriginPatterns(Arrays.asList(
                                "http://localhost:*", // Cualquier puerto localhost (Swagger UI, React, Vite)
                                "http://127.0.0.1:*", // Alias de localhost
                                "http://localhost:8081", // Frontend específico (si no cubre el patrón)
                                "https://mitoga.com", // Producción
                                "https://*.mitoga.com" // Subdominios producción
                ));

                // Métodos HTTP permitidos
                configuration.setAllowedMethods(Arrays.asList(
                                "GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));

                // Headers permitidos
                configuration.setAllowedHeaders(Arrays.asList(
                                "Authorization",
                                "Content-Type",
                                "X-Requested-With",
                                "Accept",
                                "Origin",
                                "Access-Control-Request-Method",
                                "Access-Control-Request-Headers"));

                // Headers expuestos (para que el frontend pueda leerlos)
                configuration.setExposedHeaders(Arrays.asList(
                                "Authorization",
                                "Content-Disposition"));

                // Permitir credenciales (cookies, headers de autorización)
                configuration.setAllowCredentials(true);

                // Max age (en segundos) para preflight requests
                configuration.setMaxAge(3600L);

                UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
                source.registerCorsConfiguration("/**", configuration);

                return source;
        }
}
