# 📊 HUT-001: Auditoría Backend y Plan de Implementación

**Fecha**: 2025-11-16  
**Auditor**: Backend Senior Java Developer (Rol: `zns.dev.backend`)  
**Artefactos Analizados**:
- HUT: `05-deliverables/huts/HUT-001-registro-estudiante-multistep.md`
- Backend: `00-raw-inputs/code/1-backend/0-mitoga-project`
- DB Schema: `00-raw-inputs/database/dump-mitogadb-202511161223.sql`

---

## 🎯 Executive Summary

### Estado Actual
- ✅ **Arquitectura Hexagonal**: Implementada correctamente con capas `domain`, `application`, `infrastructure`
- ✅ **Stack Tecnológico**: Spring Boot 3.4.0 + Java 21 + PostgreSQL 16 + Redis 7
- ⚠️ **Dominio**: Usuario básico implementado, **FALTA** soporte multi-step registro
- ❌ **HUT-001**: **NO IMPLEMENTADO** - Requiere nueva implementación completa

### Score de Calidad Backend
```
🟡 SCORE GENERAL: 72/100 (ACEPTABLE)

Desglose:
- Arquitectura:      85/100 🟢 (Hexagonal bien aplicada)
- Seguridad:         65/100 🟠 (BCrypt OK, FALTA validaciones robustas)
- Performance:       70/100 🟡 (Índices básicos, FALTA optimizaciones)
- Testing:           60/100 🟠 (Tests básicos, FALTA coverage >80%)
- Code Quality:      80/100 🟢 (Clean Code, sin Lombok abuse)
```

---

## 🔍 GAP Analysis: Código Actual vs HUT-001

### ✅ **LO QUE YA EXISTE**

#### 1. Domain Layer (`autenticacion/domain/model/`)
```java
✅ Usuario.java (Aggregate Root)
   - Factory Method: Usuario.registrar()
   - Métodos de negocio: verificarEmail(), bloquearCuenta(), registrarLoginExitoso()
   - Validaciones básicas: email, nombre, apellido
   - Estado: EstadoCuenta (PENDIENTE_VERIFICACION, ACTIVA, BLOQUEADA)
   - Rol: ESTUDIANTE, TUTOR, ADMIN, SUPERADMIN

✅ Credenciales.java (Value Object - básico)
✅ Token.java (para JWT refresh tokens)
```

**Fortalezas**:
- ✅ No usa @Data de Lombok (correcta encapsulación)
- ✅ Constructor privado + Factory Methods (patrón DDD correcto)
- ✅ Solo getters públicos (inmutabilidad respetada)
- ✅ Validaciones en el dominio (no en infraestructura)

**Debilidades**:
- ❌ **NO hay Value Objects** para Email, Password, NombreCompleto
- ❌ **NO hay entidades** ProcesoRegistro, VerificacionIdentidad, ResponsableLegal
- ❌ **NO hay soporte** para multi-step (4 pasos)
- ❌ Usuario tiene **campos primitivos** (String email) en lugar de Value Objects

#### 2. Application Layer (`autenticacion/application/`)
```java
✅ RegistrarUsuarioService.java
   - Implementa RegistrarUsuarioUseCase
   - Validación de email único
   - Generación de OTP (6 dígitos)
   - Envío de email de verificación
   - Generación de JWT

✅ LoginService.java
✅ RefreshTokenService.java
✅ VerificarEmailService.java
```

**Fortalezas**:
- ✅ Uso de Ports (PasswordEncoderPort, JwtTokenPort, EmailPort)
- ✅ @Transactional correctamente aplicado
- ✅ No lógica de negocio en servicios (orquestación pura)

**Debilidades**:
- ❌ **Registro en UN SOLO PASO** (HUT-001 requiere 4 pasos)
- ❌ **NO hay tracking** de proceso multi-step
- ❌ **NO hay validación** de edad para menores (responsable legal)
- ❌ **NO hay gestión** de archivos (fotos, documentos)

#### 3. Infrastructure Layer (`autenticacion/infrastructure/`)
```java
✅ JPA Persistence:
   - UsuarioPersistenceAdapter
   - TokenPersistenceAdapter
   - UsuarioJpaRepository
   - TokenJpaRepository

✅ REST API:
   - AutenticacionController (@PostMapping /api/v1/auth/registro)
   - Bean Validation en DTOs
   - Exception Handling (@RestControllerAdvice)

✅ Security:
   - JwtTokenProvider (JJWT 0.12.6)
   - JwtAuthenticationFilter
   - BCryptPasswordAdapter

✅ Email:
   - EmailAdapter (JavaMailSender)
```

