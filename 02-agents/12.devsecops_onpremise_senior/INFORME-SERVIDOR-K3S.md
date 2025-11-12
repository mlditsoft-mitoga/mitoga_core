# 📊 INFORME DE ESCANEO - SERVIDOR K3S ON-PREMISE

**Fecha:** 12 de noviembre de 2025  
**Host:** 192.168.18.126  
**Hostname:** zesserver32g  
**Usuario:** wtorresa  

---

## 🖥️ INFORMACIÓN DEL SERVIDOR

### Sistema Operativo
- **OS:** Ubuntu 24.04.3 LTS
- **Kernel:** 6.8.0-87-generic
- **Arquitectura:** x86_64 (64-bit)
- **Uptime:** ~47 horas

### Hardware
- **CPU Cores:** 4 cores (7% uso actual)
- **RAM Total:** 31 GB
- **RAM Usada:** 4.7 GB (15%)
- **RAM Disponible:** 26 GB (85%)
- **Swap:** 8 GB (sin uso)

### Almacenamiento
```
Filesystem      Size  Used  Avail  Use%  Mounted on
/dev/sdb3       275G   11G   251G    5%  /
/dev/sdb4       180G   28G   143G   17%  /var/lib (datos K3s)
/dev/sda1       458G   28K   435G    1%  /srv (disponible)
/dev/sdb2       974M  103M   805M   12%  /boot
/dev/sdb1       1.1G  6.2M   1.1G    1%  /boot/efi
```

**Total Storage:** ~914 GB  
**Total Usado:** ~39 GB (4%)  
**Total Disponible:** ~830 GB (96%)

---

## ☸️ CLUSTER KUBERNETES (K3S)

### Versión
- **K3s Version:** v1.33.5+k3s1
- **Kubernetes Version:** v1.33.5
- **Go Version:** go1.24.6
- **Container Runtime:** containerd 2.1.4-k3s1
- **Kustomize:** v5.6.0

### Topología del Cluster
- **Tipo:** Single-node (1 nodo)
- **Roles:** control-plane + master + worker
- **Estado:** Ready ✅
- **Edad:** 47 horas

```
NAME           STATUS   ROLES                  AGE   VERSION        INTERNAL-IP      KERNEL-VERSION
zesserver32g   Ready    control-plane,master   47h   v1.33.5+k3s1   192.168.18.126   6.8.0-87-generic
```

**⚠️ RECOMENDACIÓN:** 
- Cluster de nodo único = Sin alta disponibilidad
- Para producción se recomienda: **3 masters + 2-3 workers** (mínimo 5 nodos)

---

## 📦 NAMESPACES Y APLICACIONES

### Namespaces Activos (10)
| Namespace | Propósito | Edad |
|-----------|-----------|------|
| `argocd` | GitOps CD (Continuous Deployment) | 25h |
| `cicd` | CI/CD Tools (Jenkins, Prometheus, Grafana, Vault, Loki) | 46h |
| `databases` | Bases de datos (PostgreSQL, Oracle) | 27h |
| `portainer` | Gestión de contenedores (UI) | 46h |
| `kubernetes-dashboard` | Dashboard de K8s | 47h |
| `kube-system` | Componentes core de K8s | 47h |
| `default` | Namespace por defecto | 47h |
| `vault` | Secrets Management (namespace adicional) | 27h |

---

## 🚀 APLICACIONES DESPLEGADAS

### 1. Namespace: `argocd` (GitOps)
**Pods:** 7/7 Running ✅

| Pod | Estado | Restarts | Edad |
|-----|--------|----------|------|
| argocd-application-controller | Running | 3 | 25h |
| argocd-applicationset-controller | Running | 3 | 25h |
| argocd-dex-server | Running | 3 | 25h |
| argocd-notifications-controller | Running | 3 | 25h |
| argocd-redis | Running | 3 | 25h |
| argocd-repo-server | Running | 3 | 25h |
| argocd-server | Running | 3 | 25h |

**Acceso:**
- **URL:** `http://192.168.18.126:32746` (HTTP)
- **URL:** `https://192.168.18.126:30724` (HTTPS)
- **Tipo:** NodePort (30724, 32746)

---

### 2. Namespace: `cicd` (CI/CD Stack)
**Pods:** 7/7 Running ✅

