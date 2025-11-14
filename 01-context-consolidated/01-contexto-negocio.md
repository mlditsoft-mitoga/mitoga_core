# Contexto de Negocio - MI-TOGA

**Proyecto:** MI-TOGA - Plataforma de Tutorías Virtuales  
**Cliente/Organización:** ZENAPSES S.A.S  
**Fecha de análisis:** 08 de noviembre de 2025  
**Versión del documento:** 1.0  
**Estado:** MVP en desarrollo (Fase 1 completada - Frontend)

---

## 1. Descripción del Proyecto

### 1.1 Nombre del Proyecto
**MI-TOGA** - Plataforma Web de Tutorías Virtuales

### 1.2 Descripción General

MI-TOGA es una **plataforma web moderna de tutoría virtual** que conecta estudiantes con tutores colombianos especializados, facilitando el acceso a educación de calidad mediante tecnología web de última generación.

La plataforma funciona como un **marketplace bidireccional** donde:
- **Estudiantes** pueden buscar, filtrar y reservar sesiones con tutores calificados según sus necesidades específicas (materia, nivel, modalidad, precio).
- **Tutores** pueden ofrecer sus servicios, gestionar su disponibilidad, establecer tarifas y recibir pagos por sus sesiones.
- **Administradores** moderan la calidad de la plataforma, aprueban tutores, resuelven disputas y monitorean el funcionamiento general.

El proyecto busca **democratizar el acceso a educación de calidad** eliminando barreras geográficas y económicas, conectando oferta y demanda educativa de manera eficiente a través de una experiencia de usuario intuitiva y profesional.

**¿Por qué es necesario ahora?**
- La pandemia aceleró la adopción de educación virtual
- Hay demanda insatisfecha de tutorías personalizadas
- Los estudiantes buscan flexibilidad horaria y geográfica
- Los tutores necesitan una plataforma confiable para ofrecer sus servicios

**Fuente:** PROYECTO_CONTEXTO.md (sección "Descripción General" y "Misión")

### 1.3 Fecha de Inicio y Estado Actual

**Fecha de Inicio:** Q4 2024 (estimado)  
**Estado Actual:** 🟡 **MVP en Desarrollo - Fase 1 completada (Frontend)**

**Progreso por Fase:**
- ✅ **Fase 1 - MVP Frontend**: Completada (100%)
  - Diseño UI/UX completo implementado
  - Sistema de componentes reutilizables
  - Autenticación client-side (mock)
  - Marketplace funcional con filtros
  - Datos mock de 9 tutores

- ⏳ **Fase 2 - Backend**: En planificación (0%)
  - Next.js API Routes pendiente
  - Base de datos pendiente
  - Autenticación real (JWT) pendiente

- 📋 **Fases 3-5**: Planeadas (roadmap definido)

**Fuente:** PROYECTO_CONTEXTO.md (sección "Roadmap Técnico")

---

## 2. Objetivos de Negocio

### 2.1 Misión
Facilitar el encuentro entre estudiantes que buscan apoyo académico y tutores calificados en Colombia, ofreciendo una experiencia de aprendizaje flexible, accesible y de alta calidad.

### 2.2 Visión
Convertirse en la plataforma líder de tutorías en Colombia, reconocida por su facilidad de uso, calidad de tutores y resultados académicos comprobables.

### 2.3 Objetivos Principales

| # | Objetivo | Descripción | Plazo | Estado |
|---|----------|-------------|-------|--------|
| 1 | **Lanzar MVP funcional** | Plataforma con funcionalidades core operativa (marketplace, registro, agendamiento, pagos) | 6-12 meses | ⏳ En progreso |
| 2 | **Captar 100 tutores verificados** | Onboarding y verificación de tutores en especialidades clave (matemáticas, física, química, inglés, programación) | 6 meses post-lanzamiento | 📋 Planeado |
| 3 | **Alcanzar 1,000 estudiantes registrados** | Base de usuarios activa para generar transacciones recurrentes | 12 meses | 📋 Planeado |
| 4 | **Generar 500 sesiones mensuales** | Volumen de transacciones que valide el modelo de negocio | 12 meses | 📋 Planeado |
| 5 | **Lograr NPS > 50** | Nivel de satisfacción que garantice crecimiento orgánico por recomendación | Continuo | 📋 Planeado |

