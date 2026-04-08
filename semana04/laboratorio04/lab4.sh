#!/bin/bash
# =============================================================
# INSTALADOR OFICIAL: RETO ADMINISTRACIÓN LINUX
# =============================================================

# CONFIGURACIÓN (Cambia esto por tu URL de GitHub)
GITHUB_REPO="https://raw.githubusercontent.com/gdiazes/SOCA/refs/heads/main/semana04/laboratorio04/"

if [[ $EUID -ne 0 ]]; then echo "❌ Ejecuta este script como ROOT."; exit 1; fi

echo "--- 1. Descargando Binarios Ofuscados ---"
wget -q $GITHUB_REPO/prep-reto -O /usr/local/bin/prep-reto
wget -q $GITHUB_REPO/check-retos -O /usr/local/bin/check-retos

# Dar permisos de ejecución y SUID
chmod 4755 /usr/local/bin/prep-reto
chmod 4755 /usr/local/bin/check-retos

echo "--- 2. Configurando el CAOS (5 min Reboot) ---"
# Esto crea una tarea de cron que se dispara en cada inicio de la máquina
# y programa un reinicio exactamente 5 minutos después.
echo "@reboot root sleep 300 && /sbin/reboot" > /etc/cron.d/caos_reboot
systemctl restart cron

echo "--- 3. Ejecutando Preparador de Entorno ---"
# Ejecutamos el preparador que descargamos
/usr/local/bin/prep-reto

echo "--- 4. Activando Temporizador de Muerte (20 min) ---"
# Después de 20 minutos, el comando de validación se auto-elimina
echo "rm -f /usr/local/bin/check-retos" | at now + 20 minutes 2>/dev/null || (sleep 1200 && rm -f /usr/local/bin/check-retos) &

echo "==============================================================="
echo "¡INSTALACIÓN EXITOSA!"
echo "Instrucciones para el alumno:"
echo "1. Salir de root (escribir 'exit')."
echo "2. Iniciar sesión como: estudiante (Clave: Tecsup00)."
echo "3. El servidor SE REINICIARÁ cada 5 minutos automáticamente."
echo "4. Tienes 20 minutos totales antes de que el validador muera."
echo "==============================================================="
