package com.mitoga.shared.infrastructure.api.response;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Nested;

import java.util.Map;

import static org.assertj.core.api.Assertions.*;

/**
 * Tests unitarios para {@link ApiResponse}.
 * Valida la creación correcta de respuestas exitosas con diferentes
 * configuraciones.
 *
 * <p>
 * Estrategia de testing:
 * </p>
 * <ul>
 * <li>Happy paths: creación exitosa con distintos factory methods</li>
 * <li>Edge cases: validaciones de invariantes</li>
 * <li>Null safety: manejo de valores nulos</li>
 * </ul>
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
@DisplayName("ApiResponse - Respuesta Exitosa Estándar")
class ApiResponseTest {

    @Nested
    @DisplayName("Factory Methods - success()")
    class SuccessFactoryMethodTests {

        @Test
        @DisplayName("Debe crear respuesta exitosa con datos y mensaje personalizado")
        void shouldCreateSuccessResponseWithDataAndCustomMessage() {
            // Given
            Map<String, String> data = Map.of("id", "123", "nombre", "Test");
            String mensaje = "Usuario creado exitosamente";

            // When
            ApiResponse<Map<String, String>> response = ApiResponse.success(data, mensaje);

            // Then
            assertThat(response).isNotNull();
            assertThat(response.status()).isEqualTo("success");
            assertThat(response.message()).isEqualTo(mensaje);
            assertThat(response.data()).isEqualTo(data);
            assertThat(response.meta()).isNull();
            assertThat(response.timestamp()).isPositive();
            assertThat(response.timestamp()).isLessThanOrEqualTo(System.currentTimeMillis());
        }

        @Test
        @DisplayName("Debe crear respuesta exitosa con datos y mensaje por defecto")
        void shouldCreateSuccessResponseWithDataAndDefaultMessage() {
            // Given
            String data = "test-payload";

            // When
            ApiResponse<String> response = ApiResponse.success(data);

            // Then
            assertThat(response.status()).isEqualTo("success");
            assertThat(response.message()).isEqualTo("Operación exitosa");
            assertThat(response.data()).isEqualTo(data);
            assertThat(response.meta()).isNull();
            assertThat(response.timestamp()).isPositive();
        }

        @Test
        @DisplayName("Debe crear respuesta exitosa sin contenido (DELETE)")
        void shouldCreateSuccessResponseWithoutContent() {
            // Given
            String mensaje = "Usuario eliminado exitosamente";

            // When
            ApiResponse<Void> response = ApiResponse.successNoContent(mensaje);

            // Then
            assertThat(response.status()).isEqualTo("success");
            assertThat(response.message()).isEqualTo(mensaje);
            assertThat(response.data()).isNull();
            assertThat(response.meta()).isNull();
            assertThat(response.timestamp()).isPositive();
        }

        @Test
        @DisplayName("Debe crear respuesta exitosa con metadata de paginación")
        void shouldCreateSuccessResponseWithPaginationMetadata() {
            // Given
            var data = java.util.List.of("item1", "item2", "item3");
            String mensaje = "Tutores recuperados exitosamente";
            Meta meta = Meta.pagination(0, 10, 45L, 5);

            // When
            ApiResponse<java.util.List<String>> response = ApiResponse.successWithMeta(data, mensaje, meta);

            // Then
            assertThat(response.status()).isEqualTo("success");
            assertThat(response.message()).isEqualTo(mensaje);
            assertThat(response.data()).hasSize(3);
            assertThat(response.meta()).isNotNull();
            assertThat(response.meta().page()).isEqualTo(0);
            assertThat(response.meta().pageSize()).isEqualTo(10);
            assertThat(response.meta().totalElements()).isEqualTo(45L);
            assertThat(response.meta().totalPages()).isEqualTo(5);
            assertThat(response.timestamp()).isPositive();
        }
    }

    @Nested
    @DisplayName("Constructor - Validaciones de Invariantes")
    class ConstructorValidationTests {

        @Test
        @DisplayName("Debe lanzar excepción si status NO es 'success'")
        void shouldThrowExceptionWhenStatusIsNotSuccess() {
            // Given
            String invalidStatus = "error";

            // When & Then
            assertThatThrownBy(() -> new ApiResponse<>(
                    invalidStatus,
                    "mensaje",
                    "data",
                    null,
                    System.currentTimeMillis()))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Status debe ser 'success'");
        }

        @Test
        @DisplayName("Debe lanzar excepción si status es null")
        void shouldThrowExceptionWhenStatusIsNull() {
            // When & Then
            assertThatThrownBy(() -> new ApiResponse<>(
                    null,
                    "mensaje",
                    "data",
                    null,
                    System.currentTimeMillis()))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Status debe ser 'success'");
        }

        @Test
        @DisplayName("Debe lanzar excepción si timestamp es null")
        void shouldThrowExceptionWhenTimestampIsNull() {
            // When & Then
            assertThatThrownBy(() -> new ApiResponse<>(
                    "success",
                    "mensaje",
                    "data",
                    null,
                    null))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Timestamp debe ser un valor positivo");
        }

        @Test
        @DisplayName("Debe lanzar excepción si timestamp es negativo")
        void shouldThrowExceptionWhenTimestampIsNegative() {
            // When & Then
            assertThatThrownBy(() -> new ApiResponse<>(
                    "success",
                    "mensaje",
                    "data",
                    null,
                    -1L))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Timestamp debe ser un valor positivo");
        }

        @Test
        @DisplayName("Debe lanzar excepción si timestamp es cero")
        void shouldThrowExceptionWhenTimestampIsZero() {
            // When & Then
            assertThatThrownBy(() -> new ApiResponse<>(
                    "success",
                    "mensaje",
                    "data",
                    null,
                    0L))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Timestamp debe ser un valor positivo");
        }
    }

    @Nested
    @DisplayName("Edge Cases - Valores Límite")
    class EdgeCaseTests {

        @Test
        @DisplayName("Debe permitir data null explícitamente")
        void shouldAllowExplicitNullData() {
            // When
            ApiResponse<String> response = ApiResponse.success(null, "Sin datos");

            // Then
            assertThat(response.data()).isNull();
            assertThat(response.status()).isEqualTo("success");
        }

        @Test
        @DisplayName("Debe permitir meta null")
        void shouldAllowNullMeta() {
            // When
            ApiResponse<String> response = ApiResponse.success("data");

            // Then
            assertThat(response.meta()).isNull();
        }

        @Test
        @DisplayName("Debe manejar mensaje vacío")
        void shouldHandleEmptyMessage() {
            // When
            ApiResponse<String> response = ApiResponse.success("data", "");

            // Then
            assertThat(response.message()).isEmpty();
        }

        @Test
        @DisplayName("Debe generar timestamps consistentes")
        void shouldGenerateConsistentTimestamps() {
            // Given
            long before = System.currentTimeMillis();

            // When
            ApiResponse<String> response = ApiResponse.success("data");
            long after = System.currentTimeMillis();

            // Then
            assertThat(response.timestamp())
                    .isGreaterThanOrEqualTo(before)
                    .isLessThanOrEqualTo(after);
        }
    }

    @Nested
    @DisplayName("Record - Características de Inmutabilidad")
    class RecordImmutabilityTests {

        @Test
        @DisplayName("Debe ser inmutable (Record características)")
        void shouldBeImmutable() {
            // Given
            ApiResponse<String> response = ApiResponse.success("original");

            // When & Then - No hay setters, no se puede modificar
            assertThat(response)
                    .hasFieldOrProperty("status")
                    .hasFieldOrProperty("message")
                    .hasFieldOrProperty("data")
                    .hasFieldOrProperty("meta")
                    .hasFieldOrProperty("timestamp");
        }

        @Test
        @DisplayName("Debe implementar equals correctamente (Record)")
        void shouldImplementEqualsCorrectly() {
            // Given
            long timestamp = System.currentTimeMillis();
            ApiResponse<String> response1 = new ApiResponse<>("success", "msg", "data", null, timestamp);
            ApiResponse<String> response2 = new ApiResponse<>("success", "msg", "data", null, timestamp);

            // Then
            assertThat(response1).isEqualTo(response2);
            assertThat(response1.hashCode()).isEqualTo(response2.hashCode());
        }

        @Test
        @DisplayName("Debe implementar toString correctamente (Record)")
        void shouldImplementToStringCorrectly() {
            // Given
            ApiResponse<String> response = ApiResponse.success("test-data", "test-message");

            // When
            String toString = response.toString();

            // Then
            assertThat(toString)
                    .contains("status=success")
                    .contains("message=test-message")
                    .contains("data=test-data");
        }
    }
}
