# Checklist: Stack Tecnológico Preferido del Cliente

> **Propósito:** Recopilar las preferencias, restricciones y estándares tecnológicos del cliente para alinear las decisiones de arquitectura con sus capacidades y políticas organizacionales.

---

## 📋 Información General

| Campo | Valor |
|-------|-------|
| **Cliente/Organización** | |
| **Proyecto** | |
| **Fecha de Captura** | |
| **Contacto Técnico** | |
| **Cargo** | |
| **Email** | |

---

## 🎯 Contexto Organizacional

### Madurez Tecnológica

- [ ] **Startup** (equipo pequeño, stack moderno, agilidad)
- [ ] **Empresa Mediana** (equipo establecido, stack en transición)
- [ ] **Enterprise** (múltiples equipos, stack legacy + moderno, procesos formales)
- [ ] **Gobierno/Sector Público** (normativas estrictas, stack homologado)

### Estrategia Cloud

- [ ] **Cloud-First** (prioridad servicios cloud)
- [ ] **Cloud-Native** (contenedores, microservicios, serverless)
- [ ] **Hybrid Cloud** (on-premise + cloud)
- [ ] **On-Premise Only** (sin servicios cloud)
- [ ] **Multi-Cloud** (AWS + Azure + GCP)

**Proveedor(es) Cloud Preferido(s):**
- [ ] AWS (Amazon Web Services)
- [ ] Azure (Microsoft)
- [ ] GCP (Google Cloud Platform)
- [ ] Oracle Cloud
- [ ] IBM Cloud
- [ ] Otro: _______________

---

## 💻 Frontend

### Framework/Librería Principal

- [ ] **React** (versión preferida: _______)
  - [ ] Create React App
  - [ ] Vite
  - [ ] Next.js (versión: _______)
- [ ] **Angular** (versión preferida: _______)
- [ ] **Vue.js** (versión preferida: _______)
  - [ ] Nuxt.js
- [ ] **Svelte** / SvelteKit
- [ ] **Vanilla JavaScript** (sin framework)
- [ ] Otro: _______________

### Lenguaje

- [ ] **JavaScript** (ES6+)
- [ ] **TypeScript** (versión preferida: _______)
- [ ] Otro: _______________

### State Management

- [ ] Redux / Redux Toolkit
- [ ] Zustand
- [ ] MobX
- [ ] Context API (React)
- [ ] Pinia (Vue)
- [ ] NgRx (Angular)
- [ ] Otro: _______________

### Estilos y UI

- [ ] **CSS Puro** / SASS / LESS
- [ ] **Tailwind CSS**
- [ ] **Bootstrap** (versión: _______)
- [ ] **Material-UI (MUI)**
- [ ] **Ant Design**
- [ ] **Chakra UI**
- [ ] **Styled Components**
- [ ] CSS Modules
- [ ] Otro: _______________

### Build Tools

- [ ] Webpack
- [ ] Vite
- [ ] esbuild
- [ ] Parcel
- [ ] Rollup
- [ ] Otro: _______________

---

## ⚙️ Backend

### Lenguaje Principal

- [ ] **Node.js** (versión LTS: _______)
- [ ] **Python** (versión: _______)
- [ ] **Java** (versión: _______)
- [ ] **.NET** (versión: _______)
- [ ] **Go**
- [ ] **PHP** (versión: _______)
- [ ] **Ruby**
- [ ] Otro: _______________

### Framework Web

**Para Node.js:**
- [ ] Express.js
- [ ] Fastify
- [ ] NestJS
- [ ] Hapi
- [ ] Koa

**Para Python:**
- [ ] Django
- [ ] Flask
- [ ] FastAPI
- [ ] Pyramid

**Para Java:**
- [ ] Spring Boot (versión: _______)
- [ ] Quarkus
- [ ] Micronaut

**Para .NET:**
- [ ] ASP.NET Core (versión: _______)
- [ ] Minimal APIs

**Para PHP:**
- [ ] Laravel
- [ ] Symfony

**Otro:** _______________

### Arquitectura de Servicios

- [ ] **Monolito Modular**
- [ ] **Microservicios**
- [ ] **Serverless** (Functions)
- [ ] **Event-Driven**
- [ ] **Híbrida**