| Aplicación | Estado | CPU | Memoria | Propósito |
|------------|--------|-----|---------|-----------|
| **Jenkins** | Running | 11m | 388 MB | CI/CD Automation |
| **Prometheus** | Running | 17m | 207 MB | Metrics Collection |
| **Grafana** | Running | 7m | 296 MB | Dashboards & Visualization |
| **Vault** | Running | 6m | 206 MB | Secrets Management |
| **Loki** | Running | 8m | 132 MB | Log Aggregation |
| **Promtail** | Running | 17m | 126 MB | Log Shipper |
| **Alertmanager** | Running | 2m | 46 MB | Alert Management |

**Servicios Expuestos:**

| Servicio | Tipo | IP Externa | Puerto | URL |
|----------|------|------------|--------|-----|
| Jenkins | LoadBalancer | 192.168.18.126 | 8080, 50000 | http://192.168.18.126:8080 |
| Grafana | NodePort | - | 30300 | http://192.168.18.126:30300 |
| Prometheus | NodePort | - | 30900 | http://192.168.18.126:30900 |
| Vault | NodePort | - | 30200 | http://192.168.18.126:30200 |
| Alertmanager | NodePort | - | 31964 | http://192.168.18.126:31964 |

**Volúmenes Persistentes:**
- Jenkins: 20 GB (local-path)
- Grafana: 10 GB (local-path)
- Prometheus: 20 GB (local-path)
- Loki: 20 GB (local-path)
- Vault: 10 GB (local-path, Retain policy)
- Alertmanager: 5 GB (local-path)

**Total Storage CI/CD:** 85 GB

---

### 3. Namespace: `databases`
**Pods:** 2/2 Running ✅

| Base de Datos | Estado | CPU | Memoria | Puerto |
|---------------|--------|-----|---------|--------|
| **PostgreSQL** | Running | N/A | N/A | 5432 (LoadBalancer) |
| **Oracle CE** | Running | 22m | 2535 MB | 1521 (NodePort) |

**Servicios Expuestos:**

| Servicio | Tipo | IP Externa | Puerto |
|----------|------|------------|--------|
| PostgreSQL | LoadBalancer | 192.168.18.126 | 5432 |
| Oracle CE | NodePort | - | 31521 (DB), 31500 (EM) |

**Volúmenes Persistentes:**
- PostgreSQL: 10 GB
- Oracle: 20 GB

**Total Storage Databases:** 30 GB

**⚠️ ALERTA DE RECURSOS:**
- Oracle está consumiendo **2.5 GB de RAM** (mayor consumidor del cluster)
- Se recomienda monitorear y optimizar configuración

---

### 4. Namespace: `portainer`
**Pods:** 1/1 Running ✅

| Aplicación | Estado | Memoria |
|------------|--------|---------|
| Portainer | Running | N/A |

**Acceso:**
- **URL:** `http://192.168.18.126:9000` (HTTP)
- **URL:** `https://192.168.18.126:9443` (HTTPS)
- **Tipo:** LoadBalancer
- **Storage:** 10 GB

---

### 5. Namespace: `kube-system` (Sistema)
**Pods:** 8 Running ✅

| Componente | Estado | Propósito |
|------------|--------|-----------|
| CoreDNS | Running | DNS interno del cluster |
| Traefik Ingress | Running | Ingress Controller (HTTP/HTTPS routing) |
| Local Path Provisioner | Running | Provisioner de storage local |
| Metrics Server | Running | Métricas de recursos (CPU/RAM) |
| Service LB pods (4) | Running | Load balancers para servicios |

**Traefik Ingress:**
- **URL:** `http://192.168.18.126:80` (HTTP)
- **URL:** `https://192.168.18.126:443` (HTTPS)
- **Tipo:** LoadBalancer
- **IPs Asignadas:** 192.168.18.126

---

### 6. Namespace: `kubernetes-dashboard`
**Pods:** 2/2 Running ✅

| Componente | Estado |
|------------|--------|
| kubernetes-dashboard | Running |
| dashboard-metrics-scraper | Running |

**Acceso:**
- **Puerto:** 30210 (NodePort)
- **Estado LoadBalancer:** Pending ⚠️

**⚠️ PROBLEMA:**
- El servicio LoadBalancer está en `<pending>` (sin IP externa asignada)
- K3s no tiene MetalLB instalado para asignar IPs automáticamente

---

## 📊 CONSUMO DE RECURSOS

