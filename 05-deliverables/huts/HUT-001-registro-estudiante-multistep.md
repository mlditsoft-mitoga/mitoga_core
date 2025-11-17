# HUT-001: Implementación de Registro de Estudiantes Multi-step

## 📋 Metadatos

| Atributo | Valor |
|----------|-------|
| **HU Origen** | HU-001 - Registro de Estudiantes |
| **Bounded Context** | Autenticación + Perfiles Estudiantes |
| **Sprint** | Sprint 2 |
| **Story Points** | 13 (Fibonacci) |
| **Prioridad** | ALTA |
| **Tipo** | Feature |

---

## 🎯 Historia de Usuario Origen

**Como** estudiante nuevo  
**Quiero** registrarme en la plataforma mediante un proceso multi-step  
**Para** crear mi cuenta y acceder a tutorías personalizadas

### Criterios de Aceptación (Negocio)
- ✅ Email único y válido
- ✅ Password segura (8+ chars, mayúsculas, minúsculas, números)
- ✅ Información personal completa (nombres, apellidos, fecha nacimiento)
- ✅ Validación de edad (menores requieren responsable legal)
- ✅ Carga de 4 fotos (perfil, documento frontal/reverso, selfie en vivo)
- ✅ Aceptación de términos y política de habeas data
- ✅ Verificación por código OTP enviado a email

---

## 🏗️ Contexto Arquitectónico

### Patrón Arquitectónico
- **Arquitectura**: Hexagonal (Ports & Adapters)
- **DDD**: Aggregate Root: `Usuario` + `PerfilEstudiante`
- **Comunicación**: REST API + API Gateway

### ADRs Relacionados
- **[ADR-003]** Estrategia de autenticación JWT + OAuth2
- **[ADR-008]** Validación de datos con Bean Validation
- **[ADR-012]** Gestión de archivos en MinIO/S3
- **[ADR-015]** Proceso multi-step con estado en base de datos

### Tecnologías
- **Backend**: Spring Boot 3.4.0, Java 21, PostgreSQL 17.6
- **Frontend**: Next.js 16.0.0, React 18, TypeScript 5.x
- **Storage**: MinIO (on-premise) / AWS S3 (cloud)
- **API Gateway**: Spring Cloud Gateway (puerto 8080)

---

## 📊 Estructura de Datos

### Objeto JSON Completo (Request Final)

```json
{
  "credenciales": {
    "email": "estudiante@example.com",
    "password": "SecurePass123!",
    "confirmPassword": "SecurePass123!"
  },
  "informacionPersonal": {
    "primerNombre": "Juan",
    "segundoNombre": "Carlos",
    "primerApellido": "Pérez",
    "segundoApellido": "García",
    "generoId": "550e8400-e29b-41d4-a716-446655440000",
    "fechaNacimiento": "15/03/2005",
    "telefono": "+57 310 1234567",
    "paisId": "550e8400-e29b-41d4-a716-446655440001",
    "ciudadId": "550e8400-e29b-41d4-a716-446655440002",
    "direccion": "Calle 123 #45-67, Apto 301",
    "nivelEducativoId": "550e8400-e29b-41d4-a716-446655440003",
    "sobreMi": "Soy estudiante de ingeniería interesado en aprender programación..."
  },
  "responsableLegal": {
    "requerido": true,
    "email": "padre@example.com",
    "primerNombre": "Pedro",
    "primerApellido": "Pérez",
    "telefono": "+57 310 9876543"
  },
  "archivos": {
    "fotoPerfil": "base64_encoded_image_or_file_reference",
    "documentoFrente": "base64_encoded_image",
    "documentoReverso": "base64_encoded_image",
    "fotoEnVivo": "base64_encoded_image",
    "documentoResponsableFrente": "base64_encoded_image",
    "documentoResponsableReverso": "base64_encoded_image"
  },
  "aceptaciones": {
    "aceptaTerminos": true,
    "aceptaHabeasData": true,
    "fechaAceptacion": "2025-11-16T10:30:00Z"
  },
  "metadata": {
    "ipRegistro": "192.168.1.100",
    "userAgent": "Mozilla/5.0...",
    "dispositivo": "web",
    "idioma": "es-CO"
  }
}
```