### ORM / Database Access

- [ ] Prisma
- [ ] TypeORM
- [ ] Sequelize
- [ ] Mongoose
- [ ] Hibernate
- [ ] Entity Framework
- [ ] SQLAlchemy
- [ ] Dapper
- [ ] GORM
- [ ] Eloquent (Laravel)
- [ ] **ADO.NET / SQL puro**
- [ ] Otro: _______________

---

## 🗄️ Base de Datos

### Base de Datos Relacional

- [ ] **PostgreSQL** (versión preferida: _______)
- [ ] **MySQL** (versión: _______)
- [ ] **SQL Server** (versión: _______)
- [ ] **Oracle Database**
- [ ] **MariaDB**
- [ ] **SQLite** (desarrollo/testing)
- [ ] Otro: _______________

### Base de Datos NoSQL

- [ ] **MongoDB** (versión: _______)
- [ ] **Redis** (cache/sessions)
- [ ] **Elasticsearch** (búsqueda)
- [ ] **DynamoDB** (AWS)
- [ ] **Cosmos DB** (Azure)
- [ ] **Cassandra**
- [ ] **Neo4j** (grafos)
- [ ] Otro: _______________

### Estrategia de Persistencia

- [ ] Una sola DB para todo
- [ ] Polyglot Persistence (múltiples DBs especializadas)
- [ ] Read Replicas / CQRS
- [ ] Sharding
- [ ] Event Sourcing

---

## 🔐 Autenticación y Autorización

### Mecanismo de Autenticación

- [ ] **JWT (JSON Web Tokens)**
- [ ] **OAuth 2.0 / OpenID Connect**
- [ ] **SAML 2.0**
- [ ] **Session-based** (cookies)
- [ ] **API Keys**
- [ ] Certificados X.509 / mTLS

### Proveedor de Identidad

- [ ] **Auth0**
- [ ] **Firebase Authentication**
- [ ] **AWS Cognito**
- [ ] **Azure AD / Entra ID**
- [ ] **Okta**
- [ ] **Keycloak** (self-hosted)
- [ ] **Custom** (implementación propia)
- [ ] Active Directory (on-premise)
- [ ] LDAP
- [ ] Otro: _______________

### Autorización

- [ ] RBAC (Role-Based Access Control)
- [ ] ABAC (Attribute-Based Access Control)
- [ ] ACL (Access Control Lists)
- [ ] Policy-based (OPA, Casbin)

---

## 🚀 DevOps y CI/CD

### Control de Versiones

- [ ] **Git** (GitHub, GitLab, Bitbucket, Azure DevOps)
- [ ] Otro: _______________

**Plataforma preferida:**
- [ ] GitHub
- [ ] GitLab
- [ ] Bitbucket
- [ ] Azure DevOps / Azure Repos
- [ ] AWS CodeCommit
- [ ] Otro: _______________

### CI/CD Pipeline

- [ ] **GitHub Actions**
- [ ] **GitLab CI/CD**
- [ ] **Jenkins**
- [ ] **Azure Pipelines**
- [ ] **CircleCI**
- [ ] **Travis CI**
- [ ] **AWS CodePipeline**
- [ ] **ArgoCD** (GitOps)
- [ ] **Tekton**
- [ ] Otro: _______________

### Containerización

- [ ] **Docker** (obligatorio/preferido/opcional)
- [ ] Podman
- [ ] No se usan contenedores

### Orquestación de Contenedores

- [ ] **Kubernetes** (EKS, AKS, GKE, on-premise)
- [ ] **Amazon ECS / Fargate**
- [ ] **Azure Container Apps**
- [ ] **Google Cloud Run**
- [ ] **Docker Swarm**
- [ ] **Nomad**
- [ ] No se requiere orquestación

### Infrastructure as Code (IaC)

- [ ] **Terraform**
- [ ] **AWS CloudFormation**
- [ ] **Azure Bicep / ARM Templates**
- [ ] **Pulumi**
- [ ] **Ansible**
- [ ] **CDK** (AWS/Azure/Terraform)
- [ ] No se usa IaC
- [ ] Otro: _______________

---

## 📊 Observabilidad y Monitoreo

