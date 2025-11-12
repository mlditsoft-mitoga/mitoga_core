# HU-074: Desactivar cuenta

**Épica:** Perfiles | **Rol:** Estudiante/Tutor | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** usuario, **quiero** desactivar temporalmente o eliminar permanentemente mi cuenta, **para** controlar mi presencia en la plataforma según mis necesidades.

---

## ✅ Criterios

### **Escenario 1: Desactivación temporal (reversible)**
```gherkin
Given usuario "Ana" accede a /configuracion/cuenta
When hace clic "Desactivar cuenta temporalmente"
  And confirma en modal "¿Seguro desactivar?"
Then sistema:
  - Cambia user.status → INACTIVA
  - Oculta perfil de búsquedas
  - Cancela reservas futuras con reembolso 100%
  - Mantiene datos en BD (recuperable)
  - Cierra sesión automáticamente
  - Envía email: "Cuenta desactivada. Reactiva cuando quieras"
  
When Ana vuelve después de 2 meses
  And hace login con credenciales
Then muestra "Reactiva tu cuenta para continuar" → botón "Reactivar"
```

### **Escenario 2: Eliminación permanente (GDPR compliance)**
```gherkin
When selecciona "Eliminar cuenta permanentemente"
Then muestra advertencia grave:
  "⚠️ Esta acción NO es reversible. Se eliminarán:
   - Datos personales (nombre, email, foto)
   - Historial sesiones
   - Métodos de pago guardados
   - Reseñas escritas (anonimizadas)
   
   Se mantendrán (legal):
   - Transacciones financieras (5 años)
   - Facturas electrónicas"

When confirma escribiendo "ELIMINAR" + contraseña
Then sistema ejecuta job eliminación:
  - Anonimiza nombre → "Usuario eliminado"
  - Elimina email, teléfono, foto
  - Reseñas cambian autor → "Cuenta eliminada"
  - Mantiene transactions (compliance fiscal)
  - Envía email confirmación última vez
```

### **Escenario 3: Tutor con reservas futuras**
```gherkin
Given tutor tiene 3 sesiones confirmadas próximas 2 semanas
When intenta desactivar cuenta
Then muestra error:
  "No puedes desactivar con sesiones pendientes.
   Opciones:
   - Espera 2 semanas a completar sesiones
   - Cancela manualmente 3 reservas (reembolso estudiantes)"
```

---

## 🔗 Trazabilidad

**RF:** RF-074 | **RNF:** RNF-GDPR-001 (derecho al olvido), RNF-SEC-011 (anonimización datos)

**Story Points:** 3 SP

---

## 🧩 Dependencias

- **Depende de:** HU-001/005 (Cuenta existente)

---

## ✔️ DoD

- [ ] Endpoint `POST /api/usuarios/{id}/desactivar` (soft delete)
- [ ] Endpoint `DELETE /api/usuarios/{id}/eliminar` (anonimización)
- [ ] Job background eliminación datos (queue)
- [ ] Modal confirmación con advertencias claras
- [ ] Página `/cuenta-desactivada` con opción reactivar
- [ ] Validación: no permitir si reservas activas
- [ ] Email confirmación eliminación
- [ ] Compliance GDPR: exportar datos antes eliminar (data portability)
- [ ] Tests E2E: desactivar→reactivar | eliminar→verificar anonimización

---

**Etiquetas:** `#perfiles` `#mvp` `#must-have` `#desactivar-cuenta` `#eliminar-cuenta` `#gdpr` `#privacidad` `#data-retention`
