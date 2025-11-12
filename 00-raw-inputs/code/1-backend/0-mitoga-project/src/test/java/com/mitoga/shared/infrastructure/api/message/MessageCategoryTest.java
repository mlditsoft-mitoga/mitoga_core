package com.mitoga.shared.infrastructure.api.message;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Tests unitarios para MessageCategory enum.
 * Valida categorías de mensajes y sus display names.
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
@DisplayName("MessageCategory - Categorías de Mensajes")
class MessageCategoryTest {

    @Test
    @DisplayName("Debe tener todas las categorías definidas")
    void shouldHaveAllCategoriesDefined() {
        // When
        MessageCategory[] categories = MessageCategory.values();

        // Then
        assertThat(categories).hasSize(5);
        assertThat(categories).containsExactlyInAnyOrder(
                MessageCategory.SUCCESS,
                MessageCategory.ERROR,
                MessageCategory.VALIDATION,
                MessageCategory.INFO,
                MessageCategory.WARNING);
    }

    @Test
    @DisplayName("SUCCESS debe tener display name correcto")
    void successShouldHaveCorrectDisplayName() {
        // When
        String displayName = MessageCategory.SUCCESS.getDisplayName();

        // Then
        assertThat(displayName).isEqualTo("Éxito");
    }

    @Test
    @DisplayName("ERROR debe tener display name correcto")
    void errorShouldHaveCorrectDisplayName() {
        // When
        String displayName = MessageCategory.ERROR.getDisplayName();

        // Then
        assertThat(displayName).isEqualTo("Error");
    }

    @Test
    @DisplayName("VALIDATION debe tener display name correcto")
    void validationShouldHaveCorrectDisplayName() {
        // When
        String displayName = MessageCategory.VALIDATION.getDisplayName();

        // Then
        assertThat(displayName).isEqualTo("Validación");
    }

    @Test
    @DisplayName("INFO debe tener display name correcto")
    void infoShouldHaveCorrectDisplayName() {
        // When
        String displayName = MessageCategory.INFO.getDisplayName();

        // Then
        assertThat(displayName).isEqualTo("Información");
    }

    @Test
    @DisplayName("WARNING debe tener display name correcto")
    void warningShouldHaveCorrectDisplayName() {
        // When
        String displayName = MessageCategory.WARNING.getDisplayName();

        // Then
        assertThat(displayName).isEqualTo("Advertencia");
    }

    @Test
    @DisplayName("valueOf debe recuperar categoría por nombre")
    void valueOfShouldRetrieveCategoryByName() {
        // When
        MessageCategory category = MessageCategory.valueOf("SUCCESS");

        // Then
        assertThat(category).isEqualTo(MessageCategory.SUCCESS);
        assertThat(category.getDisplayName()).isEqualTo("Éxito");
    }

    @Test
    @DisplayName("Enum debe ser serializable")
    void enumShouldBeSerializable() {
        // Given
        MessageCategory category = MessageCategory.ERROR;

        // Then
        assertThat(category.name()).isEqualTo("ERROR");
        assertThat(category.ordinal()).isGreaterThanOrEqualTo(0);
    }
}
