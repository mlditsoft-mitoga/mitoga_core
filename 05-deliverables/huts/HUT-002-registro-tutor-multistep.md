# HUT-002: Implementación de Registro de Tutores Multi-step

## 📋 Metadatos

| Atributo | Valor |
|----------|-------|
| **HU Origen** | HU-002 - Registro de Tutores |
| **Bounded Context** | Tutores (Marketplace) |
| **Sprint** | Sprint 2 |
| **Story Points** | 21 (Fibonacci) |
| **Prioridad** | ALTA |
| **Tipo** | Feature |

---

## 🎯 Historia de Usuario Origen

**Como** tutor profesional  
**Quiero** registrarme en la plataforma con proceso de aprobación  
**Para** ofrecer mis servicios de tutoría y generar ingresos

### Criterios de Aceptación (Negocio)
- ✅ Registro completo de información profesional
- ✅ Carga de certificados educativos y experiencia laboral
- ✅ Selección de conocimientos/habilidades a enseñar
- ✅ Selección de idiomas con nivel de dominio
- ✅ Video de presentación (opcional)
- ✅ Definición de tarifa por hora
- ✅ Proceso de aprobación por administrador
- ✅ Estados: PENDIENTE_REGISTRO → EN_REVISION → APROBADO/RECHAZADO

---

## 🏗️ Contexto Arquitectónico

### Patrón Arquitectónico
- **Arquitectura**: Hexagonal + DDD
- **Aggregate**: `PerfilTutor` + `ProcesoRegistroTutor` (saga)
- **Workflow**: Estado multi-step persistente

### ADRs Relacionados
- **[ADR-003]** Autenticación JWT + OAuth2
- **[ADR-012]** Storage MinIO/S3 para certificados
- **[ADR-016]** Proceso de aprobación de tutores (workflow)

---

## 📊 Estructura de Datos

### Objeto JSON Completo (Request Paso 1-4)

