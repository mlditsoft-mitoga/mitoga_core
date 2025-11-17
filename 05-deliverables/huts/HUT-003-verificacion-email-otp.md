# HUT-003: Implementación de Verificación de Email con OTP

## 📋 Metadatos

| Atributo | Valor |
|----------|-------|
| **HU Origen** | HU-003 - Verificación de Email |
| **Bounded Context** | Autenticación |
| **Sprint** | Sprint 2 |
| **Story Points** | 5 (Fibonacci) |
| **Prioridad** | CRÍTICA |
| **Tipo** | Feature |
| **Dependencias** | HUT-001, HUT-002 |

---

## 🎯 Historia de Usuario Origen

**Como** usuario recién registrado (estudiante o tutor)  
**Quiero** verificar mi email mediante código OTP de 6 dígitos  
**Para** activar mi cuenta y acceder a la plataforma

### Criterios de Aceptación (Negocio)
- ✅ Código OTP de 6 dígitos numéricos
- ✅ TTL (Time To Live) de 10 minutos
- ✅ Máximo 3 intentos fallidos antes de bloqueo temporal
- ✅ Reenvío de código con cooldown de 60 segundos
- ✅ Email con plantilla profesional y responsive
- ✅ Activación automática de cuenta tras verificación exitosa
- ✅ Tokens JWT generados tras activación
- ✅ Logging de intentos de verificación (seguridad)

---

## 🏗️ Contexto Arquitectónico

### Patrón Arquitectónico
- **Arquitectura**: Hexagonal (Ports & Adapters)
- **Domain Event**: `EmailVerificadoEvent`
- **Cache**: Redis para almacenar OTP con TTL
- **Seguridad**: Rate limiting por IP y usuario

### ADRs Relacionados
- **[ADR-003]** Estrategia JWT + Refresh Token
- **[ADR-009]** Redis para cache distribuido
- **[ADR-017]** Rate limiting con Bucket4j
- **[ADR-018]** Plantillas de email con Thymeleaf

### Tecnologías
- **Backend**: Spring Boot 3.4.0, Java 21
- **Cache**: Redis 7.x (TTL automático)
- **Email**: SendGrid / AWS SES
- **Rate Limiting**: Bucket4j + Redis
- **Templates**: Thymeleaf

---

## 📊 Estructura de Datos

### Request: Verificar OTP

```json
POST /api/v1/auth/verificar-email

{
  "usuarioId": "650e8400-e29b-41d4-a716-446655440000",
  "email": "estudiante@example.com",
  "codigoOTP": "123456",
  "metadata": {
    "ipAddress": "192.168.1.100",
    "userAgent": "Mozilla/5.0...",
    "dispositivo": "web"
  }
}
```

### Response: Verificación Exitosa (200 OK)

```json
{
  "status": "success",
  "message": "Email verificado exitosamente. Bienvenido a Mi Toga.",
  "data": {
    "usuarioId": "650e8400-e29b-41d4-a716-446655440000",
    "email": "estudiante@example.com",
    "estadoAnterior": "PENDIENTE_VERIFICACION_EMAIL",
    "estadoActual": "ACTIVO",
    "fechaVerificacion": "2025-11-16T10:35:30.123Z",
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "tokenType": "Bearer",
      "expiresIn": 3600,
      "refreshExpiresIn": 604800
    },
    "perfil": {
      "nombreCompleto": "Juan Carlos Pérez García",
      "rol": "ESTUDIANTE",
      "fotoPerfil": "https://storage.mitoga.com/perfiles/650e8400.jpg"
    }
  },
  "timestamp": "2025-11-16T10:35:30.234Z"
}
```

### Response: Código Inválido (400 Bad Request)

```json
{
  "status": "error",
  "message": "Código OTP incorrecto",
  "data": {
    "intentosRestantes": 2,
    "bloqueadoHasta": null,
    "detalles": "El código ingresado no coincide. Verifica e intenta de nuevo."
  },
  "timestamp": "2025-11-16T10:35:30.234Z"
}
```

### Response: Código Expirado (410 Gone)

```json
{
  "status": "error",
  "message": "Código OTP expirado",
  "data": {
    "expiroHace": "5 minutos",
    "puedeReenviar": true,
    "cooldownSegundos": 0,
    "detalles": "El código ha caducado. Solicita uno nuevo."
  },
  "timestamp": "2025-11-16T10:35:30.234Z"
}
```

