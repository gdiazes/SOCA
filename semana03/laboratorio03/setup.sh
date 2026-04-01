```bash
# Preparación del laboratorio 03
mkdir -p /home/alumno/laboratorio03/etc/ssh
cp /etc/hosts /home/alumno/laboratorio03/etc/hosts
cp /etc/fstab /home/alumno/laboratorio03/etc/fstab
cp /etc/ssh/sshd_config /home/alumno/laboratorio03/etc/ssh/sshd_config

mkdir -p /home/alumno/laboratorio03/var/log
mkdir -p /home/alumno/laboratorio03/etc/network
cp /etc/services /home/alumno/laboratorio03/etc/services
cp /etc/passwd /home/alumno/laboratorio03/etc/passwd
cp /etc/group /home/alumno/laboratorio03/etc/group
# Simulamos un log para prácticas de búsqueda
journalctl -n 100 > /home/alumno/laboratorio03/var/log/syslog_sim

# Preparación del Bloque Final de Laboratorio
touch /home/alumno/laboratorio03/.vimrc
mkdir -p /home/alumno/laboratorio03/proyectos
cat <<EOF > /home/alumno/laboratorio03/proyectos/check_status.sh
#!/bin/bash
# Script de monitoreo de servicios
SERVICE="ssh"
if systemctl is-active --quiet \$SERVICE; then
    echo "\$SERVICE está corriendo"
else
    echo "Error: \$SERVICE está caído"
fi
EOF
chmod +x /home/alumno/laboratorio03/proyectos/check_status.sh
```
