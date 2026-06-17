# Semana 1: Introducción al ecosistema GNU/Linux
## Curso: Sistemas Operativos de Código Abierto | Tecsup

---

### 1. Resumen Ejecutivo
Esta sesión introduce los cimientos de GNU/Linux, desde su filosofía de desarrollo colaborativo hasta la arquitectura técnica que permite su eficiencia en servidores. Se aborda la estructura del sistema (Kernel, Shell, hardware), la diversidad de distribuciones y la gestión básica de estados del sistema (runlevels) y hardware.

---

### 2. Fundamentos Teóricos
*   **Filosofía y Origen:** A diferencia de sistemas propietarios, GNU/Linux se fundamenta en la licencia **GPL (General Public License)**. Como señala Stallman, el software libre no se basa en la gratuidad, sino en las cuatro libertades esenciales: ejecución, estudio, modificación y redistribución.
*   **Arquitectura en Capas:**
    *   **Hardware:** Nivel físico gestionado directamente por el Kernel.
    *   **Kernel (Núcleo):** El corazón del SO. Gestiona la memoria, los procesos y el acceso al hardware. Nemeth (2017) enfatiza que el kernel es modular, permitiendo cargar solo los drivers necesarios (*loadable kernel modules*), lo cual es crítico para la estabilidad de un servidor.
    *   **Shell:** El intérprete de comandos (Bash, Zsh, etc.). Es la interfaz primaria del administrador de redes para interactuar con el sistema sin necesidad de una GUI.
*   **Sistemas de Archivos (FHS):** La estructura jerárquica que parte de la raíz (`/`) no es arbitraria; sigue el *Filesystem Hierarchy Standard*. Separar `/boot`, `/etc` (configuración) y `/var` (datos variables/logs) permite, por ejemplo, montar `/var` en una partición distinta para evitar que un log desbordado detenga el sistema operativo.

---

### 3. Guía Práctica y Comandos Esenciales
Para un administrador de redes, la terminal es su herramienta principal.

#### Comandos de Inspección de Hardware
| Comando | Uso Profesional | Riesgo/Nota |
| :--- | :--- | :--- |
| `uname -a` | Identifica versión del kernel y arquitectura. | Vital antes de instalar módulos (ej. controladores Nvidia). |
| `dmidecode -q` | Extrae información del DMI/BIOS (hardware). | Requiere privilegios de `root`. |
| `hdparm` | Ajusta parámetros de discos duros. | **Peligroso:** Una mala configuración puede dañar el rendimiento de E/S. |
| `cat /proc/cpuinfo` | Verifica hilos, cores y banderas de CPU. | Información volcada directamente del Kernel. |

#### Estados del Sistema (Runlevels)
El concepto de *Runlevel* define qué servicios están activos. En servidores de producción, el **Runlevel 3** (Multi-user, text mode, networking) es el estándar de oro, ya que el modo gráfico (Runlevel 5) consume recursos y aumenta la superficie de ataque innecesariamente.

---

### 4. Anticipación de Dudas (FAQ)

**P1: ¿Por qué es necesario conocer el hardware desde la terminal si existe una GUI?**
*   **Respuesta:** Los servidores de alto rendimiento raramente instalan entornos gráficos. Un administrador debe ser capaz de diagnosticar un fallo de RAM o disco (`dmidecode`, `lsusb`) sin depender de interfaces visuales que pueden no estar disponibles en una emergencia.

**P2: ¿Es "Software Libre" lo mismo que "Código Abierto"?**
*   **Respuesta:** Aunque se usan indistintamente, el *Software Libre* (FSF) se centra en la ética y libertades del usuario. El *Open Source* es una metodología de desarrollo más enfocada en la colaboración técnica y eficiencia pragmática.

**P3: ¿Qué ocurre si el sistema arranca en el runlevel 1?**
*   **Respuesta:** Entrarás en modo *Single User* o modo de mantenimiento. Es el nivel donde el sistema no tiene red y solo el administrador está conectado. Es el único lugar seguro para realizar reparaciones críticas de sistemas de archivos (filesystem check).

**P4: ¿Por qué la contraseña no se muestra al escribirla?**
*   **Respuesta:** Es una medida de seguridad llamada *echo suppression*. Evita el "shoulder surfing" (que alguien vea cuántos caracteres tiene tu clave).

**P5: ¿Si instalo dos distribuciones (Windows y Ubuntu), qué pasa con el Boot Loader?**
*   **Respuesta:** El *Boot Loader* (GRUB, en Linux) debe ser capaz de detectar la partición de Windows (a través de `os-prober`) para integrarla en el menú de arranque. Si se instala Windows después de Linux, Windows sobrescribirá el MBR/EFI, requiriendo reparar GRUB mediante una Live USB.

---

### 5. Sustento Bibliográfico
*   **Conceptos sobre Kernel y Arquitectura:** Extraídos de *Nemeth, E. et al. (2017). UNIX and Linux System Administration Handbook*. El énfasis en la modularidad y la estructura de directorios FHS se basa en este manual.
*   **Comandos y uso de Terminal:** Basado en *Shotts, W. E. (2019). The Linux Command Line*. Las explicaciones sobre el uso de `/proc/` como interfaz de diagnóstico fueron enriquecidas con este texto.
*   **Filosofía y Metodología:** Extraído del contenido de la sesión (slides) y complementado con la teoría general del Proyecto GNU.

---
*Nota para el alumno: El dominio de esta semana es el prerrequisito para la automatización avanzada (shell scripting) que veremos en semanas posteriores.*