### Response: Usuario Bloqueado (429 Too Many Requests)

```json
{
  "status": "error",
  "message": "Demasiados intentos fallidos",
  "data": {
    "bloqueadoHasta": "2025-11-16T10:50:00Z",
    "minutosRestantes": 15,
    "razon": "Excediste el límite de 3 intentos. Por seguridad, tu cuenta está temporalmente bloqueada.",
    "contactoSoporte": "soporte@mitoga.com"
  },
  "timestamp": "2025-11-16T10:35:30.234Z"
}
```

### Request: Reenviar OTP

```json
POST /api/v1/auth/reenviar-otp

{
  "usuarioId": "650e8400-e29b-41d4-a716-446655440000",
  "email": "estudiante@example.com",
  "metadata": {
    "ipAddress": "192.168.1.100",
    "userAgent": "Mozilla/5.0...",
    "dispositivo": "web"
  }
}
```

### Response: OTP Reenviado (200 OK)

```json
{
  "status": "success",
  "message": "Código OTP reenviado exitosamente",
  "data": {
    "emailEnviadoA": "est***nte@example.com",
    "expiraEn": "2025-11-16T10:45:30Z",
    "proximoReenvioEn": 60,
    "intentosReenvioRestantes": 4
  },
  "timestamp": "2025-11-16T10:35:30.234Z"
}
```

---

## 📊 Modelo de Datos Redis

### Key-Value Structure (OTP Storage)

```redis
# Key pattern: otp:{usuarioId}
KEY: otp:650e8400-e29b-41d4-a716-446655440000
VALUE: {
  "codigo": "123456",
  "email": "estudiante@example.com",
  "intentosFallidos": 0,
  "creadoEn": "2025-11-16T10:30:00.000Z",
  "expiraEn": "2025-11-16T10:40:00.000Z"
}
TTL: 600 segundos (10 minutos)

# Key pattern: otp:attempts:{usuarioId}
KEY: otp:attempts:650e8400-e29b-41d4-a716-446655440000
VALUE: 2
TTL: 600 segundos

# Key pattern: otp:block:{usuarioId}
KEY: otp:block:650e8400-e29b-41d4-a716-446655440000
VALUE: "2025-11-16T10:50:00Z"
TTL: 900 segundos (15 minutos)

# Key pattern: otp:resend:cooldown:{usuarioId}
KEY: otp:resend:cooldown:650e8400-e29b-41d4-a716-446655440000
VALUE: "1"
TTL: 60 segundos
```

---

## 🔧 Tareas Técnicas Detalladas

### 📦 BACKEND TASKS

#### TAREA-003-BE-01: Implementar Servicio OTP en Domain Layer [4h]

**Descripción**: Lógica de negocio para generación y validación de OTP

**Archivos**:
- `domain/autenticacion/CodigoOTP.java` (Value Object)
- `domain/autenticacion/VerificacionEmail.java` (Domain Service)
- `domain/autenticacion/events/EmailVerificadoEvent.java`

