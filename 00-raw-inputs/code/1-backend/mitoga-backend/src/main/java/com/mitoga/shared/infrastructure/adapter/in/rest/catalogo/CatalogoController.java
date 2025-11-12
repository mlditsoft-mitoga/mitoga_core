package com.mitoga.shared.infrastructure.adapter.in.rest.catalogo;

import com.mitoga.shared.application.catalogo.dto.AncestrosResponse;
import com.mitoga.shared.application.catalogo.dto.ArbolCatalogoResponse;
import com.mitoga.shared.application.catalogo.dto.CatalogoResponse;
import com.mitoga.shared.application.catalogo.dto.DescendientesResponse;
import com.mitoga.shared.application.catalogo.service.*;
import com.mitoga.shared.infrastructure.adapter.in.rest.catalogo.dto.*;
import com.mitoga.shared.infrastructure.api.response.ApiResponse;
import com.mitoga.shared.infrastructure.api.message.SuccessMessage;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * REST Controller para operaciones de Catálogo.
 * 
 * POLÍTICA HTTP METHODS (v1.1.0):
 * - ✅ GET: SOLO para health checks (/actuator/health, /actuator/info)
 * - ✅ POST: TODOS los demás endpoints (consultas, búsquedas, operaciones)
 * 
 * Endpoints disponibles (POST-only):
 * - POST /api/v1/catalogos/buscar-arbol - Obtener árbol completo de un tipo
 * - POST /api/v1/catalogos/buscar-ancestros - Obtener ancestros (breadcrumb)
 * - POST /api/v1/catalogos/buscar-descendientes - Obtener descendientes
 * (subárbol)
 * - POST /api/v1/catalogos/buscar - Buscar por nombre
 * 
 * Ventajas de usar POST:
 * - Seguridad: Datos sensibles en body (no en URL/logs)
 * - Flexibilidad: Request bodies complejos sin limitación de tamaño
 * - Consistencia: Mismo patrón para todos los endpoints
 * - Validación: @Valid + @RequestBody robusta
 * 
 * @author Backend Team - MI-TOGA
 * @version 1.1.0 - POST-only policy
 * @since 1.0.0
 */
@RestController
@RequestMapping("/api/v1/catalogos")
@RequiredArgsConstructor
@Validated
@Slf4j
@Tag(name = "Catálogos", description = "API para gestión de catálogos recursivos jerárquicos (POST-only)")
public class CatalogoController {

    private final ObtenerArbolCatalogoService obtenerArbolService;
    private final ObtenerAncestrosCatalogoService obtenerAncestrosService;
    private final ObtenerDescendientesCatalogoService obtenerDescendientesService;
    private final BuscarCatalogosService buscarCatalogosService;

