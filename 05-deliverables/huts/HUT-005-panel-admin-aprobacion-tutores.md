# HUT-005: Panel Admin - Aprobación de Tutores

## 📋 Metadatos

| Atributo | Valor |
|----------|-------|
| **HU Origen** | HU-005 - Gestión de Aprobación de Tutores |
| **Bounded Context** | Tutores (Admin) |
| **Sprint** | Sprint 3 |
| **Story Points** | 13 |
| **Prioridad** | ALTA |
| **Dependencias** | HUT-002, HUT-004 |

---

## 🎯 Historia de Usuario

**Como** administrador de la plataforma  
**Quiero** revisar y aprobar/rechazar solicitudes de registro de tutores  
**Para** garantizar la calidad y credibilidad de los tutores en la plataforma

### Criterios de Aceptación
- ✅ Listado de tutores pendientes de aprobación con filtros
- ✅ Vista detallada: perfil completo, documentos, video presentación
- ✅ Acciones: Aprobar, Rechazar (con motivo), Solicitar más información
- ✅ Sistema de comentarios internos entre admins
- ✅ Notificaciones email al tutor (aprobación/rechazo)
- ✅ Dashboard con estadísticas (pendientes, aprobados, rechazados)
- ✅ Auditoría completa (quién aprobó/rechazó, cuándo, por qué)

---

## 🏗️ Contexto Arquitectónico

- **Arquitectura**: Hexagonal + CQRS (queries optimizadas)
- **Patterns**: State Machine, Command Pattern, Observer (notificaciones)
- **ADRs**: [ADR-015] Workflow aprobación, [ADR-020] Auditoría admin

---

## 📊 JSON Structures

### Request: Listar Tutores Pendientes

```json
GET /api/v1/admin/tutores/pendientes?page=0&size=20&ordenarPor=fechaRegistro&orden=DESC

Response 200:
{
  "status": "success",
  "data": {
    "tutores": [
      {
        "tutorId": "850e8400-e29b-41d4-a716-446655440000",
        "nombreCompleto": "María García López",
        "email": "maria.garcia@email.com",
        "telefono": "+34612345678",
        "fechaRegistro": "2025-11-15T14:30:00Z",
        "estadoActual": "EN_REVISION",
        "diasPendiente": 1,
        "puntajePreliminar": 85,
        "experienciaAños": 8,
        "especialidades": ["Matemáticas", "Física"],
        "tarifaPorHora": 25.00,
        "documentosCompletos": true,
        "videoPresente": true,
        "ultimaActividad": "2025-11-15T18:45:00Z"
      }
    ],
    "pagination": {
      "page": 0,
      "size": 20,
      "totalElements": 45,
      "totalPages": 3
    },
    "estadisticas": {
      "pendientesRevision": 45,
      "aprobadosHoy": 12,
      "rechazadosHoy": 3,
      "tiempoPromedioRevision": "2.5 horas"
    }
  }
}
```

### Request: Obtener Detalle Completo de Tutor

