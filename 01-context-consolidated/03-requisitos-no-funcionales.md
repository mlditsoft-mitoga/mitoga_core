# Requisitos No Funcionales - MI-TOGA# Requisitos No Funcionales - MI-TOGA# Requisitos No Funcionales - MI-TOGA



**Proyecto:** MI-TOGA | **Fecha:** 08/11/2025 | **Versión:** 1.0  

**Fuentes:** PROYECTO_CONTEXTO.md (KPIs Técnicos) + checklist-stack-tecnologico-cliente.md

**Proyecto:** MI-TOGA - Plataforma de Tutorías Virtuales  > **🎭 Enfoque:** Este documento debe ser analizado desde la perspectiva de un **Site Reliability Engineer (SRE) Senior y Performance Architect**, enfocándose en SLIs/SLOs/SLAs, capacity planning, fault tolerance y observability.

---

**Cliente/Organización:** ZENAPSES S.A.S  

## 1. Performance

**Fecha de Consolidación:** 8 de noviembre de 2025  ---

### RNF-001: Tiempo de Carga Inicial

- **Requisito:** < 3 segundos (páginas principales)**Versión del Documento:** 1.0  

- **Fuente:** PROYECTO_CONTEXTO.md - KPIs Técnicos

- **Estado:** ⚠️ A validar (no medido)**Método:** ZNS - Consolidación, Estructuración, Inteligencia, Best Practices, Arquitectura## 1. Performance y Escalabilidad

- **Implementación:** Next.js 16.0 con App Router, optimización de imágenes

- **Validación:** Lighthouse score > 90



### RNF-002: Tiempo de Respuesta API---### RNF-001: Tiempo de Respuesta

- **Requisito:** < 200ms (p95)

- **Fuente:** PROYECTO_CONTEXTO.md - KPIs Técnicos- Consultas simples: < 200ms

- **Estado:** ❌ Backend no implementado

- **Stack Objetivo:** Node.js/Python con PostgreSQL optimizado## 📊 Resumen Ejecutivo- Transacciones: < 500ms



### RNF-003: Tiempo de Búsqueda de Tutores

- **Requisito:** < 1 segundo

- **Estado:** ✅ Cumplido (filtrado client-side actual)Este documento especifica los requisitos no funcionales (RNF) de la plataforma MI-TOGA, cubriendo aspectos de performance, escalabilidad, seguridad, disponibilidad y restricciones técnicas.

- **Gap:** Escalar a BD con índices full-text cuando haya 1000+ tutores

### RNF-002: Escalabilidad

---

**Total de Requisitos No Funcionales:** 35  - Usuarios concurrentes esperados:

## 2. Escalabilidad

**Categorías Principales:** 10  - Crecimiento anual estimado:

### RNF-010: Concurrencia de Usuarios

- **Requisito:** Soportar 500 sesiones simultáneas (año 1)**Nivel de Criticidad:** ALTO para seguridad y disponibilidad

- **Fuente:** PROYECTO_CONTEXTO.md - Volumetría

- **Estado:** ❌ No validado

- **Estrategia:** Hosting serverless (Vercel) + CDN (Cloudflare)

---## 2. Disponibilidad y Confiabilidad

### RNF-011: Crecimiento de BD

- **Requisito:** 1,000 usuarios año 1 → 10,000 año 3

- **Estado:** ❌ Pendiente diseño de BD

- **Estrategia:** PostgreSQL con particionamiento por año## 1️⃣ Performance y Escalabilidad### RNF-003: Disponibilidad (Uptime)



### RNF-012: Escalabilidad de Videollamadas- **SLA**: 99.9%

- **Requisito:** 100 sesiones paralelas (pico)

- **Estado:** ❌ Pendiente integración Agora/Twilio### RNF-001: Tiempo de Respuesta de Páginas Web- **Horario Crítico**: 24/7 / Lunes-Viernes

- **Consideración:** Costo por minuto vs capacidad



---

**Descripción:** Los tiempos de carga de páginas deben garantizar una experiencia de usuario fluida.### RNF-004: Disaster Recovery

## 3. Disponibilidad

- **RPO** (Recovery Point Objective): < 1 hora

### RNF-020: Uptime

- **Requisito:** > 99.9% (8.76h downtime/año máximo)**Requisitos:**- **RTO** (Recovery Time Objective): < 4 horas

- **Fuente:** PROYECTO_CONTEXTO.md - KPIs Técnicos

- **Estado:** ⚠️ Dependiente de Vercel SLA- **Página de inicio (marketplace):** < 2 segundos (p95)

- **Monitoreo:** Uptime Robot + Sentry

- **Perfiles de tutor:** < 1.5 segundos (p95)

### RNF-021: Tiempo de Recuperación (RTO)

- **Requisito:** < 1 hora- **Dashboards:** < 2 segundos (p95)## 3. Seguridad

- **Estado:** ❌ Plan de DR no definido

- **Estrategia:** Backups automáticos diarios, rollback rápido- **Core Web Vitals:**



### RNF-022: Punto de Recuperación (RPO)  - LCP (Largest Contentful Paint): < 2.5s### RNF-005: Autenticación

- **Requisito:** < 15 minutos de pérdida de datos

- **Estado:** ❌ Pendiente  - FID (First Input Delay): < 100ms- [ ] Usuario/Contraseña

- **Estrategia:** Replicación de BD en tiempo real

  - CLS (Cumulative Layout Shift): < 0.1- [ ] OAuth 2.0

---

- [ ] MFA

## 4. Seguridad

**Medición:** Google Lighthouse, Web Vitals API  

### RNF-030: Autenticación

- **Requisito:** JWT con refresh tokens + OAuth social**Fuente:** PROYECTO_CONTEXTO.md - "Métricas Técnicas"  ### RNF-006: Encriptación

