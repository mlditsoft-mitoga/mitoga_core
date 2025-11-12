# HU-001: Registro de Estudiante con Proceso Multi-Step

## 📋 Historia de Usuario

**Como** estudiante nuevo,  
**Quiero** completar un proceso de registro guiado en 4 pasos con verificación de identidad,  
**Para** crear una cuenta verificada en la plataforma y poder buscar tutores de forma segura.

## 🎯 Valor de Negocio

- **Impacto en conversión:** Proceso guiado reduce abandono en ~30% vs formulario largo
- **Reducción de fraude:** Verificación biométrica + documentos reduce cuentas falsas
- **Cumplimiento legal:** Manejo de menores de 18 años según normativa colombiana (datos de responsable)
- **Confianza:** Verificación robusta aumenta credibilidad de la plataforma

**Métricas clave:**
- Tasa de completitud del registro: > 60%
- Tiempo promedio de registro: 5-8 minutos
- Cuentas verificadas exitosamente: > 95%

## 📝 Descripción Detallada

El estudiante completa un proceso de registro en **4 pasos** (wizard):

1. **Step 1 - Credenciales:** Email + contraseña fuerte + confirmación + verificación OTP (6 dígitos) por email
2. **Step 2 - Información Personal:** Datos básicos (nombres, apellidos, género, fecha nacimiento), contacto (teléfono, país, ciudad), nivel educativo, aceptación de términos. **Si es menor de 18 años**, el sistema detecta automáticamente y solicita datos del responsable legal (nombre, email, teléfono)
3. **Step 3 - Verificación Biométrica:** Captura de foto de perfil, documento de identidad (frontal + trasero), selfie en tiempo real. **Si es menor**, también captura documentos del responsable
4. **Step 4 - Confirmación:** Resumen de todos los datos ingresados + botón "Completar registro"

El sistema incluye:
- Progress bar visual (% completado)
- Validación por step (no puede avanzar con errores)
- Capitalización automática de nombres
- Cálculo de edad para detectar menores automáticamente
- Captura de fotos con cámara web o upload
- Validación de formato dd/mm/yyyy para fechas

**Estado actual:** ✅ UI completa (2087 líneas de código) | ❌ Backend pendiente

## ✅ Criterios de Aceptación

### Escenario 1: Registro exitoso de estudiante mayor de edad

**Dado que** soy un estudiante nuevo mayor de 18 años  
**Cuando** completo los 4 steps del registro con datos válidos  
**Y** verifico mi email con el código OTP  
**Y** subo mis documentos y fotos  
**Entonces** el sistema crea mi cuenta con estado "Verificación pendiente"  
**Y** recibo un email de bienvenida  
**Y** puedo acceder al dashboard de estudiante  
**Y** el sistema NO me solicita datos de responsable legal

### Escenario 2: Registro de estudiante menor de 18 años

**Dado que** soy un estudiante nuevo con fecha de nacimiento que indica < 18 años  
**Cuando** ingreso mi fecha de nacimiento en el Step 2  
**Entonces** el sistema detecta automáticamente que soy menor  
**Y** me solicita datos del responsable legal (nombre, apellido, email, teléfono)  
**Y** en el Step 3 me solicita documentos del responsable (frontal + trasero)  
**Y** el sistema valida que todos los campos de responsable están completos antes de continuar

### Escenario 3: Validación de contraseña fuerte

**Dado que** estoy en el Step 1 ingresando mis credenciales  
**Cuando** ingreso una contraseña que NO cumple con los requisitos (mínimo 8 caracteres, mayúsculas, minúsculas, números)  
**Entonces** veo un mensaje de error "La contraseña debe tener al menos 8 caracteres, mayúsculas, minúsculas y números"  
**Y** el botón "Siguiente" permanece deshabilitado hasta que corrija la contraseña

### Escenario 4: Verificación OTP por email

**Dado que** he ingresado email y contraseña válidos en el Step 1  
**Cuando** hago clic en "Verificar email"  
**Entonces** el sistema genera un código OTP de 6 dígitos  
**Y** me muestra un modal para ingresar el código  
**Y** envía el código a mi email  
**Y** tengo 5 intentos para ingresar el código correcto  
**Y** el código expira en 10 minutos  
**Cuando** ingreso el código correcto  
**Entonces** el modal se cierra y puedo avanzar al Step 2

### Escenario 5: Capitalización automática de nombres

**Dado que** estoy ingresando mis nombres en el Step 2  
**Cuando** escribo "juan pablo" en el campo "Primer nombre"  
**Entonces** el sistema capitaliza automáticamente a "Juan Pablo"  
**Y** lo mismo aplica para todos los campos de nombre (primer nombre, segundo nombre, apellidos, nombre del responsable)

### Escenario 6: Captura de foto con cámara

**Dado que** estoy en el Step 3 en la sección de verificación biométrica  
**Cuando** hago clic en "Capturar foto de perfil"  
**Entonces** se abre un modal con acceso a mi cámara web  
**Y** veo un preview en tiempo real de la cámara  
**Cuando** hago clic en "Tomar foto"  
**Entonces** se captura la imagen  
**Y** veo un preview de la foto capturada  
**Y** puedo "Retomar" o "Aceptar"  
**Cuando** acepto  
**Entonces** la foto se guarda y veo un thumbnail en el formulario

### Escenario 7: Validación de campos obligatorios por step

**Dado que** estoy en cualquier step del registro  
**Cuando** intento avanzar al siguiente step sin completar campos obligatorios marcados con *  
**Entonces** veo mensajes de error específicos debajo de cada campo incompleto  
**Y** el botón "Siguiente" no avanza al siguiente step  
**Y** los mensajes de error desaparecen cuando corrijo los campos

### Escenario 8: Navegación entre steps

