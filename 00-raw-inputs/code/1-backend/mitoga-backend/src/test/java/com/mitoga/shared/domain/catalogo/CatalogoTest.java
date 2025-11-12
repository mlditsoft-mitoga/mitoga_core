package com.mitoga.shared.domain.catalogo;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.NullAndEmptySource;
import org.junit.jupiter.params.provider.ValueSource;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

import static org.assertj.core.api.Assertions.*;

/**
 * Tests unitarios para el Aggregate Root Catalogo.
 * 
 * Valida:
 * - Factory methods (crearRaiz, crearHijo)
 * - Invariantes de negocio
 * - Métodos de comportamiento (desactivar, activar, actualizar...)
 * - Métodos de consulta (esRaiz, esHoja, estaActivo)
 * - Builder pattern
 * 
 * Objetivo: 100% coverage del dominio
 * 
 * @author Backend Senior Developer
 */
@DisplayName("Catalogo - Aggregate Root Tests")
class CatalogoTest {

    // ========== FACTORY METHODS ==========

    @Nested
    @DisplayName("Factory Method: crearRaiz()")
    class CrearRaizTests {

        @Test
        @DisplayName("Debe crear catálogo raíz con nivel 0 y padreId null")
        void debeCrearCatalogoRaizConNivelCero() {
            // Given
            CatalogoTipo tipo = new CatalogoTipo("categoria_tutoria");
            String codigo = "CAT001";
            String nombre = "Matemáticas";
            Short orden = 1;

            // When
            Catalogo raiz = Catalogo.crearRaiz(tipo, codigo, nombre, orden);

            // Then
            assertThat(raiz).isNotNull();
            assertThat(raiz.getId()).isNotNull();
            assertThat(raiz.getTipo()).isEqualTo(tipo);
            assertThat(raiz.getPadreId()).isNull();
            assertThat(raiz.getNivel()).isEqualTo((short) 0);
            assertThat(raiz.getCodigo()).isEqualTo(codigo);
            assertThat(raiz.getNombre()).isEqualTo(nombre);
            assertThat(raiz.getOrden()).isEqualTo(orden);
            assertThat(raiz.getActivo()).isTrue();
            assertThat(raiz.getSeleccionable()).isTrue();
            assertThat(raiz.getTieneHijos()).isFalse();
            assertThat(raiz.getCreationDate()).isNotNull();
            assertThat(raiz.getExpirationDate()).isNull();
        }

        @Test
        @DisplayName("Debe validar que esRaiz() retorna true")
        void debeValidarQueEsRaiz() {
            // Given
            Catalogo raiz = Catalogo.crearRaiz(
                    new CatalogoTipo("categoria_tutoria"),
                    "CAT001",
                    "Matemáticas",
                    (short) 1);

            // When & Then
            assertThat(raiz.esRaiz()).isTrue();
        }

        @Test
        @DisplayName("Debe lanzar excepción si código es null")
        void debeLanzarExcepcionSiCodigoEsNull() {
            // Given
            CatalogoTipo tipo = new CatalogoTipo("categoria_tutoria");

            // When & Then
            assertThatThrownBy(() -> Catalogo.crearRaiz(tipo, null, "Matemáticas", (short) 1))
                    .isInstanceOf(NullPointerException.class)
                    .hasMessageContaining("Código");
        }

        @Test
        @DisplayName("Debe lanzar excepción si nombre es null")
        void debeLanzarExcepcionSiNombreEsNull() {
            // Given
            CatalogoTipo tipo = new CatalogoTipo("categoria_tutoria");

            // When & Then
            assertThatThrownBy(() -> Catalogo.crearRaiz(tipo, "CAT001", null, (short) 1))
                    .isInstanceOf(NullPointerException.class)
                    .hasMessageContaining("Nombre");
        }
    }

    @Nested
    @DisplayName("Factory Method: crearHijo()")
    class CrearHijoTests {

