# GUÍA DE LABORATORIO: DIAGNÓSTICO DE HARDWARE Y RESOLUCIÓN DE FALLOS EN LA PILA GRÁFICA


## 1. Objetivos de Aprendizaje (Competencias)
Al finalizar este laboratorio, el estudiante será capaz de:
1.  **Auditar e inventariar** el hardware de un servidor GNU/Linux utilizando herramientas nativas de terminal y el sistema de archivos virtual `/proc` [5, 6].
2.  **Diagnosticar y reparar** inconsistencias en sistemas de archivos de manera segura, aplicando protocolos de prevención de pérdida de datos [12].
3.  **Analizar el rendimiento** del procesador, subsistema de memoria y bus de datos bajo escenarios de alta carga de trabajo [8, 11].
4.  **Resolver bloqueos y fallos de configuración** en el servidor de despliegue gráfico (X11/Wayland) utilizando consolas virtuales (TTY) y análisis de registros (*logs*) [14, 18].

---

## 2. Requisitos Previos y Entorno de Trabajo
*   Una máquina virtual o física con **Ubuntu Server / Desktop** (se recomienda versión LTS) con acceso a internet.
*   Usuario con privilegios de administración en el sistema (acceso a `sudo`).
*   Herramientas necesarias instaladas (se provee el comando de instalación en la primera fase).

---

## 3. Escenario del Desafío: El Caso del Servidor "Apolo"
> **Contexto:** Usted ha sido contratado como administrador de sistemas de segundo nivel para la empresa *Apolo-Tech*. El servidor principal de desarrollo ("Apolo"), que aloja bases de datos e interfaces de renderizado ligero, ha estado experimentando congelamientos aleatorios en la interfaz de usuario, lentitud extrema al escribir en el disco y alertas de temperatura en la CPU. 
> 
> Su misión es realizar una auditoría completa del hardware del servidor, diagnosticar de manera segura la integridad del disco sin dañar los datos en producción, estresar el sistema para encontrar inestabilidades térmicas y resolver un fallo crítico que impide arrancar el entorno gráfico del sistema.

---

## 4. Desarrollo de Retos Prácticos

### 🛠️ Fase de Preparación de Herramientas
Antes de iniciar, actualice los repositorios e instale los paquetes que utilizaremos en este laboratorio ejecutando:
```bash
sudo apt update
sudo apt install -y lshw inxi stress-ng fontconfig smartmontools
```

---

### RETO 1: Auditoría Profunda e Inventario del Sistema (45 minutos)
**Objetivo:** Obtener un inventario estructurado de los componentes físicos clave del servidor utilizando métodos no intrusivos [5, 8].

#### Instrucciones de Ejecución:
1.  **Inspección del Kernel:** Lea el archivo virtual que reporta el estado detallado de la memoria RAM del sistema.
    ```bash
    cat /proc/meminfo
    ```
    *Identifique qué significa el campo `MemAvailable` y por qué es más preciso para los sysadmins que el campo `MemFree`.*
2.  **Análisis de Arquitectura:** Extraiga la topología del procesador del servidor y verifique si posee banderas de virtualización (como VT-x o AMD-V) [10].
    ```bash
    lscpu
    ```
3.  **Auditoría de Firmware BIOS:** Utilice `dmidecode` para obtener la versión exacta del firmware de la placa madre y la velocidad real de operación del módulo de memoria RAM instalado [8].
    ```bash
    sudo dmidecode -t bios
    sudo dmidecode -t memory
    ```
4.  **Generación de Inventario Automatizado:** Genere un reporte jerárquico estructurado en formato HTML del hardware del servidor y guárdelo en su directorio personal para su posterior entrega [5].
    ```bash
    sudo lshw -html > ~/reporte_hardware_apolo.html
    ```

**Entregable del Reto 1:** Adjunte a su informe las respuestas del análisis de `/proc/meminfo` y el archivo HTML generado con `lshw` [5, 6].

---

