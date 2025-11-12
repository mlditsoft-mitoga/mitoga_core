package com.mitoga.shared.application.catalogo.service;

import com.mitoga.shared.domain.catalogo.*;
import com.mitoga.shared.infrastructure.api.exception.ConflictException;
import com.mitoga.shared.infrastructure.api.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Caso de uso: Eliminar Catálogo (Soft Delete).
 * 
 * Desactiva el catálogo (expiration_date = NOW()).
 * Opcionalmente puede eliminar también todos sus descendientes en cascada.
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.1.0
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class EliminarCatalogoService {

    private final CatalogoRepository catalogoRepository;

    /**
     * Elimina un catálogo (soft delete).
     * 
     * @param catalogoId            ID del catálogo a eliminar
     * @param eliminarDescendientes si es true, elimina también todos los hijos
     * @throws ResourceNotFoundException si el catálogo no existe
     * @throws ConflictException         si tiene hijos y no se especificó
     *                                   eliminarlos
     */
    @Transactional
    public void execute(CatalogoId catalogoId, boolean eliminarDescendientes) {
        log.info("Eliminando catálogo - ID: {}, cascada: {}", catalogoId.value(), eliminarDescendientes);

        // Buscar el catálogo
        Catalogo catalogo = catalogoRepository.findById(catalogoId)
                .orElseThrow(() -> {
                    log.warn("Catálogo no encontrado: {}", catalogoId.value());
                    return new ResourceNotFoundException(
                            String.format("El catálogo con ID '%s' no existe", catalogoId.value()));
                });

        // Verificar si tiene hijos
        if (catalogo.getTieneHijos() && !eliminarDescendientes) {
            log.warn("Intentando eliminar catálogo con hijos sin especificar cascada - ID: {}",
                    catalogoId.value());
            throw new ConflictException(
                    String.format("El catálogo '%s' tiene elementos hijos. " +
                            "Use eliminarDescendientes=true para eliminarlos en cascada.",
                            catalogo.getNombre()));
        }

        // Si debe eliminar descendientes, obtenerlos y eliminarlos
        if (eliminarDescendientes) {
            List<Catalogo> descendientes = catalogoRepository.obtenerDescendientes(catalogoId, false);
            log.info("Eliminando {} descendientes del catálogo {}", descendientes.size(), catalogoId.value());

            for (Catalogo descendiente : descendientes) {
                descendiente.desactivar();
                catalogoRepository.save(descendiente);
            }
        }

        // Eliminar el catálogo principal
        catalogo.desactivar();
        catalogoRepository.save(catalogo);

        log.info("Catálogo eliminado exitosamente - ID: {}", catalogoId.value());
    }
}
