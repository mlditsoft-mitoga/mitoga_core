# HU-065: Configurar Comisiones y Tarifas de Plataforma

## 📋 Historia de Usuario

**Como** administrador con permisos financieros,  
**Quiero** configurar los porcentajes de comisión que cobra la plataforma,  
**Para** ajustar el modelo de ingresos según estrategia de negocio.

## 🎯 Valor de Negocio

Flexibilidad para ajustar pricing según competencia, promociones o segmentos de tutores.

**Impacto:** Revenue optimizado, Capacidad de lanzar promociones

## 📝 Descripción Detallada

Panel de configuración financiera con campos: Comisión general (%), Comisión por categoría (Programación: 20%, Idiomas: 15%), Tarifa mínima por sesión, Tarifa de cancelación. Cambios aplican solo a nuevas reservas (no retroactivos). Historial de cambios de comisión con audit log.

## ✅ Criterios de Aceptación

### Escenario 1: Ver configuración actual de comisiones

**Cuando** navego a "Configuración" → "Comisiones"  
**Entonces** veo:
- Comisión General: 18% (aplica por defecto)
- Comisiones por Categoría:
  - Programación: 20%
  - Idiomas: 15%
  - Matemáticas: 18% (usa general)
- Tarifa Mínima Sesión: $20,000 COP
- Tarifa Cancelación (< 24h): $5,000 COP

### Escenario 2: Cambiar comisión general

**Cuando** cambio "Comisión General" de 18% a 20%  
**Y** hago clic en [Guardar Cambios]  
**Entonces** veo confirmación: "Cambios guardados. Aplicarán a nuevas reservas desde hoy"  
**Y** se registra en audit log: "Admin [nombre] cambió comisión general: 18% → 20%"  
**Y** reservas existentes mantienen comisión antigua

### Escenario 3: Configurar comisión especial por categoría

**Cuando** quiero lanzar promoción en categoría "Programación"  
**Y** cambio comisión de 20% a 10% temporalmente  
**Entonces** las nuevas reservas de Programación tienen comisión 10%  
**Y** otras categorías mantienen sus comisiones

### Escenario 4: Ver historial de cambios

**Cuando** hago clic en "Ver Historial"  
**Entonces** veo tabla cronológica:
- 08/11/2025: Comisión general 18% → 20% (Admin: Juan)
- 01/11/2025: Comisión Programación 20% → 10% (Admin: María)
- 15/10/2025: Tarifa mínima $15,000 → $20,000 (Admin: Juan)

### Escenario 5: Validación de rangos

**Cuando** intento poner comisión de 50%  
**Entonces** veo error: "La comisión debe estar entre 5% y 30%"  
**Y** no se guarda el cambio

## 🔗 Trazabilidad

- **Módulo:** Admin
- **RF:** RF-033 (Configurar comisión)
- **Prioridad:** MUST HAVE

## 📊 Estimación

- **Story Points:** 3
- **Complejidad:** Baja (CRUD simple)

## 🔄 Dependencias

- Depende de: HU-033 (Calcular comisión plataforma)
- Relacionada con: HU-030 (Procesar pago)

## 🧪 Testing

- Cambios aplicados solo a nuevas reservas
- Validaciones de rangos
- Audit log registrado
- Cálculos de comisión correctos

## 📌 Etiquetas

`#admin` `#finanzas` `#comisiones` `#configuracion` `#release-1.0`