**Fuente:** Inferido de PROYECTO_CONTEXTO.md (sección "Visión" y "Métricas de Éxito")

### 2.4 Métricas de Éxito (KPIs)

#### KPIs de Negocio

| KPI | Descripción | Valor Objetivo | Plazo | Fuente |
|-----|-------------|----------------|-------|--------|
| **Tutores activos** | Número de tutores con perfil completo y sesiones en los últimos 30 días | 100 tutores | 12 meses | PROYECTO_CONTEXTO.md |
| **Estudiantes registrados** | Total de estudiantes con cuenta activa | 1,000 usuarios | 12 meses | PROYECTO_CONTEXTO.md |
| **Sesiones realizadas/mes** | Volumen mensual de sesiones completadas | 500 sesiones | 12 meses | PROYECTO_CONTEXTO.md |
| **Tasa de retención** | % de usuarios que regresan al mes siguiente | > 40% | Continuo | PROYECTO_CONTEXTO.md |
| **Valor promedio por sesión** | Ingreso promedio por sesión de tutoría | $30,000 COP | Continuo | PROYECTO_CONTEXTO.md |
| **Net Promoter Score (NPS)** | Medición de satisfacción y probabilidad de recomendación | > 50 | Continuo | PROYECTO_CONTEXTO.md |
| **Tasa de conversión** | % de visitantes que se registran | > 5% | Continuo | Inferido |
| **Tasa de completitud de sesiones** | % de sesiones agendadas que se completan | > 90% | Continuo | Inferido |

#### KPIs Técnicos

| KPI | Descripción | Valor Objetivo | Fuente |
|-----|-------------|----------------|--------|
| **Tiempo de carga** | Tiempo de carga inicial de la página | < 3s | PROYECTO_CONTEXTO.md |
| **Core Web Vitals** | LCP, FID, CLS según estándares de Google | Aprobado | PROYECTO_CONTEXTO.md |
| **Uptime** | Disponibilidad del servicio | > 99.9% | PROYECTO_CONTEXTO.md |
| **Tasa de error** | % de requests con error | < 0.1% | PROYECTO_CONTEXTO.md |
| **Tiempo de respuesta API** | Latencia promedio de endpoints | < 200ms | PROYECTO_CONTEXTO.md |

**Fuente:** PROYECTO_CONTEXTO.md (sección "Métricas de Éxito")

---

## 3. Stakeholders

### 3.1 Stakeholders Internos

| Rol | Nombre | Responsabilidad | Contacto | Influencia |
|-----|--------|-----------------|----------|-----------|
| **Product Owner** | *(A definir)* | Definir prioridades de producto, gestionar backlog, validar features | *(Pendiente)* | 🔴 Alta |
| **Tech Lead** | *(A definir)* | Decisiones técnicas, arquitectura, stack tecnológico | *(Pendiente)* | 🔴 Alta |
| **Sponsor Ejecutivo** | *(A definir)* | Aprobación presupuesto, decisiones estratégicas | *(Pendiente)* | 🔴 Alta |
| **Desarrollador Frontend** | *(Equipo actual)* | Implementación de UI/UX, componentes React | *(Activo)* | 🟡 Media |
| **Desarrollador Backend** | *(A contratar)* | APIs, base de datos, integraciones | *(Pendiente)* | 🔴 Alta |
| **Diseñador UI/UX** | *(Colaborador)* | Diseño de interfaces, experiencia de usuario | *(Activo)* | 🟡 Media |
| **QA Engineer** | *(A definir)* | Testing, aseguramiento de calidad | *(Pendiente)* | 🟡 Media |
| **Community Manager** | *(A definir)* | Marketing, redes sociales, contenido | *(Pendiente)* | 🟢 Baja |

**Observación:** No se identificaron nombres específicos de stakeholders en la documentación disponible.

### 3.2 Stakeholders Externos

