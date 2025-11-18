package com.mitoga.autenticacion.application.service;

import com.mitoga.autenticacion.domain.entity.Usuario;
import com.mitoga.autenticacion.domain.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 * Servicio transaccional para Usuario
 * 
 * <p>
 * Este servicio se creó específicamente para resolver problemas de Foreign Key Constraints
 * cuando se persisten entidades con relaciones en la misma transacción.
 * </p>
 * 
 * <p>
 * Al usar {@code @Transactional(propagation = Propagation.REQUIRES_NEW)}, garantizamos que:
 * </p>
 * <ul>
 * <li>El Usuario se persiste en una transacción INDEPENDIENTE</li>
 * <li>La transacción se COMMITEA inmediatamente después del save</li>
 * <li>El registro queda VISIBLE en la BD para transacciones posteriores</li>
 * <li>Otras entidades pueden referenciar la FK sin errores de constraint</li>
 * </ul>
 * 
 * <p>
 * <b>Caso de uso:</b> Registro multi-paso donde ProcesoRegistro tiene FK a Usuario
 * </p>
 * 
 * @author Backend Team MI-TOGA
 * @version 1.0.0
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class UsuarioTransactionalService {

    private final UsuarioRepository usuarioRepository;

    /**
     * Persiste un Usuario en una transacción INDEPENDIENTE.
     * 
     * <p>
     * Esta transacción se commitea inmediatamente, haciendo que el Usuario
     * esté disponible en la BD para otras transacciones que lo referencien.
     * </p>
     * 
     * @param usuario Entidad Usuario a persistir
     * @return Usuario persistido con ID generado
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public Usuario saveInNewTransaction(Usuario usuario) {
        Usuario savedUsuario = usuarioRepository.save(usuario);
        log.debug("🔒 Usuario {} persistido en transacción INDEPENDIENTE y committeado", 
                savedUsuario.getId().value());
        return savedUsuario;
    }
}
