#!/bin/bash
# URL de tu repositorio (ajustada para descargar binarios)
GITHUB_URL="https://raw.githubusercontent.com/gdiazes/SOCA/refs/heads/main/semana04/laboratorio04"

echo "--- 1. Limpiando instalaciones previas ---"
rm -f /usr/local/bin/prep-reto /usr/local/bin/check-retos

echo "--- 2. Descargando Binarios desde GitHub ---"
# Usamos -L para seguir redirecciones de GitHub
wget https://raw.githubusercontent.com/gdiazes/SOCA/refs/heads/main/semana04/laboratorio04/prep-reto --no-check-certificate -O /usr/local/bin/prep-reto
wget https://raw.githubusercontent.com/gdiazes/SOCA/refs/heads/main/semana04/laboratorio04/check-retos --no-check-certificate -O /usr/local/bin/check-retos

echo "--- 3. Verificando integridad de descarga ---"
SIZE_PREP=$(stat -c%s "/usr/local/bin/prep-reto")
SIZE_CHECK=$(stat -c%s "/usr/local/bin/check-retos")

if [ "$SIZE_PREP" -lt 1000 ] || [ "$SIZE_CHECK" -lt 1000 ]; then
    echo "❌ ERROR: Los archivos descargados están vacíos o corruptos."
    echo "Verifica que las rutas en GitHub sean públicas y correctas."
    exit 1
fi

echo "--- 4. Configurando Permisos Especiales (SUID) ---"
chown root:root /usr/local/bin/prep-reto /usr/local/bin/check-retos
chmod 4755 /usr/local/bin/prep-reto
chmod 4755 /usr/local/bin/check-retos

echo "--- 5. Configurando el CAOS (Reinicio 5 min) ---"
echo "@reboot root sleep 300 && /sbin/reboot" > /etc/cron.d/caos_reboot
systemctl restart cron 2>/dev/null

echo "--- 6. Ejecutando Preparador ---"
/usr/local/bin/prep-reto

echo "===================================================="
echo "✅ INSTALACIÓN COMPLETADA EXITOSAMENTE"
echo "El sistema se reiniciará en 5 minutos."
echo "Sal de root y entra como: estudiante / Tecsup00"
echo "===================================================="