```json
GET /api/v1/admin/tutores/850e8400-e29b-41d4-a716-446655440000/detalle

Response 200:
{
  "status": "success",
  "data": {
    "tutorId": "850e8400-e29b-41d4-a716-446655440000",
    "informacionPersonal": {
      "nombreCompleto": "María García López",
      "email": "maria.garcia@email.com",
      "telefono": "+34612345678",
      "fechaNacimiento": "1992-05-15",
      "edad": 33,
      "nacionalidad": "España",
      "ciudadResidencia": "Madrid"
    },
    "experienciaLaboral": [
      {
        "empresa": "Instituto Tecnológico de Madrid",
        "cargo": "Profesora de Matemáticas",
        "desde": "2018-09-01",
        "hasta": "2024-06-30",
        "descripcion": "Enseñanza de cálculo y álgebra lineal",
        "esActual": false
      }
    ],
    "conocimientos": [
      {
        "nombre": "Matemáticas",
        "nivelExperticia": "EXPERTO",
        "añosExperiencia": 8
      },
      {
        "nombre": "Física",
        "nivelExperticia": "AVANZADO",
        "añosExperiencia": 5
      }
    ],
    "idiomas": [
      {"idioma": "Español", "nivel": "NATIVO"},
      {"idioma": "Inglés", "nivel": "AVANZADO"}
    ],
    "configuracionComercial": {
      "tarifaPorHora": 25.00,
      "disponibilidad": ["LUNES_TARDE", "MIERCOLES_TARDE", "VIERNES_MANANA"]
    },
    "archivos": {
      "fotoPerfil": {
        "archivoId": "a1111111-1111-1111-1111-111111111111",
        "urlFirmada": "https://...",
        "tipo": "FOTO_PERFIL"
      },
      "certificados": [
        {
          "archivoId": "b2222222-2222-2222-2222-222222222222",
          "nombre": "Titulo_Licenciatura_Matematicas.pdf",
          "urlFirmada": "https://...",
          "tipo": "CERTIFICADO_EDUCATIVO"
        }
      ],
      "videoPresentacion": {
        "archivoId": "c3333333-3333-3333-3333-333333333333",
        "urlFirmada": "https://...",
        "duracion": "02:45"
      }
    },
    "historialEstados": [
      {
        "estado": "PENDIENTE_REGISTRO",
        "fecha": "2025-11-15T14:00:00Z"
      },
      {
        "estado": "EN_REVISION",
        "fecha": "2025-11-15T14:30:00Z",
        "comentario": "Registro completado, en espera de revisión"
      }
    ],
    "comentariosInternos": [
      {
        "comentarioId": "d4444444-4444-4444-4444-444444444444",
        "adminId": "950e8400-e29b-41d4-a716-446655440000",
        "adminNombre": "Carlos Admin",
        "comentario": "Certificados verificados correctamente. Video de buena calidad.",
        "fecha": "2025-11-16T09:15:00Z"
      }
    ],
    "puntajePreliminar": {
      "total": 85,
      "desglose": {
        "experiencia": 30,
        "certificaciones": 25,
        "videoPresentacion": 20,
        "disponibilidad": 10
      }
    }
  }
}
```

### Request: Aprobar Tutor

```json
POST /api/v1/admin/tutores/850e8400-e29b-41d4-a716-446655440000/aprobar

{
  "adminId": "950e8400-e29b-41d4-a716-446655440000",
  "comentarioInterno": "Perfil completo y verificado. Excelente presentación.",
  "comentarioPublico": "¡Bienvenido a Mitoga! Tu perfil ha sido aprobado.",
  "configuraciones": {
    "visibilidadInmediata": true,
    "destacarPerfil": false,
    "categoriasAprobadas": ["MATEMATICAS", "FISICA"]
  }
}

Response 200:
{
  "status": "success",
  "message": "Tutor aprobado exitosamente",
  "data": {
    "tutorId": "850e8400-e29b-41d4-a716-446655440000",
    "estadoAnterior": "EN_REVISION",
    "estadoActual": "APROBADO",
    "fechaAprobacion": "2025-11-16T10:30:00Z",
    "aprobadoPor": {
      "adminId": "950e8400-e29b-41d4-a716-446655440000",
      "nombre": "Carlos Admin"
    },
    "notificacionEnviada": true
  }
}
```

### Request: Rechazar Tutor

```json
POST /api/v1/admin/tutores/850e8400-e29b-41d4-a716-446655440000/rechazar

{
  "adminId": "950e8400-e29b-41d4-a716-446655440000",
  "motivo": "DOCUMENTACION_INSUFICIENTE",
  "comentarioInterno": "Falta certificado universitario verificable",
  "comentarioPublico": "Tu solicitud requiere documentación adicional. Por favor, sube tu certificado universitario oficial.",
  "detallesRechazo": [
    "Certificado educativo no verificable",
    "Experiencia laboral sin comprobantes"
  ],
  "permitirReaplicar": true
}

Response 200:
{
  "status": "success",
  "message": "Solicitud rechazada",
  "data": {
    "tutorId": "850e8400-e29b-41d4-a716-446655440000",
    "estadoActual": "RECHAZADO",
    "fechaRechazo": "2025-11-16T10:30:00Z",
    "motivo": "DOCUMENTACION_INSUFICIENTE",
    "puedeReaplicar": true,
    "notificacionEnviada": true
  }
}
```

