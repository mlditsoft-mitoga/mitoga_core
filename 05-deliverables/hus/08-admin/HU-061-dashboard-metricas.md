# HU-061: Dashboard de Métricas de la Plataforma

## 📋 Historia de Usuario

**Como** administrador,  
**Quiero** ver métricas clave de la plataforma en un dashboard visual,  
**Para** monitorear el crecimiento y salud del negocio en tiempo real.

## 🎯 Valor de Negocio

Dashboard ejecutivo permite **tomar decisiones basadas en datos** y detectar problemas operacionales rápidamente.

**Impacto:** Tiempo de respuesta a incidentes reducido 60%, Insights de negocio accionables

## 📝 Descripción Detallada

Dashboard con KPIs principales: Total usuarios (estudiantes/tutores), Sesiones completadas (hoy/mes), Revenue total, Tasa de conversión, NPS promedio. Gráficos de tendencias (últimos 30 días). Widgets: Tutores más reservados, Materias más populares, Mapa de calor de horarios peak. Exportable a PDF para reportes ejecutivos.

## ✅ Criterios de Aceptación

### Escenario 1: Ver KPIs en tiempo real

**Dado que** ingreso al dashboard de admin  
**Entonces** veo cards con métricas actualizadas:
- 👥 Total Usuarios: 1,234 (↑ 15% vs mes pasado)
- 📚 Sesiones Completadas Hoy: 45
- 💰 Revenue del Mes: $12,500,000 COP
- ⭐ NPS Promedio: 72 (Excelente)
- 📈 Tasa de Conversión: 5.2%

### Escenario 2: Gráfico de tendencia de sesiones

**Cuando** veo el gráfico de "Sesiones por día (últimos 30 días)"  
**Entonces** veo una línea que muestra claramente tendencia de crecimiento  
**Y** puedo hover sobre cada punto para ver valor exacto

### Escenario 3: Top 10 tutores más reservados

**Entonces** veo una tabla:
1. Juan Pérez - Matemáticas - 38 sesiones
2. María García - Inglés - 32 sesiones
3. ...
**Y** puedo clic en cada tutor para ver su perfil completo

### Escenario 4: Exportar reporte mensual

**Cuando** hago clic en "Exportar PDF"  
**Entonces** se genera un PDF con todas las métricas actuales  
**Y** incluye gráficos y tablas formateados profesionalmente

## 🔗 Trazabilidad

- **Módulo:** Admin
- **RF:** RF-072 (Dashboard de métricas)
- **Prioridad:** MUST HAVE

## 📊 Estimación

- **Story Points:** 5
- **Complejidad:** Media (agregaciones SQL + gráficos)

## 🔄 Dependencias

- Depende de: Datos en BD de reservas, pagos, usuarios
- Relacionada con: HU-036 (Historial de pagos)

## 🧪 Testing

- Performance: Carga de dashboard <3s con 10K usuarios
- Precisión: Verificar cálculos de agregaciones
- Gráficos: Chart.js o Recharts funcional

## 📌 Etiquetas

`#admin` `#dashboard` `#analytics` `#kpis` `#release-1.0`