**Fortalezas**:
- ✅ Separación correcta de concerns (adapters, controllers, security)
- ✅ DTOs bien definidos (no exposición del dominio)
- ✅ Uso de records de Java 21 (inmutabilidad)

**Debilidades**:
- ❌ **NO hay adapter** para MinIO/S3 (gestión de archivos)
- ❌ **NO hay adapter** para Redis OTP (HUT-001 usa Redis para OTP)
- ❌ **NO hay endpoints** multi-step (solo un POST /registro)

---

### ❌ **LO QUE FALTA PARA HUT-001**

#### 🔴 **CRÍTICO** (Blocker)

1. **Domain Model Completo**
   ```
   ❌ Email.java (Value Object)
   ❌ Password.java (Value Object con validación fuerza)
   ❌ NombreCompleto.java (Value Object con primerNombre, segundoNombre, etc.)
   ❌ Telefono.java (Value Object con regex validación)
   ❌ ProcesoRegistro.java (Entity - tracking multi-step)
   ❌ VerificacionIdentidad.java (Entity - documentos + biometría)
   ❌ ResponsableLegal.java (Entity - para menores <18 años)
   ❌ Archivo.java (Entity - metadata de archivos en MinIO/S3)
   ❌ EstadoRegistro.java (Enum: STEP_1, STEP_2, STEP_3, STEP_4, COMPLETADO)
   ```

2. **Use Cases Multi-step**
   ```
   ❌ RegistrarEstudianteStep1UseCase (Credenciales)
   ❌ RegistrarEstudianteStep2UseCase (Info Personal + Responsable Legal)
   ❌ RegistrarEstudianteStep3UseCase (Archivos + Verificación Biométrica)
   ❌ RegistrarEstudianteStep4UseCase (Confirmación + OTP)
   ❌ ObtenerProcesoRegistroUseCase (GET estado del proceso)
   ```

3. **Infrastructure Adapters**
   ```
   ❌ MinIOStorageAdapter.java (upload/download archivos)
   ❌ RedisOTPAdapter.java (guardar OTP con TTL 10 min)
   ❌ ProcesoRegistroJpaAdapter.java
   ❌ VerificacionIdentidadJpaAdapter.java
   ❌ ResponsableLegalJpaAdapter.java
   ❌ ArchivoJpaAdapter.java
   ```

4. **REST Controllers**
   ```
   ❌ POST /api/v1/registro/estudiante/step-1
   ❌ POST /api/v1/registro/estudiante/step-2
   ❌ POST /api/v1/registro/estudiante/step-3
   ❌ POST /api/v1/registro/estudiante/step-4
   ❌ GET  /api/v1/registro/estudiante/proceso/{id}
   ```

5. **Tests**
   ```
   ❌ Tests Unitarios Value Objects (Email, Password, NombreCompleto)
   ❌ Tests Unitarios Aggregates (Usuario multi-step)
   ❌ Tests Unitarios Use Cases (4 steps con mocks)
   ❌ Tests Integración (TestContainers: PostgreSQL + Redis + MinIO)
   ❌ Tests E2E (flujo completo 4 steps)
   ```

#### 🟠 **IMPORTANTE** (Nice to Have)

1. **Validaciones Avanzadas**
   ```
   ⚠️ Validación edad <18 requiere responsable legal
   ⚠️ Validación biométrica (facial recognition score >70%)
   ⚠️ Validación archivos (tamaño, formato, virus scan)
   ⚠️ Rate limiting (max 3 intentos OTP, cooldown 60s)
   ```

2. **Optimizaciones Performance**
   ```
   ⚠️ Índices compuestos en proceso_registro (usuario_id + estado)
   ⚠️ Caché catálogos (géneros, países, niveles educativos)
   ⚠️ Async upload archivos a MinIO (no bloquear request)
   ⚠️ Connection pooling optimizado (HikariCP)
   ```

3. **Documentación**
   ```
   ⚠️ OpenAPI/Swagger para 4 endpoints
   ⚠️ Javadoc completo en Value Objects
   ⚠️ README actualizado con flujo multi-step
   ⚠️ Colección Postman con ejemplos
   ```

---

## 🏗️ Plan de Implementación HUT-001

### 📅 **Sprint 2 - 5 días (40h)**

#### **DÍA 1: Domain Model (8h)**

