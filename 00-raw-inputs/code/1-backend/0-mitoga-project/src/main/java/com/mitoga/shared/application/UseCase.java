package com.mitoga.shared.application;

/**
 * Marker interface for Use Cases (Input Ports in Hexagonal Architecture).
 * 
 * <p>
 * Un Use Case representa una acción que el usuario puede realizar en el
 * sistema.
 * Es un Input Port que define el contrato para ejecutar lógica de aplicación.
 * </p>
 * 
 * <p>
 * <b>Características de los Use Cases:</b>
 * </p>
 * <ul>
 * <li><b>Single Responsibility:</b> Cada use case hace UNA cosa</li>
 * <li><b>Independiente del framework:</b> No depende de Spring, REST, etc.</li>
 * <li><b>Orquestación:</b> Coordina el dominio, no contiene lógica de
 * negocio</li>
 * <li><b>Transaccional:</b> Normalmente anotado con @Transactional</li>
 * </ul>
 * 
 * <p>
 * <b>Patrón de implementación:</b>
 * </p>
 * 
 * <pre>
 * {
 *     &#64;code
 *     // Interface (Port)
 *     public interface RegistrarUsuarioUseCase extends UseCase<RegistroCommand, UsuarioResponse> {
 *         // Hereda execute() de UseCase
 *     }
 * 
 *     // Implementación (Service en Application Layer)
 *     &#64;Service
 *     &#64;Transactional
 *     public class RegistrarUsuarioService implements RegistrarUsuarioUseCase {
 * 
 *         private final UsuarioRepository usuarioRepository;
 *         private final PasswordHashPort passwordHashPort;
 *         private final EventPublisher eventPublisher;
 * 
 *         @Override
 *         public UsuarioResponse execute(RegistroCommand command) {
 *             // 1. Validar que email no existe
 *             if (usuarioRepository.existsByEmail(command.email())) {
 *                 throw new UsuarioYaExisteException(command.email());
 *             }
 * 
 *             // 2. Crear Aggregate Root
 *             Usuario usuario = Usuario.registrar(
 *                     Email.of(command.email()),
 *                     Password.hashear(command.password(), passwordHashPort),
 *                     command.nombre(),
 *                     command.apellido());
 * 
 *             // 3. Persistir
 *             usuario = usuarioRepository.save(usuario);
 * 
 *             // 4. Publicar Domain Events
 *             eventPublisher.publish(usuario.getDomainEvents());
 *             usuario.clearDomainEvents();
 * 
 *             // 5. Retornar DTO
 *             return UsuarioMapper.toResponse(usuario);
 *         }
 *     }
 * }
 * </pre>
 * 
 * @param <INPUT>  Tipo del comando/query de entrada (DTO)
 * @param <OUTPUT> Tipo de la respuesta (DTO)
 * 
 * @author MI-TOGA Development Team
 * @see Command
 * @see Query
 */
public interface UseCase<INPUT, OUTPUT> {

    /**
     * Ejecuta el caso de uso con el input dado.
     * 
     * @param input Comando o Query con los datos de entrada
     * @return Resultado de la ejecución (DTO)
     * @throws DomainException Si se violan reglas de negocio
     */
    OUTPUT execute(INPUT input);
}
