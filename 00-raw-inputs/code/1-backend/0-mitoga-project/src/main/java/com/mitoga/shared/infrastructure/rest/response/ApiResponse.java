package com.mitoga.shared.infrastructure.rest.response;

import com.fasterxml.jackson.annotation.JsonInclude;

/**
 * ApiResponse<T> - Wrapper genérico para respuestas REST API
 * Proporciona estructura consistente: success, data, mensaje, errors
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public record ApiResponse<T>(
    boolean success,
    T data,
    String mensaje,
    Object errors
) {
    
    /**
     * Respuesta exitosa con data
     */
    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(true, data, null, null);
    }
    
    /**
     * Respuesta exitosa con data y mensaje personalizado
     */
    public static <T> ApiResponse<T> success(T data, String mensaje) {
        return new ApiResponse<>(true, data, mensaje, null);
    }
    
    /**
     * Respuesta de error con mensaje
     */
    public static <T> ApiResponse<T> error(String mensaje) {
        return new ApiResponse<>(false, null, mensaje, null);
    }
    
    /**
     * Respuesta de error con mensaje y detalles
     */
    public static <T> ApiResponse<T> error(String mensaje, Object errors) {
        return new ApiResponse<>(false, null, mensaje, errors);
    }
}
