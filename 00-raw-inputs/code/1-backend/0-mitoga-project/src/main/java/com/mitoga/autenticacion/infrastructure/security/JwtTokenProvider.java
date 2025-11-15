package com.mitoga.autenticacion.infrastructure.security;

import com.mitoga.autenticacion.application.port.output.JwtTokenPort;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * JwtTokenProvider - ImplementaciÃ³n del port JwtTokenPort usando JJWT
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - INFRASTRUCTURE LAYER - SECURITY ADAPTER
 * - Implementa JwtTokenPort del dominio
 * - Genera y valida JWT (JSON Web Tokens)
 * - Maneja access tokens y refresh tokens
 * - Usa JJWT 0.12.x con algoritmo HS512
 */
@Component
public class JwtTokenProvider implements JwtTokenPort {

    private final Key secretKey;
    private final long accessTokenExpirationMs;
    private final long refreshTokenExpirationMs;

    public JwtTokenProvider(
            @Value("${mitoga.jwt.secret}") String secret,
            @Value("${mitoga.jwt.access-token-expiration-minutes:480}") int accessTokenExpirationMinutes,
            @Value("${mitoga.jwt.refresh-token-expiration-days:30}") int refreshTokenExpirationDays) {

        // Generar clave segura desde secret
        this.secretKey = Keys.hmacShaKeyFor(secret.getBytes());
        this.accessTokenExpirationMs = accessTokenExpirationMinutes * 60 * 1000L;
        this.refreshTokenExpirationMs = refreshTokenExpirationDays * 24 * 60 * 60 * 1000L;
    }

    @Override
    public String generateAccessToken(UUID usuarioId, String email, String rol, Map<String, Object> claims) {
        Map<String, Object> allClaims = new HashMap<>(claims);
        allClaims.put("usuarioId", usuarioId.toString());
        allClaims.put("email", email);
        allClaims.put("rol", rol);
        allClaims.put("tokenType", "ACCESS");

        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + accessTokenExpirationMs);

        return Jwts.builder()
                .setClaims(allClaims)
                .setSubject(usuarioId.toString())
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(secretKey, SignatureAlgorithm.HS512)
                .compact();
    }

    @Override
    public String generateRefreshToken() {
        UUID randomId = UUID.randomUUID();
        Map<String, Object> claims = new HashMap<>();
        claims.put("tokenId", randomId.toString());
        claims.put("tokenType", "REFRESH");

        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + refreshTokenExpirationMs);

        return Jwts.builder()
                .setClaims(claims)
                .setSubject(randomId.toString())
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(secretKey, SignatureAlgorithm.HS512)
                .compact();
    }

    public UUID getUserIdFromToken(String token) {
        Claims claims = getAllClaimsFromToken(token);
        String usuarioIdStr = claims.get("usuarioId", String.class);
        return UUID.fromString(usuarioIdStr);
    }

    public String getEmailFromToken(String token) {
        Claims claims = getAllClaimsFromToken(token);
        return claims.get("email", String.class);
    }

    public String getRolFromToken(String token) {
        Claims claims = getAllClaimsFromToken(token);
        return claims.get("rol", String.class);
    }

    @Override
    public UUID validateAccessToken(String token) {
        try {
            Claims claims = getAllClaimsFromToken(token);
            String tokenType = claims.get("tokenType", String.class);

            // Verificar que sea un access token y no estÃ© expirado
            if ("ACCESS".equals(tokenType) && !isTokenExpired(token)) {
                String usuarioIdStr = claims.get("usuarioId", String.class);
                return UUID.fromString(usuarioIdStr);
            }
            return null;
        } catch (Exception e) {
            return null;
        }
    }

    public boolean validateRefreshToken(String token) {
        try {
            Claims claims = getAllClaimsFromToken(token);
            String tokenType = claims.get("tokenType", String.class);

            // Verificar que sea un refresh token y no estÃ© expirado
            return "REFRESH".equals(tokenType) && !isTokenExpired(token);
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public Map<String, Object> extractClaims(String token) {
        try {
            Claims claims = getAllClaimsFromToken(token);
            return new HashMap<>(claims);
        } catch (Exception e) {
            return new HashMap<>();
        }
    }

    @Override
    public Long getAccessTokenExpirationSeconds() {
        return accessTokenExpirationMs / 1000;
    }

    public boolean isTokenExpired(String token) {
        try {
            Date expiration = getExpirationDateFromToken(token);
            return expiration.before(new Date());
        } catch (Exception e) {
            return true;
        }
    }

    // ==================== MÃ‰TODOS PRIVADOS ====================

    private Claims getAllClaimsFromToken(String token) {
        return Jwts.parser()
                .setSigningKey(secretKey)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    private Date getExpirationDateFromToken(String token) {
        return getAllClaimsFromToken(token).getExpiration();
    }
}
