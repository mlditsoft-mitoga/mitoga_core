package com.mitoga.shared.domain.catalogo;

import java.util.List;
import java.util.Optional;

/**
 * Repository Port (Interface) para Catálogo.
 * 
 * Define el contrato para persistencia del aggregate Catalogo.
 * La implementación real está en la capa de Infrastructure (Adapter).
 * 
 * Siguiendo Hexagonal Architecture: El dominio define el PORT,
 * la infraestructura provee el ADAPTER.
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.0.0
 */
public interface CatalogoRepository {

    /**
     * Busca un catálogo por su ID.
     * Solo retorna catálogos activos (expiration_date IS NULL).
     * 
     * @param id identificador del catálogo
     * @return Optional con el catálogo si existe y está activo
     */
    Optional<Catalogo> findById(CatalogoId id);

    /**
     * Busca catálogos por tipo.
     * Solo retorna catálogos activos.
     * 
     * @param tipo tipo de catálogo
     * @return lista de catálogos del tipo especificado
     */
    List<Catalogo> findByTipo(CatalogoTipo tipo);

    /**
     * Busca todos los nodos raíz de un tipo de catálogo.
     * Raíz = padreId IS NULL AND nivel = 0
     * Solo retorna catálogos activos.
     * 
     * @param tipo tipo de catálogo
     * @return lista de catálogos raíz ordenados por 'orden'
     */
    List<Catalogo> findRaicesByTipo(CatalogoTipo tipo);

    /**
     * Busca todos los hijos directos de un catálogo padre.
     * Solo retorna catálogos activos.
     * 
     * @param padreId identificador del padre
     * @return lista de hijos directos ordenados por 'orden'
     */
    List<Catalogo> findHijos(CatalogoId padreId);

    /**
     * Obtiene el árbol completo de un tipo de catálogo.
     * Utiliza la función PostgreSQL catalogo_obtener_arbol().
     * 
     * @param tipo               tipo de catálogo
     * @param soloActivos        si es true, filtra solo activos
     * @param soloSeleccionables si es true, filtra solo seleccionables
     * @return lista de catálogos en orden jerárquico (DFS pre-order)
     */
    List<Catalogo> obtenerArbol(CatalogoTipo tipo, boolean soloActivos, boolean soloSeleccionables);

    /**
     * Obtiene todos los ancestros (padres, abuelos, etc.) de un catálogo.
     * Utiliza la función PostgreSQL catalogo_obtener_ancestros().
     * 
     * @param catalogoId    identificador del catálogo hijo
     * @param incluirPropio si es true, incluye el nodo hijo en la lista
     * @return lista de ancestros ordenados desde raíz hasta hijo
     */
    List<Catalogo> obtenerAncestros(CatalogoId catalogoId, boolean incluirPropio);

    /**
     * Obtiene todos los descendientes (hijos, nietos, etc.) de un catálogo.
     * Utiliza la función PostgreSQL catalogo_obtener_descendientes().
     * 
     * @param catalogoId    identificador del catálogo padre
     * @param incluirPropio si es true, incluye el nodo padre en la lista
     * @return lista de descendientes en orden jerárquico (DFS pre-order)
     */
    List<Catalogo> obtenerDescendientes(CatalogoId catalogoId, boolean incluirPropio);

    /**
     * Busca catálogos por código.
     * El código es único dentro de cada tipo.
     * 
     * @param tipo   tipo de catálogo
     * @param codigo código a buscar
     * @return Optional con el catálogo si existe
     */
    Optional<Catalogo> findByTipoAndCodigo(CatalogoTipo tipo, String codigo);

    /**
     * Busca catálogos por nombre (búsqueda LIKE case-insensitive).
     * Solo retorna catálogos activos.
     * 
     * @param tipo   tipo de catálogo
     * @param nombre nombre o parte del nombre a buscar
     * @return lista de catálogos que coinciden
     */
    List<Catalogo> buscarPorNombre(CatalogoTipo tipo, String nombre);

    /**
     * Persiste un catálogo (INSERT o UPDATE).
     * 
     * @param catalogo el catálogo a guardar
     * @return el catálogo persistido con datos actualizados (triggers)
     */
    Catalogo save(Catalogo catalogo);

    /**
     * Elimina físicamente un catálogo (DELETE).
     * CUIDADO: Esto es eliminación permanente, normalmente se usa soft delete.
     * 
     * @param catalogoId identificador del catálogo a eliminar
     */
    void delete(CatalogoId catalogoId);

    /**
     * Cuenta la cantidad de hijos directos de un catálogo.
     * 
     * @param padreId identificador del padre
     * @return cantidad de hijos activos
     */
    long contarHijos(CatalogoId padreId);

    /**
     * Verifica si existe un catálogo con el código especificado.
     * 
     * @param tipo   tipo de catálogo
     * @param codigo código a verificar
     * @return true si existe, false si no
     */
    boolean existsByTipoAndCodigo(CatalogoTipo tipo, String codigo);
}