```json
{
  "step": 1,
  "procesoId": "750e8400-e29b-41d4-a716-446655440000",
  "credenciales": {
    "email": "tutor@example.com",
    "password": "SecurePass123!",
    "confirmPassword": "SecurePass123!"
  },
  "informacionBasica": {
    "primerNombre": "María",
    "segundoNombre": "Elena",
    "primerApellido": "Rodríguez",
    "segundoApellido": "Gómez",
    "generoId": "550e8400-e29b-41d4-a716-446655440000",
    "fechaNacimiento": "15/08/1990",
    "telefono": "+57 311 9876543",
    "paisId": "550e8400-e29b-41d4-a716-446655440001",
    "ciudadId": "550e8400-e29b-41d4-a716-446655440002",
    "direccion": "Carrera 10 #20-30, Casa 5",
    "nivelEducativoId": "550e8400-e29b-41d4-a716-446655440004",
    "tituloProfesional": "Ingeniera de Sistemas",
    "descripcionBreve": "Tutora especializada en programación web con 8 años de experiencia",
    "descripcionCompleta": "Ingeniera de Sistemas con maestría en Inteligencia Artificial. He trabajado en empresas de tecnología liderando proyectos de desarrollo web. Me apasiona enseñar y compartir conocimientos sobre JavaScript, React, Node.js y arquitectura de software."
  },
  "experienciasLaborales": [
    {
      "empresa": "Tech Solutions S.A.S",
      "cargo": "Senior Full Stack Developer",
      "fechaInicio": "2020-03-01",
      "fechaFin": null,
      "esTrabajoActual": true,
      "descripcion": "Desarrollo de aplicaciones web empresariales con React y Node.js",
      "paisEmpresaId": "550e8400-e29b-41d4-a716-446655440001",
      "ciudadEmpresaId": "550e8400-e29b-41d4-a716-446655440002",
      "sectorEmpresa": "Tecnología",
      "tipoEmpleo": "TIEMPO_COMPLETO"
    },
    {
      "empresa": "Digital Innovations",
      "cargo": "Frontend Developer",
      "fechaInicio": "2017-06-15",
      "fechaFin": "2020-02-28",
      "esTrabajoActual": false,
      "descripcion": "Desarrollo de interfaces de usuario con React y Vue.js",
      "paisEmpresaId": "550e8400-e29b-41d4-a716-446655440001",
      "sectorEmpresa": "Tecnología",
      "tipoEmpleo": "TIEMPO_COMPLETO"
    }
  ],
  "conocimientos": [
    {
      "conocimientoId": "850e8400-e29b-41d4-a716-446655440000",
      "nivelExperticia": "EXPERTO",
      "anosExperiencia": 8,
      "puedeEnsenarPrincipiantes": true,
      "puedeEnsenarAvanzados": true
    },
    {
      "conocimientoId": "850e8400-e29b-41d4-a716-446655440001",
      "nivelExperticia": "AVANZADO",
      "anosExperiencia": 6,
      "puedeEnsenarPrincipiantes": true,
      "puedeEnsenarAvanzados": true
    }
  ],
  "idiomas": [
    {
      "idiomaId": "950e8400-e29b-41d4-a716-446655440000",
      "nivelDominio": "NATIVO"
    },
    {
      "idiomaId": "950e8400-e29b-41d4-a716-446655440001",
      "nivelDominio": "AVANZADO"
    }
  ],
  "configuracionComercial": {
    "tarifaPorHora": 25000.00,
    "moneda": "COP",
    "aceptaReservaInmediata": true,
    "tiempoRespuestaHoras": 24,
    "diasAnticipacionReserva": 1,
    "duracionSesionMinutos": 60,
    "disponibilidadHorarios": {
      "lunes": ["09:00-12:00", "14:00-18:00"],
      "martes": ["09:00-12:00", "14:00-18:00"],
      "miercoles": ["14:00-18:00"],
      "jueves": ["09:00-12:00", "14:00-18:00"],
      "viernes": ["09:00-12:00"],
      "sabado": [],
      "domingo": []
    }
  },
  "archivos": {
    "fotoPerfil": "base64_encoded_image",
    "documentoFrente": "base64_encoded_image",
    "documentoReverso": "base64_encoded_image",
    "fotoEnVivo": "base64_encoded_image",
    "videoPresentacion": "video_url_or_base64",
    "certificadosEducativos": [
      {
        "nombre": "Título Ingeniería",
        "archivo": "base64_pdf_or_image",
        "tipoDocumento": "CERTIFICADO_EDUCATIVO"
      }
    ],
    "certificadosExperiencia": [
      {
        "nombre": "Certificado Tech Solutions",
        "archivo": "base64_pdf",
        "tipoDocumento": "CERTIFICADO_EXPERIENCIA"
      }
    ]
  },
  "aceptaciones": {
    "aceptaTerminos": true,
    "aceptaCodigoConducta": true,
    "aceptaHabeasData": true,
    "fechaAceptacion": "2025-11-16T14:30:00Z"
  },
  "metadata": {
    "ipRegistro": "192.168.1.105",
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
  "message": "Registro de tutor iniciado. Tu perfil será revisado por nuestro equipo.",
  "data": {
    "tutorId": "750e8400-e29b-41d4-a716-446655440000",
    "usuarioId": "650e8400-e29b-41d4-a716-446655440000",
    "email": "tutor@example.com",
    "estadoAprobacion": "EN_REVISION",
    "procesoRegistroId": "750e8400-e29b-41d4-a716-446655440000",
    "stepCompletado": 4,
    "fechaEnvioRevision": "2025-11-16T14:30:00Z",
    "tiempoEstimadoRevision": "24-48 horas"
  },
  "timestamp": "2025-11-16T14:30:15.234Z"
}
```

---

## 🔧 Tareas Técnicas Detalladas

### 📦 BACKEND TASKS

#### TAREA-002-BE-01: Crear Aggregate `PerfilTutor` [6h]

**Descripción**: Aggregate Root para perfil completo de tutor

**Archivos**:
- `domain/tutores/PerfilTutor.java`
- `domain/tutores/ExperienciaLaboral.java` (Entity)
- `domain/tutores/ConocimientoTutor.java` (Value Object)
- `domain/tutores/IdiomaTutor.java` (Value Object)
- `domain/tutores/TarifaPorHora.java` (Value Object)

