package com.mitoga.autenticacion.domain.repository;

import com.mitoga.autenticacion.domain.entity.ProcesoRegistro;

import java.util.Optional;
import java.util.UUID;

/**
 * Repository Port: ProcesoRegistro
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
public interface ProcesoRegistroRepository {

    /**
     * Guardar o actualizar un proceso de registro
     */
    ProcesoRegistro save(ProcesoRegistro procesoRegistro);

    /**
     * Buscar proceso por ID
     */
    Optional<ProcesoRegistro> findById(UUID procesoId);

    /**
     * Buscar proceso activo (no expirado, no cancelado) por usuario
     */
    Optional<ProcesoRegistro> findProcesoActivoByUsuario(UUID usuarioId);
}
