# HU-067: Ver Logs de Auditoría del Sistema

## 📋 Historia de Usuario

**Como** administrador de seguridad,  
**Quiero** ver logs de todas las acciones administrativas realizadas en la plataforma,  
**Para** auditorías de seguridad, compliance y trazabilidad de cambios.

## 🎯 Valor de Negocio

Audit log es requisito de compliance (SOC 2, ISO 27001) y previene fraude interno.

**Impacto:** Compliance de seguridad, Trazabilidad 100%, Prevención de fraude

## 📝 Descripción Detallada

Sistema de audit log que registra todas las acciones administrativas: Login de admin, Aprobación/rechazo de tutores, Suspensiones de cuentas, Cambios de configuración, Emisión de reembolsos, Acceso a datos de usuarios. Campos: Timestamp, Admin (quien), Acción (qué), Entidad afectada (usuario/tutor ID), IP address, User agent. Búsqueda y filtrado avanzado. Retención de logs: 7 años (compliance).

## ✅ Criterios de Aceptación

### Escenario 1: Ver logs de acciones recientes

**Cuando** navego a "Seguridad" → "Audit Logs"  
**Entonces** veo tabla con logs más recientes (últimas 100 acciones):
- 2025-11-08 14:32:15 | Admin: Juan Pérez | Acción: Aprobó tutor ID 1234 | IP: 192.168.1.50
- 2025-11-08 14:25:03 | Admin: María García | Acción: Suspendió usuario ID 567 | Motivo: Spam | IP: 192.168.1.51
- 2025-11-08 14:10:22 | Admin: Juan Pérez | Acción: Cambió comisión general: 18% → 20%

### Escenario 2: Buscar logs por admin específico

**Cuando** filtro por "Admin: María García"  
**Y** rango de fechas: Última semana  
**Entonces** veo solo las acciones realizadas por María  
**Y** puedo verificar su actividad (ej: cuántos tutores aprobó)

### Escenario 3: Buscar logs por tipo de acción

**Cuando** filtro por "Acción: Reembolso emitido"  
**Entonces** veo lista de todos los reembolsos aprobados manualmente  
**Y** cada log incluye: Admin responsable, Monto, Usuario beneficiado, Motivo

### Escenario 4: Ver detalle de un log específico

**Cuando** hago clic en un log: "Suspendió usuario ID 567"  
**Entonces** veo modal con JSON completo del evento:
```json
{
  "timestamp": "2025-11-08T14:25:03Z",
  "admin_id": 42,
  "admin_name": "María García",
  "action": "user_suspended",
  "entity_type": "user",
  "entity_id": 567,
  "changes": {
    "status": { "from": "active", "to": "suspended" },
    "suspension_reason": "Spam recurrente",
    "suspension_duration": "permanent"
  },
  "ip_address": "192.168.1.51",
  "user_agent": "Chrome/119.0 Windows"
}
```

### Escenario 5: Exportar logs para auditoría externa

**Cuando** selecciono rango: Todo el año 2025  
**Y** hago clic en [Exportar Logs]  
**Entonces** se genera archivo CSV con todos los logs  
**Y** incluye 15,234 registros con todas las columnas  
**Y** el archivo está firmado digitalmente (hash SHA-256 para integridad)

### Escenario 6: Alertas de acciones sensibles

**Dado que** quiero monitorear acciones críticas  
**Cuando** un admin emite un reembolso >$500,000 COP  
**Entonces** se envía alerta automática a email del CTO  
**Y** se marca el log con flag "🚨 Acción Sensible"

## 🔗 Trazabilidad

- **Módulo:** Admin
- **RF:** RF-076 (Audit logs)
- **RNF:** RNF-SEC-004 (Trazabilidad de acciones admin), RNF-COMP-002 (Retención 7 años)
- **Prioridad:** MUST HAVE

## 📊 Estimación

- **Story Points:** 5
- **Complejidad:** Media (logging infrastructure + búsqueda)

## 🔄 Dependencias

- Depende de: Todas las HUs de admin (generan logs)
- Relacionada con: HU-062 (Gestionar usuarios - logs de acciones)

## 🧪 Testing

- Performance: Búsqueda en 100K logs <2s
- Retención: Verificar logs no se borran antes de 7 años
- Integridad: Hash SHA-256 de exports
- Alertas: Reembolso grande trigger email

## 📌 Etiquetas

`#admin` `#seguridad` `#audit-log` `#compliance` `#trazabilidad` `#release-1.0`
