package com.mitoga.shared.application.catalogo.service;

import com.mitoga.shared.application.catalogo.dto.CatalogoResponse;
import com.mitoga.shared.domain.catalogo.*;
import com.mitoga.shared.infrastructure.api.exception.ConflictException;
import com.mitoga.shared.infrastructure.api.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

/**
 * Caso de uso: Crear Catálogo.
 * 
 * Aplica reglas de negocio:
 * - El código debe ser único dentro del tipo
 * - Si tiene padre, el padre debe existir
 * - Nivel y path se calculan automáticamente por trigger BD
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.1.0
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class CrearCatalogoService {

    private final CatalogoRepository catalogoRepository;

    /**
     * Crea un nuevo catálogo.
     * 
     * @param tipo          tipo de catálogo
     * @param padreId       ID del padre (null para raíz)
     * @param codigo        código único
     * @param nombre        nombre en español
     * @param nombreEn      nombre en inglés (opcional)
     * @param descripcion   descripción (opcional)
     * @param descripcionEn descripción en inglés (opcional)
     * @param orden         orden de visualización
     * @param icono         icono Font Awesome (opcional)
     * @param color         color hexadecimal (opcional)
     * @param activo        si está activo (default: true)
     * @param seleccionable si es seleccionable (default: true)
     * @param metadatos     metadatos adicionales (opcional)
     * @return el catálogo creado
     * @throws BusinessRuleException     si ya existe un catálogo con el mismo
     *                                   código
     * @throws ResourceNotFoundException si el padre no existe
     */
    @Transactional
    public CatalogoResponse execute(
            String tipo,
            CatalogoId padreId,
            String codigo,
            String nombre,
            String nombreEn,
            String descripcion,
            String descripcionEn,
            Short orden,
            String icono,
            String color,
            Boolean activo,
            Boolean seleccionable,
            Map<String, Object> metadatos) {

        log.info("Creando catálogo - tipo: {}, código: {}, padre: {}", tipo, codigo, padreId);

        // Validar tipo de catálogo
        CatalogoTipo catalogoTipo = CatalogoTipo.fromCodigo(tipo);

        // Validar unicidad del código
        if (catalogoRepository.existsByTipoAndCodigo(catalogoTipo, codigo)) {
            log.warn("Ya existe un catálogo con tipo {} y código {}", tipo, codigo);
            throw new ConflictException(
                    String.format("Ya existe un catálogo del tipo '%s' con el código '%s'", tipo, codigo));
        }

        // Si tiene padre, validar que existe
        if (padreId != null) {
            catalogoRepository.findById(padreId)
                    .orElseThrow(() -> {
                        log.warn("Catálogo padre no encontrado: {}", padreId);
                        return new ResourceNotFoundException(
                                String.format("El catálogo padre con ID '%s' no existe", padreId.value()));
                    });
        }

        // Crear el catálogo usando factory method
        Catalogo catalogo;
        if (padreId == null) {
            catalogo = Catalogo.crearRaiz(catalogoTipo, codigo, nombre, orden);
        } else {
            catalogo = Catalogo.crearHijo(catalogoTipo, padreId, codigo, nombre, orden);
        }

        // Establecer campos opcionales
        if (nombreEn != null) {
            catalogo.actualizarNombreEn(nombreEn);
        }
        if (descripcion != null) {
            catalogo.actualizarDescripcion(descripcion);
        }
        if (descripcionEn != null) {
            catalogo.actualizarDescripcionEn(descripcionEn);
        }
        if (icono != null) {
            catalogo.actualizarIcono(icono);
        }
        if (color != null) {
            catalogo.actualizarColor(color);
        }
        if (activo != null) {
            if (activo) {
                catalogo.activar();
            } else {
                catalogo.desactivar();
            }
        }
        if (seleccionable != null) {
            if (seleccionable) {
                catalogo.marcarComoSeleccionable();
            } else {
                catalogo.marcarComoNoSeleccionable();
            }
        }
        if (metadatos != null && !metadatos.isEmpty()) {
            catalogo.actualizarMetadatos(metadatos);
        }

        // Persistir
        Catalogo catalogoGuardado = catalogoRepository.save(catalogo);

        log.info("Catálogo creado exitosamente - ID: {}, código: {}", catalogoGuardado.getId().value(), codigo);

        return CatalogoResponse.fromDomain(catalogoGuardado);
    }
}
