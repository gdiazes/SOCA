
#  LABORATORIO N° 05: CICLO DE VIDA Y OPERACIÓN DE SOFTWARE
## Gestión de Infraestructura, Compilación y Saneamiento de Servidores

**Especialidad:** Administración de Servidores de Misión Crítica
**Entorno:** Ubuntu Server (Headless / Solo Terminal)
**Metodología:** Aprendizaje Basado en Escenarios de Producción (SRE)

---

### I. GESTIÓN DE IDENTIDAD (Hostname)
Antes de operar, debemos asegurar la trazabilidad. No puedes aplicar cambios si no sabes exactamente en qué servidor estás.
1.  **Comando:** `sudo hostnamectl set-hostname [TuNombre]Srv` (Ej: `jdiazSrv`).
2.  **Validación:** Reinicia la terminal. Tu prompt debe mostrar tu nombre. **Captura obligatoria.**

---

### II. FASE 1: AUDITORÍA DE RED CON `APT`
**El Escenario:** "El equipo de seguridad reporta que hay puertos sospechosos abiertos en el servidor. Debes identificar qué servicios están escuchando."

1.  **Instalación:** `sudo apt update && sudo apt install nmap -y`
2.  **Uso de Sysadmin:** Ejecuta un escaneo de puertos locales:
    ```bash
    nmap -sV localhost
    ```
    *Análisis:* ¿Qué servicios detectaste? (SSH, HTTP, etc.). Esto permite cerrar brechas de seguridad.

---

### III. FASE 2: DIAGNÓSTICO DE RED CON `DPKG` (.deb)
**El Escenario:** "Los usuarios se quejan de lentitud en la transferencia de datos. Debes medir el ancho de banda real del servidor hacia internet."

1.  **Obtención de la herramienta oficial (Speedtest CLI):**
    ```bash
        sudo apt install speedtest-cli
        speedtest-cli
        wget https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-x86_64.deb
    ```
2.  **Instalación:** `sudo dpkg -i ookla-speedtest-*.deb`
3.  **Uso de Sysadmin:** Ejecuta la prueba de estrés de red:
    ```bash
    speedtest
    ```
    *Análisis:* Reporta la velocidad de bajada/subida y la latencia (ping). Datos vitales para SLAs.

---

### IV. FASE 3: OPTIMIZACIÓN DE DATOS MEDIANTE COMPILACIÓN
**El Escenario:** "La aplicación web está lenta. Necesitas instalar una base de datos en memoria (Redis) compilada específicamente para tu arquitectura de CPU para obtener el máximo rendimiento."

1.  **Preparación del entorno:** `sudo apt install build-essential tcl -y`
2.  **Compilación Manual:**
    ```bash
    wget http://download.redis.io/releases/redis-stable.tar.gz
    tar -xzvf redis-stable.tar.gz
    cd redis-stable
    make
    sudo make install
    ```
3.  **Uso de Sysadmin:** Verifica la integridad del binario compilado:
    ```bash
    redis-server --version
    ```
    *Análisis:* Al compilar, has optimizado el binario para tu hardware actual, algo que un paquete genérico no siempre logra.

---

### V. FASE 4: MONITOREO DE HARDWARE (Binarios `TAR.GZ`)
**El Escenario:** "Necesitas extraer métricas de temperatura y uso de disco para enviarlas a un panel de monitoreo (Grafana)."

1.  **Despliegue de Node Exporter:**
    ```bash
    wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
    tar -xvf node_exporter-1.7.0.linux-amd64.tar.gz
    ```
2.  **Uso de Sysadmin:** Ejecuta el agente en segundo plano y observa las métricas:
    ```bash
    ./node_exporter-1.7.0.linux-amd64/node_exporter &
    curl localhost:9100/metrics | head -n 20
    ```
    *Análisis:* Estás visualizando los datos crudos que el servidor envía al sistema de monitoreo global.

---

### VI. FASE FINAL: SANEAMIENTO DEL SERVIDOR (Cleanup)
**El Escenario:** "Has terminado las pruebas. Como buen administrador, debes dejar el servidor exactamente como lo encontraste: limpio y sin paquetes de prueba."

1.  **Eliminación Completa de APT:**
    ```bash
    sudo apt purge nmap -y
    sudo apt autoremove --purge -y
    ```
2.  **Eliminación de Paquetes DPKG:**
    ```bash
    sudo dpkg -r speedtest
    ```
3.  **Limpieza de Directorios de Trabajo:**
    ```bash
    rm -rf ~/redis-stable* ~/node_exporter* ~/ookla-speedtest*
    ```
4.  **Limpieza de Caché de Descargas:**
    ```bash
    sudo apt clean
    ```

---

### VII. RÚBRICA DE EVALUACIÓN (Escala 0-20)

| Criterio | Senior (5 pts) | Junior (3 pts) | Soporte (2 pts) | No Apto (0 pts) |
| :--- | :--- | :--- | :--- | :--- |
| **Identidad del Nodo** | Hostname personalizado visible en cada paso. | Hostname correcto pero falta evidencia. | Formato incorrecto. | Sin cambio. |
| **Operación y Uso Real** | Ejecuta nmap/speedtest y analiza los resultados técnicamente. | Instala las herramientas pero no demuestra su uso práctico. | Solo muestra la instalación exitosa. | No instaló los paquetes. |
| **Habilidad de Compilación** | Compilación de Redis exitosa y verificación de versión. | Fallos menores en el proceso de `make`. | No instaló dependencias de compilación. | No intentó compilar. |
| **Protocolo de Limpieza** | Demuestra el servidor libre de archivos temporales y paquetes purgados. | Eliminó archivos pero dejó dependencias instaladas. | Solo eliminó los archivos `.tar.gz`. | Dejó el sistema sucio. |

---
** Un Sysadmin no se mide por cuánto software puede instalar, sino por cuán bien puede operar ese software para resolver problemas del negocio y por la disciplina de **no dejar rastro** tras una intervención. **
