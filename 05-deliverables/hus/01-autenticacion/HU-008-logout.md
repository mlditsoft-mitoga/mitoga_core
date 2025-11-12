# HU-008: Cerrar sesión (Logout)

**Épica:** Autenticación  
**Rol:** Usuario autenticado (estudiante/tutor/admin)  
**Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia de Usuario

> **Como** usuario autenticado,  
> **quiero** poder cerrar sesión de forma segura,  
> **para** proteger mi cuenta en dispositivos compartidos.

---

## 💼 Valor de Negocio

- **Seguridad:** Previene acceso no autorizado en PCs públicos/compartidos
- **Compliance GDPR:** Requisito obligatorio para control de sesión del usuario
- **Multi-dispositivo:** Permite logout selectivo (dispositivo actual) o total (todos)

**ROI:** Reduce ~15% de tickets de soporte relacionados con "alguien más accedió a mi cuenta"

---

## 📄 Descripción

El usuario encuentra la opción "Cerrar sesión" en:
- Menú desplegable de avatar (header)
- Configuración de cuenta (`/settings`)

Al hacer clic:
1. Sistema invalida JWT actual (blacklist en Redis si aplica)
2. Elimina tokens de localStorage/cookies
3. Redirige a página de login (`/login`)
4. Opcional: Logout de todos los dispositivos si usuario lo solicita

**Estado actual backend:** ⚠️ Parcial  
- Frontend tiene botón "Cerrar sesión" mock
- Falta endpoint backend para invalidar refresh tokens
- No hay blacklist de JWT implementada

---

## ✅ Criterios de Aceptación

### **Escenario 1: Logout exitoso desde dispositivo actual**
```gherkin
Given el usuario está autenticado con JWT válido
When hace clic en "Cerrar sesión" en el menú de avatar
Then el sistema:
  | Acción                              | Resultado                           |
  | Elimina access_token de localStorage | Token borrado (vacío)               |
  | Elimina refresh_token de cookies    | Cookie expirada (HttpOnly cleared)  |
  | Agrega JWT a blacklist (Redis)      | TTL = tiempo restante de expiración |
  | Redirige a /login                   | Con query param ?logged_out=true    |
  
  And muestra toast "Sesión cerrada. ¡Hasta pronto!"
  And el header cambia a estado "no autenticado" (botones Login/Registro)
```

### **Escenario 2: Logout de todos los dispositivos**
```gherkin
Given el usuario tiene sesiones activas en:
  | Dispositivo     | Ubicación | Última actividad |
  | Chrome Windows  | Bogotá    | Hace 5 minutos   |
  | Safari iPhone   | Medellín  | Hace 2 horas     |
  | Edge Tablet     | Cali      | Hace 1 día       |

When accede a /settings/sesiones
  And hace clic en "Cerrar todas las sesiones"
Then el sistema:
  - Invalida TODOS los refresh tokens del usuario en BD
  - Agrega todos los JWTs activos a blacklist (Redis)
  - Envía email de seguridad: "Cerraste sesión en todos tus dispositivos"
  
When intenta acceder desde Safari iPhone con JWT antiguo
Then recibe error 401 Unauthorized "Sesión expirada. Inicia sesión nuevamente"
```

### **Escenario 3: Token ya expirado (logout silencioso)**
```gherkin
Given el usuario tiene un JWT expirado hace 3 días (no usó la plataforma)
When hace clic en "Cerrar sesión"
Then el sistema:
  - Detecta JWT expirado (no es necesario blacklist)
  - Limpia localStorage y cookies igualmente
  - Redirige a /login con mensaje "Sesión cerrada"
  - NO registra error (comportamiento esperado)
```

### **Escenario 4: Navegación después de logout**
```gherkin
Given el usuario cerró sesión correctamente
When intenta acceder manualmente a /dashboard-estudiante
Then el sistema:
  - Detecta ausencia de JWT en localStorage
  - Redirige a /login con query param ?redirect=/dashboard-estudiante
  - Muestra mensaje "Debes iniciar sesión para continuar"

When hace login nuevamente
Then es redirigido automáticamente a /dashboard-estudiante (URL original)
```

