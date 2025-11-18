package com.mitoga.autenticacion.domain.repository;

import com.mitoga.autenticacion.domain.entity.Usuario;
import com.mitoga.autenticacion.domain.valueobject.EstadoCuenta;
import com.mitoga.autenticacion.domain.valueobject.UsuarioId;
import com.mitoga.autenticacion.domain.valueobject.Email;

import java.time.ZonedDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Repository Port (Domain Layer): Contrato para persistencia de Usuario
 * 
 * <p>
 * Define las operaciones de persistencia sin conocer detalles de
 * implementación.
 * </p>
 * <p>
 * Implementado por {@code UsuarioPersistenceAdapter} en infrastructure layer.
 * </p>
 * 
 * <p>
 * <b>Principios DDD aplicados:</b>
 * </p>
 * <ul>
 * <li>Usa tipos del dominio (Usuario, UsuarioId, Email, EstadoCuenta)</li>
 * <li>No expone detalles de JPA/persistencia</li>
 * <li>Métodos expresan intención de negocio</li>
 * </ul>
 */
public interface UsuarioRepository {

    /**
     * Guarda un usuario (INSERT o UPDATE)
     * 
     * @param usuario Usuario a persistir
     * @return Usuario persistido con ID generado
     */
    Usuario save(Usuario usuario);

    /**
     * Busca usuario por ID
     * 
     * @param id Identificador del usuario
     * @return Optional con usuario encontrado
     */
    Optional<Usuario> findById(UsuarioId id);

    /**
     * Busca usuario por email
     * 
     * @param email Email del usuario
     * @return Optional con usuario encontrado
     */
    Optional<Usuario> findByEmail(Email email);

    /**
     * Verifica si existe un usuario con el email dado
     * 
     * @param email Email a verificar
     * @return true si existe usuario con ese email
     */
    boolean existsByEmail(Email email);

    /**
     * Busca usuario por token de recuperación de password
     * 
     * @param token Token de recuperación
     * @return Optional con usuario encontrado
     */
    Optional<Usuario> findByTokenRecuperacion(String token);

    /**
     * Lista usuarios por estado de cuenta
     * 
     * @param estadoCuenta Estado de cuenta a filtrar
     * @return Lista de usuarios en ese estado (solo activos, no soft-deleted)
     */
    List<Usuario> findByEstadoCuenta(EstadoCuenta estadoCuenta);

    /**
     * Lista usuarios con email no verificado
     * 
     * @return Lista de usuarios pendientes verificación
     */
    List<Usuario> findByEmailNoVerificado();

    /**
     * Lista usuarios con intentos fallidos >= límite
     * 
     * @param limite Número mínimo de intentos fallidos
     * @return Lista de usuarios con múltiples intentos fallidos
     */
    List<Usuario> findByIntentosFallidosGreaterThanEqual(int limite);

    /**
     * Lista usuarios sin acceso reciente
     * 
     * @param fecha Fecha límite (usuarios con último acceso antes de esta fecha)
     * @return Lista de usuarios inactivos
     */
    List<Usuario> findByFechaUltimoAccesoBefore(ZonedDateTime fecha);

    /**
     * Cuenta usuarios por estado de cuenta (solo activos, no soft-deleted)
     * 
     * @param estadoCuenta Estado de cuenta a contar
     * @return Número de usuarios en ese estado
     */
    long countByEstadoCuenta(EstadoCuenta estadoCuenta);

    /**
     * Elimina (soft delete) un usuario
     * 
     * <p>
     * Establece expiration_date y cambia estado a ELIMINADO.
     * </p>
     * 
     * @param usuario Usuario a eliminar
     */
    void delete(Usuario usuario);

    /**
     * Lista todos los usuarios activos (no soft-deleted)
     * 
     * @return Lista de todos los usuarios activos
     */
    List<Usuario> findAll();
}
