package com.mitoga.autenticacion.infrastructure.persistence.adapter;

import com.mitoga.autenticacion.infrastructure.persistence.entity.UsuarioEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.ZonedDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repositorio JPA para UsuarioEntity
 * 
 * <p>
 * Todos los métodos usan <b>Query Methods derivados</b> de Spring Data JPA.
 * </p>
 * 
 * <p>
 * <b>Convenciones Query Methods:</b>
 * </p>
 * <ul>
 * <li><b>findBy</b>: Retorna List o Optional</li>
 * <li><b>existsBy</b>: Retorna boolean</li>
 * <li><b>countBy</b>: Retorna long</li>
 * <li><b>And</b>: Conjunción lógica</li>
 * <li><b>Or</b>: Disyunción lógica</li>
 * <li><b>GreaterThan</b>: Mayor que</li>
 * <li><b>LessThan</b>: Menor que</li>
 * <li><b>Between</b>: Entre dos valores</li>
 * <li><b>OrderBy</b>: Ordenamiento</li>
 * </ul>
 * 
 * <p>
 * <b>Filtrado soft-delete automático:</b>
 * </p>
 * <p>
 * Todos los métodos filtran por <code>expirationDate IS NULL</code>
 * para excluir registros eliminados lógicamente.
 * </p>
 * 
 * @see <a href=
 *      "https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#jpa.query-methods">Spring
 *      Data JPA Query Methods</a>
 */
@Repository
public interface UsuarioJpaRepository extends JpaRepository<UsuarioEntity, UUID> {

        /**
         * Busca usuario por email (solo activos, no soft-deleted)
         * 
         * <p>
         * Query generado:
         * </p>
         * 
         * <pre>
         * SELECT * FROM appmatch_schema.usuarios 
         * WHERE email = ? AND expiration_date IS NULL
         * </pre>
         */
        Optional<UsuarioEntity> findByEmailAndExpirationDateIsNull(String email);

        /**
         * Verifica existencia por email (solo activos)
         * 
         * <p>
         * Query generado:
         * </p>
         * 
         * <pre>
         * SELECT COUNT(*) > 0 FROM appmatch_schema.usuarios 
         * WHERE email = ? AND expiration_date IS NULL
         * </pre>
         */
        boolean existsByEmailAndExpirationDateIsNull(String email);

        /**
         * Busca usuario por token de recuperación (solo activos con token no nulo)
         * 
         * <p>
         * Query generado:
         * </p>
         * 
         * <pre>
         * SELECT * FROM appmatch_schema.usuarios 
         * WHERE token_recuperacion_password = ? 
         *   AND expiration_date IS NULL
         *   AND token_recuperacion_password IS NOT NULL
         * </pre>
         */
        Optional<UsuarioEntity> findByTokenRecuperacionPasswordAndExpirationDateIsNullAndTokenRecuperacionPasswordIsNotNull(
                        String tokenRecuperacionPassword);

        /**
         * Lista usuarios por estado de cuenta (solo activos)
         * 
         * <p>
         * Query generado:
         * </p>
         * 
         * <pre>
         * SELECT * FROM appmatch_schema.usuarios 
         * WHERE estado_cuenta = ? AND expiration_date IS NULL
         * ORDER BY creation_date DESC
         * </pre>
         */
        List<UsuarioEntity> findByEstadoCuentaAndExpirationDateIsNullOrderByCreationDateDesc(String estadoCuenta);

        /**
         * Lista usuarios con email no verificado (solo activos)
         * 
         * <p>
         * Query generado:
         * </p>
         * 
         * <pre>
         * SELECT * FROM appmatch_schema.usuarios 
         * WHERE email_verificado = FALSE 
         *   AND expiration_date IS NULL
         * ORDER BY creation_date DESC
         * </pre>
         */
        List<UsuarioEntity> findByEmailVerificadoFalseAndExpirationDateIsNullOrderByCreationDateDesc();

        /**
         * Lista usuarios con intentos fallidos >= límite (solo activos)
         * 
         * <p>
         * Query generado:
         * </p>
         * 
         * <pre>
         * SELECT * FROM appmatch_schema.usuarios 
         * WHERE intentos_fallidos_login >= ? 
         *   AND expiration_date IS NULL
         * ORDER BY intentos_fallidos_login DESC
         * </pre>
         */
        List<UsuarioEntity> findByIntentosFallidosLoginGreaterThanEqualAndExpirationDateIsNullOrderByIntentosFallidosLoginDesc(
                        Integer limite);

        /**
         * Lista usuarios sin acceso reciente (solo activos)
         * 
         * <p>
         * Query generado:
         * </p>
         * 
         * <pre>
         * SELECT * FROM appmatch_schema.usuarios 
         * WHERE fecha_ultimo_acceso < ? 
         *   AND expiration_date IS NULL
         * ORDER BY fecha_ultimo_acceso ASC NULLS FIRST
         * </pre>
         */
        List<UsuarioEntity> findByFechaUltimoAccesoBeforeAndExpirationDateIsNullOrderByFechaUltimoAccesoAsc(
                        ZonedDateTime fecha);

        /**
         * Lista usuarios sin acceso nunca registrado (fecha_ultimo_acceso IS NULL)
         * 
         * <p>
         * Query generado:
         * </p>
         * 
         * <pre>
         * SELECT * FROM appmatch_schema.usuarios 
         * WHERE fecha_ultimo_acceso IS NULL 
         *   AND expiration_date IS NULL
         * ORDER BY creation_date DESC
         * </pre>
         */
        List<UsuarioEntity> findByFechaUltimoAccesoIsNullAndExpirationDateIsNullOrderByCreationDateDesc();

        /**
         * Cuenta usuarios por estado de cuenta (solo activos)
         * 
         * <p>
         * Query generado:
         * </p>
         * 
         * <pre>
         * SELECT COUNT(*) FROM appmatch_schema.usuarios 
         * WHERE estado_cuenta = ? AND expiration_date IS NULL
         * </pre>
         */
        long countByEstadoCuentaAndExpirationDateIsNull(String estadoCuenta);

        /**
         * Lista todos los usuarios activos (no soft-deleted)
         * 
         * <p>
         * Query generado:
         * </p>
         * 
         * <pre>
         * SELECT * FROM appmatch_schema.usuarios 
         * WHERE expiration_date IS NULL
         * ORDER BY creation_date DESC
         * </pre>
         */
        List<UsuarioEntity> findByExpirationDateIsNullOrderByCreationDateDesc();

        // Nota: findById heredado de JpaRepository permite buscar incluyendo
        // soft-deleted para auditoría
}