**Implementación Esperada**:
```java
@AggregateRoot
public class PerfilTutor {
    private final TutorId id;
    private final UsuarioId usuarioId;
    private NombreCompleto nombreCompleto;
    private EstadoAprobacionTutor estadoAprobacion;
    private TarifaPorHora tarifa;
    private final List<ExperienciaLaboral> experiencias;
    private final List<ConocimientoTutor> conocimientos;
    private final List<IdiomaTutor> idiomas;
    
    // Constructor privado
    private PerfilTutor(TutorId id, UsuarioId usuarioId, NombreCompleto nombre) {
        this.id = Objects.requireNonNull(id);
        this.usuarioId = Objects.requireNonNull(usuarioId);
        this.nombreCompleto = Objects.requireNonNull(nombre);
        this.estadoAprobacion = EstadoAprobacionTutor.PENDIENTE_REGISTRO;
        this.experiencias = new ArrayList<>();
        this.conocimientos = new ArrayList<>();
        this.idiomas = new ArrayList<>();
    }
    
    // Factory Method
    public static PerfilTutor crear(UsuarioId usuarioId, NombreCompleto nombre) {
        validarEdadMinima(nombre.getFechaNacimiento());
        return new PerfilTutor(TutorId.generar(), usuarioId, nombre);
    }
    
    public void agregarExperiencia(ExperienciaLaboral experiencia) {
        validarExperienciaUnica(experiencia);
        this.experiencias.add(experiencia);
    }
    
    public void definirTarifa(TarifaPorHora tarifa) {
        validarTarifaMinima(tarifa);
        this.tarifa = tarifa;
    }
    
    public void enviarParaRevision() {
        if (!estáCompleto()) {
            throw new IllegalStateException("Perfil incompleto");
        }
        this.estadoAprobacion = EstadoAprobacionTutor.EN_REVISION;
    }
    
    public void aprobar(UsuarioId adminId) {
        if (this.estadoAprobacion != EstadoAprobacionTutor.EN_REVISION) {
            throw new IllegalStateException("Solo perfiles en revisión pueden ser aprobados");
        }
        this.estadoAprobacion = EstadoAprobacionTutor.APROBADO;
        // Domain event: TutorAprobadoEvent
    }
    
    private boolean estáCompleto() {
        return nombreCompleto != null
            && !experiencias.isEmpty()
            && !conocimientos.isEmpty()
            && tarifa != null;
    }
    
    private static void validarEdadMinima(LocalDate fechaNacimiento) {
        int edad = Period.between(fechaNacimiento, LocalDate.now()).getYears();
        if (edad < 18) {
            throw new IllegalArgumentException("Tutores deben ser mayores de 18 años");
        }
    }
}
```

**Criterios Técnicos**:
- [ ] Aggregate con entidades hijas (experiencias)
- [ ] Validaciones de negocio en el dominio
- [ ] Domain Events (TutorAprobadoEvent, TutorRechazadoEvent)
- [ ] Métodos de estado (enviarParaRevision, aprobar, rechazar)
- [ ] Tests unitarios >90% coverage

---

#### TAREA-002-BE-02: Implementar Saga `ProcesoRegistroTutor` [8h]

**Descripción**: Gestión de estado multi-step con persistencia

**Archivos**:
- `domain/tutores/ProcesoRegistroTutor.java`
- `application/usecases/tutores/GuardarPasoRegistroUseCase.java`
- `application/usecases/tutores/FinalizarRegistroTutorUseCase.java`

**Implementación Saga**:
```java
@Entity
@Table(schema = "tutores_schema", name = "proceso_registro_tutor")
public class ProcesoRegistroTutor {
    
    @Id
    @Column(name = "pkid_proceso_tutor")
    private UUID id;
    
    @Column(name = "usuario_id", nullable = false)
    private UUID usuarioId;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "estado_actual")
    private EstadoAprobacionTutor estadoActual;
    
    @Column(name = "step_completado")
    private Integer stepCompletado;
    
    @Column(name = "datos_formulario", columnDefinition = "jsonb")
    @Type(type = "jsonb")
    private Map<String, Object> datosFormulario;
    
    @Column(name = "experiencias_laborales", columnDefinition = "jsonb")
    @Type(type = "jsonb")
    private List<ExperienciaLaboralDto> experiencias;
    
    @Column(name = "conocimientos_seleccionados", columnDefinition = "jsonb")
    @Type(type = "jsonb")
    private List<UUID> conocimientos;
    
    @Column(name = "idiomas_seleccionados", columnDefinition = "jsonb")
    @Type(type = "jsonb")
    private List<IdiomaTutorDto> idiomas;
    
    // Métodos de transición de estado
    public void completarStep(int step) {
        if (step <= this.stepCompletado) {
            throw new IllegalStateException("Step ya completado");
        }
        this.stepCompletado = step;
        
        if (step == 4) {
            this.estadoActual = EstadoAprobacionTutor.EN_REVISION;
            // Disparar evento: RegistroTutorCompletadoEvent
        }
    }
    
    public void guardarDatosStep(int step, Map<String, Object> datos) {
        this.datosFormulario.putAll(datos);
        completarStep(step);
    }
}
```