### RETO 2: Diagnóstico Seguro de Discos y Pruebas de Estrés (60 minutos)
**Objetivo:** Aprender a manipular herramientas de integridad de datos de forma segura e identificar inestabilidades en la CPU bajo carga [11, 12].

####   Actividad Crítica de Seguridad: Simulación Segura de `fsck`
Como aprendió en clase, **ejecutar `fsck` sobre un sistema de archivos montado puede corromper los datos de manera irreversible** [12]. Para practicar de forma segura, creará un disco virtual simulado en un archivo, creará un sistema de archivos en él, simulará un fallo y lo reparará [12].

1.  **Crear un disco virtual de 100MB:**
    ```bash
    dd if=/dev/zero of=~/disco_virtual.img bs=1M count=100
    ```
2.  **Dar formato ext4 al disco virtual:**
    ```bash
    mkfs.ext4 ~/disco_virtual.img
    ```
3.  **Montar el disco virtual para escribir datos de prueba:**
    ```bash
    mkdir ~/punto_montaje
    sudo mount -o loop ~/disco_virtual.img ~/punto_montaje
    echo "Datos de producción críticos de Apolo" | sudo tee ~/punto_montaje/archivo_critico.txt
    ```
4.  **La Regla de Oro en Acción (Simulación de Fallo):** Intente ejecutar `fsck` sobre el archivo de imagen mientras está montado. Observe el mensaje de advertencia del sistema operativo [12].
    ```bash
    sudo fsck.ext4 ~/disco_virtual.img
    ```
5.  **Procedimiento Seguro de Reparación:** Desmonte el volumen de forma segura y luego proceda a ejecutar la verificación y reparación de consistencia [12].
    ```bash
    sudo umount ~/punto_montaje
    sudo fsck.ext4 -f ~/disco_virtual.img
    ```

#### Pruebas de Estrés y Telemetría de CPU
1.  Abra una segunda ventana de terminal para monitorear el comportamiento de la CPU y la memoria virtual cada segundo:
    ```bash
    vmstat 1
    ```
2.  En la terminal principal, inicie una prueba de estrés agresiva en la CPU durante 60 segundos usando `stress-ng` para emular una compilación masiva del kernel [11]:
    ```bash
    stress-ng --cpu 4 --timeout 60s --metrics-brief
    ```
3.  **Análisis:** Observe en la ventana de `vmstat` el comportamiento de las columnas `us` (tiempo de CPU de usuario), `sy` (tiempo de CPU del sistema) y las columnas de memoria virtual `si` / `so` [12]. 

**Entregable del Reto 2:** Explique brevemente por qué el sistema operativo bloquea la ejecución de `fsck` en caliente y qué valores de `vmstat` se dispararon durante la prueba de estrés con `stress-ng` [11, 12].

---

### RETO 3: Depuración y Recuperación de la Interfaz Gráfica (60 minutos)
**Objetivo:** Solucionar problemas de rendimiento, analizar controladores gráficos y simular la recuperación de un sistema gráfico colapsado [13, 14, 18].

#### 1. Auditoría del Subsistema Gráfico
Consulte los detalles del adaptador gráfico del servidor, el servidor de visualización activo y determine si se están utilizando controladores de código abierto o propietarios [13].
```bash
inxi -Gx
```

#### 2. Simulación de Incidente de congelamiento de la GUI
Imagine que la pantalla gráfica de Ubuntu se congela por completo y el ratón no responde. Aplique el protocolo de recuperación del administrador de sistemas [18]:
1.  **Forzar cambio a consola TTY:** Presione en su teclado la combinación de teclas:
    `Ctrl` + `Alt` + `F3`
    *(Esto lo sacará del entorno gráfico y le abrirá una interfaz de consola pura basada en texto)* [18].