| Tipo | Descripción | Impacto | Notas |
|------|-------------|---------|-------|
| **Estudiantes** | Usuarios finales que buscan tutorías | 🔴 Alto - Usuarios directos, fuente de ingresos | Segmento objetivo: estudiantes de colegio y universidad en Colombia |
| **Tutores** | Profesionales que ofrecen servicios de tutoría | 🔴 Alto - Oferta de valor, calidad del servicio | Requieren proceso de verificación y aprobación |
| **Padres de Familia** | Tomadores de decisión para tutorías de menores | 🟡 Medio - Influenciadores de compra | Interesados en seguridad y calidad |
| **Instituciones Educativas** | Posibles partners estratégicos (B2B2C) | 🟢 Bajo - Oportunidad futura | Potencial para acuerdos institucionales |
| **Reguladores** | MinEducación, MinTIC (Colombia) | 🟡 Medio - Compliance requerido | Regulaciones de educación virtual y protección de datos |
| **Pasarelas de Pago** | Stripe, PayU, Wompi | 🔴 Alto - Dependencia crítica | Integración necesaria para monetización |
| **Proveedores de Videollamadas** | Agora, Twilio, Jitsi | 🔴 Alto - Funcionalidad core | Decisión técnica pendiente |

**Fuente:** Inferido de PROYECTO_CONTEXTO.md (casos de uso y funcionalidades)

---

## 4. Usuarios Objetivo

### 4.1 Segmentos de Usuarios

#### Segmento 1: **Estudiantes de Colegio**

**Descripción:**
- Estudiantes de secundaria (grados 6-11)
- Edades: 11-17 años
- Buscan refuerzo académico en materias específicas
- Preparación para exámenes (ICFES, parciales)

**Necesidades principales:**
1. Tutores con experiencia en pedagogía para jóvenes
2. Flexibilidad horaria (después de clases, fines de semana)
3. Modalidad virtual desde casa
4. Tarifas accesibles
5. Contenido alineado con el currículo escolar colombiano

**Volumen esperado:** 40-50% de la base de estudiantes (~400-500 usuarios en año 1)

**Frecuencia de uso:** 1-2 sesiones por semana

**Pain points:**
- Dificultad para encontrar tutores especializados cerca de casa
- Costos elevados de tutorías presenciales
- Limitaciones de horario

**Fuente:** Inferido de PROYECTO_CONTEXTO.md (contexto general y casos de uso)

---

#### Segmento 2: **Estudiantes Universitarios**

**Descripción:**
- Estudiantes de pregrado y posgrado
- Edades: 17-30 años
- Necesitan apoyo en materias complejas (cálculo, física, programación)
- Preparación para proyectos finales y tesis

**Necesidades principales:**
1. Tutores con expertise técnico avanzado
2. Sesiones intensivas por bloques
3. Disponibilidad nocturna (estudiantes que trabajan)
4. Especialización en áreas STEM
5. Apoyo en metodología de investigación

**Volumen esperado:** 30-40% de la base de estudiantes (~300-400 usuarios en año 1)

**Frecuencia de uso:** 1-3 sesiones por semana (variable según época de parciales)

**Pain points:**
- Dificultad para encontrar tutores con nivel universitario
- Necesidad de sesiones específicas y puntuales
- Presupuesto limitado

**Fuente:** Inferido de PROYECTO_CONTEXTO.md y mock data de tutores (especialidades avanzadas)

---

#### Segmento 3: **Profesionales en Upskilling**

**Descripción:**
- Profesionales que buscan actualizar habilidades
- Edades: 25-45 años
- Interés en tecnología, idiomas, soft skills
- Buscan tutorías para cambio de carrera

**Necesidades principales:**
1. Tutores con experiencia laboral real
2. Enfoque práctico y orientado a resultados
3. Flexibilidad total de horarios
4. Tutorías especializadas (Python, React, inglés de negocios)
5. Certificados o validación de aprendizaje

**Volumen esperado:** 10-20% de la base de estudiantes (~100-200 usuarios en año 1)

**Frecuencia de uso:** 1 sesión por semana (continua durante meses)

**Pain points:**
- Falta de tiempo por trabajo
- Cursos genéricos no personalizados
- Inversión significativa en tiempo y dinero

**Fuente:** Inferido de roadmap (mencionan "plataforma escalable")

---

#### Segmento 4: **Tutores (Lado de la Oferta)**

**Descripción:**
- Profesionales con expertise en materias específicas
- Maestros, ingenieros, profesionales con vocación docente
- Buscan ingresos adicionales o trabajo principal

**Necesidades principales:**
1. Plataforma confiable para recibir pagos
2. Gestión simple de calendario y disponibilidad
3. Proceso de verificación transparente
4. Comisiones razonables
5. Herramientas para impartir clases de calidad (videollamadas estables)