**Implementación**:
```java
package com.mitoga.domain.autenticacion;

// Value Object: Código OTP
public record CodigoOTP(String valor) {
    
    private static final int LONGITUD = 6;
    private static final SecureRandom RANDOM = new SecureRandom();
    
    public CodigoOTP {
        Objects.requireNonNull(valor, "Código OTP no puede ser nulo");
        if (!valor.matches("^\\d{6}$")) {
            throw new IllegalArgumentException("Código OTP debe ser de 6 dígitos numéricos");
        }
    }
    
    public static CodigoOTP generar() {
        int codigo = RANDOM.nextInt(900000) + 100000; // 100000-999999
        return new CodigoOTP(String.valueOf(codigo));
    }
    
    public static CodigoOTP of(String valor) {
        return new CodigoOTP(valor);
    }
    
    public boolean coincideCon(String otroValor) {
        return this.valor.equals(otroValor);
    }
}

// Domain Service
@DomainService
public class VerificacionEmailService {
    
    private static final int MAX_INTENTOS = 3;
    private static final Duration DURACION_BLOQUEO = Duration.ofMinutes(15);
    
    public ResultadoVerificacion verificar(
            Usuario usuario, 
            CodigoOTP codigoIngresado,
            OTPStoragePort otpStorage) {
        
        // 1. Verificar si usuario está bloqueado
        if (otpStorage.estaBloqueado(usuario.getId())) {
            Duration tiempoRestante = otpStorage.tiempoBloqueoRestante(usuario.getId());
            throw new UsuarioBloqueadoException(tiempoRestante);
        }
        
        // 2. Obtener OTP almacenado
        Optional<OTPAlmacenado> otpOpt = otpStorage.obtener(usuario.getId());
        if (otpOpt.isEmpty()) {
            throw new OTPNoEncontradoException("Código no encontrado o expirado");
        }
        
        OTPAlmacenado otpAlmacenado = otpOpt.get();
        
        // 3. Verificar expiración
        if (otpAlmacenado.haExpirado()) {
            otpStorage.eliminar(usuario.getId());
            throw new OTPExpiradoException();
        }
        
        // 4. Validar código
        if (!otpAlmacenado.getCodigo().coincideCon(codigoIngresado.valor())) {
            // Incrementar intentos fallidos
            int intentosActuales = otpStorage.incrementarIntentosFallidos(usuario.getId());
            
            if (intentosActuales >= MAX_INTENTOS) {
                // Bloquear usuario
                otpStorage.bloquear(usuario.getId(), DURACION_BLOQUEO);
                otpStorage.eliminar(usuario.getId());
                throw new MaximosIntentosExcedidosException(DURACION_BLOQUEO);
            }
            
            throw new CodigoOTPInvalidoException(MAX_INTENTOS - intentosActuales);
        }
        
        // 5. Código válido - Activar usuario
        usuario.verificarEmail();
        otpStorage.eliminar(usuario.getId());
        otpStorage.limpiarBloqueo(usuario.getId());
        
        // 6. Publicar Domain Event
        return ResultadoVerificacion.exitoso(usuario);
    }
    
    public CodigoOTP generarYAlmacenar(
            Usuario usuario,
            OTPStoragePort otpStorage,
            Duration ttl) {
        
        CodigoOTP codigo = CodigoOTP.generar();
        
        OTPAlmacenado otp = OTPAlmacenado.crear(
            usuario.getId(),
            usuario.getEmail(),
            codigo,
            ttl
        );
        
        otpStorage.guardar(otp);
        
        return codigo;
    }
}

// Domain Event
public record EmailVerificadoEvent(
    UUID usuarioId,
    String email,
    Instant fechaVerificacion
) implements DomainEvent {
    
    @Override
    public Instant occurredOn() {
        return fechaVerificacion;
    }
}
```

**Criterios Técnicos**:
- [ ] Value Object CodigoOTP inmutable
- [ ] Generación criptográficamente segura (SecureRandom)
- [ ] Validaciones de negocio en domain layer
- [ ] Domain Events para desacoplamiento
- [ ] Tests unitarios >95% coverage
- [ ] Sin dependencias de infraestructura

**Tests**:
```java
@Test
void testGenerarCodigoOTPValido() {
    CodigoOTP codigo = CodigoOTP.generar();
    
    assertNotNull(codigo);
    assertTrue(codigo.valor().matches("^\\d{6}$"));
    assertTrue(Integer.parseInt(codigo.valor()) >= 100000);
    assertTrue(Integer.parseInt(codigo.valor()) <= 999999);
}

@Test
void testCodigoInvalidoLanzaException() {
    assertThrows(IllegalArgumentException.class, () -> {
        CodigoOTP.of("12345"); // Solo 5 dígitos
    });
    
    assertThrows(IllegalArgumentException.class, () -> {
        CodigoOTP.of("abc123"); // Contiene letras
    });
}

@Test
void testVerificacionExitosaActivaUsuario() {
    Usuario usuario = crearUsuarioPendiente();
    CodigoOTP codigoReal = CodigoOTP.of("123456");
    OTPStoragePort mockStorage = mock(OTPStoragePort.class);
    
    when(mockStorage.obtener(usuario.getId()))
        .thenReturn(Optional.of(crearOTPAlmacenado(codigoReal)));
    
    VerificacionEmailService service = new VerificacionEmailService();
    ResultadoVerificacion resultado = service.verificar(usuario, codigoReal, mockStorage);
    
    assertTrue(resultado.esExitoso());
    assertEquals(EstadoUsuario.ACTIVO, usuario.getEstado());
    verify(mockStorage).eliminar(usuario.getId());
}

@Test
void testTresIntentosInvalidosBloqueaUsuario() {
    Usuario usuario = crearUsuarioPendiente();
    CodigoOTP codigoReal = CodigoOTP.of("123456");
    CodigoOTP codigoIncorrecto = CodigoOTP.of("654321");
    OTPStoragePort mockStorage = mock(OTPStoragePort.class);
    
    when(mockStorage.obtener(any())).thenReturn(Optional.of(crearOTPAlmacenado(codigoReal)));
    when(mockStorage.incrementarIntentosFallidos(any())).thenReturn(1, 2, 3);
    
    VerificacionEmailService service = new VerificacionEmailService();
    
    // Intentos 1 y 2
    assertThrows(CodigoOTPInvalidoException.class, () -> {
        service.verificar(usuario, codigoIncorrecto, mockStorage);
    });
    assertThrows(CodigoOTPInvalidoException.class, () -> {
        service.verificar(usuario, codigoIncorrecto, mockStorage);
    });
    
    // Intento 3 - Bloqueo
    assertThrows(MaximosIntentosExcedidosException.class, () -> {
        service.verificar(usuario, codigoIncorrecto, mockStorage);
    });
    
    verify(mockStorage).bloquear(eq(usuario.getId()), any(Duration.class));
}
```

