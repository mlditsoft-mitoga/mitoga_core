package com.mitoga.shared.infrastructure.api.message;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Tests unitarios para SuccessMessage enum.
 * Valida códigos, mensajes y funcionalidad de formateo.
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
@DisplayName("SuccessMessage - Diccionario de Mensajes de Éxito")
class SuccessMessageTest {

    @Nested
    @DisplayName("Mensajes Genéricos")
    class GenericMessagesTests {

        @Test
        @DisplayName("GEN_CREATED debe tener código y mensaje correcto")
        void genCreatedShouldHaveCorrectCodeAndMessage() {
            // When
            String code = SuccessMessage.GEN_CREATED.getCode();
            String message = SuccessMessage.GEN_CREATED.getMessage();

            // Then
            assertThat(code).isEqualTo("GEN_001");
            assertThat(message).isEqualTo("Recurso creado exitosamente");
        }

        @Test
        @DisplayName("GEN_UPDATED debe tener categoría SUCCESS")
        void genUpdatedShouldHaveSuccessCategory() {
            // When
            MessageCategory category = SuccessMessage.GEN_UPDATED.getCategory();

            // Then
            assertThat(category).isEqualTo(MessageCategory.SUCCESS);
        }
    }

    @Nested
    @DisplayName("Mensajes de Usuarios")
    class UserMessagesTests {

        @Test
        @DisplayName("USER_REGISTERED debe tener código USER_001")
        void userRegisteredShouldHaveCorrectCode() {
            // When
            String code = SuccessMessage.USER_REGISTERED.getCode();

            // Then
            assertThat(code).isEqualTo("USER_001");
        }

        @Test
        @DisplayName("USER_LOGIN_SUCCESS debe tener mensaje de bienvenida")
        void userLoginSuccessShouldHaveWelcomeMessage() {
            // When
            String message = SuccessMessage.USER_LOGIN_SUCCESS.getMessage();

            // Then
            assertThat(message).contains("Inicio de sesión exitoso");
            assertThat(message).contains("Bienvenido");
        }

        @Test
        @DisplayName("USER_PASSWORD_RESET_SUCCESS debe mencionar contraseña")
        void userPasswordResetShouldMentionPassword() {
            // When
            String message = SuccessMessage.USER_PASSWORD_RESET_SUCCESS.getMessage();

            // Then
            assertThat(message).containsIgnoringCase("contraseña");
            assertThat(message).containsIgnoringCase("exitosamente");
        }
    }

    @Nested
    @DisplayName("Mensajes de Tutores")
    class TutorMessagesTests {

        @Test
        @DisplayName("TUTOR_PROFILE_CREATED debe mencionar aprobación pendiente")
        void tutorProfileCreatedShouldMentionPendingApproval() {
            // When
            String message = SuccessMessage.TUTOR_PROFILE_CREATED.getMessage();

            // Then
            assertThat(message).containsIgnoringCase("Pendiente de aprobación");
        }

        @Test
        @DisplayName("TUTOR_PROFILE_APPROVED debe tener código TUTOR_002")
        void tutorProfileApprovedShouldHaveCorrectCode() {
            // When
            String code = SuccessMessage.TUTOR_PROFILE_APPROVED.getCode();

            // Then
            assertThat(code).isEqualTo("TUTOR_002");
        }
    }

    @Nested
    @DisplayName("Mensajes de Reservas")
    class ReservaMessagesTests {

        @Test
        @DisplayName("RESERVA_CREATED debe tener código RESERVA_001")
        void reservaCreatedShouldHaveCorrectCode() {
            // When
            String code = SuccessMessage.RESERVA_CREATED.getCode();

            // Then
            assertThat(code).isEqualTo("RESERVA_001");
        }

        @Test
        @DisplayName("RESERVA_CONFIRMED debe mencionar confirmación")
        void reservaConfirmedShouldMentionConfirmation() {
            // When
            String message = SuccessMessage.RESERVA_CONFIRMED.getMessage();

            // Then
            assertThat(message).containsIgnoringCase("confirmada");
        }
    }

    @Nested
    @DisplayName("Mensajes de Pagos")
    class PagoMessagesTests {

        @Test
        @DisplayName("PAGO_PROCESSED debe tener código PAGO_001")
        void pagoProcessedShouldHaveCorrectCode() {
            // When
            String code = SuccessMessage.PAGO_PROCESSED.getCode();

            // Then
            assertThat(code).isEqualTo("PAGO_001");
        }

        @Test
        @DisplayName("PAGO_REFUNDED debe mencionar tiempo de procesamiento")
        void pagoRefundedShouldMentionProcessingTime() {
            // When
            String message = SuccessMessage.PAGO_REFUNDED.getMessage();

            // Then
            assertThat(message).containsIgnoringCase("días");
        }
    }

    @Nested
    @DisplayName("Funcionalidad de Formateo")
    class FormattingTests {

        @Test
        @DisplayName("format() sin parámetros debe retornar mensaje original")
        void formatWithoutParamsShouldReturnOriginalMessage() {
            // When
            String formatted = SuccessMessage.GEN_CREATED.format();
            String original = SuccessMessage.GEN_CREATED.getMessage();

            // Then
            assertThat(formatted).isEqualTo(original);
        }

        @Test
        @DisplayName("format() debe mantener mensaje cuando no hay placeholders")
        void formatShouldMaintainMessageWhenNoPlaceholders() {
            // When
            String formatted = SuccessMessage.USER_LOGIN_SUCCESS.format("param1", "param2");
            String original = SuccessMessage.USER_LOGIN_SUCCESS.getMessage();

            // Then
            assertThat(formatted).isEqualTo(original);
        }
    }

    @Nested
    @DisplayName("Invariantes del Enum")
    class EnumInvariantsTests {

        @Test
        @DisplayName("Todos los mensajes deben tener código no nulo ni vacío")
        void allMessagesShouldHaveNonEmptyCode() {
            // When/Then
            for (SuccessMessage message : SuccessMessage.values()) {
                assertThat(message.getCode())
                        .as("Code for " + message.name())
                        .isNotNull()
                        .isNotBlank();
            }
        }

        @Test
        @DisplayName("Todos los mensajes deben tener mensaje no nulo ni vacío")
        void allMessagesShouldHaveNonEmptyMessage() {
            // When/Then
            for (SuccessMessage message : SuccessMessage.values()) {
                assertThat(message.getMessage())
                        .as("Message for " + message.name())
                        .isNotNull()
                        .isNotBlank();
            }
        }

        @Test
        @DisplayName("Todos los mensajes deben tener categoría SUCCESS")
        void allMessagesShouldHaveSuccessCategory() {
            // When/Then
            for (SuccessMessage message : SuccessMessage.values()) {
                assertThat(message.getCategory())
                        .as("Category for " + message.name())
                        .isEqualTo(MessageCategory.SUCCESS);
            }
        }

        @Test
        @DisplayName("Códigos deben seguir convención [MODULO]_[NUMERO]")
        void codesShouldFollowNamingConvention() {
            // When/Then
            for (SuccessMessage message : SuccessMessage.values()) {
                assertThat(message.getCode())
                        .as("Code format for " + message.name())
                        .matches("^[A-Z]+_\\d{3}$");
            }
        }

        @Test
        @DisplayName("Debe haber al menos 25 mensajes definidos")
        void shouldHaveAtLeast25Messages() {
            // When
            int count = SuccessMessage.values().length;

            // Then
            assertThat(count).isGreaterThanOrEqualTo(25);
        }
    }
}