- **Estado:** ⚠️ Mock actual, JWT pendiente

- **Fuente:** PROYECTO_CONTEXTO.md - Stack Backend**Prioridad:** Must Have (MVP)- Datos en tránsito: TLS 1.3

- **Validación:** Tokens con expiración 24h, refresh 7d

- Datos en reposo: AES-256

### RNF-031: Encriptación de Datos en Tránsito

- **Requisito:** HTTPS/TLS 1.3---

- **Estado:** ✅ Cumplido (Vercel auto-HTTPS)

### RNF-007: Compliance

### RNF-032: Encriptación de Datos en Reposo

- **Requisito:** Contraseñas con bcrypt/argon2, datos sensibles encriptados### RNF-002: Tiempo de Respuesta de APIs- [ ] GDPR

- **Estado:** ❌ Pendiente implementación

- **Estándar:** OWASP Top 10- [ ] PCI-DSS



### RNF-033: Cumplimiento GDPR/LOPD**Descripción:** Las APIs backend deben responder rápidamente para garantizar UX responsiva.- [ ] HIPAA

- **Requisito:** Consentimiento de cookies, derecho al olvido

- **Estado:** ❌ No implementado- [ ] SOC 2

- **Acciones:** Política de privacidad, banner de cookies, export de datos

**Requisitos:**

### RNF-034: PCI-DSS (Pagos)

- **Requisito:** Cumplimiento PCI-DSS nivel 1- **Endpoints simples (GET por ID):** < 100ms (p95)

- **Estado:** ✅ Delegado a Stripe/PayU (no almacenar tarjetas)

- **Validación:** Usar tokens únicos, no guardar CVV- **Búsquedas y filtros:** < 300ms (p95)## 4. Restricciones Técnicas



### RNF-035: Protección contra Ataques- **Operaciones complejas (agregaciones):** < 500ms (p95)

- **Requisito:** Rate limiting, CORS, CSRF protection

- **Estado:** ⚠️ CORS configurado, rate limiting pendiente- **Transacciones (POST/PUT/DELETE):** < 1s (p95)### Tecnologías Mandatorias

- **Implementación:** Middleware Next.js + API Gateway

- **Pagos:** < 2s (p95)- Lenguaje:

---

- Framework:

## 5. Usabilidad

**Medición:** APM (Prometheus, New Relic)  - Base de datos:

### RNF-040: Diseño Responsive

- **Requisito:** Funcional en móvil (375px) a 4K (3840px)**Fuente:** build.gradle - Spring Boot Actuator + Micrometer Prometheus  - Cloud provider:

- **Estado:** ✅ Implementado (Tailwind CSS)

- **Validación:** Tested en Chrome DevTools responsive mode**Prioridad:** Must Have (Fase 2)



### RNF-041: Accesibilidad (WCAG 2.1 AA)### Presupuesto

- **Requisito:** Contraste 4.5:1, navegación por teclado, ARIA labels

- **Estado:** ⚠️ Parcial (no auditado)---- Desarrollo: $

- **Validación:** axe DevTools, Lighthouse accessibility score > 90

- Infraestructura mensual: $

### RNF-042: Internacionalización (i18n)

- **Requisito:** Soporte español (MVP) + inglés (futuro)### RNF-003: Escalabilidad de Usuarios Concurrentes

- **Estado:** ❌ Hardcoded español

- **Implementación:** next-i18next o i18next



### RNF-043: Tiempos de Aprendizaje**Descripción:** El sistema debe soportar crecimiento progresivo de usuarios.---

- **Requisito:** Usuario nuevo completa reserva en < 10 min

- **Estado:** ⚠️ No medido**Fecha de creación**: 2025-11-07

- **Estrategia:** Onboarding guiado, tooltips

**Requisitos por Fase:****Última actualización**:

---

**Versión**: 1.0

## 6. Mantenibilidad

| Fase | Usuarios Totales | Usuarios Concurrentes | Requests/segundo (RPS) |

### RNF-050: Cobertura de Tests|------|------------------|----------------------|------------------------|

- **Requisito:** > 80% (backend), > 60% (frontend)| MVP (Fase 1) | 500 | 50 | 100 RPS |

- **Estado:** ❌ 0% (no hay tests)| Fase 2 | 2,000 | 200 | 500 RPS |

- **Fuente:** Buenas prácticas estándar| Año 1 | 10,000 | 1,000 | 2,000 RPS |

- **Herramientas:** Jest + React Testing Library (frontend), Pytest/Jest (backend)| Año 3 | 50,000 | 5,000 | 10,000 RPS |



### RNF-051: Documentación de Código**Estrategia de Escalabilidad:**

- **Requisito:** JSDoc en funciones críticas, README por módulo- Escalamiento horizontal de backend (Kubernetes/ECS)

- **Estado:** ⚠️ Parcial (algunos README)- Auto-scaling basado en CPU (>70%) y memoria (>80%)

- **Gap:** Falta JSDoc, API docs- CDN para assets estáticos (CloudFront/Cloudflare)

- Cache distribuido (Redis) para sesiones y datos frecuentes

### RNF-052: Linting y Formateo- Database read replicas para queries pesadas

- **Requisito:** ESLint + Prettier configurados

- **Estado:** ✅ ESLint configurado (.eslintrc.json)**Fuente:** Análisis de volumetría + Supuestos de crecimiento  

- **Validación:** Pre-commit hooks con Husky**Prioridad:** Must Have (Fase 2 en adelante)



### RNF-053: Versionado Semántico---

- **Requisito:** Seguir SemVer (MAJOR.MINOR.PATCH)

- **Estado:** ❌ No aplicado### RNF-004: Volumen de Datos

- **Estrategia:** Conventional Commits + Semantic Release

