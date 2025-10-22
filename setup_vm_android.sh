#!/bin/bash
# ==========================================================
# Script: setup_vm_android.sh
# Autor: Bernardo
# Descripción: Configura VM Android con RHEL 10 en Railway.app
# ==========================================================

set -e

# 1️⃣ Variables
ISO_URL="https://drive.google.com/uc?export=download&id=1VDdg3DC1Mlb--TNv2Ml9drem-SkYB5VV"
ISO_DIR="./iso"
ISO_PATH="$ISO_DIR/rhel-10.0-x86_64-boot.iso"
DISK_PATH="./android_disk.qcow2"
NOVNC_PORT=6080

# 2️⃣ Crear directorio de ISO si no existe
mkdir -p "$ISO_DIR"

# 3️⃣ Descargar ISO si no existe
if [ ! -f "$ISO_PATH" ]; then
    echo "✅ Descargando ISO..."
    curl -L -o "$ISO_PATH" "$ISO_URL"
else
    echo "✅ ISO ya descargada."
fi

# 4️⃣ Crear disco virtual si no existe
if [ ! -f "$DISK_PATH" ]; then
    echo "✅ Creando disco virtual..."
    qemu-img create -f qcow2 "$DISK_PATH" 10G
fi

# 5️⃣ Iniciar VM Android con QEMU
echo "✅ Iniciando VM Android..."
nohup qemu-system-x86_64 \
    -m 2048 \
    -hda "$DISK_PATH" \
    -cdrom "$ISO_PATH" \
    -boot d \
    -vnc :0 \
    -net nic -net user \
    -display none &

# 6️⃣ Iniciar noVNC
echo "✅ Iniciando interfaz web (noVNC)..."
nohup websockify -D "$NOVNC_PORT" localhost:5900 &

# 7️⃣ Crear Caddyfile si no existe
CADDYFILE_PATH="/etc/caddy/Caddyfile"
if [ ! -f "$CADDYFILE_PATH" ]; then
    echo "✅ Creando Caddyfile..."
    sudo mkdir -p /etc/caddy
    echo ":$NOVNC_PORT {
        reverse_proxy localhost:$NOVNC_PORT
    }" | sudo tee "$CADDYFILE_PATH"
fi

# 8️⃣ Iniciar Caddy HTTPS
echo "✅ Iniciando Caddy HTTPS..."
nohup sudo caddy run --config "$CADDYFILE_PATH" &

echo "🌐 Acceso disponible en: https://TU_DOMINIO_RAILWAY_URL"