        @Test
        @DisplayName("Debe crear catálogo hijo con nivel > 0 y padreId not null")
        void debeCrearCatalogoHijoConNivelUno() {
            // Given
            Catalogo padre = Catalogo.crearRaiz(
                    new CatalogoTipo("categoria_tutoria"),
                    "CAT001",
                    "Matemáticas",
                    (short) 1);

            // When
            Catalogo hijo = Catalogo.crearHijo(
                    padre.getTipo(),
                    padre.getId(),
                    "CAT001-ALG",
                    "Álgebra",
                    (short) 1);

            // Then
            assertThat(hijo).isNotNull();
            assertThat(hijo.getId()).isNotNull();
            assertThat(hijo.getTipo()).isEqualTo(padre.getTipo());
            assertThat(hijo.getPadreId()).isEqualTo(padre.getId());
            assertThat(hijo.getNivel()).isEqualTo((short) 1);
            assertThat(hijo.getCodigo()).isEqualTo("CAT001-ALG");
            assertThat(hijo.getNombre()).isEqualTo("Álgebra");
            assertThat(hijo.esRaiz()).isFalse();
        }

        @Test
        @DisplayName("Debe lanzar excepción si padreId es null")
        void debeLanzarExcepcionSiPadreIdEsNull() {
            // Given
            CatalogoTipo tipo = new CatalogoTipo("categoria_tutoria");

            // When & Then
            assertThatThrownBy(() -> Catalogo.crearHijo(tipo, null, "CAT001", "Álgebra", (short) 1))
                    .isInstanceOf(NullPointerException.class)
                    .hasMessageContaining("padreId");
        }

        @Test
        @DisplayName("Debe lanzar excepción si nivel es 0 para un hijo")
        void debeLanzarExcepcionSiNivelEsCeroParaHijo() {
            // Given
            CatalogoId padreId = CatalogoId.generate();
            CatalogoTipo tipo = new CatalogoTipo("categoria_tutoria");

            // When & Then
            // Nota: crearHijo siempre crea con nivel=1, no podemos pasar nivel=0
            // Este test valida que el builder rechace nivel=0 con padreId
            assertThatThrownBy(() -> new Catalogo.Builder()
                    .id(CatalogoId.generate())
                    .creationDate(LocalDateTime.now())
                    .tipo(tipo)
                    .padreId(padreId)
                    .nivel((short) 0) // Inconsistencia: tiene padre pero nivel 0
                    .codigo("CAT001")
                    .nombre("Test")
                    .orden((short) 0)
                    .activo(true)
                    .seleccionable(true)
                    .tieneHijos(false)
                    .build())
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("hijo");
        }
    }

    // ========== INVARIANT VALIDATIONS ==========

    @Nested
    @DisplayName("Validaciones de Invariantes")
    class InvariantesTests {

        @Test
        @DisplayName("Debe lanzar excepción si nivel es negativo")
        void debeLanzarExcepcionSiNivelEsNegativo() {
            // When & Then
            assertThatThrownBy(() -> new Catalogo.Builder()
                    .id(CatalogoId.generate())
                    .creationDate(LocalDateTime.now())
                    .tipo(new CatalogoTipo("test"))
                    .nivel((short) -1)
                    .codigo("TEST")
                    .nombre("Test")
                    .orden((short) 0)
                    .activo(true)
                    .seleccionable(true)
                    .tieneHijos(false)
                    .build())
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("nivel");
        }

        @Test
        @DisplayName("Debe lanzar excepción si nivel >= 100")
        void debeLanzarExcepcionSiNivelMayorOIgualCien() {
            // When & Then
            assertThatThrownBy(() -> new Catalogo.Builder()
                    .id(CatalogoId.generate())
                    .creationDate(LocalDateTime.now())
                    .tipo(new CatalogoTipo("test"))
                    .padreId(CatalogoId.generate())
                    .nivel((short) 100)
                    .codigo("TEST")
                    .nombre("Test")
                    .orden((short) 0)
                    .activo(true)
                    .seleccionable(true)
                    .tieneHijos(false)
                    .build())
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("nivel");
        }

        @Test
        @DisplayName("Debe lanzar excepción si orden es negativo")
        void debeLanzarExcepcionSiOrdenEsNegativo() {
            // When & Then
            assertThatThrownBy(() -> Catalogo.crearRaiz(
                    new CatalogoTipo("test"),
                    "TEST",
                    "Test",
                    (short) -1))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("orden");
        }

        @Test
        @DisplayName("Debe lanzar excepción si orden >= 9999")
        void debeLanzarExcepcionSiOrdenMayorOIgualNoveMilNoveNoveNove() {
            // When & Then
            assertThatThrownBy(() -> Catalogo.crearRaiz(
                    new CatalogoTipo("test"),
                    "TEST",
                    "Test",
                    (short) 9999))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("orden");
        }

