#!/bin/bash
set -euo pipefail

# ZNS-METHOD Deployment Script
# Versión: 2.0
# Autor: Senior Infrastructure Engineer

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables de configuración
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
PROJECT_ROOT="/opt/zns-method"
DEPLOYMENT_DIR="$PROJECT_ROOT/deployment"
ENV_FILE="$DEPLOYMENT_DIR/.env"
COMPOSE_FILE="$DEPLOYMENT_DIR/docker-compose-zns.yml"
LOG_FILE="/var/log/zns-deployment.log"

# Funciones de logging
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1" | tee -a "$LOG_FILE"
}

# Función de verificación de prerrequisitos
check_prerequisites() {
    log_step "Verificando prerrequisitos del sistema..."
    
    # Verificar que el script se ejecute como root
    if [[ $EUID -eq 0 ]]; then
        log_error "Este script no debe ejecutarse como root"
        exit 1
    fi
    
    # Verificar Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker no está instalado"
        exit 1
    fi
    
    # Verificar Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose no está instalado"
        exit 1
    fi
    
    # Verificar NVIDIA Docker (para GPU)
    if ! docker run --rm --gpus all nvidia/cuda:11.8-base-ubuntu22.04 nvidia-smi &> /dev/null; then
        log_warn "NVIDIA Docker runtime no disponible - continuando sin soporte GPU"
    else
        log_info "✅ NVIDIA Docker runtime detectado"
    fi
    
    # Verificar permisos Docker
    if ! docker ps &> /dev/null; then
        log_error "Usuario actual no tiene permisos para Docker"
        exit 1
    fi
    
    # Verificar espacio en disco
    AVAILABLE_SPACE=$(df / | awk 'NR==2 {print $4}')
    REQUIRED_SPACE=20971520 # 20GB en KB
    
    if [[ $AVAILABLE_SPACE -lt $REQUIRED_SPACE ]]; then
        log_error "Espacio insuficiente en disco. Requerido: 20GB, Disponible: $(($AVAILABLE_SPACE/1024/1024))GB"
        exit 1
    fi
    
    # Verificar memoria RAM
    TOTAL_RAM=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
    REQUIRED_RAM=16777216 # 16GB en KB
    
    if [[ $TOTAL_RAM -lt $REQUIRED_RAM ]]; then
        log_warn "RAM disponible menor a 16GB. Rendimiento puede verse afectado."
    fi
    
    log_info "✅ Prerrequisitos verificados"
}

# Función para crear estructura de directorios
setup_directories() {
    log_step "Configurando estructura de directorios..."
    
    # Crear directorio principal
    sudo mkdir -p "$PROJECT_ROOT"
    sudo chown -R $USER:docker "$PROJECT_ROOT"
    
    # Crear subdirectorios
    mkdir -p "$PROJECT_ROOT"/{deployment,models,configs,logs,data,scripts,monitoring,backups,ssl}
    
    # Crear logs específicos
    mkdir -p "$PROJECT_ROOT/logs"/{gateway,nginx,worker,scheduler}
    
    # Permisos
    chmod -R 755 "$PROJECT_ROOT"
    
    log_info "✅ Estructura de directorios creada"
}

