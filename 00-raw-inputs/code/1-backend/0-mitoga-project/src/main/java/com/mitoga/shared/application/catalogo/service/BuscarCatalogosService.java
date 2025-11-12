package com.mitoga.shared.application.catalogo.service;

import com.mitoga.shared.application.catalogo.dto.CatalogoResponse;
import com.mitoga.shared.application.catalogo.mapper.CatalogoMapper;
import com.mitoga.shared.domain.catalogo.CatalogoRepository;
import com.mitoga.shared.domain.catalogo.CatalogoTipo;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Use Case: Buscar Catálogos por Nombre.
 * 
 * Permite buscar catálogos de un tipo específico por nombre
 * (búsqueda LIKE case-insensitive).
 * 
 * Útil para implementar autocomplete o búsqueda en dropdowns grandes.
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.0.0
 */
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class BuscarCatalogosService {

    private final CatalogoRepository catalogoRepository;
    private final CatalogoMapper catalogoMapper;

    /**
     * Ejecuta el use case.
     * 
     * @param tipo   tipo de catálogo (ej: "categorias_tutorias")
     * @param nombre nombre o parte del nombre a buscar
     * @return lista de catálogos que coinciden
     */
    public List<CatalogoResponse> execute(String tipo, String nombre) {
        log.info("Buscando catálogos - tipo: {}, nombre: '{}'", tipo, nombre);

        // Validar tipo
        CatalogoTipo catalogoTipo = new CatalogoTipo(tipo);

        // Buscar en repositorio
        List<CatalogoResponse> resultados = catalogoRepository
                .buscarPorNombre(catalogoTipo, nombre)
                .stream()
                .map(catalogoMapper::toResponse)
                .toList();

        log.info("Búsqueda completada - tipo: {}, nombre: '{}', resultados: {}", tipo, nombre, resultados.size());

        return resultados;
    }
}