### Top 10 Pods por Memoria
| Namespace | Pod | Memoria |
|-----------|-----|---------|
| databases | oracle-ce | 2535 MB 🔴 |
| cicd | jenkins | 388 MB |
| cicd | grafana | 296 MB |
| cicd | prometheus | 207 MB |
| cicd | vault | 206 MB |
| cicd | loki | 132 MB |
| cicd | promtail | 126 MB |
| argocd | argocd-dex-server | 112 MB |
| cicd | alertmanager | 46 MB |
| argocd | argocd-server | 30 MB |

**Total RAM en uso por pods:** ~4.2 GB / 31 GB (13.5%)

### Top 5 Pods por CPU
| Namespace | Pod | CPU |
|-----------|-----|-----|
| databases | oracle-ce | 22m |
| cicd | prometheus | 17m |
| cicd | promtail | 17m |
| cicd | jenkins | 11m |
| argocd | argocd-redis | 8m |

**Total CPU en uso:** ~300m / 4000m (7.5%)

---

## 💾 VOLÚMENES PERSISTENTES (PV/PVC)

### Resumen de Storage
| Namespace | PVC | Tamaño | Status | StorageClass |
|-----------|-----|--------|--------|--------------|
| cicd | jenkins-pvc | 20 GB | Bound ✅ | local-path |
| cicd | prometheus-data-pvc | 20 GB | Bound ✅ | local-path |
| cicd | loki-data-pvc | 20 GB | Bound ✅ | local-path |
| cicd | grafana-data-pvc | 10 GB | Bound ✅ | local-path |
| cicd | vault-data-pvc | 10 GB | Bound ✅ | local-path (Retain) |
| cicd | alertmanager-data-pvc | 5 GB | Bound ✅ | local-path |
| databases | oracle-data | 20 GB | Bound ✅ | local-path |
| databases | postgres-pvc | 10 GB | Bound ✅ | local-path |
| portainer | portainer | 10 GB | Bound ✅ | local-path |

**Total Storage Provisionado:** 125 GB  
**Storage Disponible en /var/lib:** 143 GB  
**Uso:** 87% del espacio asignado

**⚠️ ADVERTENCIA:**
- Solo queda **18 GB libres** en `/var/lib` para nuevos PVCs
- Se recomienda monitorear crecimiento de logs (Loki, Prometheus)

---

## 🌐 SERVICIOS EXTERNOS

### Servicios LoadBalancer (3)
| Servicio | Namespace | IP Externa | Puertos |
|----------|-----------|------------|---------|
| jenkins-external | cicd | 192.168.18.126 | 8080, 50000 |
| postgres-external | databases | 192.168.18.126 | 5432 |
| traefik | kube-system | 192.168.18.126 | 80, 443 |
| portainer | portainer | 192.168.18.126 | 9000, 9443, 30776 |

**⚠️ PROBLEMA:**
- Todos los LoadBalancers usan la **misma IP** (192.168.18.126)
- K3s no tiene MetalLB configurado (usa IP del host por defecto)
- **Recomendación:** Instalar MetalLB con pool de IPs (ej: 192.168.18.200-250)

### Servicios NodePort (6)
| Servicio | Namespace | Puerto(s) | URL |
|----------|-----------|-----------|-----|
| argocd-server | argocd | 32746, 30724 | http://192.168.18.126:32746 |
| grafana | cicd | 30300 | http://192.168.18.126:30300 |
| prometheus | cicd | 30900 | http://192.168.18.126:30900 |
| vault | cicd | 30200 | http://192.168.18.126:30200 |
| alertmanager-external | cicd | 31964 | http://192.168.18.126:31964 |
| oracle-ce | databases | 31521, 31500 | - |

---

## 🔍 INGRESS RULES

**Estado:** No hay Ingress configurados ❌

**⚠️ PROBLEMA:**
- Traefik Ingress Controller está instalado pero **no hay Ingress resources**
- Todos los servicios se exponen via LoadBalancer/NodePort directamente
- **Impacto:** No hay routing HTTP/HTTPS centralizado ni gestión de SSL/TLS

**Recomendaciones:**
1. Crear Ingress para Jenkins: `jenkins.mitoga.local`
2. Crear Ingress para Grafana: `grafana.mitoga.local`
3. Crear Ingress para ArgoCD: `argocd.mitoga.local`
4. Instalar Cert-Manager para SSL/TLS automático

---

## 🔒 ANÁLISIS DE SEGURIDAD

