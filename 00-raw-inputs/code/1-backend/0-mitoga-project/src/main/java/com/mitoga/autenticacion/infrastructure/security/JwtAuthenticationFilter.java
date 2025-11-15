package com.mitoga.autenticacion.infrastructure.security;

import com.mitoga.autenticacion.application.port.output.JwtTokenPort;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;
import java.util.Map;
import java.util.UUID;

/**
 * JwtAuthenticationFilter - Filtro para autenticación basada en JWT
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - INFRASTRUCTURE LAYER - SECURITY FILTER
 * - Intercepta cada request HTTP
 * - Extrae y valida JWT token del header Authorization
 * - Configura SecurityContext con la autenticación del usuario
 * - Permite acceso a endpoints públicos sin token
 * 
 * FLUJO:
 * 1. Extrae JWT del header "Authorization: Bearer <token>"
 * 2. Valida el token usando JwtTokenProvider
 * 3. Extrae claims (usuarioId, email, rol)
 * 4. Crea Authentication object y lo coloca en SecurityContext
 * 5. Spring Security usa este contexto para autorización
 */
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private static final Logger logger = LoggerFactory.getLogger(JwtAuthenticationFilter.class);
    private static final String AUTHORIZATION_HEADER = "Authorization";
    private static final String BEARER_PREFIX = "Bearer ";

    private final JwtTokenPort jwtTokenProvider;

    public JwtAuthenticationFilter(JwtTokenPort jwtTokenProvider) {
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain) throws ServletException, IOException {

        try {
            // 1. Extraer JWT token del header Authorization
            String jwt = extractJwtFromRequest(request);

            // 2. Si hay token, validar y configurar autenticación
            if (jwt != null && !jwt.isEmpty()) {
                // Validar token y extraer usuarioId
                UUID usuarioId = jwtTokenProvider.validateAccessToken(jwt);

                if (usuarioId != null) {
                    // Extraer claims del token
                    Map<String, Object> claims = jwtTokenProvider.extractClaims(jwt);
                    String email = (String) claims.get("email");
                    String rol = (String) claims.get("rol");

                    // Crear Authentication object
                    UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                            usuarioId, // Principal (ID del usuario)
                            null, // Credentials (no necesitamos password aquí)
                            Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + rol)));

                    // Agregar detalles del request
                    authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                    // Configurar SecurityContext
                    SecurityContextHolder.getContext().setAuthentication(authentication);

                    logger.debug("Usuario autenticado: {} - Rol: {}", email, rol);

                } else {
                    logger.warn("Token JWT inválido o expirado");
                }
            }

        } catch (Exception e) {
            logger.error("Error al procesar JWT token: {}", e.getMessage());
            // No lanzamos la excepción, permitimos que el request continúe
            // Spring Security manejará la falta de autenticación en endpoints protegidos
        }

        // 3. Continuar con la cadena de filtros
        filterChain.doFilter(request, response);
    }

    /**
     * Extrae el JWT token del header Authorization
     * 
     * @param request HttpServletRequest
     * @return JWT token sin el prefijo "Bearer ", o null si no existe
     */
    private String extractJwtFromRequest(HttpServletRequest request) {
        String bearerToken = request.getHeader(AUTHORIZATION_HEADER);

        if (bearerToken != null && bearerToken.startsWith(BEARER_PREFIX)) {
            return bearerToken.substring(BEARER_PREFIX.length());
        }

        return null;
    }
}
