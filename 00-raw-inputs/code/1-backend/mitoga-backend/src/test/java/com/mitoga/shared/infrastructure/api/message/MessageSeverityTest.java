package com.mitoga.shared.infrastructure.api.message;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Tests unitarios para MessageSeverity enum.
 * Valida niveles de severidad y sus display names.
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
@DisplayName("MessageSeverity - Niveles de Severidad")
class MessageSeverityTest {

    @Test
    @DisplayName("Debe tener todos los niveles de severidad definidos")
    void shouldHaveAllSeverityLevelsDefined() {
        // When
        MessageSeverity[] severities = MessageSeverity.values();

        // Then
        assertThat(severities).hasSize(4);
        assertThat(severities).containsExactlyInAnyOrder(
                MessageSeverity.LOW,
                MessageSeverity.MEDIUM,
                MessageSeverity.HIGH,
                MessageSeverity.CRITICAL);
    }

    @Test
    @DisplayName("LOW debe tener display name correcto")
    void lowShouldHaveCorrectDisplayName() {
        // When
        String displayName = MessageSeverity.LOW.getDisplayName();

        // Then
        assertThat(displayName).isEqualTo("Baja");
    }

    @Test
    @DisplayName("MEDIUM debe tener display name correcto")
    void mediumShouldHaveCorrectDisplayName() {
        // When
        String displayName = MessageSeverity.MEDIUM.getDisplayName();

        // Then
        assertThat(displayName).isEqualTo("Media");
    }

    @Test
    @DisplayName("HIGH debe tener display name correcto")
    void highShouldHaveCorrectDisplayName() {
        // When
        String displayName = MessageSeverity.HIGH.getDisplayName();

        // Then
        assertThat(displayName).isEqualTo("Alta");
    }

    @Test
    @DisplayName("CRITICAL debe tener display name correcto")
    void criticalShouldHaveCorrectDisplayName() {
        // When
        String displayName = MessageSeverity.CRITICAL.getDisplayName();

        // Then
        assertThat(displayName).isEqualTo("Crítica");
    }

    @Test
    @DisplayName("valueOf debe recuperar severidad por nombre")
    void valueOfShouldRetrieveSeverityByName() {
        // When
        MessageSeverity severity = MessageSeverity.valueOf("CRITICAL");

        // Then
        assertThat(severity).isEqualTo(MessageSeverity.CRITICAL);
        assertThat(severity.getDisplayName()).isEqualTo("Crítica");
    }

    @Test
    @DisplayName("Severidades deben estar ordenadas por criticidad")
    void severitiesShouldBeOrderedByCriticality() {
        // When
        MessageSeverity[] severities = MessageSeverity.values();

        // Then
        assertThat(severities[0]).isEqualTo(MessageSeverity.LOW);
        assertThat(severities[1]).isEqualTo(MessageSeverity.MEDIUM);
        assertThat(severities[2]).isEqualTo(MessageSeverity.HIGH);
        assertThat(severities[3]).isEqualTo(MessageSeverity.CRITICAL);
    }

    @Test
    @DisplayName("Enum debe ser serializable")
    void enumShouldBeSerializable() {
        // Given
        MessageSeverity severity = MessageSeverity.HIGH;

        // Then
        assertThat(severity.name()).isEqualTo("HIGH");
        assertThat(severity.ordinal()).isEqualTo(2);
    }
}
