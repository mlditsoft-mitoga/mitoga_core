package com.mitoga.autenticacion.domain.model;

import lombok.Value;

/**
 * Credenciales - VALUE OBJECT para encapsular datos de login
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - DOMAIN LAYER - VALUE OBJECT
 * - Value Object inmutable que encapsula las credenciales
 * - Sin identidad propia (identificado por sus valores)
 * - Usado para comandos de login y registro
 */
@Value
public class Credenciales {

    String email;
    String password;

    /**
     * Crea unas credenciales validando el formato del email
     */
    public static Credenciales of(String email, String password) {
        validarEmail(email);
        validarPassword(password);
        return new Credenciales(email, password);
    }

    /**
     * Valida que el email tenga formato válido
     */
    private static void validarEmail(String email) {
        if (email == null || email.isBlank()) {
            throw new IllegalArgumentException("El email no puede estar vacío");
        }

        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        if (!email.matches(emailRegex)) {
            throw new IllegalArgumentException("Formato de email inválido");
        }

        if (email.length() > 255) {
            throw new IllegalArgumentException("El email no puede tener más de 255 caracteres");
        }
    }

    /**
     * Valida que la contraseña cumpla con los requisitos mínimos
     */
    private static void validarPassword(String password) {
        if (password == null || password.isBlank()) {
            throw new IllegalArgumentException("La contraseña no puede estar vacía");
        }

        if (password.length() < 8) {
            throw new IllegalArgumentException("La contraseña debe tener al menos 8 caracteres");
        }

        if (password.length() > 128) {
            throw new IllegalArgumentException("La contraseña no puede tener más de 128 caracteres");
        }

        // Debe contener al menos: 1 mayúscula, 1 minúscula, 1 número
        boolean tieneMayuscula = password.chars().anyMatch(Character::isUpperCase);
        boolean tieneMinuscula = password.chars().anyMatch(Character::isLowerCase);
        boolean tieneNumero = password.chars().anyMatch(Character::isDigit);

        if (!tieneMayuscula || !tieneMinuscula || !tieneNumero) {
            throw new IllegalArgumentException(
                    "La contraseña debe contener al menos una mayúscula, una minúscula y un número");
        }
    }

    /**
     * Normaliza el email a minúsculas
     */
    public String getEmailNormalizado() {
        return email.toLowerCase().trim();
    }

    /**
     * Oculta la contraseña para logging seguro
     */
    public String toStringSafe() {
        return "Credenciales{email='" + email + "', password='***'}";
    }
}
