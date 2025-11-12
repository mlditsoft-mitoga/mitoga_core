# Ejemplo de Ejecución de Tests - Newman

## 📊 Output Esperado

### Ejecución Exitosa (Local Environment)

```bash
PS D:\...\postman> .\run-newman-tests.ps1 -Environment local

🚀 Ejecutando tests de API
   Colección: Mitoga-API.postman_collection.json
   Ambiente: Local
   Fecha: 2025-11-12 09:00:00

newman

Mitoga API

→ 1. Catálogos Recursivos / 1.1. Obtener Árbol Completo
  GET http://localhost:8082/api/v1/catalogos/cliente/arbol?soloActivos=true [200 OK, 3.45KB, 234ms]
  ✓  Status code is 200
  ✓  Response has success structure
  ✓  Data is an array
  ✓  Response time is less than 2000ms

→ 1. Catálogos Recursivos / 1.2. Obtener Ancestros
  GET http://localhost:8082/api/v1/catalogos/550e8400-.../ancestros [200 OK, 1.23KB, 156ms]
  ✓  Status code is 200
  ✓  Response has success structure
  ✓  Ancestros are ordered from root to parent

→ 1. Catálogos Recursivos / 1.3. Obtener Descendientes
  GET http://localhost:8082/api/v1/catalogos/550e8400-.../descendientes?nivel=2 [200 OK, 2.89KB, 178ms]
  ✓  Status code is 200
  ✓  Response has success structure
  ✓  All descendants have higher level than parent

→ 1. Catálogos Recursivos / 1.4. Buscar Catálogos
  GET http://localhost:8082/api/v1/catalogos/search?tipo=cliente&nombre=tecn... [200 OK, 1.56KB, 145ms]
  ✓  Status code is 200
  ✓  Response has success structure
  ✓  Search results match criteria

→ 1. Catálogos Recursivos / 1.5. Error - Catálogo No Encontrado
  GET http://localhost:8082/api/v1/catalogos/00000000-0000-0000-.../ancestros [404 Not Found, 512B, 89ms]
  ✓  Status code is 404
  ✓  Response has error structure

→ 2. Health Check / 2.1. Actuator Health
  GET http://localhost:8082/api/v1/actuator/health [200 OK, 789B, 67ms]
  (sin tests específicos)

→ 2. Health Check / 2.2. Actuator Info
  GET http://localhost:8082/api/v1/actuator/info [200 OK, 345B, 45ms]
  (sin tests específicos)

┌─────────────────────────┬───────────────────┬──────────────────┐
│                         │          executed │           failed │
├─────────────────────────┼───────────────────┼──────────────────┤
│              iterations │                 1 │                0 │
├─────────────────────────┼───────────────────┼──────────────────┤
│                requests │                 7 │                0 │
├─────────────────────────┼───────────────────┼──────────────────┤
│            test-scripts │                 7 │                0 │
├─────────────────────────┼───────────────────┼──────────────────┤
│      prerequest-scripts │                 7 │                0 │
├─────────────────────────┼───────────────────┼──────────────────┤
│              assertions │                16 │                0 │
├─────────────────────────┴───────────────────┴──────────────────┤
│ total run duration: 1.2s                                        │
├─────────────────────────────────────────────────────────────────┤
│ total data received: 10.75KB (approx)                           │
├─────────────────────────────────────────────────────────────────┤
│ average response time: 130ms [min: 45ms, max: 234ms, s.d.: 65ms]│
└─────────────────────────────────────────────────────────────────┘

✅ Tests completados exitosamente

📊 Reportes generados:
   HTML: .\newman-reports\newman-report-Local-20251112_090000.html
   JSON: .\newman-reports\newman-report-Local-20251112_090000.json
   JUnit: .\newman-reports\newman-report-Local-20251112_090000.xml

¿Abrir reporte HTML? (y/n):
```

---

## ❌ Ejemplo de Ejecución con Errores

### Caso 1: Aplicación No Corriendo

```bash
PS D:\...\postman> .\run-newman-tests.ps1 -Environment local

🚀 Ejecutando tests de API
   Colección: Mitoga-API.postman_collection.json
   Ambiente: Local
   Fecha: 2025-11-12 09:05:00

newman

Mitoga API

→ 1. Catálogos Recursivos / 1.1. Obtener Árbol Completo
  GET http://localhost:8082/api/v1/catalogos/cliente/arbol [Error: connect ECONNREFUSED 127.0.0.1:8082]
  1. Error: connect ECONNREFUSED 127.0.0.1:8082

┌─────────────────────────┬───────────────────┬──────────────────┐
│                         │          executed │           failed │
├─────────────────────────┼───────────────────┼──────────────────┤
│              iterations │                 1 │                0 │
├─────────────────────────┼───────────────────┼──────────────────┤
│                requests │                 1 │                1 │
├─────────────────────────┼───────────────────┼──────────────────┤
│            test-scripts │                 0 │                0 │
├─────────────────────────┼───────────────────┼──────────────────┤
│      prerequest-scripts │                 1 │                0 │
├─────────────────────────┼───────────────────┼──────────────────┤
│              assertions │                 0 │                0 │
└─────────────────────────┴───────────────────┴──────────────────┘

❌ Tests fallaron con código: 1

📊 Revisar reporte de errores:
   HTML: .\newman-reports\newman-report-Local-20251112_090500.html

¿Abrir reporte de errores? (y/n):
```

**Solución:** Iniciar la aplicación con `.\gradlew.bat bootRun`

