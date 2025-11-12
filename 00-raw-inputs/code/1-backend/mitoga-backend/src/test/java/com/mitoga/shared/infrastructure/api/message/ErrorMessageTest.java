package com.mitoga.shared.infrastructure.api.message;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Tests unitarios para ErrorMessage enum.
 * Valida códigos, mensajes, severidad y funcionalidad de formateo.
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
@DisplayName("ErrorMessage - Diccionario de Mensajes de Error")
class ErrorMessageTest {

    @Nested
    @DisplayName("Errores Genéricos")
    class GenericErrorsTests {

        @Test
        @DisplayName("ERR_GEN_INTERNAL_SERVER debe tener severidad CRITICAL")
        void errGenInternalServerShouldHaveCriticalSeverity() {
            // When
            MessageSeverity severity = ErrorMessage.ERR_GEN_INTERNAL_SERVER.getSeverity();

            // Then
            assertThat(severity).isEqualTo(MessageSeverity.CRITICAL);
        }

        @Test
        @DisplayName("ERR_GEN_RESOURCE_NOT_FOUND debe tener código ERR_GEN_002")
        void errGenResourceNotFoundShouldHaveCorrectCode() {
            // When
            String code = ErrorMessage.ERR_GEN_RESOURCE_NOT_FOUND.getCode();

            // Then
            assertThat(code).isEqualTo("ERR_GEN_002");
        }

        @Test
        @DisplayName("ERR_GEN_DATABASE_CONNECTION debe tener severidad CRITICAL")
        void errGenDatabaseConnectionShouldHaveCriticalSeverity() {
            // When
            MessageSeverity severity = ErrorMessage.ERR_GEN_DATABASE_CONNECTION.getSeverity();

            // Then
            assertThat(severity).isEqualTo(MessageSeverity.CRITICAL);
        }
    }

    @Nested
    @DisplayName("Errores de Autenticación")
    class AuthErrorsTests {

        @Test
        @DisplayName("ERR_AUTH_INVALID_CREDENTIALS debe tener código ERR_AUTH_001")
        void errAuthInvalidCredentialsShouldHaveCorrectCode() {
            // When
            String code = ErrorMessage.ERR_AUTH_INVALID_CREDENTIALS.getCode();

            // Then
            assertThat(code).isEqualTo("ERR_AUTH_001");
        }

        @Test
        @DisplayName("ERR_AUTH_TOKEN_EXPIRED debe mencionar sesión expirada")
        void errAuthTokenExpiredShouldMentionExpiredSession() {
            // When
            String message = ErrorMessage.ERR_AUTH_TOKEN_EXPIRED.getMessage();

            // Then
            assertThat(message).containsIgnoringCase("sesión");
            assertThat(message).containsIgnoringCase("expirado");
        }

        @Test
        @DisplayName("ERR_AUTH_UNAUTHORIZED debe tener severidad HIGH")
        void errAuthUnauthorizedShouldHaveHighSeverity() {
            // When
            MessageSeverity severity = ErrorMessage.ERR_AUTH_UNAUTHORIZED.getSeverity();

            // Then
            assertThat(severity).isEqualTo(MessageSeverity.HIGH);
        }

        @Test
        @DisplayName("ERR_AUTH_ACCOUNT_DISABLED debe tener severidad HIGH")
        void errAuthAccountDisabledShouldHaveHighSeverity() {
            // When
            MessageSeverity severity = ErrorMessage.ERR_AUTH_ACCOUNT_DISABLED.getSeverity();

            // Then
            assertThat(severity).isEqualTo(MessageSeverity.HIGH);
        }
    }

    @Nested
    @DisplayName("Errores de Validación")
    class ValidationErrorsTests {

        @Test
        @DisplayName("ERR_VAL_REQUIRED_FIELD debe tener código ERR_VAL_001")
        void errValRequiredFieldShouldHaveCorrectCode() {
            // When
            String code = ErrorMessage.ERR_VAL_REQUIRED_FIELD.getCode();

            // Then
            assertThat(code).isEqualTo("ERR_VAL_001");
        }

        @Test
        @DisplayName("ERR_VAL_INVALID_EMAIL debe tener severidad LOW")
        void errValInvalidEmailShouldHaveLowSeverity() {
            // When
            MessageSeverity severity = ErrorMessage.ERR_VAL_INVALID_EMAIL.getSeverity();

            // Then
            assertThat(severity).isEqualTo(MessageSeverity.LOW);
        }