**Volumen esperado:** 100 tutores verificados en año 1

**Frecuencia de uso:** Diaria (gestión de calendario y sesiones)

**Pain points:**
- Dificultad para conseguir estudiantes consistentemente
- Incertidumbre en cobros
- Falta de herramientas profesionales para tutorías

**Fuente:** PROYECTO_CONTEXTO.md (sección "Roles de Usuario - Tutor")

---

### 4.2 Resumen de Volumetría

| Segmento | % Esperado | Usuarios Año 1 | Sesiones/mes (promedio) |
|----------|------------|----------------|-------------------------|
| Estudiantes Colegio | 40-50% | 400-500 | 1.5 sesiones/semana |
| Estudiantes Universidad | 30-40% | 300-400 | 2 sesiones/semana |
| Profesionales | 10-20% | 100-200 | 1 sesión/semana |
| **Total Estudiantes** | **100%** | **1,000** | **~500 sesiones/mes total** |
| Tutores | N/A | 100 | 5 sesiones/semana cada uno |

**Fuente:** Inferido de KPIs en PROYECTO_CONTEXTO.md

---

## 5. Modelo de Negocio

### 5.1 Tipo de Modelo

**Modelo:** **Marketplace B2C + Comisiones por Transacción**

**Características:**
- Plataforma que conecta dos lados: estudiantes (demanda) y tutores (oferta)
- Monetización basada en comisiones por sesión completada
- Valor agregado: verificación de tutores, pagos seguros, herramientas de comunicación

**Tipo secundario:** **SaaS para Tutores** (potencial futuro: suscripciones premium para tutores con beneficios adicionales)

**Fuente:** Inferido de PROYECTO_CONTEXTO.md (marketplace de tutores + pagos mencionados)

### 5.2 Fuentes de Ingreso

| # | Fuente de Ingreso | Descripción | Estimación | Estado |
|---|-------------------|-------------|------------|--------|
| 1 | **Comisión por sesión** | % del valor de cada sesión de tutoría (típicamente 15-25% en plataformas similares) | 20% de $30,000 COP = $6,000 COP por sesión | 📋 Planeado (Fase 4) |
| 2 | **Suscripciones premium (Tutores)** | Membresía mensual para tutores con beneficios: mayor visibilidad, sin comisión, estadísticas avanzadas | $50,000 - $100,000 COP/mes por tutor | 💡 Idea futura |
| 3 | **Publicidad de instituciones** | Instituciones educativas o empresas EdTech pueden promocionarse en la plataforma | Variable (CPM o CPC) | 💡 Idea futura |
| 4 | **Comisión por materiales** | Si se permite venta de materiales educativos complementarios | 10-15% del valor | 💡 Idea futura |

**Proyección de Ingresos Año 1 (estimado):**
- 500 sesiones/mes × $6,000 COP comisión = **$3,000,000 COP/mes** (~$750 USD/mes)
- Año 1: **$36,000,000 COP** (~$9,000 USD)

**Observación:** Números estimados basados en el modelo típico de marketplaces. No hay información de monetización específica en la documentación.

**Fuente:** Inferido de PROYECTO_CONTEXTO.md (menciona Stripe/PayU en roadmap Fase 4)

### 5.3 Estructura de Costos

| Categoría | Descripción | Estimación Mensual | Frecuencia | Notas |
|-----------|-------------|-------------------|------------|-------|
| **Desarrollo** | Desarrollo de features, mantenimiento | $5,000,000 - $10,000,000 COP | Mensual (recurrente) | Equipo dev + Tech Lead |
| **Infraestructura Cloud** | Hosting, base de datos, almacenamiento, CDN | $500,000 - $1,000,000 COP | Mensual | AWS/Azure (estimado para 1K usuarios) |
| **Servicios Externos** | Pasarela de pagos, videollamadas, email, SMS | $300,000 - $800,000 COP | Mensual | Stripe/PayU (~2-3%), Twilio, SendGrid |
| **Marketing y Adquisición** | Google Ads, redes sociales, contenido | $1,000,000 - $3,000,000 COP | Mensual | CAC objetivo: < $50,000 COP por usuario |
| **Operaciones** | Soporte, moderación, legal, admin | $1,000,000 - $2,000,000 COP | Mensual | Community manager + soporte |
| **Licencias y Software** | Herramientas de desarrollo, analytics, CRM | $200,000 - $500,000 COP | Mensual | GitHub, Figma, Analytics, etc. |