**Dado que** estoy en el Step 3  
**Cuando** hago clic en el botón "Anterior"  
**Entonces** regreso al Step 2  
**Y** conservo todos los datos que había ingresado previamente  
**Y** puedo editar cualquier campo  
**Cuando** hago clic en "Siguiente" nuevamente  
**Entonces** avanzo al Step 3 con los datos actualizados

### Escenario 9: Error en envío de OTP

**Dado que** he ingresado mi email y solicité el código OTP  
**Cuando** el servicio de envío de emails falla  
**Entonces** veo el mensaje "No pudimos enviar el código. Intenta nuevamente."  
**Y** puedo hacer clic en "Reenviar código"  
**Y** el sistema reinicia el contador de intentos

## 🔗 Trazabilidad

- **Módulo:** Autenticación
- **Épica:** Onboarding de Estudiante
- **Requisito Funcional:** [RF-001] Registro de Estudiante (Multi-Step)
- **Requisito No Funcional:** [RNF-SEC-001] Encriptación de contraseñas, [RNF-USAB-001] Accesibilidad WCAG 2.1
- **Prioridad:** MUST HAVE (MVP crítico)

## 📊 Estimación

- **Story Points:** 13 (Alto - Complejidad por 4 steps, validaciones, OTP, biométrico, menores)
- **Esfuerzo Estimado:** 8-10 días (frontend + backend + testing)
- **Complejidad:** Alta

## 🔄 Dependencias

- **Depende de:** Ninguna (es el entry point del usuario)
- **Bloquea a:** [HU-002] Login, [HU-010] Buscar tutores, todas las features de estudiante
- **Relacionada con:** [HU-005] Registro de tutor (mismo flujo pero diferente)

## 🧪 Notas de Testing

**Casos de prueba clave:**
1. Registro completo de mayor de edad (happy path)
2. Registro de menor de 18 años (validar campos de responsable)
3. Validación de contraseña débil (debe bloquear)
4. Verificación OTP (código correcto, código incorrecto, código expirado, 5 intentos fallidos)
5. Upload y captura de fotos (ambos métodos)
6. Validación de fecha futura (debe rechazar)
7. Navegación hacia atrás y adelante (persistencia de datos)
8. Abandono en step 2 y regreso (¿se recuperan datos?)

**Datos de prueba requeridos:**
- Usuarios menores de 18: Fecha nacimiento 2010-2008
- Usuarios mayores: Fecha nacimiento 1990-2005
- Emails válidos para OTP testing
- Imágenes de prueba para documentos (JPG, PNG)

**Consideraciones de automatización:**
- E2E con Cypress: Flujo completo de registro
- Unitarias: Validaciones de formulario (contraseña, email, fecha)
- Integración: API de envío de OTP, upload de imágenes

## 🎨 Notas de Diseño

**Implementación actual:**
- Componente: `components/auth/StudentRegistration.tsx` (2087 líneas)
- Sub-componentes: `CameraModal.tsx`, `PDFViewerModal.tsx`, `PhoneInput.tsx`, `DatePicker.tsx`
- Estado: React hooks (useState para steps y form data)
- Validación: Client-side con mensajes específicos por campo

**Pendiente:**
- Integración con backend (API REST)
- Envío real de OTP por email (SendGrid/AWS SES)
- Verificación biométrica con face-api en backend
- Persistencia en PostgreSQL/MongoDB
- Generación de JWT token tras registro exitoso

## ⚠️ Riesgos y Supuestos

**Supuestos:**
- El servicio de envío de emails (SendGrid/AWS SES) tiene > 99% uptime
- Los usuarios tienen cámara web o pueden subir fotos desde archivo
- La verificación de documentos será manual por admin en MVP (no OCR automático)
- Face-API puede ejecutarse en backend sin impactar performance

**Riesgos:**
- Abandono por proceso largo (mitigación: progress bar y guardado parcial)
- Emails de OTP caen en spam (mitigación: configurar SPF/DKIM)
- Problemas de acceso a cámara en algunos navegadores (mitigación: fallback a upload)
- Menores intentan registrarse sin responsable (mitigación: validación estricta + educación)

**Preguntas abiertas:**
- ¿El responsable debe confirmar por email antes de activar la cuenta del menor?
- ¿Qué sucede si un estudiante cumple 18 durante el uso de la plataforma?
- ¿Cuánto tiempo es válida la verificación de documentos (debe renovarse anualmente)?

## ✔️ Definition of Done (DoD)

- [ ] Código desarrollado y code review aprobado
- [ ] Tests unitarios escritos y pasando (>80% cobertura)
- [ ] Tests E2E de flujo completo con Cypress
- [ ] Criterios de aceptación validados por PO (todos los 9 escenarios)
- [ ] API REST de registro implementada y documentada
- [ ] Servicio de envío de OTP configurado y testeado
- [ ] Upload de imágenes a S3/Cloud Storage funcional
- [ ] Validación de documentos por admin implementada (HU-060)
- [ ] Documentación técnica actualizada (README, API docs)
- [ ] Sin errores críticos o de seguridad (ESLint, SAST)
- [ ] Desplegado en ambiente de staging
- [ ] Demo realizada con stakeholders
- [ ] Cumple WCAG 2.1 AA (navegación por teclado, labels ARIA)
- [ ] Performance: Registro completo en < 8 minutos (RNF-USAB-003)

## 📌 Etiquetas (Tags)

`#modulo-autenticacion` `#mvp` `#must-have` `#frontend` `#backend` `#seguridad` `#onboarding` `#menores` `#biometrico` `#otp`

---

**Última actualización:** 08/11/2025  
**Autor:** Product Owner - CEIBA v1.2  
**Revisores:** Equipo de desarrollo, UX, QA, Legal (cumplimiento normativa menores)
