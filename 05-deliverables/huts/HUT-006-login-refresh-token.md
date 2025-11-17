# HUT-006: Login + Refresh Token

## 📋 Metadatos

| Atributo | Valor |
|----------|-------|
| **HU Origen** | HU-006 - Autenticación de Usuarios |
| **Bounded Context** | Autenticación |
| **Sprint** | Sprint 2 |
| **Story Points** | 8 |
| **Prioridad** | CRÍTICA |
| **Dependencias** | HUT-001, HUT-003 |

---

## 🎯 Historia de Usuario

**Como** usuario registrado y verificado  
**Quiero** iniciar sesión con email y contraseña  
**Para** acceder a la plataforma de forma segura

### Criterios de Aceptación
- ✅ Login con email + password
- ✅ Generación de Access Token (15 min) + Refresh Token (7 días)
- ✅ Refresh token rotation (nuevo par de tokens)
- ✅ Detección de dispositivo + geolocalización
- ✅ Límite de sesiones activas por usuario (máx 5)
- ✅ Notificación email nueva sesión (opcional)
- ✅ Rate limiting (max 5 intentos/5min)
- ✅ Bloqueo temporal tras fallos repetidos

---

## 🏗️ Contexto Arquitectónico

- **Arquitectura**: Hexagonal + JWT Stateless
- **Patterns**: Token Rotation, Device Fingerprinting, Sliding Sessions
- **Security**: bcrypt password, HMAC-SHA256 tokens, Redis blacklist
- **ADRs**: [ADR-003] OAuth2 + JWT, [ADR-016] Token rotation

---

## 📊 JSON Structures

### Request: Login

```json
POST /api/v1/auth/login

{
  "email": "maria.garcia@email.com",
  "password": "SecurePass123!",
  "dispositivo": {
    "tipo": "WEB",
    "navegador": "Chrome 120",
    "sistemaOperativo": "Windows 11",
    "ip": "192.168.1.100",
    "userAgent": "Mozilla/5.0..."
  },
  "recordarme": true
}

Response 200:
{
  "status": "success",
  "message": "Inicio de sesión exitoso",
  "data": {
    "usuario": {
      "usuarioId": "650e8400-e29b-41d4-a716-446655440000",
      "email": "maria.garcia@email.com",
      "nombreCompleto": "María García López",
      "rol": "TUTOR",
      "emailVerificado": true,
      "fotoPerfil": "https://storage.mitoga.com/..."
    },
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "rt_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6...",
      "tokenType": "Bearer",
      "expiresIn": 900,
      "refreshExpiresIn": 604800
    },
    "sesion": {
      "sesionId": "950e8400-e29b-41d4-a716-446655440000",
      "dispositivo": "Chrome en Windows 11",
      "ubicacion": "Madrid, España",
      "fechaCreacion": "2025-11-16T10:30:00Z",
      "ultimaActividad": "2025-11-16T10:30:00Z"
    },
    "navegacion": {
      "dashboardUrl": "/dashboard",
      "perfilUrl": "/perfil/650e8400-e29b-41d4-a716-446655440000"
    }
  },
  "timestamp": "2025-11-16T10:30:00.123Z"
}
```

### Response: Credenciales Inválidas (401)

```json
{
  "status": "error",
  "message": "Credenciales incorrectas",
  "data": {
    "codigo": "CREDENCIALES_INVALIDAS",
    "intentosRestantes": 3,
    "bloqueadoHasta": null
  },
  "timestamp": "2025-11-16T10:30:00.123Z"
}
```

### Response: Usuario Bloqueado (423)

```json
{
  "status": "error",
  "message": "Cuenta temporalmente bloqueada",
  "data": {
    "codigo": "CUENTA_BLOQUEADA",
    "razon": "Múltiples intentos fallidos de inicio de sesión",
    "bloqueadoHasta": "2025-11-16T10:45:00Z",
    "minutosRestantes": 15,
    "accionRecomendada": "Espera 15 minutos o restablece tu contraseña"
  },
  "timestamp": "2025-11-16T10:30:00.123Z"
}
```