**Total Costos Mensuales Estimados (Fase 2-3):** $8,000,000 - $17,000,000 COP (~$2,000 - $4,250 USD/mes)

**Observación:** Costos basados en estimaciones de industria para startups en fase MVP-Growth. No hay presupuesto específico en la documentación.

**Fuente:** Estimación basada en stack tecnológico identificado en PROYECTO_CONTEXTO.md

### 5.4 Punto de Equilibrio

**Cálculo estimado:**
- Costos fijos mensuales: ~$12,000,000 COP
- Ingreso promedio por sesión (comisión): $6,000 COP
- **Sesiones necesarias para break-even:** 2,000 sesiones/mes

**Timeline esperado para break-even:** 18-24 meses post-lanzamiento (basado en curva de crecimiento típica de marketplaces educativos)

**Fuente:** Cálculo estimado (no hay información financiera en documentación)

---

## 6. Alcance y Limitaciones

### 6.1 En Alcance (Confirmado)

#### ✅ MVP (Fase 1) - Completado
- [x] Diseño UI/UX completo y responsivo
- [x] Sistema de componentes reutilizables en React
- [x] Autenticación client-side (mock para demo)
- [x] Marketplace de tutores con tarjetas informativas
- [x] Filtrado por materia, modalidad, calificación, precio
- [x] Ordenamiento de resultados
- [x] Búsqueda por nombre
- [x] Datos mock de 9 tutores de prueba
- [x] Páginas: Home (marketplace), Dashboard Tutor, Dashboard Admin

**Fuente:** PROYECTO_CONTEXTO.md (sección "Roadmap Técnico - Fase 1")

#### ⏳ Fase 2 - Backend (Próximo Sprint)
- [ ] Next.js API Routes
- [ ] Conexión a base de datos (PostgreSQL o MongoDB)
- [ ] Autenticación real con JWT
- [ ] CRUD de tutores
- [ ] CRUD de usuarios
- [ ] Sistema de roles y permisos (estudiante, tutor, admin)

**Fuente:** PROYECTO_CONTEXTO.md (sección "Roadmap Técnico - Fase 2")

#### 📋 Fase 3 - Funcionalidades Core (Planeadas)
- [ ] Sistema de agendamiento de sesiones
- [ ] Notificaciones (email y push notifications)
- [ ] Chat en tiempo real (Socket.io o similar)
- [ ] Videollamadas integradas (WebRTC, Agora o Twilio)
- [ ] Sistema de calificaciones y reseñas
- [ ] Búsqueda avanzada con filtros múltiples

**Fuente:** PROYECTO_CONTEXTO.md (sección "Roadmap Técnico - Fase 3")

#### 📋 Fase 4 - Pagos y Monetización (Planeadas)
- [ ] Integración con pasarela de pagos (Stripe o PayU)
- [ ] Sistema de comisiones automáticas
- [ ] Facturación automática
- [ ] Reporte de ingresos para tutores
- [ ] Sistema de retiros/transferencias

**Fuente:** PROYECTO_CONTEXTO.md (sección "Roadmap Técnico - Fase 4")

#### 📋 Fase 5 - Optimizaciones (Futuras)
- [ ] SEO optimization avanzado
- [ ] Performance optimization (lazy loading, code splitting)
- [ ] Google Analytics y métricas avanzadas
- [ ] A/B testing framework
- [ ] Progressive Web App (PWA)
- [ ] Mobile app nativa (React Native)

**Fuente:** PROYECTO_CONTEXTO.md (sección "Roadmap Técnico - Fase 5")

---

### 6.2 Fuera de Alcance (Explícitamente Excluido)

#### ❌ No Incluido en MVP ni Roadmap Inmediato

1. **Tutorías Presenciales con Logística:**
   - La plataforma NO coordina transporte ni logística para sesiones "en sitio"
   - Tutores y estudiantes coordinan directamente ubicaciones físicas

2. **Contenido Educativo Propio:**
   - La plataforma NO crea ni vende cursos pregrabados
   - Enfoque 100% en sesiones en vivo uno-a-uno

3. **Certificaciones Oficiales:**
   - No se emiten certificados con validez académica oficial
   - Solo constancias de sesiones completadas