**Descripción:** Proyección de crecimiento de datos para dimensionamiento de almacenamiento.

---

**Estimaciones:**

## 7. Portabilidad

| Entidad | Tamaño Promedio | Año 1 | Año 3 | Año 5 |

### RNF-060: Compatibilidad de Navegadores|---------|-----------------|-------|-------|-------|

- **Requisito:** Últimas 2 versiones de Chrome, Firefox, Safari, Edge| Usuarios | 2 KB | 10,000 registros (20 MB) | 50,000 (100 MB) | 200,000 (400 MB) |

- **Estado:** ✅ Next.js/React compatible| Tutores | 50 KB (con foto) | 200 registros (10 MB) | 1,000 (50 MB) | 5,000 (250 MB) |

- **Validación:** BrowserStack testing| Sesiones | 1 KB | 24,000 registros (24 MB) | 240,000 (240 MB) | 1M (1 GB) |

| Mensajes (chat) | 0.5 KB | 100,000 (50 MB) | 1M (500 MB) | 10M (5 GB) |

### RNF-061: Multiplataforma| Reseñas | 1 KB | 12,000 (12 MB) | 120,000 (120 MB) | 500,000 (500 MB) |

- **Requisito:** Web (MVP) + PWA (futuro) + apps nativas (fase 3)| **TOTAL ESTIMADO** | - | **~120 MB** | **~1 GB** | **~7 GB** |

- **Estado:** ✅ Web implementada

- **Roadmap:** PWA en Fase 2**Nota:** No incluye archivos multimedia (fotos de perfil, grabaciones). Añadir ~50% para multimedia.



---**Estrategia de Almacenamiento:**

- PostgreSQL para datos estructurados

## 8. Observabilidad- AWS S3 / Azure Blob para imágenes y archivos

- Archiving de datos antiguos (>2 años) a storage frío

### RNF-070: Logging

- **Requisito:** Logs estructurados (JSON) con niveles (error, warn, info)**Fuente:** Proyecciones basadas en modelo de negocio  

- **Estado:** ❌ Console.log básico**Prioridad:** Should Have (planificación de capacidad)

- **Herramientas:** Winston/Pino (backend), Datadog/Logtail

---

### RNF-071: Monitoring

- **Requisito:** APM con dashboards de métricas### RNF-005: Optimización de Imágenes

- **Estado:** ❌ No implementado

- **Herramientas:** Vercel Analytics + Sentry**Descripción:** Las imágenes deben optimizarse para reducir tiempos de carga.



### RNF-072: Alertas**Requisitos:**

- **Requisito:** Notificaciones de errores críticos en < 5min- Formatos modernos: WebP (con fallback a JPEG/PNG)

- **Estado:** ❌ No configurado- Lazy loading para imágenes fuera del viewport

- **Estrategia:** Sentry + PagerDuty/Slack- Responsive images con `srcset` (múltiples resoluciones)

- Compresión: calidad 80% para fotos de perfil

---- Límite de tamaño: 5 MB por imagen (antes de compresión)

- Dimensiones máximas: 1920x1920px

## 9. Resumen Cuantitativo

**Fuente:** Best practices de performance web  

| Categoría | Total RNFs | Cumplidos | Parciales | Pendientes |**Prioridad:** Should Have (MVP)

|-----------|-----------|-----------|-----------|------------|

| Performance | 3 | 1 | 1 | 1 |---

| Escalabilidad | 3 | 0 | 0 | 3 |

| Disponibilidad | 3 | 0 | 1 | 2 |## 2️⃣ Disponibilidad y Confiabilidad

| Seguridad | 6 | 2 | 2 | 2 |

| Usabilidad | 4 | 1 | 2 | 1 |### RNF-006: Disponibilidad (Uptime)

| Mantenibilidad | 4 | 1 | 1 | 2 |

| Portabilidad | 2 | 1 | 0 | 1 |**Descripción:** La plataforma debe estar disponible de forma confiable.

| Observabilidad | 3 | 0 | 0 | 3 |

| **TOTAL** | **28** | **6 (21%)** | **7 (25%)** | **15 (54%)** |**Requisitos:**

- **SLA Target:** 99.5% uptime (3.65 horas downtime/mes)

---- **Meta aspiracional:** 99.9% uptime (43 minutos downtime/mes)

- **Horario crítico:** Lunes-Domingo 6:00-23:00 hora Colombia

## 10. Priorización por Impacto- **Ventanas de mantenimiento:** Domingos 2:00-5:00 AM (previa notificación)



### 🔴 Crítico (Bloqueante MVP)**Componentes Críticos:**

- RNF-030 (JWT), RNF-032 (Encriptación), RNF-034 (PCI-DSS), RNF-050 (Tests)- Frontend (Next.js): 99.9%

- Backend API (Spring Boot): 99.9%

### 🟠 Alto (Prioridad Fase 1-2)- Base de datos (PostgreSQL): 99.95%

- RNF-001 (Performance), RNF-020 (Uptime), RNF-035 (Ataques), RNF-041 (Accesibilidad), RNF-071 (Monitoring)- Sistema de pagos: 99.99%



### 🟡 Medio (Fase 2-3)**Fuente:** Estándares de industria para SaaS B2C  

- RNF-011 (Escalabilidad BD), RNF-033 (GDPR), RNF-042 (i18n), RNF-053 (Versionado), RNF-070 (Logging)**Prioridad:** Must Have (Fase 2 en adelante)



### 🟢 Bajo (Mejora Continua)---

- RNF-022 (RPO), RNF-043 (Aprendizaje), RNF-061 (Apps nativas), RNF-072 (Alertas)

### RNF-007: Disaster Recovery

---

**Descripción:** Estrategia para recuperación ante desastres.

**Documento:** ZNS v2.0 - RNFs extraídos de KPIs técnicos + buenas prácticas estándar  

