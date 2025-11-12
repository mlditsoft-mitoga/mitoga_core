package com.mitoga.shared.infrastructure.api.response;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Nested;

import static org.assertj.core.api.Assertions.*;

/**
 * Tests unitarios para {@link ValidationError}.
 * Valida la creación correcta de detalles de errores de validación.
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
@DisplayName("ValidationError - Detalle de Error de Validación")
class ValidationErrorTest {

    @Nested
    @DisplayName("Factory Methods")
    class FactoryMethodTests {

        @Test
        @DisplayName("Debe crear ValidationError sin valor rechazado")
        void shouldCreateValidationErrorWithoutRejectedValue() {
            // When
            ValidationError error = ValidationError.of("email", "Email inválido");

            // Then
            assertThat(error.field()).isEqualTo("email");
            assertThat(error.message()).isEqualTo("Email inválido");
            assertThat(error.rejectedValue()).isNull();
        }

        @Test
        @DisplayName("Debe crear ValidationError con valor rechazado")
        void shouldCreateValidationErrorWithRejectedValue() {
            // When
            ValidationError error = ValidationError.of(
                    "email",
                    "Email inválido",
                    "email-invalido");

            // Then
            assertThat(error.field()).isEqualTo("email");
            assertThat(error.message()).isEqualTo("Email inválido");
            assertThat(error.rejectedValue()).isEqualTo("email-invalido");
        }

        @Test
        @DisplayName("Debe crear ValidationError con rejectedValue null explícitamente")
        void shouldCreateValidationErrorWithExplicitNullRejectedValue() {
            // When
            ValidationError error = new ValidationError("field", "message", null);

            // Then
            assertThat(error.rejectedValue()).isNull();
        }
    }

    @Nested
    @DisplayName("Constructor - Validaciones de Invariantes")
    class ConstructorValidationTests {

        @Test
        @DisplayName("Debe lanzar excepción si field es null")
        void shouldThrowExceptionWhenFieldIsNull() {
            // When & Then
            assertThatThrownBy(() -> new ValidationError(null, "mensaje", "value"))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Field no puede ser nulo o vacío");
        }

        @Test
        @DisplayName("Debe lanzar excepción si field está vacío")
        void shouldThrowExceptionWhenFieldIsEmpty() {
            // When & Then
            assertThatThrownBy(() -> new ValidationError("", "mensaje", "value"))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Field no puede ser nulo o vacío");
        }

        @Test
        @DisplayName("Debe lanzar excepción si field es solo espacios en blanco")
        void shouldThrowExceptionWhenFieldIsBlank() {
            // When & Then
            assertThatThrownBy(() -> new ValidationError("   ", "mensaje", "value"))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Field no puede ser nulo o vacío");
        }

        @Test
        @DisplayName("Debe lanzar excepción si message es null")
        void shouldThrowExceptionWhenMessageIsNull() {
            // When & Then
            assertThatThrownBy(() -> new ValidationError("field", null, "value"))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Message no puede ser nulo o vacío");
        }

        @Test
        @DisplayName("Debe lanzar excepción si message está vacío")
        void shouldThrowExceptionWhenMessageIsEmpty() {
            // When & Then
            assertThatThrownBy(() -> new ValidationError("field", "", "value"))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Message no puede ser nulo o vacío");
        }

        @Test
        @DisplayName("Debe lanzar excepción si message es solo espacios en blanco")
        void shouldThrowExceptionWhenMessageIsBlank() {
            // When & Then
            assertThatThrownBy(() -> new ValidationError("field", "   ", "value"))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Message no puede ser nulo o vacío");
        }
    }

    @Nested
    @DisplayName("Edge Cases - Valores Límite")
    class EdgeCaseTests {

        @Test
        @DisplayName("Debe manejar field con caracteres especiales")
        void shouldHandleFieldWithSpecialCharacters() {
            // When
            ValidationError error = ValidationError.of(
                    "usuario.email",
                    "Email inválido");

            // Then
            assertThat(error.field()).isEqualTo("usuario.email");
        }

        @Test
        @DisplayName("Debe manejar message largo")
        void shouldHandleLongMessage() {
            // Given
            String longMessage = "Este es un mensaje de error muy largo que describe " +
                    "en detalle qué salió mal con la validación del campo y proporciona " +
                    "información adicional para ayudar al desarrollador a corregir el problema.";

            // When
            ValidationError error = ValidationError.of("field", longMessage);

            // Then
            assertThat(error.message()).isEqualTo(longMessage);
        }

        @Test
        @DisplayName("Debe manejar rejectedValue de diferentes tipos")
        void shouldHandleRejectedValueOfDifferentTypes() {
            // When - String
            ValidationError error1 = ValidationError.of("field1", "msg", "string-value");
            // When - Integer
            ValidationError error2 = ValidationError.of("field2", "msg", 123);
            // When - Boolean
            ValidationError error3 = ValidationError.of("field3", "msg", true);
            // When - Object
            ValidationError error4 = ValidationError.of("field4", "msg", java.util.Map.of("key", "value"));

            // Then
            assertThat(error1.rejectedValue()).isInstanceOf(String.class);
            assertThat(error2.rejectedValue()).isInstanceOf(Integer.class);
            assertThat(error3.rejectedValue()).isInstanceOf(Boolean.class);
            assertThat(error4.rejectedValue()).isInstanceOf(java.util.Map.class);
        }
    }

    @Nested
    @DisplayName("Record - Características de Inmutabilidad")
    class RecordImmutabilityTests {

        @Test
        @DisplayName("Debe implementar equals correctamente (Record)")
        void shouldImplementEqualsCorrectly() {
            // Given
            ValidationError error1 = ValidationError.of("email", "inválido", "test");
            ValidationError error2 = ValidationError.of("email", "inválido", "test");

            // Then
            assertThat(error1).isEqualTo(error2);
            assertThat(error1.hashCode()).isEqualTo(error2.hashCode());
        }

        @Test
        @DisplayName("Debe implementar toString correctamente (Record)")
        void shouldImplementToStringCorrectly() {
            // Given
            ValidationError error = ValidationError.of("email", "inválido", "test");

            // When
            String toString = error.toString();

            // Then
            assertThat(toString)
                    .contains("field=email")
                    .contains("message=inválido")
                    .contains("rejectedValue=test");
        }
    }
}
