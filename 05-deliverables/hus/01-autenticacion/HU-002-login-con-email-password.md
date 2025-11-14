# HU-002: Login con Email y Contraseña

## 📋 Historia de Usuario

**Como** usuario registrado (estudiante, tutor o admin),  
**Quiero** iniciar sesión con mi email y contraseña,  
**Para** acceder a mi cuenta y utilizar las funcionalidades de la plataforma según mi rol.

## 🎯 Valor de Negocio

- **Retención:** Acceso rápido aumenta frecuencia de uso
- **Seguridad:** Autenticación segura protege datos de usuarios
- **Experiencia:** Login simple en < 1 segundo mejora UX

## 📝 Descripción Detallada

Usuario ingresa email y contraseña en formulario de login. Sistema valida credenciales, genera token JWT y redirige según rol: estudiante → `/dashboard`, tutor → `/dashboard/tutor`, admin → `/dashboard/admin`.

**Estado actual:** ✅ UI implementada | ❌ Backend JWT pendiente

## ✅ Criterios de Aceptación

### Escenario 1: Login exitoso

**Dado que** soy un usuario registrado con credenciales válidas  
**Cuando** ingreso mi email y contraseña correctos  
**Y** hago clic en "Iniciar sesión"  
**Entonces** el sistema valida mis credenciales  
**Y** genera un token JWT válido por 24h  
**Y** me redirige a mi dashboard según mi rol  
**Y** veo mi nombre y foto de perfil en la barra superior

### Escenario 2: Credenciales incorrectas

**Dado que** ingreso un email válido pero contraseña incorrecta  
**Cuando** hago clic en "Iniciar sesión"  
**Entonces** veo el mensaje "Email o contraseña incorrectos"  
**Y** el sistema NO revela si el email existe o no (seguridad)  
**Y** permanezco en la página de login  
**Y** después de 5 intentos fallidos, se bloquea la cuenta por 15 minutos

### Escenario 3: Cuenta no verificada

**Dado que** mi cuenta existe pero no he verificado mi email  
**Cuando** intento hacer login  
**Entonces** veo el mensaje "Por favor verifica tu email antes de iniciar sesión"  
**Y** veo un botón "Reenviar email de verificación"

### Escenario 4: Recordar sesión

**Dado que** marco la opción "Recordarme"  
**Cuando** hago login exitoso  
**Entonces** el sistema genera un refresh token válido por 7 días  
**Y** en mi próxima visita, estoy automáticamente logueado  
**Y** no necesito ingresar credenciales nuevamente

### Escenario 5: Mostrar/ocultar contraseña

**Dado que** estoy ingresando mi contraseña  
**Cuando** hago clic en el ícono del ojo  
**Entonces** la contraseña se muestra en texto plano  
**Cuando** vuelvo a hacer clic  
**Entonces** la contraseña se oculta nuevamente

## 🔗 Trazabilidad

- **Módulo:** Autenticación
- **Épica:** Autenticación y Autorización
- **Requisito Funcional:** [RF-002] Login con Email/Password
- **Requisito No Funcional:** [RNF-SEC-001] JWT, [RNF-PERF-002] Response <1s
- **Prioridad:** MUST HAVE

## 📊 Estimación

- **Story Points:** 3
- **Esfuerzo Estimado:** 2-3 días
- **Complejidad:** Baja

## 🔄 Dependencias

- **Depende de:** [HU-001] Registro de estudiante
- **Bloquea a:** Todas las features protegidas
- **Relacionada con:** [HU-003] Recuperar contraseña, [HU-006] OAuth

## ✔️ Definition of Done

- [ ] API POST /api/auth/login implementada
- [ ] JWT generado con expiración 24h
- [ ] Refresh token (opcional)
- [ ] Tests unitarios >80% cobertura
- [ ] Tests E2E de flujo de login
- [ ] Rate limiting: max 5 intentos/15min
- [ ] Documentación API actualizada

## 📌 Etiquetas

`#autenticacion` `#mvp` `#must-have` `#seguridad` `#jwt`

---

**Última actualización:** 08/11/2025  
**Autor:** Product Owner - ZNS v2.0