### Logging

- [ ] **CloudWatch Logs** (AWS)
- [ ] **Azure Monitor / Log Analytics**
- [ ] **Google Cloud Logging**
- [ ] **ELK Stack** (Elasticsearch, Logstash, Kibana)
- [ ] **Grafana Loki**
- [ ] **Splunk**
- [ ] **Datadog**
- [ ] **New Relic**
- [ ] Otro: _______________

### Métricas y APM (Application Performance Monitoring)

- [ ] **Prometheus + Grafana**
- [ ] **Datadog**
- [ ] **New Relic**
- [ ] **Dynatrace**
- [ ] **AWS CloudWatch**
- [ ] **Azure Application Insights**
- [ ] **Google Cloud Monitoring**
- [ ] **Elastic APM**
- [ ] Otro: _______________

### Tracing Distribuido

- [ ] **Jaeger**
- [ ] **Zipkin**
- [ ] **AWS X-Ray**
- [ ] **Azure Application Insights**
- [ ] **OpenTelemetry**
- [ ] **Datadog APM**
- [ ] Otro: _______________

### Alerting

- [ ] **PagerDuty**
- [ ] **Opsgenie**
- [ ] **Slack / Microsoft Teams** (webhooks)
- [ ] **CloudWatch Alarms**
- [ ] **Grafana Alerts**
- [ ] **Prometheus Alertmanager**
- [ ] Otro: _______________

---

## 🔒 Seguridad

### Escaneo de Vulnerabilidades

- [ ] **Snyk**
- [ ] **OWASP Dependency-Check**
- [ ] **GitHub Dependabot**
- [ ] **Trivy**
- [ ] **Aqua Security**
- [ ] **SonarQube**
- [ ] Otro: _______________

### Secrets Management

- [ ] **AWS Secrets Manager**
- [ ] **Azure Key Vault**
- [ ] **Google Secret Manager**
- [ ] **HashiCorp Vault**
- [ ] **Doppler**
- [ ] **Variables de entorno** (CI/CD)
- [ ] Otro: _______________

### WAF (Web Application Firewall)

- [ ] **AWS WAF**
- [ ] **Azure WAF**
- [ ] **Cloudflare WAF**
- [ ] **Imperva**
- [ ] No se requiere
- [ ] Otro: _______________

### SSL/TLS Certificates

- [ ] **AWS Certificate Manager (ACM)**
- [ ] **Let's Encrypt**
- [ ] **DigiCert**
- [ ] **Azure Key Vault Certificates**
- [ ] Certificados corporativos (CA interna)
- [ ] Otro: _______________

---

## 🧪 Testing

### Unit Testing

- [ ] **Jest** (JavaScript/TypeScript)
- [ ] **Vitest**
- [ ] **Mocha + Chai**
- [ ] **JUnit** (Java)
- [ ] **NUnit / xUnit** (.NET)
- [ ] **pytest** (Python)
- [ ] **RSpec** (Ruby)
- [ ] Otro: _______________

### Integration Testing

- [ ] **Supertest** (Node.js)
- [ ] **Testcontainers**
- [ ] **Postman / Newman**
- [ ] **REST Assured** (Java)
- [ ] **Pact** (Contract Testing)
- [ ] Otro: _______________

### E2E Testing

- [ ] **Cypress**
- [ ] **Playwright**
- [ ] **Selenium**
- [ ] **Puppeteer**
- [ ] **TestCafe**
- [ ] Otro: _______________

### Code Coverage

- [ ] **Istanbul / nyc**
- [ ] **JaCoCo** (Java)
- [ ] **Coverage.py** (Python)
- [ ] Integrado en SonarQube
- [ ] **Target mínimo de cobertura:** _______% 

---

## 📡 APIs y Comunicación

### Estilo de API

- [ ] **REST / RESTful**
- [ ] **GraphQL**
- [ ] **gRPC**
- [ ] **WebSockets**
- [ ] **Server-Sent Events (SSE)**
- [ ] **SOAP** (legacy)

### Documentación de APIs

- [ ] **OpenAPI / Swagger**
- [ ] **Postman Collections**
- [ ] **GraphQL Playground / GraphiQL**
- [ ] **Redoc**
- [ ] **Stoplight**
- [ ] Documentación manual (Markdown)