---

## 📊 Database Schema

### Tabla: `tutores_schema.aprobaciones_tutores`

```sql
CREATE TABLE IF NOT EXISTS tutores_schema.aprobaciones_tutores (
    pkid_aprobacion UUID DEFAULT gen_random_uuid() NOT NULL,
    tutor_id UUID NOT NULL,
    admin_id UUID NOT NULL,
    accion VARCHAR(20) NOT NULL, -- APROBAR, RECHAZAR, SOLICITAR_INFO
    estado_anterior VARCHAR(50) NOT NULL,
    estado_nuevo VARCHAR(50) NOT NULL,
    motivo_rechazo VARCHAR(100),
    comentario_interno TEXT,
    comentario_publico TEXT,
    detalles_adicionales JSONB DEFAULT '{}'::JSONB,
    fecha_accion TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    
    CONSTRAINT pk_aprobaciones PRIMARY KEY (pkid_aprobacion),
    CONSTRAINT fk_aprobacion_tutor FOREIGN KEY (tutor_id)
        REFERENCES tutores_schema.perfiles_tutores(pkid_perfil_tutor),
    CONSTRAINT fk_aprobacion_admin FOREIGN KEY (admin_id)
        REFERENCES autenticacion_schema.usuarios(pkid_usuarios)
);

CREATE INDEX idx_aprobaciones_tutor ON tutores_schema.aprobaciones_tutores(tutor_id);
CREATE INDEX idx_aprobaciones_admin ON tutores_schema.aprobaciones_tutores(admin_id);
CREATE INDEX idx_aprobaciones_fecha ON tutores_schema.aprobaciones_tutores(fecha_accion DESC);
```

### Tabla: `tutores_schema.comentarios_revision`

```sql
CREATE TABLE IF NOT EXISTS tutores_schema.comentarios_revision (
    pkid_comentario UUID DEFAULT gen_random_uuid() NOT NULL,
    tutor_id UUID NOT NULL,
    admin_id UUID NOT NULL,
    comentario TEXT NOT NULL,
    es_publico BOOLEAN DEFAULT FALSE,
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    
    CONSTRAINT pk_comentarios_revision PRIMARY KEY (pkid_comentario)
);
```

---

## 🔧 Tareas Técnicas

### TAREA-005-BE-01: Domain Service AprobacionTutorService [4h]

**Archivos**: `domain/tutores/AprobacionTutorService.java`

**Implementación**:
```java
@DomainService
public class AprobacionTutorService {
    
    public PerfilTutor aprobar(PerfilTutor tutor, AdminId adminId, String comentario) {
        // Validar estado actual
        if (!tutor.estaEnRevision()) {
            throw new EstadoInvalidoException("Solo se pueden aprobar tutores en revisión");
        }
        
        // Cambiar estado
        tutor.aprobar(adminId, comentario);
        
        // Publicar evento
        DomainEvents.publish(new TutorAprobadoEvent(tutor.getId(), adminId));
        
        return tutor;
    }
    
    public PerfilTutor rechazar(PerfilTutor tutor, AdminId adminId, 
                                MotivoRechazo motivo, String comentario) {
        if (!tutor.estaEnRevision()) {
            throw new EstadoInvalidoException("Solo se pueden rechazar tutores en revisión");
        }
        
        tutor.rechazar(adminId, motivo, comentario);
        
        DomainEvents.publish(new TutorRechazadoEvent(tutor.getId(), motivo));
        
        return tutor;
    }
    
    public void calcularPuntajePreliminar(PerfilTutor tutor) {
        int puntaje = 0;
        
        // Experiencia (max 30 puntos)
        puntaje += Math.min(tutor.getAñosExperiencia() * 3, 30);
        
        // Certificados (max 25 puntos)
        puntaje += tutor.getCertificados().size() * 5;
        
        // Video presentación (20 puntos si existe)
        if (tutor.tieneVideoPresentacion()) puntaje += 20;
        
        // Disponibilidad (max 10 puntos)
        puntaje += Math.min(tutor.getHorasDisponibles() / 2, 10);
        
        tutor.setPuntajePreliminar(Math.min(puntaje, 100));
    }
}
```