        @ParameterizedTest
        @NullAndEmptySource
        @ValueSource(strings = { "   ", "\t", "\n" })
        @DisplayName("Debe lanzar excepción si código está vacío")
        void debeLanzarExcepcionSiCodigoEstaVacio(String codigoInvalido) {
            // When & Then
            assertThatThrownBy(() -> Catalogo.crearRaiz(
                    new CatalogoTipo("test"),
                    codigoInvalido,
                    "Test",
                    (short) 0))
                    .isInstanceOf(IllegalArgumentException.class);
        }

        @Test
        @DisplayName("Debe lanzar excepción si código excede 50 caracteres")
        void debeLanzarExcepcionSiCodigoExcedeCincuentaCaracteres() {
            // Given
            String codigoLargo = "A".repeat(51);

            // When & Then
            assertThatThrownBy(() -> Catalogo.crearRaiz(
                    new CatalogoTipo("test"),
                    codigoLargo,
                    "Test",
                    (short) 0))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("50");
        }

        @Test
        @DisplayName("Debe lanzar excepción si nombre excede 255 caracteres")
        void debeLanzarExcepcionSiNombreExcedeDoscientosCincuentaCincoCaracteres() {
            // Given
            String nombreLargo = "A".repeat(256);

            // When & Then
            assertThatThrownBy(() -> Catalogo.crearRaiz(
                    new CatalogoTipo("test"),
                    "TEST",
                    nombreLargo,
                    (short) 0))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("255");
        }

        @Test
        @DisplayName("Debe lanzar excepción si nodo raíz tiene padreId")
        void debeLanzarExcepcionSiNodoRaizTienePadreId() {
            // When & Then
            assertThatThrownBy(() -> new Catalogo.Builder()
                    .id(CatalogoId.generate())
                    .creationDate(LocalDateTime.now())
                    .tipo(new CatalogoTipo("test"))
                    .padreId(CatalogoId.generate()) // NO DEBE TENER padreId si nivel=0
                    .nivel((short) 0)
                    .codigo("TEST")
                    .nombre("Test")
                    .orden((short) 0)
                    .activo(true)
                    .seleccionable(true)
                    .tieneHijos(false)
                    .build())
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("raíz");
        }

        @Test
        @DisplayName("Debe lanzar excepción si nodo hijo no tiene padreId")
        void debeLanzarExcepcionSiNodoHijoNoTienePadreId() {
            // When & Then
            assertThatThrownBy(() -> new Catalogo.Builder()
                    .id(CatalogoId.generate())
                    .creationDate(LocalDateTime.now())
                    .tipo(new CatalogoTipo("test"))
                    .padreId(null) // DEBE TENER padreId si nivel>0
                    .nivel((short) 1)
                    .codigo("TEST")
                    .nombre("Test")
                    .orden((short) 0)
                    .activo(true)
                    .seleccionable(true)
                    .tieneHijos(false)
                    .build())
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("hijo");
        }

        @Test
        @DisplayName("Debe lanzar excepción si color no cumple patrón hex")
        void debeLanzarExcepcionSiColorNoCumplePatronHex() {
            // When & Then
            assertThatThrownBy(() -> new Catalogo.Builder()
                    .id(CatalogoId.generate())
                    .creationDate(LocalDateTime.now())
                    .tipo(new CatalogoTipo("test"))
                    .nivel((short) 0)
                    .codigo("TEST")
                    .nombre("Test")
                    .orden((short) 0)
                    .color("red") // Debe ser #RRGGBB
                    .activo(true)
                    .seleccionable(true)
                    .tieneHijos(false)
                    .build())
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("color");
        }
    }

    // ========== BUSINESS METHODS ==========

    @Nested
    @DisplayName("Métodos de Negocio")
    class MetodosNegocioTests {

        @Test
        @DisplayName("desactivar() debe marcar catálogo como inactivo y no seleccionable")
        void desactivarDebemarcarCatalogoComoInactivo() {
            // Given
            Catalogo catalogo = Catalogo.crearRaiz(
                    new CatalogoTipo("test"),
                    "TEST",
                    "Test",
                    (short) 0);

            // When
            catalogo.desactivar();

            // Then
            assertThat(catalogo.getActivo()).isFalse();
            assertThat(catalogo.getSeleccionable()).isFalse();
            assertThat(catalogo.getExpirationDate()).isNotNull();
            assertThat(catalogo.estaActivo()).isFalse();
        }