**Gap Principal:** Backend no implementado (14 RNFs pendientes dependen de backend)  **Requisitos:**

**Recomendación:** Priorizar RNFs de seguridad y performance antes de lanzar MVP.- **RPO (Recovery Point Objective):** < 1 hora (pérdida de datos aceptable)

- **RTO (Recovery Time Objective):** < 4 horas (tiempo de recuperación)

**Estrategia de Backup:**
- Base de datos:
  - Backups automáticos incrementales cada 6 horas
  - Backup completo diario (retención: 30 días)
  - Punto de restauración (PITR) disponible
- Archivos (S3/Blob):
  - Versionado habilitado
  - Replicación cross-region
- Código:
  - Git como fuente de verdad
  - Tagged releases para rollback

**Réplica Geográfica:**
- ⚠️ SUPUESTO: No requerida en MVP
- Fase 4+: Base de datos read replica en región secundaria

**Fuente:** Best practices de DevOps + Supuestos  
**Prioridad:** Must Have (Fase 2)

---

### RNF-008: Tolerancia a Fallos

**Descripción:** El sistema debe continuar operando ante fallos parciales.

**Requisitos:**
- **No Single Point of Failure (SPOF):** Mínimo 2 instancias de cada servicio crítico
- **Circuit Breaker:** Para llamadas a servicios externos (pagos, videollamadas)
- **Degradación Gradual:**
  - Si falla chat: marketplace y agendamiento siguen funcionando
  - Si falla sistema de pagos: se permite agendar con "pago pendiente"
  - Si falla videollamada: se proporciona enlace alternativo (Zoom/Meet)
- **Health Checks:** Endpoints `/actuator/health` en todos los servicios
- **Auto-healing:** Kubernetes/ECS reinicia contenedores unhealthy automáticamente

**Fuente:** Spring Boot Actuator (build.gradle) + Arquitectura de microservicios  
**Prioridad:** Should Have (Fase 2-3)

---

### RNF-009: Tasa de Error Aceptable

**Descripción:** Límites de errores para garantizar calidad del servicio.

**Requisitos:**
- **Errores HTTP 5xx:** < 0.1% de requests
- **Errores HTTP 4xx:** < 5% de requests
- **Errores de JavaScript (frontend):** < 0.5% de sesiones
- **Transacciones fallidas (pagos):** < 1%

**Monitoreo y Alertas:**
- Alertas automáticas si tasa de error > umbral por 5 minutos
- Dashboard de errores en tiempo real
- Logs centralizados para troubleshooting

**Fuente:** Estándares de calidad de software  
**Prioridad:** Must Have (Fase 2)

---

## 3️⃣ Seguridad

### RNF-010: Autenticación y Autorización

**Descripción:** Mecanismos para asegurar identidad y permisos.

**Requisitos de Autenticación:**
- **MVP (Fase 1):** Session-based con localStorage (temporal)
- **Fase 2+:** JWT (JSON Web Tokens)
  - Access token: expiración 15 minutos
  - Refresh token: expiración 7 días
  - Almacenamiento: httpOnly cookies (prevenir XSS)
- **Fase 3:** OAuth 2.0 (Google, Facebook)
- **Fase 5:** Autenticación de dos factores (TOTP)

**Modelo de Autorización:**
- **RBAC (Role-Based Access Control)**
- Roles: ESTUDIANTE, TUTOR, ADMIN
- Permisos granulares por endpoint
- Validación de permisos en backend (nunca solo frontend)

**Fuente:** build.gradle - Spring Security, JWT 0.11.5  
**Prioridad:** Must Have (Fase 2)

---

### RNF-011: Protección de Datos Sensibles

**Descripción:** Encriptación de información confidencial.

**Requisitos:**