### API Gateway

- [ ] **AWS API Gateway**
- [ ] **Azure API Management**
- [ ] **Google Cloud API Gateway**
- [ ] **Kong**
- [ ] **Apigee**
- [ ] **Tyk**
- [ ] No se requiere
- [ ] Otro: _______________

### Message Broker / Event Streaming

- [ ] **RabbitMQ**
- [ ] **Apache Kafka**
- [ ] **AWS SQS / SNS**
- [ ] **Azure Service Bus**
- [ ] **Google Pub/Sub**
- [ ] **Redis Pub/Sub**
- [ ] **NATS**
- [ ] No se requiere
- [ ] Otro: _______________

---

## 🌐 Networking y CDN

### CDN (Content Delivery Network)

- [ ] **CloudFront** (AWS)
- [ ] **Azure CDN**
- [ ] **Google Cloud CDN**
- [ ] **Cloudflare**
- [ ] **Fastly**
- [ ] **Akamai**
- [ ] No se requiere

### DNS

- [ ] **Route 53** (AWS)
- [ ] **Azure DNS**
- [ ] **Google Cloud DNS**
- [ ] **Cloudflare DNS**
- [ ] DNS corporativo interno
- [ ] Otro: _______________

### Load Balancer

- [ ] **AWS ALB / NLB**
- [ ] **Azure Load Balancer**
- [ ] **Google Cloud Load Balancing**
- [ ] **NGINX**
- [ ] **HAProxy**
- [ ] **Traefik**
- [ ] Kubernetes Ingress

---

## 📦 Almacenamiento y Assets

### Object Storage

- [ ] **AWS S3**
- [ ] **Azure Blob Storage**
- [ ] **Google Cloud Storage**
- [ ] **MinIO** (self-hosted)
- [ ] No se requiere

### File System / Shared Storage

- [ ] **AWS EFS**
- [ ] **Azure Files**
- [ ] **Google Filestore**
- [ ] NFS
- [ ] No se requiere

---

## 📚 Documentación y Colaboración

### Documentación Técnica

- [ ] **Markdown en Git**
- [ ] **Confluence**
- [ ] **Notion**
- [ ] **SharePoint**
- [ ] **GitBook**
- [ ] **Read the Docs**
- [ ] **Docusaurus**
- [ ] Otro: _______________

### Diagramas de Arquitectura

- [ ] **PlantUML + C4 Model** (código versionado)
- [ ] **Draw.io / Diagrams.net**
- [ ] **Lucidchart**
- [ ] **Miro**
- [ ] **Structurizr**
- [ ] **Visio** (Microsoft)
- [ ] **Mermaid** (embebido en Markdown)
- [ ] Otro: _______________

### Gestión de Proyectos

- [ ] **Jira**
- [ ] **Azure DevOps Boards**
- [ ] **GitHub Projects**
- [ ] **GitLab Issues**
- [ ] **Asana**
- [ ] **Monday.com**
- [ ] **Linear**
- [ ] Otro: _______________

---

## 🚫 Restricciones y Prohibiciones

### Tecnologías Prohibidas

> Listar tecnologías que NO deben usarse por políticas organizacionales, seguridad, o incompatibilidades.

- [ ] Ninguna prohibición específica
- [ ] Licencias GPL (por cuestiones legales)
- [ ] Servicios de proveedores específicos: _______________
- [ ] Tecnologías descontinuadas: _______________
- [ ] Frameworks/librerías específicas: _______________

**Detalles:**

```
[Espacio para detallar restricciones]
```

---

## 🎓 Capacidades del Equipo

### Experiencia del Equipo Técnico

| Tecnología | Nivel de Experiencia |
|------------|---------------------|
| Frontend (React/Angular/Vue) | ⭐⭐⭐⭐⭐ |
| Backend (Node/Python/Java/.NET) | ⭐⭐⭐⭐⭐ |
| DevOps / Cloud | ⭐⭐⭐⭐⭐ |
| Kubernetes | ⭐⭐⭐⭐⭐ |
| Microservicios | ⭐⭐⭐⭐⭐ |
| Seguridad | ⭐⭐⭐⭐⭐ |