---

#### TAREA-003-BE-02: Implementar Adapter Redis para OTP [3h]

**Descripción**: Puerto de salida para almacenar OTP en Redis con TTL

**Archivos**:
- `infrastructure/cache/RedisOTPAdapter.java`
- `infrastructure/cache/OTPRedisEntity.java`
- `application/ports/out/OTPStoragePort.java`

**Implementación**:
```java
@Component
@RequiredArgsConstructor
public class RedisOTPAdapter implements OTPStoragePort {
    
    private static final String OTP_KEY_PREFIX = "otp:";
    private static final String ATTEMPTS_KEY_PREFIX = "otp:attempts:";
    private static final String BLOCK_KEY_PREFIX = "otp:block:";
    private static final String COOLDOWN_KEY_PREFIX = "otp:resend:cooldown:";
    
    private final RedisTemplate<String, Object> redisTemplate;
    private final ObjectMapper objectMapper;
    
    @Override
    public void guardar(OTPAlmacenado otp) {
        String key = OTP_KEY_PREFIX + otp.getUsuarioId();
        
        OTPRedisEntity entity = OTPRedisEntity.from(otp);
        
        redisTemplate.opsForValue().set(
            key,
            entity,
            otp.getTtl().getSeconds(),
            TimeUnit.SECONDS
        );
        
        // Resetear intentos
        String attemptsKey = ATTEMPTS_KEY_PREFIX + otp.getUsuarioId();
        redisTemplate.delete(attemptsKey);
    }
    
    @Override
    public Optional<OTPAlmacenado> obtener(UsuarioId usuarioId) {
        String key = OTP_KEY_PREFIX + usuarioId.getValue();
        
        OTPRedisEntity entity = (OTPRedisEntity) redisTemplate.opsForValue().get(key);
        
        return Optional.ofNullable(entity)
            .map(OTPRedisEntity::toDomain);
    }
    
    @Override
    public void eliminar(UsuarioId usuarioId) {
        String key = OTP_KEY_PREFIX + usuarioId.getValue();
        redisTemplate.delete(key);
    }
    
    @Override
    public int incrementarIntentosFallidos(UsuarioId usuarioId) {
        String key = ATTEMPTS_KEY_PREFIX + usuarioId.getValue();
        
        Long intentos = redisTemplate.opsForValue().increment(key);
        
        // Establecer TTL si es el primer intento
        if (intentos == 1) {
            redisTemplate.expire(key, 10, TimeUnit.MINUTES);
        }
        
        return intentos.intValue();
    }
    
    @Override
    public void bloquear(UsuarioId usuarioId, Duration duracion) {
        String key = BLOCK_KEY_PREFIX + usuarioId.getValue();
        
        Instant bloqueadoHasta = Instant.now().plus(duracion);
        
        redisTemplate.opsForValue().set(
            key,
            bloqueadoHasta.toString(),
            duracion.getSeconds(),
            TimeUnit.SECONDS
        );
    }
    
    @Override
    public boolean estaBloqueado(UsuarioId usuarioId) {
        String key = BLOCK_KEY_PREFIX + usuarioId.getValue();
        return Boolean.TRUE.equals(redisTemplate.hasKey(key));
    }
    
    @Override
    public Duration tiempoBloqueoRestante(UsuarioId usuarioId) {
        String key = BLOCK_KEY_PREFIX + usuarioId.getValue();
        
        String bloqueadoHastaStr = (String) redisTemplate.opsForValue().get(key);
        if (bloqueadoHastaStr == null) {
            return Duration.ZERO;
        }
        
        Instant bloqueadoHasta = Instant.parse(bloqueadoHastaStr);
        Instant ahora = Instant.now();
        
        return Duration.between(ahora, bloqueadoHasta);
    }
    
    @Override
    public void limpiarBloqueo(UsuarioId usuarioId) {
        String blockKey = BLOCK_KEY_PREFIX + usuarioId.getValue();
        String attemptsKey = ATTEMPTS_KEY_PREFIX + usuarioId.getValue();
        
        redisTemplate.delete(blockKey);
        redisTemplate.delete(attemptsKey);
    }
    
    @Override
    public boolean puedeReenviar(UsuarioId usuarioId) {
        String key = COOLDOWN_KEY_PREFIX + usuarioId.getValue();
        return !Boolean.TRUE.equals(redisTemplate.hasKey(key));
    }
    
    @Override
    public void marcarReenviado(UsuarioId usuarioId, Duration cooldown) {
        String key = COOLDOWN_KEY_PREFIX + usuarioId.getValue();
        
        redisTemplate.opsForValue().set(
            key,
            "1",
            cooldown.getSeconds(),
            TimeUnit.SECONDS
        );
    }
}

// Redis Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class OTPRedisEntity {
    private String codigo;
    private String email;
    private String usuarioId;
    private int intentosFallidos;
    private Instant creadoEn;
    private Instant expiraEn;
    
    public static OTPRedisEntity from(OTPAlmacenado otp) {
        return new OTPRedisEntity(
            otp.getCodigo().valor(),
            otp.getEmail().getValue(),
            otp.getUsuarioId().getValue().toString(),
            0,
            otp.getCreadoEn(),
            otp.getExpiraEn()
        );
    }
    
    public OTPAlmacenado toDomain() {
        return new OTPAlmacenado(
            UsuarioId.of(UUID.fromString(usuarioId)),
            Email.of(email),
            CodigoOTP.of(codigo),
            creadoEn,
            expiraEn
        );
    }
}
```

