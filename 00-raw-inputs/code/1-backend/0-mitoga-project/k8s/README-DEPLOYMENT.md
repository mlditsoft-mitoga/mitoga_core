# 🚀 GUÍA DE DEPLOYMENT CI/CD - MITOGA BACKEND

**Fecha:** 12 de noviembre de 2025  
**DevSecOps:** Senior On-Premise  
**Cluster:** K3s - 192.168.18.126  
**Namespace:** mi-toga  

---

## 📋 RESUMEN EJECUTIVO

Se ha configurado un pipeline CI/CD completo para el proyecto Mitoga Backend con las siguientes características:

✅ **Namespace aislado** con Resource Quotas y Limit Ranges  
✅ **RBAC configurado** con Service Account para deployments  
✅ **ConfigMaps y Secrets** para configuración  
✅ **Deployment** con 2 replicas, health checks y security context  
✅ **Service ClusterIP** para comunicación interna  
✅ **Ingress con TLS** (api.mitoga.local)  
✅ **HPA** (2-10 replicas basado en CPU/Memoria)  
✅ **PDB** (Pod Disruption Budget para alta disponibilidad)  
✅ **Network Policies** (deny-all + allow específicos)  
✅ **ServiceMonitor** con alertas Prometheus  
✅ **Jenkinsfile** con 10 stages completos  

---

## 🏗️ ARQUITECTURA DESPLEGADA

```
┌─────────────────────────────────────────────────────────────────┐
│                    INTERNET / USERS                              │
└───────────────────────────────┬─────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    TRAEFIK INGRESS (443/80)                      │
│                    192.168.18.201                                │
│                    api.mitoga.local                              │
└───────────────────────────────┬─────────────────────────────────┘
                                │ TLS/SSL
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│              NAMESPACE: mi-toga                                  │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │  SERVICE: mitoga-backend-service (ClusterIP:8080)        │ │
│  └─────────────────────────┬─────────────────────────────────┘ │
│                            │                                     │
│  ┌─────────────────────────┴─────────────────────────────────┐ │
│  │  DEPLOYMENT: mitoga-backend (2-10 replicas)              │ │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐         │ │
│  │  │   POD 1    │  │   POD 2    │  │   POD N    │         │ │
│  │  │ Spring Boot│  │ Spring Boot│  │ Spring Boot│         │ │
│  │  │  Java 21   │  │  Java 21   │  │  Java 21   │         │ │
│  │  └────────────┘  └────────────┘  └────────────┘         │ │
│  └───────────────────────────────────────────────────────────┘ │
│                                                                  │
│  HPA: Auto-scaling basado en CPU (70%) y Memoria (80%)         │
│  PDB: Mínimo 1 pod disponible durante disruptions               │
│  NetworkPolicy: Allow Traefik, Prometheus, DB, Redis            │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│              DEPENDENCIAS EXTERNAS                               │
│  • PostgreSQL (databases namespace)                              │
│  • Redis (databases namespace)                                   │
│  • Vault (cicd namespace)                                        │
│  • Prometheus (cicd namespace)                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📦 ARCHIVOS CREADOS

### Manifiestos Kubernetes (k8s/)
```
k8s/
├── 00-namespace.yaml         # Namespace + ResourceQuota + LimitRange
├── 01-serviceaccount.yaml    # ServiceAccount + Role + RoleBinding
├── 02-configmap.yaml         # application.yml + prometheus config
├── 03-secrets.yaml           # DB, Redis, Mail, Vault, JWT secrets
├── 04-deployment.yaml        # Deployment principal (2 replicas)
├── 05-service.yaml           # ClusterIP Service + Headless
├── 06-ingress.yaml           # Ingress + Traefik Middlewares
├── 07-hpa-pdb.yaml           # HPA (2-10 replicas) + PDB
├── 08-networkpolicy.yaml     # Network Policies
├── 09-servicemonitor.yaml    # ServiceMonitor + PrometheusRule
└── init-db.sql               # Script inicialización PostgreSQL
```

### Pipeline CI/CD
```
Jenkinsfile                   # Pipeline completo con 10 stages
```

---

## 🚀 PASOS DE DEPLOYMENT

### PASO 1: Aplicar Manifiestos K8s

```bash
# Conectar al servidor
ssh wtorresa@192.168.18.126

