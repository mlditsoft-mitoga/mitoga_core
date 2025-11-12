package com.mitoga.shared.infrastructure.api.message;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Tests unitarios para MessageResolver.
 * Valida resolución de mensajes con y sin parámetros.
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
@DisplayName("MessageResolver - Resolutor de Mensajes")
class MessageResolverTest {

    private MessageResolver messageResolver;

    @BeforeEach
    void setUp() {
        messageResolver = new MessageResolver();
    }

    @Nested
    @DisplayName("Mensajes de Éxito")
    class SuccessMessageTests {

        @Test
        @DisplayName("Debe resolver mensaje de éxito sin parámetros")
        void shouldResolveSuccessMessageWithoutParams() {
            // When
            String message = messageResolver.resolve(SuccessMessage.USER_LOGIN_SUCCESS);

            // Then
            assertThat(message).isEqualTo("Inicio de sesión exitoso. Bienvenido");
        }

        @Test
        @DisplayName("Debe resolver mensaje de éxito con parámetros vacíos")
        void shouldResolveSuccessMessageWithEmptyParams() {
            // When
            String message = messageResolver.resolve(SuccessMessage.GEN_CREATED);

            // Then
            assertThat(message).isEqualTo("Recurso creado exitosamente");
        }

        @Test
        @DisplayName("Debe obtener código de mensaje de éxito")
        void shouldGetSuccessMessageCode() {
            // When
            String code = messageResolver.getCode(SuccessMessage.USER_REGISTERED);

            // Then
            assertThat(code).isEqualTo("USER_001");
        }

        @Test
        @DisplayName("Debe manejar múltiples mensajes diferentes")
        void shouldHandleMultipleDifferentMessages() {
            // When
            String message1 = messageResolver.resolve(SuccessMessage.RESERVA_CREATED);
            String message2 = messageResolver.resolve(SuccessMessage.PAGO_PROCESSED);

            // Then
            assertThat(message1).contains("Reserva creada");
            assertThat(message2).contains("Pago procesado");
        }
    }

    @Nested
    @DisplayName("Mensajes de Error")
    class ErrorMessageTests {

        @Test
        @DisplayName("Debe resolver mensaje de error sin parámetros")
        void shouldResolveErrorMessageWithoutParams() {
            // When
            String message = messageResolver.resolve(ErrorMessage.ERR_GEN_INTERNAL_SERVER);

            // Then
            assertThat(message).contains("Error interno del servidor");
        }

        @Test
        @DisplayName("Debe resolver mensaje de error con un parámetro")
        void shouldResolveErrorMessageWithOneParam() {
            // When
            String message = messageResolver.resolve(
                    ErrorMessage.ERR_USER_EMAIL_ALREADY_EXISTS,
                    "test@example.com");

            // Then
            assertThat(message).isEqualTo("El email 'test@example.com' ya está registrado");
        }

        @Test
        @DisplayName("Debe resolver mensaje de error con múltiples parámetros")
        void shouldResolveErrorMessageWithMultipleParams() {
            // When
            String message = messageResolver.resolve(
                    ErrorMessage.ERR_GEN_RESOURCE_NOT_FOUND,
                    "Usuario",
                    "12345");

            // Then
            assertThat(message).isEqualTo("Usuario no encontrado con ID: 12345");
        }

        @Test
        @DisplayName("Debe resolver mensaje con parámetro numérico")
        void shouldResolveMessageWithNumericParam() {
            // When
            String message = messageResolver.resolve(
                    ErrorMessage.ERR_VAL_PASSWORD_TOO_SHORT,
                    8);

            // Then
            assertThat(message).contains("8 caracteres");
        }

        @Test
        @DisplayName("Debe obtener código de mensaje de error")
        void shouldGetErrorMessageCode() {
            // When
            String code = messageResolver.getCode(ErrorMessage.ERR_AUTH_INVALID_CREDENTIALS);

            // Then
            assertThat(code).isEqualTo("ERR_AUTH_001");
        }

