package com.mitoga.autenticacion.domain.valueobject;

import com.mitoga.shared.domain.DomainException;
import com.mitoga.shared.domain.ValueObject;

import java.util.Arrays;
import java.util.Objects;

/**
 * Value Object: Idioma preferido del usuario
 * 
 * <p>
 * Idiomas soportados según constraint DB:
 * </p>
 * <ul>
 * <li><b>es</b>: Español (default)</li>
 * <li><b>en</b>: English</li>
 * <li><b>fr</b>: Français</li>
 * <li><b>pt</b>: Português</li>
 * <li><b>de</b>: Deutsch</li>
 * <li><b>it</b>: Italiano</li>
 * </ul>
 * 
 * <p>
 * Usa códigos ISO 639-1 (2 letras)
 * </p>
 */
public enum IdiomaPreferido implements ValueObject {

    ES("es", "Español"),
    EN("en", "English"),
    FR("fr", "Français"),
    PT("pt", "Português"),
    DE("de", "Deutsch"),
    IT("it", "Italiano");

    private final String codigo;
    private final String nombre;

    IdiomaPreferido(String codigo, String nombre) {
        this.codigo = codigo;
        this.nombre = nombre;
    }

    public String getCodigo() {
        return codigo;
    }

    public String getNombre() {
        return nombre;
    }

    /**
     * Factory method para crear IdiomaPreferido desde código ISO 639-1
     */
    public static IdiomaPreferido from(String codigo) {
        Objects.requireNonNull(codigo, "Código idioma no puede ser nulo");

        String codigoNormalizado = codigo.toLowerCase().trim();

        return Arrays.stream(IdiomaPreferido.values())
                .filter(idioma -> idioma.codigo.equals(codigoNormalizado))
                .findFirst()
                .orElseThrow(() -> new IdiomaNoSoportadoException(
                        String.format("Idioma '%s' no soportado. Idiomas válidos: %s",
                                codigo, Arrays.toString(IdiomaPreferido.values()))));
    }

    /**
     * Factory method para crear IdiomaPreferido con default (Español)
     */
    public static IdiomaPreferido fromOrDefault(String codigo) {
        if (codigo == null || codigo.trim().isEmpty()) {
            return ES; // Default según DB
        }
        return from(codigo);
    }

    /**
     * Retorna el código ISO 639-1 para persistencia DB
     */
    public String toDBValue() {
        return this.codigo;
    }

    /**
     * Exception para idioma no soportado
     */
    public static class IdiomaNoSoportadoException extends DomainException {
        public IdiomaNoSoportadoException(String message) {
            super(message);
        }
    }
}
