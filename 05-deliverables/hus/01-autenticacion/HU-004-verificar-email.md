# HU-004: Verificar email tras registro

**Épica:** Autenticación  
**Rol:** Usuario nuevo (estudiante/tutor)  
**Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia de Usuario

> **Como** usuario que completó el registro,  
> **quiero** recibir un código OTP por email y validarlo en pantalla,  
> **para** confirmar que mi correo es válido y activar mi cuenta.

---

## 💼 Valor de Negocio

- **Prevención de spam:** Reduce cuentas fake ~80% (validación email real)
- **Seguridad:** Evita suplantación de identidad (confirma ownership del email)
- **Base de datos limpia:** Emails válidos para notificaciones futuras (tasa entrega >95%)

**ROI:** Ahorro ~40h/mes soporte técnico (gestión cuentas inválidas)

---

## 📄 Descripción

Después de completar el formulario de registro (HU-001 o HU-005), el sistema envía un código OTP de 6 dígitos al email proporcionado. El usuario debe:
1. Revisar su bandeja de entrada (y carpeta spam)
2. Copiar el código OTP
3. Ingresarlo en la pantalla de verificación antes de 10 minutos
4. Si expira, puede solicitar reenvío (máximo 3 intentos/hora)

Una vez verificado, el usuario puede hacer login y acceder a la plataforma.

**Estado actual backend:** ⚠️ Parcial  
- Email service mock implementado (envío simulado)
- Falta integración real con SendGrid/AWS SES
- Falta lógica de expiración y rate limiting OTP

---

## ✅ Criterios de Aceptación

### **Escenario 1: Verificación exitosa con código OTP válido**
```gherkin
Given el usuario "juan@email.com" completó el registro
  And recibió un email con código OTP "123456"
When ingresa el código "123456" en la pantalla de verificación
  And hace clic en "Verificar"
Then el sistema valida el código contra la BD
  And marca el email como verificado (email_verified=true)
  And muestra mensaje "¡Cuenta activada! Inicia sesión"
  And redirige a "/login" después de 2 segundos
```

### **Escenario 2: Código OTP incorrecto**
```gherkin
Given el usuario recibió el código OTP "123456"
When ingresa un código incorrecto "999999"
  And hace clic en "Verificar"
Then el sistema muestra error "Código inválido. Intentos restantes: 4/5"
  And mantiene el formulario visible para reintentar
  And NO consume el código OTP válido

When ingresa 5 códigos incorrectos consecutivos
Then el sistema bloquea verificación por 15 minutos
  And muestra "Demasiados intentos. Solicita un nuevo código"
```

### **Escenario 3: Código OTP expirado**
```gherkin
Given el código OTP "123456" fue generado hace 11 minutos
When el usuario ingresa "123456"
  And hace clic en "Verificar"
Then el sistema valida expiración (TTL 10 minutos)
  And muestra error "Código expirado. Solicita uno nuevo"
  And habilita botón "Reenviar código"
```

### **Escenario 4: Reenviar código OTP**
```gherkin
Given el usuario está en la pantalla de verificación
When hace clic en "Reenviar código"
Then el sistema invalida el código OTP anterior
  And genera un nuevo código OTP aleatorio de 6 dígitos
  And envía email con el nuevo código
  And muestra toast "Código enviado. Revisa tu bandeja"
  And inicia temporizador de 60 segundos antes de permitir otro reenvío

When hace clic en "Reenviar código" 4 veces en 10 minutos
Then el sistema aplica rate limiting
  And muestra "Límite de reenvíos alcanzado. Espera 30 minutos"
```

### **Escenario 5: Acceso directo sin verificar email**
```gherkin
Given el usuario "maria@email.com" completó registro
  But NO verificó su email (email_verified=false)
When intenta hacer login con credenciales correctas
Then el sistema valida estado de verificación
  And muestra modal "Debes verificar tu email primero"
  And ofrece botón "Reenviar código de verificación"
  And NO permite acceso a la plataforma
```

---

## 🔗 Trazabilidad

**Requisitos funcionales:**
- RF-001 (Registro de estudiante) → incluye verificación email
- RF-005 (Registro de tutor) → requiere email verificado para aprobación

**Requisitos no funcionales:**
- RNF-SEC-002: OTP debe ser aleatorio criptográficamente seguro
- RNF-SEC-003: Rate limiting (3 reenvíos/10min, 5 intentos validación/15min)
- RNF-USAB-001: Mensaje claro sobre carpeta spam + tiempo expiración visible

---

## 📏 Estimación

**Story Points:** 5 SP  
**Complejidad:** Media

**Desglose:**
- Backend API (generación OTP, validación, expiración): 3 SP
- Integración email service (SendGrid): 1 SP
- Frontend (pantalla verificación, temporizador): 1 SP

---

## 🧩 Dependencias

**Depende de:**
- HU-001 (Registro estudiante) y HU-005 (Registro tutor) → flujo previo
- Email service configurado (SendGrid/AWS SES)

**Bloquea a:**
- HU-002 (Login) → requiere email verificado para permitir acceso

**Relacionada con:**
- HU-003 (Recuperar contraseña) → comparte servicio de envío de emails

---

## ✔️ Definition of Done (DoD)

- [ ] Endpoint `POST /api/auth/verify-email` implementado con validación OTP
- [ ] Endpoint `POST /api/auth/resend-verification-code` con rate limiting
- [ ] Generación OTP criptográficamente seguro (crypto.randomInt())
- [ ] TTL de 10 minutos para código OTP (stored en Redis o columna expires_at)
- [ ] Integración real con SendGrid (template HTML personalizado)
- [ ] Rate limiting: 5 intentos validación/15min, 3 reenvíos/10min
- [ ] Pantalla frontend `/verify-email` con temporizador countdown
- [ ] Tests unitarios: generación OTP, validación, expiración (>85% cobertura)
- [ ] Test E2E: flujo completo registro → verificación → login (Cypress)
- [ ] Manejo de carpeta spam en email template (texto "revisa spam")
- [ ] Accesibilidad WCAG 2.1 AA (inputs con labels, errores descriptivos)
- [ ] Logs de auditoría: intentos fallidos, reenvíos, verificaciones exitosas

---

## 🏷️ Etiquetas

`#modulo-autenticacion` `#mvp` `#must-have` `#backend` `#frontend` `#seguridad` `#email-verification` `#otp` `#sendgrid` `#rate-limiting`

---

## 🧪 Notas de Testing

**Casos edge:**
- Email nunca llega (problema SMTP) → mostrar opción "Cambiar email"
- Usuario cierra navegador y vuelve → código OTP sigue válido si no expiró
- Múltiples ventanas abiertas → cualquier verificación invalida código en todas
- Cambio de email antes de verificar → invalidar código anterior

**Recomendación:** Mock del email service en tests para evitar envíos reales (usar MailHog o similar en staging)
