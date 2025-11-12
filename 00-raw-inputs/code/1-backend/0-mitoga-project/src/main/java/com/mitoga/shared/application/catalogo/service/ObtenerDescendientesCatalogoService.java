package com.mitoga.shared.application.catalogo.service;

import com.mitoga.shared.application.catalogo.dto.CatalogoResponse;
import com.mitoga.shared.application.catalogo.dto.DescendientesResponse;
import com.mitoga.shared.application.catalogo.mapper.CatalogoMapper;
import com.mitoga.shared.domain.catalogo.Catalogo;
import com.mitoga.shared.domain.catalogo.CatalogoId;
import com.mitoga.shared.domain.catalogo.CatalogoRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Use Case: Obtener Descendientes de un Catálogo.
 * 
 * Retorna todos los nodos descendientes (hijos, nietos, bisnietos, etc.)
 * de un nodo padre específico.
 * 
 * Útil para mostrar subárboles o expandir categorías.
 * 
 * Utiliza la función PostgreSQL catalogo_obtener_descendientes().
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.0.0
 */
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class ObtenerDescendientesCatalogoService {

    private final CatalogoRepository catalogoRepository;
    private final CatalogoMapper catalogoMapper;

    /**
     * Ejecuta el use case.
     * 
     * @param catalogoIdStr identificador del catálogo padre (UUID string)
     * @param incluirPropio si es true, incluye el nodo padre en la lista
     * @return descendientes ordenados jerárquicamente
     * @throws IllegalArgumentException  si catalogoIdStr no es un UUID válido
     * @throws CatalogoNotFoundException si el catálogo no existe
     */
    public DescendientesResponse execute(String catalogoIdStr, boolean incluirPropio) {
        log.info("Obteniendo descendientes de catálogo - id: {}, incluirPropio: {}", catalogoIdStr, incluirPropio);

        // Validar y convertir ID
        CatalogoId catalogoId = CatalogoId.fromString(catalogoIdStr);

        // Obtener catálogo padre
        Catalogo padre = catalogoRepository.findById(catalogoId)
                .orElseThrow(() -> new CatalogoNotFoundException(catalogoId));

        // Obtener descendientes desde repositorio
        List<CatalogoResponse> descendientes = catalogoRepository
                .obtenerDescendientes(catalogoId, incluirPropio)
                .stream()
                .map(catalogoMapper::toResponse)
                .toList();

        log.info("Descendientes obtenidos - id: {}, totalDescendientes: {}", catalogoIdStr, descendientes.size());

        // Construir respuesta con estadísticas
        CatalogoResponse padreResponse = catalogoMapper.toResponse(padre);
        return DescendientesResponse.from(padreResponse, descendientes);
    }
}
