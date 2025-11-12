# Módulo: Perfiles

**Responsable:** Full Stack Team  
**Story Points Totales:** 32 SP  
**Historias:** 5 HUs MUST HAVE

---

## 🎯 Objetivo del Módulo

Gestionar datos personales, profesionales y financieros de estudiantes y tutores, incluyendo certificaciones verificadas y configuración de disponibilidad.

---

## 📋 Historias de Usuario

| ID | Título | Rol | Prioridad | SP | Estado |
|----|--------|-----|-----------|----|----|
| [HU-070](HU-070-editar-perfil-estudiante.md) | Crear/editar perfil estudiante | Estudiante | MUST | 5 | ✅ Generada |
| [HU-071](HU-071-subir-certificados-tutor.md) | Subir certificados profesionales | Tutor | MUST | 8 | ✅ Generada |
| [HU-072](HU-072-configurar-disponibilidad.md) | Configurar disponibilidad horaria | Tutor | MUST | 8 | ✅ Generada |
| [HU-073](HU-073-historial-sesiones.md) | Ver historial sesiones completo | Est/Tutor | MUST | 3 | ✅ Generada |
| [HU-074](HU-074-desactivar-cuenta.md) | Desactivar/eliminar cuenta | Usuario | MUST | 3 | ✅ Generada |

**Total:** 27 SP

---

## 🔗 Dependencias

**Servicios externos:**
- AWS S3 (almacenamiento certificados privados con pre-signed URLs)
- Image processing (Sharp/Cloudinary para resize fotos perfil)

**RNF críticos:**
- RNF-SEC-008: Certificados encrypted at rest
- RNF-GDPR-001: Derecho al olvido (anonimización datos)
- RNF-USAB-005: Preview foto antes guardar

---

## 🧪 Testing

- **Cobertura esperada:** >90% (datos sensibles)
- **Tests E2E:** Upload certificado→aprobación admin→badge visible
- **Security testing:** Validar acceso certificados solo admin/owner
- **GDPR compliance:** Verificar eliminación completa datos (audit logs)

---

## 📊 Métricas

| Métrica | Objetivo |
|---------|----------|
| Tutores con certificados verificados | > 70% |
| Estudiantes con perfil completo | > 60% |
| Tiempo aprobación certificados | < 48h |
| Tutores con disponibilidad configurada | 100% (obligatorio) |

---

**Última actualización:** 08/11/2025  
**Estado:** 5/5 HUs generadas (100%)
