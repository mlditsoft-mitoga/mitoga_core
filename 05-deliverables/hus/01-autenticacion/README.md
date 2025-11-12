# Módulo: Autenticación

**Responsable:** Tech Lead Backend  
**Story Points Totales:** 42 SP  
**Historias:** 8 HUs (3 generadas, 5 pendientes)

---

## 🎯 Objetivo del Módulo

Gestionar el ciclo completo de autenticación y autorización de usuarios (estudiantes, tutores, administradores) con seguridad robusta (JWT, OAuth, 2FA) y experiencia de usuario fluida (registros multi-step, recuperación de contraseña, verificación de email).

---

## 📋 Historias de Usuario

| ID | Título | Rol | Prioridad | SP | Estado |
|----|--------|-----|-----------|----|----|
| [HU-001](HU-001-registro-estudiante-multi-step.md) | Registro estudiante (4 steps + OTP + biométrico) | Estudiante | MUST | 13 | ✅ Generada |
| [HU-002](HU-002-login-con-email-password.md) | Login con email y contraseña | Usuario | MUST | 3 | ✅ Generada |
| [HU-003](HU-003-recuperar-contrasena-email.md) | Recuperar contraseña con email | Usuario | MUST | 5 | ✅ Generada |
| HU-004 | Verificar email con código OTP | Usuario | MUST | 5 | ⏸️ Pendiente |
| [HU-005](HU-005-registro-tutor-multi-step.md) | Registro tutor (4 steps: experiencia + conocimientos) | Tutor | MUST | 13 | ✅ Generada |
| HU-006 | Login social (Google OAuth) | Usuario | SHOULD | 8 | ⏸️ Pendiente |
| HU-007 | Autenticación 2FA con app | Usuario | COULD | 13 | ⏸️ Pendiente |
| HU-008 | Cerrar sesión y logout | Usuario | MUST | 2 | ⏸️ Pendiente |

**Total:** 42 SP  
**Generadas:** 34 SP (4 HUs)  
**Pendientes:** 28 SP (4 HUs)

---

## 🔗 Dependencias

**Servicios externos:**
- SendGrid/AWS SES (envío de emails OTP, recuperación)
- Firebase Auth o Auth0 (OAuth social login)
- Twilio Authy (2FA opcional)

**RNF críticos:**
- RNF-SEC-001: Encriptación bcrypt/argon2 para contraseñas
- RNF-SEC-002: JWT con refresh tokens, expiración 24h
- RNF-PERF-002: Response time < 1s para login
- RNF-SEC-003: Rate limiting (5 intentos/15min)

---

## 🧪 Testing

- **Cobertura esperada:** >90% (módulo crítico de seguridad)
- **Tests E2E:** Cypress - flujos completos de registro y login
- **Penetration testing:** OWASP Top 10 validado
- **Load testing:** 500 logins concurrentes sin degradación

---

## 📊 Métricas

| Métrica | Objetivo |
|---------|----------|
| Tasa de completitud registro | > 60% |
| Tiempo promedio registro | < 8 minutos |
| Tasa de abandono step 2 | < 20% |
| Login exitoso (primer intento) | > 95% |
| Recuperación contraseña exitosa | > 90% |

---

**Última actualización:** 08/11/2025  
**Estado:** 4/8 HUs generadas (50%)
