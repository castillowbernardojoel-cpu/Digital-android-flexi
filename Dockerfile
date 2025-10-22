FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    qemu qemu-kvm qemu-utils \
    novnc websockify curl sudo \
    debian-keyring debian-archive-keyring apt-transport-https \
    && apt-get clean

# Instalar Caddy
RUN curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | apt-key add - \
    && echo "deb [trusted=yes] https://dl.cloudsmith.io/public/caddy/stable/deb/debian any-version main" | tee /etc/apt/sources.list.d/caddy.list \
    && apt-get update \
    && apt-get install -y caddy

# Crear directorios de trabajo
RUN mkdir -p /workspace/iso
WORKDIR /workspace

# Copiar archivos del proyecto
COPY setup_vm_android.sh .
COPY Caddyfile /etc/caddy/Caddyfile

# Dar permisos de ejecución
RUN chmod +x setup_vm_android.sh

# Exponer puerto de noVNC
EXPOSE 6080

# Comando por defecto
CMD ["bash", "setup_vm_android.sh"]