**Criterios**:
- [ ] TTL automático en Redis
- [ ] Serialización/deserialización correcta
- [ ] Manejo de keys con prefijos claros
- [ ] Tests de integración con Testcontainers Redis
- [ ] Logging de operaciones críticas

---

#### TAREA-003-BE-03: Implementar Use Cases [4h]

**Archivos**:
- `application/usecases/autenticacion/VerificarEmailUseCase.java`
- `application/usecases/autenticacion/ReenviarOTPUseCase.java`
- `application/ports/in/VerificarEmailCommand.java`

**Implementación**:
```java
@UseCase
@Transactional
@RequiredArgsConstructor
public class VerificarEmailUseCase {
    
    private final UsuarioRepositoryPort usuarioRepository;
    private final OTPStoragePort otpStorage;
    private final VerificacionEmailService verificacionService;
    private final JwtTokenPort tokenProvider;
    private final EventPublisher eventPublisher;
    
    public VerificarEmailResponse ejecutar(VerificarEmailCommand command) {
        
        // 1. Buscar usuario
        Usuario usuario = usuarioRepository.findById(command.usuarioId())
            .orElseThrow(() -> new UsuarioNoEncontradoException(command.usuarioId()));
        
        // 2. Validar estado
        if (usuario.getEstado() == EstadoUsuario.ACTIVO) {
            throw new EmailYaVerificadoException("Email ya fue verificado previamente");
        }
        
        // 3. Verificar código OTP
        CodigoOTP codigoIngresado = CodigoOTP.of(command.codigoOTP());
        
        ResultadoVerificacion resultado = verificacionService.verificar(
            usuario,
            codigoIngresado,
            otpStorage
        );
        
        // 4. Persistir cambio de estado
        usuario = usuarioRepository.save(usuario);
        
        // 5. Generar tokens JWT
        TokenPair tokens = tokenProvider.generarTokens(
            usuario.getId(),
            usuario.getEmail(),
            usuario.getRol()
        );
        
        // 6. Publicar evento de dominio
        eventPublisher.publish(new EmailVerificadoEvent(
            usuario.getId().getValue(),
            usuario.getEmail().getValue(),
            Instant.now()
        ));
        
        // 7. Log de auditoría
        log.info("Email verificado exitosamente - Usuario: {}, IP: {}", 
            usuario.getEmail().getValue(), 
            command.metadata().ipAddress());
        
        return VerificarEmailResponse.of(usuario, tokens);
    }
}

@UseCase
@RequiredArgsConstructor
public class ReenviarOTPUseCase {
    
    private static final Duration COOLDOWN = Duration.ofSeconds(60);
    private static final Duration OTP_TTL = Duration.ofMinutes(10);
    private static final int MAX_REENVIOS = 5;
    
    private final UsuarioRepositoryPort usuarioRepository;
    private final OTPStoragePort otpStorage;
    private final VerificacionEmailService verificacionService;
    private final EmailServicePort emailService;
    
    public ReenviarOTPResponse ejecutar(ReenviarOTPCommand command) {
        
        // 1. Validar cooldown
        if (!otpStorage.puedeReenviar(command.usuarioId())) {
            throw new CooldownActivoException("Debes esperar 60 segundos antes de reenviar");
        }
        
        // 2. Buscar usuario
        Usuario usuario = usuarioRepository.findById(command.usuarioId())
            .orElseThrow(() -> new UsuarioNoEncontradoException(command.usuarioId()));
        
        // 3. Generar nuevo OTP
        CodigoOTP nuevoOTP = verificacionService.generarYAlmacenar(
            usuario,
            otpStorage,
            OTP_TTL
        );
        
        // 4. Enviar email
        emailService.enviarCodigoVerificacion(
            usuario.getEmail().getValue(),
            nuevoOTP.valor()
        );
        
        // 5. Marcar cooldown
        otpStorage.marcarReenviado(command.usuarioId(), COOLDOWN);
        
        // 6. Log de auditoría
        log.info("OTP reenviado - Usuario: {}, IP: {}", 
            usuario.getEmail().getValue(),
            command.metadata().ipAddress());
        
        return ReenviarOTPResponse.of(usuario, OTP_TTL, COOLDOWN);
    }
}
```

