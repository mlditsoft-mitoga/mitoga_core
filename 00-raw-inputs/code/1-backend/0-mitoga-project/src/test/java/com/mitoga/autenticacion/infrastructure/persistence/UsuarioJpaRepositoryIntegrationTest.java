package com.mitoga.autenticacion.infrastructure.persistence;

import com.mitoga.autenticacion.domain.model.Usuario;
import com.mitoga.autenticacion.domain.model.valueobject.EstadoCuenta;
import com.mitoga.autenticacion.domain.model.valueobject.Rol;
import com.mitoga.autenticacion.infrastructure.persistence.jpa.UsuarioJpaRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * UsuarioJpaRepositoryIntegrationTest - Integration tests para
 * UsuarioJpaRepository
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-15
 * 
 * TESTING - PERSISTENCE LAYER - INTEGRATION TEST
 * - @DataJpaTest para testing con base de datos en memoria (H2)
 * - TestEntityManager para operaciones JPA
 * - Verificación de queries personalizadas
 * - Testing de relaciones y constraints
 */
@DataJpaTest
@ActiveProfiles("test")
@DisplayName("UsuarioJpaRepository - Integration Tests")
class UsuarioJpaRepositoryIntegrationTest {

    @Autowired
    private UsuarioJpaRepository usuarioJpaRepository;

    @Autowired
    private TestEntityManager entityManager;

    @Test
    @DisplayName("Debe guardar y recuperar usuario correctamente")
    void debeGuardarYRecuperarUsuario() {
        // Given
        Usuario usuario = Usuario.crear(
                "juan.perez@example.com",
                "hashedPassword123",
                "Juan",
                "Pérez",
                Rol.ESTUDIANTE);

        // When
        Usuario usuarioGuardado = usuarioJpaRepository.save(usuario);
        entityManager.flush();
        entityManager.clear();

        Optional<Usuario> usuarioRecuperado = usuarioJpaRepository.findById(usuarioGuardado.getId());

        // Then
        assertThat(usuarioRecuperado).isPresent();
        assertThat(usuarioRecuperado.get().getEmail()).isEqualTo("juan.perez@example.com");
        assertThat(usuarioRecuperado.get().getNombre()).isEqualTo("Juan");
        assertThat(usuarioRecuperado.get().getApellido()).isEqualTo("Pérez");
        assertThat(usuarioRecuperado.get().getRol()).isEqualTo(Rol.ESTUDIANTE);
    }

    @Test
    @DisplayName("Debe buscar usuario por email correctamente")
    void debeBuscarUsuarioPorEmail() {
        // Given
        Usuario usuario = Usuario.crear(
                "maria.garcia@example.com",
                "hashedPassword",
                "María",
                "García",
                Rol.TUTOR);
        entityManager.persist(usuario);
        entityManager.flush();

        // When
        Optional<Usuario> resultado = usuarioJpaRepository.findByEmail("maria.garcia@example.com");

        // Then
        assertThat(resultado).isPresent();
        assertThat(resultado.get().getEmail()).isEqualTo("maria.garcia@example.com");
        assertThat(resultado.get().getRol()).isEqualTo(Rol.TUTOR);
    }

    @Test
    @DisplayName("Debe retornar empty cuando el email no existe")
    void debeRetornarEmptyCuandoEmailNoExiste() {
        // When
        Optional<Usuario> resultado = usuarioJpaRepository.findByEmail("noexiste@example.com");

        // Then
        assertThat(resultado).isEmpty();
    }

    @Test
    @DisplayName("Debe verificar existencia de email correctamente")
    void debeVerificarExistenciaDeEmail() {
        // Given
        Usuario usuario = Usuario.crear(
                "pedro.lopez@example.com",
                "hashedPassword",
                "Pedro",
                "López",
                Rol.ESTUDIANTE);
        entityManager.persist(usuario);
        entityManager.flush();

        // When
        boolean existe = usuarioJpaRepository.existsByEmail("pedro.lopez@example.com");
        boolean noExiste = usuarioJpaRepository.existsByEmail("otro@example.com");

        // Then
        assertThat(existe).isTrue();
        assertThat(noExiste).isFalse();
    }

    @Test
    @DisplayName("Debe buscar usuarios por rol")
    void debeBuscarUsuariosPorRol() {
        // Given
        Usuario estudiante1 = Usuario.crear("est1@example.com", "pass", "Est1", "Uno", Rol.ESTUDIANTE);
        Usuario estudiante2 = Usuario.crear("est2@example.com", "pass", "Est2", "Dos", Rol.ESTUDIANTE);
        Usuario tutor = Usuario.crear("tutor@example.com", "pass", "Tutor", "Uno", Rol.TUTOR);

        entityManager.persist(estudiante1);
        entityManager.persist(estudiante2);
        entityManager.persist(tutor);
        entityManager.flush();

        // When
        List<Usuario> estudiantes = usuarioJpaRepository.findByRol(Rol.ESTUDIANTE);
        List<Usuario> tutores = usuarioJpaRepository.findByRol(Rol.TUTOR);

        // Then
        assertThat(estudiantes).hasSize(2);
        assertThat(tutores).hasSize(1);
        assertThat(estudiantes).allMatch(u -> u.getRol() == Rol.ESTUDIANTE);
        assertThat(tutores).allMatch(u -> u.getRol() == Rol.TUTOR);
    }

