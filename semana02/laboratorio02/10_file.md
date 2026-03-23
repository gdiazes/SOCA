El comando **`file`** es el detective privado del SysAdmin. A diferencia de Windows, donde un archivo `.txt` se considera texto y un `.exe` un ejecutable solo por su nombre, **a Linux no le importan las extensiones**. Puedes llamar a una imagen `foto.txt` y Linux seguirá sabiendo que es una imagen.

¿Cómo lo sabe? Leyendo los "Magic Numbers" (firmas en los primeros bytes del archivo). El comando `file` lee esos bytes y te dice **exactamente qué es el archivo**, independientemente de cómo se llame.

Aquí tienes la guía de **`file`** para tu **`laboratorio02`**:

---

### Preparación del Escenario
Vamos a crear archivos con "identidades falsas" para que `file` demuestre su poder de deducción.

```bash
mkdir -p laboratorio02/var/backups/auditoria_file

# 1. Creamos un script de Bash pero lo llamamos ".jpg" (Típico truco hacker)
echo '#!/bin/bash' > laboratorio02/var/backups/auditoria_file/foto_vacaciones.jpg
echo 'echo "Soy un virus"' >> laboratorio02/var/backups/auditoria_file/foto_vacaciones.jpg
chmod +x laboratorio02/var/backups/auditoria_file/foto_vacaciones.jpg

# 2. Creamos un archivo vacío real
touch laboratorio02/var/backups/auditoria_file/archivo_vacio.txt

# 3. Creamos un archivo de configuración ASCII normal
echo "PORT=8080" > laboratorio02/var/backups/auditoria_file/config.conf

# 4. Creamos un enlace simbólico
ln -s /etc/passwd laboratorio02/var/backups/auditoria_file/enlace_falso.pdf

echo "Escenario de auditoría listo."
```

---

### Nivel 1: El Junior (Identificación Básica)

**1. Analizar un archivo sospechoso:**
```bash
file laboratorio02/var/backups/auditoria_file/foto_vacaciones.jpg
```
*   **Resultado esperado:** `Bourne-Again shell script, ASCII text executable`
*   **Qué hace:** Lee la cabecera del archivo (`#!/bin/bash`) e ignora por completo que termina en `.jpg`.
*   **Uso real:** **Auditoría de seguridad básica**. Descubrir si un usuario subió un script malicioso camuflado como imagen a la carpeta pública del servidor web.

**2. Analizar múltiples archivos:**
```bash
file laboratorio02/var/backups/auditoria_file/*
```
*   **Qué hace:** Analiza todos los archivos de una carpeta y te da un reporte línea por línea del tipo de cada uno.
*   **Uso real:** Revisar rápidamente qué tipo de datos hay en una carpeta de descargas o de "uploads" de usuarios.

---

### Nivel 2: El Administrador Intermedio (Tipos de Datos y Enlaces)

**3. Identificar el "MIME type" (`-i`):**
Los servidores web (como Apache o Nginx) no hablan en texto normal, hablan en "MIME types" (ej. `text/html`, `image/png`).
```bash
file -i laboratorio02/var/backups/auditoria_file/config.conf
```
*   **Resultado esperado:** `text/plain; charset=us-ascii`
*   **Qué hace:** Te da el tipo MIME oficial y la codificación de caracteres.
*   **Uso real:** Configurar servidores web. Si un archivo `.css` no carga en la página web, usas esto para ver si el sistema operativo realmente lo está detectando como texto o si se corrompió como binario.

**4. Seguir enlaces simbólicos (`-L`):**
Por defecto, si analizas un enlace simbólico, `file` te dice "esto es un enlace". Pero a ti te interesa saber **qué hay del otro lado** del enlace.
```bash
file -L laboratorio02/var/backups/auditoria_file/enlace_falso.pdf
```
*   **Resultado esperado:** Te dirá que es un archivo de texto ASCII (porque apunta a `/etc/passwd`), ignorando que es un enlace y que se llama `.pdf`.
*   **Uso real:** Analizar accesos directos sospechosos sin tener que buscar a mano la ruta original a la que apuntan.

---

### Nivel 3: El SysAdmin Senior (Archivos Especiales y Compresión)

**5. Identificar archivos vacíos:**
```bash
file laboratorio02/var/backups/auditoria_file/archivo_vacio.txt
```
*   **Resultado esperado:** `empty`
*   **Uso real:** Detectar logs que no están registrando nada o bases de datos que se corrompieron y quedaron en 0 bytes.

**6. Analizar el interior de archivos comprimidos (`-z`):**
Imagina que tienes un archivo `.gz` (gzip). Si usas `file` normal, solo te dirá "esto está comprimido con gzip". Pero tú quieres saber **qué hay dentro** sin descomprimirlo.
```bash
# Primero comprimimos el config para la prueba:
gzip -c laboratorio02/var/backups/auditoria_file/config.conf > laboratorio02/var/backups/auditoria_file/config.conf.gz

# Ahora miramos "dentro" del archivo comprimido:
file -z laboratorio02/var/backups/auditoria_file/config.conf.gz
```
*   **Resultado esperado:** Te dirá que es un archivo comprimido, pero también te dirá que **contiene texto ASCII**.
*   **Uso real:** Analizar backups viejos (ej. `backup_2020.tar.gz`) para saber si dentro hay texto, binarios de base de datos o imágenes, sin gastar gigabytes de disco descomprimiéndolos.

---

### Nivel 4: El "Gurú" del Sistema (Desofuscación)

**7. Modo "Solo la respuesta" (`-b` de brief):**
Cuando haces scripts automatizados (Bash scripting), no quieres que `file` te imprima el nombre del archivo, solo quieres el resultado de qué tipo es.
```bash
file -b laboratorio02/var/backups/auditoria_file/foto_vacaciones.jpg
```
*   **Resultado esperado:** `Bourne-Again shell script, ASCII text executable` (sin mostrar la ruta `/var/backups/...`).
*   **Uso real:** **Scripts de limpieza automática**. Imagina un script que recorre la carpeta de imágenes subidas por los usuarios. Usas `file -b` y, si el resultado contiene la palabra "script" o "executable", el script borra el archivo automáticamente y banea al usuario.

---

### 🔥 Tu Reto de SysAdmin con `file`

Un desarrollador te envía un archivo misterioso llamado `datos_procesados.bin` y te dice que no sabe si es un archivo de texto, un binario compilado o un archivo comprimido. Además, te pide que tu respuesta sea directa (sin incluir el nombre del archivo en la salida) y que, si resulta ser texto, le digas cuál es el tipo **MIME** oficial para configurarlo en el servidor web.

**Misión:**
1.  Supón que el archivo está en `laboratorio02/var/backups/auditoria_file/datos_procesados.bin` (puedes crearlo rápido con `echo "Hola" > ...`).
2.  Usa `file` para analizarlo.
3.  Asegúrate de que la salida sea **breve** (solo el resultado).
4.  Asegúrate de que la salida esté en formato **MIME type**.

**¿Qué comando de 3 banderas (o 2 si las combinas) usarías para darle la respuesta exacta al desarrollador?**

*(Pista: Necesitas combinar `-b` e `-i`).*