4. **Tutorías Grupales:**
   - MVP se enfoca en sesiones individuales (1-a-1)
   - Grupos pueden considerarse en fases futuras

5. **Marketplace de Materiales Educativos:**
   - No se incluye venta de libros, guías o materiales complementarios
   - Tutores pueden compartir recursos pero no monetizarlos directamente en la plataforma

6. **Integraciones con Sistemas de Gestión Escolar (LMS):**
   - No hay integración con Moodle, Blackboard, Google Classroom en MVP
   - Potencial para fases futuras B2B

**Fuente:** Inferido por ausencia en PROYECTO_CONTEXTO.md y enfoque del roadmap

---

### 6.3 Alcance Condicional (Pendiente de Validación)

#### ⚠️ Funcionalidades Mencionadas pero Sin Confirmación

1. **Autenticación con OAuth (Google/Facebook):**
   - Mencionado en roadmap de autenticación
   - **Pendiente:** Confirmar si se incluye en Fase 2 o posterior
   - **Riesgo:** Complejidad adicional de integración

2. **Verificación de Tutores con Documentos:**
   - Proceso de aprobación mencionado en roles de usuario
   - **Pendiente:** Definir flujo exacto, documentos requeridos, tiempo de revisión
   - **Responsable:** Admin (manualmente) o automatizado

3. **Grabación de Sesiones:**
   - No mencionado explícitamente en roadmap
   - **Pendiente:** Validar si es requerido (implicaciones legales de privacidad)
   - **Decisión:** Product Owner + Legal

4. **Sistema de Reembolsos:**
   - Lógico para plataforma de pagos pero no especificado
   - **Pendiente:** Definir políticas de cancelación y reembolso
   - **Bloqueador:** Requiere definición de términos y condiciones

5. **Multi-idioma (i18n):**
   - No mencionado en MVP
   - **Pendiente:** ¿Solo español o también inglés/otros idiomas?
   - **Decisión:** Depende de estrategia de expansión internacional

6. **Niveles de Membresía para Estudiantes:**
   - No definido (solo comisiones por sesión mencionadas)
   - **Pendiente:** ¿Habrá planes premium para estudiantes con beneficios?

**Fuente:** Inferido de análisis de gaps en PROYECTO_CONTEXTO.md

---

### 6.4 Restricciones Conocidas

#### Restricciones Técnicas

1. **Stack Tecnológico Definido:**
   - Frontend: Next.js 16 + React 19 + TypeScript 5.9 (no negociable, ya implementado)
   - Styling: Tailwind CSS 4.1 (no negociable, ya implementado)
   - Restricción: Cualquier cambio de framework requeriría reescritura completa

2. **Dependencias Externas Críticas:**
   - Pasarela de pagos (Stripe o PayU) - Comisiones del 2-4%
   - Proveedor de videollamadas (Agora/Twilio) - Costos por minuto
   - Restricción: Dependencia de terceros con costos variables

3. **Sin Backend Implementado:**
   - Toda la lógica actual es client-side
   - Restricción: Vulnerabilidades de seguridad hasta implementar backend real

**Fuente:** PROYECTO_CONTEXTO.md (sección "Stack Tecnológico") y package.json

#### Restricciones de Negocio

1. **Mercado Inicial: Solo Colombia**
   - Enfoque geográfico limitado en fase MVP
   - Restricción: Expansión internacional requiere localización y regulaciones adicionales

2. **Sin Presupuesto Documentado:**
   - No hay información de inversión disponible
   - Restricción: Alcance real depende de recursos financieros no especificados

3. **Timeline No Definido:**
   - Roadmap de 5 fases sin fechas específicas
   - Restricción: Imposible comprometer fechas de entrega sin timeline formal

**Fuente:** Análisis de gaps en documentación

#### Restricciones Regulatorias (Potenciales)

1. **Protección de Datos (Habeas Data - Ley 1581 de 2012):**
   - Obligatorio implementar políticas de privacidad y tratamiento de datos personales
   - Restricción: Requiere términos y condiciones, política de privacidad, consentimientos

2. **Protección de Menores:**
   - Si estudiantes menores de edad usan la plataforma, requiere consentimiento parental
   - Restricción: Proceso de verificación de edad y permisos parentales

3. **Facturación Electrónica (DIAN - Colombia):**
   - Si se procesan pagos, eventualmente requerido emitir facturas electrónicas
   - Restricción: Integración con proveedor de facturación electrónica