### Request: Refresh Token

```json
POST /api/v1/auth/refresh

{
  "refreshToken": "rt_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6..."
}

Response 200:
{
  "status": "success",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "rt_z9y8x7w6v5u4t3s2r1q0p9o8n7m6l5k4...",
    "tokenType": "Bearer",
    "expiresIn": 900,
    "refreshExpiresIn": 604800
  }
}
```

### Response: Refresh Token Inválido (401)

```json
{
  "status": "error",
  "message": "Token de actualización inválido o expirado",
  "data": {
    "codigo": "REFRESH_TOKEN_INVALIDO",
    "accion": "REAUTENTICAR",
    "loginUrl": "/auth/login"
  }
}
```

### Request: Logout

```json
POST /api/v1/auth/logout
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

{
  "refreshToken": "rt_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6...",
  "cerrarTodasLasSesiones": false
}

Response 200:
{
  "status": "success",
  "message": "Sesión cerrada exitosamente",
  "data": {
    "sesionesTerminadas": 1,
    "mensaje": "Has cerrado sesión correctamente"
  }
}
```

### Request: Listar Sesiones Activas

```json
GET /api/v1/auth/sesiones
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

Response 200:
{
  "status": "success",
  "data": {
    "sesiones": [
      {
        "sesionId": "950e8400-e29b-41d4-a716-446655440000",
        "dispositivo": "Chrome en Windows 11",
        "ubicacion": "Madrid, España",
        "ip": "192.168.1.100",
        "esActual": true,
        "fechaCreacion": "2025-11-16T10:30:00Z",
        "ultimaActividad": "2025-11-16T11:45:00Z"
      },
      {
        "sesionId": "850e8400-e29b-41d4-a716-446655440001",
        "dispositivo": "Safari en iPhone 15",
        "ubicacion": "Barcelona, España",
        "ip": "192.168.1.105",
        "esActual": false,
        "fechaCreacion": "2025-11-15T08:00:00Z",
        "ultimaActividad": "2025-11-15T22:30:00Z"
      }
    ],
    "totalSesiones": 2,
    "limiteMaximo": 5
  }
}
```

---

## 📊 Database Schema

### Tabla: `autenticacion_schema.sesiones`

```sql
CREATE TABLE IF NOT EXISTS autenticacion_schema.sesiones (
    pkid_sesion UUID DEFAULT gen_random_uuid() NOT NULL,
    usuario_id UUID NOT NULL,
    refresh_token_hash VARCHAR(64) NOT NULL UNIQUE,
    
    -- Dispositivo
    dispositivo_tipo VARCHAR(20), -- WEB, MOBILE_IOS, MOBILE_ANDROID, TABLET
    navegador VARCHAR(100),
    sistema_operativo VARCHAR(100),
    user_agent TEXT,
    
    -- Ubicación
    ip_address VARCHAR(45),
    pais VARCHAR(100),
    ciudad VARCHAR(100),
    latitud DECIMAL(10, 8),
    longitud DECIMAL(11, 8),
    
    -- Seguridad
    es_sesion_activa BOOLEAN DEFAULT TRUE,
    ultimo_uso TIMESTAMPTZ DEFAULT NOW(),
    fecha_expiracion TIMESTAMPTZ NOT NULL,
    
    -- Auditoría
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    fecha_cierre TIMESTAMPTZ,
    motivo_cierre VARCHAR(50), -- LOGOUT, EXPIRACION, REVOCACION, NUEVO_LOGIN
    
    CONSTRAINT pk_sesiones PRIMARY KEY (pkid_sesion),
    CONSTRAINT fk_sesion_usuario FOREIGN KEY (usuario_id)
        REFERENCES autenticacion_schema.usuarios(pkid_usuarios) ON DELETE CASCADE
);

CREATE INDEX idx_sesiones_usuario ON autenticacion_schema.sesiones(usuario_id);
CREATE INDEX idx_sesiones_activas ON autenticacion_schema.sesiones(usuario_id, es_sesion_activa) 
    WHERE es_sesion_activa = TRUE;
CREATE INDEX idx_sesiones_refresh_token ON autenticacion_schema.sesiones(refresh_token_hash);
CREATE INDEX idx_sesiones_expiracion ON autenticacion_schema.sesiones(fecha_expiracion);
```

