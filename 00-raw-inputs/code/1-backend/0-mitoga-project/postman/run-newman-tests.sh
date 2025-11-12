#!/bin/bash
# Script para ejecutar tests de API con Newman
# Uso: ./run-newman-tests.sh [environment]
# Ejemplo: ./run-newman-tests.sh local

set -e  # Salir si hay algún error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Directorio de la colección
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COLLECTION="$SCRIPT_DIR/Mitoga-API.postman_collection.json"

# Ambiente por defecto
ENVIRONMENT="${1:-local}"

# Mapear ambiente a archivo de entorno
case "$ENVIRONMENT" in
  local|dev|development)
    ENV_FILE="$SCRIPT_DIR/Mitoga-Local.postman_environment.json"
    ;;
  qa|test|testing)
    ENV_FILE="$SCRIPT_DIR/Mitoga-QA.postman_environment.json"
    ;;
  prod|production)
    ENV_FILE="$SCRIPT_DIR/Mitoga-Production.postman_environment.json"
    echo -e "${RED}⚠️  ADVERTENCIA: Ejecutando tests en PRODUCCIÓN${NC}"
    read -p "¿Estás seguro? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
      echo -e "${YELLOW}Tests cancelados${NC}"
      exit 0
    fi
    ;;
  *)
    echo -e "${RED}❌ Ambiente inválido: $ENVIRONMENT${NC}"
    echo "Ambientes válidos: local, qa, production"
    exit 1
    ;;
esac

# Verificar que Newman esté instalado
if ! command -v newman &> /dev/null; then
    echo -e "${RED}❌ Newman no está instalado${NC}"
    echo "Instalar con: npm install -g newman"
    exit 1
fi

# Verificar que los archivos existan
if [ ! -f "$COLLECTION" ]; then
    echo -e "${RED}❌ Colección no encontrada: $COLLECTION${NC}"
    exit 1
fi

if [ ! -f "$ENV_FILE" ]; then
    echo -e "${RED}❌ Archivo de entorno no encontrado: $ENV_FILE${NC}"
    exit 1
fi

# Crear directorio para reportes
REPORTS_DIR="$SCRIPT_DIR/newman-reports"
mkdir -p "$REPORTS_DIR"

# Timestamp para el reporte
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
REPORT_PREFIX="$REPORTS_DIR/newman-report-$ENVIRONMENT-$TIMESTAMP"

echo -e "${GREEN}🚀 Ejecutando tests de API${NC}"
echo "   Colección: Mitoga-API.postman_collection.json"
echo "   Ambiente: $ENVIRONMENT"
echo "   Fecha: $(date)"
echo ""

# Ejecutar Newman con reportes HTML, JSON y JUnit
newman run "$COLLECTION" \
  -e "$ENV_FILE" \
  --reporters cli,html,json,junit \
  --reporter-html-export "${REPORT_PREFIX}.html" \
  --reporter-json-export "${REPORT_PREFIX}.json" \
  --reporter-junit-export "${REPORT_PREFIX}.xml" \
  --timeout-request 10000 \
  --timeout-script 5000 \
  --color on \
  --bail

EXIT_CODE=$?

echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}✅ Tests completados exitosamente${NC}"
    echo ""
    echo "📊 Reportes generados:"
    echo "   HTML: ${REPORT_PREFIX}.html"
    echo "   JSON: ${REPORT_PREFIX}.json"
    echo "   JUnit: ${REPORT_PREFIX}.xml"
else
    echo -e "${RED}❌ Tests fallaron con código: $EXIT_CODE${NC}"
    echo ""
    echo "📊 Revisar reporte de errores:"
    echo "   HTML: ${REPORT_PREFIX}.html"
fi

# Abrir reporte HTML en navegador (opcional)
if [ $EXIT_CODE -eq 0 ] && command -v xdg-open &> /dev/null; then
    echo ""
    read -p "¿Abrir reporte HTML? (y/n): " open_report
    if [ "$open_report" = "y" ]; then
        xdg-open "${REPORT_PREFIX}.html"
    fi
fi

exit $EXIT_CODE
