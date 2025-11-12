package com.mitoga.shared.application.catalogo.service;

import com.mitoga.shared.application.catalogo.dto.CatalogoResponse;
import com.mitoga.shared.domain.catalogo.*;
import com.mitoga.shared.infrastructure.api.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Caso de uso: Obtener Catálogo por ID.
 * 
 * Retorna un catálogo específico por su identificador.
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.1.0
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class ObtenerCatalogoPorIdService {

    private final CatalogoRepository catalogoRepository;

    /**
     * Obtiene un catálogo por su ID.
     * 
     * @param catalogoId ID del catálogo
     * @return el catálogo encontrado
     * @throws ResourceNotFoundException si el catálogo no existe
     */
    @Transactional(readOnly = true)
    public CatalogoResponse execute(CatalogoId catalogoId) {
        log.info("Obteniendo catálogo - ID: {}", catalogoId.value());

        Catalogo catalogo = catalogoRepository.findById(catalogoId)
                .orElseThrow(() -> {
                    log.warn("Catálogo no encontrado: {}", catalogoId.value());
                    return new ResourceNotFoundException(
                            String.format("El catálogo con ID '%s' no existe", catalogoId.value()));
                });

        return CatalogoResponse.fromDomain(catalogo);
    }
}