### Respuesta Backend (201 Created)

```json
{
  "status": "success",
  "message": "Registro iniciado. Verifica tu email para continuar.",
  "data": {
    "usuarioId": "650e8400-e29b-41d4-a716-446655440000",
    "email": "estudiante@example.com",
    "estadoRegistro": "PENDIENTE_VERIFICACION_EMAIL",
    "codigoOTPEnviado": true,
    "tiempoExpiracionOTP": "2025-11-16T10:40:00Z"
  },
  "timestamp": "2025-11-16T10:30:15.234Z"
}
```

---

## 🔧 Tareas Técnicas Detalladas

### 📦 BACKEND TASKS

#### TAREA-001-BE-01: Crear Aggregate `Usuario` [5h]

**Descripción**: Implementar Aggregate Root Usuario con Value Objects inmutables

**Archivos**:
- `domain/autenticacion/Usuario.java`
- `domain/autenticacion/Email.java` (Value Object)
- `domain/autenticacion/Password.java` (Value Object)
- `domain/autenticacion/NombreCompleto.java` (Value Object)

**Implementación Esperada**:
```java
package com.mitoga.domain.autenticacion;

@AggregateRoot
public class Usuario {
    private final UsuarioId id;
    private final Email email;
    private final Password password;
    private final NombreCompleto nombreCompleto;
    private final Rol rol;
    private EstadoUsuario estado;
    
    // Constructor privado (DDD pattern)
    private Usuario(UsuarioId id, Email email, Password password, 
                    NombreCompleto nombreCompleto, Rol rol) {
        this.id = Objects.requireNonNull(id, "ID no puede ser nulo");
        this.email = Objects.requireNonNull(email, "Email no puede ser nulo");
        this.password = Objects.requireNonNull(password, "Password no puede ser nulo");
        this.nombreCompleto = Objects.requireNonNull(nombreCompleto);
        this.rol = Objects.requireNonNull(rol, "Rol no puede ser nulo");
        this.estado = EstadoUsuario.PENDIENTE_VERIFICACION_EMAIL;
    }
    
    // Factory Method (patrón DDD)
    public static Usuario registrar(Email email, Password password, 
                                     NombreCompleto nombreCompleto, Rol rol) {
        // Validaciones de negocio
        validarEmailUnico(email); // Se delega al servicio
        validarPasswordSegura(password);
        validarEdadParaRol(nombreCompleto.getFechaNacimiento(), rol);
        
        return new Usuario(
            UsuarioId.generar(),
            email,
            password,
            nombreCompleto,
            rol
        );
    }
    
    public void verificarEmail() {
        if (this.estado != EstadoUsuario.PENDIENTE_VERIFICACION_EMAIL) {
            throw new IllegalStateException("Usuario ya verificado");
        }
        this.estado = EstadoUsuario.ACTIVO;
    }
    
    // Getters (sin setters - inmutabilidad)
    public UsuarioId getId() { return id; }
    public Email getEmail() { return email; }
    // ...
}
```

**Criterios Técnicos de Aceptación**:
- [ ] Value Objects inmutables (records de Java)
- [ ] Constructor privado + Factory Method
- [ ] Validaciones de negocio en el dominio
- [ ] No dependencias de infraestructura
- [ ] Tests unitarios >90% coverage

**Tests**:
```java
// UsuarioTest.java
@Test
void testRegistrarUsuarioEstudianteExitoso() {
    Email email = Email.of("test@mitoga.com");
    Password password = Password.of("SecurePass123!");
    NombreCompleto nombre = NombreCompleto.of("Juan", "Pérez", LocalDate.of(2005, 3, 15));
    
    Usuario usuario = Usuario.registrar(email, password, nombre, Rol.ESTUDIANTE);
    
    assertNotNull(usuario.getId());
    assertEquals(EstadoUsuario.PENDIENTE_VERIFICACION_EMAIL, usuario.getEstado());
    assertEquals(Rol.ESTUDIANTE, usuario.getRol());
}

@Test
void testEmailInvalidoLanzaException() {
    assertThrows(IllegalArgumentException.class, () -> {
        Email.of("email-invalido");
    });
}

@Test
void testPasswordDebiLanzaException() {
    assertThrows(IllegalArgumentException.class, () -> {
        Password.of("123"); // Muy corta
    });
}

@Test
void testMenorNoPuedeSerTutor() {
    LocalDate fechaNacimientoMenor = LocalDate.now().minusYears(15);
    NombreCompleto nombre = NombreCompleto.of("Juan", "Pérez", fechaNacimientoMenor);
    
    assertThrows(IllegalArgumentException.class, () -> {
        Usuario.registrar(
            Email.of("menor@test.com"),
            Password.of("SecurePass123!"),
            nombre,
            Rol.TUTOR // ❌ Menores no pueden ser tutores
        );
    });
}
```

