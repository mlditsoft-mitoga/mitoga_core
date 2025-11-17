# HUT-004: Gestión de Archivos (Upload MinIO/S3)

## 📋 Metadatos

| Atributo | Valor |
|----------|-------|
| **HU Origen** | HU-004 - Gestión de Archivos de Usuario |
| **Bounded Context** | Shared Services (Archivos) |
| **Sprint** | Sprint 2 |
| **Story Points** | 8 (Fibonacci) |
| **Prioridad** | ALTA |
| **Tipo** | Infrastructure Feature |
| **Dependencias** | HUT-001, HUT-002 |

---

## 🎯 Historia de Usuario Origen

**Como** usuario de la plataforma (estudiante o tutor)  
**Quiero** subir y gestionar archivos de forma segura (fotos, documentos, certificados)  
**Para** completar mi perfil y verificar mi identidad

### Criterios de Aceptación (Negocio)
- ✅ Soporte para múltiples tipos: imágenes (JPG, PNG), documentos (PDF), videos (MP4)
- ✅ Tamaño máximo: 5MB para imágenes, 20MB para PDFs, 100MB para videos
- ✅ Compresión automática de imágenes (optimización)
- ✅ Generación de thumbnails para fotos de perfil
- ✅ URLs firmadas con expiración (pre-signed URLs)
- ✅ Almacenamiento en MinIO (on-premise) o S3 (cloud)
- ✅ Metadata persistida en PostgreSQL
- ✅ Escaneo antivirus (ClamAV) antes de aceptar archivo
- ✅ Soft delete (archivos no se eliminan físicamente)

---

## 🏗️ Contexto Arquitectónico

### Patrón Arquitectónico
- **Arquitectura**: Hexagonal (Port: `ArchivoStoragePort`)
- **Strategy Pattern**: Implementaciones intercambiables (MinIO/S3)
- **Async Processing**: Upload asíncrono con CompletableFuture
- **Event-Driven**: Domain Event `ArchivoSubidoEvent`

### ADRs Relacionados
- **[ADR-012]** Estrategia de almacenamiento de archivos
- **[ADR-013]** Compresión de imágenes con ImageMagick
- **[ADR-014]** Pre-signed URLs para seguridad
- **[ADR-019]** Escaneo antivirus con ClamAV

### Tecnologías
- **Storage**: MinIO 2023.x (on-premise) / AWS S3 (cloud)
- **Backend**: Spring Boot 3.4.0, Java 21
- **Image Processing**: Thumbnailator (Java library)
- **Antivirus**: ClamAV (opcional, enterprise)
- **Database**: PostgreSQL 17.6 (metadata)

---

## 📊 Estructura de Datos

### Request: Upload de Archivo (Multipart)

```http
POST /api/v1/archivos/upload
Content-Type: multipart/form-data

------WebKitFormBoundary
Content-Disposition: form-data; name="archivo"; filename="foto_perfil.jpg"
Content-Type: image/jpeg

[binary data]
------WebKitFormBoundary
Content-Disposition: form-data; name="tipoArchivo"

FOTO_PERFIL
------WebKitFormBoundary
Content-Disposition: form-data; name="usuarioId"

650e8400-e29b-41d4-a716-446655440000
------WebKitFormBoundary--
```

### Request: Upload Base64 (JSON)

```json
POST /api/v1/archivos/upload-base64

{
  "usuarioId": "650e8400-e29b-41d4-a716-446655440000",
  "tipoArchivo": "FOTO_PERFIL",
  "archivoBase64": "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD...",
  "nombreArchivo": "foto_perfil.jpg",
  "metadata": {
    "descripcion": "Foto de perfil del estudiante",
    "tags": ["perfil", "verificacion"]
  }
}
```

### Response: Upload Exitoso (201 Created)

```json
{
  "status": "success",
  "message": "Archivo subido exitosamente",
  "data": {
    "archivoId": "950e8400-e29b-41d4-a716-446655440000",
    "nombreOriginal": "foto_perfil.jpg",
    "nombreAlmacenado": "650e8400_foto_perfil_20251116103045.jpg",
    "tipoArchivo": "FOTO_PERFIL",
    "mimeType": "image/jpeg",
    "tamaño": 245678,
    "tamañoFormateado": "239.9 KB",
    "urlAcceso": "https://storage.mitoga.com/usuarios/650e8400/perfil/foto_perfil.jpg",
    "urlThumbnail": "https://storage.mitoga.com/usuarios/650e8400/perfil/foto_perfil_thumb.jpg",
    "esPublico": false,
    "urlFirmada": {
      "url": "https://storage.mitoga.com/usuarios/650e8400/perfil/foto_perfil.jpg?X-Amz-Algorithm=...",
      "expiraEn": "2025-11-16T11:30:45Z",
      "validoPor": "1 hora"
    },
    "estadoEscaneo": "PENDIENTE",
    "checksumMD5": "5d41402abc4b2a76b9719d911017c592",
    "fechaSubida": "2025-11-16T10:30:45.123Z",
    "dimensiones": {
      "ancho": 1920,
      "alto": 1080,
      "aspectRatio": "16:9"
    }
  },
  "timestamp": "2025-11-16T10:30:45.234Z"
}
```

### Response: Error Validación (400 Bad Request)

```json
{
  "status": "error",
  "message": "Archivo no válido",
  "data": {
    "errores": [
      {
        "campo": "archivo",
        "error": "TAMAÑO_EXCEDIDO",
        "mensaje": "El archivo excede el tamaño máximo de 5MB",
        "tamañoActual": "7.2 MB",
        "tamañoMaximo": "5 MB"
      }
    ]
  },
  "timestamp": "2025-11-16T10:30:45.234Z"
}
```

