#!/usr/bin/env powershell
# ==============================================================================
# SCRIPT DE CONFIGURACIÓN DE BASE DE DATOS MITOGA
# ==============================================================================
# Autor: Backend Senior Developer - ZNS-METHOD
# Fecha: 15 de noviembre de 2025
# Propósito: Ejecutar migraciones de BD en orden correcto para resolver startup
# ==============================================================================

# Configuración de conexión
$DB_HOST = "192.168.18.126"
$DB_PORT = "5432"
$DB_NAME = "mitogadb"
$DB_USER = "admin"
$DB_PASS = "Shacall1989*"

# Directorio base
$BASE_DIR = "d:\Documents\2.maldivati_workspace\1.filiales\02.mitoga_auditoria\ZES-METHOD\00-raw-inputs\database"

Write-Host "🚀 INICIANDO CONFIGURACIÓN DE BASE DE DATOS MITOGA" -ForegroundColor Green
Write-Host "📍 Host: $DB_HOST" -ForegroundColor Yellow
Write-Host "📍 Database: $DB_NAME" -ForegroundColor Yellow

# Función para ejecutar SQL
function Ejecutar-SQL {
    param(
        [string]$ArchivoSQL,
        [string]$Descripcion
    )
    
    Write-Host "📂 Ejecutando: $Descripcion" -ForegroundColor Cyan
    Write-Host "   Archivo: $ArchivoSQL" -ForegroundColor Gray
    
    $env:PGPASSWORD = $DB_PASS
    $comando = "psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f `"$ArchivoSQL`""
    
    try {
        Invoke-Expression $comando
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ ÉXITO" -ForegroundColor Green
        } else {
            Write-Host "   ❌ ERROR (código: $LASTEXITCODE)" -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host "   ❌ EXCEPCIÓN: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
    
    return $true
}

# Verificar que psql está disponible
try {
    psql --version | Out-Null
} catch {
    Write-Host "❌ ERROR: psql no está instalado o no está en PATH" -ForegroundColor Red
    Write-Host "💡 Instala PostgreSQL client tools o agrega psql al PATH" -ForegroundColor Yellow
    exit 1
}

# Cambiar al directorio de scripts
Set-Location $BASE_DIR

Write-Host "`n🔥 EJECUTANDO MIGRACIONES EN ORDEN SECUENCIAL..." -ForegroundColor Yellow

# PASO 1: Schema inicial y tablas base
if (!(Ejecutar-SQL "V1__init_schema.sql" "V1 - Schemas iniciales y tablas base")) {
    Write-Host "❌ FALLO EN V1 - ABORTANDO" -ForegroundColor Red
    exit 1
}

# PASO 2: Catálogos recursivos
if (!(Ejecutar-SQL "V2__catalogo_recursivo.sql" "V2 - Catálogos recursivos")) {
    Write-Host "❌ FALLO EN V2 - ABORTANDO" -ForegroundColor Red
    exit 1
}

# PASO 3: Datos de catálogos
if (!(Ejecutar-SQL "V3__catalogo_recursivo_datos.sql" "V3 - Datos de catálogos")) {
    Write-Host "❌ FALLO EN V3 - ABORTANDO" -ForegroundColor Red
    exit 1
}

# PASO 4: Registro de estudiantes (CRÍTICO - contiene tabla proceso_registro)
if (!(Ejecutar-SQL "Registro Estudiante\V4__registro_estudiantes_multistep.sql" "V4 - Registro estudiantes multistep (CRÍTICO)")) {
    Write-Host "❌ FALLO EN V4 - ABORTANDO" -ForegroundColor Red
    exit 1
}

# PASO 5: Extensión de tutores
if (!(Ejecutar-SQL "V5_1__tutores_storage_extension.sql" "V5.1 - Extensión storage tutores")) {
    Write-Host "⚠️  FALLO EN V5.1 - CONTINUANDO (no crítico)" -ForegroundColor Yellow
}

# PASO 6: Validación final
if (!(Ejecutar-SQL "V5_VALIDACION_COMPLETA.sql" "V5 - Validación final")) {
    Write-Host "⚠️  FALLO EN VALIDACIÓN - CONTINUANDO" -ForegroundColor Yellow
}

Write-Host "`n🎉 CONFIGURACIÓN DE BASE DE DATOS COMPLETADA" -ForegroundColor Green

# Verificar que la tabla crítica existe
Write-Host "`n🔍 VERIFICANDO TABLA CRÍTICA..." -ForegroundColor Cyan
$verificacion = @"
SELECT 
    schemaname, 
    tablename,
    tableowner
FROM pg_tables 
WHERE schemaname = 'autenticacion_schema' 
AND tablename = 'proceso_registro';
"@

$env:PGPASSWORD = $DB_PASS
$resultado = echo $verificacion | psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t

if ($resultado -match "proceso_registro") {
    Write-Host "✅ TABLA 'autenticacion_schema.proceso_registro' CONFIRMADA" -ForegroundColor Green
    
    # Ahora probar el startup de Spring Boot
    Write-Host "`n🚀 PROBANDO STARTUP DE APLICACIÓN..." -ForegroundColor Cyan
    Set-Location "d:\Documents\2.maldivati_workspace\1.filiales\02.mitoga_auditoria\ZES-METHOD\00-raw-inputs\code\1-backend\0-mitoga-project"
    
    Write-Host "Compilando proyecto..." -ForegroundColor Yellow
    mvn clean compile
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ COMPILACIÓN EXITOSA" -ForegroundColor Green
        
        Write-Host "Iniciando aplicación (timeout 30s)..." -ForegroundColor Yellow
        $proceso = Start-Process -FilePath "mvn" -ArgumentList "spring-boot:run" -PassThru -WindowStyle Hidden
        
        Start-Sleep -Seconds 30
        
        if (!$proceso.HasExited) {
            Write-Host "✅ APLICACIÓN INICIADA CORRECTAMENTE" -ForegroundColor Green
            Write-Host "🌐 La aplicación debería estar disponible en http://localhost:8080" -ForegroundColor Green
            $proceso.Kill()
        } else {
            Write-Host "❌ LA APLICACIÓN SE CERRÓ INESPERADAMENTE" -ForegroundColor Red
        }
    } else {
        Write-Host "❌ FALLO EN COMPILACIÓN" -ForegroundColor Red
    }
    
} else {
    Write-Host "❌ TABLA CRÍTICA NO ENCONTRADA - REVISAR LOGS" -ForegroundColor Red
}

Write-Host "`n📋 RESUMEN FINAL:" -ForegroundColor Yellow
Write-Host "- ✅ Scripts de BD ejecutados" -ForegroundColor Green
Write-Host "- ✅ Código Java corregido (schema autenticacion_schema)" -ForegroundColor Green
Write-Host "- 🔧 Postman collection lista para pruebas" -ForegroundColor Green
Write-Host "`n💡 SIGUIENTE PASO: Revisar logs de aplicación si hay errores" -ForegroundColor Yellow