### Tabla: `autenticacion_schema.intentos_login`

```sql
CREATE TABLE IF NOT EXISTS autenticacion_schema.intentos_login (
    pkid_intento UUID DEFAULT gen_random_uuid() NOT NULL,
    email VARCHAR(255) NOT NULL,
    ip_address VARCHAR(45) NOT NULL,
    fue_exitoso BOOLEAN NOT NULL,
    motivo_fallo VARCHAR(100),
    user_agent TEXT,
    fecha_intento TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    
    CONSTRAINT pk_intentos_login PRIMARY KEY (pkid_intento)
);

CREATE INDEX idx_intentos_email_fecha ON autenticacion_schema.intentos_login(email, fecha_intento DESC);
CREATE INDEX idx_intentos_ip_fecha ON autenticacion_schema.intentos_login(ip_address, fecha_intento DESC);
```

---

## 🔧 Tareas Técnicas

### TAREA-006-BE-01: Value Object RefreshToken [2h]

**Archivos**: `domain/autenticacion/RefreshToken.java`

**Implementación**:
```java
public record RefreshToken(String valor) {
    
    private static final String PREFIX = "rt_";
    private static final int TOKEN_LENGTH = 64;
    
    public RefreshToken {
        Objects.requireNonNull(valor);
        if (!valor.startsWith(PREFIX)) {
            throw new IllegalArgumentException("Refresh token debe iniciar con " + PREFIX);
        }
        if (valor.length() != PREFIX.length() + TOKEN_LENGTH) {
            throw new IllegalArgumentException("Refresh token longitud inválida");
        }
    }
    
    public static RefreshToken generar() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[TOKEN_LENGTH / 2]; // 32 bytes = 64 hex chars
        random.nextBytes(bytes);
        
        String token = PREFIX + bytesToHex(bytes);
        return new RefreshToken(token);
    }
    
    public String hash() {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(valor.getBytes(StandardCharsets.UTF_8));
            return bytesToHex(hash);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 no disponible", e);
        }
    }
    
    private static String bytesToHex(byte[] bytes) {
        StringBuilder result = new StringBuilder();
        for (byte b : bytes) {
            result.append(String.format("%02x", b));
        }
        return result.toString();
    }
}
```

---

### TAREA-006-BE-02: Domain Service AutenticacionService [4h]

**Archivos**: `domain/autenticacion/AutenticacionService.java`