        @Test
        @DisplayName("desactivar() debe lanzar excepción si ya está inactivo")
        void desactivarDebeLanzarExcepcionSiYaEstaInactivo() {
            // Given
            Catalogo catalogo = Catalogo.crearRaiz(
                    new CatalogoTipo("test"),
                    "TEST",
                    "Test",
                    (short) 0);
            catalogo.desactivar();

            // When & Then
            assertThatThrownBy(catalogo::desactivar)
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("inactivo");
        }

        @Test
        @DisplayName("activar() debe marcar catálogo como activo")
        void activarDebeMarcarCatalogoComoActivo() {
            // Given
            Catalogo catalogo = Catalogo.crearRaiz(
                    new CatalogoTipo("test"),
                    "TEST",
                    "Test",
                    (short) 0);
            catalogo.desactivar();

            // When
            catalogo.activar();

            // Then
            assertThat(catalogo.getActivo()).isTrue();
            assertThat(catalogo.getExpirationDate()).isNull();
            assertThat(catalogo.estaActivo()).isTrue();
        }

        @Test
        @DisplayName("actualizarNombre() debe actualizar nombre correctamente")
        void actualizarNombreDebeActualizarNombreCorrectamente() {
            // Given
            Catalogo catalogo = Catalogo.crearRaiz(
                    new CatalogoTipo("test"),
                    "TEST",
                    "Nombre Original",
                    (short) 0);

            // When
            catalogo.actualizarNombre("Nombre Actualizado", "Updated Name");

            // Then
            assertThat(catalogo.getNombre()).isEqualTo("Nombre Actualizado");
            assertThat(catalogo.getNombreEn()).isEqualTo("Updated Name");
        }

        @Test
        @DisplayName("actualizarOrden() debe actualizar orden correctamente")
        void actualizarOrdenDebeActualizarOrdenCorrectamente() {
            // Given
            Catalogo catalogo = Catalogo.crearRaiz(
                    new CatalogoTipo("test"),
                    "TEST",
                    "Test",
                    (short) 1);

            // When
            catalogo.actualizarOrden((short) 5);

            // Then
            assertThat(catalogo.getOrden()).isEqualTo((short) 5);
        }

        @Test
        @DisplayName("marcarComoSeleccionable() debe permitir seleccionar en UI")
        void marcarComoSeleccionableDebePermitirSeleccionarEnUI() {
            // Given
            Catalogo catalogo = Catalogo.crearRaiz(
                    new CatalogoTipo("test"),
                    "TEST",
                    "Test",
                    (short) 0);
            catalogo.marcarComoNoSeleccionable();

            // When
            catalogo.marcarComoSeleccionable();

            // Then
            assertThat(catalogo.getSeleccionable()).isTrue();
        }

        @Test
        @DisplayName("marcarComoSeleccionable() debe lanzar excepción si está inactivo")
        void marcarComoSeleccionableDebeLanzarExcepcionSiEstaInactivo() {
            // Given
            Catalogo catalogo = Catalogo.crearRaiz(
                    new CatalogoTipo("test"),
                    "TEST",
                    "Test",
                    (short) 0);
            catalogo.desactivar();

            // When & Then
            assertThatThrownBy(catalogo::marcarComoSeleccionable)
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("inactivo");
        }

        @Test
        @DisplayName("actualizarMetadatos() debe reemplazar metadatos")
        void actualizarMetadatosDebeReemplazarMetadatos() {
            // Given
            Catalogo catalogo = Catalogo.crearRaiz(
                    new CatalogoTipo("test"),
                    "TEST",
                    "Test",
                    (short) 0);
            Map<String, Object> nuevosMetadatos = new HashMap<>();
            nuevosMetadatos.put("key1", "value1");
            nuevosMetadatos.put("key2", 123);

            // When
            catalogo.actualizarMetadatos(nuevosMetadatos);

            // Then
            assertThat(catalogo.getMetadatos()).containsEntry("key1", "value1");
            assertThat(catalogo.getMetadatos()).containsEntry("key2", 123);
        }
    }

    // ========== QUERY METHODS ==========

    @Nested
    @DisplayName("Métodos de Consulta")
    class MetodosConsultaTests {

