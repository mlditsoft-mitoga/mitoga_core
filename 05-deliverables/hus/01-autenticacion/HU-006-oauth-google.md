# HU-006: Login con OAuth (Google)

**Épica:** Autenticación  
**Rol:** Usuario nuevo o existente  
**Prioridad:** SHOULD HAVE (Post-MVP)

---

## 📖 Historia de Usuario

> **Como** usuario (estudiante o tutor),  
> **quiero** iniciar sesión con mi cuenta de Google,  
> **para** evitar crear una contraseña nueva y acceder rápidamente.

---

## 💼 Valor de Negocio

- **Reducción de fricción:** Aumenta tasa de conversión registro ~25% (menos pasos)
- **Seguridad delegada:** Google gestiona autenticación 2FA/MFA (menos riesgo para plataforma)
- **Onboarding rápido:** Login en 1 clic vs formulario multi-step tradicional
- **Datos verificados:** Email pre-verificado por Google (skip HU-004)

**ROI:** Reduce abandono en pantalla de registro ~30% (benchmark Baymard Institute)

---

## 📄 Descripción

El usuario ve un botón "Continuar con Google" en las pantallas de login y registro. Al hacer clic:
1. Se abre popup OAuth de Google
2. Usuario autoriza MI-TOGA acceder a email, nombre, foto
3. Sistema recibe token de Google y valida firma
4. Si email existe → login directo (genera JWT)
5. Si email NO existe → crea cuenta automáticamente con datos de Google (rol default: estudiante)
6. Redirige a dashboard según rol

**Estado actual backend:** ❌ No implementado  
- Requiere configuración OAuth en Google Cloud Console
- Necesita endpoints callback para manejar redirect

---

## ✅ Criterios de Aceptación

### **Escenario 1: Login exitoso con Google (cuenta existente)**
```gherkin
Given el usuario "carlos@gmail.com" tiene cuenta en MI-TOGA
  And su cuenta fue creada originalmente con email/password
When hace clic en "Continuar con Google" en /login
  And autoriza MI-TOGA en el popup OAuth de Google
Then el sistema recibe el token de Google (id_token)
  And extrae email "carlos@gmail.com" del token
  And busca usuario en BD por email
  And vincula cuenta Google (campo google_id poblado)
  And genera JWT con payload {userId, rol, email}
  And redirige a /dashboard-estudiante (o dashboard según rol)
```

### **Escenario 2: Registro automático con Google (cuenta nueva)**
```gherkin
Given el email "laura@gmail.com" NO existe en MI-TOGA
When hace clic en "Continuar con Google" en /register
  And autoriza MI-TOGA accediendo a: email, nombre, foto perfil
Then el sistema crea usuario nuevo con:
  | Campo            | Valor                        |
  | email            | laura@gmail.com              |
  | nombre           | Laura Martínez (de Google)   |
  | google_id        | 1234567890 (Google sub)      |
  | email_verified   | true (pre-verificado)        |
  | rol              | "estudiante" (default)       |
  | profile_picture  | URL foto de Google           |
  | password_hash    | NULL (no tiene contraseña)   |
  
  And genera JWT
  And redirige a /onboarding-estudiante (completar perfil)
  And envía email de bienvenida
```

### **Escenario 3: Error OAuth - Usuario cancela autorización**
```gherkin
Given el usuario hace clic en "Continuar con Google"
When cierra el popup OAuth sin autorizar
Then el sistema detecta callback error "access_denied"
  And muestra toast "Autorización cancelada. Intenta nuevamente"
  And mantiene al usuario en la pantalla de login
  And NO crea ninguna cuenta
```

### **Escenario 4: Cuenta vinculada - Cambiar entre email/password y Google**
```gherkin
Given el usuario "ana@gmail.com" se registró con email/password
  And posteriormente hizo login con Google (cuenta vinculada)
When en un futuro hace login con email/password tradicional
Then el sistema permite ambos métodos de autenticación
  And ambos generan el mismo JWT (mismo userId)

When intenta registrarse nuevamente con Google con el mismo email
Then el sistema detecta email duplicado
  And muestra "Esta cuenta ya existe. Inicia sesión"
```

