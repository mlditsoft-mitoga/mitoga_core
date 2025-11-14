# 🛒 Caso de Estudio Completo: ShopFast E-commerce MVP

**Propósito**: Demostración end-to-end del Método ZNS v2.0 aplicado a un proyecto real de e-commerce.

---

## 📋 Información del Proyecto

### Contexto del Cliente

**Empresa**: ShopFast Inc.  
**Industria**: Retail / E-commerce  
**Necesidad**: Plataforma MVP de e-commerce B2C para venta de electrónicos

### Restricciones del Proyecto

| Restricción | Valor |
|-------------|-------|
| **Presupuesto** | $50,000 USD |
| **Timeline** | 3 meses (12 semanas) |
| **Equipo** | 1 Tech Lead + 2 Fullstack Devs + 1 QA |
| **Nivel de Experiencia** | Mid-level (2-4 años) |
| **Stack Preferido** | Node.js, React, PostgreSQL |
| **Compliance** | PCI DSS Level 4, GDPR básico |

### Objetivos de Negocio

1. ✅ Lanzar MVP en 3 meses con funcionalidades core
2. ✅ Soportar 1,000 productos inicialmente
3. ✅ Procesar 100 órdenes/día
4. ✅ Integración con pasarela de pagos (Stripe)
5. ✅ Panel administrativo básico

---

## 📂 Estructura del Caso de Estudio

```
shopfast-ecommerce-mvp/
├── README.md (este archivo)
├── 00-inputs/                           # Entrada: Documentos del cliente
│   ├── rfp-shopfast.pdf
│   ├── requisitos-funcionales.docx
│   ├── mockups-ui.pptx
│   └── checklist-stack-cliente.md
├── 01-fase0-consolidacion/              # Fase 0: Consolidación
│   ├── ejecucion-paso-a-paso.md
│   ├── 01-contexto-negocio.md
│   ├── 02-requisitos-funcionales.md
│   └── 03-requisitos-no-funcionales.md
├── 02-fase2-arquitectura/               # Fase 2: Arquitectura (saltamos Fase 1)
│   ├── ejecucion-paso-a-paso.md
│   ├── adrs/
│   │   ├── ADR-001-arquitectura-monolitica-modular.md
│   │   ├── ADR-002-stack-tecnologico.md
│   │   └── ADR-003-estrategia-persistencia.md
│   ├── diagrams/
│   │   ├── c4-l1-context-shopfast.puml
│   │   ├── c4-l2-container-shopfast.puml
│   │   └── c4-l3-component-catalog.puml
│   └── specs/
│       ├── modulo-catalogo.md
│       ├── modulo-carrito.md
│       └── api-endpoints.md
├── 03-fase2.1-modelado-datos/           # Fase 2.1: Modelado Datos
│   ├── ejecucion-paso-a-paso.md
│   ├── modelo-datos-shopfast.md
│   └── erd-shopfast.puml
└── 04-analisis-completo/                # Análisis retrospectivo
    ├── tiempo-real-vs-estimado.md
    ├── decisiones-criticas.md
    └── lecciones-aprendidas.md
```

---

## 🎯 Flujo de Ejecución Demostrado

### Fase 0: Consolidación de Contexto
**Prompt usado**: `prompt-maestro-consolidacion.md`  
**Input**: Documentos en `00-inputs/`  
**Output**: 3 archivos consolidados en `01-fase0-consolidacion/`  
**Tiempo real**: 2.5 horas  
**Ver detalles**: [ejecucion-paso-a-paso.md](01-fase0-consolidacion/ejecucion-paso-a-paso.md)

### Fase 2: Diseño de Arquitectura
**Prompt usado**: `prompt-arquitectura-soluciones.md`  
**Input**: Contexto consolidado de Fase 0  
**Output**: 3 ADRs, 3 diagramas C4, 3 specs de módulos  
**Tiempo real**: 4.2 horas  
**Ver detalles**: [ejecucion-paso-a-paso.md](02-fase2-arquitectura/ejecucion-paso-a-paso.md)

**Decisiones Arquitectónicas Clave**:
- ✅ Monolito modular (no microservicios por presupuesto)
- ✅ Next.js 14 + Node.js + PostgreSQL
- ✅ Deploy en Vercel + Supabase (PaaS para velocidad)
- ✅ Stripe para pagos (reduce complejidad PCI)

