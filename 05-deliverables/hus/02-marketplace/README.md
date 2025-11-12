# Módulo: Marketplace

**Responsable:** Product Manager + Frontend Lead  
**Story Points Totales:** 45 SP  
**Historias:** 6 HUs (5 MUST, 1 SHOULD)

---

## 🎯 Objetivo del Módulo

Facilitar el descubrimiento y evaluación de tutores mediante búsqueda inteligente, filtros avanzados, perfiles completos y sistema de reseñas verificadas.

---

## 📋 Historias de Usuario

| ID | Título | Rol | Prioridad | SP | Estado |
|----|--------|-----|-----------|----|----|
| [HU-010](HU-010-buscar-tutores.md) | Buscar tutores por materia | Estudiante | MUST | 8 | ✅ Generada |
| [HU-011](HU-011-filtrar-resultados.md) | Filtrar por precio/rating/disponibilidad | Estudiante | MUST | 5 | ✅ Generada |
| [HU-012](HU-012-ver-perfil-tutor.md) | Ver perfil completo tutor | Estudiante | MUST | 8 | ✅ Generada |
| [HU-013](HU-013-ordenar-resultados.md) | Ordenar por rating/precio/relevancia | Estudiante | MUST | 3 | ✅ Generada |
| [HU-014](HU-014-ver-resenas.md) | Ver reseñas de tutor | Estudiante | MUST | 5 | ✅ Generada |
| [HU-015](HU-015-calificar-tutor.md) | Calificar y reseñar tutor | Estudiante | SHOULD | 8 | ✅ Generada |

**Total:** 37 SP (5 MUST + 1 SHOULD)

---

## 🔗 Dependencias

**Servicios externos:**
- AWS S3 / Cloudinary (fotos perfil tutores, videos presentación)
- Elasticsearch (opcional Fase 2 para búsqueda avanzada)

**RNF críticos:**
- RNF-PERF-001: Búsqueda <500ms (1000+ tutores)
- RNF-USAB-001: Autocompletado después 2 caracteres
- RNF-SEO-001: URLs amigables indexables Google

---

## 🧪 Testing

- **Cobertura esperada:** >85%
- **Tests E2E:** Búsqueda→filtros→perfil→reserva (funnel completo)
- **Load testing:** 100 búsquedas concurrentes sin degradación
- **A/B testing:** Ordenamiento default (relevancia vs mejor valorados)

---

## 📊 Métricas

| Métrica | Objetivo | Seguimiento |
|---------|----------|-------------|
| Búsquedas exitosas (>1 resultado) | > 85% | Analytics |
| Click-through rate (búsqueda→perfil) | > 40% | Hotjar |
| Conversión (perfil→reserva) | > 25% | Mixpanel |
| Tiempo promedio búsqueda→reserva | < 3 minutos | User journey |

---

**Última actualización:** 08/11/2025  
**Estado:** 6/6 HUs generadas (100% documentación)
