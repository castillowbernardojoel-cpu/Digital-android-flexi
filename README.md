# 🚀 Digital Android Flexi — VM Android en la Nube con Railway.app

**Autor:** Bernardo Joel Castillo (castillowbernardojoel-cpu)  
**Versión:** 1.0  
**Licencia:** MIT  
**Fecha:** Octubre 2025  

---

## 📘 Descripción del Proyecto

**Digital Android Flexi** es un entorno virtual basado en **RHEL 10 + Android ISO**, diseñado para ejecutarse directamente en la nube mediante **Railway.app**.

Permite acceder a una **máquina virtual Android completa**, desde cualquier navegador web (móvil o PC), **sin instalar aplicaciones**, gracias a la integración de:

- **QEMU:** emulación del sistema Android.  
- **noVNC:** acceso gráfico remoto vía navegador.  
- **Caddy:** servidor HTTPS automático con certificados SSL.  
- **Railway.app:** despliegue gratuito con dominio público.

---

## ⚙️ Estructura del Proyecto
Digital-android-flexi/ │ ├── setup_vm_android.sh   # Script principal de configuración y ejecución ├── Dockerfile            # Imagen base para Railway (Ubuntu + QEMU + Caddy) ├── Caddyfile             # Configuración HTTPS y reverse proxy ├── README.md             # Este documento ├── .gitignore            # Archivos a ignorar └── iso/                  # Carpeta donde se descarga la imagen ISO

---

## 🧩 Requisitos Previos

- Cuenta gratuita en [Railway.app](https://railway.app/).  
- Archivo **ISO de Android o RHEL 10** alojado en Google Drive (ya incluido).  
- Navegador web actualizado (Chrome, Firefox, Edge o Android WebView).