        @Test
        @DisplayName("ERR_VAL_PASSWORD_WEAK debe mencionar requisitos de contraseña")
        void errValPasswordWeakShouldMentionPasswordRequirements() {
            // When
            String message = ErrorMessage.ERR_VAL_PASSWORD_WEAK.getMessage();

            // Then
            assertThat(message).containsIgnoringCase("contraseña");
            assertThat(message).containsIgnoringCase("mayúsculas");
        }
    }

    @Nested
    @DisplayName("Errores de Usuarios")
    class UserErrorsTests {

        @Test
        @DisplayName("ERR_USER_EMAIL_ALREADY_EXISTS debe tener código ERR_USER_001")
        void errUserEmailAlreadyExistsShouldHaveCorrectCode() {
            // When
            String code = ErrorMessage.ERR_USER_EMAIL_ALREADY_EXISTS.getCode();

            // Then
            assertThat(code).isEqualTo("ERR_USER_001");
        }

        @Test
        @DisplayName("ERR_USER_NOT_FOUND debe tener código ERR_USER_002")
        void errUserNotFoundShouldHaveCorrectCode() {
            // When
            String code = ErrorMessage.ERR_USER_NOT_FOUND.getCode();

            // Then
            assertThat(code).isEqualTo("ERR_USER_002");
        }

        @Test
        @DisplayName("ERR_USER_EMAIL_ALREADY_EXISTS debe tener severidad MEDIUM")
        void errUserEmailAlreadyExistsShouldHaveMediumSeverity() {
            // When
            MessageSeverity severity = ErrorMessage.ERR_USER_EMAIL_ALREADY_EXISTS.getSeverity();

            // Then
            assertThat(severity).isEqualTo(MessageSeverity.MEDIUM);
        }
    }

    @Nested
    @DisplayName("Errores de Tutores")
    class TutorErrorsTests {

        @Test
        @DisplayName("ERR_TUTOR_NOT_FOUND debe tener código ERR_TUTOR_001")
        void errTutorNotFoundShouldHaveCorrectCode() {
            // When
            String code = ErrorMessage.ERR_TUTOR_NOT_FOUND.getCode();

            // Then
            assertThat(code).isEqualTo("ERR_TUTOR_001");
        }

        @Test
        @DisplayName("ERR_TUTOR_NOT_APPROVED debe mencionar aprobación")
        void errTutorNotApprovedShouldMentionApproval() {
            // When
            String message = ErrorMessage.ERR_TUTOR_NOT_APPROVED.getMessage();

            // Then
            assertThat(message).containsIgnoringCase("aprobado");
        }
    }

    @Nested
    @DisplayName("Errores de Reservas")
    class ReservaErrorsTests {

        @Test
        @DisplayName("ERR_RESERVA_NOT_FOUND debe tener código ERR_RESERVA_001")
        void errReservaNotFoundShouldHaveCorrectCode() {
            // When
            String code = ErrorMessage.ERR_RESERVA_NOT_FOUND.getCode();

            // Then
            assertThat(code).isEqualTo("ERR_RESERVA_001");
        }

        @Test
        @DisplayName("ERR_RESERVA_SLOT_NOT_AVAILABLE debe tener severidad MEDIUM")
        void errReservaSlotNotAvailableShouldHaveMediumSeverity() {
            // When
            MessageSeverity severity = ErrorMessage.ERR_RESERVA_SLOT_NOT_AVAILABLE.getSeverity();

            // Then
            assertThat(severity).isEqualTo(MessageSeverity.MEDIUM);
        }
    }

    @Nested
    @DisplayName("Errores de Pagos")
    class PagoErrorsTests {

        @Test
        @DisplayName("ERR_PAGO_PAYMENT_FAILED debe tener código ERR_PAGO_001")
        void errPagoPaymentFailedShouldHaveCorrectCode() {
            // When
            String code = ErrorMessage.ERR_PAGO_PAYMENT_FAILED.getCode();

            // Then
            assertThat(code).isEqualTo("ERR_PAGO_001");
        }

        @Test
        @DisplayName("ERR_PAGO_PAYMENT_FAILED debe tener severidad HIGH")
        void errPagoPaymentFailedShouldHaveHighSeverity() {
            // When
            MessageSeverity severity = ErrorMessage.ERR_PAGO_PAYMENT_FAILED.getSeverity();

            // Then
            assertThat(severity).isEqualTo(MessageSeverity.HIGH);
        }

        @Test
        @DisplayName("ERR_PAGO_INSUFFICIENT_FUNDS debe mencionar fondos")
        void errPagoInsufficientFundsShouldMentionFunds() {
            // When
            String message = ErrorMessage.ERR_PAGO_INSUFFICIENT_FUNDS.getMessage();

            // Then
            assertThat(message).containsIgnoringCase("fondos");
        }
    }

