GUÍA DE LABORATORIO DE SISTEMAS OPERATIVOS DE CÓDIGO ABIERTO
RETO TÉCNICO: DESPLIEGUE DE SERVICIOS WEB Y PLAN DE CONTINGENCIA REMOTO

El presente laboratorio es diseñado para la implementación de un entorno de producción web y un sistema de respaldo automatizado. La ejecución es realizada mediante el uso de dos máquinas virtuales con Ubuntu Server operando en un entorno de red privada virtual bajo VMware Workstation.

---

### TOPOLOGÍA VIRTUAL (VMWARE WORKSTATION)

La interconexión es establecida a través de un conmutador virtual configurado en modo NAT (VMnet8). Las direcciones IP presentadas son valores simulados que deben ser sustituidos por el estudiante según el direccionamiento asignado en su entorno real.

```text
      [ ENTORNO VIRTUAL - RED PRIVADA NAT ]
                     |
    +----------------+--------------------------+
    |                                           |
    |  [ NODO 1: PRODUCCIÓN ]                   |  [ NODO 2: ALMACÉN ]
    |  IP: 192.168.10.10 (Simulada)             |  IP: 192.168.10.20 (Simulada)
    |  Hostname: WebProd-Apellido               |  Hostname: BackupSrv-Apellido
    |  Rol: Servidor Apache2                    |  Rol: Depósito de Seguridad
    |                                           |
    +-------[ script: respaldo.sh ]-------------+-----> [ ~/backups_remotos ]
```

---

### FASE 1: CONFIGURACIÓN DEL SERVIDOR DE PRODUCCIÓN (MV 1)

En esta etapa se procede con la personalización del nodo y la instalación del servicio web principal.

1. **Modificación del nombre de host:**
Es realizado para asegurar la identificación unívoca del nodo en la infraestructura.
```bash
sudo hostnamectl set-hostname WebProd-Apellido
```

2. **Actualización de repositorios e instalación de Apache2:**
La lista de paquetes es sincronizada y el servidor web es desplegado mediante el gestor de paquetes.
```bash
sudo apt update
sudo apt install apache2 nmap -y
```

3. **Edición del contenido web mediante el editor VI:**
Se accede al archivo de configuración de índice para personalizar el mensaje del servidor.
*Instrucciones de VI: Presionar la tecla "i" para entrar en modo inserción. Tras realizar los cambios, presionar "Esc", escribir ":wq" y presionar "Enter" para guardar y salir.*
```bash
sudo vi /var/www/html/index.html
```

4. **Compilación de herramienta de diagnóstico (iperf3):**
Para cumplir con el requerimiento de gestión de software desde código fuente, es descargada y compilada la herramienta iperf3, utilizada para medir el ancho de banda de la red.
```bash
sudo apt install build-essential -y
wget https://github.com/esnet/iperf/archive/refs/tags/3.15.tar.gz
tar -xzvf 3.15.tar.gz
cd iperf-3.15
./configure
make
sudo make install
sudo ldconfig
```

---

### FASE 2: CONFIGURACIÓN DEL SERVIDOR DE ALMACÉN (MV 2)

El segundo nodo es condicionado para actuar como repositorio receptor de los respaldos generados.

1. **Establecimiento de identidad:**
El nombre del sistema es configurado para diferenciarlo del servidor de producción.
```bash
sudo hostnamectl set-hostname BackupSrv-Apellido
```

2. **Creación del directorio de destino:**
Es generada una ruta específica en el directorio personal para organizar los archivos recibidos.
```bash
mkdir -p ~/backups_remotos
```

3. **Identificación de la dirección IP de red:**
La dirección lógica es verificada para ser empleada en el proceso de transferencia remota.
```bash
ip add
```

---

### FASE 3: AUTOMATIZACIÓN DEL RESPALDO Y TRANSFERENCIA (MV 1)

Un script de Bash es desarrollado en el servidor de producción para gestionar la integridad y el transporte de los datos hacia el nodo de reserva.