2.  Inicie sesión con su usuario y contraseña habituales.
3.  **Buscar el fallo en los Logs:** Inspeccione el archivo de registro del servidor de despliegue gráfico buscando específicamente advertencias críticas o errores (marcados con la etiqueta de error `(EE)`) [18].
    ```bash
    grep "(EE)" /var/log/Xorg.0.log
    ```
    *Nota: Si su sistema utiliza Wayland por defecto, revise el log del sistema mediante:*
    ```bash
    journalctl -b | grep -i "wayland"
    ```
4.  **Reinicio del servicio:** Si la interfaz gráfica no responde, simule la restauración del sistema reiniciando el Administrador de Pantalla (Display Manager) [18].
    ```bash
    sudo systemctl restart gdm3
    ```
    *(O reemplace `gdm3` por `lightdm` o `sddm` según su entorno de escritorio)* [18].
5.  **Retorno Seguro:** Regrese a la interfaz gráfica presionando `Ctrl` + `Alt` + `F1` o `Ctrl` + `Alt` + `F2`.

**Entregable del Reto 3:** Describa paso a paso qué acciones tomaría como sysadmin si encuentra un error crítico `(EE)` en los logs de video que impida el inicio de la sesión gráfica [18].

---

## 5. Preguntas de Reflexión Crítica (Para el informe)
Para consolidar los aprendizajes teóricos y prácticos de esta sesión, responda de forma analítica:
1.  **Diferenciación Tecnológica:** ¿Qué ventajas operativas y de seguridad ofrece la arquitectura moderna de **Wayland** en comparación con el modelo tradicional cliente-servidor de **X11**? [10, 19]
2.  **Análisis de Caso:** Durante una auditoría con `vmstat`, observa que la columna de swap-out (`so`) registra valores altos de manera constante, mientras que el porcentaje de CPU inactiva (`id`) se encuentra cerca del 95% [12]. ¿Qué diagnóstico daría sobre la salud y la configuración del hardware de este servidor?
3.  **Prevención de Pérdidas:** ¿Por qué es una mala práctica de administración desactivar o ignorar las alertas de tecnología **SMART** en discos duros de servidores empresariales?

---

## 6. Rúbrica de Evaluación

| Criterio de Evaluación | Sobresaliente (20-17) | Aceptable (16-11) | Requiere Mejora (10-0) |
| :--- | :--- | :--- | :--- |
| **Reto 1: Inventario de Hardware** | Genera el reporte HTML de forma limpia y explica de manera profunda la diferencia técnica de los campos de memoria en `/proc/meminfo` [5, 6]. | Genera el reporte HTML, pero tiene dificultades para explicar o analizar la información técnica del procesador y memoria [5, 8]. | No logra generar el reporte HTML de hardware o no comprende el propósito del directorio `/proc` [5, 6]. |
| **Reto 2: Integridad y Estrés** | Diseña correctamente la simulación del disco virtual para ejecutar `fsck` con seguridad y analiza críticamente el flujo de `vmstat` [11, 12]. | Ejecuta la simulación de `fsck`, pero muestra vacíos conceptuales sobre los riesgos de reparar un volumen montado en caliente [12]. | No logra configurar el disco simulado o ejecuta comandos peligrosos que comprometen la salud de la máquina virtual [12]. |
| **Reto 3: Troubleshooting de GUI** | Recupera con éxito el control mediante consola TTY, rastrea errores específicos en los archivos de registros e identifica los controladores con `inxi` [13, 18]. | Realiza el cambio a TTY y reinicia el servicio gráfico, pero tiene dificultades para interpretar la salida de los archivos de logs [18]. | No logra cambiar a consolas virtuales de diagnóstico o desconoce cómo leer logs de errores del sistema gráfico [18]. |
| **Preguntas de Reflexión** | Responde las preguntas de análisis técnico con bases sólidas, utilizando terminología adecuada y referenciando la teoría del curso [10, 19]. | Responde las preguntas de manera superficial, mostrando una comprensión general pero carente de rigurosidad de arquitectura de sistemas. | Sus respuestas muestran contradicciones técnicas graves o copias literales sin análisis propio. |
