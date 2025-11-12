# Módulo: Pagos

**Responsable:** Backend Lead + Compliance Officer  
**Story Points Totales:** 66 SP  
**Historias:** 8 HUs MUST HAVE

---

## 🎯 Objetivo del Módulo

Procesar transacciones seguras con múltiples métodos de pago (tarjeta, PSE), gestionar comisiones automáticas, reembolsos, facturación electrónica DIAN y retiros tutores.

---

## 📋 Historias de Usuario

| ID | Título | Rol | Prioridad | SP | Estado |
|----|--------|-----|-----------|----|----|
| [HU-030](HU-030-procesar-pago.md) | Procesar pago con tarjeta (Stripe) | Estudiante | MUST | 13 | ✅ Generada |
| [HU-031](HU-031-pago-pse.md) | Pagar con PSE (Colombia) | Estudiante | MUST | 8 | ✅ Generada |
| [HU-032](HU-032-guardar-metodo-pago.md) | Guardar método de pago seguro | Estudiante | MUST | 5 | ✅ Generada |
| [HU-033](HU-033-comision-plataforma.md) | Calcular comisión automática 20% | Sistema | MUST | 5 | ✅ Generada |
| [HU-034](HU-034-solicitar-reembolso.md) | Solicitar reembolso (admin review) | Estudiante | MUST | 8 | ✅ Generada |
| [HU-035](HU-035-factura-electronica.md) | Generar factura electrónica DIAN | Est/Tutor | MUST | 8 | ✅ Generada |
| [HU-036](HU-036-historial-pagos.md) | Ver historial pagos/ingresos | Est/Tutor | MUST | 3 | ✅ Generada |
| [HU-037](HU-037-transferir-fondos-tutor.md) | Transferir fondos a tutor (ACH) | Tutor | MUST | 8 | ✅ Generada |

**Total:** 58 SP

---

## 🔗 Dependencias

**Servicios externos:**
- **Stripe:** Pagos tarjeta, tokenización, refunds, payouts (primary)
- **PayU / ePayco:** PSE Colombia (transferencias bancarias)
- **Alegra / Siigo:** Facturación electrónica DIAN (UBL 2.1)

**RNF críticos:**
- RNF-SEC-007: PCI-DSS compliance (no almacenar datos tarjeta)
- RNF-LEGAL-001: Facturación electrónica DIAN obligatoria Colombia
- RNF-FIN-001: Cálculos comisiones auditables
- RNF-FIN-002: Retiros procesados <48h

---

## 🧪 Testing

- **Cobertura esperada:** >98% (módulo crítico revenue)
- **Tests E2E:** Pago exitoso + rechazado + reembolso + factura generada (flow completo)
- **Security testing:** Penetration testing PCI-DSS compliance
- **Load testing:** 1000 pagos concurrentes sin pérdida transacciones
- **Disaster recovery:** Backup transacciones cada 15 min (PostgreSQL WAL)

---

## 📊 Métricas

| Métrica | Objetivo | Seguimiento |
|---------|----------|-------------|
| **Tasa éxito pagos** | > 95% | Stripe dashboard |
| **Tiempo procesamiento pago** | < 5s | APM monitoring |
| **Reembolsos totales** | < 5% transacciones | BD analytics |
| **Retiros tutores a tiempo** | > 95% <48h | Queue monitoring |
| **Facturas DIAN exitosas** | 100% | Logs API DIAN |
| **Comisión efectiva** | 20% neto (post gateway fees) | Financial reports |

---

## ⚠️ Compliance & Security

**PCI-DSS Level 1:**
- Tokenización tarjetas (Stripe Elements)
- No almacenar CVV ni número completo
- HTTPS obligatorio (TLS 1.3)
- Logs de auditoría 5 años

**DIAN Colombia:**
- Factura electrónica UBL 2.1
- Firma digital certificado vigente
- Numeración consecutiva
- Retención fuente automática (si aplica)

---

**Última actualización:** 08/11/2025  
**Estado:** 8/8 HUs generadas (100%)