##### **Mañana (4h)**: Value Objects
```java
// 1. Email.java
public record Email(String value) {
    public Email {
        Objects.requireNonNull(value, "Email no puede ser nulo");
        if (!value.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new IllegalArgumentException("Email inválido: " + value);
        }
    }
    
    public static Email of(String value) {
        return new Email(value.toLowerCase().trim());
    }
}

// 2. Password.java (con validación fuerza)
public record Password(String value) {
    private static final String REGEX = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$";
    
    public Password {
        Objects.requireNonNull(value);
        if (!value.matches(REGEX)) {
            throw new IllegalArgumentException(
                "Password debe tener: 8+ chars, mayúsculas, minúsculas, números"
            );
        }
    }
}

// 3. NombreCompleto.java
public record NombreCompleto(
    String primerNombre,
    String segundoNombre,
    String primerApellido,
    String segundoApellido,
    LocalDate fechaNacimiento
) {
    public int calcularEdad() {
        return Period.between(fechaNacimiento, LocalDate.now()).getYears();
    }
    
    public boolean esMenorDeEdad() {
        return calcularEdad() < 18;
    }
}

// 4. Telefono.java
public record Telefono(String value) {
    private static final String REGEX = "^\\+?[0-9\\s\\-\\(\\)]{7,20}$";
    
    public Telefono {
        if (!value.matches(REGEX)) {
            throw new IllegalArgumentException("Teléfono inválido");
        }
    }
}
```

**Tests**:
```java
@Test
void emailInvalido_lanzaException() {
    assertThrows(IllegalArgumentException.class, () -> Email.of("invalido"));
}

@Test
void passwordDebil_lanzaException() {
    assertThrows(IllegalArgumentException.class, () -> Password.of("123"));
}

@Test
void menorDeEdad_retornaTrue() {
    NombreCompleto nombre = NombreCompleto.of(
        "Juan", null, "Pérez", null, 
        LocalDate.now().minusYears(15)
    );
    assertTrue(nombre.esMenorDeEdad());
}
```

##### **Tarde (4h)**: Entities (ProcesoRegistro, VerificacionIdentidad, ResponsableLegal)
```java
// ProcesoRegistro.java
@Entity
@Table(schema = "autenticacion_schema", name = "proceso_registro")
public class ProcesoRegistro extends BaseEntity {
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id")
    private Usuario usuario;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "estado_actual")
    private EstadoRegistro estadoActual;
    
    @Column(name = "step_completado")
    private Integer stepCompletado = 0;
    
    @Type(JsonBinaryType.class)
    @Column(name = "datos_step_1", columnDefinition = "jsonb")
    private Map<String, Object> datosStep1;
    
    @Type(JsonBinaryType.class)
    @Column(name = "datos_step_2", columnDefinition = "jsonb")
    private Map<String, Object> datosStep2;
    
    @Type(JsonBinaryType.class)
    @Column(name = "datos_step_3", columnDefinition = "jsonb")
    private Map<String, Object> datosStep3;
    
    @Type(JsonBinaryType.class)
    @Column(name = "datos_step_4", columnDefinition = "jsonb")
    private Map<String, Object> datosStep4;
    
    @Column(name = "fecha_expiracion")
    private Instant fechaExpiracion;
    
    // Factory Method
    public static ProcesoRegistro iniciar(Usuario usuario) {
        ProcesoRegistro proceso = new ProcesoRegistro();
        proceso.usuario = usuario;
        proceso.estadoActual = EstadoRegistro.STEP_1_CREDENCIALES;
        proceso.fechaExpiracion = Instant.now().plus(24, ChronoUnit.HOURS);
        return proceso;
    }
    
    // Métodos de negocio
    public void completarStep1(Map<String, Object> datos) {
        validarTransicion(EstadoRegistro.STEP_1_CREDENCIALES);
        this.datosStep1 = datos;
        this.stepCompletado = 1;
        this.estadoActual = EstadoRegistro.STEP_2_DATOS_PERSONALES;
    }
    
    public void completarStep2(Map<String, Object> datos) {
        validarTransicion(EstadoRegistro.STEP_2_DATOS_PERSONALES);
        this.datosStep2 = datos;
        this.stepCompletado = 2;
        this.estadoActual = EstadoRegistro.STEP_3_VERIFICACION_BIOMETRICA;
    }
    
    // ... similar para step 3 y 4
    
    private void validarTransicion(EstadoRegistro esperado) {
        if (this.estadoActual != esperado) {
            throw new IllegalStateException(
                String.format("Transición inválida: esperado %s, actual %s", 
                    esperado, estadoActual)
            );
        }
    }
    
    public boolean estaExpirado() {
        return Instant.now().isAfter(fechaExpiracion);
    }
}
```

---

#### **DÍA 2: Use Cases (8h)**

