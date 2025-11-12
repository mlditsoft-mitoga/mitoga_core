package com.mitoga.shared.application.catalogo.service;

import com.mitoga.shared.application.catalogo.dto.ArbolCatalogoResponse;
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
 * Use Case: Obtener Árbol de Catálogos.
 * 
 * Retorna el árbol completo de un tipo de catálogo en formato jer
 * 
 * árquico
 * para construir dropdowns, árboles de navegación, etc.
 * 
 * Utiliza la función PostgreSQL catalogo_obtener_arbol() para obtener
 * todos los nodos en orden DFS pre-order.
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.0.0
 */
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class ObtenerArbolCatalogoService {

    private final CatalogoRepository catalogoRepository;
    private final CatalogoMapper catalogoMapper;

    /**
     * Ejecuta el use case.
     * 
     * @param tipo               tipo de catálogo (ej: "categorias_tutorias")
     * @param soloActivos        si es true, filtra solo catálogos activos
     * @param soloSeleccionables si es true, filtra solo catálogos seleccionables
     * @return árbol completo con estadísticas
     */
    public ArbolCatalogoResponse execute(String tipo, boolean soloActivos, boolean soloSeleccionables) {
        log.info("Obteniendo árbol de catálogos - tipo: {}, soloActivos: {}, soloSeleccionables: {}",
                tipo, soloActivos, soloSeleccionables);

        // Validar tipo
        CatalogoTipo catalogoTipo = new CatalogoTipo(tipo);

        // Obtener árbol desde repositorio
        List<CatalogoResponse> nodos = catalogoRepository
                .obtenerArbol(catalogoTipo, soloActivos, soloSeleccionables)
                .stream()
                .map(catalogoMapper::toResponse)
                .toList();

        log.info("Árbol de catálogos obtenido - tipo: {}, totalNodos: {}", tipo, nodos.size());

        // Construir respuesta con estadísticas
        return ArbolCatalogoResponse.from(tipo, nodos);
    }
}
