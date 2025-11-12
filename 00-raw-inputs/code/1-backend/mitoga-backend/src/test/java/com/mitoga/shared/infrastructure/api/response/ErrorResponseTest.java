package com.mitoga.shared.infrastructure.api.response;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Nested;

import java.util.List;

import static org.assertj.core.api.Assertions.*;

/**
 * Tests unitarios para {@link ErrorResponse}.
 * Valida la creación correcta de respuestas de error con diferentes códigos
 * HTTP.
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
@DisplayName("ErrorResponse - Respuesta de Error Estándar")
class ErrorResponseTest {

    @Nested
    @DisplayName("Factory Methods - Errores del Cliente (4xx)")
    class ClientErrorFactoryMethodTests {

        @Test
        @DisplayName("Debe crear error 400 Bad Request con detalles de validación")
        void shouldCreateValidationError() {
            // Given
            List<ValidationError> details = List.of(
                    ValidationError.of("email", "Email inválido", "test"),
                    ValidationError.of("password", "Contraseña muy corta", "123"));

            // When
            ErrorResponse response = ErrorResponse.validationError(
                    "Errores de validación",
                    "/api/v1/usuarios/registro",
                    details);

            // Then
            assertThat(response.status()).isEqualTo("fail");
            assertThat(response.error()).isEqualTo("ValidationException");
            assertThat(response.code()).isEqualTo(400);
            assertThat(response.path()).isEqualTo("/api/v1/usuarios/registro");
            assertThat(response.details()).hasSize(2);
            assertThat(response.timestamp()).isPositive();
        }

        @Test
        @DisplayName("Debe crear error 404 Not Found")
        void shouldCreateNotFoundError() {
            // When
            ErrorResponse response = ErrorResponse.notFound(
                    "Usuario",
                    "uuid-123",
                    "/api/v1/usuarios/uuid-123");

            // Then
            assertThat(response.status()).isEqualTo("fail");
            assertThat(response.message()).isEqualTo("Usuario no encontrado con ID: uuid-123");
            assertThat(response.error()).isEqualTo("ResourceNotFoundException");
            assertThat(response.code()).isEqualTo(404);
            assertThat(response.details()).isNull();
        }

        @Test
        @DisplayName("Debe crear error 409 Conflict")
        void shouldCreateConflictError() {
            // When
            ErrorResponse response = ErrorResponse.conflict(
                    "El email ya está registrado",
                    "/api/v1/usuarios/registro");

            // Then
            assertThat(response.status()).isEqualTo("fail");
            assertThat(response.error()).isEqualTo("ConflictException");
            assertThat(response.code()).isEqualTo(409);
            assertThat(response.message()).contains("email ya está registrado");
        }

        @Test
        @DisplayName("Debe crear error 401 Unauthorized")
        void shouldCreateUnauthorizedError() {
            // When
            ErrorResponse response = ErrorResponse.unauthorized(
                    "Token JWT inválido",
                    "/api/v1/perfil");

            // Then
            assertThat(response.status()).isEqualTo("fail");
            assertThat(response.error()).isEqualTo("UnauthorizedException");
            assertThat(response.code()).isEqualTo(401);
        }

        @Test
        @DisplayName("Debe crear error 403 Forbidden")
        void shouldCreateForbiddenError() {
            // When
            ErrorResponse response = ErrorResponse.forbidden(
                    "Sin permisos",
                    "/api/v1/admin/usuarios");

            // Then
            assertThat(response.status()).isEqualTo("fail");
            assertThat(response.error()).isEqualTo("ForbiddenException");
            assertThat(response.code()).isEqualTo(403);
        }

        @Test
        @DisplayName("Debe crear error genérico del cliente (4xx)")
        void shouldCreateGenericClientError() {
            // When
            ErrorResponse response = ErrorResponse.clientError(
                    "Solicitud inválida",
                    "BadRequestException",
                    400,
                    "/api/v1/test");

            // Then
            assertThat(response.status()).isEqualTo("fail");
            assertThat(response.error()).isEqualTo("BadRequestException");
            assertThat(response.code()).isEqualTo(400);
        }
    }

    @Nested
    @DisplayName("Factory Methods - Errores del Servidor (5xx)")
    class ServerErrorFactoryMethodTests {

        @Test
        @DisplayName("Debe crear error 500 Internal Server Error")
        void shouldCreateInternalServerError() {
            // When
            ErrorResponse response = ErrorResponse.serverError(
                    "Error interno del servidor",
                    "InternalServerError",
                    500,
                    "/api/v1/usuarios");

            // Then
            assertThat(response.status()).isEqualTo("error");
            assertThat(response.error()).isEqualTo("InternalServerError");
            assertThat(response.code()).isEqualTo(500);
            assertThat(response.message()).contains("Error interno");
        }

        @Test
        @DisplayName("Debe crear error 503 Service Unavailable")
        void shouldCreateServiceUnavailableError() {
            // When
            ErrorResponse response = ErrorResponse.serverError(
                    "Servicio no disponible",
                    "ServiceUnavailableException",
                    503,
                    "/api/v1/health");

            // Then
            assertThat(response.status()).isEqualTo("error");
            assertThat(response.code()).isEqualTo(503);
        }
    }

    @Nested
    @DisplayName("Constructor - Validaciones de Invariantes")
    class ConstructorValidationTests {

        @Test
        @DisplayName("Debe lanzar excepción si status no es 'fail' o 'error'")
        void shouldThrowExceptionWhenStatusIsInvalid() {
            // When & Then
            assertThatThrownBy(() -> new ErrorResponse(
                    "success",
                    "mensaje",
                    "error",
                    400,
                    "/path",
                    System.currentTimeMillis(),
                    null))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Status debe ser 'fail' o 'error'");
        }

        @Test
        @DisplayName("Debe lanzar excepción si status es null")
        void shouldThrowExceptionWhenStatusIsNull() {
            // When & Then
            assertThatThrownBy(() -> new ErrorResponse(
                    null,
                    "mensaje",
                    "error",
                    400,
                    "/path",
                    System.currentTimeMillis(),
                    null))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Status debe ser 'fail' o 'error'");
        }

        @Test
        @DisplayName("Debe lanzar excepción si code < 400")
        void shouldThrowExceptionWhenCodeIsLessThan400() {
            // When & Then
            assertThatThrownBy(() -> new ErrorResponse(
                    "fail",
                    "mensaje",
                    "error",
                    399,
                    "/path",
                    System.currentTimeMillis(),
                    null))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Code debe estar entre 400 y 599");
        }

        @Test
        @DisplayName("Debe lanzar excepción si code >= 600")
        void shouldThrowExceptionWhenCodeIsGreaterThanOrEqual600() {
            // When & Then
            assertThatThrownBy(() -> new ErrorResponse(
                    "error",
                    "mensaje",
                    "error",
                    600,
                    "/path",
                    System.currentTimeMillis(),
                    null))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Code debe estar entre 400 y 599");
        }

        @Test
        @DisplayName("Debe lanzar excepción si timestamp es null o no positivo")
        void shouldThrowExceptionWhenTimestampIsInvalid() {
            // When & Then - null
            assertThatThrownBy(() -> new ErrorResponse(
                    "fail",
                    "mensaje",
                    "error",
                    400,
                    "/path",
                    null,
                    null))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Timestamp debe ser un valor positivo");

            // When & Then - zero
            assertThatThrownBy(() -> new ErrorResponse(
                    "fail",
                    "mensaje",
                    "error",
                    400,
                    "/path",
                    0L,
                    null))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Timestamp debe ser un valor positivo");
        }
    }

    @Nested
    @DisplayName("Edge Cases - Valores Límite")
    class EdgeCaseTests {

        @Test
        @DisplayName("Debe permitir code=400 (límite inferior)")
        void shouldAllowCode400() {
            // When
            ErrorResponse response = ErrorResponse.clientError(
                    "Bad request",
                    "BadRequestException",
                    400,
                    "/path");

            // Then
            assertThat(response.code()).isEqualTo(400);
        }

        @Test
        @DisplayName("Debe permitir code=599 (límite superior)")
        void shouldAllowCode599() {
            // When
            ErrorResponse response = ErrorResponse.serverError(
                    "Network error",
                    "NetworkException",
                    599,
                    "/path");

            // Then
            assertThat(response.code()).isEqualTo(599);
        }

        @Test
        @DisplayName("Debe permitir details null")
        void shouldAllowNullDetails() {
            // When
            ErrorResponse response = ErrorResponse.clientError(
                    "Error sin detalles",
                    "GenericException",
                    400,
                    "/path");

            // Then
            assertThat(response.details()).isNull();
        }

        @Test
        @DisplayName("Debe permitir details vacío")
        void shouldAllowEmptyDetails() {
            // When
            ErrorResponse response = ErrorResponse.validationError(
                    "Error",
                    "/path",
                    List.of());

            // Then
            assertThat(response.details()).isEmpty();
        }
    }

    @Nested
    @DisplayName("Consistencia de Status según Código HTTP")
    class StatusConsistencyTests {

        @Test
        @DisplayName("clientError() debe generar status='fail' para códigos 4xx")
        void clientErrorShouldGenerateFailStatus() {
            // When
            ErrorResponse response = ErrorResponse.clientError(
                    "Client error",
                    "Exception",
                    404,
                    "/path");

            // Then
            assertThat(response.status()).isEqualTo("fail");
        }

        @Test
        @DisplayName("serverError() debe generar status='error' para códigos 5xx")
        void serverErrorShouldGenerateErrorStatus() {
            // When
            ErrorResponse response = ErrorResponse.serverError(
                    "Server error",
                    "Exception",
                    500,
                    "/path");

            // Then
            assertThat(response.status()).isEqualTo("error");
        }
    }
}