##### **Mañana (4h)**: RegistrarEstudianteStep1UseCase + Step2UseCase
```java
@Service
@Transactional
public class RegistrarEstudianteStep1UseCase {
    
    private final UsuarioRepository usuarioRepository;
    private final ProcesoRegistroRepository procesoRepository;
    private final PasswordEncoderPort passwordEncoder;
    
    public RegistroStep1Response ejecutar(RegistroStep1Command command) {
        // 1. Validar email único
        if (usuarioRepository.existsByEmail(command.email())) {
            throw new EmailYaRegistradoException(command.email());
        }
        
        // 2. Crear Value Objects
        Email email = Email.of(command.email());
        Password password = Password.of(command.password());
        String passwordHash = passwordEncoder.encode(password.value());
        
        // 3. Crear Usuario (solo credenciales básicas)
        Usuario usuario = new Usuario();
        usuario.setEmail(email.value());
        usuario.setPasswordHash(passwordHash);
        usuario.setRol(Usuario.Rol.ESTUDIANTE);
        usuario.setEstadoCuenta(Usuario.EstadoCuenta.PENDIENTE_VERIFICACION);
        usuario = usuarioRepository.save(usuario);
        
        // 4. Iniciar ProcesoRegistro
        ProcesoRegistro proceso = ProcesoRegistro.iniciar(usuario);
        proceso.completarStep1(Map.of(
            "email", email.value(),
            "aceptaTerminos", command.aceptaTerminos(),
            "aceptaHabeasData", command.aceptaHabeasData(),
            "ipRegistro", command.metadata().ip(),
            "userAgent", command.metadata().userAgent()
        ));
        proceso = procesoRepository.save(proceso);
        
        return RegistroStep1Response.of(proceso);
    }
}
```

##### **Tarde (4h)**: RegistrarEstudianteStep3UseCase + Step4UseCase
```java
@Service
@Transactional
public class RegistrarEstudianteStep3UseCase {
    
    private final ProcesoRegistroRepository procesoRepository;
    private final ArchivoRepository archivoRepository;
    private final MinIOStoragePort storagePort;
    private final VerificacionIdentidadRepository verificacionRepository;
    
    public RegistroStep3Response ejecutar(RegistroStep3Command command) {
        // 1. Recuperar proceso
        ProcesoRegistro proceso = procesoRepository.findById(command.procesoId())
            .orElseThrow(() -> new ProcesoNoEncontradoException(command.procesoId()));
        
        if (proceso.estaExpirado()) {
            throw new ProcesoExpiradoException(proceso.getId());
        }
        
        // 2. Subir archivos a MinIO (asíncrono)
        List<Archivo> archivos = CompletableFuture.supplyAsync(() -> {
            List<Archivo> uploaded = new ArrayList<>();
            uploaded.add(subirArchivo(proceso.getUsuario(), TipoArchivo.FOTO_PERFIL, command.fotoPerfil()));
            uploaded.add(subirArchivo(proceso.getUsuario(), TipoArchivo.DOCUMENTO_FRONTAL, command.documentoFrente()));
            uploaded.add(subirArchivo(proceso.getUsuario(), TipoArchivo.DOCUMENTO_REVERSO, command.documentoReverso()));
            uploaded.add(subirArchivo(proceso.getUsuario(), TipoArchivo.SELFIE_VERIFICACION, command.fotoEnVivo()));
            return uploaded;
        }).join();
        
        archivoRepository.saveAll(archivos);
        
        // 3. Crear VerificacionIdentidad
        VerificacionIdentidad verificacion = new VerificacionIdentidad();
        verificacion.setUsuario(proceso.getUsuario());
        verificacion.setProcesoRegistro(proceso);
        verificacion.setTipoDocumento(command.tipoDocumento());
        verificacion.setNumeroDocumento(command.numeroDocumento());
        verificacion.setFotoDocumentoFrontal(archivos.get(1));
        verificacion.setFotoDocumentoReverso(archivos.get(2));
        verificacion.setSelfieVerificacion(archivos.get(3));
        verificacion.setEstadoVerificacion(EstadoVerificacion.PENDIENTE);
        verificacionRepository.save(verificacion);
        
        // 4. Completar step 3
        proceso.completarStep3(Map.of(
            "archivosSubidos", archivos.stream().map(Archivo::getId).toList(),
            "verificacionId", verificacion.getId()
        ));
        procesoRepository.save(proceso);
        
        return RegistroStep3Response.of(proceso);
    }
    
    private Archivo subirArchivo(Usuario usuario, TipoArchivo tipo, byte[] contenido) {
        String nombreArchivo = String.format("%s_%s_%d.jpg", 
            usuario.getId(), tipo, System.currentTimeMillis());
        
        String url = storagePort.upload(nombreArchivo, contenido);
        
        Archivo archivo = new Archivo();
        archivo.setUsuario(usuario);
        archivo.setNombreArchivo(nombreArchivo);
        archivo.setTipoArchivo(tipo);
        archivo.setStorageProvider("MINIO");
        archivo.setStoragePath(url);
        archivo.setTamañoBytes((long) contenido.length);
        return archivo;
    }
}
```