        @Test
        @DisplayName("esRaiz() debe retornar true para nivel 0 sin padre")
        void esRaizDebeRetornarTrueParaNivelCeroSinPadre() {
            // Given
            Catalogo raiz = Catalogo.crearRaiz(
                    new CatalogoTipo("test"),
                    "TEST",
                    "Test",
                    (short) 0);

            // When & Then
            assertThat(raiz.esRaiz()).isTrue();
        }

        @Test
        @DisplayName("esRaiz() debe retornar false para nodos hijos")
        void esRaizDebeRetornarFalseParaNodosHijos() {
            // Given
            Catalogo padre = Catalogo.crearRaiz(
                    new CatalogoTipo("test"),
                    "TEST",
                    "Test",
                    (short) 0);
            Catalogo hijo = Catalogo.crearHijo(
                    padre.getTipo(),
                    padre.getId(),
                    "TEST-HIJO",
                    "Hijo",
                    (short) 0);

            // When & Then
            assertThat(hijo.esRaiz()).isFalse();
        }

        @Test
        @DisplayName("esHoja() debe retornar true si no tiene hijos")
        void esHojaDebeRetornarTrueSiNoTieneHijos() {
            // Given
            Catalogo catalogo = Catalogo.crearRaiz(
                    new CatalogoTipo("test"),
                    "TEST",
                    "Test",
                    (short) 0);

            // When & Then
            assertThat(catalogo.esHoja()).isTrue();
        }

        @Test
        @DisplayName("estaActivo() debe retornar true si activo y sin expiration")
        void estaActivoDebeRetornarTrueSiActivoYSinExpiration() {
            // Given
            Catalogo catalogo = Catalogo.crearRaiz(
                    new CatalogoTipo("test"),
                    "TEST",
                    "Test",
                    (short) 0);

            // When & Then
            assertThat(catalogo.estaActivo()).isTrue();
        }

        @Test
        @DisplayName("estaActivo() debe retornar false si está desactivado")
        void estaActivoDebeRetornarFalseSiEstaDesactivado() {
            // Given
            Catalogo catalogo = Catalogo.crearRaiz(
                    new CatalogoTipo("test"),
                    "TEST",
                    "Test",
                    (short) 0);
            catalogo.desactivar();

            // When & Then
            assertThat(catalogo.estaActivo()).isFalse();
        }
    }

    // ========== EQUALS & HASHCODE ==========

    @Nested
    @DisplayName("Equals & HashCode")
    class EqualsHashCodeTests {

        @Test
        @DisplayName("equals() debe comparar por ID únicamente")
        void equalsDebeCompararPorIdUnicamente() {
            // Given
            CatalogoId id = CatalogoId.generate();
            Catalogo catalogo1 = new Catalogo.Builder()
                    .id(id)
                    .creationDate(LocalDateTime.now())
                    .tipo(new CatalogoTipo("test"))
                    .nivel((short) 0)
                    .codigo("TEST1")
                    .nombre("Nombre 1")
                    .orden((short) 0)
                    .activo(true)
                    .seleccionable(true)
                    .tieneHijos(false)
                    .build();

            Catalogo catalogo2 = new Catalogo.Builder()
                    .id(id) // MISMO ID
                    .creationDate(LocalDateTime.now())
                    .tipo(new CatalogoTipo("test"))
                    .nivel((short) 0)
                    .codigo("TEST2") // Diferentes atributos
                    .nombre("Nombre 2")
                    .orden((short) 1)
                    .activo(false)
                    .seleccionable(false)
                    .tieneHijos(true)
                    .build();

            // When & Then
            assertThat(catalogo1).isEqualTo(catalogo2);
            assertThat(catalogo1.hashCode()).isEqualTo(catalogo2.hashCode());
        }

        @Test
        @DisplayName("equals() debe retornar false para IDs diferentes")
        void equalsDebeRetornarFalseParaIdsDiferentes() {
            // Given
            Catalogo catalogo1 = Catalogo.crearRaiz(
                    new CatalogoTipo("test"),
                    "TEST1",
                    "Nombre 1",
                    (short) 0);

            Catalogo catalogo2 = Catalogo.crearRaiz(
                    new CatalogoTipo("test"),
                    "TEST2",
                    "Nombre 2",
                    (short) 0);

            // When & Then
            assertThat(catalogo1).isNotEqualTo(catalogo2);
        }
    }
}