    @Nested
    @DisplayName("Funcionalidad de Formateo")
    class FormattingTests {

        @Test
        @DisplayName("format() sin parámetros debe retornar mensaje original")
        void formatWithoutParamsShouldReturnOriginalMessage() {
            // When
            String formatted = ErrorMessage.ERR_GEN_INTERNAL_SERVER.format();
            String original = ErrorMessage.ERR_GEN_INTERNAL_SERVER.getMessage();

            // Then
            assertThat(formatted).isEqualTo(original);
        }

        @Test
        @DisplayName("format() con parámetros debe interpolar valores")
        void formatWithParamsShouldInterpolateValues() {
            // When
            String formatted = ErrorMessage.ERR_GEN_RESOURCE_NOT_FOUND.format("Usuario", "123");

            // Then
            assertThat(formatted).contains("Usuario");
            assertThat(formatted).contains("123");
        }

        @Test
        @DisplayName("format() debe interpolar email correctamente")
        void formatShouldInterpolateEmailCorrectly() {
            // When
            String formatted = ErrorMessage.ERR_USER_EMAIL_ALREADY_EXISTS.format("test@example.com");

            // Then
            assertThat(formatted).contains("test@example.com");
            assertThat(formatted).containsIgnoringCase("registrado");
        }

        @Test
        @DisplayName("format() debe interpolar múltiples parámetros")
        void formatShouldInterpolateMultipleParams() {
            // When
            String formatted = ErrorMessage.ERR_VAL_PASSWORD_TOO_SHORT.format(8);

            // Then
            assertThat(formatted).contains("8");
        }
    }

    @Nested
    @DisplayName("Invariantes del Enum")
    class EnumInvariantsTests {

        @Test
        @DisplayName("Todos los errores deben tener código no nulo ni vacío")
        void allErrorsShouldHaveNonEmptyCode() {
            // When/Then
            for (ErrorMessage error : ErrorMessage.values()) {
                assertThat(error.getCode())
                        .as("Code for " + error.name())
                        .isNotNull()
                        .isNotBlank();
            }
        }

        @Test
        @DisplayName("Todos los errores deben tener mensaje no nulo ni vacío")
        void allErrorsShouldHaveNonEmptyMessage() {
            // When/Then
            for (ErrorMessage error : ErrorMessage.values()) {
                assertThat(error.getMessage())
                        .as("Message for " + error.name())
                        .isNotNull()
                        .isNotBlank();
            }
        }

        @Test
        @DisplayName("Todos los errores deben tener categoría ERROR")
        void allErrorsShouldHaveErrorCategory() {
            // When/Then
            for (ErrorMessage error : ErrorMessage.values()) {
                assertThat(error.getCategory())
                        .as("Category for " + error.name())
                        .isEqualTo(MessageCategory.ERROR);
            }
        }

        @Test
        @DisplayName("Todos los errores deben tener severidad definida")
        void allErrorsShouldHaveDefinedSeverity() {
            // When/Then
            for (ErrorMessage error : ErrorMessage.values()) {
                assertThat(error.getSeverity())
                        .as("Severity for " + error.name())
                        .isNotNull()
                        .isIn(MessageSeverity.values());
            }
        }

        @Test
        @DisplayName("Códigos deben seguir convención ERR_[MODULO]_[NUMERO]")
        void codesShouldFollowNamingConvention() {
            // When/Then
            for (ErrorMessage error : ErrorMessage.values()) {
                assertThat(error.getCode())
                        .as("Code format for " + error.name())
                        .matches("^ERR_[A-Z]+_\\d{3}$");
            }
        }

        @Test
        @DisplayName("Debe haber al menos 30 errores definidos")
        void shouldHaveAtLeast30Errors() {
            // When
            int count = ErrorMessage.values().length;

            // Then
            assertThat(count).isGreaterThanOrEqualTo(30);
        }

        @Test
        @DisplayName("Errores críticos deben ser de sistema o BD")
        void criticalErrorsShouldBeSystemOrDatabase() {
            // When/Then
            for (ErrorMessage error : ErrorMessage.values()) {
                if (error.getSeverity() == MessageSeverity.CRITICAL) {
                    String message = error.getMessage().toLowerCase();
                    assertThat(message)
                            .as("Critical error message for " + error.name())
                            .matches(".*\\b(servidor|sistema|base de datos|conexión)\\b.*");
                }
            }
        }
    }
}
