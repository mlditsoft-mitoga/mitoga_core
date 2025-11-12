# Script para ejecutar tests de API con Newman en Windows
# Uso: .\run-newman-tests.ps1 [-Environment local|qa|production]
# Ejemplo: .\run-newman-tests.ps1 -Environment local

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('local', 'dev', 'development', 'qa', 'test', 'testing', 'prod', 'production')]
    [string]$Environment = 'local'
)

# Configuración
$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Collection = Join-Path $ScriptDir "Mitoga-API.postman_collection.json"

# Mapear ambiente a archivo de entorno
switch -Regex ($Environment) {
    '^(local|dev|development)$' {
        $EnvFile = Join-Path $ScriptDir "Mitoga-Local.postman_environment.json"
        $EnvName = "Local"
    }
    '^(qa|test|testing)$' {
        $EnvFile = Join-Path $ScriptDir "Mitoga-QA.postman_environment.json"
        $EnvName = "QA"
    }
    '^(prod|production)$' {
        $EnvFile = Join-Path $ScriptDir "Mitoga-Production.postman_environment.json"
        $EnvName = "Production"
        
        Write-Host "⚠️  ADVERTENCIA: Ejecutando tests en PRODUCCIÓN" -ForegroundColor Red
        $confirm = Read-Host "¿Estás seguro? (yes/no)"
        if ($confirm -ne "yes") {
            Write-Host "Tests cancelados" -ForegroundColor Yellow
            exit 0
        }
    }
}

# Verificar que Newman esté instalado
try {
    $null = Get-Command newman -ErrorAction Stop
} catch {
    Write-Host "❌ Newman no está instalado" -ForegroundColor Red
    Write-Host "Instalar con: npm install -g newman" -ForegroundColor Yellow
    exit 1
}

# Verificar que los archivos existan
if (-not (Test-Path $Collection)) {
    Write-Host "❌ Colección no encontrada: $Collection" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $EnvFile)) {
    Write-Host "❌ Archivo de entorno no encontrado: $EnvFile" -ForegroundColor Red
    exit 1
}

# Crear directorio para reportes
$ReportsDir = Join-Path $ScriptDir "newman-reports"
if (-not (Test-Path $ReportsDir)) {
    New-Item -ItemType Directory -Path $ReportsDir | Out-Null
}

# Timestamp para el reporte
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$ReportPrefix = Join-Path $ReportsDir "newman-report-$EnvName-$Timestamp"

# Mostrar información
Write-Host "🚀 Ejecutando tests de API" -ForegroundColor Green
Write-Host "   Colección: Mitoga-API.postman_collection.json"
Write-Host "   Ambiente: $EnvName"
Write-Host "   Fecha: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Host ""

# Ejecutar Newman con reportes HTML, JSON y JUnit
try {
    newman run $Collection `
        -e $EnvFile `
        --reporters cli,html,json,junit `
        --reporter-html-export "$ReportPrefix.html" `
        --reporter-json-export "$ReportPrefix.json" `
        --reporter-junit-export "$ReportPrefix.xml" `
        --timeout-request 10000 `
        --timeout-script 5000 `
        --color on `
        --bail
    
    $ExitCode = $LASTEXITCODE
} catch {
    Write-Host "❌ Error al ejecutar Newman: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
if ($ExitCode -eq 0) {
    Write-Host "✅ Tests completados exitosamente" -ForegroundColor Green
    Write-Host ""
    Write-Host "📊 Reportes generados:"
    Write-Host "   HTML: $ReportPrefix.html"
    Write-Host "   JSON: $ReportPrefix.json"
    Write-Host "   JUnit: $ReportPrefix.xml"
    
    # Abrir reporte HTML en navegador (opcional)
    Write-Host ""
    $openReport = Read-Host "¿Abrir reporte HTML? (y/n)"
    if ($openReport -eq "y") {
        Start-Process "$ReportPrefix.html"
    }
} else {
    Write-Host "❌ Tests fallaron con código: $ExitCode" -ForegroundColor Red
    Write-Host ""
    Write-Host "📊 Revisar reporte de errores:"
    Write-Host "   HTML: $ReportPrefix.html"
    
    # Abrir reporte de errores automáticamente
    Write-Host ""
    $openReport = Read-Host "¿Abrir reporte de errores? (y/n)"
    if ($openReport -eq "y") {
        Start-Process "$ReportPrefix.html"
    }
}

exit $ExitCode