### Response: Virus Detectado (406 Not Acceptable)

```json
{
  "status": "error",
  "message": "Archivo rechazado por seguridad",
  "data": {
    "razon": "VIRUS_DETECTADO",
    "detalles": "El archivo contiene contenido malicioso",
    "amenaza": "Trojan.Generic.12345",
    "accion": "El archivo fue eliminado automáticamente",
    "recomendacion": "Escanea tu dispositivo con un antivirus actualizado"
  },
  "timestamp": "2025-11-16T10:30:45.234Z"
}
```

### Request: Obtener URL Firmada

```json
GET /api/v1/archivos/950e8400-e29b-41d4-a716-446655440000/url-firmada?expiracion=3600

Response 200 OK:
{
  "status": "success",
  "data": {
    "url": "https://storage.mitoga.com/usuarios/650e8400/perfil/foto_perfil.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=...",
    "expiraEn": "2025-11-16T11:30:45Z",
    "validoPor": "1 hora"
  }
}
```

### Request: Eliminar Archivo (Soft Delete)

```json
DELETE /api/v1/archivos/950e8400-e29b-41d4-a716-446655440000

Response 200 OK:
{
  "status": "success",
  "message": "Archivo eliminado exitosamente",
  "data": {
    "archivoId": "950e8400-e29b-41d4-a716-446655440000",
    "nombreArchivo": "foto_perfil.jpg",
    "estadoAnterior": "ACTIVO",
    "estadoActual": "ELIMINADO",
    "fechaEliminacion": "2025-11-16T10:35:00.123Z",
    "eliminadoPor": "650e8400-e29b-41d4-a716-446655440000"
  }
}
```

---

## 📊 Modelo de Datos PostgreSQL

### Tabla: `shared_schema.archivos`

```sql
CREATE TABLE IF NOT EXISTS shared_schema.archivos (
    -- Identificadores
    pkid_archivo UUID DEFAULT gen_random_uuid() NOT NULL,
    usuario_id UUID NOT NULL,
    
    -- Información del archivo
    nombre_original VARCHAR(255) NOT NULL,
    nombre_almacenado VARCHAR(500) NOT NULL UNIQUE,
    tipo_archivo shared_schema.tipo_archivo NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    
    -- Almacenamiento
    storage_provider VARCHAR(20) DEFAULT 'MINIO', -- MINIO, S3, AZURE
    bucket_name VARCHAR(100) NOT NULL,
    storage_path TEXT NOT NULL,
    url_acceso TEXT,
    
    -- Tamaño y checksums
    tamaño_bytes BIGINT NOT NULL CHECK (tamaño_bytes > 0),
    checksum_md5 VARCHAR(32) NOT NULL,
    checksum_sha256 VARCHAR(64),
    
    -- Imágenes (opcional)
    dimensiones JSONB, -- {ancho: 1920, alto: 1080, aspectRatio: "16:9"}
    url_thumbnail TEXT,
    
    -- Seguridad
    estado_escaneo VARCHAR(20) DEFAULT 'PENDIENTE', -- PENDIENTE, LIMPIO, INFECTADO
    resultado_escaneo TEXT,
    fecha_escaneo TIMESTAMPTZ,
    es_publico BOOLEAN DEFAULT FALSE,
    
    -- Metadata
    metadata JSONB DEFAULT '{}'::JSONB,
    tags TEXT[],
    descripcion TEXT,
    
    -- Auditoría
    creation_date TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    expiration_date TIMESTAMPTZ, -- Soft delete
    eliminado_por UUID,
    
    -- Constraints
    CONSTRAINT pk_archivos PRIMARY KEY (pkid_archivo),
    CONSTRAINT fk_archivos_usuario FOREIGN KEY (usuario_id) 
        REFERENCES autenticacion_schema.usuarios(pkid_usuarios) ON DELETE CASCADE,
    CONSTRAINT fk_archivos_eliminador FOREIGN KEY (eliminado_por)
        REFERENCES autenticacion_schema.usuarios(pkid_usuarios)
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_archivos_usuario ON shared_schema.archivos(usuario_id);
CREATE INDEX IF NOT EXISTS idx_archivos_tipo ON shared_schema.archivos(tipo_archivo);
CREATE INDEX IF NOT EXISTS idx_archivos_estado_escaneo ON shared_schema.archivos(estado_escaneo);
CREATE INDEX IF NOT EXISTS idx_archivos_activos ON shared_schema.archivos(usuario_id) 
    WHERE expiration_date IS NULL;
```

### ENUM: `tipo_archivo`

```sql
CREATE TYPE shared_schema.tipo_archivo AS ENUM (
    'FOTO_PERFIL',
    'DOCUMENTO_IDENTIDAD_FRONTAL',
    'DOCUMENTO_IDENTIDAD_REVERSO',
    'SELFIE_VERIFICACION',
    'CERTIFICADO_EDUCATIVO',
    'CERTIFICADO_EXPERIENCIA',
    'VIDEO_PRESENTACION',
    'DOCUMENTO_GENERICO'
);
```

---

## 🔧 Tareas Técnicas Detalladas

### 📦 BACKEND TASKS

#### TAREA-004-BE-01: Crear Domain Model `Archivo` [3h]

**Descripción**: Aggregate Root para archivos con Value Objects

**Archivos**:
- `domain/archivos/Archivo.java`
- `domain/archivos/NombreArchivo.java` (Value Object)
- `domain/archivos/TamañoArchivo.java` (Value Object)
- `domain/archivos/ChecksumMD5.java` (Value Object)
- `domain/archivos/events/ArchivoSubidoEvent.java`