---

#### TAREA-001-BE-02: Implementar Use Case `RegistrarEstudianteUseCase` [6h]

**Descripción**: Puerto de entrada (application layer) para registro de estudiantes

**Archivos**:
- `application/usecases/estudiantes/RegistrarEstudianteUseCase.java`
- `application/ports/in/RegistrarEstudianteCommand.java`
- `application/ports/out/UsuarioRepositoryPort.java`
- `application/ports/out/ArchivoStoragePort.java`
- `application/ports/out/EmailServicePort.java`

**Implementación**:
```java
@UseCase
@Transactional
public class RegistrarEstudianteUseCase {
    
    private final UsuarioRepositoryPort usuarioRepository;
    private final PerfilEstudianteRepositoryPort perfilRepository;
    private final ArchivoStoragePort archivoStorage;
    private final EmailServicePort emailService;
    private final PasswordEncoderPort passwordEncoder;
    
    public RegistrarEstudianteResponse ejecutar(RegistrarEstudianteCommand command) {
        // 1. Validar email único
        if (usuarioRepository.existsByEmail(command.email())) {
            throw new EmailYaRegistradoException(command.email());
        }
        
        // 2. Crear aggregate Usuario
        Email email = Email.of(command.email());
        Password password = Password.of(
            passwordEncoder.encode(command.password())
        );
        NombreCompleto nombreCompleto = NombreCompleto.of(
            command.primerNombre(),
            command.primerApellido(),
            command.fechaNacimiento()
        );
        
        Usuario usuario = Usuario.registrar(email, password, nombreCompleto, Rol.ESTUDIANTE);
        
        // 3. Persistir usuario
        usuario = usuarioRepository.save(usuario);
        
        // 4. Crear perfil de estudiante
        PerfilEstudiante perfil = PerfilEstudiante.crear(
            usuario.getId(),
            command.toPerfilData()
        );
        perfilRepository.save(perfil);
        
        // 5. Subir archivos a storage (async)
        CompletableFuture.runAsync(() -> {
            subirArchivos(usuario.getId(), command.archivos());
        });
        
        // 6. Generar y enviar código OTP
        String codigoOTP = generarCodigoOTP();
        emailService.enviarCodigoVerificacion(email.getValue(), codigoOTP);
        
        // 7. Guardar OTP con TTL (10 minutos)
        guardarOTPTemporalmente(usuario.getId(), codigoOTP, Duration.ofMinutes(10));
        
        return RegistrarEstudianteResponse.of(usuario);
    }
    
    private String generarCodigoOTP() {
        return String.format("%06d", new Random().nextInt(999999));
    }
    
    private void subirArchivos(UsuarioId usuarioId, ArchivosCommand archivos) {
        archivoStorage.guardar(usuarioId, TipoArchivo.FOTO_PERFIL, archivos.fotoPerfil());
        archivoStorage.guardar(usuarioId, TipoArchivo.DOCUMENTO_IDENTIDAD_FRONTAL, archivos.documentoFrente());
        archivoStorage.guardar(usuarioId, TipoArchivo.DOCUMENTO_IDENTIDAD_REVERSO, archivos.documentoReverso());
        archivoStorage.guardar(usuarioId, TipoArchivo.SELFIE_VERIFICACION, archivos.fotoEnVivo());
    }
}
```

**Criterios Técnicos**:
- [ ] Transaccional (@Transactional)
- [ ] Validación de email único antes de crear aggregate
- [ ] Subida de archivos asíncrona
- [ ] Generación OTP criptográficamente seguro
- [ ] TTL de 10 minutos para OTP
- [ ] Tests con mocks >85% coverage

