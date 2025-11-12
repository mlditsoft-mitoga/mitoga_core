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
 * Caso de uso: Actualizar Catálogo.
 * 
 * Permite modificar los atributos de un catálogo existente.
 * Solo actualiza los campos que vienen informados (parcial update).
 * 
 * @author Backend Team - MI-TOGA
 * @since 1.1.0
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class ActualizarCatalogoService {

    private final CatalogoRepository catalogoRepository;

    /**
     * Actualiza un catálogo existente.
     * 
     * @param catalogoId    ID del catálogo a actualizar
     * @param padreId       nuevo padre (opcional)
     * @param codigo        nuevo código (opcional)
     * @param nombre        nuevo nombre (opcional)
     * @param nombreEn      nuevo nombre en inglés (opcional)
     * @param descripcion   nueva descripción (opcional)
     * @param descripcionEn nueva descripción en inglés (opcional)
     * @param orden         nuevo orden (opcional)
     * @param icono         nuevo icono (opcional)
     * @param color         nuevo color (opcional)
     * @param activo        nuevo estado activo (opcional)
     * @param seleccionable nuevo estado seleccionable (opcional)
     * @param metadatos     nuevos metadatos (opcional)
     * @return el catálogo actualizado
     * @throws ResourceNotFoundException si el catálogo no existe
     * @throws ConflictException         si el nuevo código ya existe
     */
    @Transactional
    public CatalogoResponse execute(
            CatalogoId catalogoId,
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

        log.info("Actualizando catálogo - ID: {}", catalogoId.value());

        // Buscar el catálogo existente
        Catalogo catalogo = catalogoRepository.findById(catalogoId)
                .orElseThrow(() -> {
                    log.warn("Catálogo no encontrado: {}", catalogoId.value());
                    return new ResourceNotFoundException(
                            String.format("El catálogo con ID '%s' no existe", catalogoId.value()));
                });

        // Si se quiere cambiar el código, validar unicidad
        if (codigo != null && !codigo.equals(catalogo.getCodigo())) {
            if (catalogoRepository.existsByTipoAndCodigo(catalogo.getTipo(), codigo)) {
                log.warn("Ya existe un catálogo con tipo {} y código {}", catalogo.getTipo(), codigo);
                throw new ConflictException(
                        String.format("Ya existe un catálogo del tipo '%s' con el código '%s'",
                                catalogo.getTipo().value(), codigo));
            }
            catalogo.actualizarCodigo(codigo);
        }

        // Actualizar padre si viene informado
        if (padreId != null && !padreId.equals(catalogo.getPadreId())) {
            // Validar que el nuevo padre existe
            catalogoRepository.findById(padreId)
                    .orElseThrow(() -> {
                        log.warn("Catálogo padre no encontrado: {}", padreId.value());
                        return new ResourceNotFoundException(
                                String.format("El catálogo padre con ID '%s' no existe", padreId.value()));
                    });
            catalogo.cambiarPadre(padreId);
        }

        // Actualizar nombre
        if (nombre != null || nombreEn != null) {
            String nuevoNombre = nombre != null ? nombre : catalogo.getNombre();
            catalogo.actualizarNombre(nuevoNombre, nombreEn);
        }

        // Actualizar descripción
        if (descripcion != null) {
            catalogo.actualizarDescripcion(descripcion);
        }

        if (descripcionEn != null) {
            catalogo.actualizarDescripcionEn(descripcionEn);
        }

        // Actualizar orden
        if (orden != null) {
            catalogo.actualizarOrden(orden);
        }

        // Actualizar icono
        if (icono != null) {
            catalogo.actualizarIcono(icono);
        }

        // Actualizar color
        if (color != null) {
            catalogo.actualizarColor(color);
        }

        // Actualizar estado activo
        if (activo != null) {
            if (activo && !catalogo.getActivo()) {
                catalogo.activar();
            } else if (!activo && catalogo.getActivo()) {
                catalogo.desactivar();
            }
        }

        // Actualizar seleccionable
        if (seleccionable != null) {
            if (seleccionable && !catalogo.getSeleccionable()) {
                catalogo.marcarComoSeleccionable();
            } else if (!seleccionable && catalogo.getSeleccionable()) {
                catalogo.marcarComoNoSeleccionable();
            }
        }

        // Actualizar metadatos
        if (metadatos != null) {
            catalogo.actualizarMetadatos(metadatos);
        }

        // Persistir cambios
        Catalogo catalogoActualizado = catalogoRepository.save(catalogo);

        log.info("Catálogo actualizado exitosamente - ID: {}", catalogoId.value());

        return CatalogoResponse.fromDomain(catalogoActualizado);
    }
}