### ✅ Fortalezas
1. **Vault instalado** - Secrets management disponible
2. **Namespaces segregados** - Separación lógica de aplicaciones
3. **Prometheus + Grafana** - Monitoreo activo
4. **ArgoCD** - GitOps para deployments declarativos
5. **Promtail + Loki** - Centralización de logs

### ⚠️ Vulnerabilidades y Riesgos

#### 🔴 CRÍTICO
1. **Cluster de nodo único** - Sin alta disponibilidad, punto único de fallo
2. **Sin Network Policies** - No hay aislamiento de red entre namespaces
3. **Sin MetalLB** - Gestión deficiente de IPs externas
4. **Sin Ingress configurados** - Exposición directa de puertos
5. **Sin Cert-Manager** - No hay SSL/TLS automático

#### 🟡 MEDIO
6. **Sin límites de recursos** - Pods pueden consumir recursos ilimitados
7. **Sin PodSecurityPolicies/Standards** - No hay restricciones de seguridad a nivel pod
8. **Sin imagen scanning** - No hay Trivy/Falco para escaneo de vulnerabilidades
9. **Sin backups automatizados** - No hay Velero para disaster recovery
10. **Restart frecuentes** - Varios pods con 3-6 restarts en 24-48h

#### 🟢 BAJO
11. **Sin Horizontal Pod Autoscaler** - No hay autoscaling automático
12. **Sin Resource Quotas** - No hay límites por namespace
13. **Kubernetes Dashboard con LoadBalancer pending** - Servicio no accesible

---

## 📈 RECOMENDACIONES PRIORITARIAS

### 🔥 URGENTE (Semana 1)

#### 1. Instalar MetalLB para gestión de IPs
```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml

# Configurar pool de IPs
cat <<EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: default-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.18.200-192.168.18.250
EOF
```

#### 2. Configurar Ingress Resources
- Crear Ingress para Jenkins, Grafana, ArgoCD, Prometheus
- Configurar DNS interno (`*.mitoga.local`)
- Reducir exposición de puertos NodePort

#### 3. Implementar Resource Limits
```yaml
resources:
  requests:
    memory: "256Mi"
    cpu: "100m"
  limits:
    memory: "512Mi"
    cpu: "500m"
```

#### 4. Instalar Cert-Manager para SSL/TLS
```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.3/cert-manager.yaml
```

### ⚡ ALTA PRIORIDAD (Semana 2-3)

#### 5. Implementar Network Policies
- Aislar namespaces (databases solo accesible desde cicd/argocd)
- Restringir tráfico entre pods

#### 6. Configurar Backups con Velero
```bash
helm install velero vmware-tanzu/velero \
  --namespace velero \
  --create-namespace \
  --set configuration.backupStorageLocation[0].bucket=k3s-backups \
  --set configuration.backupStorageLocation[0].provider=aws
```

#### 7. Agregar Security Scanning
- Instalar Trivy para escaneo de imágenes
- Configurar SonarQube para análisis de código (ya existe pero no activo)

#### 8. Optimizar Oracle Database
- Reducir consumo de RAM (actualmente 2.5 GB)
- Considerar usar PostgreSQL para más servicios

### 🎯 MEDIA PRIORIDAD (Mes 1-2)

#### 9. Implementar Alta Disponibilidad
- **Opción 1:** Agregar 2 masters + 2 workers (5 nodos total)
- **Opción 2:** Considerar K3s multi-cluster con failover

#### 10. Configurar HPA (Horizontal Pod Autoscaler)
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: jenkins-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: jenkins
  minReplicas: 1
  maxReplicas: 3
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 80
```

#### 11. Implementar Resource Quotas por Namespace
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: cicd-quota
  namespace: cicd
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 8Gi
    limits.cpu: "8"
    limits.memory: 16Gi
```

#### 12. Configurar Monitoreo Avanzado
- ServiceMonitors para todas las aplicaciones
- Dashboards Grafana personalizados
- Alertas críticas (CPU > 80%, RAM > 90%, Disk > 85%)

---

## 🎯 PLAN DE ACCIÓN CI/CD

### Objetivo
Configurar pipeline CI/CD completo para `mitoga-backend` desplegando a este servidor K3s.

### Pasos

#### 1. Preparar Namespace de Aplicación
```bash
kubectl create namespace production
kubectl create namespace staging
kubectl create namespace development
```

