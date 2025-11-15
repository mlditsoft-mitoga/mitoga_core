# ============================================================================
# Script: ejecutar_v5.1_storage.ps1
# Description: Ejecutar V5.1 Storage Extension para tutores
# Author: Database Engineering Team - ZNS-METHOD
# Date: 2025-11-14
# Prerequisitos: V4 y V5 ejecutados previamente
# ============================================================================

Write-Host "🗄️ INICIANDO V5.1 STORAGE EXTENSION TUTORES" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# Configuración de conexión
$env:PGPASSWORD = "Shacall1989*."
$servidor = "192.168.18.126"
$puerto = "5432"
$usuario = "admin"
$database = "mitogadb"
$archivo_script = "V5_1__tutores_storage_extension.sql"

Write-Host "📊 Parámetros de conexión:" -ForegroundColor Yellow
Write-Host "   Servidor: $servidor" -ForegroundColor Gray
Write-Host "   Puerto: $puerto" -ForegroundColor Gray
Write-Host "   Usuario: $usuario" -ForegroundColor Gray
Write-Host "   Base de datos: $database" -ForegroundColor Gray
Write-Host "   Script: $archivo_script" -ForegroundColor Gray
Write-Host ""

# Verificar que el archivo existe
if (-not (Test-Path $archivo_script)) {
    Write-Host "❌ ERROR: Archivo $archivo_script no encontrado" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Archivo $archivo_script encontrado" -ForegroundColor Green

# Ejecutar el script
Write-Host "🚀 Ejecutando V5.1 Storage Extension..." -ForegroundColor Yellow

try {
    $resultado = psql -h $servidor -p $puerto -U $usuario -d $database -f $archivo_script 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "🎉 V5.1 STORAGE EXTENSION COMPLETADO EXITOSAMENTE" -ForegroundColor Green
        Write-Host "============================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "📋 Resultado de la ejecución:" -ForegroundColor Cyan
        Write-Host $resultado -ForegroundColor White
        Write-Host ""
        Write-Host "✅ Sistema de archivos para tutores configurado" -ForegroundColor Green
        Write-Host "✅ 8 nuevos tipos de archivo agregados" -ForegroundColor Green
        Write-Host "✅ Tabla tutor_archivos creada" -ForegroundColor Green
        Write-Host "✅ Funciones helper disponibles" -ForegroundColor Green
    } else {
        Write-Host "❌ ERROR EN V5.1 STORAGE EXTENSION" -ForegroundColor Red
        Write-Host "=================================" -ForegroundColor Red
        Write-Host $resultado -ForegroundColor Red
        Write-Host ""
        Write-Host "💡 Verificar:" -ForegroundColor Yellow
        Write-Host "   - V4 y V5 ejecutados previamente" -ForegroundColor Gray
        Write-Host "   - Esquemas shared_schema y tutores_schema existen" -ForegroundColor Gray
        Write-Host "   - Función setup_updated_at_trigger corregida" -ForegroundColor Gray
        exit 1
    }
} catch {
    Write-Host "❌ EXCEPCIÓN DURANTE EJECUCIÓN: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🎯 PRÓXIMOS PASOS:" -ForegroundColor Cyan
Write-Host "   1. Desarrollar APIs de gestión de archivos" -ForegroundColor Gray
Write-Host "   2. Implementar frontend de carga de documentos" -ForegroundColor Gray
Write-Host "   3. Configurar almacenamiento externo (S3/Cloudinary)" -ForegroundColor Gray
Write-Host ""