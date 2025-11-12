# HU-003: Recuperar Contraseña con Email

## 📋 Historia de Usuario

**Como** usuario que olvidó su contraseña,  
**Quiero** solicitar un enlace de recuperación por email,  
**Para** restablecer mi contraseña y recuperar el acceso a mi cuenta.

## 🎯 Valor de Negocio

- **Reducción de soporte:** 70% de tickets de soporte son por contraseñas olvidadas
- **Retención:** Usuarios pueden recuperar acceso sin crear nueva cuenta
- **Seguridad:** Proceso seguro con token temporal

## 📝 Descripción Detallada

Usuario ingresa su email, sistema envía enlace con token único válido por 1 hora. Usuario hace clic en enlace, ingresa nueva contraseña (2 veces), sistema valida y actualiza contraseña encriptada.

## ✅ Criterios de Aceptación

### Escenario 1: Solicitud de recuperación exitosa

**Dado que** olvidé mi contraseña  
**Cuando** ingreso mi email en "¿Olvidaste tu contraseña?"  
**Y** hago clic en "Enviar enlace"  
**Entonces** recibo un email con enlace de recuperación  
**Y** el enlace contiene un token único válido por 1 hora  
**Y** veo el mensaje "Revisa tu email para restablecer tu contraseña"

### Escenario 2: Email no registrado

**Dado que** ingreso un email que NO existe en el sistema  
**Cuando** solicito recuperación  
**Entonces** veo el mensaje genérico "Si el email existe, recibirás un enlace"  
**Y** el sistema NO revela si el email está registrado o no (seguridad anti-enumeración)

### Escenario 3: Cambio de contraseña exitoso

**Dado que** he recibido el email y hago clic en el enlace  
**Cuando** ingreso nueva contraseña (cumple requisitos) y confirmación  
**Y** hago clic en "Cambiar contraseña"  
**Entonces** el sistema actualiza mi contraseña encriptada  
**Y** invalida el token usado  
**Y** me redirige al login con mensaje "Contraseña actualizada exitosamente"  
**Y** puedo hacer login con la nueva contraseña

### Escenario 4: Token expirado

**Dado que** el enlace de recuperación tiene más de 1 hora  
**Cuando** intento usarlo  
**Entonces** veo el mensaje "Este enlace ha expirado. Solicita uno nuevo"  
**Y** puedo hacer clic en "Solicitar nuevo enlace"

### Escenario 5: Token ya usado

**Dado que** ya usé el token para cambiar mi contraseña  
**Cuando** intento usar el mismo enlace nuevamente  
**Entonces** veo el mensaje "Este enlace ya fue utilizado"  
**Y** puedo solicitar un nuevo enlace si es necesario

## 🔗 Trazabilidad

- **Módulo:** Autenticación
- **Requisito Funcional:** [RF-003] Recuperación de Contraseña
- **Requisito No Funcional:** [RNF-SEC-002] Tokens temporales
- **Prioridad:** MUST HAVE

## 📊 Estimación

- **Story Points:** 5
- **Complejidad:** Media

## 🔄 Dependencias

- **Depende de:** [HU-001] Registro, servicio de email
- **Relacionada con:** [HU-002] Login

## ✔️ Definition of Done

- [ ] API POST /api/auth/forgot-password
- [ ] API POST /api/auth/reset-password
- [ ] Email template de recuperación
- [ ] Tokens con expiración 1h
- [ ] Tests E2E del flujo completo

## 📌 Etiquetas

`#autenticacion` `#mvp` `#must-have` `#seguridad` `#email`

---

**Última actualización:** 08/11/2025