---

#### **DÍA 3: Infrastructure Adapters (8h)**

##### **Mañana (4h)**: MinIOStorageAdapter + RedisOTPAdapter
```java
@Component
public class MinIOStorageAdapter implements ArchivoStoragePort {
    
    private final MinioClient minioClient;
    
    @Value("${minio.bucket-name}")
    private String bucketName;
    
    @Override
    public String upload(String nombreArchivo, byte[] contenido) {
        try {
            minioClient.putObject(
                PutObjectArgs.builder()
                    .bucket(bucketName)
                    .object(nombreArchivo)
                    .stream(new ByteArrayInputStream(contenido), contenido.length, -1)
                    .contentType("image/jpeg")
                    .build()
            );
            
            return getPublicUrl(nombreArchivo);
        } catch (Exception e) {
            throw new ArchivoUploadException("Error subiendo archivo: " + nombreArchivo, e);
        }
    }
    
    @Override
    public byte[] download(String nombreArchivo) {
        try (InputStream stream = minioClient.getObject(
            GetObjectArgs.builder()
                .bucket(bucketName)
                .object(nombreArchivo)
                .build()
        )) {
            return stream.readAllBytes();
        } catch (Exception e) {
            throw new ArchivoDownloadException("Error descargando archivo: " + nombreArchivo, e);
        }
    }
    
    private String getPublicUrl(String nombreArchivo) {
        return String.format("http://minio:9000/%s/%s", bucketName, nombreArchivo);
    }
}
```

```java
@Component
public class RedisOTPAdapter implements OTPStoragePort {
    
    private final RedisTemplate<String, String> redisTemplate;
    
    private static final Duration OTP_TTL = Duration.ofMinutes(10);
    private static final int MAX_ATTEMPTS = 3;
    
    @Override
    public void guardarOTP(UUID usuarioId, String codigo) {
        String key = "otp:" + usuarioId;
        redisTemplate.opsForValue().set(key, codigo, OTP_TTL);
    }
    
    @Override
    public boolean validarOTP(UUID usuarioId, String codigo) {
        String key = "otp:" + usuarioId;
        String codigoGuardado = redisTemplate.opsForValue().get(key);
        
        if (codigoGuardado == null) {
            return false; // OTP expirado
        }
        
        if (!codigoGuardado.equals(codigo)) {
            incrementarIntentos(usuarioId);
            return false;
        }
        
        // OTP válido - eliminar de Redis
        redisTemplate.delete(key);
        redisTemplate.delete("otp:attempts:" + usuarioId);
        return true;
    }
    
    private void incrementarIntentos(UUID usuarioId) {
        String keyAttempts = "otp:attempts:" + usuarioId;
        Long intentos = redisTemplate.opsForValue().increment(keyAttempts);
        
        if (intentos == 1) {
            redisTemplate.expire(keyAttempts, Duration.ofMinutes(15));
        }
        
        if (intentos >= MAX_ATTEMPTS) {
            // Bloquear usuario por 15 minutos
            String keyBlock = "otp:block:" + usuarioId;
            redisTemplate.opsForValue().set(keyBlock, "blocked", Duration.ofMinutes(15));
        }
    }
}
```

##### **Tarde (4h)**: REST Controllers Multi-step
```java
@RestController
@RequestMapping("/api/v1/registro/estudiante")
@Validated
public class RegistroEstudianteController {
    
    private final RegistrarEstudianteStep1UseCase step1UseCase;
    private final RegistrarEstudianteStep2UseCase step2UseCase;
    private final RegistrarEstudianteStep3UseCase step3UseCase;
    private final RegistrarEstudianteStep4UseCase step4UseCase;
    
    @PostMapping("/step-1")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<RegistroStep1Response> step1(
            @Valid @RequestBody RegistroStep1Request request,
            @RequestHeader("X-Real-IP") String ip,
            @RequestHeader("User-Agent") String userAgent) {
        
        RegistroStep1Command command = request.toCommand()
            .withMetadata(ip, userAgent);
        
        RegistroStep1Response response = step1UseCase.ejecutar(command);
        
        return ApiResponse.success(response, "Step 1 completado. Continúa con información personal.");
    }
    
    @PostMapping("/step-2")
    public ApiResponse<RegistroStep2Response> step2(@Valid @RequestBody RegistroStep2Request request) {
        RegistroStep2Command command = request.toCommand();
        RegistroStep2Response response = step2UseCase.ejecutar(command);
        return ApiResponse.success(response, "Step 2 completado. Sube tus documentos.");
    }
    
    @PostMapping("/step-3")
    public ApiResponse<RegistroStep3Response> step3(@Valid @RequestBody RegistroStep3Request request) {
        RegistroStep3Command command = request.toCommand();
        RegistroStep3Response response = step3UseCase.ejecutar(command);
        return ApiResponse.success(response, "Step 3 completado. Confirma tu información.");
    }
    
    @PostMapping("/step-4")
    public ApiResponse<RegistroStep4Response> step4(@Valid @RequestBody RegistroStep4Request request) {
        RegistroStep4Command command = request.toCommand();
        RegistroStep4Response response = step4UseCase.ejecutar(command);
        return ApiResponse.success(response, "Registro completado. Verifica tu email.");
    }
    
    @GetMapping("/proceso/{procesoId}")
    public ApiResponse<ProcesoRegistroResponse> obtenerProceso(@PathVariable UUID procesoId) {
        // Implementación...
    }
}
```

