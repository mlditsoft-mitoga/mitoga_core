#!/bin/bash

# ZNS-METHOD K3s Deployment Assessment Script
# Para ejecutar en el servidor 192.168.18.126

echo "🤖 ZNS-METHOD K3s Assessment"
echo "=============================="
echo ""

# Información básica del sistema
echo "📊 INFORMACIÓN DEL SISTEMA:"
echo "----------------------------"
echo "Hostname: $(hostname)"
echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime)"
echo ""

# Hardware
echo "🖥️ HARDWARE:"
echo "-------------"
echo "CPU: $(nproc) cores"
echo "RAM: $(free -h | awk '/^Mem:/ {print $2}')"
echo "Disk: $(df -h / | awk 'NR==2 {print $2" total, "$4" available"}')"
echo ""

# GPU (si existe)
echo "🎮 GPU:"
echo "-------"
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi --query-gpu=name,memory.total,memory.free --format=csv,noheader,nounits
    echo "NVIDIA Runtime: $(docker run --rm --gpus all nvidia/cuda:11.8-base-ubuntu22.04 nvidia-smi --query-gpu=driver_version --format=csv,noheader 2>/dev/null || echo 'No disponible')"
else
    echo "No NVIDIA GPU detectada"
fi
echo ""

# K3s Status
echo "☸️ KUBERNETES (K3s):"
echo "--------------------"
echo "K3s Version: $(k3s --version | head -1)"
echo "Status: $(systemctl is-active k3s || echo 'No activo')"
echo ""

# Nodes
echo "📦 NODOS:"
kubectl get nodes -o wide 2>/dev/null || echo "❌ kubectl no disponible"
echo ""

# Namespaces
echo "📁 NAMESPACES:"
kubectl get namespaces 2>/dev/null || echo "❌ kubectl no disponible"
echo ""

# Storage Classes
echo "💾 STORAGE:"
kubectl get storageclass 2>/dev/null || echo "❌ kubectl no disponible"
echo ""

# Resources disponibles
echo "🎯 RECURSOS DISPONIBLES:"
echo "------------------------"
kubectl top nodes 2>/dev/null || echo "❌ metrics-server no disponible"
echo ""

# Network
echo "🌐 NETWORKING:"
echo "--------------"
echo "IP Address: $(hostname -I | awk '{print $1}')"
echo "Network interfaces:"
ip addr show | grep -E "^[0-9]+:" | awk '{print $2}'
echo ""

# Docker info
echo "🐳 DOCKER:"
echo "----------"
if command -v docker &> /dev/null; then
    echo "Docker Version: $(docker --version)"
    echo "Status: $(systemctl is-active docker || echo 'No activo')"
    echo "Images: $(docker images --format 'table {{.Repository}}\t{{.Tag}}\t{{.Size}}' | wc -l) total"
else
    echo "Docker no instalado"
fi
echo ""

# Puertos en uso
echo "🔌 PUERTOS EN USO:"
echo "------------------"
netstat -tlpn | grep LISTEN | head -20
echo ""

echo "✅ Assessment completado"
echo ""
echo "📋 PRÓXIMOS PASOS:"
echo "1. Revisar recursos disponibles"
echo "2. Configurar namespace para ZNS-METHOD"
echo "3. Preparar almacenamiento persistente"
echo "4. Desplegar ZNS-METHOD en K3s"