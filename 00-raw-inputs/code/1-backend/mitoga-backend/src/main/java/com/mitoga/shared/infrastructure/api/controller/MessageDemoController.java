package com.mitoga.shared.infrastructure.api.controller;

import com.mitoga.shared.infrastructure.api.exception.ConflictException;
import com.mitoga.shared.infrastructure.api.exception.ResourceNotFoundException;
import com.mitoga.shared.infrastructure.api.message.ErrorMessage;
import com.mitoga.shared.infrastructure.api.message.SuccessMessage;
import com.mitoga.shared.infrastructure.api.response.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * Controller de demostración para el sistema de mensajes estandarizados.
 * Muestra cómo usar SuccessMessage y ErrorMessage en endpoints reales.
 *
 * <p>
 * Este controller NO debe ser usado en producción. Es solo para demostrar
 * el uso correcto de los enums de mensajes y cómo se integran con
 * ApiResponse y GlobalExceptionHandler.
 * </p>
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
@RestController
@RequestMapping("/demo/messages")
@Tag(name = "Message Demo", description = "Demostración del sistema de mensajes estandarizados")
@RequiredArgsConstructor
@Slf4j
public class MessageDemoController {

    /**
     * Endpoint que demuestra el uso de SuccessMessage para operaciones exitosas.
     *
     * @return ResponseEntity con ApiResponse usando SuccessMessage.GEN_CREATED
     */
    @PostMapping("/success-create")
    @Operation(summary = "Demo de mensaje de creación exitosa", description = "Demuestra el uso de SuccessMessage.GEN_CREATED")
    public ResponseEntity<ApiResponse<Map<String, String>>> demoSuccessCreate() {
        log.info("Demo: Creando recurso ficticio");

        Map<String, String> data = Map.of(
                "id", "123e4567-e89b-12d3-a456-426614174000",
                "name", "Recurso de ejemplo");

        // Uso correcto de SuccessMessage enum
        ApiResponse<Map<String, String>> response = ApiResponse.success(
                data,
                SuccessMessage.GEN_CREATED);

        return ResponseEntity.ok(response);
    }

    /**
     * Endpoint que demuestra el uso de SuccessMessage para operaciones de
     * actualización.
     *
     * @param id ID del recurso a actualizar
     * @return ResponseEntity con ApiResponse usando SuccessMessage.GEN_UPDATED
     */
    @PutMapping("/success-update/{id}")
    @Operation(summary = "Demo de mensaje de actualización exitosa", description = "Demuestra el uso de SuccessMessage.GEN_UPDATED")
    public ResponseEntity<ApiResponse<Map<String, String>>> demoSuccessUpdate(@PathVariable String id) {
        log.info("Demo: Actualizando recurso {}", id);

        Map<String, String> data = Map.of(
                "id", id,
                "name", "Recurso actualizado");

        // Uso correcto de SuccessMessage enum
        ApiResponse<Map<String, String>> response = ApiResponse.success(
                data,
                SuccessMessage.GEN_UPDATED);

        return ResponseEntity.ok(response);
    }

    /**
     * Endpoint que demuestra el uso de SuccessMessage para eliminaciones.
     *
     * @param id ID del recurso a eliminar
     * @return ResponseEntity con ApiResponse usando SuccessMessage.GEN_DELETED
     */
    @DeleteMapping("/success-delete/{id}")
    @Operation(summary = "Demo de mensaje de eliminación exitosa", description = "Demuestra el uso de SuccessMessage.GEN_DELETED")
    public ResponseEntity<ApiResponse<Void>> demoSuccessDelete(@PathVariable String id) {
        log.info("Demo: Eliminando recurso {}", id);

        // Uso correcto de SuccessMessage enum para respuestas sin contenido
        ApiResponse<Void> response = ApiResponse.successNoContent(SuccessMessage.GEN_DELETED);

        return ResponseEntity.ok(response);
    }

    /**
     * Endpoint que demuestra cómo se lanzan excepciones que serán capturadas
     * por GlobalExceptionHandler y transformadas en ErrorResponse con ErrorMessage
     * enums.
     *
     * @param id ID del recurso a buscar
     * @return Nunca retorna, siempre lanza ResourceNotFoundException
     */
    @GetMapping("/error-not-found/{id}")
    @Operation(summary = "Demo de error 404 - Recurso no encontrado", description = "Demuestra cómo ResourceNotFoundException se transforma en ErrorResponse")
    public ResponseEntity<ApiResponse<Map<String, String>>> demoErrorNotFound(@PathVariable String id) {
        log.warn("Demo: Buscando recurso inexistente {}", id);

        // GlobalExceptionHandler capturará esta excepción y usará
        // ErrorMessage.ERR_GEN_RESOURCE_NOT_FOUND
        throw new ResourceNotFoundException("Recurso", id);
    }