    @Test
    @DisplayName("Debe buscar usuarios por estado de cuenta")
    void debeBuscarUsuariosPorEstadoCuenta() {
        // Given
        Usuario usuarioActivo = Usuario.crear("activo@example.com", "pass", "Activo", "User", Rol.ESTUDIANTE);
        usuarioActivo.verificarEmail("123456");

        Usuario usuarioPendiente = Usuario.crear("pendiente@example.com", "pass", "Pendiente", "User", Rol.ESTUDIANTE);

        Usuario usuarioBloqueado = Usuario.crear("bloqueado@example.com", "pass", "Bloqueado", "User", Rol.ESTUDIANTE);
        usuarioBloqueado.bloquearCuenta("Test");

        entityManager.persist(usuarioActivo);
        entityManager.persist(usuarioPendiente);
        entityManager.persist(usuarioBloqueado);
        entityManager.flush();

        // When
        List<Usuario> activos = usuarioJpaRepository.findByEstadoCuenta(EstadoCuenta.ACTIVA);
        List<Usuario> pendientes = usuarioJpaRepository.findByEstadoCuenta(EstadoCuenta.PENDIENTE_VERIFICACION);
        List<Usuario> bloqueados = usuarioJpaRepository.findByEstadoCuenta(EstadoCuenta.BLOQUEADA);

        // Then
        assertThat(activos).hasSize(1);
        assertThat(pendientes).hasSize(1);
        assertThat(bloqueados).hasSize(1);
    }

    @Test
    @DisplayName("Debe encontrar usuarios sin verificar")
    void debeEncontrarUsuariosSinVerificar() {
        // Given
        Usuario verificado = Usuario.crear("verificado@example.com", "pass", "Ver", "User", Rol.ESTUDIANTE);
        verificado.verificarEmail("123456");

        Usuario sinVerificar = Usuario.crear("sinverificar@example.com", "pass", "Sin", "Ver", Rol.ESTUDIANTE);

        entityManager.persist(verificado);
        entityManager.persist(sinVerificar);
        entityManager.flush();

        // When
        List<Usuario> usuariosSinVerificar = usuarioJpaRepository.findUsuariosSinVerificar();

        // Then
        assertThat(usuariosSinVerificar).hasSize(1);
        assertThat(usuariosSinVerificar.get(0).isEmailVerificado()).isFalse();
    }

    @Test
    @DisplayName("Debe encontrar usuarios bloqueados")
    void debeEncontrarUsuariosBloqueados() {
        // Given
        Usuario normal = Usuario.crear("normal@example.com", "pass", "Normal", "User", Rol.ESTUDIANTE);
        Usuario bloqueado = Usuario.crear("bloqueado@example.com", "pass", "Bloq", "User", Rol.TUTOR);
        bloqueado.bloquearCuenta("Spam");

        entityManager.persist(normal);
        entityManager.persist(bloqueado);
        entityManager.flush();

        // When
        List<Usuario> usuariosBloqueados = usuarioJpaRepository.findUsuariosBloqueados();

        // Then
        assertThat(usuariosBloqueados).hasSize(1);
        assertThat(usuariosBloqueados.get(0).getEstadoCuenta()).isEqualTo(EstadoCuenta.BLOQUEADA);
    }

    @Test
    @DisplayName("Debe respetar constraint de email único")
    void debeRespetarConstraintEmailUnico() {
        // Given
        Usuario usuario1 = Usuario.crear("unico@example.com", "pass1", "Usuario", "Uno", Rol.ESTUDIANTE);
        entityManager.persist(usuario1);
        entityManager.flush();

        Usuario usuario2 = Usuario.crear("unico@example.com", "pass2", "Usuario", "Dos", Rol.TUTOR);

        // When & Then
        try {
            entityManager.persist(usuario2);
            entityManager.flush();
            assertThat(false).isTrue(); // No debería llegar aquí
        } catch (Exception e) {
            // Se espera una excepción de constraint violation
            assertThat(e).isNotNull();
        }
    }

    @Test
    @DisplayName("Debe persistir timestamps de auditoría")
    void debePersistirTimestampsAuditoria() {
        // Given
        Usuario usuario = Usuario.crear("timestamps@example.com", "pass", "Time", "User", Rol.ESTUDIANTE);

        // When
        Usuario usuarioGuardado = entityManager.persist(usuario);
        entityManager.flush();

        // Then
        assertThat(usuarioGuardado.getFechaCreacion()).isNotNull();
        assertThat(usuarioGuardado.getFechaActualizacion()).isNotNull();
    }

    @Test
    @DisplayName("Debe actualizar usuario correctamente")
    void debeActualizarUsuarioCorrectamente() {
        // Given
        Usuario usuario = Usuario.crear("actualizar@example.com", "pass", "Original", "Name", Rol.ESTUDIANTE);
        entityManager.persist(usuario);
        entityManager.flush();
        entityManager.clear();

        // When
        Usuario usuarioRecuperado = usuarioJpaRepository.findById(usuario.getId()).get();
        usuarioRecuperado.verificarEmail("123456");
        usuarioJpaRepository.save(usuarioRecuperado);
        entityManager.flush();
        entityManager.clear();

        Usuario usuarioActualizado = usuarioJpaRepository.findById(usuario.getId()).get();

        // Then
        assertThat(usuarioActualizado.isEmailVerificado()).isTrue();
        assertThat(usuarioActualizado.getEstadoCuenta()).isEqualTo(EstadoCuenta.ACTIVA);
    }
}
