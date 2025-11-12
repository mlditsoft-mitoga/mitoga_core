# HU-072: Configurar disponibilidad de tutor

**Épica:** Perfiles | **Rol:** Tutor | **Prioridad:** MUST HAVE (MVP)

---

## 📖 Historia

> **Como** tutor, **quiero** configurar mi disponibilidad horaria (días, horas, duración sesiones), **para** que estudiantes vean slots disponibles y reserven solo cuando puedo atender.

---

## 💼 Valor

- **Evita conflictos:** 95% reducción dobles reservas (calendario sincronizado)
- **Flexibilidad:** Tutores configuran horarios recurrentes (Lun-Vie 9-18h) o específicos
- **Conversión:** Disponibilidad clara aumenta reservas ~35%

---

## ✅ Criterios

### **Escenario 1: Configurar horario recurrente**
```gherkin
Given tutor "Carlos" accede a /perfil/disponibilidad
When configura horario semanal:
  | Día       | Hora inicio | Hora fin | Activo |
  | Lunes     | 09:00       | 18:00    | ✅     |
  | Martes    | 09:00       | 18:00    | ✅     |
  | Miércoles | 14:00       | 20:00    | ✅     |
  | Jueves    | 09:00       | 18:00    | ✅     |
  | Viernes   | 09:00       | 15:00    | ✅     |
  | Sábado    | OFF         | OFF      | ❌     |
  | Domingo   | OFF         | OFF      | ❌     |
  
  And configura "Duración sesión: 1 hora (default)"
  And configura "Buffer entre sesiones: 15 min"
Then sistema:
  - Genera slots automáticos cada 1h (ej: 9-10, 10-11, 11-12...)
  - Aplica buffer (si sesión 9-10, próxima disponible 10:15)
  - Guarda en tabla `tutor_availability` (recurrencia semanal)
```

### **Escenario 2: Bloquear fechas específicas (vacaciones)**
```gherkin
When tutor marca "No disponible: 20/12/2025 - 05/01/2026"
Then sistema:
  - Crea registro `availability_exceptions` tipo=BLOCKED
  - Oculta slots en calendario para esas fechas
  - Muestra "No disponible" si estudiante selecciona día bloqueado
```

### **Escenario 3: Agregar disponibilidad extra (fecha específica)**
```gherkin
Given tutor normalmente NO trabaja sábados
When agrega disponibilidad especial:
  - Fecha: Sábado 15/01/2026
  - Horario: 10:00 - 14:00
Then sistema:
  - Crea exception tipo=AVAILABLE_EXTRA
  - Muestra slots disponibles ese sábado específico
  - NO afecta recurrencia base (próximos sábados siguen OFF)
```

### **Escenario 4: Vista calendario tutor (mis reservas)**
```gherkin
Given tutor tiene configurado horario 9-18h Lun-Vie
  And tiene 3 reservas confirmadas:
    | Fecha     | Hora      | Estudiante | Materia     |
    | 10/01 Lun | 10:00-11:00 | Ana      | Matemáticas |
    | 10/01 Lun | 14:00-15:00 | Luis     | Física      |
    | 11/01 Mar | 09:00-10:00 | María    | Cálculo     |
When accede a /perfil/calendario
Then muestra:
  - Calendario mensual con slots DISPONIBLES (verde) y RESERVADOS (azul)
  - Lista de próximas sesiones (vista agenda)
  - Botón "Editar disponibilidad"
```

---

## 🔗 Trazabilidad

**RF:** RF-072 (Configurar disponibilidad tutor)  
**RNF:** RNF-PERF-005 (sincronización calendario tiempo real <1s)

**Story Points:** 8 SP | **Complejidad:** Alta (lógica recurrencia + excepciones)

---

## 🧩 Dependencias

- **Depende de:** HU-005 (Registro tutor)
- **Bloquea a:** HU-021 (Reservar sesión - requiere disponibilidad configurada)
- **Relacionada con:** HU-012 (Ver perfil tutor muestra calendario)

---

## ✔️ DoD

- [ ] Endpoint `POST /api/tutores/{id}/disponibilidad` (configurar horario recurrente)
- [ ] Endpoint `POST /api/tutores/{id}/disponibilidad/exceptions` (bloqueos/extras)
- [ ] Endpoint `GET /api/tutores/{id}/disponibilidad?mes=2026-01` (slots disponibles)
- [ ] Tabla `tutor_availability`: dia_semana, hora_inicio, hora_fin, duracion_sesion, buffer, active
- [ ] Tabla `availability_exceptions`: fecha, tipo (BLOCKED/AVAILABLE_EXTRA), hora_inicio, hora_fin
- [ ] Frontend: calendario drag-and-drop (react-big-calendar o FullCalendar)
- [ ] Validación conflictos: no permitir slots superpuestos
- [ ] Zona horaria del tutor almacenada (timezone)
- [ ] Tests E2E: configurar horario→estudiante ve slots→reserva exitosa

---

**Etiquetas:** `#perfiles` `#mvp` `#must-have` `#tutor` `#disponibilidad` `#calendario` `#recurrencia` `#time-management`

---

## ⚠️ Supuestos

- Tutores configuran disponibilidad en su zona horaria local
- Sistema convierte automáticamente a zona horaria estudiante en búsqueda
- Buffer 15 min suficiente para preparar siguiente sesión