# Aplicar manifiestos en orden
kubectl apply -f k8s/00-namespace.yaml
kubectl apply -f k8s/01-serviceaccount.yaml
kubectl apply -f k8s/02-configmap.yaml
kubectl apply -f k8s/03-secrets.yaml

# ⚠️ IMPORTANTE: Editar secrets antes de aplicar en producción
kubectl edit secret -n mi-toga mitoga-db-credentials
kubectl edit secret -n mi-toga mitoga-redis-credentials
kubectl edit secret -n mi-toga mitoga-mail-credentials
kubectl edit secret -n mi-toga mitoga-jwt-keys

# Aplicar deployment y servicios
kubectl apply -f k8s/04-deployment.yaml
kubectl apply -f k8s/05-service.yaml
kubectl apply -f k8s/06-ingress.yaml
kubectl apply -f k8s/07-hpa-pdb.yaml
kubectl apply -f k8s/08-networkpolicy.yaml
kubectl apply -f k8s/09-servicemonitor.yaml
```

### PASO 2: Configurar Base de Datos PostgreSQL

```bash
# Conectar a PostgreSQL
kubectl exec -it -n databases postgres-dbbfb4c95-69cck -- psql -U admin postgres

# Ejecutar desde psql:
CREATE DATABASE mitoga_db;
CREATE USER mitoga_user WITH ENCRYPTED PASSWORD 'changeme_mitoga_2025';
GRANT ALL PRIVILEGES ON DATABASE mitoga_db TO mitoga_user;

\c mitoga_db
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO mitoga_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO mitoga_user;
\q
```

### PASO 3: Configurar Credenciales en Jenkins

```bash
# Acceder a Jenkins
http://192.168.18.203:8080

# Agregar credenciales en Jenkins > Credentials > Global
1. github-mitoga-credentials (Username with password)
   - Username: mlditsoft-mitoga
   - Password: [GitHub Personal Access Token]

2. docker-registry-credentials (Username with password)
   - Username: admin
   - Password: [Docker Registry password]

3. k3s-kubeconfig-credentials (Secret file)
   - File: ~/.kube/config del servidor K3s

4. sonarqube-token (Secret text)
   - Secret: [SonarQube authentication token]
```

### PASO 4: Crear Jenkins Pipeline Job

```bash
1. New Item > Multibranch Pipeline
2. Name: mitoga-backend-pipeline
3. Branch Sources > Add source > Git
   - Project Repository: https://github.com/mlditsoft-mitoga/mitoga_core.git
   - Credentials: github-mitoga-credentials
4. Build Configuration:
   - Mode: by Jenkinsfile
   - Script Path: 00-raw-inputs/code/1-backend/0-mitoga-project/Jenkinsfile
5. Scan Multibranch Pipeline Triggers:
   - ✅ Periodically if not otherwise run
   - Interval: 5 minutes
6. Save
```

### PASO 5: Configurar DNS/Hosts

```bash
# En tu máquina local (Windows):
notepad C:\Windows\System32\drivers\etc\hosts

# Agregar línea:
192.168.18.201  api.mitoga.local mitoga.mitoga.local

# En Linux/Mac:
sudo nano /etc/hosts
# Agregar la misma línea
```

### PASO 6: Ejecutar Primer Deployment

```bash
# Opción A: Via Jenkins (RECOMENDADO)
1. Ir a Jenkins > mitoga-backend-pipeline > master
2. Click en "Build with Parameters"
3. DEPLOY_ENVIRONMENT: production
4. SKIP_TESTS: false
5. Build Now

# Opción B: Via kubectl manual (solo para testing)
kubectl set image deployment/mitoga-backend \
    mitoga-backend=192.168.18.126:5000/mitoga-backend:latest \
    -n mi-toga

