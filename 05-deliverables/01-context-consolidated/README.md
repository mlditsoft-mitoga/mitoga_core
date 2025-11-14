# 📁 Contexto Consolidado del Proyecto

Este directorio contiene el **contexto consolidado** del proyecto, resultado del análisis y síntesis de todas las fuentes de entrada disponibles en `00-raw-inputs/`.

## 🎯 Propósito

Proveer documentación estructurada y organizada que sirva como base de conocimiento única para:
- Agentes de arquitectura y diseño
- Equipos de desarrollo
- Generación de artefactos técnicos (ADRs, diagramas, modelo de datos)
- Creación de historias de usuario y especificaciones

## 📄 Documentos Consolidados

### `01-contexto-negocio.md`
**Descripción:** Contexto del negocio, dominio del problema, stakeholders y objetivos estratégicos.

**Contenido:**
- Descripción del proyecto y propuesta de valor
- Actores y roles (estudiantes, tutores, administradores)
- Modelo de negocio y flujos clave
- Métricas de éxito y KPIs

### `02-requisitos-funcionales.md`
**Descripción:** Requisitos funcionales consolidados por módulos/dominios.

**Contenido:**
- Módulos identificados (Autenticación, Marketplace, Reservas, Pagos, Videollamadas, Notificaciones, Admin, Perfiles)
- Funcionalidades MUST-HAVE (MVP) y priorización MoSCoW
- Flujos de usuario principales
- Reglas de negocio críticas

### `03-requisitos-no-funcionales.md`
**Descripción:** Requisitos no funcionales (rendimiento, seguridad, escalabilidad, compliance).

**Contenido:**
- Atributos de calidad (ISO 25010)
- Restricciones técnicas y regulatorias
- SLAs y objetivos de disponibilidad
- Seguridad y privacidad (GDPR, PCI-DSS si aplica)
- Capacidad, volúmenes esperados y crecimiento

## 🔄 Proceso de Consolidación

Este contexto fue generado mediante el **Método ZNS v2.0** utilizando el prompt maestro:
```
02-agents/0.consolidation_context/prompt-maestro-consolidacion.md
```

**Fuentes de entrada:**
- Documentos de negocio y RFPs (`00-raw-inputs/word/`, `pdfs/`, `powerpoint/`)
- Código fuente existente (`00-raw-inputs/code/`)
- Checklist de stack tecnológico del cliente
- Contexto del proyecto (`PROYECTO_CONTEXTO.md`)

## 🔗 Uso en el Flujo de Trabajo

1. **Fase de Análisis** → Los documentos de este directorio alimentan el análisis de obsolescencia y evaluación técnica en `03-analysis/`
2. **Fase de Arquitectura** → Sirven como entrada para definir arquitectura, ADRs y modelo de datos en `04-architecture/`
3. **Fase de Generación de HUs** → Base para crear historias de usuario funcionales en `05-deliverables/hus/`

## ✅ Validación y Mantenimiento

- Los documentos consolidados deben revisarse cuando se añadan nuevos inputs en `00-raw-inputs/`
- Cambios significativos en requisitos deben reflejarse aquí y propagarse a artefactos dependientes
- Mantener trazabilidad entre requisitos consolidados y artefactos generados (ADRs, HUs, specs)

## 📌 Notas

- Este directorio NO contiene código ni artefactos técnicos, solo documentación de contexto
- Para diagramas, ADRs y especificaciones técnicas, ver `04-architecture/`
- Para historias de usuario y entregables finales, ver `05-deliverables/`

---

**Última actualización:** Noviembre 2025  
**Metodología:** ZNS v2.0  
**Responsable:** Equipo de Arquitectura y Análisis