4. **PCI-DSS (Pagos con Tarjeta):**
   - Si se manejan datos de tarjetas de crédito directamente (no aplica si se usa Stripe/PayU como intermediario)
   - Restricción: Certificación costosa si se maneja directamente

**Fuente:** Inferido de contexto colombiano y mejores prácticas de plataformas de pago

---

## 7. Supuestos Documentados

### Supuestos de Negocio

| ID | Supuesto | Justificación | Riesgo si es Incorrecto | Validar con |
|----|----------|---------------|------------------------|-------------|
| S-001 | La comisión por sesión será del 20% | Estándar de industria en marketplaces similares (Airbnb, Uber toman 15-25%) | 🟡 MEDIO - Modelo financiero cambia | Product Owner / CFO |
| S-002 | Tarifa promedio por sesión es $30,000 COP | Basado en tarifas de tutorías en Colombia (~$20,000-$50,000 COP/hora) | 🟡 MEDIO - Proyecciones de ingreso afectadas | Investigación de mercado |
| S-003 | Ratio tutor:estudiantes es 1:10 | Cada tutor atiende en promedio 10 estudiantes distintos | 🟡 MEDIO - Afecta captación de tutores | Datos históricos de plataformas similares |
| S-004 | Tasa de conversión visitante→registro es 5% | Estándar de conversión para SaaS/marketplaces educativos | 🟢 BAJO - Solo afecta estrategia de marketing | A/B testing post-lanzamiento |

### Supuestos Técnicos

| ID | Supuesto | Justificación | Riesgo si es Incorrecto | Validar con |
|----|----------|---------------|------------------------|-------------|
| S-005 | Base de datos será PostgreSQL | Mencionado en PROYECTO_CONTEXTO.md como opción preferida | 🟡 MEDIO - Cambio de arquitectura | Tech Lead |
| S-006 | Videollamadas con Agora o Twilio | Proveedores líderes en la industria | 🟡 MEDIO - Costos y complejidad de integración | Tech Lead + evaluación de costos |
| S-007 | Hosting en AWS | Asumido por menciones de S3 en documentación | 🟢 BAJO - Arquitectura cloud-agnostic posible | DevOps / Tech Lead |
| S-008 | 1,000 usuarios concurrentes máximo en año 1 | Basado en 1,000 usuarios totales con 10% activos simultáneamente | 🔴 ALTO - Subdimensionamiento de infraestructura | Simulaciones de carga |

### Supuestos de Producto

| ID | Supuesto | Justificación | Riesgo si es Incorrecto | Validar con |
|----|----------|---------------|------------------------|-------------|
| S-009 | Sesiones duran 1 hora en promedio | Estándar de tutorías personalizadas | 🟢 BAJO - Solo afecta UX de agendamiento | User research |
| S-010 | Tutores configuran disponibilidad semanalmente | Patrón común en plataformas de scheduling | 🟢 BAJO - Flexibilidad de implementación | UX research con tutores |
| S-011 | Estudiantes pueden cancelar hasta 24h antes sin penalidad | Política estándar de plataformas de servicios | 🟡 MEDIO - Afecta flujo de cancelaciones | Legal / Product Owner |
| S-012 | Verificación de tutores toma 3-5 días hábiles | Tiempo razonable para revisión manual por admin | 🟡 MEDIO - Afecta experiencia de onboarding de tutores | Pruebas de proceso |

**Fuente:** Supuestos inferidos por ausencia de especificaciones en PROYECTO_CONTEXTO.md

---

## 8. Riesgos Identificados

### Riesgos de Negocio

| ID | Riesgo | Probabilidad | Impacto | Mitigación |
|----|--------|--------------|---------|------------|
| R-001 | **Falta de tutores de calidad** | 🟡 Media | 🔴 Alto | Proceso de verificación robusto, incentivos para primeros tutores |
| R-002 | **Baja adopción inicial de estudiantes** | 🟡 Media | 🔴 Alto | Estrategia de marketing agresiva, partnerships con instituciones |
| R-003 | **Competencia de plataformas establecidas** | 🔴 Alta | 🟡 Medio | Diferenciación por UX, enfoque en mercado colombiano |
| R-004 | **Problemas de calidad en sesiones** | 🟡 Media | 🟡 Medio | Sistema de calificaciones, moderación activa |