**Implementación**:
```java
@DomainService
public class AutenticacionService {
    
    private final PasswordEncoder passwordEncoder;
    
    public SesionUsuario autenticar(Email email, Password password, 
                                     DispositivoInfo dispositivo) {
        // Validar credenciales
        Usuario usuario = buscarPorEmail(email);
        
        if (!passwordEncoder.matches(password.valor(), usuario.getPasswordHash())) {
            registrarIntentoFallido(email, dispositivo.getIp(), "PASSWORD_INCORRECTO");
            throw new CredencialesInvalidasException();
        }
        
        // Validar estado usuario
        if (!usuario.estaVerificado()) {
            throw new EmailNoVerificadoException();
        }
        
        if (usuario.estaBloqueado()) {
            throw new UsuarioBloqueadoException(usuario.getBloqueoHasta());
        }
        
        // Validar límite de sesiones
        int sesionesActivas = contarSesionesActivas(usuario.getId());
        if (sesionesActivas >= 5) {
            cerrarSesionMasAntigua(usuario.getId());
        }
        
        // Generar tokens
        RefreshToken refreshToken = RefreshToken.generar();
        
        // Crear sesión
        Sesion sesion = Sesion.crear(
            usuario.getId(),
            refreshToken,
            dispositivo,
            Duration.ofDays(7)
        );
        
        // Registrar intento exitoso
        registrarIntentoExitoso(email, dispositivo.getIp());
        
        // Publicar evento
        DomainEvents.publish(new UsuarioAutenticadoEvent(
            usuario.getId(),
            dispositivo,
            Instant.now()
        ));
        
        return new SesionUsuario(usuario, sesion, refreshToken);
    }
    
    public SesionUsuario renovarSesion(RefreshToken refreshToken) {
        // Buscar sesión por token hash
        Sesion sesion = buscarPorRefreshToken(refreshToken.hash())
            .orElseThrow(() -> new RefreshTokenInvalidoException());
        
        // Validar expiración
        if (sesion.estaExpirada()) {
            throw new RefreshTokenExpiradoException();
        }
        
        // Token rotation: generar nuevo par
        RefreshToken nuevoRefreshToken = RefreshToken.generar();
        
        // Invalidar token anterior
        sesion.renovar(nuevoRefreshToken);
        
        Usuario usuario = buscarUsuario(sesion.getUsuarioId());
        
        return new SesionUsuario(usuario, sesion, nuevoRefreshToken);
    }
    
    public void cerrarSesion(UsuarioId usuarioId, RefreshToken refreshToken, 
                              boolean cerrarTodas) {
        if (cerrarTodas) {
            cerrarTodasLasSesiones(usuarioId);
        } else {
            Sesion sesion = buscarPorRefreshToken(refreshToken.hash())
                .orElseThrow(() -> new SesionNoEncontradaException());
            
            sesion.cerrar(MotivoCierre.LOGOUT);
        }
        
        DomainEvents.publish(new SesionCerradaEvent(usuarioId, Instant.now()));
    }
    
    private void validarIntentosLogin(Email email, String ip) {
        int intentosFallidos = contarIntentosFallidos(email, Duration.ofMinutes(5));
        
        if (intentosFallidos >= 5) {
            bloquearTemporalmente(email, Duration.ofMinutes(15));
            throw new CuentaBloqueadaException(Duration.ofMinutes(15));
        }
    }
}
```

---

### TAREA-006-BE-03: Use Case IniciarSesionUseCase [3h]

**Archivos**: `application/usecases/auth/IniciarSesionUseCase.java`

**Implementación**:
```java
@UseCase
@Transactional
public class IniciarSesionUseCase {
    
    private final AutenticacionService autenticacionService;
    private final SesionRepositoryPort sesionRepository;
    private final JwtTokenProvider jwtProvider;
    private final EmailPort emailService;
    private final GeolocalizacionPort geolocalizacionService;
    
    public IniciarSesionResponse ejecutar(IniciarSesionCommand command) {
        
        // 1. Validar rate limiting
        validarRateLimiting(command.email(), command.dispositivo().getIp());
        
        // 2. Enriquecer info dispositivo con geolocalización
        DispositivoInfo dispositivo = enriquecerDispositivo(
            command.dispositivo(),
            geolocalizacionService.obtenerUbicacion(command.dispositivo().getIp())
        );
        
        // 3. Autenticar (domain service)
        SesionUsuario sesionUsuario = autenticacionService.autenticar(
            Email.of(command.email()),
            Password.of(command.password()),
            dispositivo
        );
        
        // 4. Persistir sesión
        sesionRepository.save(sesionUsuario.getSesion());
        
        // 5. Generar JWT access token
        String accessToken = jwtProvider.generarAccessToken(
            sesionUsuario.getUsuario(),
            Duration.ofMinutes(15)
        );
        
        // 6. Enviar email nueva sesión (async)
        if (command.notificarNuevaSesion()) {
            CompletableFuture.runAsync(() -> 
                emailService.enviarNuevaSesionDetectada(
                    sesionUsuario.getUsuario().getEmail(),
                    dispositivo
                )
            );
        }
        
        // 7. Log auditoría
        log.info("Login exitoso - Usuario: {}, Dispositivo: {}, IP: {}, Ubicación: {}",
            sesionUsuario.getUsuario().getId(),
            dispositivo.getTipo(),
            dispositivo.getIp(),
            dispositivo.getCiudad());
        
        return IniciarSesionResponse.of(
            sesionUsuario.getUsuario(),
            accessToken,
            sesionUsuario.getRefreshToken().valor(),
            sesionUsuario.getSesion()
        );
    }
    
    private void validarRateLimiting(String email, String ip) {
        // Bucket4j + Redis
        Bucket bucket = obtenerBucket(email, ip);
        
        if (!bucket.tryConsume(1)) {
            throw new RateLimitExcedidoException(
                "Demasiados intentos de login. Intenta en 5 minutos."
            );
        }
    }
}
```