---

## 🔗 Trazabilidad

**Requisitos funcionales:**
- RF-002 (Login) → logout es contraparte natural del login
- RF-004 (Gestión de sesiones) → control de sesiones activas

**Requisitos no funcionales:**
- RNF-SEC-002: Invalidar refresh tokens en BD al hacer logout
- RNF-SEC-005: Blacklist de JWT con TTL automático (Redis)
- RNF-USAB-002: Confirmación de logout solo si sesiones sensibles abiertas

---

## 📏 Estimación

**Story Points:** 2 SP  
**Complejidad:** Baja

**Desglose:**
- Backend endpoint `POST /api/auth/logout`: 1 SP
- Frontend limpiar tokens + redirect: 0.5 SP
- Blacklist JWT en Redis (opcional): 0.5 SP

---

## 🧩 Dependencias

**Depende de:**
- HU-002 (Login) → requiere JWT existente para cerrar sesión

**Bloquea a:**
- (Ninguna dependencia crítica)

**Relacionada con:**
- HU-007 (2FA) → si 2FA activo, logout también debe invalidar códigos temporales

---

## ✔️ Definition of Done (DoD)

- [ ] Endpoint `POST /api/auth/logout` implementado
- [ ] Endpoint `POST /api/auth/logout-all` para logout multi-dispositivo
- [ ] Refresh tokens invalidados en BD (columna `is_active = false`)
- [ ] Blacklist de JWT en Redis (key: `jwt:blacklist:{token_id}`, TTL automático)
- [ ] Frontend limpia localStorage (`access_token`, `user_data`)
- [ ] Frontend limpia cookies HttpOnly (`refresh_token`)
- [ ] Redirect a `/login` con query param `?logged_out=true`
- [ ] Email de seguridad si logout de todos los dispositivos
- [ ] Tests unitarios: invalidación tokens, blacklist (>90% cobertura)
- [ ] Test E2E: logout → intento acceso protegido → redirect a login (Cypress)
- [ ] Logs de auditoría: registrar logout (user_id, timestamp, IP, dispositivo)

---

## 🏷️ Etiquetas

`#modulo-autenticacion` `#mvp` `#must-have` `#backend` `#frontend` `#seguridad` `#jwt` `#session-management` `#redis-blacklist`

---

## 🧪 Notas de Testing

**Casos edge:**
- Usuario hace logout mientras tiene request en curso (ej: subiendo archivo) → abortar request
- Múltiples tabs abiertas → logout en una debe afectar todas (usar BroadcastChannel API)
- Usuario borra cookies manualmente → logout frontend igual (defensive coding)
- Logout automático por inactividad (30 min) → mostrar modal "Sesión expirada por inactividad"

**Recomendación:** Implementar heartbeat/ping cada 5 min para detectar sesión activa vs inactiva

---

## ⚠️ Riesgos y Supuestos

**Riesgos:**
- Blacklist de JWT crece indefinidamente → usar TTL automático igual a expiración JWT
- Usuario olvida hacer logout en PC público → implementar logout automático por inactividad (HU futura)

**Supuestos:**
- Redis está disponible para blacklist (fallback: validar contra BD si Redis falla)
- Logout no requiere confirmación (flujo rápido), salvo en /settings/sesiones

---

## ❓ Preguntas Abiertas

1. ¿Mostrar confirmación "¿Seguro que quieres cerrar sesión?" → NO (fricción innecesaria), salvo si hay cambios sin guardar
2. ¿Logout automático después de X minutos de inactividad? → Fase 2 (30 min ideal para plataforma educativa)
3. ¿Mantener historial de sesiones (última vez activo)? → Sí, útil para /settings/sesiones
