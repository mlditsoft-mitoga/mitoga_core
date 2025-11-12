package com.mitoga.shared.application.catalogo.service;

import com.mitoga.shared.application.catalogo.dto.AncestrosResponse;
import com.mitoga.shared.application.catalogo.dto.CatalogoResponse;
import com.mitoga.shared.application.catalogo.mapper.CatalogoMapper;
import com.mitoga.shared.domain.catalogo.CatalogoId;
import com.mitoga.shared.domain.catalogo.CatalogoRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Use Case: Obtener Ancestros de un Catálogo.
 * 
 * Retorna la ruta completa desde la raíz hasta un nodo específico.
 * Útil para construir breadcrumbs de navegación.
 * 
 * Ejemplo: Colombia → Cundinamarca → Bogotá D.C.
 * 
 * Utiliza la función PostgreSQL catalogo_obtener_ancestros().
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.0.0
 */
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class ObtenerAncestrosCatalogoService {

    private final CatalogoRepository catalogoRepository;
    private final CatalogoMapper catalogoMapper;

    /**
     * Ejecuta el use case.
     * 
     * @param catalogoIdStr identificador del catálogo hijo (UUID string)
     * @param incluirPropio si es true, incluye el nodo hijo en la lista
     * @return ruta de ancestros desde raíz hasta hijo
     * @throws IllegalArgumentException  si catalogoIdStr no es un UUID válido
     * @throws CatalogoNotFoundException si el catálogo no existe
     */
    public AncestrosResponse execute(String catalogoIdStr, boolean incluirPropio) {
        log.info("Obteniendo ancestros de catálogo - id: {}, incluirPropio: {}", catalogoIdStr, incluirPropio);

        // Validar y convertir ID
        CatalogoId catalogoId = CatalogoId.fromString(catalogoIdStr);

        // Verificar que el catálogo existe
        catalogoRepository.findById(catalogoId)
                .orElseThrow(() -> new CatalogoNotFoundException(catalogoId));

        // Obtener ancestros desde repositorio
        List<CatalogoResponse> ancestros = catalogoRepository
                .obtenerAncestros(catalogoId, incluirPropio)
                .stream()
                .map(catalogoMapper::toResponse)
                .toList();

        log.info("Ancestros obtenidos - id: {}, totalAncestros: {}", catalogoIdStr, ancestros.size());

        // Construir respuesta con ruta legible
        return AncestrosResponse.from(ancestros);
    }
}