**Criterios**:
- [ ] Transaccional
- [ ] Validaciones previas (estado usuario, cooldown)
- [ ] Generación de tokens JWT tras verificación
- [ ] Publicación de eventos de dominio
- [ ] Logging de auditoría (seguridad)
- [ ] Tests con mocks >85% coverage

---

#### TAREA-003-BE-04: Implementar REST Controllers [2h]

**Archivos**:
- `infrastructure/web/VerificacionEmailController.java`
- `infrastructure/web/dto/VerificarEmailRequest.java`

**Endpoints**:
```java
@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
@Validated
public class VerificacionEmailController {
    
    private final VerificarEmailUseCase verificarUseCase;
    private final ReenviarOTPUseCase reenviarUseCase;
    
    @PostMapping("/verificar-email")
    public ResponseEntity<ApiResponse<VerificarEmailResponse>> verificar(
            @Valid @RequestBody VerificarEmailRequest request,
            @RequestHeader("X-Real-IP") String ip,
            @RequestHeader("User-Agent") String userAgent) {
        
        VerificarEmailCommand command = request.toCommand()
            .withMetadata(ip, userAgent);
        
        VerificarEmailResponse response = verificarUseCase.ejecutar(command);
        
        return ResponseEntity.ok(
            ApiResponse.success(response, "Email verificado exitosamente. Bienvenido a Mi Toga.")
        );
    }
    
    @PostMapping("/reenviar-otp")
    public ResponseEntity<ApiResponse<ReenviarOTPResponse>> reenviar(
            @Valid @RequestBody ReenviarOTPRequest request,
            @RequestHeader("X-Real-IP") String ip,
            @RequestHeader("User-Agent") String userAgent) {
        
        ReenviarOTPCommand command = request.toCommand()
            .withMetadata(ip, userAgent);
        
        ReenviarOTPResponse response = reenviarUseCase.ejecutar(command);
        
        return ResponseEntity.ok(
            ApiResponse.success(response, "Código OTP reenviado exitosamente")
        );
    }
}

// DTOs
public record VerificarEmailRequest(
    @NotNull UUID usuarioId,
    @NotBlank @Email String email,
    @NotBlank @Pattern(regexp = "^\\d{6}$") String codigoOTP
) {
    public VerificarEmailCommand toCommand() {
        return new VerificarEmailCommand(
            UsuarioId.of(usuarioId),
            email,
            codigoOTP
        );
    }
}
```

