package com.mitoga.autenticacion.infrastructure.security;

import com.mitoga.autenticacion.application.port.output.PasswordEncoderPort;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

/**
 * BCryptPasswordAdapter - Implementación del port PasswordEncoderPort usando
 * BCrypt
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * ARQUITECTURA HEXAGONAL - INFRASTRUCTURE LAYER - SECURITY ADAPTER
 * - Implementa PasswordEncoderPort del dominio
 * - Usa BCrypt para hash de passwords (algoritmo seguro con salt)
 * - Strength 12 (2^12 = 4096 iteraciones)
 */
@Component
public class BCryptPasswordAdapter implements PasswordEncoderPort {

    private final BCryptPasswordEncoder bCryptPasswordEncoder;

    public BCryptPasswordAdapter() {
        this.bCryptPasswordEncoder = new BCryptPasswordEncoder(12); // Strength 12
    }

    @Override
    public String encode(String rawPassword) {
        return bCryptPasswordEncoder.encode(rawPassword);
    }

    @Override
    public boolean matches(String rawPassword, String encodedPassword) {
        return bCryptPasswordEncoder.matches(rawPassword, encodedPassword);
    }
}