### Fase 2.1: Modelado de Datos
**Prompt usado**: `prompt-modelado-datos.md`  
**Input**: Specs de módulos de Fase 2  
**Output**: Modelo de datos completo + ERD + SQL schema  
**Tiempo real**: 3.1 horas  
**Ver detalles**: [ejecucion-paso-a-paso.md](03-fase2.1-modelado-datos/ejecucion-paso-a-paso.md)

---

## 📊 Métricas del Proyecto

### Tiempo Total Invertido

| Fase | Estimado | Real | Variación |
|------|----------|------|-----------|
| Fase 0: Consolidación | 2-4h | 2.5h | ✅ Dentro |
| Fase 1: Obsolescencia | - | - | ⏭️ Saltada (proyecto nuevo) |
| Fase 2: Arquitectura | 4-6h | 4.2h | ✅ Dentro |
| Fase 2.1: Modelado Datos | 3-4h | 3.1h | ✅ Dentro |
| **TOTAL** | **9-14h** | **9.8h** | ✅ **70% del rango estimado** |

### Artefactos Generados

| Tipo de Documento | Cantidad | Páginas Totales |
|-------------------|----------|-----------------|
| Contexto Consolidado | 3 | 18 |
| ADRs | 3 | 12 |
| Diagramas C4/PlantUML | 4 | - |
| Especificaciones Módulos | 3 | 24 |
| Modelo de Datos | 1 | 8 |
| Schema SQL | 1 | 3 |
| **TOTAL** | **15** | **65 páginas** |

---

## 🎓 Lecciones Aprendidas

### ✅ Lo que funcionó bien

1. **Restricciones claras desde el inicio**: Presupuesto y timeline definidos ayudaron a tomar decisiones rápidas
2. **Saltar Fase 1 en greenfield**: No analizar obsolescencia en proyecto nuevo ahorró 3-5 horas
3. **Plantillas ADR**: Aceleraron documentación de decisiones (30 min/ADR vs 90 min sin plantilla)
4. **PlantUML + C4**: Diagramas consistentes y mantenibles desde código

### ⚠️ Desafíos encontrados

1. **Falta de información de volúmenes**: Tuvimos que hacer supuestos (documentados) sobre tráfico esperado
2. **Stack del equipo no 100% alineado**: Equipo tenía experiencia en Vue, no React (agregamos riesgo en ADR)
3. **Compliance subestimado inicialmente**: GDPR requirió más análisis de lo previsto

### 💡 Recomendaciones para casos similares

1. **Validar experiencia del equipo temprano**: Antes de definir stack en ADR-002
2. **Crear checklist de compliance**: Antes de Fase 2 si hay regulaciones
3. **Usar plantilla de supuestos**: Documentar lo que falta desde Fase 0

---

## 📖 Cómo Usar Este Caso de Estudio

### Opción 1: Lectura Secuencial
1. Leer inputs en `00-inputs/`
2. Revisar cada fase en orden
3. Comparar outputs con plantillas originales

### Opción 2: Aprendizaje por Decisión
1. Ir directamente a `02-fase2-arquitectura/adrs/`
2. Estudiar matrices de decisión
3. Entender trade-offs documentados

### Opción 3: Replicación
1. Usar este proyecto como template
2. Reemplazar inputs con tu proyecto
3. Seguir mismo flujo de ejecución

---

## 📞 Preguntas Frecuentes

**P: ¿Por qué saltaron la Fase 1 (Obsolescencia)?**  
R: Es un proyecto greenfield (nuevo desde cero). La Fase 1 es para proyectos brownfield (modernización).

**P: ¿Por qué solo 9.8 horas si un proyecto real toma meses?**  
R: El Método ZNS cubre **diseño y documentación de arquitectura**, no implementación de código.

**P: ¿Puedo usar este caso para mi proyecto?**  
R: ✅ Sí, está bajo licencia MIT. Puedes adaptar plantillas y estructura.

**P: ¿Dónde están los archivos de input simulados?**  
R: En `00-inputs/`. Son versiones simplificadas de documentos reales de cliente.

---

## 🔗 Referencias

- [Método ZNS v2.0](../../README.md)
- [Plantilla ADR](../../02-agents/2.definition_of_architecture/plantilla-adr.md)
- [Política de Diagramación](../../02-agents/2.definition_of_architecture/politica-diagramacion.md)
- [C4 Model](https://c4model.com)

---

**Versión del Caso**: 1.0.0  
**Fecha de Creación**: 7 de noviembre de 2025  
**Autor**: Equipo Método ZNS  
**Licencia**: MIT
