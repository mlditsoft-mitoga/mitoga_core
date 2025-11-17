package com.zenapses.mitoga.utils;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * Generador de hashes BCrypt para datos de prueba.
 * 
 * IMPORTANTE: Ejecutar esta clase ANTES de insertar-datos-prueba.sql
 * Copiar los hashes generados al script SQL.
 * 
 * @author Database Engineer Senior
 * @date 2025-11-16
 */
public class GenerarHashesPrueba {

    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(10); // 10 rounds (default)
        String password = "Test1234*";

        System.out.println("═══════════════════════════════════════════════════════════════");
        System.out.println("GENERADOR DE HASHES BCRYPT - Datos de Prueba");
        System.out.println("Password: " + password);
        System.out.println("Rounds: 10 (BCrypt default)");
        System.out.println("═══════════════════════════════════════════════════════════════\n");

        // Usuarios de prueba
        String[] usuarios = {
                "estudiante1@test.com",
                "estudiante2@test.com",
                "estudiante3@test.com",
                "tutor1@test.com",
                "tutor2@test.com",
                "estudiante_tutor@test.com",
                "admin@mitoga.com"
        };

        System.out.println("-- Hashes generados (copiar a insertar-datos-prueba.sql):");
        System.out.println("-- ═══════════════════════════════════════════════════════════════\n");

        for (int i = 0; i < usuarios.length; i++) {
            String hash = encoder.encode(password);
            System.out.println("-- Usuario: " + usuarios[i]);
            System.out.println("UPDATE appmatch_schema.usuarios");
            System.out.println("SET password_hash = '" + hash + "'");
            System.out.println("WHERE email = '" + usuarios[i] + "';");
            System.out.println();
        }

        System.out.println("\n═══════════════════════════════════════════════════════════════");
        System.out.println("✅ " + usuarios.length + " hashes generados correctamente");
        System.out.println("═══════════════════════════════════════════════════════════════");

        // Test de validación
        System.out.println("\n📋 TEST DE VALIDACIÓN:");
        String testHash = encoder.encode(password);
        boolean matches = encoder.matches(password, testHash);
        System.out.println("Hash generado: " + testHash);
        System.out.println("Validación: " + (matches ? "✅ CORRECTO" : "❌ ERROR"));

        // Mostrar estructura del hash
        System.out.println("\n📐 ESTRUCTURA DEL HASH BCRYPT:");
        System.out.println("$2a        = Identificador BCrypt");
        System.out.println("$10        = Cost factor (2^10 = 1024 iterations)");
        System.out.println("$[22 chars] = Salt (aleatoria, diferente cada vez)");
        System.out.println("[31 chars]  = Hash final");
        System.out.println("Total: 60 caracteres");
    }
}