**Implementación**:
```java
package com.mitoga.domain.archivos;

@AggregateRoot
public class Archivo {
    
    private final ArchivoId id;
    private final UsuarioId usuarioId;
    private final NombreArchivo nombreOriginal;
    private final NombreArchivo nombreAlmacenado;
    private final TipoArchivo tipo;
    private final MimeType mimeType;
    private final TamañoArchivo tamaño;
    private final ChecksumMD5 checksum;
    private final StoragePath path;
    private EstadoEscaneo estadoEscaneo;
    private boolean esPublico;
    private Instant fechaSubida;
    private Instant fechaEliminacion;
    
    // Constructor privado
    private Archivo(ArchivoId id, UsuarioId usuarioId, NombreArchivo nombreOriginal,
                    NombreArchivo nombreAlmacenado, TipoArchivo tipo, MimeType mimeType,
                    TamañoArchivo tamaño, ChecksumMD5 checksum, StoragePath path) {
        this.id = Objects.requireNonNull(id);
        this.usuarioId = Objects.requireNonNull(usuarioId);
        this.nombreOriginal = Objects.requireNonNull(nombreOriginal);
        this.nombreAlmacenado = Objects.requireNonNull(nombreAlmacenado);
        this.tipo = Objects.requireNonNull(tipo);
        this.mimeType = Objects.requireNonNull(mimeType);
        this.tamaño = Objects.requireNonNull(tamaño);
        this.checksum = Objects.requireNonNull(checksum);
        this.path = Objects.requireNonNull(path);
        this.estadoEscaneo = EstadoEscaneo.PENDIENTE;
        this.esPublico = false;
        this.fechaSubida = Instant.now();
    }
    
    // Factory Method
    public static Archivo crear(UsuarioId usuarioId, NombreArchivo nombreOriginal,
                                 TipoArchivo tipo, byte[] contenido) {
        
        // Validaciones de negocio
        validarTamañoMaximo(tipo, contenido.length);
        validarMimeType(tipo, detectarMimeType(contenido));
        
        // Generar nombre único para almacenamiento
        NombreArchivo nombreAlmacenado = generarNombreUnico(usuarioId, nombreOriginal);
        
        // Calcular checksum
        ChecksumMD5 checksum = ChecksumMD5.calcular(contenido);
        
        // Determinar path en storage
        StoragePath path = StoragePath.construir(usuarioId, tipo, nombreAlmacenado);
        
        return new Archivo(
            ArchivoId.generar(),
            usuarioId,
            nombreOriginal,
            nombreAlmacenado,
            tipo,
            MimeType.detectar(contenido),
            TamañoArchivo.of(contenido.length),
            checksum,
            path
        );
    }
    
    public void marcarComoLimpio(String resultadoEscaneo) {
        this.estadoEscaneo = EstadoEscaneo.LIMPIO;
        // Domain Event: ArchivoEscaneadoEvent
    }
    
    public void marcarComoInfectado(String amenaza) {
        this.estadoEscaneo = EstadoEscaneo.INFECTADO;
        // Domain Event: VirusDetectadoEvent
    }
    
    public void eliminar(UsuarioId eliminadoPor) {
        if (this.fechaEliminacion != null) {
            throw new IllegalStateException("Archivo ya eliminado");
        }
        this.fechaEliminacion = Instant.now();
        // Domain Event: ArchivoEliminadoEvent
    }
    
    public void hacerPublico() {
        this.esPublico = true;
    }
    
    public boolean estaEliminado() {
        return fechaEliminacion != null;
    }
    
    private static void validarTamañoMaximo(TipoArchivo tipo, long tamaño) {
        long maxBytes = switch (tipo) {
            case FOTO_PERFIL, SELFIE_VERIFICACION -> 5 * 1024 * 1024; // 5MB
            case DOCUMENTO_IDENTIDAD_FRONTAL, DOCUMENTO_IDENTIDAD_REVERSO -> 5 * 1024 * 1024;
            case CERTIFICADO_EDUCATIVO, CERTIFICADO_EXPERIENCIA -> 20 * 1024 * 1024; // 20MB
            case VIDEO_PRESENTACION -> 100 * 1024 * 1024; // 100MB
            default -> 10 * 1024 * 1024; // 10MB default
        };
        
        if (tamaño > maxBytes) {
            throw new TamañoArchivoExcedidoException(tamaño, maxBytes);
        }
    }
    
    private static NombreArchivo generarNombreUnico(UsuarioId usuarioId, NombreArchivo original) {
        String timestamp = Instant.now().toString().replaceAll("[:\\-.]", "");
        String extension = extraerExtension(original.valor());
        String nombre = String.format("%s_%s_%s.%s",
            usuarioId.getValue().toString().substring(0, 8),
            sanitizarNombre(original.valorSinExtension()),
            timestamp,
            extension
        );
        return NombreArchivo.of(nombre);
    }
    
    // Getters
    public ArchivoId getId() { return id; }
    public UsuarioId getUsuarioId() { return usuarioId; }
    public TamañoArchivo getTamaño() { return tamaño; }
    public ChecksumMD5 getChecksum() { return checksum; }
    public boolean esImagen() { return mimeType.esImagen(); }
    // ...
}

// Value Object: TamañoArchivo
public record TamañoArchivo(long bytes) {
    
    public TamañoArchivo {
        if (bytes <= 0) {
            throw new IllegalArgumentException("Tamaño debe ser positivo");
        }
    }
    
    public static TamañoArchivo of(long bytes) {
        return new TamañoArchivo(bytes);
    }
    
    public String formateado() {
        if (bytes < 1024) return bytes + " B";
        if (bytes < 1024 * 1024) return String.format("%.1f KB", bytes / 1024.0);
        if (bytes < 1024 * 1024 * 1024) return String.format("%.1f MB", bytes / (1024.0 * 1024));
        return String.format("%.1f GB", bytes / (1024.0 * 1024 * 1024));
    }
    
    public boolean excede(TamañoArchivo otro) {
        return this.bytes > otro.bytes;
    }
}

// Value Object: ChecksumMD5
public record ChecksumMD5(String valor) {
    
    public ChecksumMD5 {
        Objects.requireNonNull(valor);
        if (!valor.matches("^[a-f0-9]{32}$")) {
            throw new IllegalArgumentException("Checksum MD5 inválido");
        }
    }
    
    public static ChecksumMD5 calcular(byte[] contenido) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] hash = md.digest(contenido);
            StringBuilder hex = new StringBuilder();
            for (byte b : hash) {
                hex.append(String.format("%02x", b));
            }
            return new ChecksumMD5(hex.toString());
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("MD5 no disponible", e);
        }
    }
    
    public boolean coincideCon(ChecksumMD5 otro) {
        return this.valor.equals(otro.valor);
    }
}
```