**Datos en Tránsito:**
- **TLS 1.3** (mínimo TLS 1.2)
- Certificados SSL/TLS válidos (Let's Encrypt, DigiCert)
- HSTS (HTTP Strict Transport Security) habilitado
- Todos los endpoints HTTPS obligatorio

**Datos en Reposo:**
- Contraseñas: **bcrypt** con cost factor ≥ 12
- Datos sensibles en BD (tarjetas, documentos): **AES-256-GCM**
- Tokens y secrets: Vault (Spring Cloud Vault) o AWS Secrets Manager

**PII (Personally Identifiable Information):**
- Nombres, emails, teléfonos: encriptados a nivel de aplicación
- Derecho al olvido: eliminación segura (GDPR Art. 17)
- Anonimización para analytics

**Fuente:** build.gradle - Spring Cloud Vault, Spring Security  
**Prioridad:** Must Have (Fase 2)

---

### RNF-012: Seguridad de Contraseñas

**Descripción:** Política de contraseñas robusta.

**Requisitos:**
- **Longitud mínima:** 8 caracteres
- **Composición:** Al menos 1 mayúscula, 1 minúscula, 1 número
- **Recomendado:** 1 carácter especial (@, #, $, etc.)
- **Prohibido:** Contraseñas comunes (lista de 10,000+ passwords débiles)
- **Expiración:** No obligatoria (NIST recomienda NO forzar cambio periódico)
- **Reutilización:** No permitir últimas 5 contraseñas
- **Fuerza:** Indicador visual de fortaleza al registrarse
- **Storage:** bcrypt con salt aleatorio por usuario

**Fuente:** NIST SP 800-63B + build.gradle (Spring Security)  
**Prioridad:** Must Have (MVP)

---

### RNF-013: Protección contra Ataques Comunes

**Descripción:** Mitigación de vulnerabilidades OWASP Top 10.

**Requisitos:**

| Vulnerabilidad | Mitigación |
|----------------|------------|
| **SQL Injection** | JPA/Hibernate con prepared statements, validación de inputs |
| **XSS (Cross-Site Scripting)** | Sanitización de inputs, CSP headers, React escape automático |
| **CSRF (Cross-Site Request Forgery)** | CSRF tokens en formularios, SameSite cookies |
| **Broken Authentication** | Límite de intentos (5), bloqueo temporal (15 min), 2FA |
| **Sensitive Data Exposure** | Encriptación TLS, no logs de datos sensibles |
| **Broken Access Control** | Validación de permisos server-side, no confiar en frontend |
| **Security Misconfiguration** | Headers de seguridad (X-Frame-Options, X-Content-Type-Options) |
| **Insecure Deserialization** | Validación de JSON, no deserializar objetos no confiables |
| **Using Components with Known Vulnerabilities** | Dependabot, Snyk, actualizaciones regulares |
| **Insufficient Logging & Monitoring** | Logs de eventos de seguridad, alertas de actividad sospechosa |

**Fuente:** OWASP Top 10 2021 + Spring Security  
**Prioridad:** Must Have (Fase 2)

---

### RNF-014: Rate Limiting

**Descripción:** Protección contra abuso de APIs.

**Requisitos:**

| Endpoint | Límite | Ventana | Acción |
|----------|--------|---------|--------|
| Login | 5 intentos | 15 min | Bloqueo temporal + CAPTCHA |
| Registro | 3 registros | 1 hora | Bloqueo por IP |
| Búsqueda | 60 requests | 1 min | HTTP 429 (Too Many Requests) |
| APIs generales | 1000 requests | 1 hora | HTTP 429 |
| Pagos | 10 requests | 10 min | HTTP 429 + alerta |

**Implementación:** Spring Cloud Gateway + Redis para distributed rate limiting  
**Fuente:** Best practices de seguridad API  
**Prioridad:** Should Have (Fase 2)

---

### RNF-015: Auditoría y Logging de Seguridad

**Descripción:** Registro de eventos críticos para auditoría.

**Eventos a Auditar:**
1. Autenticación (login exitoso/fallido, logout)
2. Cambios de contraseña
3. Cambios de permisos/roles
4. Acceso a datos sensibles (perfiles, pagos)
5. Transacciones financieras
6. Cambios de configuración (admin)
7. Eliminación de datos

**Formato de Log:**
```json
{
  "timestamp": "2025-11-08T10:30:00Z",
  "event_type": "LOGIN_SUCCESS",
  "user_id": "uuid",
  "ip_address": "192.168.1.1",
  "user_agent": "Mozilla/5.0...",
  "trace_id": "abc123"
}
```

**Retención:**
- Logs operacionales: 90 días
- Logs de auditoría de seguridad: 1 año
- Logs financieros: 7 años (requisito legal Colombia)

**Fuente:** Compliance GDPR + Regulaciones financieras  
**Prioridad:** Must Have (Fase 2)

---

## 4️⃣ Compliance y Regulaciones

### RNF-016: GDPR (Reglamento General de Protección de Datos)

**Descripción:** Cumplimiento con regulación europea de privacidad.

**Requisitos:**
1. **Consentimiento explícito:** Banner de cookies, opt-in para marketing
2. **Derecho de acceso:** Usuario puede descargar todos sus datos (portabilidad)
3. **Derecho al olvido:** Usuario puede solicitar eliminación completa
4. **Minimización de datos:** Solo recopilar datos necesarios
5. **Seguridad by design:** Encriptación, pseudonimización
6. **Notificación de brechas:** Reportar a autoridades en 72h
7. **Data Protection Officer (DPO):** ⚠️ Si se procesan > 250 datos personales

**Aplicabilidad:** ⚠️ Solo si hay usuarios en Europa (a confirmar)  
**Fuente:** GDPR Art. 5, 17, 20, 32, 33  
**Prioridad:** Should Have (si aplica)

---

### RNF-017: Ley de Habeas Data (Colombia)

**Descripción:** Cumplimiento con legislación colombiana de protección de datos.

**Requisitos:**
1. **Autorización previa:** Consentimiento informado para recolección de datos
2. **Política de privacidad:** Clara, accesible, en español
3. **Finalidad:** Uso de datos solo para propósito declarado
4. **Derechos ARCOP:** Acceso, Rectificación, Cancelación, Oposición, Portabilidad
5. **Responsable de datos:** Designar responsable de atención de solicitudes
6. **Registro en SIC:** ⚠️ Si se procesan datos sensibles (a validar)

**Fuente:** Ley 1581 de 2012 (Colombia)  
**Prioridad:** Must Have (opera en Colombia)

---

### RNF-018: PCI-DSS (Pagos con Tarjeta)

**Descripción:** Cumplimiento con estándar de seguridad de pagos.

**Requisitos:**
- **NO almacenar datos de tarjetas:** Usar tokenización de Stripe/PayU
- **Scope reducido:** Iframe/redirect a pasarela certificada
- **HTTPS obligatorio:** En todas las páginas con formularios de pago
- **Logs de transacciones:** Almacenar de forma segura
- **Auditorías:** Anuales si se procesan >1M transacciones/año

**Estrategia:** Delegar a pasarela certificada PCI-DSS Level 1 (Stripe/PayU)  
**Fuente:** PCI-DSS v4.0  
**Prioridad:** Must Have (Fase 4 - Pagos)

---

## 5️⃣ Usabilidad y Accesibilidad

### RNF-019: Responsive Design

**Descripción:** La plataforma debe funcionar en todos los dispositivos.

**Requisitos:**
- **Mobile-first approach:** Diseño desde 320px (iPhone SE)
- **Breakpoints Tailwind:**
  - Mobile: < 640px (1 columna)
  - Tablet: 768px - 1024px (2-3 columnas)
  - Desktop: > 1024px (3-4 columnas)
- **Touch-friendly:** Botones mínimo 44x44px
- **Orientación:** Soporte portrait y landscape
- **Testing:** Chrome DevTools + BrowserStack en dispositivos reales

**Fuente:** PROYECTO_CONTEXTO.md - "Responsive Breakpoints"  
**Prioridad:** Must Have (MVP)

---

### RNF-020: Accesibilidad (WCAG 2.1)

**Descripción:** La plataforma debe ser usable por personas con discapacidades.

**Requisitos:**
- **Nivel objetivo:** WCAG 2.1 Level AA
- **Contraste de colores:** Mínimo 4.5:1 (texto normal), 3:1 (texto grande)
- **Navegación por teclado:** Todos los elementos interactivos accesibles sin mouse
- **Screen readers:** Etiquetas ARIA, texto alternativo en imágenes
- **Formularios:** Labels asociados, mensajes de error claros
- **Focus visible:** Indicador claro de elemento enfocado
- **No dependencia de color:** Usar iconos/texto además de color

**Testing:** axe DevTools, WAVE, NVDA/JAWS  
**Fuente:** WCAG 2.1 estándar  
**Prioridad:** Should Have (MVP)

---

### RNF-021: Internacionalización (i18n)

**Descripción:** Preparación para soporte multi-idioma.

**Requisitos de MVP:**
- **Idioma único:** Español (Colombia)
- **Formato de fechas:** DD/MM/YYYY
- **Formato de moneda:** COP $XX,XXX
- **Zona horaria:** America/Bogota (UTC-5)

**Requisitos Futuros (Fase 5):**
- Soporte para inglés (expansión internacional)
- Selector de idioma en header
- Traducciones externalizadas (i18next)
- Pluralización correcta

**Fuente:** Roadmap de expansión LATAM  
**Prioridad:** Nice to Have (Fase 5)

---

## 6️⃣ Compatibilidad y Navegadores

### RNF-022: Soporte de Navegadores

**Descripción:** Navegadores y versiones soportadas.

**Requisitos:**

| Navegador | Versión Mínima | Notas |
|-----------|----------------|-------|
| Chrome | Últimas 2 versiones | Navegador primario (80%+ usuarios) |
| Firefox | Últimas 2 versiones | Soporte completo |
| Safari | Últimas 2 versiones | Importante para iOS |
| Edge | Últimas 2 versiones | Basado en Chromium |
| Mobile Safari (iOS) | iOS 14+ | Crítico para mobile |
| Chrome Mobile (Android) | Android 10+ | Crítico para mobile |

**NO soportados:** Internet Explorer, navegadores obsoletos  
**Estrategia:** Progressive enhancement, feature detection  
**Fuente:** Estadísticas de uso en Colombia  
**Prioridad:** Must Have (MVP)

---

### RNF-023: Progressive Web App (PWA)

**Descripción:** Características de aplicación web progresiva.

**Requisitos (Fase 5):**
- Manifest.json con iconos y metadata
- Service Worker para offline básico
- Instalable en home screen
- Push notifications (con consentimiento)
- Modo offline: mostrar "Sin conexión" gracefully

**Beneficios:** Mejor engagement, iconos en dispositivos móviles  
**Fuente:** PROYECTO_CONTEXTO.md - "Roadmap Fase 5 - PWA capabilities"  
**Prioridad:** Nice to Have (Fase 5)

---

## 7️⃣ Mantenibilidad y Operabilidad

### RNF-024: Código y Arquitectura

**Descripción:** Estándares de calidad de código.

**Requisitos:**

**Frontend (Next.js + TypeScript):**
- TypeScript strict mode habilitado
- ESLint configurado y passing
- Componentes pequeños (< 300 líneas)
- Props tipadas con interfaces
- Testing: cobertura > 70% (Jest + React Testing Library)

**Backend (Spring Boot + Java 21):**
- Java 21 features aprovechadas (records, pattern matching)
- Clean Architecture / Hexagonal
- SOLID principles
- Testing: cobertura > 80% (JUnit 5 + Mockito)
- SonarQube quality gate: A rating

**Fuente:** build.gradle + PROYECTO_CONTEXTO.md "Estándares de Código"  
**Prioridad:** Must Have (todas las fases)

---

### RNF-025: Documentación

**Descripción:** Documentación técnica completa y actualizada.

**Requisitos:**

**Documentación de APIs:**
- OpenAPI 3.0 spec (Swagger)
- Ejemplos de requests/responses
- Códigos de error documentados
- Autenticación explicada

**Documentación de Código:**
- README.md en cada repo (setup, comandos, arquitectura)
- Javadoc para clases/métodos públicos
- JSDoc para funciones TypeScript complejas
- Architecture Decision Records (ADRs) para decisiones importantes

**Documentación de Usuario:**
- FAQs para estudiantes y tutores
- Guías de "Cómo usar" con screenshots
- Política de privacidad y términos de servicio

**Fuente:** build.gradle - SpringDoc OpenAPI 2.8.9  
**Prioridad:** Should Have (Fase 2)

---

### RNF-026: Monitoreo y Observabilidad

**Descripción:** Visibilidad del estado y comportamiento del sistema.

**Requisitos:**

**Métricas (Prometheus + Grafana):**
- CPU, memoria, disco de servidores
- Request rate, error rate, duration (RED method)
- Métricas de negocio: registros/día, sesiones/día, ingresos/día
- JVM metrics (heap, garbage collection)

**Logging (ELK / CloudWatch):**
- Logs estructurados (JSON)
- Niveles: ERROR, WARN, INFO, DEBUG
- Contexto: trace_id, user_id, timestamp
- Centralización de logs de todos los servicios

**Tracing Distribuido (Jaeger / X-Ray):**
- Trazas de requests entre microservicios
- Identificación de bottlenecks
- Latencia por componente

**Alerting (PagerDuty / Slack):**
- CPU > 85% por 5 minutos
- Error rate > 1% por 5 minutos
- Downtime detectado
- Disk > 90%

**Fuente:** build.gradle - Micrometer Prometheus, Spring Boot Actuator  
**Prioridad:** Must Have (Fase 2)

---

### RNF-027: Despliegue y CI/CD

**Descripción:** Pipeline automatizado de despliegue.

**Requisitos:**

**Control de Versiones:**
- Git (GitHub/GitLab)
- Branching: GitFlow (main, develop, feature/*, hotfix/*)
- Pull Requests con code review obligatorio
- Commits convencionales (Conventional Commits)

**CI Pipeline:**
- Build automático en cada push
- Ejecución de tests (unit, integration)
- Análisis de código (SonarQube, ESLint)
- Build de Docker images
- Tag de versión (semantic versioning)

**CD Pipeline:**
- Deploy automático a DEV en merge a develop
- Deploy manual a STAGING
- Deploy manual a PROD (con aprobación)
- Rollback automático si healthcheck falla
- Blue-Green deployment para zero-downtime

**Entornos:**
- DEV: desarrollo activo
- STAGING: replica de producción para testing
- PROD: producción

**Fuente:** Best practices DevOps  
**Prioridad:** Must Have (Fase 2)

---

## 8️⃣ Infraestructura y Deployment

### RNF-028: Stack Tecnológico

**Descripción:** Tecnologías mandatorias para el proyecto.

**Requisitos:**

**Frontend:**
- Framework: **Next.js 16.0+** con App Router
- Lenguaje: **TypeScript 5.9+**
- UI Library: **React 19.2+**
- Estilos: **Tailwind CSS 4.1+**
- Iconos: **Heroicons**
- Build: **Vite** (Next.js incluye)

**Backend:**
- Framework: **Spring Boot 3.5.5+**
- Lenguaje: **Java 21**
- Build Tool: **Gradle 8+**
- ORM: **Spring Data JPA + Hibernate**

**Base de Datos:**
- **PostgreSQL 15+** (relacional principal)
- **Redis 7+** (cache y sesiones) - Fase 2

**Infraestructura:**
- Contenedores: **Docker**
- Orquestación: **Kubernetes** o **AWS ECS** - Fase 3
- Cloud Provider: ⚠️ AWS (recomendado) o Azure

**Fuente:** PROYECTO_CONTEXTO.md + build.gradle  
**Prioridad:** Must Have (definido)

---

### RNF-029: Ambientes Cloud

**Descripción:** Configuración de ambientes en la nube.

**Requisitos:**

**Opción A: AWS**
- Compute: ECS Fargate o EC2 + ALB
- Database: RDS PostgreSQL (Multi-AZ)
- Storage: S3 para archivos
- CDN: CloudFront
- Secrets: Secrets Manager
- Monitoring: CloudWatch

**Opción B: Azure**
- Compute: Azure Container Apps o App Service
- Database: Azure Database for PostgreSQL
- Storage: Azure Blob Storage
- CDN: Azure CDN
- Secrets: Key Vault
- Monitoring: Azure Monitor

**Networking:**
- HTTPS obligatorio (certificado SSL)
- WAF (Web Application Firewall) - Fase 3
- DDoS protection
- Dominio personalizado: ⚠️ mitoga.co (a confirmar)

**Fuente:** build.gradle - Spring Cloud Vault (multi-cloud)  
**Prioridad:** Must Have (Fase 2)

---

### RNF-030: Costos de Infraestructura

**Descripción:** Estimación y límites de costos cloud.

**Estimaciones Mensuales (USD):**

| Servicio | MVP | Fase 2 | Año 1 | Año 3 |
|----------|-----|--------|-------|-------|
| Compute (containers) | $50 | $200 | $500 | $2,000 |
| Database (RDS/Managed) | $100 | $200 | $500 | $1,500 |
| Storage (S3/Blob) | $10 | $50 | $200 | $800 |
| CDN | $20 | $50 | $150 | $500 |
| Monitoring | $20 | $50 | $100 | $300 |
| Secrets Management | $10 | $20 | $50 | $100 |
| Otros (DNS, etc.) | $10 | $30 | $50 | $100 |
| **TOTAL** | **$220** | **$600** | **$1,550** | **$5,300** |

**Notas:**
- No incluye servicios de Fase 3-4 (videollamadas, pagos)
- Videollamadas (Agora): ~$500-2,000/mes según uso
- Pasarela de pagos: % de transacciones (no costo fijo)

**Estrategia de Optimización:**
- Reserved Instances / Savings Plans (30-40% descuento)
- Auto-scaling para ajustar capacidad
- S3 Intelligent-Tiering para archivos antiguos
- Spot Instances para workloads no críticos

**Fuente:** Calculadoras AWS/Azure + Supuestos  
**Prioridad:** Must Have (planificación financiera)

---

## 9️⃣ Integraciones Externas

### RNF-031: Pasarela de Pagos

**Descripción:** Integración con proveedor de pagos.

**Requisitos:**

**Proveedor:** Stripe (preferido) o PayU Colombia
- Soporte para Colombia (COP)
- Métodos: Tarjetas, PSE, Nequi, Daviplata
- Comisión: ~3.5% + COP $900/transacción
- Tiempo de liquidación: 2-3 días hábiles
- API REST bien documentada
- Webhooks para eventos
- Dashboard de administración
- Soporte técnico 24/7

**Certificaciones:** PCI-DSS Level 1  
**Fuente:** Análisis de pasarelas en Colombia  
**Prioridad:** Must Have (Fase 4)

---

### RNF-032: Videollamadas

**Descripción:** Integración con proveedor de videollamadas.

**Requisitos:**

**Proveedor:** Agora.io (preferido) o Twilio Video
- WebRTC real-time communication
- Calidad adaptativa (1080p → 360p según bandwidth)
- Latencia < 200ms
- Soporte para screen sharing
- Grabación en cloud (opcional)
- SDK para web y mobile
- Comisión: ~$0.99/1,000 minutos

**Fuente:** Análisis de proveedores de video  
**Prioridad:** Must Have (Fase 3)

---

### RNF-033: Servicio de Emails

**Descripción:** Envío transaccional y marketing de emails.

**Requisitos:**

**Proveedor:** SendGrid, AWS SES, o Mailgun
- SMTP/API para envío
- Plantillas HTML personalizables
- Tracking de apertura/clicks
- Deliverability > 98%
- Límite: ⚠️ 10,000 emails/mes gratis (SendGrid)
- Manejo de bounces y unsubscribes

**Tipos de Emails:**
- Verificación de cuenta
- Recuperación de contraseña
- Confirmación de sesión
- Recordatorios
- Notificaciones

**Fuente:** build.gradle - Spring Boot Mail  
**Prioridad:** Must Have (Fase 2)

---

## 🔟 Testing y Calidad

### RNF-034: Cobertura de Testing

**Descripción:** Niveles mínimos de cobertura de tests.

**Requisitos:**

| Tipo de Test | Cobertura Mínima | Herramientas |
|--------------|------------------|--------------|
| **Unit Tests** | 80% | JUnit 5, Mockito (backend); Jest (frontend) |
| **Integration Tests** | 60% | Spring Boot Test, Testcontainers; Supertest |
| **E2E Tests** | Critical paths (login, agendamiento, pago) | Cypress, Playwright |
| **API Tests** | Todos los endpoints públicos | Postman/Newman, REST Assured |

**Ejecución:**
- Localmente antes de cada commit
- CI pipeline en cada push
- Nightly builds para E2E completos

**Fuente:** build.gradle - JUnit, Mockito  
**Prioridad:** Must Have (Fase 2)

---

### RNF-035: Estrategia de Testing

**Descripción:** Pirámide de testing y estrategia general.

**Pirámide de Testing:**
```
         E2E (10%)
      Integration (30%)
    Unit Tests (60%)
```

**Tipos de Testing:**

1. **Unit Tests:** Funciones/métodos individuales, mocks de dependencias
2. **Integration Tests:** Integración entre componentes, database real (Testcontainers)
3. **E2E Tests:** Flujos completos de usuario, navegador real
4. **Performance Tests:** Load testing con JMeter/k6 (pre-production)
5. **Security Tests:** OWASP ZAP, Snyk, Dependabot
6. **Accessibility Tests:** axe-core, Pa11y
7. **Manual QA:** Antes de cada release a producción

**Criterio de Aceptación:**
- Todos los tests pasan antes de merge
- No disminuir cobertura de tests
- Tests deben ejecutarse en < 10 minutos (CI)

**Fuente:** Best practices de testing  
**Prioridad:** Must Have (Fase 2)

---

## 📊 Matriz de Priorización

### Resumen por Prioridad

| Prioridad | Cantidad | RNFs |
|-----------|----------|------|
| **Must Have (MVP-Fase 2)** | 20 | RNF-001 al RNF-012, RNF-019, RNF-022, RNF-024 al RNF-029, RNF-033 al RNF-035 |
| **Should Have (Fase 2-4)** | 10 | RNF-008, RNF-014, RNF-016, RNF-017, RNF-020, RNF-025 |
| **Nice to Have (Fase 5+)** | 5 | RNF-021, RNF-023, RNF-041 (del doc funcionales) |

---

## 📝 Supuestos y Gaps Críticos

### Supuestos Realizados

1. **Cloud provider:** Asumido AWS, pero puede ser Azure (stack es cloud-agnostic)
2. **Volumetría:** Basada en proyecciones de modelo de negocio (no validado)
3. **SLA:** 99.5% asumido, no hay contrato formal definido
4. **Compliance GDPR:** Solo si hay usuarios en Europa (a confirmar)
5. **Costos:** Estimaciones, no hay presupuesto aprobado

### Gaps Identificados

1. **⚠️ SLA formal:** No hay acuerdo de nivel de servicio definido
2. **⚠️ Presupuesto cloud:** No hay límite de gasto mensual aprobado
3. **⚠️ Región de deployment:** No definida (us-east-1? sa-east-1?)
4. **⚠️ Backup testing:** No hay plan de simulacros de disaster recovery
5. **⚠️ Penetration testing:** No hay plan de pruebas de seguridad externas

---

## ✅ Validación y Aprobación

| Acción | Estado | Responsable | Fecha |
|--------|--------|-------------|-------|
| Aprobar SLA y RTO/RPO | ⏸️ Pendiente | CTO + Product Owner | ⚠️ TBD |
| Confirmar presupuesto cloud | ⏸️ Pendiente | CFO | ⚠️ TBD |
| Validar stack tecnológico | ⏸️ Pendiente | Tech Lead | ⚠️ TBD |
| Aprobar política de seguridad | ⏸️ Pendiente | CISO / Security Lead | ⚠️ TBD |
| Confirmar compliance requerido | ⏸️ Pendiente | Legal | ⚠️ TBD |

---

**Documento generado por:** GitHub Copilot - Solutions Architect  
**Fecha:** 8 de noviembre de 2025  
**Método:** ZNS v2.0 - Fase 0 Consolidación de Contexto  
**Fuentes:** PROYECTO_CONTEXTO.md, build.gradle, estándares de industria  
**Nivel de confianza:** 🟡 MEDIO (70%) - Muchos RNF son supuestos que requieren validación  
**Próximos pasos:** Validación con Tech Lead, definición de SLAs, aprobación de presupuesto