---

### TAREA-006-BE-04: Use Case RenovarTokenUseCase [2h]

**Implementación**:
```java
@UseCase
@Transactional
public class RenovarTokenUseCase {
    
    private final AutenticacionService autenticacionService;
    private final SesionRepositoryPort sesionRepository;
    private final JwtTokenProvider jwtProvider;
    private final RedisTemplate<String, String> redisTemplate;
    
    public RenovarTokenResponse ejecutar(RenovarTokenCommand command) {
        
        // 1. Renovar sesión (domain service)
        SesionUsuario sesionUsuario = autenticacionService.renovarSesion(
            RefreshToken.of(command.refreshToken())
        );
        
        // 2. Actualizar sesión en BD
        sesionRepository.save(sesionUsuario.getSesion());
        
        // 3. Blacklist del refresh token anterior (Redis)
        String tokenAnteriorHash = RefreshToken.of(command.refreshToken()).hash();
        redisTemplate.opsForValue().set(
            "blacklist:rt:" + tokenAnteriorHash,
            "revoked",
            Duration.ofDays(7)
        );
        
        // 4. Generar nuevo access token
        String nuevoAccessToken = jwtProvider.generarAccessToken(
            sesionUsuario.getUsuario(),
            Duration.ofMinutes(15)
        );
        
        log.info("Token renovado - Usuario: {}, Sesión: {}",
            sesionUsuario.getUsuario().getId(),
            sesionUsuario.getSesion().getId());
        
        return RenovarTokenResponse.of(
            nuevoAccessToken,
            sesionUsuario.getRefreshToken().valor()
        );
    }
}
```

---

### TAREA-006-BE-05: REST Controller AutenticacionController [2h]