**Use Case**:
```java
@UseCase
@Transactional
public class GuardarPasoRegistroUseCase {
    
    private final ProcesoRegistroRepository procesoRepository;
    
    public GuardarPasoResponse ejecutar(GuardarPasoCommand command) {
        // 1. Buscar o crear proceso
        ProcesoRegistroTutor proceso = procesoRepository
            .findByUsuarioId(command.usuarioId())
            .orElseGet(() -> crearNuevoProceso(command.usuarioId()));
        
        // 2. Guardar datos del step actual
        proceso.guardarDatosStep(command.step(), command.datos());
        
        // 3. Persistir
        proceso = procesoRepository.save(proceso);
        
        return GuardarPasoResponse.of(proceso);
    }
}
```

**Criterios**:
- [ ] Estado persistido en PostgreSQL con JSONB
- [ ] Idempotencia (re-guardar step no genera error)
- [ ] Transiciones de estado validadas
- [ ] Tests de integración con Testcontainers

---

#### TAREA-002-BE-03: Implementar REST Controller Multi-step [4h]

**Endpoints**:
```java
@RestController
@RequestMapping("/api/v1/auth/tutores")
public class RegistroTutorController {
    
    // Guardar progreso de un step
    @PostMapping("/registro/paso/{step}")
    public ApiResponse<ProcesoRegistroDto> guardarPaso(
            @PathVariable int step,
            @Valid @RequestBody GuardarPasoRequest request) {
        // ...
    }
    
    // Finalizar y enviar para revisión
    @PostMapping("/registro/finalizar")
    public ApiResponse<PerfilTutorDto> finalizarRegistro(
            @Valid @RequestBody FinalizarRegistroRequest request) {
        // ...
    }
    
    // Obtener estado del proceso
    @GetMapping("/registro/estado")
    public ApiResponse<ProcesoRegistroDto> obtenerEstado() {
        // ...
    }
}
```

**Criterios**:
- [ ] Endpoints RESTful semánticos
- [ ] Validación por step (diferentes DTOs)
- [ ] Manejo de errores específico por step
- [ ] Documentación OpenAPI completa

---

### 🎨 FRONTEND TASKS

#### TAREA-002-FE-01: Componente Multi-step Tutor [8h]

**Archivos**:
- `components/auth/TutorRegistration.tsx`
- `components/tutores/ExperienciaLaboralForm.tsx`
- `components/tutores/ConocimientosSelector.tsx`
- `components/tutores/IdiomasSelector.tsx`
- `hooks/useTutorRegistration.ts`

**Steps del Formulario**:
1. **Step 1**: Credenciales + Info Personal Básica
2. **Step 2**: Experiencia Laboral (agregar múltiples)
3. **Step 3**: Conocimientos/Habilidades + Idiomas
4. **Step 4**: Tarifa + Disponibilidad + Archivos
5. **Step 5**: Confirmación y Envío

**Criterios**:
- [ ] Guardado automático por step (draft)
- [ ] Navegación hacia atrás permitida
- [ ] Validación progresiva
- [ ] Progress bar visual (0-100%)
- [ ] Tests E2E completos

---

## 📊 Estimación Consolidada

| Tarea | Esfuerzo | Rol |
|-------|----------|-----|
| Backend Aggregate PerfilTutor | 6h | Backend Dev |
| Backend Saga Proceso Registro | 8h | Backend Dev |
| Backend REST Multi-step | 4h | Backend Dev |
| Frontend Multi-step Tutor | 8h | Frontend Dev |
| Frontend Experiencias/Conocimientos | 4h | Frontend Dev |
| E2E Tests Playwright | 5h | QA Engineer |
| Admin Panel Aprobación | 6h | Full Stack Dev |
| **TOTAL** | **41h** | **~5-6 días** |

**Story Points**: 21 (Fibonacci)

---

## ✅ Definition of Done

### Backend:
- [ ] Saga implementada con transiciones de estado
- [ ] JSONB usado para datos flexibles
- [ ] Tests de integración con Testcontainers
- [ ] Domain Events publicados (TutorAprobadoEvent)

### Frontend:
- [ ] Guardado automático por step
- [ ] UX fluida con loading states
- [ ] Validación específica por step
- [ ] Tests E2E de flujo completo

---

**Versión**: 1.0  
**Fecha**: 2025-11-16  
**Autor**: Technical User Stories Engineer  
**Metodología**: ZNS v2.0