        @Test
        @DisplayName("Debe obtener severidad de error")
        void shouldGetErrorSeverity() {
            // When
            MessageSeverity severity = messageResolver.getSeverity(
                    ErrorMessage.ERR_GEN_INTERNAL_SERVER);

            // Then
            assertThat(severity).isEqualTo(MessageSeverity.CRITICAL);
        }

        @Test
        @DisplayName("Debe obtener severidad de error de autenticación")
        void shouldGetAuthErrorSeverity() {
            // When
            MessageSeverity severity = messageResolver.getSeverity(
                    ErrorMessage.ERR_AUTH_UNAUTHORIZED);

            // Then
            assertThat(severity).isEqualTo(MessageSeverity.HIGH);
        }

        @Test
        @DisplayName("Debe obtener severidad de error de validación")
        void shouldGetValidationErrorSeverity() {
            // When
            MessageSeverity severity = messageResolver.getSeverity(
                    ErrorMessage.ERR_VAL_INVALID_EMAIL);

            // Then
            assertThat(severity).isEqualTo(MessageSeverity.LOW);
        }
    }

    @Nested
    @DisplayName("Obtención de Código")
    class GetCodeTests {

        @Test
        @DisplayName("Debe obtener código de mensaje de éxito")
        void shouldGetCodeFromSuccessMessage() {
            // When
            String code = messageResolver.getCode(SuccessMessage.TUTOR_PROFILE_APPROVED);

            // Then
            assertThat(code).isEqualTo("TUTOR_002");
        }

        @Test
        @DisplayName("Debe obtener código de mensaje de error")
        void shouldGetCodeFromErrorMessage() {
            // When
            String code = messageResolver.getCode(ErrorMessage.ERR_RESERVA_SLOT_NOT_AVAILABLE);

            // Then
            assertThat(code).isEqualTo("ERR_RESERVA_002");
        }

        @Test
        @DisplayName("Códigos deben ser únicos y no vacíos")
        void codesShouldBeUniqueAndNotEmpty() {
            // When
            String code1 = messageResolver.getCode(SuccessMessage.GEN_CREATED);
            String code2 = messageResolver.getCode(ErrorMessage.ERR_GEN_INTERNAL_SERVER);

            // Then
            assertThat(code1).isNotBlank();
            assertThat(code2).isNotBlank();
            assertThat(code1).isNotEqualTo(code2);
        }
    }

    @Nested
    @DisplayName("Edge Cases")
    class EdgeCasesTests {

        @Test
        @DisplayName("Debe manejar mensaje sin placeholders con parámetros")
        void shouldHandleMessageWithoutPlaceholdersWithParams() {
            // When
            String message = messageResolver.resolve(
                    SuccessMessage.USER_LOGIN_SUCCESS,
                    "param1",
                    "param2");

            // Then
            assertThat(message).isEqualTo("Inicio de sesión exitoso. Bienvenido");
        }

        @Test
        @DisplayName("Debe resolver mensaje con parámetro null")
        void shouldResolveMessageWithNullParam() {
            // When
            String message = messageResolver.resolve(
                    ErrorMessage.ERR_USER_NOT_FOUND,
                    (Object) null);

            // Then
            assertThat(message).contains("null");
        }

        @Test
        @DisplayName("MessageResolver debe ser reutilizable")
        void messageResolverShouldBeReusable() {
            // When
            String message1 = messageResolver.resolve(SuccessMessage.USER_REGISTERED);
            String message2 = messageResolver.resolve(ErrorMessage.ERR_AUTH_INVALID_CREDENTIALS);
            String message3 = messageResolver.resolve(SuccessMessage.PAGO_PROCESSED);

            // Then
            assertThat(message1).contains("registrado");
            assertThat(message2).contains("incorrectos");
            assertThat(message3).contains("procesado");
        }
    }
}
