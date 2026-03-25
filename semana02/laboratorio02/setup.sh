cat: 3: No such file or directory
master@master:~$ cat 3.sh
# 1. Limpieza inicial
rm -rf laboratorio02

# 2. Estructura de directorios
mkdir -p laboratorio02/{etc/{apache2,mysql,bind,cron.d},var/{log,lib/{mysql,dhcp},backups/mysql,www/html}}

# --- PREPARACIÓN PARA CADA COMANDO ---

# Para 1: ls -l (apache2)
touch laboratorio02/etc/apache2/apache2.conf

# Para 2 y 9: ls -lh y ls -li (mysql)
dd if=/dev/zero of=laboratorio02/var/lib/mysql/ibdata1 bs=1M count=12 2>/dev/null
# Creamos un HARD LINK (mismo inodo) para probar el comando 9
ln laboratorio02/var/lib/mysql/ibdata1 laboratorio02/var/lib/mysql/ibdata1_hardlink

# Para 3: ls -lt (etc - Fechas manipuladas)
touch -d "2020-01-01" laboratorio02/etc/hosts
touch -d "2023-06-15" laboratorio02/etc/resolv.conf
touch -d "now" laboratorio02/etc/fstab

# Para 4 y 5: ls -ltr y ls -lSh (var/log - Tamaños y fechas)
dd if=/dev/zero of=laboratorio02/var/log/syslog bs=1M count=50 2>/dev/null
touch -d "2021-01-01" laboratorio02/var/log/syslog
dd if=/dev/zero of=laboratorio02/var/log/auth.log bs=1M count=15 2>/dev/null
touch -d "2023-08-01" laboratorio02/var/log/auth.log
echo "error fatal" > laboratorio02/var/log/kern.log
touch -d "now" laboratorio02/var/log/kern.log

# Para 6: ls -F (var - Tipos de archivos)
ln -s /tmp laboratorio02/var/enlace_simbolico
touch laboratorio02/var/script_ejecutable.sh
chmod +x laboratorio02/var/script_ejecutable.sh

# Para 7: ls -R (var/lib)
touch laboratorio02/var/lib/dhcp/dhcpd.leases

# Para 8: ls -la (var/www/html - Archivos ocultos)
echo "PASS=123" > laboratorio02/var/www/html/.env
echo "deny from all" > laboratorio02/var/www/html/.htaccess
touch laboratorio02/var/www/html/index.php

# Para 10: ls -1 (cron.d)
touch laboratorio02/etc/cron.d/db_backup
touch laboratorio02/etc/cron.d/log_backup
touch laboratorio02/etc/cron.d/sys_check

#cp
# --- ARCHIVOS PARA LA GUÍA DE 'CP' (Los que faltaban) ---
touch laboratorio02/etc/bind/named.conf.local
touch laboratorio02/etc/mysql/my.cnf.production
touch laboratorio02/etc/bind/zones/db.empresa.com
touch laboratorio02/etc/exim4/exim4.conf
touch laboratorio02/etc/dhcp/dhcpd.conf

# Permisos especiales para probar 'cp -p'
chmod 600 laboratorio02/etc/mysql/my.cnf.production

echo "¡Laboratorio02 corregido y completo! Todos los archivos fuente existen."

# Creamos una carpeta de backups centralizada
mkdir -p laboratorio02/var/backups/configs

# Creamos un archivo de configuración crítico con permisos específicos
touch laboratorio02/etc/mysql/my.cnf.production
chmod 600 laboratorio02/etc/mysql/my.cnf.production # Solo root lee/escribe

# Creamos una carpeta con varios archivos para probar copias recursivas
mkdir -p laboratorio02/etc/bind/zones
touch laboratorio02/etc/bind/zones/{db.empresa.com,db.10.0.0}

# Aseguramos que el archivo exista
mkdir -p laboratorio02/etc/exim4
touch laboratorio02/etc/exim4/exim4.conf


#find
# 1. Aseguramos archivos con diferentes TAMAÑOS
dd if=/dev/zero of=laboratorio02/var/log/apache2/huge_access.log bs=1M count=10 2>/dev/null
dd if=/dev/zero of=laboratorio02/var/log/mysql/small_error.log bs=1k count=10 2>/dev/null

# 2. Aseguramos archivos con diferentes FECHAS
touch -d "2022-01-01" laboratorio02/etc/apache2/old_config.conf
touch -d "30 days ago" laboratorio02/var/log/exim4/mainlog.1

# 3. Aseguramos archivos con PERMISOS específicos (Seguridad)
chmod 777 laboratorio02/var/www/html/index.php  # ¡Peligro!
chmod 600 laboratorio02/etc/mysql/my.cnf

# 4. Un enlace roto (clásico de SysAdmin)
ln -s /ruta/que/no/existe laboratorio02/etc/enlace_roto

# 2. Creación recursiva de TODAS las carpetas necesarias
mkdir -p laboratorio02/etc/{apache2,mysql,bind/zones,cron.d,exim4,dhcp}
mkdir -p laboratorio02/var/{log/{apache2,mysql,exim4,bind,dhcp},lib/{mysql/empresa_db,dhcp},backups/configs,www/html}

# 3. Creación de archivos con nombres y extensiones para Nivel 1 (Nombres)
touch laboratorio02/etc/apache2/apache2.conf
touch laboratorio02/etc/bind/named.conf.local
touch laboratorio02/etc/bind/zones/db.empresa.com
touch laboratorio02/etc/exim4/exim4.conf
touch laboratorio02/etc/dhcp/dhcpd.conf
touch laboratorio02/var/www/html/index.php

# 4. Archivos con fechas manipuladas para Nivel 2 (Tiempo)
touch -d "2022-01-01" laboratorio02/etc/apache2/old_config.conf
touch -d "30 days ago" laboratorio02/var/log/exim4/mainlog.1
touch -d "100 days ago" laboratorio02/var/log/apache2/access.log.old

# 5. Archivos con tamaños para Nivel 3 (Tamaño)
dd if=/dev/zero of=laboratorio02/var/log/apache2/huge_access.log bs=1M count=10 2>/dev/null
dd if=/dev/zero of=laboratorio02/var/lib/mysql/ibdata1 bs=1M count=12 2>/dev/null

# 6. Permisos y Enlaces para Nivel 4 (Seguridad y Tipos)
chmod 777 laboratorio02/var/www/html/index.php  # Archivo peligroso
chmod 600 laboratorio02/etc/mysql/my.cnf.production 2>/dev/null || touch laboratorio02/etc/mysql/my.cnf.production && chmod 600 laboratorio02/etc/mysql/my.cnf.production
ln -s /ruta/inexistente laboratorio02/etc/enlace_roto


#mkdir
mkdir   laboratorio02/home
mkdir   laboratorio02/home/admin

echo "¡Laboratorio02 RECONSTRUIDO sin errores! Listo para FIND."
echo "Entorno para CP listo."