    /**
     * POST /api/v1/catalogos/buscar-arbol
     * 
     * Obtiene el árbol completo de un tipo de catálogo.
     * Útil para construir dropdowns jerárquicos, árboles de navegación, etc.
     */
    @Operation(summary = "Obtener árbol completo de catálogos", description = "Retorna todos los nodos de un tipo de catálogo en orden jerárquico (DFS pre-order). "
            + "Permite filtrar por activos y/o seleccionables. **Usar POST con body JSON.**")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Árbol obtenido exitosamente", content = @Content(schema = @Schema(implementation = ApiResponse.class))),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Tipo de catálogo inválido o request inválido")
    })
    @PostMapping("/buscar-arbol")
    public ResponseEntity<ApiResponse<ArbolCatalogoResponse>> obtenerArbol(
            @Valid @RequestBody ObtenerArbolRequest request) {
        log.info("POST /api/v1/catalogos/buscar-arbol - tipo: {}, soloActivos: {}, soloSeleccionables: {}",
                request.tipo(), request.soloActivos(), request.soloSeleccionables());

        ArbolCatalogoResponse arbol = obtenerArbolService.execute(
                request.tipo(),
                request.soloActivos(),
                request.soloSeleccionables());

        return ResponseEntity.ok(ApiResponse.success(arbol, SuccessMessage.GEN_RETRIEVED));
    }

    /**
     * POST /api/v1/catalogos/buscar-ancestros
     * 
     * Obtiene la ruta de ancestros (breadcrumb) de un catálogo.
     * Retorna desde la raíz hasta el nodo especificado.
     */
    @Operation(summary = "Obtener ancestros de un catálogo", description = "Retorna la ruta completa desde la raíz hasta el catálogo especificado. "
            + "Útil para construir breadcrumbs de navegación. **Usar POST con body JSON.**")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Ancestros obtenidos exitosamente", content = @Content(schema = @Schema(implementation = ApiResponse.class))),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Catálogo no encontrado"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Request inválido")
    })
    @PostMapping("/buscar-ancestros")
    public ResponseEntity<ApiResponse<AncestrosResponse>> obtenerAncestros(
            @Valid @RequestBody ObtenerAncestrosRequest request) {
        log.info("POST /api/v1/catalogos/buscar-ancestros - catalogoId: {}, incluirPropio: {}",
                request.catalogoId(), request.incluirPropio());

        AncestrosResponse ancestros = obtenerAncestrosService.execute(
                request.catalogoId(),
                request.incluirPropio());

        return ResponseEntity.ok(ApiResponse.success(ancestros, SuccessMessage.GEN_RETRIEVED));
    }

    /**
     * POST /api/v1/catalogos/buscar-descendientes
     * 
     * Obtiene todos los descendientes (hijos, nietos, etc.) de un catálogo.
     * Útil para expandir subárboles.
     */
    @Operation(summary = "Obtener descendientes de un catálogo", description = "Retorna todos los nodos descendientes del catálogo especificado. "
            + "Útil para mostrar subárboles o expandir categorías. **Usar POST con body JSON.**")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Descendientes obtenidos exitosamente", content = @Content(schema = @Schema(implementation = ApiResponse.class))),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Catálogo no encontrado"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Request inválido")
    })
    @PostMapping("/buscar-descendientes")
    public ResponseEntity<ApiResponse<DescendientesResponse>> obtenerDescendientes(
            @Valid @RequestBody ObtenerDescendientesRequest request) {
        log.info("POST /api/v1/catalogos/buscar-descendientes - catalogoId: {}, incluirPropio: {}",
                request.catalogoId(), request.incluirPropio());

        DescendientesResponse descendientes = obtenerDescendientesService.execute(
                request.catalogoId(),
                request.incluirPropio());

        return ResponseEntity.ok(ApiResponse.success(descendientes, SuccessMessage.GEN_RETRIEVED));
    }

    /**
     * POST /api/v1/catalogos/buscar
     * 
     * Busca catálogos por nombre.
     * Búsqueda LIKE case-insensitive.
     */
    @Operation(summary = "Buscar catálogos por nombre", description = "Busca catálogos de un tipo específico por nombre (búsqueda parcial case-insensitive). "
            + "Útil para implementar autocomplete o búsqueda en dropdowns grandes. **Usar POST con body JSON.**")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Búsqueda completada exitosamente", content = @Content(schema = @Schema(implementation = ApiResponse.class))),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Request inválido")
    })
    @PostMapping("/buscar")
    public ResponseEntity<ApiResponse<List<CatalogoResponse>>> buscarCatalogos(
            @Valid @RequestBody BuscarCatalogosRequest request) {
        log.info("POST /api/v1/catalogos/buscar - tipo: {}, nombre: '{}'",
                request.tipo(), request.nombre());

        List<CatalogoResponse> resultados = buscarCatalogosService.execute(
                request.tipo(),
                request.nombre());

        return ResponseEntity.ok(ApiResponse.success(resultados, SuccessMessage.GEN_RETRIEVED));
    }
}