**Criterios Técnicos**:
- [ ] Value Objects inmutables
- [ ] Validaciones de negocio en domain
- [ ] Factory Method con lógica compleja
- [ ] Domain Events publicados
- [ ] Tests unitarios >90% coverage

**Tests**:
```java
@Test
void testCrearArchivoValidoExitoso() {
    UsuarioId usuarioId = UsuarioId.generar();
    NombreArchivo nombre = NombreArchivo.of("foto_perfil.jpg");
    byte[] contenido = cargarArchivoTest("foto_test.jpg");
    
    Archivo archivo = Archivo.crear(usuarioId, nombre, TipoArchivo.FOTO_PERFIL, contenido);
    
    assertNotNull(archivo.getId());
    assertEquals(EstadoEscaneo.PENDIENTE, archivo.getEstadoEscaneo());
    assertFalse(archivo.estaEliminado());
}

@Test
void testTamañoExcedidoLanzaException() {
    byte[] archivoGrande = new byte[10 * 1024 * 1024]; // 10MB
    
    assertThrows(TamañoArchivoExcedidoException.class, () -> {
        Archivo.crear(
            UsuarioId.generar(),
            NombreArchivo.of("foto_grande.jpg"),
            TipoArchivo.FOTO_PERFIL, // Max 5MB
            archivoGrande
        );
    });
}

@Test
void testEliminarArchivoActualizaEstado() {
    Archivo archivo = crearArchivoTest();
    UsuarioId eliminador = UsuarioId.generar();
    
    archivo.eliminar(eliminador);
    
    assertTrue(archivo.estaEliminado());
    assertNotNull(archivo.getFechaEliminacion());
}
```

---

#### TAREA-004-BE-02: Implementar Adapter MinIO [5h]

**Descripción**: Implementación de puerto de storage con MinIO

**Archivos**:
- `infrastructure/storage/MinIOStorageAdapter.java`
- `infrastructure/storage/config/MinIOConfig.java`
- `application/ports/out/ArchivoStoragePort.java`