---

### Caso 2: Credenciales Incorrectas

```bash
newman

Mitoga API

→ 1. Catálogos Recursivos / 1.1. Obtener Árbol Completo
  GET http://localhost:8082/api/v1/catalogos/cliente/arbol [401 Unauthorized, 1.23KB, 89ms]
  ✗  Status code is 200
   ↳  expected 401 to deeply equal 200
  ✗  Response has success structure
   ↳  expected { Object (timestamp, status, ...) } to have property 'success'

┌─────────────────────────┬───────────────────┬──────────────────┐
│                         │          executed │           failed │
├─────────────────────────┼───────────────────┼──────────────────┤
│              iterations │                 1 │                0 │
├─────────────────────────┼───────────────────┼──────────────────┤
│                requests │                 1 │                0 │
├─────────────────────────┼───────────────────┼──────────────────┤
│            test-scripts │                 1 │                0 │
├─────────────────────────┼───────────────────┼──────────────────┤
│      prerequest-scripts │                 1 │                0 │
├─────────────────────────┼───────────────────┼──────────────────┤
│              assertions │                 4 │                2 │
└─────────────────────────┴───────────────────┴──────────────────┘
```

**Solución:** Actualizar el password en el environment:
1. Ver logs de Spring Boot para el password generado
2. Copiar el password
3. Postman → Environments → Mitoga - Local → password → Paste

---

### Caso 3: Base de Datos Sin Datos

```bash
→ 1. Catálogos Recursivos / 1.1. Obtener Árbol Completo
  GET http://localhost:8082/api/v1/catalogos/cliente/arbol [200 OK, 567B, 123ms]
  ✓  Status code is 200
  ✓  Response has success structure
  ✓  Data is an array
  ✓  Response time is less than 2000ms

→ 1. Catálogos Recursivos / 1.2. Obtener Ancestros
  GET http://localhost:8082/api/v1/catalogos/550e8400-e29b-41d4-a716-446655440002/ancestros [404 Not Found, 456B, 98ms]
  ✗  Status code is 200
   ↳  expected 404 to deeply equal 200
```

**Solución:** Ejecutar scripts de población de datos:
```sql
-- En PostgreSQL
\i V3__catalogo_recursivo_datos.sql
```

---

## 📈 Métricas de Rendimiento Típicas

### Entorno Local (Development)
```
Average Response Time: 130ms
Min Response Time: 45ms
Max Response Time: 234ms
Standard Deviation: 65ms

Data Transfer: ~10-15KB per run
Total Duration: 1-2 seconds
```

### Entorno QA (Testing)
```
Average Response Time: 250ms
Min Response Time: 120ms
Max Response Time: 450ms
Standard Deviation: 95ms

Data Transfer: ~10-15KB per run
Total Duration: 2-3 seconds
```

### Entorno Production (Live)
```
Average Response Time: 180ms
Min Response Time: 80ms
Max Response Time: 350ms
Standard Deviation: 75ms

Data Transfer: ~10-15KB per run
Total Duration: 1.5-2.5 seconds
```

---

## 🎯 Benchmarks y Objetivos

### SLA (Service Level Agreement)

| Métrica | Objetivo | Crítico |
|---------|----------|---------|
| Response Time (p50) | < 200ms | < 500ms |
| Response Time (p95) | < 400ms | < 1000ms |
| Response Time (p99) | < 800ms | < 2000ms |
| Success Rate | > 99.5% | > 95% |
| Availability | > 99.9% | > 99% |

### Tests Performance

| Test | Objetivo | Estado Actual |
|------|----------|---------------|
| Assertions Pass Rate | 100% | ✅ 100% |
| Test Execution Time | < 2s | ✅ 1.2s |
| Data Validation | 100% | ✅ 100% |

---

## 🔧 Comandos Útiles

### Ejecutar con Opciones Específicas

```powershell
# Solo un folder específico
newman run Mitoga-API.postman_collection.json \
  -e Mitoga-Local.postman_environment.json \
  --folder "1. Catálogos Recursivos"

# Con iteraciones múltiples
newman run Mitoga-API.postman_collection.json \
  -e Mitoga-Local.postman_environment.json \
  -n 10  # 10 iteraciones

# Con delay entre requests
newman run Mitoga-API.postman_collection.json \
  -e Mitoga-Local.postman_environment.json \
  --delay-request 1000  # 1 segundo

# Con variables adicionales
newman run Mitoga-API.postman_collection.json \
  -e Mitoga-Local.postman_environment.json \
  --env-var "catalogoId=550e8400-e29b-41d4-a716-446655440002"

# Solo reportes específicos
newman run Mitoga-API.postman_collection.json \
  -e Mitoga-Local.postman_environment.json \
  --reporters cli  # Solo consola
```

---

## 📊 Ejemplo de Reporte HTML

El reporte HTML generado incluye:

### Secciones del Reporte
1. **Summary**
   - Total requests: 7
   - Total assertions: 16
   - Failures: 0
   - Duration: 1.2s

2. **Requests**
   - Lista detallada de cada request
   - Status code
   - Response time
   - Response size

3. **Test Results**
   - Assertions por request
   - Pass/Fail status
   - Error messages (si hay)

4. **Response Data**
   - Headers
   - Body (JSON formateado)
   - Cookies

5. **Charts**
   - Response time distribution
   - Success rate
   - Request duration

---

**Nota:** Este es un documento de ejemplo para referencia. Los valores reales dependerán del estado del sistema y la carga del servidor.