#### 2. Configurar Jenkins Pipeline
- Crear Jenkinsfile en repositorio `mitoga_core`
- Configurar credentials en Jenkins:
  - GitHub (SCM)
  - Harbor/DockerHub (Container Registry)
  - Kubernetes (kubectl config)

#### 3. Configurar ArgoCD Application
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: mitoga-backend
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/mlditsoft-mitoga/mitoga_core.git
    targetRevision: master
    path: k8s/overlays/production
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

#### 4. Crear Manifiestos K8s para Mitoga Backend
```
k8s/
├── base/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── configmap.yaml
│   └── kustomization.yaml
└── overlays/
    ├── development/
    ├── staging/
    └── production/
        ├── ingress.yaml
        ├── hpa.yaml
        └── kustomization.yaml
```

#### 5. Configurar Monitoring
- ServiceMonitor para métricas de Spring Boot Actuator
- Dashboard Grafana para Mitoga Backend
- Alertas de salud (health checks, error rate)

---

## 📊 MÉTRICAS CLAVE DEL CLUSTER

### Salud General
- **Estado del Cluster:** ✅ Healthy (1/1 nodos Ready)
- **Pods Totales:** 29 pods
- **Pods Running:** 27/29 (93%)
- **Pods Completed:** 2/29 (helm installers)
- **Pods Failed/Pending:** 0 ✅

### Recursos
- **CPU Utilization:** 7% (300m/4000m)
- **Memory Utilization:** 19% (6.2 GB / 31 GB)
- **Disk /var/lib:** 17% (28 GB / 180 GB)
- **Disk /:** 5% (11 GB / 275 GB)

### Storage
- **PVs Totales:** 9
- **PVCs Bound:** 9/9 (100%)
- **Storage Provisionado:** 125 GB
- **Storage Usado (estimado):** ~40 GB (32%)

### Networking
- **LoadBalancer Services:** 4 (3 activos + 1 pending)
- **NodePort Services:** 6
- **ClusterIP Services:** ~20+
- **Ingress Resources:** 0 ❌

---

## ✅ CONCLUSIONES

### Fortalezas del Setup Actual
1. ✅ Stack CI/CD completo (Jenkins, ArgoCD, Prometheus, Grafana, Vault)
2. ✅ Monitoreo y logging centralizado (Prometheus, Grafana, Loki)
3. ✅ GitOps implementado (ArgoCD)
4. ✅ Bases de datos productivas (PostgreSQL, Oracle)
5. ✅ Buen rendimiento (7% CPU, 19% RAM)
6. ✅ Storage suficiente (830 GB disponibles)

### Debilidades Críticas
1. ❌ Cluster de nodo único (Sin HA)
2. ❌ Sin MetalLB (gestión de IPs deficiente)
3. ❌ Sin Ingress configurados (exposición directa de puertos)
4. ❌ Sin Network Policies (sin aislamiento de red)
5. ❌ Sin backups automatizados (Velero)
6. ❌ Sin Resource Limits/Quotas
7. ❌ Sin SSL/TLS automatizado (Cert-Manager)

### Riesgo General
**MEDIO-ALTO** 🟡🔴

El cluster está funcional y estable, pero tiene riesgos significativos:
- **Disponibilidad:** Nodo único = punto único de fallo
- **Seguridad:** Sin aislamiento de red ni políticas de seguridad
- **Escalabilidad:** Sin autoscaling ni gestión avanzada de recursos
- **Disaster Recovery:** Sin backups automatizados

---

## 🚀 PRÓXIMOS PASOS INMEDIATOS

### Esta Semana
1. [ ] Instalar MetalLB con pool de IPs
2. [ ] Crear Ingress para servicios principales
3. [ ] Configurar Resource Limits en deployments críticos
4. [ ] Instalar Cert-Manager

### Próximas 2 Semanas
5. [ ] Implementar Network Policies
6. [ ] Configurar Velero para backups
7. [ ] Agregar Trivy para security scanning
8. [ ] Optimizar Oracle Database

### Próximo Mes
9. [ ] Evaluar expansión a cluster multi-nodo
10. [ ] Configurar HPA para aplicaciones críticas
11. [ ] Implementar Resource Quotas por namespace
12. [ ] Desplegar Mitoga Backend con pipeline completo

---

**Reporte generado por:** DevSecOps Senior  
**Fecha:** 12 de noviembre de 2025  
**Versión:** 1.0.0