---

#### TAREA-001-BE-03: Implementar Adapter JPA `UsuarioJpaAdapter` [4h]

**Archivos**:
- `infrastructure/persistence/UsuarioJpaAdapter.java`
- `infrastructure/persistence/UsuarioJpaEntity.java`
- `infrastructure/persistence/UsuarioJpaRepository.java`
- `infrastructure/persistence/UsuarioMapper.java`

**Esquema JPA Entity**:
```java
@Entity
@Table(schema = "autenticacion_schema", name = "usuarios")
public class UsuarioJpaEntity {
    @Id
    @Column(name = "pkid_usuarios")
    private UUID id;
    
    @Column(name = "email", unique = true, nullable = false)
    private String email;
    
    @Column(name = "password_hash", nullable = false)
    private String passwordHash;
    
    @Column(name = "primer_nombre", nullable = false)
    private String primerNombre;
    
    @Column(name = "segundo_nombre")
    private String segundoNombre;
    
    @Column(name = "primer_apellido", nullable = false)
    private String primerApellido;
    
    @Column(name = "segundo_apellido")
    private String segundoApellido;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "rol", nullable = false)
    private Rol rol;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "estado", nullable = false)
    private EstadoUsuario estado;
    
    @Column(name = "creation_date", nullable = false)
    private Instant creationDate;
    
    @Column(name = "expiration_date")
    private Instant expirationDate;
    
    // Getters y Setters
}
```

**Mapper (Domain ↔ JPA)**:
```java
@Component
public class UsuarioMapper {
    
    public UsuarioJpaEntity toEntity(Usuario usuario) {
        UsuarioJpaEntity entity = new UsuarioJpaEntity();
        entity.setId(usuario.getId().getValue());
        entity.setEmail(usuario.getEmail().getValue());
        entity.setPasswordHash(usuario.getPassword().getValue());
        // ... mapeo completo
        return entity;
    }
    
    public Usuario toDomain(UsuarioJpaEntity entity) {
        // Reconstruir aggregate desde entidad JPA
        return Usuario.reconstruct(
            UsuarioId.of(entity.getId()),
            Email.of(entity.getEmail()),
            Password.ofEncoded(entity.getPasswordHash()),
            NombreCompleto.of(/* ... */),
            entity.getRol(),
            entity.getEstado()
        );
    }
}
```

**Criterios**:
- [ ] Mapper bidireccional (domain ↔ entity)
- [ ] Queries optimizadas (índices en email)
- [ ] Tests de integración con H2 o Testcontainers
- [ ] No lógica de negocio en el adapter

---

#### TAREA-001-BE-04: Implementar REST Controller `RegistroEstudianteController` [3h]

**Archivos**:
- `infrastructure/web/RegistroEstudianteController.java`
- `infrastructure/web/dto/RegistroEstudianteRequest.java`
- `infrastructure/web/dto/RegistroEstudianteResponse.java`

**Endpoint**:
```java
@RestController
@RequestMapping("/api/v1/auth/estudiantes")
@Validated
public class RegistroEstudianteController {
    
    private final RegistrarEstudianteUseCase registrarUseCase;
    
    @PostMapping("/registro")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<RegistroEstudianteResponse> registrar(
            @Valid @RequestBody RegistroEstudianteRequest request,
            @RequestHeader("X-Real-IP") String ip,
            @RequestHeader("User-Agent") String userAgent) {
        
        RegistrarEstudianteCommand command = request.toCommand()
            .withMetadata(ip, userAgent);
        
        RegistrarEstudianteResponse response = registrarUseCase.ejecutar(command);
        
        return ApiResponse.success(
            response,
            "Registro iniciado. Verifica tu email para continuar."
        );
    }
}
```

**Request DTO con Bean Validation**:
```java
public record RegistroEstudianteRequest(
    @NotBlank @Email String email,
    @NotBlank @Size(min = 8) @Pattern(regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).+$") String password,
    @NotBlank String primerNombre,
    @NotBlank String primerApellido,
    @NotNull UUID generoId,
    @NotNull @Past LocalDate fechaNacimiento,
    @NotBlank String telefono,
    @NotNull UUID paisId,
    @NotNull UUID ciudadId,
    @NotNull UUID nivelEducativoId,
    @Valid ArchivosRequest archivos,
    @AssertTrue boolean aceptaTerminos,
    @AssertTrue boolean aceptaHabeasData
) {
    public RegistrarEstudianteCommand toCommand() {
        return new RegistrarEstudianteCommand(/* mapeo */);
    }
}
```

