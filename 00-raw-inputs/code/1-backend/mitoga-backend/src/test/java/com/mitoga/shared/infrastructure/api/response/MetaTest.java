package com.mitoga.shared.infrastructure.api.response;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Nested;

import static org.assertj.core.api.Assertions.*;

/**
 * Tests unitarios para {@link Meta}.
 * Valida la creación correcta de metadatos con validaciones de paginación.
 *
 * @author Backend Team
 * @version 1.0
 * @since 2025-11-08
 */
@DisplayName("Meta - Metadatos de Respuesta")
class MetaTest {

    @Nested
    @DisplayName("Factory Methods")
    class FactoryMethodTests {

        @Test
        @DisplayName("Debe crear metadatos de paginación correctamente")
        void shouldCreatePaginationMetadata() {
            // When
            Meta meta = Meta.pagination(0, 10, 45L, 5);

            // Then
            assertThat(meta.page()).isEqualTo(0);
            assertThat(meta.pageSize()).isEqualTo(10);
            assertThat(meta.totalElements()).isEqualTo(45L);
            assertThat(meta.totalPages()).isEqualTo(5);
            assertThat(meta.version()).isEqualTo("v1");
        }

        @Test
        @DisplayName("Debe crear metadatos solo con versión")
        void shouldCreateVersionOnlyMetadata() {
            // When
            Meta meta = Meta.version("v2");

            // Then
            assertThat(meta.page()).isNull();
            assertThat(meta.pageSize()).isNull();
            assertThat(meta.totalElements()).isNull();
            assertThat(meta.totalPages()).isNull();
            assertThat(meta.version()).isEqualTo("v2");
        }
    }

    @Nested
    @DisplayName("Constructor - Validaciones de Invariantes")
    class ValidationTests {

        @Test
        @DisplayName("Debe lanzar excepción si page es negativo")
        void shouldThrowExceptionWhenPageIsNegative() {
            // When & Then
            assertThatThrownBy(() -> new Meta(-1, 10, 100L, 10, "v1"))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Page debe ser >= 0");
        }

        @Test
        @DisplayName("Debe lanzar excepción si pageSize es cero o negativo")
        void shouldThrowExceptionWhenPageSizeIsZeroOrNegative() {
            // When & Then
            assertThatThrownBy(() -> new Meta(0, 0, 100L, 10, "v1"))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("PageSize debe ser > 0");

            assertThatThrownBy(() -> new Meta(0, -1, 100L, 10, "v1"))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("PageSize debe ser > 0");
        }

        @Test
        @DisplayName("Debe lanzar excepción si totalElements es negativo")
        void shouldThrowExceptionWhenTotalElementsIsNegative() {
            // When & Then
            assertThatThrownBy(() -> new Meta(0, 10, -1L, 10, "v1"))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("TotalElements debe ser >= 0");
        }

        @Test
        @DisplayName("Debe lanzar excepción si totalPages es negativo")
        void shouldThrowExceptionWhenTotalPagesIsNegative() {
            // When & Then
            assertThatThrownBy(() -> new Meta(0, 10, 100L, -1, "v1"))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("TotalPages debe ser >= 0");
        }

        @Test
        @DisplayName("Debe permitir valores null en campos opcionales")
        void shouldAllowNullValues() {
            // When
            Meta meta = new Meta(null, null, null, null, null);

            // Then
            assertThat(meta.page()).isNull();
            assertThat(meta.pageSize()).isNull();
            assertThat(meta.totalElements()).isNull();
            assertThat(meta.totalPages()).isNull();
            assertThat(meta.version()).isNull();
        }
    }

    @Nested
    @DisplayName("Edge Cases - Valores Límite")
    class EdgeCaseTests {

        @Test
        @DisplayName("Debe permitir page=0 (primera página)")
        void shouldAllowPageZero() {
            // When
            Meta meta = Meta.pagination(0, 10, 10L, 1);

            // Then
            assertThat(meta.page()).isZero();
        }

        @Test
        @DisplayName("Debe permitir totalElements=0 (sin resultados)")
        void shouldAllowZeroTotalElements() {
            // When
            Meta meta = Meta.pagination(0, 10, 0L, 0);

            // Then
            assertThat(meta.totalElements()).isZero();
            assertThat(meta.totalPages()).isZero();
        }

        @Test
        @DisplayName("Debe manejar paginación con 1 solo elemento")
        void shouldHandleSingleElement() {
            // When
            Meta meta = Meta.pagination(0, 10, 1L, 1);

            // Then
            assertThat(meta.totalElements()).isEqualTo(1L);
            assertThat(meta.totalPages()).isEqualTo(1);
        }

        @Test
        @DisplayName("Debe manejar paginación grande")
        void shouldHandleLargePagination() {
            // When
            Meta meta = Meta.pagination(999, 100, 100000L, 1000);

            // Then
            assertThat(meta.page()).isEqualTo(999);
            assertThat(meta.totalElements()).isEqualTo(100000L);
            assertThat(meta.totalPages()).isEqualTo(1000);
        }
    }
}