1. **Creación del archivo de automatización mediante VI:**
El archivo es generado en el directorio personal del usuario administrador.
```bash
vi ~/respaldo.sh
```

2. **Contenido del Script de Respaldo:**
Se definen variables para automatizar el proceso. El algoritmo Bzip2 es empleado por su alta tasa de compresión sobre el directorio web. La transferencia es ejecutada mediante el protocolo seguro SCP.
```bash
#!/bin/bash

# Definición de variables (Deben ser ajustadas al entorno real)
IP_DESTINO="192.168.10.20"
USUARIO_REMOTO="usuario"
FECHA=$(date +%Y-%m-%d)
NOMBRE_ARCHIVO="backup_web_$FECHA.tar.bz2"

# Generación del empaquetado comprimido de la carpeta web
tar -cvjf /tmp/$NOMBRE_ARCHIVO /var/www/html

# Transferencia del archivo al servidor de almacén mediante SCP
scp /tmp/$NOMBRE_ARCHIVO $USUARIO_REMOTO@$IP_DESTINO:~/backups_remotos/

# Eliminación del residuo temporal en el servidor local
rm /tmp/$NOMBRE_ARCHIVO

echo "El proceso de respaldo y transferencia ha finalizado satisfactoriamente."
```

3. **Asignación de privilegios y ejecución:**
El archivo es dotado de permisos de ejecución y es procesado por el intérprete de comandos.
```bash
chmod +x ~/respaldo.sh
./respaldo.sh
```

---

### FASE 4: PROTOCOLO DE SANEAMIENTO E HIGIENE (MV 1)

Tras la confirmación de la recepción del respaldo en la MV 2, se procede a la eliminación de componentes técnicos innecesarios en el servidor de producción para mantener un entorno optimizado.

1. **Purga de herramientas de compilación y auditoría:**
Los paquetes utilizados para la construcción de software y diagnóstico de red son eliminados.
```bash
sudo apt purge build-essential nmap -y
sudo apt autoremove --purge -y
```

2. **Remoción de directorios de código fuente:**
Los restos del proceso de compilación manual son eliminados para liberar espacio en el sistema de archivos.
```bash
rm -rf ~/3.15.tar.gz ~/iperf-3.15
```

3. **Limpieza de la caché del gestor de paquetes:**
Los archivos temporales de descarga almacenados por el sistema son saneados.
```bash
sudo apt clean
```

---

### RÚBRICA DE EVALUACIÓN

| Criterio de Evaluación | Sobresaliente (5 pts) | Logrado (3 pts) | En Proceso (2 pts) | No Logrado (0 pts) |
| :--- | :--- | :--- | :--- | :--- |
| Configuración de Red | Los nombres de host e IPs son validados y la conexión entre nodos es exitosa. | Existe conexión pero los nombres de host no fueron personalizados según la guía. | Se presentan fallos persistentes en el direccionamiento de las máquinas. | No fue establecida la comunicación entre los servidores. |
| Gestión de Apache2 | El servidor web es instalado y el contenido es personalizado mediante VI. | El servicio web funciona pero no se realizó la personalización del archivo index. | El servidor web es instalado pero presenta errores de inicio. | No se realizó la instalación del servidor Apache2. |
| Automatización y Respaldo | El script gestiona fechas, compresión Bzip2 y transferencia SCP con éxito. | El respaldo es generado pero se utiliza un algoritmo ineficiente o falla el SCP. | El archivo de respaldo es generado localmente pero no es transferido. | El script de automatización no fue presentado ni ejecutado. |
| Protocolo de Higiene | El servidor es entregado libre de residuos, archivos temporales y paquetes extra. | La limpieza es parcial y se conservan carpetas de código fuente en el sistema. | Solo se realizó una eliminación superficial de los paquetes instalados. | No se realizó ningún proceso de saneamiento tras las pruebas. |

