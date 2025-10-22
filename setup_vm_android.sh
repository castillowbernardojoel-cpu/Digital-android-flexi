#!/bin/bash
# ==========================================================
# Script: setup_vm_android.sh
# Autor: Bernardo (castillowbernardojoel-cpu)
# Descripción: Configura VM Android con RHEL 10 en Railway.app
# ==========================================================

set -e

# 1️⃣ Variables principales
ISO_URL="https://drive.google.com/uc?export=download&id=1VDdg3DC1Mlb--TNv2Ml9drem-SkYB5VV"
ISO_DIR="/app/iso"
ISO_PATH="$ISO_DIR/rhel-10.0-x86_64-boot.iso"
DISK_PATH="/app/android_disk.qcow2"
NOVNC_DIR="/app/novnc"
NOVNC_PORT=6080

echo "🧠 Iniciando configuración de VM Android..."

# 2️⃣ Crear directorios requeridos
mkdir -p "$ISO_DIR" "$NOVNC_DIR"

# 3️⃣ Descargar ISO desde Google Drive si no existe
if [ ! -f "$ISO_PATH" ]; then
    echo "📦 Descargando ISO desde Google Drive..."
    curl -L -o "$ISO_PATH" "$ISO_URL"
else
    echo "✅ ISO ya existente."
fi

# 4️⃣ Crear disco virtual si no existe
if [ ! -f "$DISK_PATH" ]; then
    echo "🧱 Creando disco virtual Android..."
    qemu-img create -f qcow2 "$DISK_PATH" 10G
fi

# 5️⃣ Clonar noVNC si no está descargado
if [ ! -f "$NOVNC_DIR/index.html" ]; then
    echo "🌐 Descargando noVNC..."
    git clone https://github.com/novnc/noVNC.git "$NOVNC_DIR"
fi

# 6️⃣ Iniciar la VM Android con QEMU
echo "🚀 Iniciando máquina virtual Android..."
nohup qemu-system-x86_64 \
  -m 2048 \
  -boot d \
  -cdrom "$ISO_PATH" \
  -hda "$DISK_PATH" \
  -enable-kvm \
  -smp 2 \
  -vnc :0 \
  -net nic -net user \
  > /app/qemu.log 2>&1 &

sleep 5

# 7️⃣ Crear el archivo Caddyfile dinámicamente
CADDYFILE_PATH="/app/Caddyfile"
echo "🧩 Creando Caddyfile..."
cat <<EOF > "$CADDYFILE_PATH"
:6080 {
    root * /app/novnc
    file_server
    reverse_proxy /vnc/* 127.0.0.1:5900
    reverse_proxy /websockify 127.0.0.1:6080
    encode gzip
    log {
        output stdout
        format console
    }
}
EOF

# 8️⃣ Iniciar Caddy HTTPS y noVNC
echo "🌍 Iniciando servidor web (noVNC + Caddy)..."
nohup caddy run --config "$CADDYFILE_PATH" --adapter caddyfile > /app/caddy.log 2>&1 &

# 9️⃣ Mostrar dominio HTTPS público
echo "✅ Acceso disponible en: https://$RAILWAY_STATIC_URL"
echo "Si la variable no aparece, consulta tu dominio en Railway.app > Networking > Public Domain"