**Endpoints**:
```java
@RestController
@RequestMapping("/api/v1/auth")
public class AutenticacionController {
    
    @PostMapping("/login")
    @RateLimiter(name = "login", fallbackMethod = "loginRateLimitExceeded")
    public ResponseEntity<ApiResponse<IniciarSesionResponse>> login(
            @Valid @RequestBody IniciarSesionRequest request,
            HttpServletRequest httpRequest) {
        
        DispositivoInfo dispositivo = extraerInfoDispositivo(httpRequest);
        
        IniciarSesionCommand command = IniciarSesionCommand.builder()
            .email(request.email())
            .password(request.password())
            .dispositivo(dispositivo)
            .notificarNuevaSesion(request.recordarme())
            .build();
        
        IniciarSesionResponse response = iniciarSesionUseCase.ejecutar(command);
        
        return ResponseEntity.ok(
            ApiResponse.success(response, "Inicio de sesión exitoso")
        );
    }
    
    @PostMapping("/refresh")
    public ResponseEntity<ApiResponse<RenovarTokenResponse>> refresh(
            @Valid @RequestBody RenovarTokenRequest request) {
        
        RenovarTokenCommand command = new RenovarTokenCommand(request.refreshToken());
        RenovarTokenResponse response = renovarTokenUseCase.ejecutar(command);
        
        return ResponseEntity.ok(ApiResponse.success(response));
    }
    
    @PostMapping("/logout")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<ApiResponse<CerrarSesionResponse>> logout(
            @Valid @RequestBody CerrarSesionRequest request,
            @AuthenticationPrincipal UsuarioAutenticado usuario) {
        
        CerrarSesionCommand command = new CerrarSesionCommand(
            usuario.getUsuarioId(),
            RefreshToken.of(request.refreshToken()),
            request.cerrarTodasLasSesiones()
        );
        
        CerrarSesionResponse response = cerrarSesionUseCase.ejecutar(command);
        
        return ResponseEntity.ok(
            ApiResponse.success(response, "Sesión cerrada exitosamente")
        );
    }
    
    @GetMapping("/sesiones")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<ApiResponse<List<SesionActivaDTO>>> listarSesiones(
            @AuthenticationPrincipal UsuarioAutenticado usuario) {
        
        List<SesionActivaDTO> sesiones = listarSesionesQuery.ejecutar(
            usuario.getUsuarioId()
        );
        
        return ResponseEntity.ok(ApiResponse.success(sesiones));
    }
    
    @ExceptionHandler(CredencialesInvalidasException.class)
    public ResponseEntity<ApiResponse<ErrorDetails>> handleCredencialesInvalidas(
            CredencialesInvalidasException ex) {
        
        ErrorDetails error = new ErrorDetails(
            "CREDENCIALES_INVALIDAS",
            ex.getIntentosRestantes(),
            null
        );
        
        return ResponseEntity
            .status(HttpStatus.UNAUTHORIZED)
            .body(ApiResponse.error(error, "Credenciales incorrectas"));
    }
    
    @ExceptionHandler(CuentaBloqueadaException.class)
    public ResponseEntity<ApiResponse<ErrorDetails>> handleCuentaBloqueada(
            CuentaBloqueadaException ex) {
        
        ErrorDetails error = new ErrorDetails(
            "CUENTA_BLOQUEADA",
            0,
            ex.getBloqueoHasta()
        );
        
        return ResponseEntity
            .status(HttpStatus.LOCKED)
            .body(ApiResponse.error(error, "Cuenta temporalmente bloqueada"));
    }
}
```

---

### TAREA-006-FE-01: Página Login [3h]

**Archivos**: `app/auth/login/page.tsx`

**Implementación**:
```typescript
export default function LoginPage() {
  const router = useRouter();
  const { register, handleSubmit, formState: { errors } } = useForm<LoginForm>({
    resolver: zodResolver(loginSchema)
  });
  
  const { mutate: login, isLoading, error } = useMutation({
    mutationFn: (data: LoginForm) => authService.login(data),
    onSuccess: (response) => {
      // Guardar tokens
      tokenStorage.setAccessToken(response.data.tokens.accessToken);
      tokenStorage.setRefreshToken(response.data.tokens.refreshToken);
      
      // Guardar usuario
      userStorage.setUser(response.data.usuario);
      
      toast.success('¡Bienvenido de vuelta!');
      
      // Redirigir según rol
      const redirectUrl = response.data.navegacion.dashboardUrl;
      router.push(redirectUrl);
    },
    onError: (error: ApiError) => {
      if (error.data?.codigo === 'CUENTA_BLOQUEADA') {
        toast.error(
          `Cuenta bloqueada. Intenta en ${error.data.minutosRestantes} minutos.`
        );
      } else {
        toast.error('Credenciales incorrectas');
      }
    }
  });
  
  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50">
      <Card className="w-full max-w-md p-8">
        <h1 className="text-3xl font-bold text-center mb-6">
          Iniciar Sesión
        </h1>
        
        <form onSubmit={handleSubmit(login)} className="space-y-4">
          <Input
            {...register('email')}
            type="email"
            label="Email"
            placeholder="tu@email.com"
            error={errors.email?.message}
            autoComplete="email"
            autoFocus
          />
          
          <Input
            {...register('password')}
            type="password"
            label="Contraseña"
            error={errors.password?.message}
            autoComplete="current-password"
          />
          
          <div className="flex items-center justify-between">
            <Checkbox
              {...register('recordarme')}
              label="Recordarme"
            />
            
            <Link 
              href="/auth/olvide-password" 
              className="text-sm text-blue-600 hover:underline"
            >
              ¿Olvidaste tu contraseña?
            </Link>
          </div>
          
          {error && (
            <Alert variant="error">
              {error.message}
              {error.data?.intentosRestantes > 0 && (
                <p className="text-sm mt-1">
                  Intentos restantes: {error.data.intentosRestantes}
                </p>
              )}
            </Alert>
          )}
          
          <Button 
            type="submit" 
            className="w-full" 
            loading={isLoading}
          >
            Iniciar Sesión
          </Button>
        </form>
        
        <div className="mt-6 text-center">
          <p className="text-gray-600">
            ¿No tienes cuenta?{' '}
            <Link href="/auth/registro" className="text-blue-600 font-semibold">
              Regístrate aquí
            </Link>
          </p>
        </div>
        
        <Divider className="my-6">O continúa con</Divider>
        
        <div className="grid grid-cols-2 gap-3">
          <Button variant="outline" onClick={() => handleOAuthLogin('google')}>
            <GoogleIcon /> Google
          </Button>
          <Button variant="outline" onClick={() => handleOAuthLogin('facebook')}>
            <FacebookIcon /> Facebook
          </Button>
        </div>
      </Card>
    </div>
  );
}
```

