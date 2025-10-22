# ==========================================================
# Dockerfile para Android VM en Render
# ==========================================================

FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# 1️⃣ Actualizar e instalar dependencias básicas
RUN apt-get update && apt-get install -y \
    qemu-system-x86 \
    qemu-utils \
    curl \
    git \
    python3-pip \
    debian-keyring \
    debian-archive-keyring \
    apt-transport-https \
    && apt-get clean

# 2️⃣ Instalar websockify vía pip
RUN pip3 install websockify

# 3️⃣ Instalar noVNC desde GitHub
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC

# 4️⃣ Instalar Caddy usando repositorio oficial
RUN curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | apt-key add - && \
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list && \
    apt-get update && apt-get install -y caddy

# 5️⃣ Crear directorio de trabajo y copiar archivos del proyecto
WORKDIR /app
COPY setup_vm_android.sh /app/setup_vm_android.sh
COPY Caddyfile /etc/caddy/Caddyfile

# 6️⃣ Dar permisos de ejecución al script
RUN chmod +x /app/setup_vm_android.sh

# 7️⃣ Puerto HTTPS de Render
EXPOSE 10000

# 8️⃣ Comando principal
CMD ["/app/setup_vm_android.sh"]
