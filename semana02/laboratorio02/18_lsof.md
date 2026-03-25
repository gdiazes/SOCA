
### Nivel 1: El Junior (Búsqueda por Archivo)
El error de novato es intentar borrar un archivo y que el sistema diga "Archivo en uso", pero no saber por quién.

**1. ¿Quién está tocando esto?: `lsof [ruta_archivo]`**
*   **Comando:** `lsof /var/log/syslog`
*   **Qué hace:** Te dice qué procesos tienen abierto ese archivo específico en este momento.
*   **Uso real:** Descubrir por qué no puedes desmontar un USB o borrar un log que parece estar "bloqueado".

**2. Ver todo (El diluvio): `lsof`**
*   **Acción:** Ejecutar `lsof` a secas.
*   **Qué hace:** Lista los miles de archivos abiertos por el sistema. Es demasiado ruido.
*   **Uso real:** Casi nunca se usa solo; siempre se filtra con `grep`.

---

### Nivel 2: El Administrador Intermedio (Redes y Usuarios)
Aquí es donde `lsof` reemplaza a otros comandos como `netstat`.

**3. Auditoría de Red: `lsof -i`**
*   **Comando:** `sudo lsof -i :80` (o cualquier puerto).
*   **Qué hace:** Muestra qué proceso está escuchando en el puerto 80 (HTTP).
*   **Uso real:** Descubrir por qué tu servidor Apache no arranca (quizás Nginx ya tomó el puerto).

**4. Filtrar por Usuario: `lsof -u`**
*   **Comando:** `lsof -u master`
*   **Qué hace:** Lista todo lo que el usuario `master` tiene abierto (archivos, sockets, librerías).
*   **Uso real:** Investigar si un usuario está ejecutando scripts sospechosos en su `/home`.

---

### Nivel 3: El SysAdmin Senior (Forense de Incidentes)
A este nivel, usamos `lsof` para resolver el misterio del "espacio fantasma".

**5. El Truco del "Archivo Borrado pero Vivo": `lsof +L1`**
*   **Comando:** `sudo lsof +L1`
*   **Qué hace:** Busca archivos que han sido borrados con `rm` pero que **un proceso sigue manteniendo abiertos**.
*   **Uso real:** **EL COMANDO CLAVE DE NUESTRO LABORATORIO.** Si borraste los archivos `.dat` pero el disco sigue al 100%, es porque el proceso sigue escribiendo en ellos en la memoria. Este comando te dirá el PID del culpable para que lo mates.

**6. Investigar un Proceso por PID: `lsof -p`**
*   **Comando:** `sudo lsof -p 14595`
*   **Qué hace:** Muestra **absolutamente todo** lo que ese proceso tiene abierto: sus archivos de datos, sus conexiones de red y sus librerías `.so`.
*   **Uso real:** Analizar qué hace realmente un binario sospechoso que se llama `.udev-cache`.

---

### Nivel 4: El "Gurú" del Sistema (Filtros Avanzados)

**7. La Condición AND: `lsof -a`**
*   **Comando:** `sudo lsof -a -u root -iTCP:22`
*   **Qué hace:** Busca archivos que pertenezcan a root **Y** que sean de la conexión SSH. Sin el `-a`, `lsof` interpreta los filtros como un "OR".
*   **Uso real:** Auditorías de seguridad extremadamente precisas.

**8. Escaneo de Directorio Recurrente: `lsof +D`**
*   **Comando:** `sudo lsof +D /var/tmp`
*   **Qué hace:** Lista todos los procesos que tienen archivos abiertos dentro de esa carpeta y sus subcarpetas.
*   **Uso real:** Identificar rápidamente qué está llenando una partición específica.

**9. Modo "Solo PID" para Scripting: `lsof -t`**
*   **Comando:** `kill -9 $(lsof -t /.sys_res_0.dat)`
*   **Qué hace:** El `-t` devuelve solo el número del PID.
*   **Uso real:** Automatización. Puedes crear un script que mate automáticamente a cualquier proceso que toque un archivo prohibido.