**Tests**:
```java
@Test
void testAprobarTutorEnRevisionExitoso() {
    PerfilTutor tutor = crearTutorEnRevision();
    AdminId admin = AdminId.generar();
    
    tutor = aprobacionService.aprobar(tutor, admin, "Perfil completo");
    
    assertEquals(EstadoTutor.APROBADO, tutor.getEstado());
    assertNotNull(tutor.getFechaAprobacion());
}

@Test
void testRechazarTutorPublicaEvento() {
    PerfilTutor tutor = crearTutorEnRevision();
    
    tutor = aprobacionService.rechazar(
        tutor, 
        AdminId.generar(), 
        MotivoRechazo.DOCUMENTACION_INSUFICIENTE,
        "Faltan documentos"
    );
    
    verify(eventPublisher).publish(any(TutorRechazadoEvent.class));
}
```

---

### TAREA-005-BE-02: Use Cases Aprobación [3h]

**Archivos**: `application/usecases/tutores/AprobarTutorUseCase.java`, `RechazarTutorUseCase.java`

**Implementación**:
```java
@UseCase
@Transactional
public class AprobarTutorUseCase {
    
    private final TutorRepositoryPort tutorRepository;
    private final AprobacionTutorService aprobacionService;
    private final EmailPort emailService;
    private final AuditoriaPort auditoriaPort;
    
    public AprobarTutorResponse ejecutar(AprobarTutorCommand command) {
        // 1. Buscar tutor
        PerfilTutor tutor = tutorRepository.findById(command.tutorId())
            .orElseThrow(() -> new TutorNoEncontradoException(command.tutorId()));
        
        // 2. Aprobar (domain service)
        tutor = aprobacionService.aprobar(
            tutor, 
            command.adminId(), 
            command.comentarioInterno()
        );
        
        // 3. Persistir
        tutorRepository.save(tutor);
        
        // 4. Guardar auditoría
        auditoriaPort.registrar(new AprobacionTutorAudit(
            tutor.getId(),
            command.adminId(),
            AccionAdmin.APROBAR,
            command.comentarioInterno()
        ));
        
        // 5. Enviar email al tutor
        emailService.enviarAprobacionTutor(
            tutor.getEmail(),
            tutor.getNombreCompleto(),
            command.comentarioPublico()
        );
        
        log.info("Tutor aprobado - ID: {}, Admin: {}", tutor.getId(), command.adminId());
        
        return AprobarTutorResponse.of(tutor);
    }
}
```

---

### TAREA-005-BE-03: Query Optimizado para Listado [3h]

**Archivos**: `application/queries/ListarTutoresPendientesQuery.java`

**Implementación** (CQRS):
```java
@Query
public class ListarTutoresPendientesQuery {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    public Page<TutorPendienteDTO> ejecutar(ListarTutoresPendientesRequest request) {
        String sql = """
            SELECT 
                pt.pkid_perfil_tutor,
                u.nombre_completo,
                u.email,
                pt.telefono,
                pt.creation_date AS fecha_registro,
                pt.estado,
                EXTRACT(DAY FROM NOW() - pt.creation_date) AS dias_pendiente,
                pt.puntaje_preliminar,
                pt.tarifa_por_hora,
                COUNT(a.pkid_archivo) FILTER (WHERE a.tipo_archivo IN ('CERTIFICADO_EDUCATIVO')) AS num_certificados,
                EXISTS(SELECT 1 FROM shared_schema.archivos WHERE tipo_archivo = 'VIDEO_PRESENTACION' AND usuario_id = u.pkid_usuarios) AS tiene_video
            FROM tutores_schema.perfiles_tutores pt
            INNER JOIN autenticacion_schema.usuarios u ON u.pkid_usuarios = pt.usuario_id
            LEFT JOIN shared_schema.archivos a ON a.usuario_id = u.pkid_usuarios
            WHERE pt.estado = 'EN_REVISION'
            GROUP BY pt.pkid_perfil_tutor, u.nombre_completo, u.email, pt.telefono, pt.creation_date, pt.estado
            ORDER BY pt.creation_date DESC
            LIMIT ? OFFSET ?
            """;
        
        List<TutorPendienteDTO> tutores = jdbcTemplate.query(
            sql,
            new TutorPendienteDTORowMapper(),
            request.getSize(),
            request.getPage() * request.getSize()
        );
        
        long total = contarTotales();
        
        return new PageImpl<>(tutores, PageRequest.of(request.getPage(), request.getSize()), total);
    }
}
```