### **Escenario 5: Token de Google inválido o expirado**
```gherkin
Given el usuario completa el flujo OAuth
When el sistema recibe un token corrupto/expirado
Then valida firma con Google Public Keys (JWKS endpoint)
  And detecta token inválido
  And muestra error "Error de autenticación. Intenta nuevamente"
  And registra error en logs de seguridad
  And NO crea cuenta ni sesión
```

---

## 🔗 Trazabilidad

**Requisitos funcionales:**
- RF-002 (Login de usuario) → alternativa OAuth como método adicional
- RF-001 (Registro) → OAuth como vía rápida de registro

**Requisitos no funcionales:**
- RNF-SEC-001: Validación token Google con Google OAuth2 Public Keys
- RNF-INT-001: Integración con API Google Sign-In (OAuth 2.0 client)
- RNF-USAB-003: Popup OAuth debe abrirse sin bloqueo (verificar pop-up blockers)

---

## 📏 Estimación

**Story Points:** 8 SP  
**Complejidad:** Alta (integración third-party)

**Desglose:**
- Configuración Google Cloud Console (OAuth client ID): 1 SP
- Backend endpoints (`POST /api/auth/google/callback`): 3 SP
- Lógica vinculación cuentas existentes: 2 SP
- Frontend botón + popup + manejo errores: 1 SP
- Testing OAuth flow (mock tokens): 1 SP

---

## 🧩 Dependencias

**Depende de:**
- HU-001 (Registro estudiante) y HU-005 (Registro tutor) → estructura DB usuarios
- Google Cloud Platform account configurado (credenciales OAuth)

**Bloquea a:**
- (Ninguna dependencia crítica, feature opcional post-MVP)

**Relacionada con:**
- HU-002 (Login tradicional) → misma pantalla, métodos alternativos
- HU-007 (2FA) → OAuth puede coexistir con 2FA adicional

---

## ✔️ Definition of Done (DoD)

- [ ] Google Cloud Console configurado con OAuth 2.0 Client ID
- [ ] Endpoints backend: `POST /api/auth/google/callback`
- [ ] Validación token Google con library `google-auth-library` (Node.js)
- [ ] Lógica creación automática cuenta si email NO existe
- [ ] Lógica vinculación si email existe (populate `google_id`)
- [ ] Frontend: botón "Continuar con Google" con logo oficial (Google Brand Guidelines)
- [ ] Popup OAuth configurado con scopes: `email`, `profile`, `openid`
- [ ] Manejo errores: token inválido, usuario cancela, email ya registrado
- [ ] Tests unitarios: validación token, creación/vinculación usuario (>80% cobertura)
- [ ] Test E2E: flujo completo OAuth mock (sin Google real) con Cypress
- [ ] Documentación interna: cómo regenerar credentials si expiran
- [ ] Compliance GDPR: mostrar qué datos se acceden desde Google en pantalla de consentimiento

---

## 🏷️ Etiquetas

`#modulo-autenticacion` `#post-mvp` `#should-have` `#backend` `#frontend` `#oauth` `#google-auth` `#integracion-third-party` `#onboarding-rapido`

---

## 🧪 Notas de Testing

**Casos edge:**
- Email de Google no es @gmail.com (puede ser @empresa.com con Workspace) → permitir
- Usuario tiene misma photo URL en Google → cachear para evitar recargas
- Google cambia estructura del token (breaking change) → monitorear deprecation notices
- Rate limiting de Google API → implementar retry con exponential backoff

**Recomendación:** Usar Google OAuth Playground para testing manual de tokens

---

## ⚠️ Riesgos y Supuestos

**Riesgos:**
- Google descontinúa OAuth 2.0 (migración forzada OAuth 2.1) → esfuerzo 5 SP
- Usuarios confunden "Continuar con Google" con compartir todo su perfil → clarificar en UI

**Supuestos:**
- 40% de usuarios preferirá OAuth vs email/password tradicional
- Google Email Verified flag es confiable (skip HU-004)

---

## ❓ Preguntas Abiertas

1. ¿Permitir OAuth Facebook/Apple también? → Validar con analytics (post-MVP)
2. ¿Solicitar scopes adicionales (Google Calendar para sincronizar sesiones)? → Fase 2
3. ¿Qué pasa si usuario borra cuenta de Google después? → Mantener cuenta MI-TOGA, convertir a email/password
