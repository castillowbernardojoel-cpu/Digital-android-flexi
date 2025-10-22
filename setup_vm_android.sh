#!/bin/bash
# ==========================================================
# Script: setup_vm_android.sh
# Autor: Bernardo
# Descripción: Configura VM Android con RHEL 10 en Railway.app
# ==========================================================

set -e

# 1️⃣ Variables
ISO_URL="https://drive.google.com/uc?export=download&id=1VDdg3DC1Mlb--TNv2Ml9drem-SkYB5VV"
ISO_PATH="./iso/rhel-10.0-x86_64-boot.iso"
DISK_PATH="./android_disk.qcow2"

mkdir -p ./iso

# 2️⃣ Descargar ISO si no existe
if [ ! -f "$ISO_PATH" ]; then
    echo "✅ Descargando ISO..."
    curl -L -o "$ISO_PATH" "$ISO_URL"
else
    echo "✅ ISO ya descargada."
fi

# 3️⃣ Crear disco virtual si no existe
if [ ! -f "$DISK_PATH" ]; then
    echo "✅ Creando disco virtual..."
    qemu-img create -f qcow2 "$DISK_PATH" 10G
fi

# 4️⃣ Iniciar VM Android con noVNC
echo "✅ Iniciando VM Android..."
nohup qemu-system-x86_64 \
    -m 2048 \
    -hda "$DISK_PATH" \
    -cdrom "$ISO_PATH" \
    -boot d \
    -vnc :0 \
    -net nic -net user \
    -display none &

# 5️⃣ Iniciar noVNC
echo "✅ Iniciando interfaz web (noVNC)..."
mkdir -p /tmp/novnc
nohup websockify -D 6080 localhost:5900 &

# 6️⃣ Iniciar Caddy (HTTPS)
echo "✅ Iniciando Caddy HTTPS..."
nohup caddy run --config /etc/caddy/Caddyfile &

echo "🌐 Acceso disponible en: https://TU_DOMINIO_RAILWAY_URL"