---

### TAREA-005-BE-04: REST Controllers Admin [2h]

**Archivos**: `infrastructure/web/admin/AdminTutoresController.java`

**Endpoints**:
```java
@RestController
@RequestMapping("/api/v1/admin/tutores")
@PreAuthorize("hasRole('ADMIN')")
public class AdminTutoresController {
    
    @GetMapping("/pendientes")
    public ResponseEntity<ApiResponse<Page<TutorPendienteDTO>>> listarPendientes(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        
        var query = new ListarTutoresPendientesRequest(page, size);
        Page<TutorPendienteDTO> tutores = listarTutoresQuery.ejecutar(query);
        
        return ResponseEntity.ok(ApiResponse.success(tutores));
    }
    
    @PostMapping("/{tutorId}/aprobar")
    public ResponseEntity<ApiResponse<AprobarTutorResponse>> aprobar(
            @PathVariable UUID tutorId,
            @Valid @RequestBody AprobarTutorRequest request,
            @AuthenticationPrincipal AdminUsuario admin) {
        
        var command = new AprobarTutorCommand(
            TutorId.of(tutorId),
            admin.getUsuarioId(),
            request.comentarioInterno(),
            request.comentarioPublico()
        );
        
        var response = aprobarUseCase.ejecutar(command);
        
        return ResponseEntity.ok(ApiResponse.success(response, "Tutor aprobado exitosamente"));
    }
    
    @PostMapping("/{tutorId}/rechazar")
    public ResponseEntity<ApiResponse<RechazarTutorResponse>> rechazar(
            @PathVariable UUID tutorId,
            @Valid @RequestBody RechazarTutorRequest request,
            @AuthenticationPrincipal AdminUsuario admin) {
        
        var command = new RechazarTutorCommand(
            TutorId.of(tutorId),
            admin.getUsuarioId(),
            request.motivo(),
            request.comentarioInterno(),
            request.comentarioPublico(),
            request.permitirReaplicar()
        );
        
        var response = rechazarUseCase.ejecutar(command);
        
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
```

---

### TAREA-005-FE-01: Dashboard Admin Tutores [5h]

**Archivos**: `app/admin/tutores/page.tsx`, `components/admin/TutorPendienteCard.tsx`