**Exception Handler**:
```java
@ControllerAdvice
public class VerificacionEmailExceptionHandler {
    
    @ExceptionHandler(CodigoOTPInvalidoException.class)
    public ResponseEntity<ApiResponse<Map<String, Object>>> handleCodigoInvalido(
            CodigoOTPInvalidoException ex) {
        
        Map<String, Object> data = Map.of(
            "intentosRestantes", ex.getIntentosRestantes(),
            "bloqueadoHasta", null,
            "detalles", "El código ingresado no coincide. Verifica e intenta de nuevo."
        );
        
        return ResponseEntity
            .badRequest()
            .body(ApiResponse.error("Código OTP incorrecto", data));
    }
    
    @ExceptionHandler(OTPExpiradoException.class)
    public ResponseEntity<ApiResponse<Map<String, Object>>> handleOTPExpirado(
            OTPExpiradoException ex) {
        
        Map<String, Object> data = Map.of(
            "expiroHace", ex.getTiempoExpirado(),
            "puedeReenviar", true,
            "cooldownSegundos", 0,
            "detalles", "El código ha caducado. Solicita uno nuevo."
        );
        
        return ResponseEntity
            .status(HttpStatus.GONE)
            .body(ApiResponse.error("Código OTP expirado", data));
    }
    
    @ExceptionHandler(MaximosIntentosExcedidosException.class)
    public ResponseEntity<ApiResponse<Map<String, Object>>> handleMaximosIntentos(
            MaximosIntentosExcedidosException ex) {
        
        Map<String, Object> data = Map.of(
            "bloqueadoHasta", ex.getBloqueadoHasta(),
            "minutosRestantes", ex.getMinutosRestantes(),
            "razon", "Excediste el límite de 3 intentos. Por seguridad, tu cuenta está temporalmente bloqueada.",
            "contactoSoporte", "soporte@mitoga.com"
        );
        
        return ResponseEntity
            .status(HttpStatus.TOO_MANY_REQUESTS)
            .body(ApiResponse.error("Demasiados intentos fallidos", data));
    }
}
```

**Criterios**:
- [ ] Endpoints RESTful semánticos
- [ ] Validación con Bean Validation
- [ ] Exception handlers específicos por error
- [ ] HTTP status codes correctos (200, 400, 410, 429)
- [ ] Documentación OpenAPI
- [ ] Rate limiting por IP (Bucket4j)

---

### 🎨 FRONTEND TASKS

#### TAREA-003-FE-01: Componente Modal OTP [3h]

**Archivos**:
- `components/auth/OTPVerificationModal.tsx`
- `hooks/useOTPVerification.ts`

