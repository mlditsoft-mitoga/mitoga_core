# HU-064: Resolver Disputas entre Usuarios

## 📋 Historia de Usuario

**Como** administrador,  
**Quiero** gestionar disputas y tickets de soporte entre estudiantes y tutores,  
**Para** mediar conflictos y mantener satisfacción de ambas partes.

## 🎯 Valor de Negocio

Sistema de resolución de disputas es crítico para retención de usuarios y prevenir chargebacks.

**Impacto:** Chargebacks reducidos 40%, NPS aumentado 10 puntos

## 📝 Descripción Detallada

Sistema de tickets con estados: Abierto, En Revisión, Resuelto, Cerrado. Tipos comunes: "Tutor no se presentó", "Calidad de sesión mala", "Problema técnico", "Solicitud de reembolso". Admin puede: Ver historial completo de la sesión, Comunicarse con ambas partes por mensaje interno, Emitir reembolsos manuales, Aplicar créditos a cuenta, Cerrar caso con notas de resolución.

## ✅ Criterios de Aceptación

### Escenario 1: Ver cola de disputas abiertas

**Cuando** navego a "Soporte" → "Disputas"  
**Entonces** veo tabla con:
- ID Ticket, Usuario, Tipo disputa, Fecha, Prioridad (Alta/Media/Baja), Estado
- Filtros: Por tipo, por fecha, por estado
- Badge rojo: "3 disputas urgentes" (más de 24h sin respuesta)

### Escenario 2: Revisar detalle de disputa

**Cuando** abro ticket #1234: "Tutor no se presentó a la sesión"  
**Entonces** veo:
- Estudiante: María García
- Tutor: Juan Pérez
- Sesión: 10/11/2025 14:00 - Matemáticas
- Reclamo: "Esperé 20 minutos, el tutor nunca entró"
- Evidencia: Screenshot de sala de espera con timestamp
- Historial: Tutor no marcó "sesión iniciada"
- Botones: [Mensaje al Estudiante] [Mensaje al Tutor] [Emitir Reembolso] [Cerrar]

### Escenario 3: Comunicarse con las partes

**Cuando** hago clic en [Mensaje al Tutor]  
**Entonces** se abre editor de mensaje interno  
**Y** escribo: "Hola Juan, ¿qué sucedió con la sesión del 10/11? El estudiante reporta que no te presentaste"  
**Y** al enviar, el tutor recibe email + notificación in-app  
**Y** puede responder directamente en el ticket

### Escenario 4: Emitir reembolso manual

**Dado que** confirmo que el tutor no se presentó (sin justificación válida)  
**Cuando** hago clic en [Emitir Reembolso]  
**Entonces** se genera reembolso de $50,000 COP a la tarjeta del estudiante  
**Y** se envía email al estudiante: "Tu reembolso fue aprobado. Llegará en 5-10 días"  
**Y** se aplica penalidad al tutor: Advertencia (3 = suspensión)  
**Y** cierro el ticket con nota: "Reembolso emitido, advertencia al tutor"

### Escenario 5: Aplicar crédito en lugar de reembolso

**Dado que** el problema fue técnico (no culpa de tutor ni estudiante)  
**Cuando** hago clic en [Aplicar Crédito]  
**Entonces** agrego $50,000 COP de saldo a la cuenta del estudiante  
**Y** el crédito es usable en próximas reservas  
**Y** se envía email: "Agregamos $50,000 de crédito por las molestias"

### Escenario 6: Cerrar disputa con resolución

**Cuando** ambas partes llegaron a acuerdo  
**Y** hago clic en [Cerrar Disputa]  
**Entonces** escribo nota de resolución: "Acordaron reprogramar sesión sin costo"  
**Y** el estado cambia a "Cerrado"  
**Y** se calcula SLA: Tiempo de resolución 4 horas (Meta: <24h)

## 🔗 Trazabilidad

- **Módulo:** Admin
- **RF:** RF-074 (Resolver disputas)
- **Prioridad:** SHOULD HAVE

## 📊 Estimación

- **Story Points:** 8
- **Complejidad:** Alta (flujo complejo, reembolsos, mensajería)

## 🔄 Dependencias

- Depende de: HU-034 (Solicitar reembolso), HU-062 (Gestionar usuarios)
- Relacionada con: HU-037 (Transferir fondos tutor)

## 🧪 Testing

- Flujo completo: Abrir disputa → Mensaje → Reembolso → Cerrar
- Reembolsos: Integración con Stripe refunds
- SLA: Alertas si disputa >24h sin respuesta
- Audit log: Todas las acciones registradas

## 📌 Etiquetas

`#admin` `#disputas` `#soporte` `#reembolsos` `#release-1.1`