### Riesgos Técnicos

| ID | Riesgo | Probabilidad | Impacto | Mitigación |
|----|--------|--------------|---------|------------|
| R-005 | **Escalabilidad insuficiente** | 🟢 Baja | 🔴 Alto | Arquitectura cloud-native desde Fase 2, load testing |
| R-006 | **Problemas de calidad en videollamadas** | 🟡 Media | 🔴 Alto | Seleccionar proveedor confiable (Agora/Twilio), tests de calidad |
| R-007 | **Brechas de seguridad en pagos** | 🟢 Baja | 🔴 Alto | Usar pasarelas certificadas (PCI-DSS), no manejar datos de tarjetas |
| R-008 | **Falta de backend implementado** | 🔴 Alta (actual) | 🔴 Alto | Priorizar Fase 2, contratar backend developer |

**Fuente:** Análisis de riesgos basado en estado actual del proyecto y mejores prácticas

---

## 9. Próximos Pasos Críticos

### Información Pendiente de Validación (Prioridad Alta)

1. **Stakeholders y Contactos:**
   - ⚠️ Identificar y documentar Product Owner, Tech Lead, Sponsor Ejecutivo con nombres y contactos

2. **Presupuesto y Financiamiento:**
   - ⚠️ Definir presupuesto total del proyecto
   - ⚠️ Confirmar fuentes de financiamiento (inversión, bootstrapping, etc.)

3. **Timeline con Fechas:**
   - ⚠️ Establecer fechas específicas para lanzamiento de cada fase
   - ⚠️ Definir fecha objetivo de MVP completo (frontend + backend mínimo)

4. **Decisiones Técnicas Pendientes:**
   - ⚠️ Confirmar base de datos (PostgreSQL vs MongoDB)
   - ⚠️ Seleccionar proveedor de videollamadas (Agora vs Twilio vs alternativa)
   - ⚠️ Decidir pasarela de pagos (Stripe vs PayU vs Wompi)

5. **Modelo de Monetización:**
   - ⚠️ Confirmar % de comisión por sesión
   - ⚠️ Definir políticas de cancelación y reembolsos
   - ⚠️ Establecer estructura de precios para posibles membresías premium

6. **Cumplimiento Legal:**
   - ⚠️ Redactar Términos y Condiciones
   - ⚠️ Redactar Política de Privacidad (Ley 1581 - Habeas Data)
   - ⚠️ Definir proceso de consentimiento parental para menores

---

## 10. Conclusiones

### Fortalezas del Proyecto

1. ✅ **Visión clara y bien articulada** - Misión, visión y propuesta de valor definidas
2. ✅ **MVP frontend funcional** - Base sólida para iteración
3. ✅ **Stack tecnológico moderno** - Next.js 16, React 19, TypeScript
4. ✅ **Roadmap estructurado** - 5 fases claramente definidas
5. ✅ **Casos de uso bien documentados** - Comprensión clara de flujos de usuario

### Debilidades Identificadas

1. ❌ **Falta de backend** - Funcionalidad crítica pendiente
2. ❌ **Ausencia de información financiera** - Sin presupuesto ni proyecciones validadas
3. ❌ **Stakeholders no identificados** - Falta de contactos y responsables claros
4. ❌ **Timeline sin fechas** - Roadmap sin compromisos temporales
5. ❌ **Requisitos no formalizados** - Documentación descriptiva pero no especificación formal

### Recomendaciones Inmediatas

1. 🎯 **Priorizar Fase 2 (Backend)** - Sin backend, la plataforma no puede monetizar
2. 🎯 **Formalizar stakeholders** - Identificar Product Owner y Tech Lead
3. 🎯 **Definir presupuesto** - Necesario para planificación realista
4. 🎯 **Establecer timeline** - Fechas de entrega para generar accountability
5. 🎯 **Contratar backend developer** - Skill crítico faltante en el equipo

---

**Documento preparado por:** ZNS v2.0 - Consolidación de Contexto Profundo  
**Fecha:** 08 de noviembre de 2025  
**Versión:** 1.0  
**Próxima revisión:** Al completar Fase 2 (Backend)

**Nota:** Este documento se basa en la información disponible en PROYECTO_CONTEXTO.md y análisis del código frontend. Supuestos y estimaciones están marcados claramente y requieren validación con stakeholders del proyecto.