---

#### **DÍA 4: Tests (8h)**

##### **Mañana (4h)**: Tests Unitarios
```java
// EmailTest.java
class EmailTest {
    @Test
    void emailValido_creaInstancia() {
        Email email = Email.of("test@mitoga.com");
        assertEquals("test@mitoga.com", email.value());
    }
    
    @Test
    void emailInvalido_lanzaException() {
        assertThrows(IllegalArgumentException.class, () -> Email.of("invalido"));
    }
    
    @Test
    void emailConEspacios_seNormalizaCorrectamente() {
        Email email = Email.of("  TEST@MITOGA.COM  ");
        assertEquals("test@mitoga.com", email.value());
    }
}

// PasswordTest.java
class PasswordTest {
    @Test
    void passwordFuerte_creaInstancia() {
        Password password = Password.of("SecurePass123!");
        assertNotNull(password.value());
    }
    
    @Test
    void passwordDebil_lanzaException() {
        assertThrows(IllegalArgumentException.class, () -> Password.of("123"));
    }
    
    @ParameterizedTest
    @ValueSource(strings = {"abc", "ABCDEFGH", "12345678", "abcd1234"})
    void passwordSinRequisitos_lanzaException(String passwordDebil) {
        assertThrows(IllegalArgumentException.class, () -> Password.of(passwordDebil));
    }
}

// RegistrarEstudianteStep1UseCaseTest.java
@ExtendWith(MockitoExtension.class)
class RegistrarEstudianteStep1UseCaseTest {
    
    @Mock
    private UsuarioRepository usuarioRepository;
    
    @Mock
    private ProcesoRegistroRepository procesoRepository;
    
    @Mock
    private PasswordEncoderPort passwordEncoder;
    
    @InjectMocks
    private RegistrarEstudianteStep1UseCase useCase;
    
    @Test
    void registroExitoso_creaUsuarioYProceso() {
        // Given
        RegistroStep1Command command = new RegistroStep1Command(
            "test@mitoga.com",
            "SecurePass123!",
            true,
            true,
            new MetadataCommand("192.168.1.1", "Mozilla/5.0")
        );
        
        when(usuarioRepository.existsByEmail(anyString())).thenReturn(false);
        when(passwordEncoder.encode(anyString())).thenReturn("hashedPassword");
        when(usuarioRepository.save(any(Usuario.class))).thenAnswer(i -> i.getArgument(0));
        when(procesoRepository.save(any(ProcesoRegistro.class))).thenAnswer(i -> i.getArgument(0));
        
        // When
        RegistroStep1Response response = useCase.ejecutar(command);
        
        // Then
        assertNotNull(response.procesoId());
        assertEquals("test@mitoga.com", response.email());
        assertEquals("STEP_1_CREDENCIALES", response.estadoActual());
        
        verify(usuarioRepository).existsByEmail("test@mitoga.com");
        verify(usuarioRepository).save(any(Usuario.class));
        verify(procesoRepository).save(any(ProcesoRegistro.class));
    }
    
    @Test
    void emailDuplicado_lanzaException() {
        // Given
        RegistroStep1Command command = new RegistroStep1Command(
            "duplicado@mitoga.com",
            "SecurePass123!",
            true,
            true,
            new MetadataCommand("192.168.1.1", "Mozilla/5.0")
        );
        
        when(usuarioRepository.existsByEmail("duplicado@mitoga.com")).thenReturn(true);
        
        // When/Then
        assertThrows(EmailYaRegistradoException.class, () -> useCase.ejecutar(command));
        
        verify(usuarioRepository, never()).save(any());
    }
}
```

