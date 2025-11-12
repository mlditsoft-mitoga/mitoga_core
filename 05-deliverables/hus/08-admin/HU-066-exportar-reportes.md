# HU-066: Exportar Reportes Financieros

## 📋 Historia de Usuario

**Como** administrador financiero,  
**Quiero** exportar reportes de transacciones y pagos a tutores,  
**Para** contabilidad, auditorías y declaración de impuestos.

## 🎯 Valor de Negocio

Reportes financieros son obligatorios para compliance fiscal y auditorías externas.

**Impacto:** Compliance contable, Reducción de tiempo en auditorías 70%

## 📝 Descripción Detallada

Generador de reportes con filtros: Rango de fechas, Tipo de transacción (Pagos recibidos, Comisiones, Pagos a tutores, Reembolsos), Estado (Completado, Pendiente, Fallido). Formatos de exportación: CSV, Excel, PDF. Campos: ID transacción, Fecha, Usuario, Tutor, Monto, Comisión, Neto, Estado, Método de pago.

## ✅ Criterios de Aceptación

### Escenario 1: Exportar transacciones del mes

**Cuando** navego a "Reportes" → "Financieros"  
**Y** selecciono filtros:
- Rango: 01/11/2025 - 30/11/2025
- Tipo: Todos
- Estado: Completado
**Y** hago clic en [Exportar CSV]  
**Entonces** se descarga archivo "transacciones-nov-2025.csv"  
**Y** contiene 234 transacciones con columnas:
- id, fecha, estudiante, tutor, materia, monto_sesion, comision_plataforma, neto_tutor, metodo_pago, estado

### Escenario 2: Reporte de comisiones para contabilidad

**Cuando** selecciono:
- Rango: Q4 2025 (Oct-Nov-Dic)
- Tipo: Solo comisiones
- Formato: Excel
**Y** exporto  
**Entonces** el Excel incluye sheet "Resumen" con:
- Total Comisiones: $4,500,000 COP
- Por Categoría: Programación $1,200,000, Matemáticas $1,800,000, etc.
**Y** sheet "Detalle" con todas las transacciones

### Escenario 3: Reporte de pagos a tutores (para transferencias)

**Cuando** filtro por:
- Rango: Semana pasada
- Tipo: Pagos a tutores (neto después de comisión)
- Estado: Pendiente de transferencia
**Y** exporto CSV  
**Entonces** obtengo lista de tutores con:
- Nombre, Email, Cuenta bancaria, Monto a transferir
- Usable para upload masivo a banco

### Escenario 4: Reporte de reembolsos para auditoría

**Cuando** selecciono:
- Rango: Año 2025
- Tipo: Solo reembolsos
- Formato: PDF
**Entonces** se genera PDF con:
- Header: Logo MI-TOGA, fecha de generación
- Tabla de reembolsos con motivos
- Footer: Total reembolsado $1,250,000 (2.1% de ingresos)

### Escenario 5: Programar reporte recurrente

**Cuando** hago clic en "Programar Reporte"  
**Y** configuro:
- Frecuencia: Mensual (primer día del mes)
- Tipo: Transacciones del mes anterior
- Formato: Excel
- Enviar a: finanzas@mi-toga.com
**Entonces** se crea scheduled job que envía email automático cada mes

## 🔗 Trazabilidad

- **Módulo:** Admin
- **RF:** RF-075 (Reportes financieros)
- **Prioridad:** MUST HAVE

## 📊 Estimación

- **Story Points:** 5
- **Complejidad:** Media (generación de archivos + filtros complejos)

## 🔄 Dependencias

- Depende de: HU-030 (Pagos), HU-037 (Transferencias tutores)
- Relacionada con: HU-061 (Dashboard métricas)

## 🧪 Testing

- Volumen: 10K transacciones exportadas en <10s
- Precisión: Sumar columnas debe coincidir con BD
- Formatos: CSV/Excel/PDF correctamente formateados
- Filtros: Combinaciones complejas de filtros

## 📌 Etiquetas

`#admin` `#finanzas` `#reportes` `#compliance` `#export` `#release-1.0`
