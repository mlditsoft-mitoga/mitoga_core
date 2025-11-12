# HU-062: Gestionar Usuarios (Buscar, Ver, Suspender)

## 📋 Historia de Usuario

**Como** administrador,  
**Quiero** buscar, ver detalles y gestionar cualquier usuario de la plataforma,  
**Para** resolver tickets de soporte y tomar acciones administrativas.

## 🎯 Valor de Negocio

Herramienta operacional esencial para soporte al cliente y moderación.

**Impacto:** Tiempo de resolución de tickets reducido 50%

## 📝 Descripción Detallada

Panel de búsqueda de usuarios por nombre, email, ID. Vista de detalle con: perfil completo, historial de sesiones, historial de pagos, reseñas recibidas/escritas. Acciones: Suspender cuenta (temporal o permanente), Reactivar, Resetear contraseña, Agregar notas internas. Log de auditoría de todas las acciones administrativas.

## ✅ Criterios de Aceptación

### Escenario 1: Buscar usuario por email

**Dado que** necesito encontrar al usuario "juan@example.com"  
**Cuando** escribo el email en el buscador y presiono Enter  
**Entonces** veo los resultados: Juan Pérez (Estudiante) - ID 1234  
**Y** puedo clic en [Ver Detalles]

### Escenario 2: Ver detalle completo de usuario

**Cuando** abro el detalle de Juan Pérez  
**Entonces** veo:
- Datos personales completos
- Estado de cuenta: Activo / Suspendido
- Fecha de registro: 10/10/2025
- Sesiones completadas: 12
- Total pagado: $450,000 COP
- Reseñas escritas: 8 (promedio 4.5 ⭐)
- Botones: [Suspender Cuenta] [Resetear Contraseña] [Ver Sesiones]

### Escenario 3: Suspender cuenta con motivo

**Cuando** hago clic en [Suspender Cuenta]  
**Entonces** veo modal pidiendo motivo (obligatorio)  
**Y** puedo elegir duración: Temporal (7/30 días) o Permanente  
**Y** al confirmar:
- Usuario no puede iniciar sesión
- Sesiones futuras se cancelan automáticamente
- Se envía email: "Tu cuenta fue suspendida. Motivo: [motivo]"

### Escenario 4: Agregar nota interna de soporte

**Cuando** escribo en "Notas Internas": "Usuario reportó problema de pago resuelto"  
**Entonces** la nota se guarda con mi nombre y timestamp  
**Y** es visible solo para otros admins (no para el usuario)

### Escenario 5: Resetear contraseña de usuario

**Cuando** hago clic en [Resetear Contraseña]  
**Entonces** se genera un link temporal de reseteo  
**Y** se envía por email al usuario: "Restablece tu contraseña"  
**Y** veo confirmación: "Email de reseteo enviado"

## 🔗 Trazabilidad

- **Módulo:** Admin
- **RF:** RF-073 (Gestionar usuarios)
- **Prioridad:** MUST HAVE

## 📊 Estimación

- **Story Points:** 5
- **Complejidad:** Media

## 🔄 Dependencias

- Depende de: Roles y permisos (solo admin)
- Relacionada con: HU-060 (Aprobar tutores)

## 🧪 Testing

- Búsqueda: Por nombre parcial, email, ID
- Suspensión: Verificar usuario no puede login
- Audit log: Todas las acciones registradas
- Permisos: Solo rol admin puede suspender

## 📌 Etiquetas

`#admin` `#gestion-usuarios` `#soporte` `#moderacion` `#release-1.0`
