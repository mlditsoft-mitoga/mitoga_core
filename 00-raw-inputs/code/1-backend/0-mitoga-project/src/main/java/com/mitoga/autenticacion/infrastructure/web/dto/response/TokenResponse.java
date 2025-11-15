package com.mitoga.autenticacion.infrastructure.web.dto.response;

/**
 * TokenResponse - DTO para respuesta con tokens JWT
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 */
public class TokenResponse {

    private String accessToken;
    private String refreshToken;
    private String tokenType = "Bearer";
    private Long expiresIn; // Segundos hasta expiración
    private UsuarioInfoDto usuario;

    public TokenResponse() {
    }

    public TokenResponse(String accessToken, String refreshToken, Long expiresIn, UsuarioInfoDto usuario) {
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
        this.expiresIn = expiresIn;
        this.usuario = usuario;
    }

    // Inner class para info del usuario
    public static class UsuarioInfoDto {
        private String id;
        private String email;
        private String nombreCompleto;
        private String rol;
        private boolean emailVerificado;

        public UsuarioInfoDto() {
        }

        public UsuarioInfoDto(String id, String email, String nombreCompleto, String rol, boolean emailVerificado) {
            this.id = id;
            this.email = email;
            this.nombreCompleto = nombreCompleto;
            this.rol = rol;
            this.emailVerificado = emailVerificado;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getNombreCompleto() {
            return nombreCompleto;
        }

        public void setNombreCompleto(String nombreCompleto) {
            this.nombreCompleto = nombreCompleto;
        }

        public String getRol() {
            return rol;
        }

        public void setRol(String rol) {
            this.rol = rol;
        }

        public boolean isEmailVerificado() {
            return emailVerificado;
        }

        public void setEmailVerificado(boolean emailVerificado) {
            this.emailVerificado = emailVerificado;
        }
    }

    // Getters y Setters
    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public String getRefreshToken() {
        return refreshToken;
    }

    public void setRefreshToken(String refreshToken) {
        this.refreshToken = refreshToken;
    }

    public String getTokenType() {
        return tokenType;
    }

    public void setTokenType(String tokenType) {
        this.tokenType = tokenType;
    }

    public Long getExpiresIn() {
        return expiresIn;
    }

    public void setExpiresIn(Long expiresIn) {
        this.expiresIn = expiresIn;
    }

    public UsuarioInfoDto getUsuario() {
        return usuario;
    }

    public void setUsuario(UsuarioInfoDto usuario) {
        this.usuario = usuario;
    }
}