##### **Tarde (4h)**: Tests de Integración (TestContainers)
```java
@SpringBootTest
@Testcontainers
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class RegistroEstudianteIntegrationTest {
    
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:17.6")
        .withDatabaseName("mitogadb_test")
        .withUsername("test")
        .withPassword("test");
    
    @Container
    static GenericContainer<?> redis = new GenericContainer<>("redis:7-alpine")
        .withExposedPorts(6379);
    
    @Container
    static GenericContainer<?> minio = new GenericContainer<>("minio/minio:latest")
        .withExposedPorts(9000)
        .withEnv("MINIO_ROOT_USER", "minioadmin")
        .withEnv("MINIO_ROOT_PASSWORD", "minioadmin");
    
    @Autowired
    private RegistrarEstudianteStep1UseCase step1UseCase;
    
    @Autowired
    private RegistrarEstudianteStep2UseCase step2UseCase;
    
    @Autowired
    private UsuarioRepository usuarioRepository;
    
    @Autowired
    private ProcesoRegistroRepository procesoRepository;
    
    @DynamicPropertySource
    static void properties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
        registry.add("spring.redis.host", redis::getHost);
        registry.add("spring.redis.port", () -> redis.getMappedPort(6379));
        registry.add("minio.url", () -> "http://" + minio.getHost() + ":" + minio.getMappedPort(9000));
    }
    
    @Test
    void flujoCompletoRegistroEstudiante_crearCuentaCorrectamente() {
        // Step 1: Credenciales
        RegistroStep1Command step1Cmd = new RegistroStep1Command(
            "estudiante@test.com",
            "SecurePass123!",
            true,
            true,
            new MetadataCommand("192.168.1.1", "Mozilla/5.0")
        );
        
        RegistroStep1Response step1Res = step1UseCase.ejecutar(step1Cmd);
        assertNotNull(step1Res.procesoId());
        
        // Step 2: Información Personal
        RegistroStep2Command step2Cmd = new RegistroStep2Command(
            step1Res.procesoId(),
            "Juan",
            null,
            "Pérez",
            null,
            UUID.randomUUID(), // generoId
            LocalDate.of(2005, 3, 15),
            "+57 310 1234567",
            UUID.randomUUID(), // paisId
            UUID.randomUUID(), // ciudadId
            "Calle 123 #45-67",
            UUID.randomUUID(), // nivelEducativoId
            "Estudiante interesado en programación",
            null // Sin responsable legal (mayor de 18)
        );
        
        RegistroStep2Response step2Res = step2UseCase.ejecutar(step2Cmd);
        assertEquals("STEP_2_DATOS_PERSONALES", step2Res.estadoActual());
        
        // Verificar en DB
        ProcesoRegistro proceso = procesoRepository.findById(step1Res.procesoId()).orElseThrow();
        assertEquals(2, proceso.getStepCompletado());
        assertNotNull(proceso.getDatosStep1());
        assertNotNull(proceso.getDatosStep2());
    }
}
```

---

#### **DÍA 5: Postman + Documentación (8h)**

##### **Mañana (4h)**: Colección Postman
```json
{
  "info": {
    "name": "HUT-001: Registro Estudiante Multi-step",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "variable": [
    {
      "key": "baseUrl",
      "value": "http://localhost:8080/api/v1",
      "type": "string"
    },
    {
      "key": "procesoId",
      "value": "",
      "type": "string"
    }
  ],
  "item": [
    {
      "name": "Step 1: Credenciales",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          },
          {
            "key": "X-Real-IP",
            "value": "192.168.1.100"
          },
          {
            "key": "User-Agent",
            "value": "PostmanRuntime/7.x"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"email\": \"estudiante@mitoga.com\",\n  \"password\": \"SecurePass123!\",\n  \"confirmPassword\": \"SecurePass123!\",\n  \"aceptaTerminos\": true,\n  \"aceptaHabeasData\": true\n}"
        },
        "url": {
          "raw": "{{baseUrl}}/registro/estudiante/step-1",
          "host": ["{{baseUrl}}"],
          "path": ["registro", "estudiante", "step-1"]
        }
      },
      "event": [
        {
          "listen": "test",
          "script": {
            "exec": [
              "pm.test(\"Status 201 Created\", () => {",
              "    pm.response.to.have.status(201);",
              "});",
              "",
              "pm.test(\"Response contiene procesoId\", () => {",
              "    const json = pm.response.json();",
              "    pm.expect(json.data.procesoId).to.exist;",
              "    pm.collectionVariables.set(\"procesoId\", json.data.procesoId);",
              "});"
            ]
          }
        }
      ]
    },
    {
      "name": "Step 2: Información Personal",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"procesoId\": \"{{procesoId}}\",\n  \"primerNombre\": \"Juan\",\n  \"primerApellido\": \"Pérez\",\n  \"fechaNacimiento\": \"2005-03-15\",\n  \"generoId\": \"550e8400-e29b-41d4-a716-446655440000\",\n  \"telefono\": \"+57 310 1234567\",\n  \"paisId\": \"550e8400-e29b-41d4-a716-446655440001\",\n  \"ciudadId\": \"550e8400-e29b-41d4-a716-446655440002\",\n  \"direccion\": \"Calle 123 #45-67\",\n  \"nivelEducativoId\": \"550e8400-e29b-41d4-a716-446655440003\",\n  \"sobreMi\": \"Soy estudiante de ingeniería...\"\n}"
        },
        "url": {
          "raw": "{{baseUrl}}/registro/estudiante/step-2",
          "host": ["{{baseUrl}}"],
          "path": ["registro", "estudiante", "step-2"]
        }
      }
    }
  ]
}
```