**Criterios**:
- [ ] Validación con @Valid y Bean Validation
- [ ] Manejo de excepciones con @ControllerAdvice
- [ ] Documentación OpenAPI/Swagger
- [ ] Tests E2E con RestAssured o MockMvc
- [ ] Logging estructurado (SLF4J + Logback)

---

### 🎨 FRONTEND TASKS

#### TAREA-001-FE-01: Crear componente `StudentRegistration` multi-step [6h]

**Archivos**:
- `components/auth/StudentRegistration.tsx`
- `components/auth/StudentRegistration.test.tsx`
- `hooks/useStudentRegistration.ts`

**Implementación (Estado y Lógica)**:
```typescript
export default function StudentRegistration() {
  const [currentStep, setCurrentStep] = useState(1);
  const [formData, setFormData] = useState<StudentFormData>({
    // Estado inicial
  });
  
  const { mutate: registrar, isLoading } = useMutation({
    mutationFn: (data: StudentFormData) => authService.registrarEstudiante(data),
    onSuccess: (response) => {
      toast.success('Registro exitoso. Revisa tu email.');
      router.push('/auth/verificar-otp');
    },
    onError: (error) => {
      toast.error(error.message || 'Error en el registro');
    }
  });
  
  const handleNext = () => {
    if (validateCurrentStep()) {
      setCurrentStep(prev => prev + 1);
    }
  };
  
  // Render steps...
}
```

**Criterios**:
- [ ] 4 steps implementados (Credenciales, Info, Verificación, Confirmación)
- [ ] Validación con Zod schema
- [ ] Tests con React Testing Library
- [ ] Accesibilidad WCAG 2.1 AA
- [ ] Responsive design (mobile + desktop)

---

## 📊 Estimación Consolidada

| Tarea | Esfuerzo | Rol |
|-------|----------|-----|
| Backend Aggregate Usuario | 5h | Backend Dev |
| Backend Use Case | 6h | Backend Dev |
| Backend JPA Adapter | 4h | Backend Dev |
| Backend REST Controller | 3h | Backend Dev |
| Frontend Multi-step Form | 6h | Frontend Dev |
| Frontend Catálogos Dinámicos | 2h | Frontend Dev |
| E2E Tests (Playwright) | 4h | QA Engineer |
| **TOTAL** | **30h** | **~4 días** |

**Story Points**: 13 (Fibonacci)

---

## 🔗 Dependencies & Blockers

### Dependencias:
- ✅ [V4] Schema `shared_schema` creado (catálogos)
- ✅ [V5] Schema `autenticacion_schema` creado
- ⏳ [HUT-002] Servicio de Email configurado (SendGrid/AWS SES)
- ⏳ [HUT-003] MinIO/S3 configurado para archivos

### Blockers Potenciales:
- ⚠️ Configuración SMTP no disponible en staging
- ⚠️ Límites de almacenamiento en MinIO on-premise

---

## ✅ Definition of Done (DoD)

### Backend:
- [ ] Código en feature branch con PR aprobado
- [ ] Tests unitarios >85% coverage
- [ ] Tests de integración (repositories)
- [ ] SonarQube sin code smells críticos
- [ ] Documentación OpenAPI generada
- [ ] Flyway migration aplicada en dev/staging

### Frontend:
- [ ] Componente implementado con TypeScript estricto
- [ ] Tests unitarios >80% coverage
- [ ] Accesibilidad validada (Lighthouse >90)
- [ ] Responsive design verificado
- [ ] Error states manejados

### E2E:
- [ ] Happy path cubierto
- [ ] Edge cases cubiertos
- [ ] Tests ejecutados en CI/CD
- [ ] Performance validado (<2s por step)

---

**Versión**: 1.0  
**Fecha**: 2025-11-16  
**Autor**: Technical User Stories Engineer  
**Metodología**: ZNS v2.0
