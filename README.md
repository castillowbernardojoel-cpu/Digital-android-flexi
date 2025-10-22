# 🌐 Digital Android Flexi

**Autor:** Bernardo Joel Castillo Wilson  
**Proyecto:** Máquina Virtual Android basada en RHEL 10, desplegable en Railway.app  
**Versión:** 1.0  
**Fecha:** Octubre 2025  

---

## 🧠 Descripción General

**Digital Android Flexi** es un entorno virtual basado en Linux (RHEL 10) que ejecuta Android en la nube.  
El sistema se despliega automáticamente en **Railway.app**, permitiendo el acceso remoto vía navegador web con **Caddy (HTTPS)** y **noVNC** — sin necesidad de instalar aplicaciones o configuraciones locales.

Este proyecto ofrece una solución ligera y flexible para desarrolladores, testers o usuarios que deseen ejecutar un sistema Android virtual directamente desde un navegador web, incluyendo dispositivos móviles como el **Samsung A25**.

---

## ⚙️ Componentes Principales

| Componente | Descripción |
|-------------|-------------|
| **QEMU/KVM** | Virtualiza la máquina Android en base a una imagen ISO. |
| **Caddy** | Servidor web que habilita HTTPS automáticamente. |
| **noVNC + Websockify** | Permiten acceso gráfico remoto vía navegador web. |
| **Railway.app** | Plataforma de despliegue gratuita y en la nube. |

---

## 🧩 Estructura del Repositorio