kubectl rollout status deployment/mitoga-backend -n mi-toga
```

---

## ✅ VERIFICACIÓN POST-DEPLOYMENT

### Verificar Pods
```bash
kubectl get pods -n mi-toga
# Esperado: 2 pods Running

kubectl describe pod -n mi-toga -l app=mitoga-backend
# Verificar eventos, estado, recursos
```

### Verificar Services
```bash
kubectl get svc -n mi-toga
# Esperado: mitoga-backend-service ClusterIP

kubectl get endpoints -n mi-toga
# Debe mostrar IPs de pods
```

### Verificar Ingress
```bash
kubectl get ingress -n mi-toga
# ADDRESS debe ser 192.168.18.201

kubectl describe ingress mitoga-backend-ingress -n mi-toga
```

### Health Checks
```bash
# Health endpoint (via port-forward)
kubectl port-forward -n mi-toga svc/mitoga-backend-service 8080:8080

# En otra terminal:
curl http://localhost:8080/actuator/health
# Esperado: {"status":"UP"}

# Via Ingress (HTTPS)
curl -k https://api.mitoga.local/actuator/health
```

### Logs
```bash
# Ver logs en tiempo real
kubectl logs -f -n mi-toga -l app=mitoga-backend

# Logs de pod específico
POD_NAME=$(kubectl get pods -n mi-toga -l app=mitoga-backend -o jsonpath='{.items[0].metadata.name}')
kubectl logs -f -n mi-toga $POD_NAME
```

### Métricas Prometheus
```bash
# Verificar ServiceMonitor
kubectl get servicemonitor -n mi-toga

# Acceder a Prometheus
http://192.168.18.126:30900

# Query ejemplos:
- up{job="mitoga-backend-service"}
- jvm_memory_used_bytes{area="heap"}
- http_server_requests_seconds_count
```

### Grafana Dashboard
```bash
# Acceder a Grafana
http://192.168.18.126:30300

# Crear dashboard con queries:
- JVM Heap Memory: jvm_memory_used_bytes{area="heap",namespace="mi-toga"}
- HTTP Requests: rate(http_server_requests_seconds_count{namespace="mi-toga"}[5m])
- Response Time: histogram_quantile(0.95, rate(http_server_requests_seconds_bucket[5m]))
```

---

## 🔒 SEGURIDAD

### Network Policies Aplicadas
✅ Deny all traffic por defecto  
✅ Allow desde Traefik Ingress  
✅ Allow desde Prometheus  
✅ Allow hacia PostgreSQL  
✅ Allow hacia Redis  
✅ Allow hacia Vault  
✅ Allow HTTPS saliente (443, 587, 465)  

### Security Context
✅ runAsNonRoot: true  
✅ readOnlyRootFilesystem: true  
✅ runAsUser: 65532 (distroless nonroot)  
✅ capabilities dropped: ALL  
✅ seccompProfile: RuntimeDefault  

### Secrets Management
⚠️ **CAMBIAR EN PRODUCCIÓN:**
- DB_PASSWORD en `mitoga-db-credentials`
- REDIS_PASSWORD en `mitoga-redis-credentials`
- MAIL_PASSWORD en `mitoga-mail-credentials`
- JWT_SECRET en `mitoga-jwt-keys`
- VAULT_TOKEN en `mitoga-vault-token`

---

## 📊 MONITOREO

### Alertas Configuradas (PrometheusRule)
1. **MitogaBackendDown** - Pod down > 1min (CRITICAL)
2. **MitogaBackendHighCPU** - CPU > 80% por 5min (WARNING)
3. **MitogaBackendHighMemory** - Heap > 90% por 5min (WARNING)
4. **MitogaBackendHighErrorRate** - Errores > 10/sec por 5min (CRITICAL)
5. **MitogaBackendSlowResponse** - p95 > 2 sec por 5min (WARNING)
6. **MitogaBackendDBPoolExhaustion** - Pool > 90% por 5min (CRITICAL)
7. **MitogaBackendHighGCTime** - GC > 50% tiempo por 5min (WARNING)

### Endpoints de Monitoreo
```
/actuator/health              # Health check
/actuator/health/liveness     # Liveness probe
/actuator/health/readiness    # Readiness probe
/actuator/prometheus          # Métricas Prometheus
/actuator/metrics             # Métricas individuales
/actuator/info                # Información de la app
```

---

## 🔄 OPERACIONES

### Escalar Manualmente
```bash
kubectl scale deployment mitoga-backend --replicas=5 -n mi-toga
```

### Rolling Update
```bash
kubectl set image deployment/mitoga-backend \
    mitoga-backend=192.168.18.126:5000/mitoga-backend:v2.0.0 \
    -n mi-toga

