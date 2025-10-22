#!/bin/bash
# ==========================================================
# Script: setup_vm_android.sh
# Autor: Bernardo
# Descripción: Configura VM Android con RHEL 10 en Render.com
# ==========================================================

set -e

ISO_URL="https://drive.google.com/uc?export=download&id=1VDdg3DC1Mlb--TNv2Ml9drem-SkYB5VV"
ISO_DIR="./iso"
ISO_PATH="$ISO_DIR/rhel-10.0-x86_64-boot.iso"
DISK_PATH="./android_disk.qcow2"
NOVNC_PORT=10000

mkdir -p "$ISO_DIR"

if [ ! -f "$ISO_PATH" ]; then
    echo "📥 Descargando ISO..."
    curl -L -o "$ISO_PATH" "$ISO_URL"
else
    echo "✅ ISO ya está descargada."
fi

if [ ! -f "$DISK_PATH" ]; then
    echo "🧱 Creando disco virtual..."
    qemu-img create -f qcow2 "$DISK_PATH" 10G
fi

echo "🚀 Iniciando VM Android..."
nohup qemu-system-x86_64 \
    -m 2048 \
    -hda "$DISK_PATH" \
    -cdrom "$ISO_PATH" \
    -boot d \
    -vnc :0 \
    -net nic -net user \
    -display none &

echo "🌐 Iniciando noVNC..."
nohup websockify -D $NOVNC_PORT localhost:5900 &

echo "⚙️ Iniciando Caddy HTTPS..."
nohup caddy run --config /etc/caddy/Caddyfile &
sleep 3

echo "✅ Tu Android VM está en marcha"
echo "🌍 Accede desde tu navegador con la URL HTTPS de Render"
