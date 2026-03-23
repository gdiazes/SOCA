El comando **`cpio` (Copy In, Copy Out)** es una reliquia legendaria en el mundo UNIX. Aunque `tar` es más popular para el día a día, los SysAdmins avanzados aman `cpio` por una razón brutal: **fue diseñado para trabajar conectado al comando `find`**. 

Mientras `tar` empaqueta lo que le dices, `cpio` lee una lista de rutas desde la *entrada estándar* (tuberías o pipes) y las empaqueta, lo que te permite hacer backups granulares o clonaciones de discos con una precisión milimétrica. Además, es el formato interno que usa Linux para arrancar (el famoso `initramfs` es un archivo cpio comprimido) y el formato de los paquetes RPM (Red Hat).

Aquí tienes la guía de **`cpio`** para tu **`laboratorio02`**:

---

### Preparación del Escenario
Vamos a crear las carpetas de pruebas para no mezclar los backups de cpio con los de tar.
```bash
mkdir -p laboratorio02/var/backups/cpio_data/restauracion
touch laboratorio02/var/log/syslog.1 laboratorio02/var/log/syslog.2
```

---

### Nivel 1: El Junior (Crear y Listar)

`cpio` usa letras que definen la dirección de los datos: **`-o`** (Out: para crear el archivo) e **`-i`** (In: para extraer del archivo). Siempre recomendamos usar **`-c`** (formato ASCII portable) para evitar problemas de compatibilidad entre distintos servidores.

**1. Crear un archivo CPIO (Copy-Out):**
```bash
find laboratorio02/etc/cron.d | cpio -ovc > laboratorio02/var/backups/cpio_data/crons_backup.cpio
```
*   **Qué hace:** `find` escupe la lista de archivos de cron, el pipe (`|`) se los pasa a `cpio`, y el `>` lo guarda en un archivo físico.
*   **Uso real:** Respaldar estructuras exactas generadas dinámicamente.

**2. Listar el contenido (`-t` de Table of contents):**
```bash
cpio -tv < laboratorio02/var/backups/cpio_data/crons_backup.cpio
```
*   **Qué hace:** Lee el archivo usando la redirección de entrada (`<`) y te muestra un `ls -l` de lo que hay dentro sin extraerlo.
*   **Uso real:** Auditoría. Es exactamente lo mismo que harías para ver qué hay dentro de la imagen de arranque (`initrd`) del kernel de Linux si el servidor no quiere bootear.

---

### Nivel 2: El Administrador Intermedio (Extracción Segura)

**3. Extraer el archivo (Copy-In):**
```bash
cd laboratorio02/var/backups/cpio_data/restauracion/
cpio -idvc < ../crons_backup.cpio
cd - # Volvemos a la ruta original
```
*   **Qué hace:** Extrae (`-i`) el contenido del backup. El flag crítico aquí es **`-d`** (make directories), que le dice a cpio que recree las carpetas (`etc/cron.d/...`) si no existen en el destino.
*   **Uso real:** Restaurar un backup manteniendo intacta la jerarquía de carpetas original. Si omites la `-d`, cpio fallará quejándose de que no encuentra la ruta.

---

### Nivel 3: El SysAdmin Senior (El combo Find + CPIO)

Aquí es donde `cpio` humilla a `tar`. En lugar de excluir cosas, usas la potencia de `find` para seleccionar **exactamente** qué quieres respaldar.

**4. Backup Quirúrgico (Por tamaño y extensión):**
Imagina que quieres respaldar todos los `.log` de Apache, pero **solo los que pesen menos de 5MB** (para evitar saturar la red).
```bash
find laboratorio02/var/log/apache2 -name "*.log" -size -5M | cpio -ovc > laboratorio02/var/backups/cpio_data/logs_pequenos.cpio
```
*   **Uso real:** Backups ultra-granulares. Hacer esto con `tar` requiere comandos mucho más largos o archivos de texto intermedios. `cpio` toma la salida de `find` y la digiere en tiempo real.

---

### Nivel 4: El "Gurú" del Sistema (Clonación Pass-Through)

**5. El modo Pass-Through (`-p`):**
Este es el secreto mejor guardado de los SysAdmins de la vieja escuela. `cpio -p` copia archivos de un árbol de directorios a otro **sin crear el archivo .cpio intermedio**. Es un clonador perfecto.

```bash
mkdir -p laboratorio02/var/backups/cpio_data/clon_web
find laboratorio02/var/www/html/ | cpio -pvd laboratorio02/var/backups/cpio_data/clon_web/
```
*   **Qué hace:** `find` lista toda la web. `cpio` en modo `-p` (pass-through) lee esa lista, mantiene los permisos originales, respeta los enlaces duros y simbólicos, y replica el árbol exacto dentro de la carpeta `clon_web`.
*   **Uso real:** **Migraciones de discos en caliente**. Muchos ingenieros prefieren `find | cpio -p` en lugar de `cp -a` porque cpio maneja de manera impecable los "archivos dispersos" (sparse files), los nodos de dispositivos (`/dev`) y las tuberías con nombre (FIFOs) de bases de datos.

---

### 🔥 Tu Reto de SysAdmin con `cpio`

El servidor web ha sido atacado y quieres hacer un respaldo forense **únicamente** de los archivos que han sido modificados en las **últimas 24 horas** dentro de `laboratorio02/var/www/html/` y `laboratorio02/etc/apache2/`.

**Misión:**
1.  Usa `find` para buscar archivos en ambas rutas (`find ruta1 ruta2 ...`) que hayan sido modificados hace menos de 1 día (`-mtime -1`).
2.  Usa el pipe (`|`) para pasar esa lista a `cpio`.
3.  Crea un archivo llamado `evidencia_forense.cpio` usando el formato ASCII portable.

**¿Qué comando usarías para capturar esta evidencia quirúrgica de forma impecable?**

*(Pista: El comando `find` acepta múltiples rutas separadas por espacios antes de aplicar los filtros de tiempo).*