kubectl rollout status deployment/mitoga-backend -n mi-toga
```

### Rollback
```bash
# Ver historial
kubectl rollout history deployment/mitoga-backend -n mi-toga

# Rollback a versión anterior
kubectl rollout undo deployment/mitoga-backend -n mi-toga

# Rollback a versión específica
kubectl rollout undo deployment/mitoga-backend --to-revision=3 -n mi-toga
```

### Restart Pods
```bash
kubectl rollout restart deployment/mitoga-backend -n mi-toga
```

### Debug Pod
```bash
# Shell interactivo (distroless no tiene shell, usar debug container)
kubectl debug -it -n mi-toga $POD_NAME --image=busybox:1.36 --target=mitoga-backend

# Exec comando
kubectl exec -n mi-toga $POD_NAME -- wget -qO- http://localhost:8080/actuator/health
```

---

## 📝 PIPELINE CI/CD - JENKINSFILE

### 10 Stages Configurados:

1. **📥 Checkout** - Clonar repositorio GitHub
2. **🔨 Build** - Compilar con Gradle
3. **🧪 Tests** - Unit + Integration tests
4. **📊 SonarQube** - Code quality analysis
5. **✅ Quality Gate** - Verificar quality gate
6. **🐳 Docker Build** - Construir imagen distroless
7. **🔒 Trivy Scan** - Security scanning (HIGH, CRITICAL)
8. **📤 Push Registry** - Push a Docker Registry local
9. **🚀 Deploy K3s** - Aplicar manifiestos + rolling update
10. **✅ Smoke Tests** - Health checks post-deployment

### Parámetros del Pipeline:
- `DEPLOY_ENVIRONMENT`: development | staging | production
- `SKIP_TESTS`: Skip tests (no recomendado)
- `SKIP_SONAR`: Skip SonarQube
- `SKIP_TRIVY`: Skip security scan
- `FORCE_DEPLOY`: Force deploy (ignora fallos)

---

## 🎯 PRÓXIMOS PASOS

### Corto Plazo (Esta Semana)
- [ ] Configurar Redis para caché
- [ ] Completar Ingress para Prometheus y Portainer
- [ ] Extender Network Policies a otros namespaces
- [ ] Configurar backup automático con Velero

### Medio Plazo (Próximas 2 Semanas)
- [ ] Integrar SonarQube en cluster
- [ ] Instalar Trivy en Jenkins agent
- [ ] Configurar alertas en Slack/Email
- [ ] Implementar GitOps con ArgoCD

### Largo Plazo (Próximo Mes)
- [ ] Migrar a cluster multi-nodo (HA)
- [ ] Implementar Blue-Green deployments
- [ ] Configurar Disaster Recovery completo
- [ ] Optimizar costos y recursos

---

## 📚 DOCUMENTACIÓN ADICIONAL

- [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)
- [K3s Documentation](https://docs.k3s.io/)
- [Traefik Ingress](https://doc.traefik.io/traefik/providers/kubernetes-ingress/)
- [Prometheus Operator](https://prometheus-operator.dev/)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)

---

**Configurado por:** DevSecOps Senior  
**Fecha:** 12 de noviembre de 2025  
**Versión:** 1.0.0  
**Namespace:** mi-toga  
**Cluster:** K3s @ 192.168.18.126  

🎉 **CI/CD Pipeline Ready for Production!**