---

### TAREA-006-FE-02: Token Refresh Interceptor [2h]

**Archivos**: `lib/api/interceptors/tokenRefreshInterceptor.ts`

**Implementación**:
```typescript
export function setupTokenRefreshInterceptor(apiClient: AxiosInstance) {
  
  // Request interceptor: añadir access token
  apiClient.interceptors.request.use((config) => {
    const accessToken = tokenStorage.getAccessToken();
    if (accessToken) {
      config.headers.Authorization = `Bearer ${accessToken}`;
    }
    return config;
  });
  
  // Response interceptor: refresh token si 401
  apiClient.interceptors.response.use(
    (response) => response,
    async (error) => {
      const originalRequest = error.config;
      
      // Si 401 y no es retry
      if (error.response?.status === 401 && !originalRequest._retry) {
        originalRequest._retry = true;
        
        try {
          const refreshToken = tokenStorage.getRefreshToken();
          
          if (!refreshToken) {
            throw new Error('No refresh token');
          }
          
          // Refresh tokens
          const response = await authService.refreshToken({ refreshToken });
          
          // Guardar nuevos tokens
          tokenStorage.setAccessToken(response.data.accessToken);
          tokenStorage.setRefreshToken(response.data.refreshToken);
          
          // Reintentar request original
          originalRequest.headers.Authorization = 
            `Bearer ${response.data.accessToken}`;
          
          return apiClient(originalRequest);
          
        } catch (refreshError) {
          // Refresh falló: logout
          tokenStorage.clear();
          window.location.href = '/auth/login';
          return Promise.reject(refreshError);
        }
      }
      
      return Promise.reject(error);
    }
  );
}
```

---

## 📊 Estimación

| Tarea | Esfuerzo | Rol |
|-------|----------|-----|
| Backend RefreshToken VO | 2h | Backend Dev |
| Backend Domain Service | 4h | Backend Dev |
| Backend Use Cases | 5h | Backend Dev |
| Backend REST Controller | 2h | Backend Dev |
| Frontend Login Page | 3h | Frontend Dev |
| Frontend Token Interceptor | 2h | Frontend Dev |
| Rate Limiting Config | 1h | Backend Dev |
| Tests E2E | 3h | QA Engineer |
| **TOTAL** | **22h** | **~3 días** |

**Story Points**: 8

---

## ✅ Definition of Done

- [ ] JWT tokens generados correctamente
- [ ] Token rotation implementado
- [ ] Rate limiting (5 intentos/5min)
- [ ] Geolocalización por IP
- [ ] Email nueva sesión
- [ ] Sesiones listadas en UI
- [ ] Tests E2E (login + refresh + logout)
- [ ] Blacklist Redis para tokens revocados

---

**Versión**: 1.0  
**Fecha**: 2025-11-16