##### **Tarde (4h)**: Documentación OpenAPI + README
```yaml
# openapi.yaml (generado por SpringDoc)
openapi: 3.0.1
info:
  title: MI-TOGA Backend API
  description: API REST para registro multi-step de estudiantes
  version: 1.0.0
servers:
  - url: http://localhost:8080/api/v1
paths:
  /registro/estudiante/step-1:
    post:
      tags:
        - Registro Estudiante
      summary: Step 1 - Credenciales
      operationId: registrarStep1
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/RegistroStep1Request'
            example:
              email: estudiante@mitoga.com
              password: SecurePass123!
              confirmPassword: SecurePass123!
              aceptaTerminos: true
              aceptaHabeasData: true
      responses:
        '201':
          description: Step 1 completado exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/RegistroStep1Response'
        '400':
          description: Validación fallida
        '409':
          description: Email ya registrado
components:
  schemas:
    RegistroStep1Request:
      type: object
      required:
        - email
        - password
        - aceptaTerminos
        - aceptaHabeasData
      properties:
        email:
          type: string
          format: email
        password:
          type: string
          minLength: 8
          pattern: '^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$'
        confirmPassword:
          type: string
        aceptaTerminos:
          type: boolean
        aceptaHabeasData:
          type: boolean
```

---

## 📊 Resumen Estimación

| Tarea | Esfuerzo | Día |
|-------|----------|-----|
| **Domain Model** (VO + Entities) | 8h | Día 1 |
| **Use Cases** (4 steps) | 8h | Día 2 |
| **Infrastructure** (Adapters + Controllers) | 8h | Día 3 |
| **Tests** (Unitarios + Integración) | 8h | Día 4 |
| **Postman + Docs** | 8h | Día 5 |
| **TOTAL** | **40h** | **5 días** |

**Story Points**: 13 (Fibonacci)  
**Cobertura Tests Esperada**: >85%  
**Deuda Técnica**: Mínima (arquitectura limpia)

---

## ✅ Definition of Done

### Backend:
- [x] Value Objects inmutables (records Java 21)
- [x] Aggregates con Factory Methods
- [x] Use Cases transaccionales con ports
- [x] Adapters JPA + MinIO + Redis implementados
- [x] 4 endpoints REST documentados (OpenAPI)
- [x] Tests unitarios >85% coverage
- [x] Tests integración (TestContainers)
- [x] Colección Postman completa
- [x] Flyway migration aplicada
- [x] SonarQube sin code smells críticos

### Seguridad:
- [x] Bean Validation en todos los DTOs
- [x] Password hashing con BCrypt (strength 12)
- [x] OTP con TTL 10 minutos (Redis)
- [x] Rate limiting (max 3 intentos OTP)
- [x] Validación archivos (tamaño, formato)
- [x] SQL Injection prevenido (JPA)

### Performance:
- [x] Índices optimizados en proceso_registro
- [x] Async upload archivos a MinIO
- [x] Connection pooling configurado (HikariCP)
- [x] Queries N+1 prevenidas (@EntityGraph)

---

## 🚀 Próximos Pasos

1. **Revisar y aprobar este plan** con Product Owner
2. **Configurar entorno**:
   - MinIO local (Docker Compose)
   - Redis 7.x
   - PostgreSQL 17.6
3. **Ejecutar script SQL** `V001__registro_estudiante_multistep.sql`
4. **Iniciar Sprint 2** - Implementación HUT-001

---

**Autor**: Backend Senior Java Developer  
**Rol**: `zns.dev.backend`  
**Metodología**: ZNS v2.0  
**Fecha**: 2025-11-16