**Implementación**:
```typescript
export default function AdminTutoresPage() {
  const [filtro, setFiltro] = useState<FiltroTutores>({ estado: 'EN_REVISION' });
  
  const { data: tutores, isLoading } = useQuery({
    queryKey: ['tutores-pendientes', filtro],
    queryFn: () => adminTutoresService.listarPendientes(filtro)
  });
  
  const { data: estadisticas } = useQuery({
    queryKey: ['estadisticas-tutores'],
    queryFn: () => adminTutoresService.obtenerEstadisticas()
  });
  
  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6">Gestión de Tutores</h1>
      
      {/* Estadísticas */}
      <div className="grid grid-cols-4 gap-4 mb-6">
        <StatCard 
          titulo="Pendientes Revisión" 
          valor={estadisticas?.pendientesRevision || 0}
          icono={ClockIcon}
          color="yellow"
        />
        <StatCard 
          titulo="Aprobados Hoy" 
          valor={estadisticas?.aprobadosHoy || 0}
          icono={CheckCircleIcon}
          color="green"
        />
        <StatCard 
          titulo="Rechazados Hoy" 
          valor={estadisticas?.rechazadosHoy || 0}
          icono={XCircleIcon}
          color="red"
        />
        <StatCard 
          titulo="Tiempo Promedio" 
          valor={estadisticas?.tiempoPromedioRevision || '-'}
          icono={ChartBarIcon}
          color="blue"
        />
      </div>
      
      {/* Listado de tutores */}
      <div className="grid gap-4">
        {isLoading ? (
          <LoadingSpinner />
        ) : (
          tutores?.data.tutores.map(tutor => (
            <TutorPendienteCard 
              key={tutor.tutorId} 
              tutor={tutor}
              onRevisar={() => router.push(`/admin/tutores/${tutor.tutorId}`)}
            />
          ))
        )}
      </div>
    </div>
  );
}
```

---

### TAREA-005-FE-02: Modal Aprobación/Rechazo [3h]

**Archivos**: `components/admin/AprobarTutorModal.tsx`

**Implementación**:
```typescript
export function AprobarTutorModal({ tutor, isOpen, onClose }: Props) {
  const { register, handleSubmit, formState: { errors } } = useForm<AprobarForm>();
  
  const { mutate: aprobar, isLoading } = useMutation({
    mutationFn: (data: AprobarForm) => 
      adminTutoresService.aprobar(tutor.tutorId, data),
    onSuccess: () => {
      toast.success('Tutor aprobado exitosamente');
      queryClient.invalidateQueries(['tutores-pendientes']);
      onClose();
    }
  });
  
  return (
    <Modal isOpen={isOpen} onClose={onClose} size="lg">
      <form onSubmit={handleSubmit(aprobar)}>
        <ModalHeader>Aprobar Tutor: {tutor.nombreCompleto}</ModalHeader>
        
        <ModalBody>
          <Textarea
            {...register('comentarioInterno')}
            label="Comentario Interno (solo admins)"
            placeholder="Notas internas sobre la aprobación..."
            rows={3}
          />
          
          <Textarea
            {...register('comentarioPublico', { required: true })}
            label="Mensaje para el Tutor"
            placeholder="¡Bienvenido! Tu perfil ha sido aprobado..."
            error={errors.comentarioPublico?.message}
            rows={4}
          />
          
          <Checkbox
            {...register('visibilidadInmediata')}
            label="Hacer visible inmediatamente en el marketplace"
            defaultChecked
          />
        </ModalBody>
        
        <ModalFooter>
          <Button variant="ghost" onClick={onClose}>Cancelar</Button>
          <Button type="submit" loading={isLoading}>
            Aprobar Tutor
          </Button>
        </ModalFooter>
      </form>
    </Modal>
  );
}
```

---

## 📊 Estimación

| Tarea | Esfuerzo | Rol |
|-------|----------|-----|
| Backend Domain Service | 4h | Backend Dev |
| Backend Use Cases | 3h | Backend Dev |
| Backend Query Optimizado | 3h | Backend Dev |
| Backend REST Controllers | 2h | Backend Dev |
| Frontend Dashboard | 5h | Frontend Dev |
| Frontend Modal Aprobación | 3h | Frontend Dev |
| Email Templates | 2h | Backend Dev |
| Tests E2E | 4h | QA Engineer |
| **TOTAL** | **26h** | **~3-4 días** |

**Story Points**: 13

---

## ✅ Definition of Done

- [ ] State machine correctamente implementada
- [ ] Query CQRS optimizado (sin N+1)
- [ ] Auditoría completa de acciones admin
- [ ] Emails enviados (aprobación/rechazo)
- [ ] Dashboard con estadísticas en tiempo real
- [ ] Tests E2E (aprobar + rechazar flows)
- [ ] Permisos RBAC validados

---

**Versión**: 1.0  
**Fecha**: 2025-11-16