**Implementación**:
```java
@Component
@RequiredArgsConstructor
@Profile("minio")
public class MinIOStorageAdapter implements ArchivoStoragePort {
    
    private final MinioClient minioClient;
    private final MinIOProperties properties;
    
    @Override
    public ArchivoAlmacenado guardar(Archivo archivo, InputStream contenido) {
        try {
            // 1. Asegurar que bucket existe
            crearBucketSiNoExiste(properties.getBucketName());
            
            // 2. Construir path completo
            String objectName = construirObjectName(archivo);
            
            // 3. Preparar metadata
            Map<String, String> metadata = new HashMap<>();
            metadata.put("usuario-id", archivo.getUsuarioId().getValue().toString());
            metadata.put("tipo-archivo", archivo.getTipo().name());
            metadata.put("checksum-md5", archivo.getChecksum().valor());
            
            // 4. Upload a MinIO
            PutObjectArgs args = PutObjectArgs.builder()
                .bucket(properties.getBucketName())
                .object(objectName)
                .stream(contenido, archivo.getTamaño().bytes(), -1)
                .contentType(archivo.getMimeType().valor())
                .userMetadata(metadata)
                .build();
            
            ObjectWriteResponse response = minioClient.putObject(args);
            
            // 5. Generar URL de acceso
            String urlAcceso = generarUrlAcceso(objectName);
            
            // 6. Si es imagen, generar thumbnail
            String urlThumbnail = null;
            if (archivo.esImagen()) {
                urlThumbnail = generarThumbnail(archivo, contenido);
            }
            
            log.info("Archivo guardado en MinIO - Bucket: {}, Object: {}, Tamaño: {}",
                properties.getBucketName(), objectName, archivo.getTamaño().formateado());
            
            return ArchivoAlmacenado.of(
                archivo,
                StorageProvider.MINIO,
                properties.getBucketName(),
                objectName,
                urlAcceso,
                urlThumbnail
            );
            
        } catch (Exception e) {
            log.error("Error guardando archivo en MinIO: {}", e.getMessage(), e);
            throw new StorageException("Error al guardar archivo", e);
        }
    }
    
    @Override
    public InputStream descargar(ArchivoId archivoId, String storagePath) {
        try {
            GetObjectArgs args = GetObjectArgs.builder()
                .bucket(properties.getBucketName())
                .object(storagePath)
                .build();
            
            return minioClient.getObject(args);
            
        } catch (Exception e) {
            log.error("Error descargando archivo de MinIO: {}", e.getMessage(), e);
            throw new ArchivoNoEncontradoException(archivoId);
        }
    }
    
    @Override
    public String generarUrlFirmada(String storagePath, Duration expiracion) {
        try {
            GetPresignedObjectUrlArgs args = GetPresignedObjectUrlArgs.builder()
                .method(Method.GET)
                .bucket(properties.getBucketName())
                .object(storagePath)
                .expiry((int) expiracion.getSeconds(), TimeUnit.SECONDS)
                .build();
            
            return minioClient.getPresignedObjectUrl(args);
            
        } catch (Exception e) {
            log.error("Error generando URL firmada: {}", e.getMessage(), e);
            throw new StorageException("Error al generar URL firmada", e);
        }
    }
    
    @Override
    public void eliminar(String storagePath) {
        try {
            RemoveObjectArgs args = RemoveObjectArgs.builder()
                .bucket(properties.getBucketName())
                .object(storagePath)
                .build();
            
            minioClient.removeObject(args);
            
            log.info("Archivo eliminado de MinIO - Object: {}", storagePath);
            
        } catch (Exception e) {
            log.error("Error eliminando archivo de MinIO: {}", e.getMessage(), e);
            throw new StorageException("Error al eliminar archivo", e);
        }
    }
    
    @Override
    public boolean existe(String storagePath) {
        try {
            StatObjectArgs args = StatObjectArgs.builder()
                .bucket(properties.getBucketName())
                .object(storagePath)
                .build();
            
            minioClient.statObject(args);
            return true;
            
        } catch (Exception e) {
            return false;
        }
    }
    
    private void crearBucketSiNoExiste(String bucketName) throws Exception {
        boolean exists = minioClient.bucketExists(
            BucketExistsArgs.builder().bucket(bucketName).build()
        );
        
        if (!exists) {
            minioClient.makeBucket(
                MakeBucketArgs.builder().bucket(bucketName).build()
            );
            log.info("Bucket creado en MinIO: {}", bucketName);
        }
    }
    
    private String construirObjectName(Archivo archivo) {
        return String.format("usuarios/%s/%s/%s",
            archivo.getUsuarioId().getValue(),
            archivo.getTipo().name().toLowerCase(),
            archivo.getNombreAlmacenado().valor()
        );
    }
    
    private String generarUrlAcceso(String objectName) {
        return String.format("%s/%s/%s",
            properties.getEndpoint(),
            properties.getBucketName(),
            objectName
        );
    }
    
    private String generarThumbnail(Archivo archivo, InputStream original) {
        try {
            // Usar Thumbnailator para comprimir y redimensionar
            ByteArrayOutputStream thumbnailOut = new ByteArrayOutputStream();
            
            Thumbnails.of(original)
                .size(200, 200)
                .outputFormat("jpg")
                .outputQuality(0.8)
                .toOutputStream(thumbnailOut);
            
            // Upload thumbnail
            String thumbnailName = archivo.getNombreAlmacenado().valor()
                .replace(".", "_thumb.");
            
            String thumbnailPath = construirObjectName(archivo)
                .replace(archivo.getNombreAlmacenado().valor(), thumbnailName);
            
            minioClient.putObject(
                PutObjectArgs.builder()
                    .bucket(properties.getBucketName())
                    .object(thumbnailPath)
                    .stream(new ByteArrayInputStream(thumbnailOut.toByteArray()),
                        thumbnailOut.size(), -1)
                    .contentType("image/jpeg")
                    .build()
            );
            
            return generarUrlAcceso(thumbnailPath);
            
        } catch (Exception e) {
            log.warn("Error generando thumbnail: {}", e.getMessage());
            return null; // Thumbnail es opcional
        }
    }
}

// Configuration
@Configuration
@EnableConfigurationProperties(MinIOProperties.class)
public class MinIOConfig {
    
    @Bean
    @ConditionalOnProperty(name = "storage.provider", havingValue = "minio")
    public MinioClient minioClient(MinIOProperties properties) {
        return MinioClient.builder()
            .endpoint(properties.getEndpoint())
            .credentials(properties.getAccessKey(), properties.getSecretKey())
            .build();
    }
}

@ConfigurationProperties(prefix = "storage.minio")
@Data
public class MinIOProperties {
    private String endpoint = "http://localhost:9000";
    private String accessKey;
    private String secretKey;
    private String bucketName = "mitoga-files";
}
```

**application.yml**:
```yaml
storage:
  provider: minio
  minio:
    endpoint: http://localhost:9000
    access-key: ${MINIO_ACCESS_KEY:minioadmin}
    secret-key: ${MINIO_SECRET_KEY:minioadmin}
    bucket-name: mitoga-files
```

**Criterios**:
- [ ] Buckets auto-creados si no existen
- [ ] Metadata almacenada con archivo
- [ ] Pre-signed URLs con expiración configurable
- [ ] Generación de thumbnails para imágenes
- [ ] Tests de integración con Testcontainers MinIO
- [ ] Logging estructurado

---

#### TAREA-004-BE-03: Implementar Use Case Upload [4h]

**Archivos**:
- `application/usecases/archivos/SubirArchivoUseCase.java`
- `application/usecases/archivos/ObtenerUrlFirmadaUseCase.java`
- `application/usecases/archivos/EliminarArchivoUseCase.java`

