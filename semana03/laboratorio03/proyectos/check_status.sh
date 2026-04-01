#!/bin/bash
# Script de monitoreo de servicios
SERVICE="ssh"
if systemctl is-active --quiet ; then
    echo " está corriendo"
else
    echo "Error:  está caído"
fi