> **Escala:** ⭐ = Básico | ⭐⭐⭐ = Intermedio | ⭐⭐⭐⭐⭐ = Experto

### Disponibilidad para Capacitación

- [ ] **Sí** - El equipo puede capacitarse en tecnologías nuevas
- [ ] **Limitada** - Solo capacitación en herramientas críticas
- [ ] **No** - Se requiere stack conocido por el equipo actual

**Budget para capacitación:** _______________

---

## 💰 Consideraciones de Costos

### Preferencia de Licenciamiento

- [ ] **Open Source prioritario**
- [ ] **Commercial OK** (con presupuesto)
- [ ] **Enterprise support requerido**
- [ ] **Freemium/SaaS aceptable**

### Budget Mensual Cloud Estimado

- [ ] < $500/mes (desarrollo/MVP)
- [ ] $500 - $2,000/mes (startup)
- [ ] $2,000 - $10,000/mes (empresa mediana)
- [ ] $10,000 - $50,000/mes (enterprise)
- [ ] > $50,000/mes (high-scale enterprise)
- [ ] Sin restricción de presupuesto

---

## 📝 Compliance y Regulaciones

### Normativas Aplicables

- [ ] **GDPR** (Protección de datos - EU)
- [ ] **CCPA** (California Consumer Privacy Act)
- [ ] **HIPAA** (datos de salud - USA)
- [ ] **PCI-DSS** (pagos con tarjeta)
- [ ] **SOC 2**
- [ ] **ISO 27001**
- [ ] **LGPD** (Brasil)
- [ ] **Ley de Habeas Data** (Colombia/LATAM)
- [ ] Regulaciones gubernamentales específicas: _______________
- [ ] Ninguna

### Residencia de Datos

- [ ] **Global** (sin restricciones geográficas)
- [ ] **Regional:** _______________
- [ ] **On-premise obligatorio** (datos sensibles)
- [ ] **Datos encriptados en reposo y tránsito** (obligatorio)

---

## 🔄 Integración con Sistemas Existentes

### Sistemas Legados a Integrar

| Sistema | Tecnología | Protocolo/API | Estado |
|---------|-----------|---------------|--------|
| ERP | SAP/Oracle/Dynamics | REST/SOAP | Activo |
| CRM | Salesforce/Dynamics | REST | Activo |
| | | | |
| | | | |

### Formatos de Intercambio

- [ ] **JSON**
- [ ] **XML**
- [ ] **CSV**
- [ ] **Protobuf**
- [ ] **EDIFACT** (EDI)
- [ ] Otro: _______________

---

## ✅ Prioridades y Preferencias

### Factores Críticos (ordenar del 1 al 10, siendo 1 el más importante)

- [ ] **Performance / Velocidad**
- [ ] **Escalabilidad**
- [ ] **Seguridad**
- [ ] **Costo (TCO)**
- [ ] **Time-to-Market**
- [ ] **Mantenibilidad**
- [ ] **Compatibilidad con stack actual**
- [ ] **Experiencia del equipo**
- [ ] **Soporte Enterprise**
- [ ] **Innovación / Tecnologías emergentes**

### Filosofía de Adopción Tecnológica

- [ ] **Conservative** (tecnologías probadas, estables, LTS)
- [ ] **Pragmatic** (balance entre estabilidad e innovación)
- [ ] **Early Adopter** (últimas versiones, tecnologías emergentes)

---

## 📎 Notas Adicionales

```
[Espacio para comentarios adicionales, contexto especial, decisiones arquitectónicas previas, 
lecciones aprendidas de proyectos anteriores, etc.]








```

---

## ✍️ Firmas y Aprobación

| Rol | Nombre | Firma | Fecha |
|-----|--------|-------|-------|
| **Arquitecto de Soluciones** | | | |
| **Tech Lead Cliente** | | | |
| **CTO / Director Tecnología** | | | |
| **PMO / Project Manager** | | | |

---

**Versión del Documento:** 1.0  
**Última Actualización:** {{ FECHA }}  
**Método:** CEIBA - Consolidación, Estructuración, Inteligencia, Best Practices, Arquitectura
