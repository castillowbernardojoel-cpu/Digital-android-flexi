# Imagen base
FROM ubuntu:22.04

# Evitar prompts interactivos
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar e instalar dependencias
RUN apt-get update && apt-get install -y \
    qemu-system-x86 \
    qemu-utils \
    caddy \
    novnc \
    websockify \
    curl \
    git \
    && apt-get clean

# Crear directorio de trabajo
WORKDIR /app

# Copiar archivos del proyecto
COPY setup_vm_android.sh /app/setup_vm_android.sh
COPY Caddyfile /etc/caddy/Caddyfile

# Dar permisos de ejecución
RUN chmod +x /app/setup_vm_android.sh

# Puerto HTTPS de Render
EXPOSE 10000

# Comando principal
CMD ["/app/setup_vm_android.sh"]
