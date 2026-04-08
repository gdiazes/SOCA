#!/bin/bash
# 1. Instalar dependencias
apt update && apt install -y gcc shc cron wget

# 2. Descargar los códigos fuente desde GitHub
URL="https://raw.githubusercontent.com/gdiazes/SOCA/refs/heads/main/semana04/laboratorio04/"
wget -q $URL/prep-reto  --no-check-certificate -O  /usr/local/bin/prep-reto
wget -q $URL/check-retos  --no-check-certificate -O /usr/local/bin/check-retos

# 4. Dar permisos SUID
chmod 4755 /usr/local/bin/prep-reto
chmod 4755 /usr/local/bin/check-retos


echo "✅ Instalación completada. Ejecuta 'prep-reto' para empezar."
