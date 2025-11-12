# Código Fuente - Modernización y Migración

Esta carpeta contiene el código fuente del sistema existente cuando el proyecto es de **modernización, migración o análisis de obsolescencia**.

## 📂 Estructura

```
code/
├── README.md           # Este archivo
├── frontend/           # Código fuente del frontend
├── backend/            # Código fuente del backend
└── mobile/             # Código fuente de aplicaciones móviles
```

---

## 🎯 Cuándo usar esta carpeta

### ✅ **Proyectos de Modernización/Migración:**
- Análisis de obsolescencia de proyecto existente
- Refactorización de arquitectura legacy
- Migración de tecnologías (ej: Java 8 → 17, Angular → React)
- Modernización a cloud-native
- Upgrade de frameworks (Spring Boot 2.x → 3.x)

### ❌ **NO usar para:**
- Proyectos greenfield (nuevo desarrollo desde cero)
- Solo documentación de requisitos

---

## 📁 Subcarpetas

### `/frontend/`
**Contenido esperado:**
- Código fuente de aplicaciones web (SPA, SSR)
- Frameworks: React, Angular, Vue, Svelte, etc.
- Archivos de configuración (package.json, webpack, vite, etc.)

**Estructura sugerida:**
```
frontend/
├── src/
├── public/
├── package.json
├── tsconfig.json
├── .env
└── README.md
```

---

### `/backend/`
**Contenido esperado:**
- Código fuente de servicios backend/APIs
- Lenguajes: Node.js, Python, Java, .NET, Go, PHP, etc.
- Archivos de configuración (pom.xml, build.gradle, requirements.txt, etc.)

**Estructura sugerida:**
```
backend/
├── src/
├── tests/
├── config/
├── pom.xml / build.gradle / package.json / requirements.txt
└── README.md
```

---

### `/mobile/`
**Contenido esperado:**
- Aplicaciones móviles nativas o híbridas
- Plataformas: iOS (Swift), Android (Kotlin/Java), React Native, Flutter
- Archivos de proyecto (Xcode, Android Studio, etc.)

**Estructura sugerida:**
```
mobile/
├── ios/              # Proyecto iOS (si aplica)
├── android/          # Proyecto Android (si aplica)
├── src/              # Código compartido (React Native, Flutter)
├── package.json      # React Native
├── pubspec.yaml      # Flutter
└── README.md
```

---

## 📋 Checklist de Preparación

Antes de ejecutar el **Agente 1: Análisis de Obsolescencia**, asegúrate de:

### ✅ Código Fuente Disponible
- [ ] Repositorio clonado o código extraído
- [ ] Acceso a todas las ramas relevantes (main, develop, release)
- [ ] Incluye archivos de configuración (.env.example, config samples)
- [ ] Dependencias documentadas (package.json, pom.xml, requirements.txt)

### ✅ Estructura Organizada
- [ ] Frontend separado de backend (si aplica)
- [ ] Mobile separado de web (si aplica)
- [ ] Archivos de build/configuración incluidos
- [ ] README de cada módulo incluido

### ✅ Información de Contexto
- [ ] Versión actual de frameworks/lenguajes documentada
- [ ] Historial de versiones (CHANGELOG) disponible
- [ ] Documentación técnica existente copiada a `/pdfs/` o `/word/`

---

## 🔍 Análisis Recomendado

### Herramientas de Análisis Automático

#### **Para Node.js/JavaScript/TypeScript:**
```bash
# Análisis de dependencias obsoletas
cd ./code/frontend  # o backend si Node.js
npm outdated
npm audit

# Análisis de código
npx eslint . --ext .js,.ts,.jsx,.tsx
npx tsc --noEmit  # TypeScript type check
```

#### **Para Java/Spring Boot:**
```bash
cd ./code/backend
# Análisis de dependencias con Maven
./mvnw versions:display-dependency-updates
./mvnw dependency-check:check  # OWASP Dependency Check

# O con Gradle
./gradlew dependencyUpdates
```

#### **Para Python:**
```bash
cd ./code/backend
# Análisis de dependencias
pip list --outdated
safety check  # Vulnerabilidades conocidas
```

#### **Para .NET:**
```bash
cd ./code/backend
dotnet list package --outdated
dotnet format --verify-no-changes  # Code formatting check
```

---

## 🤖 Integración con Agentes CEIBA

### Agente 1: Análisis de Obsolescencia

**Comando de ejecución:**
```bash
Claude/GPT-4, ejecuta:
./02-agentes/1.analisis_obsolescencia/prompt-analisis-obsolescencia.md

CÓDIGO FUENTE:
./00-raw-inputs/code/frontend
./00-raw-inputs/code/backend
./00-raw-inputs/code/mobile

CONTEXTO CONSOLIDADO:
./01-context-consolidado/
```

**El agente analizará:**
- Stack tecnológico actual (versiones, frameworks, librerías)
- Dependencias obsoletas o con vulnerabilidades
- Arquitectura del código (patrones, estructura)
- Prácticas de desarrollo (testing, CI/CD)
- Deuda técnica y code smells
- Recomendaciones de modernización

---

## 📝 Notas Importantes

### ⚠️ Seguridad
- **NO incluir:** Archivos `.env` con credenciales reales, tokens, secrets
- **NO incluir:** node_modules, vendor, build outputs
- **Incluir:** `.env.example`, config samples, documentación de secrets requeridos

### 📦 Archivos Grandes
- Si el repositorio es muy grande (> 500MB), considerar:
  - Clonar con `--depth 1` (shallow clone)
  - Excluir historial de Git (solo código actual)
  - Comprimir y referenciar ubicación externa

### 🔗 Repositorios Remotos
Si el código está en un repositorio remoto accesible:
```markdown
# Crear archivo: ./code/REPOSITORY_INFO.md

## Repositorio Remoto

- **URL:** https://github.com/company/project
- **Branch principal:** main
- **Última versión:** v2.3.4
- **Acceso:** [Instrucciones para clonar]

## Módulos

- **Frontend:** /apps/web
- **Backend:** /services/api
- **Mobile:** /apps/mobile
```

---

## ✅ Ejemplo de Estructura Completa

```
00-raw-inputs/
├── pdfs/
├── excel/
├── word/
├── powerpoint/
├── imagenes/
├── otros/
└── code/                              # ← Nueva carpeta
    ├── README.md                      # Este archivo
    ├── REPOSITORY_INFO.md             # Info del repositorio remoto
    ├── frontend/
    │   ├── src/
    │   ├── public/
    │   ├── package.json
    │   ├── tsconfig.json
    │   └── README.md
    ├── backend/
    │   ├── src/
    │   ├── tests/
    │   ├── pom.xml
    │   └── README.md
    └── mobile/
        ├── android/
        ├── ios/
        ├── src/
        └── README.md
```

---

## 🔗 Referencias

- **Agente de Obsolescencia:** `../../02-agentes/1.analisis_obsolescencia/prompt-analisis-obsolescencia.md`
- **Documentación Principal:** `../../README.md`

---

**Versión:** Método CEIBA v1.2  
**Uso:** Proyectos de modernización, migración y análisis de obsolescencia
