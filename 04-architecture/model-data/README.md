# Modelado de Datos - Outputs

Esta carpeta contiene todos los entregables relacionados con el diseño del modelo de datos del sistema.

## 📂 Estructura

```
modelo-datos/
├── README.md                          # Este archivo
├── modelo-datos-[proyecto]-[fecha].md # Documento principal de arquitectura de datos
├── diagramas/                         # Diagramas ERD y de distribución de datos
│   ├── erd-completo.puml             # ERD completo del sistema
│   ├── erd-[servicio].puml           # ERD por servicio/módulo
│   └── data-distribution.puml        # Diagrama de distribución (microservicios)
└── database/                          # Scripts y configuraciones de base de datos
    ├── migrations/                    # Scripts de migración versionados
    │   ├── V001__initial_schema.sql
    │   ├── V002__add_indexes.sql
    │   └── ...
    ├── seeds/                         # Datos iniciales/demo
    │   └── seed_initial_data.sql
    └── scripts/                       # Scripts utilitarios
        ├── backup.sh
        ├── restore.sh
        └── anonymize_user.sql
```

## 📋 Entregables Esperados

### 1. Documento Principal
**Archivo:** `modelo-datos-[proyecto]-[fecha].md`

**Contenido:**
- Estrategia de persistencia (Polyglot Persistence)
- Base de datos por servicio/módulo con justificación
- Modelo conceptual (entidades, relaciones, bounded contexts)
- Esquemas detallados (DDL completo)
- Estrategia de índices y optimización
- Caching layers y TTLs
- Estrategia de consistencia (ACID / Saga / Eventual)
- Seguridad y compliance (encriptación, auditoría, GDPR)
- Migrations y versionado
- Backup y Disaster Recovery (RPO/RTO)
- Análisis de performance de queries críticos

### 2. Diagramas ERD (PlantUML)

**Archivos en `/diagramas/`:**
- `erd-completo.puml` - Diagrama entidad-relación completo del sistema
- `erd-user-service.puml` - ERD del servicio de usuarios (ejemplo)
- `erd-order-service.puml` - ERD del servicio de pedidos (ejemplo)
- `data-distribution.puml` - Diagrama de distribución de datos entre servicios

**Características de los ERDs:**
- Notación Crow's Foot o Chen
- Tipos de datos especificados
- Primary Keys y Foreign Keys identificados
- Cardinalidades claramente marcadas (1:1, 1:N, N:M)
- Índices críticos documentados

### 3. Scripts de Base de Datos

**Migrations (`/database/migrations/`):**
- Archivos versionados (V001, V002, etc.)
- Compatibles con Flyway/Liquibase/TypeORM/Alembic
- Incluyen rollback strategy cuando aplique
- Comentados con contexto de cada cambio

**Seeds (`/database/seeds/`):**
- Datos iniciales para desarrollo/testing
- Datos de referencia (catálogos, configuraciones)
- Scripts idempotentes (safe to run múltiples veces)

**Scripts Utilitarios (`/database/scripts/`):**
- Backup y restore procedures
- Scripts de anonimización (GDPR compliance)
- Scripts de maintenance (VACUUM, ANALYZE, REINDEX)
- Health checks y monitoring queries

## 🎯 Workflow de Uso

### 1. Generar Modelo de Datos
```bash
# Ejecutar prompt de modelado de datos
Claude/GPT-4, ejecuta:
./02-agentes/2.definicion_arquitectura/prompt-modelado-datos.md

# Salida esperada:
./03-arquitectura/modelo-datos/modelo-datos-[proyecto]-[fecha].md
```

### 2. Generar Diagramas ERD
```bash
# Los ERDs se generan en PlantUML durante el proceso
# Renderizar a SVG/PNG:
plantuml ./03-arquitectura/modelo-datos/diagramas/*.puml

# O usar extensión VSCode: PlantUML (jebbs.plantuml)
```

### 3. Aplicar Migrations
```bash
# Con Flyway (Java/Spring Boot)
flyway migrate -locations=filesystem:./database/migrations

# Con TypeORM (Node.js)
npm run typeorm migration:run

# Con Alembic (Python)
alembic upgrade head
```

### 4. Cargar Seeds (Desarrollo)
```bash
# PostgreSQL
psql -d database_name -f ./database/seeds/seed_initial_data.sql

# MySQL
mysql database_name < ./database/seeds/seed_initial_data.sql
```

## 📊 Checklist de Calidad

### ✅ Modelado Conceptual
- [ ] Identificadas todas las entidades del dominio
- [ ] Definidas relaciones y cardinalidades
- [ ] Bounded contexts definidos (si microservicios)
- [ ] Diagrama ERD completo generado

### ✅ Estrategia de Persistencia
- [ ] Base de datos seleccionada por servicio/módulo con justificación técnica
- [ ] Estrategia de consistencia definida (ACID / Saga / Eventual)
- [ ] Patrón de comunicación entre servicios definido

### ✅ Esquemas Detallados
- [ ] DDL completo con tipos de datos, constraints, defaults
- [ ] Índices estratégicos para queries críticos
- [ ] Triggers y stored procedures documentados
- [ ] Estrategia de particionamiento (si tablas > 10M registros)

### ✅ Performance
- [ ] Queries críticos identificados y optimizados
- [ ] Estrategia de caching definida (layers, TTLs, invalidación)
- [ ] Read replicas planificadas (si RPS > 1000)
- [ ] Sharding evaluado (si aplica)

### ✅ Seguridad
- [ ] PII identificados y estrategia de encriptación definida
- [ ] Auditoría de cambios implementada
- [ ] Procedimiento de anonimización (GDPR)
- [ ] Encriptación at-rest y in-transit

### ✅ Operaciones
- [ ] Estrategia de migrations y versionado
- [ ] Scripts de backup y restore
- [ ] RPO/RTO targets definidos
- [ ] Monitoreo de DB planificado

## 🔗 Referencias

- **Prompt de Modelado:** `../../02-agentes/2.definicion_arquitectura/prompt-modelado-datos.md`
- **Guía PlantUML:** Ver sección en `prompt-arquitectura-soluciones.md`
- **Templates:** `plantilla-modulo-servicio.md`, `plantilla-api-endpoint.md`

---

**Rol Especializado:** Data Architect Senior & Database Engineer  
**Versión:** Método ZNS v2.0