**Implementación**:
```java
@UseCase
@Transactional
@RequiredArgsConstructor
public class SubirArchivoUseCase {
    
    private final ArchivoStoragePort storagePort;
    private final ArchivoRepositoryPort archivoRepository;
    private final VirusScanner virusScanner; // Opcional
    private final EventPublisher eventPublisher;
    
    public SubirArchivoResponse ejecutar(SubirArchivoCommand command) {
        
        // 1. Validar archivo
        validarArchivo(command.contenido(), command.tipoArchivo());
        
        // 2. Escanear virus (opcional, async)
        if (virusScanner.isEnabled()) {
            ResultadoEscaneo resultado = virusScanner.escanear(command.contenido());
            if (resultado.esInfectado()) {
                log.warn("Virus detectado en archivo - Usuario: {}, Amenaza: {}",
                    command.usuarioId(), resultado.getAmenaza());
                throw new VirusDetectadoException(resultado.getAmenaza());
            }
        }
        
        // 3. Crear aggregate Archivo
        Archivo archivo = Archivo.crear(
            command.usuarioId(),
            NombreArchivo.of(command.nombreArchivo()),
            command.tipoArchivo(),
            command.contenido()
        );
        
        // 4. Upload a storage (MinIO/S3)
        ArchivoAlmacenado almacenado = storagePort.guardar(
            archivo,
            new ByteArrayInputStream(command.contenido())
        );
        
        // 5. Persistir metadata en BD
        archivo = archivoRepository.save(archivo.conDatosAlmacenamiento(almacenado));
        
        // 6. Generar URL firmada (1 hora)
        String urlFirmada = storagePort.generarUrlFirmada(
            almacenado.getStoragePath(),
            Duration.ofHours(1)
        );
        
        // 7. Publicar evento
        eventPublisher.publish(new ArchivoSubidoEvent(
            archivo.getId().getValue(),
            archivo.getUsuarioId().getValue(),
            archivo.getTipo(),
            Instant.now()
        ));
        
        // 8. Log de auditoría
        log.info("Archivo subido - Usuario: {}, Tipo: {}, Tamaño: {}, Checksum: {}",
            archivo.getUsuarioId().getValue(),
            archivo.getTipo(),
            archivo.getTamaño().formateado(),
            archivo.getChecksum().valor());
        
        return SubirArchivoResponse.of(archivo, urlFirmada, almacenado);
    }
    
    private void validarArchivo(byte[] contenido, TipoArchivo tipo) {
        // Validar que no esté vacío
        if (contenido == null || contenido.length == 0) {
            throw new ArchivoVacioException();
        }
        
        // Validar magic bytes (firma del archivo)
        MimeType mimeTypeReal = MimeType.detectar(contenido);
        if (!mimeTypeReal.esCompatibleCon(tipo)) {
            throw new TipoArchivoInvalidoException(
                String.format("Tipo de archivo no coincide. Esperado: %s, Real: %s",
                    tipo, mimeTypeReal)
            );
        }
    }
}

@UseCase
@RequiredArgsConstructor
public class ObtenerUrlFirmadaUseCase {
    
    private final ArchivoRepositoryPort archivoRepository;
    private final ArchivoStoragePort storagePort;
    
    public ObtenerUrlFirmadaResponse ejecutar(ObtenerUrlFirmadaQuery query) {
        
        // 1. Buscar archivo
        Archivo archivo = archivoRepository.findById(query.archivoId())
            .orElseThrow(() -> new ArchivoNoEncontradoException(query.archivoId()));
        
        // 2. Verificar permisos
        if (!archivo.getUsuarioId().equals(query.usuarioSolicitante()) && !archivo.esPublico()) {
            throw new AccesoDenegadoException("No tienes permiso para acceder a este archivo");
        }
        
        // 3. Generar URL firmada
        Duration expiracion = query.expiracionSegundos()
            .map(Duration::ofSeconds)
            .orElse(Duration.ofHours(1));
        
        String urlFirmada = storagePort.generarUrlFirmada(
            archivo.getStoragePath(),
            expiracion
        );
        
        return new ObtenerUrlFirmadaResponse(
            urlFirmada,
            Instant.now().plus(expiracion)
        );
    }
}

@UseCase
@Transactional
@RequiredArgsConstructor
public class EliminarArchivoUseCase {
    
    private final ArchivoRepositoryPort archivoRepository;
    private final ArchivoStoragePort storagePort;
    private final EventPublisher eventPublisher;
    
    public EliminarArchivoResponse ejecutar(EliminarArchivoCommand command) {
        
        // 1. Buscar archivo
        Archivo archivo = archivoRepository.findById(command.archivoId())
            .orElseThrow(() -> new ArchivoNoEncontradoException(command.archivoId()));
        
        // 2. Verificar permisos
        if (!archivo.getUsuarioId().equals(command.usuarioEliminador())) {
            throw new AccesoDenegadoException("Solo el propietario puede eliminar el archivo");
        }
        
        // 3. Soft delete en dominio
        archivo.eliminar(command.usuarioEliminador());
        
        // 4. Persistir cambio
        archivoRepository.save(archivo);
        
        // 5. Eliminar de storage (async, opcional)
        CompletableFuture.runAsync(() -> {
            try {
                storagePort.eliminar(archivo.getStoragePath());
                log.info("Archivo físicamente eliminado - ID: {}", archivo.getId());
            } catch (Exception e) {
                log.error("Error eliminando archivo físico: {}", e.getMessage());
            }
        });
        
        // 6. Publicar evento
        eventPublisher.publish(new ArchivoEliminadoEvent(
            archivo.getId().getValue(),
            archivo.getUsuarioId().getValue(),
            Instant.now()
        ));
        
        return EliminarArchivoResponse.of(archivo);
    }
}
```

**Criterios**:
- [ ] Validación de magic bytes (firma archivo)
- [ ] Escaneo antivirus opcional
- [ ] Upload asíncrono con CompletableFuture
- [ ] Soft delete en BD, hard delete async
- [ ] Control de permisos (propietario/público)
- [ ] Tests con mocks >85%

---

#### TAREA-004-BE-04: Implementar REST Controller [3h]

**Archivos**:
- `infrastructure/web/ArchivosController.java`
- `infrastructure/web/dto/SubirArchivoRequest.java`