**Implementación**:
```typescript
interface OTPVerificationModalProps {
  isOpen: boolean;
  email: string;
  usuarioId: string;
  onSuccess: (tokens: TokenPair) => void;
  onClose: () => void;
}

export function OTPVerificationModal({ 
  isOpen, 
  email, 
  usuarioId, 
  onSuccess, 
  onClose 
}: OTPVerificationModalProps) {
  
  const [otpCode, setOtpCode] = useState(['', '', '', '', '', '']);
  const [cooldownSeconds, setCooldownSeconds] = useState(0);
  const inputRefs = useRef<(HTMLInputElement | null)[]>([]);
  
  const { mutate: verificar, isLoading, error } = useMutation({
    mutationFn: (data: VerificarEmailData) => authService.verificarEmail(data),
    onSuccess: (response) => {
      toast.success('¡Email verificado! Bienvenido a Mi Toga');
      onSuccess(response.data.tokens);
    },
    onError: (error: ApiError) => {
      if (error.status === 429) {
        toast.error(`Cuenta bloqueada por ${error.data.minutosRestantes} minutos`);
      } else if (error.status === 410) {
        toast.error('Código expirado. Solicita uno nuevo');
      } else {
        toast.error(error.message);
      }
    }
  });
  
  const { mutate: reenviar } = useMutation({
    mutationFn: () => authService.reenviarOTP({ usuarioId, email }),
    onSuccess: () => {
      toast.success('Código reenviado. Revisa tu email');
      setCooldownSeconds(60);
      setOtpCode(['', '', '', '', '', '']);
    }
  });
  
  // Cooldown timer
  useEffect(() => {
    if (cooldownSeconds > 0) {
      const timer = setTimeout(() => {
        setCooldownSeconds(prev => prev - 1);
      }, 1000);
      return () => clearTimeout(timer);
    }
  }, [cooldownSeconds]);
  
  const handleSubmit = () => {
    const codigo = otpCode.join('');
    if (codigo.length === 6) {
      verificar({ usuarioId, email, codigoOTP: codigo });
    }
  };
  
  const handleChange = (index: number, value: string) => {
    if (!/^\d*$/.test(value)) return;
    
    const newOTP = [...otpCode];
    newOTP[index] = value.slice(-1);
    setOtpCode(newOTP);
    
    // Auto-focus next input
    if (value && index < 5) {
      inputRefs.current[index + 1]?.focus();
    }
  };
  
  const handlePaste = (e: React.ClipboardEvent) => {
    e.preventDefault();
    const pastedData = e.clipboardData.getData('text').slice(0, 6);
    if (!/^\d+$/.test(pastedData)) return;
    
    const newOTP = [...otpCode];
    for (let i = 0; i < pastedData.length && i < 6; i++) {
      newOTP[i] = pastedData[i];
    }
    setOtpCode(newOTP);
  };
  
  return (
    <Modal isOpen={isOpen} onClose={onClose}>
      {/* Modal content con inputs de 6 dígitos */}
      <div className="flex gap-3 justify-center" onPaste={handlePaste}>
        {otpCode.map((digit, index) => (
          <input
            key={index}
            ref={el => inputRefs.current[index] = el}
            type="text"
            inputMode="numeric"
            maxLength={1}
            value={digit}
            onChange={(e) => handleChange(index, e.target.value)}
            className="w-14 h-16 text-center text-3xl font-bold rounded-xl border-2"
          />
        ))}
      </div>
      
      <button
        onClick={handleSubmit}
        disabled={isLoading || otpCode.some(d => !d)}
        className="w-full btn-primary"
      >
        {isLoading ? 'Verificando...' : 'Verificar código'}
      </button>
      
      <button
        onClick={() => reenviar()}
        disabled={cooldownSeconds > 0}
        className="w-full btn-secondary"
      >
        {cooldownSeconds > 0 
          ? `Reenviar en ${cooldownSeconds}s` 
          : 'Reenviar código'}
      </button>
    </Modal>
  );
}
```

**Criterios**:
- [ ] 6 inputs independientes con auto-focus
- [ ] Soporte de paste (pegar código completo)
- [ ] Cooldown de 60s para reenvío
- [ ] Manejo de errores específico (400, 410, 429)
- [ ] Loading states
- [ ] Accesibilidad (ARIA labels)

---

## 📊 Estimación Consolidada

| Tarea | Esfuerzo | Rol |
|-------|----------|-----|
| Backend Domain Service OTP | 4h | Backend Dev |
| Backend Redis Adapter | 3h | Backend Dev |
| Backend Use Cases | 4h | Backend Dev |
| Backend REST Controllers | 2h | Backend Dev |
| Frontend Modal OTP | 3h | Frontend Dev |
| Plantilla Email Thymeleaf | 2h | Frontend Dev |
| Tests E2E | 2h | QA Engineer |
| **TOTAL** | **20h** | **~3 días** |

**Story Points**: 5 (Fibonacci)

---

## ✅ Definition of Done

### Backend:
- [ ] Redis configurado con TTL automático
- [ ] Rate limiting implementado (Bucket4j)
- [ ] Domain events publicados
- [ ] Logging de auditoría completo
- [ ] Tests de integración con Testcontainers Redis

### Frontend:
- [ ] Modal OTP funcional con 6 inputs
- [ ] Cooldown visual de 60s
- [ ] Manejo de errores UX-friendly
- [ ] Tests unitarios >80%
- [ ] Accesibilidad validada

### Email:
- [ ] Plantilla responsive Thymeleaf
- [ ] SendGrid/AWS SES configurado
- [ ] Email de bienvenida post-verificación

---

**Versión**: 1.0  
**Fecha**: 2025-11-16  
**Autor**: Technical User Stories Engineer  
**Metodología**: ZNS v2.0
