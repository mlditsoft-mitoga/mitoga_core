# HU-053: Configurar Preferencias de Notificaciones

## 📋 Historia de Usuario

**Como** usuario de la plataforma,  
**Quiero** configurar qué notificaciones recibo y por cuáles canales,  
**Para** controlar el volumen de comunicaciones según mis preferencias personales.

## 🎯 Valor de Negocio

Dar control al usuario sobre notificaciones **previene el churn** por fatiga de notificaciones excesivas. Es un requisito de compliance (GDPR: derecho a controlar comunicaciones).

**Impacto:** Retención aumentada 10%, Compliance GDPR, Tickets de "Desuscribir" reducidos 80%

## 📝 Descripción Detallada

Panel de preferencias en "Configuración" con toggles granulares para cada tipo de notificación (confirmaciones, recordatorios, mensajes, promociones) y cada canal (email, push, SMS opcional). Cambios aplicados inmediatamente. Opción de "Silenciar todo" temporal (modo no molestar).

## ✅ Criterios de Aceptación

### Escenario 1: Acceder al panel de preferencias

**Dado que** quiero personalizar mis notificaciones  
**Cuando** navego a "Mi Perfil" → "Configuración" → "Notificaciones"  
**Entonces** veo una tabla con filas de tipos de notificaciones y columnas de canales:

| Tipo de Notificación | Email | Push | SMS |
|---|---|---|---|
| Confirmaciones de reserva | ✅ | ✅ | ⬜ |
| Recordatorios (24h/1h) | ✅ | ✅ | ⬜ |
| Nuevos mensajes | ✅ | ✅ | ⬜ |
| Cambios en reservas | ✅ | ✅ | ⬜ |
| Promociones y ofertas | ⬜ | ⬜ | ⬜ |

**Y** cada checkbox es interactivo para activar/desactivar

### Escenario 2: Desactivar recordatorios por push

**Dado que** no quiero notificaciones push de recordatorios (solo email)  
**Cuando** desactivo el checkbox de "Recordatorios" → "Push"  
**Entonces** veo un mensaje de confirmación: "Preferencias guardadas ✓"  
**Y** a partir de ese momento, no recibo push de recordatorios  
**Y** sigo recibiendo emails de recordatorios normalmente

### Escenario 3: Activar modo "No Molestar" temporal

**Dado que** estoy de vacaciones por 1 semana  
**Cuando** activo el toggle "Modo No Molestar" y selecciono fechas (10/11 - 17/11)  
**Entonces** durante esas fechas **no recibo** ninguna notificación push  
**Y** los emails críticos (confirmaciones) se siguen enviando  
**Y** veo un banner: "🔕 Modo No Molestar activo hasta el 17/11"

### Escenario 4: Silenciar notificaciones promocionales

**Dado que** solo quiero notificaciones transaccionales  
**Cuando** desactivo todos los checkboxes de "Promociones y ofertas"  
**Entonces** no recibo emails de marketing ni ofertas especiales  
**Y** sigo recibiendo confirmaciones y recordatorios normalmente

### Escenario 5: Aplicación inmediata de cambios

**Dado que** cambio 3 preferencias (desactivo promociones email, activo SMS recordatorios)  
**Cuando** hago clic en "Guardar Cambios"  
**Entonces** las preferencias se guardan en BD en <1 segundo  
**Y** los cambios se aplican inmediatamente (no requiero cerrar sesión)  
**Y** veo confirmación visual: "✅ Preferencias actualizadas"

## 🔗 Trazabilidad

- **Módulo:** Notificaciones
- **Épica:** Gestión de Preferencias
- **Requisito Funcional:** RF-063 (Configurar preferencias)
- **Requisito No Funcional:** RNF-COMP-001 (Compliance GDPR Art. 7)
- **Prioridad:** SHOULD HAVE (Release 1.1)

## 📊 Estimación

- **Story Points:** 3
- **Esfuerzo Estimado:** 1-2 días
- **Complejidad:** Baja (CRUD de preferencias en BD)

## 🔄 Dependencias

- **Depende de:** HU-050, HU-051, HU-052 (tipos de notificaciones existentes)
- **Bloquea a:** HU-054 (Respetar preferencias al enviar notificaciones)
- **Relacionada con:** HU-074 (Desactivar cuenta - efecto en notificaciones)

## 🧪 Notas de Testing

1. **Persistencia:** Cambiar preferencias, cerrar sesión, verificar que se mantienen
2. **Aplicación inmediata:** Desactivar email → reservar sesión → NO recibir email
3. **Modo No Molestar:** Verificar fechas de inicio y fin
4. **Validación:** No permitir desactivar TODOS los canales para notificaciones críticas
5. **Audit log:** Registrar cambios de preferencias con timestamp

## ⚠️ Riesgos y Supuestos

**Supuestos:** Tabla `user_notification_preferences` en PostgreSQL, relación 1:1 con users  
**Riesgos:** **Bajo** - Usuario desactiva todo y se queja de no recibir info

## ✔️ Definition of Done

- [ ] UI de preferencias implementada
- [ ] CRUD de preferencias en backend
- [ ] Modo No Molestar funcional
- [ ] Validación de preferencias mínimas
- [ ] Tests de persistencia y aplicación
- [ ] Documentación de tabla de preferencias

## 📌 Etiquetas

`#modulo-notificaciones` `#release-1.1` `#prioridad-media` `#configuracion` `#gdpr` `#compliance`

---

**Última actualización:** 2025-11-08  
**Autor:** Product Owner Senior - ZNS v2.0