**Endpoints**:
```java
@RestController
@RequestMapping("/api/v1/archivos")
@RequiredArgsConstructor
public class ArchivosController {
    
    private final SubirArchivoUseCase subirUseCase;
    private final ObtenerUrlFirmadaUseCase obtenerUrlUseCase;
    private final EliminarArchivoUseCase eliminarUseCase;
    
    @PostMapping("/upload")
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<SubirArchivoResponse>> upload(
            @RequestParam("archivo") MultipartFile archivo,
            @RequestParam("tipoArchivo") TipoArchivo tipoArchivo,
            @RequestParam("usuarioId") UUID usuarioId,
            @RequestParam(value = "descripcion", required = false) String descripcion) {
        
        try {
            SubirArchivoCommand command = SubirArchivoCommand.builder()
                .usuarioId(UsuarioId.of(usuarioId))
                .nombreArchivo(archivo.getOriginalFilename())
                .tipoArchivo(tipoArchivo)
                .contenido(archivo.getBytes())
                .descripcion(descripcion)
                .build();
            
            SubirArchivoResponse response = subirUseCase.ejecutar(command);
            
            return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(ApiResponse.success(response, "Archivo subido exitosamente"));
            
        } catch (IOException e) {
            throw new ArchivoCorruptoException("Error leyendo el archivo");
        }
    }
    
    @PostMapping("/upload-base64")
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<SubirArchivoResponse>> uploadBase64(
            @Valid @RequestBody SubirArchivoBase64Request request) {
        
        // Decodificar base64
        byte[] contenido = decodificarBase64(request.archivoBase64());
        
        SubirArchivoCommand command = SubirArchivoCommand.builder()
            .usuarioId(request.usuarioId())
            .nombreArchivo(request.nombreArchivo())
            .tipoArchivo(request.tipoArchivo())
            .contenido(contenido)
            .build();
        
        SubirArchivoResponse response = subirUseCase.ejecutar(command);
        
        return ResponseEntity
            .status(HttpStatus.CREATED)
            .body(ApiResponse.success(response, "Archivo subido exitosamente"));
    }
    
    @GetMapping("/{archivoId}/url-firmada")
    public ResponseEntity<ApiResponse<ObtenerUrlFirmadaResponse>> obtenerUrlFirmada(
            @PathVariable UUID archivoId,
            @RequestParam(value = "expiracion", defaultValue = "3600") int expiracionSegundos,
            @AuthenticationPrincipal UsuarioAutenticado usuario) {
        
        ObtenerUrlFirmadaQuery query = new ObtenerUrlFirmadaQuery(
            ArchivoId.of(archivoId),
            usuario.getUsuarioId(),
            Optional.of(expiracionSegundos)
        );
        
        ObtenerUrlFirmadaResponse response = obtenerUrlUseCase.ejecutar(query);
        
        return ResponseEntity.ok(ApiResponse.success(response));
    }
    
    @DeleteMapping("/{archivoId}")
    public ResponseEntity<ApiResponse<EliminarArchivoResponse>> eliminar(
            @PathVariable UUID archivoId,
            @AuthenticationPrincipal UsuarioAutenticado usuario) {
        
        EliminarArchivoCommand command = new EliminarArchivoCommand(
            ArchivoId.of(archivoId),
            usuario.getUsuarioId()
        );
        
        EliminarArchivoResponse response = eliminarUseCase.ejecutar(command);
        
        return ResponseEntity.ok(
            ApiResponse.success(response, "Archivo eliminado exitosamente")
        );
    }
    
    @GetMapping("/{archivoId}/descargar")
    public ResponseEntity<Resource> descargar(
            @PathVariable UUID archivoId,
            @AuthenticationPrincipal UsuarioAutenticado usuario) {
        
        // Implementar descarga directa
        // Usar storagePort.descargar() + StreamingResponseBody
        
        return ResponseEntity.ok()
            .contentType(MediaType.APPLICATION_OCTET_STREAM)
            .header(HttpHeaders.CONTENT_DISPOSITION, 
                "attachment; filename=\"" + filename + "\"")
            .body(resource);
    }
    
    private byte[] decodificarBase64(String base64) {
        // Remover prefijo "data:image/jpeg;base64," si existe
        String base64Data = base64.contains(",") 
            ? base64.split(",")[1] 
            : base64;
        
        return Base64.getDecoder().decode(base64Data);
    }
}
```

**Criterios**:
- [ ] Soporte Multipart y Base64
- [ ] Validación con @Valid
- [ ] Autenticación con JWT
- [ ] Exception handlers específicos
- [ ] Documentación OpenAPI
- [ ] Rate limiting (max 10 uploads/min)

---

### 🎨 FRONTEND TASKS

#### TAREA-004-FE-01: Componente Upload Drag & Drop [4h]

**Archivos**:
- `components/shared/FileUpload.tsx`
- `hooks/useFileUpload.ts`