    /**
     * Endpoint que demuestra error de conflicto (409).
     *
     * @param email Email que genera conflicto
     * @return Nunca retorna, siempre lanza ConflictException
     */
    @PostMapping("/error-conflict")
    @Operation(summary = "Demo de error 409 - Conflicto", description = "Demuestra cómo ConflictException se transforma en ErrorResponse")
    public ResponseEntity<ApiResponse<Map<String, String>>> demoErrorConflict(
            @RequestParam String email) {
        log.warn("Demo: Intentando registrar email duplicado {}", email);

        // GlobalExceptionHandler capturará esta excepción
        throw new ConflictException(String.format("El email %s ya está registrado", email));
    }

    /**
     * Endpoint que demuestra error interno del servidor (500).
     *
     * @return Nunca retorna, siempre lanza RuntimeException
     */
    @GetMapping("/error-server")
    @Operation(summary = "Demo de error 500 - Error interno del servidor", description = "Demuestra cómo Exception genérica se transforma en ErrorResponse")
    public ResponseEntity<ApiResponse<Map<String, String>>> demoErrorServer() {
        log.error("Demo: Simulando error interno del servidor");

        // GlobalExceptionHandler capturará esta excepción y usará
        // ErrorMessage.ERR_GEN_INTERNAL_SERVER
        throw new RuntimeException("Simulación de error interno del servidor");
    }

    /**
     * Endpoint informativo que lista todos los SuccessMessage disponibles.
     *
     * @return Lista de todos los mensajes de éxito
     */
    @GetMapping("/success-messages")
    @Operation(summary = "Lista todos los SuccessMessage disponibles", description = "Endpoint de referencia para ver todos los mensajes de éxito")
    public ResponseEntity<ApiResponse<Map<String, String>>> listSuccessMessages() {
        Map<String, String> messages = Map.ofEntries(
                Map.entry("GEN_CREATED", SuccessMessage.GEN_CREATED.getMessage()),
                Map.entry("GEN_UPDATED", SuccessMessage.GEN_UPDATED.getMessage()),
                Map.entry("GEN_DELETED", SuccessMessage.GEN_DELETED.getMessage()),
                Map.entry("USER_REGISTERED", SuccessMessage.USER_REGISTERED.getMessage()),
                Map.entry("USER_LOGIN_SUCCESS", SuccessMessage.USER_LOGIN_SUCCESS.getMessage()),
                Map.entry("RESERVA_CREATED", SuccessMessage.RESERVA_CREATED.getMessage()),
                Map.entry("PAGO_PROCESSED", SuccessMessage.PAGO_PROCESSED.getMessage()));

        ApiResponse<Map<String, String>> response = ApiResponse.success(
                messages,
                "Lista de SuccessMessages (ejemplo parcial)");

        return ResponseEntity.ok(response);
    }

    /**
     * Endpoint informativo que lista algunos ErrorMessage disponibles.
     *
     * @return Lista de algunos mensajes de error
     */
    @GetMapping("/error-messages")
    @Operation(summary = "Lista algunos ErrorMessage disponibles", description = "Endpoint de referencia para ver mensajes de error")
    public ResponseEntity<ApiResponse<Map<String, String>>> listErrorMessages() {
        Map<String, String> messages = Map.ofEntries(
                Map.entry("ERR_GEN_INTERNAL_SERVER", ErrorMessage.ERR_GEN_INTERNAL_SERVER.getMessage()),
                Map.entry("ERR_GEN_RESOURCE_NOT_FOUND", ErrorMessage.ERR_GEN_RESOURCE_NOT_FOUND.getMessage()),
                Map.entry("ERR_AUTH_INVALID_CREDENTIALS", ErrorMessage.ERR_AUTH_INVALID_CREDENTIALS.getMessage()),
                Map.entry("ERR_VAL_REQUIRED_FIELD", ErrorMessage.ERR_VAL_REQUIRED_FIELD.getMessage()),
                Map.entry("ERR_USER_EMAIL_ALREADY_EXISTS", ErrorMessage.ERR_USER_EMAIL_ALREADY_EXISTS.getMessage()),
                Map.entry("ERR_PAGO_PAYMENT_FAILED", ErrorMessage.ERR_PAGO_PAYMENT_FAILED.getMessage()));

        ApiResponse<Map<String, String>> response = ApiResponse.success(
                messages,
                "Lista de ErrorMessages (ejemplo parcial)");

        return ResponseEntity.ok(response);
    }
}