# Función para copiar archivos de configuración
copy_configs() {
    log_step "Copiando archivos de configuración..."
    
    # Copiar todo el directorio de deployment
    cp -r "$SCRIPT_DIR"/* "$DEPLOYMENT_DIR/"
    
    # Copiar ZNS-METHOD source
    if [[ -d "$(dirname "$SCRIPT_DIR")/../.." ]]; then
        ln -sf "$(realpath "$(dirname "$SCRIPT_DIR")/../..")" "$PROJECT_ROOT/source"
        log_info "✅ ZNS-METHOD source enlazado"
    else
        log_error "No se encontró el directorio source de ZNS-METHOD"
        exit 1
    fi
    
    log_info "✅ Configuraciones copiadas"
}

# Función para generar archivo de entorno
generate_env_file() {
    log_step "Generando archivo de configuración de entorno..."
    
    # Generar passwords aleatorias
    POSTGRES_PASSWORD=$(openssl rand -hex 16)
    REDIS_PASSWORD=$(openssl rand -hex 16)
    SECRET_KEY=$(openssl rand -hex 32)
    GRAFANA_PASSWORD=$(openssl rand -hex 12)
    
    cat > "$ENV_FILE" << EOF
# ZNS-METHOD Environment Configuration
# Generated: $(date)

# Database
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
DATABASE_URL=postgresql://zns_admin:$POSTGRES_PASSWORD@zns-postgres:5432/zns_method

# Cache
REDIS_PASSWORD=$REDIS_PASSWORD
REDIS_URL=redis://:$REDIS_PASSWORD@zns-redis:6379/0

# API Gateway
SECRET_KEY=$SECRET_KEY
LOG_LEVEL=INFO
MAX_TOKENS=4096
RATE_LIMIT_PER_MINUTE=20

# Text Generation WebUI
TEXTGEN_URL=http://zns-textgen:5000/api/v1

# Monitoring
GRAFANA_PASSWORD=$GRAFANA_PASSWORD

# Network
COMPOSE_PROJECT_NAME=zns-method
DOCKER_BUILDKIT=1
EOF
    
    chmod 600 "$ENV_FILE"
    log_info "✅ Archivo de entorno generado"
    log_info "📝 Credenciales guardadas en: $ENV_FILE"
}

# Función para descargar modelos de IA
download_models() {
    log_step "Descargando modelos de IA..."
    
    MODELS_DIR="$PROJECT_ROOT/models"
    
    # Lista de modelos recomendados para ZNS-METHOD
    declare -A MODELS=(
        ["TheBloke/CodeLlama-7B-Instruct-GGML"]="codellama-7b-instruct.q4_0.bin"
        ["microsoft/DialoGPT-medium"]="pytorch_model.bin"
        ["sentence-transformers/all-MiniLM-L6-v2"]="pytorch_model.bin"
    )
    
    for MODEL_PATH in "${!MODELS[@]}"; do
        MODEL_NAME="${MODELS[$MODEL_PATH]}"
        LOCAL_PATH="$MODELS_DIR/$MODEL_PATH"
        
        if [[ ! -f "$LOCAL_PATH/$MODEL_NAME" ]]; then
            log_info "Descargando $MODEL_PATH..."
            mkdir -p "$LOCAL_PATH"
            
            # Usando huggingface-hub para descargar
            python3 -c "
from huggingface_hub import snapshot_download
try:
    snapshot_download(repo_id='$MODEL_PATH', cache_dir='$MODELS_DIR', resume_download=True)
    print('✅ Modelo $MODEL_PATH descargado')
except Exception as e:
    print(f'⚠️ Error descargando $MODEL_PATH: {e}')
"
        else
            log_info "✅ Modelo $MODEL_PATH ya existe"
        fi
    done
    
    log_info "✅ Modelos verificados"
}

# Función para construir imágenes Docker
build_images() {
    log_step "Construyendo imágenes Docker..."
    
    cd "$DEPLOYMENT_DIR"
    
    # Cargar variables de entorno
    export $(grep -v '^#' "$ENV_FILE" | xargs)
    
    # Construir con BuildKit para mejor rendimiento
    export DOCKER_BUILDKIT=1
    
    # Build gateway
    docker-compose -f "$COMPOSE_FILE" build zns-gateway
    
    log_info "✅ Imágenes construidas"
}

# Función para inicializar servicios
start_services() {
    log_step "Iniciando servicios ZNS-METHOD..."
    
    cd "$DEPLOYMENT_DIR"
    
    # Cargar variables de entorno
    export $(grep -v '^#' "$ENV_FILE" | xargs)
    
    # Iniciar servicios en orden correcto
    log_info "Iniciando base de datos y cache..."
    docker-compose -f "$COMPOSE_FILE" up -d zns-postgres zns-redis
    
    # Esperar que estén listos
    sleep 30
    
    log_info "Iniciando motor de IA..."
    docker-compose -f "$COMPOSE_FILE" up -d zns-textgen
    
    # Esperar que esté listo
    sleep 45
    
    log_info "Iniciando API Gateway..."
    docker-compose -f "$COMPOSE_FILE" up -d zns-gateway zns-worker zns-scheduler
    
    # Esperar que esté listo
    sleep 20
    
    log_info "Iniciando servicios web..."
    docker-compose -f "$COMPOSE_FILE" up -d zns-nginx
    
    log_info "Iniciando monitoreo..."
    docker-compose -f "$COMPOSE_FILE" up -d zns-prometheus zns-grafana
    
    log_info "✅ Todos los servicios iniciados"
}

# Función de verificación de servicios
verify_deployment() {
    log_step "Verificando deployment..."
    
    # Lista de servicios y sus health checks
    declare -A SERVICES=(
        ["zns-postgres"]="5432"
        ["zns-redis"]="6379" 
        ["zns-gateway"]="8080"
        ["zns-nginx"]="80"
        ["zns-prometheus"]="9090"
        ["zns-grafana"]="3000"
    )
    
    ALL_HEALTHY=true
    
    for SERVICE in "${!SERVICES[@]}"; do
        PORT="${SERVICES[$SERVICE]}"
        
        if docker ps --filter "name=$SERVICE" --filter "status=running" | grep -q "$SERVICE"; then
            log_info "✅ $SERVICE: RUNNING"
            
            # Test conectividad
            if nc -z localhost "$PORT" 2>/dev/null; then
                log_info "   ✅ Puerto $PORT: ACCESIBLE"
            else
                log_warn "   ⚠️ Puerto $PORT: NO ACCESIBLE"
                ALL_HEALTHY=false
            fi
        else
            log_error "❌ $SERVICE: NO RUNNING"
            ALL_HEALTHY=false
        fi
    done
    
    # Test API Gateway específico
    if curl -s http://localhost:8080/health | grep -q "healthy"; then
        log_info "✅ API Gateway health check: OK"
    else
        log_error "❌ API Gateway health check: FAILED"
        ALL_HEALTHY=false
    fi
    
    if $ALL_HEALTHY; then
        log_info "🎉 Deployment verificado exitosamente"
        return 0
    else
        log_error "❌ Algunos servicios presentan problemas"
        return 1
    fi
}

# Función para mostrar información post-deployment
show_deployment_info() {
    log_step "Información del deployment..."
    
    echo ""
    echo "🎉 ZNS-METHOD DEPLOYMENT COMPLETADO"
    echo "======================================"
    echo ""
    echo "📊 Servicios disponibles:"
    echo "  • ZNS API Gateway:     http://localhost:8080"
    echo "  • Documentación API:   http://localhost:8080/docs"
    echo "  • Health Check:        http://localhost:8080/health"
    echo "  • Prometheus:          http://localhost:9090"
    echo "  • Grafana:             http://localhost:3000"
    echo ""
    echo "🔐 Credenciales:"
    echo "  • Archivo de configuración: $ENV_FILE"
    echo "  • Grafana: admin / [ver archivo .env]"
    echo ""
    echo "📚 Próximos pasos:"
    echo "  1. Configurar tu frontend Next.js para apuntar a http://localhost:8080"
    echo "  2. Probar los endpoints en http://localhost:8080/docs"
    echo "  3. Configurar dashboards en Grafana"
    echo "  4. Configurar SSL/TLS para producción"
    echo ""
    echo "🛠️ Comandos útiles:"
    echo "  • Ver logs:              docker-compose -f $COMPOSE_FILE logs -f [servicio]"
    echo "  • Reiniciar:            docker-compose -f $COMPOSE_FILE restart [servicio]"
    echo "  • Parar todo:           docker-compose -f $COMPOSE_FILE down"
    echo "  • Actualizar:           docker-compose -f $COMPOSE_FILE pull && docker-compose -f $COMPOSE_FILE up -d"
    echo ""
}

# Función para cleanup en caso de error
cleanup_on_error() {
    log_error "Error detectado. Ejecutando cleanup..."
    
    cd "$DEPLOYMENT_DIR" 2>/dev/null || true
    docker-compose -f "$COMPOSE_FILE" down 2>/dev/null || true
    
    log_error "Deployment falló. Ver logs en $LOG_FILE"
}

# Función principal
main() {
    # Banner
    echo "🤖 ZNS-METHOD Deployment Script v2.0"
    echo "====================================="
    echo ""
    
    # Trap para cleanup
    trap cleanup_on_error ERR
    
    # Crear log file
    sudo touch "$LOG_FILE"
    sudo chown $USER:$USER "$LOG_FILE"
    
    log_info "🚀 Iniciando deployment ZNS-METHOD..."
    
    # Ejecutar pasos
    check_prerequisites
    setup_directories
    copy_configs
    generate_env_file
    download_models
    build_images
    start_services
    
    # Esperar estabilización
    log_step "Esperando estabilización de servicios..."
    sleep 60
    
    # Verificar deployment
    if verify_deployment; then
        show_deployment_info
        log_info "✅ ZNS-METHOD deployment completado exitosamente"
        exit 0
    else
        log_error "❌ ZNS-METHOD deployment falló en verificación"
        exit 1
    fi
}

# Manejo de argumentos
case "${1:-}" in
    "install"|"deploy"|"")
        main
        ;;
    "verify"|"check")
        verify_deployment
        ;;
    "info")
        show_deployment_info
        ;;
    "help"|"-h"|"--help")
        echo "Uso: $0 [comando]"
        echo ""
        echo "Comandos:"
        echo "  install, deploy    Ejecutar deployment completo"
        echo "  verify, check      Verificar servicios"
        echo "  info              Mostrar información del deployment"
        echo "  help              Mostrar esta ayuda"
        ;;
    *)
        log_error "Comando desconocido: $1"
        echo "Usa '$0 help' para ver comandos disponibles"
        exit 1
        ;;
esac