**Implementación**:
```typescript
interface FileUploadProps {
  tipoArchivo: TipoArchivo;
  maxSizeMB: number;
  acceptedTypes: string[];
  onSuccess: (response: UploadResponse) => void;
  onError: (error: Error) => void;
  placeholder?: string;
}

export function FileUpload({
  tipoArchivo,
  maxSizeMB,
  acceptedTypes,
  onSuccess,
  onError,
  placeholder
}: FileUploadProps) {
  
  const [isDragging, setIsDragging] = useState(false);
  const [preview, setPreview] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);
  
  const { mutate: upload, isLoading, progress } = useFileUpload({
    onSuccess,
    onError
  });
  
  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
    
    const file = e.dataTransfer.files[0];
    if (file) {
      validateAndUpload(file);
    }
  };
  
  const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      validateAndUpload(file);
    }
  };
  
  const validateAndUpload = (file: File) => {
    // Validar tamaño
    const maxBytes = maxSizeMB * 1024 * 1024;
    if (file.size > maxBytes) {
      toast.error(`El archivo excede el tamaño máximo de ${maxSizeMB}MB`);
      return;
    }
    
    // Validar tipo
    if (!acceptedTypes.includes(file.type)) {
      toast.error('Tipo de archivo no permitido');
      return;
    }
    
    // Generar preview si es imagen
    if (file.type.startsWith('image/')) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setPreview(reader.result as string);
      };
      reader.readAsDataURL(file);
    }
    
    // Upload
    upload({ file, tipoArchivo });
  };
  
  return (
    <div
      className={`border-2 border-dashed rounded-xl p-8 text-center transition-all ${
        isDragging 
          ? 'border-blue-500 bg-blue-50' 
          : 'border-gray-300 hover:border-gray-400'
      }`}
      onDragOver={(e) => { e.preventDefault(); setIsDragging(true); }}
      onDragLeave={() => setIsDragging(false)}
      onDrop={handleDrop}
    >
      {preview ? (
        <div className="relative">
          <img src={preview} alt="Preview" className="max-h-64 mx-auto rounded-lg" />
          <button
            onClick={() => setPreview(null)}
            className="absolute top-2 right-2 btn-danger-sm"
          >
            Eliminar
          </button>
        </div>
      ) : (
        <>
          <input
            ref={fileInputRef}
            type="file"
            accept={acceptedTypes.join(',')}
            onChange={handleFileSelect}
            className="hidden"
          />
          
          <svg className="w-12 h-12 mx-auto text-gray-400 mb-4" /* Upload icon */ />
          
          <p className="text-gray-600 mb-2">
            {placeholder || 'Arrastra tu archivo aquí o haz clic para seleccionar'}
          </p>
          
          <button
            onClick={() => fileInputRef.current?.click()}
            disabled={isLoading}
            className="btn-primary"
          >
            Seleccionar archivo
          </button>
          
          <p className="text-xs text-gray-500 mt-2">
            Máximo {maxSizeMB}MB • {acceptedTypes.join(', ')}
          </p>
        </>
      )}
      
      {isLoading && (
        <div className="mt-4">
          <div className="w-full bg-gray-200 rounded-full h-2">
            <div
              className="bg-blue-600 h-2 rounded-full transition-all"
              style={{ width: `${progress}%` }}
            />
          </div>
          <p className="text-sm text-gray-600 mt-2">{progress}% completado</p>
        </div>
      )}
    </div>
  );
}

// Hook personalizado
export function useFileUpload({ onSuccess, onError }: UseFileUploadProps) {
  const [progress, setProgress] = useState(0);
  
  const mutation = useMutation({
    mutationFn: async ({ file, tipoArchivo }: UploadData) => {
      const formData = new FormData();
      formData.append('archivo', file);
      formData.append('tipoArchivo', tipoArchivo);
      formData.append('usuarioId', getUserId());
      
      return await apiClient.post('/archivos/upload', formData, {
        onUploadProgress: (progressEvent) => {
          const percentCompleted = Math.round(
            (progressEvent.loaded * 100) / progressEvent.total!
          );
          setProgress(percentCompleted);
        }
      });
    },
    onSuccess: (data) => {
      setProgress(0);
      onSuccess(data);
    },
    onError: (error) => {
      setProgress(0);
      onError(error);
    }
  });
  
  return {
    ...mutation,
    progress
  };
}
```

**Criterios**:
- [ ] Drag & drop funcional
- [ ] Preview de imágenes
- [ ] Progress bar con porcentaje
- [ ] Validación cliente (tamaño, tipo)
- [ ] Manejo de errores UX-friendly
- [ ] Accesibilidad (teclado)

---

## 📊 Estimación Consolidada

| Tarea | Esfuerzo | Rol |
|-------|----------|-----|
| Backend Domain Model Archivo | 3h | Backend Dev |
| Backend MinIO Adapter | 5h | Backend Dev |
| Backend Use Cases | 4h | Backend Dev |
| Backend REST Controllers | 3h | Backend Dev |
| Frontend Drag & Drop Component | 4h | Frontend Dev |
| Image Processing (Thumbnails) | 2h | Backend Dev |
| Tests E2E Upload | 3h | QA Engineer |
| **TOTAL** | **24h** | **~3 días** |

**Story Points**: 8 (Fibonacci)

---

## 🔗 Dependencies & Blockers

### Dependencias:
- ✅ [HUT-001] Registro Estudiantes (usuarios)
- ✅ [HUT-002] Registro Tutores (usuarios)
- ⏳ MinIO instalado y configurado
- ⏳ ClamAV configurado (opcional, enterprise)

### Blockers Potenciales:
- ⚠️ MinIO no accesible desde staging
- ⚠️ Límites de almacenamiento en producción
- ⚠️ ClamAV no instalado (virus scan)

---

## ✅ Definition of Done

### Backend:
- [ ] MinIO adapter implementado
- [ ] S3 adapter implementado (opcional)
- [ ] Thumbnails generados para imágenes
- [ ] Pre-signed URLs con expiración
- [ ] Soft delete implementado
- [ ] Tests con Testcontainers MinIO

### Frontend:
- [ ] Drag & drop funcional
- [ ] Progress bar visual
- [ ] Preview de imágenes
- [ ] Validación cliente robusta
- [ ] Tests unitarios >80%

### Seguridad:
- [ ] Magic bytes validation
- [ ] Checksum MD5 calculado
- [ ] Rate limiting (10 uploads/min)
- [ ] URLs firmadas con expiración

---

**Versión**: 1.0  
**Fecha**: 2025-11-16  
**Autor**: Technical User Stories Engineer  
**Metodología**: ZNS v2.0
