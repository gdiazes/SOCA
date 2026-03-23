El comando **`tar` (Tape Archive)** es el rey indiscutible de los respaldos en Linux. Su nombre viene de la época en que los datos se guardaban en cintas magnéticas (Tapes). A diferencia de los `.zip` de Windows, `tar` fue diseñado para **preservar absolutamente todos los permisos, dueños y enlaces simbólicos** de los archivos, lo que lo hace obligatorio para cualquier SysAdmin.

Aquí tienes la guía de **`tar`** para tu **`laboratorio02`**, desde empaquetados básicos hasta migraciones de servidores en caliente.

---

### Preparación del Escenario
Antes de empezar, vamos a crear unas carpetas de destino para nuestros ejercicios:
```bash
mkdir -p laboratorio02/var/backups/{archivos,restauracion,clon_exacto}
```

---

### Nivel 1: El Junior (Empaquetar y Extraer)

La regla de oro de `tar` es recordar sus 3 banderas principales: **`-c`** (Create/Crear), **`-x`** (eXtract/Extraer) y **`-f`** (File/Archivo de destino). Siempre se acompañan de **`-v`** (Verbose) para ver qué pasa.

**1. Crear un archivo TAR (Sin comprimir):**
```bash
tar -cvf laboratorio02/var/backups/archivos/etc_backup.tar laboratorio02/etc/
```
*   **Qué hace:** Junta toda la carpeta `/etc` en un solo archivo `.tar`. **No reduce el tamaño**, solo empaqueta.
*   **Uso real:** Mover miles de archivos pequeños de un servidor a otro. Transferir un solo archivo de 1GB por red es muchísimo más rápido que transferir 10,000 archivos de 100KB.

**2. Extraer un TAR en una ruta específica (`-C`):**
```bash
tar -xvf laboratorio02/var/backups/archivos/etc_backup.tar -C laboratorio02/var/backups/restauracion/
```
*   **Qué hace:** Desempaqueta el contenido dentro de la carpeta `restauracion/` usando la bandera `-C` (Change directory).
*   **Uso real:** Restaurar un backup en una carpeta temporal para revisar un archivo de configuración sin sobrescribir el de producción.

---

### Nivel 2: El Administrador Intermedio (Compresión y Auditoría)

Un TAR normal pesa lo mismo que los archivos originales. Para ahorrar disco, le inyectamos algoritmos de compresión usando **`-z`** (gzip) o **`-j`** (bzip2).

**3. Crear un "Tarball" comprimido (`-z`):**
```bash
tar -czvf laboratorio02/var/backups/archivos/logs_backup.tar.gz laboratorio02/var/log/
```
*   **Qué hace:** Empaqueta y comprime simultáneamente usando `gzip`. El archivo resultante es un `.tar.gz` (o `.tgz`).
*   **Uso real:** Respaldos diarios de logs o bases de datos. Gzip es el estándar de la industria porque ofrece el mejor equilibrio entre velocidad y tamaño.

**4. Ver el contenido sin extraer (`-t` de list):**
```bash
tar -tvf laboratorio02/var/backups/archivos/logs_backup.tar.gz
```
*   **Qué hace:** Muestra la lista de todo lo que hay dentro del archivo comprimido, incluyendo sus permisos originales.
*   **Uso real:** **Auditoría de backups**. Antes de restaurar un archivo que pisará tu servidor de producción, verificas si el backup realmente contiene lo que necesitas.

---

### Nivel 3: El SysAdmin Senior (Cirugía de Precisión)

**5. Excluir basura del backup (`--exclude`):**
```bash
tar -czvf laboratorio02/var/backups/archivos/web_backup.tar.gz --exclude="*.log" --exclude="cache" laboratorio02/var/www/html/
```
*   **Qué hace:** Respalda toda la carpeta web, **excepto** los archivos que terminen en `.log` y cualquier carpeta llamada `cache`.
*   **Uso real:** Optimización extrema de respaldos. No quieres que tu backup de la web pese 50GB solo porque el sistema incluyó los archivos temporales de sesión o cachés que no sirven para nada.

**6. Extraer un solo archivo del pajar:**
Imagina que solo necesitas el `index.php`, no todo el backup web.
```bash
# Primero vemos la ruta exacta dentro del tar:
tar -tvf laboratorio02/var/backups/archivos/web_backup.tar.gz | grep index.php

# Luego extraemos solo esa ruta:
tar -xzvf laboratorio02/var/backups/archivos/web_backup.tar.gz laboratorio02/var/www/html/index.php -C laboratorio02/var/backups/restauracion/
```
*   **Uso real:** Restauraciones de emergencia. Un desarrollador borró un archivo crítico y necesita la versión de ayer al instante. No vas a descomprimir 100GB enteros para sacar un archivo de 2KB.

---

### Nivel 4: El "Gurú" del Sistema (Pipes y Migraciones)

**7. El clonado exacto al vuelo (Tar Pipe):**
A veces `cp -a` no es suficiente o es muy lento. Los Gurús usan `tar` para clonar directorios complejos pasándolos a través de un "tubo" (`|`) de la memoria RAM, sin crear un archivo físico de por medio.
```bash
tar -cf - laboratorio02/etc | (cd laboratorio02/var/backups/clon_exacto && tar -xvf -)
```
*   **Qué hace:** El primer `tar` empaqueta `/etc` y lo manda a la salida estándar (`-`). El tubo (`|`) lo atrapa, viaja a la carpeta destino, y el segundo `tar` lo desempaqueta desde la entrada estándar (`-`).
*   **Uso real:** **Migraciones de discos**. Es la forma más rápida y segura de mover todo el sistema operativo de un disco duro a otro preservando absolutamente cada bit de metadatos, enlaces duros y permisos especiales.

---

### 🔥 Tu Reto de SysAdmin con `tar`

El servidor de bases de datos ha sufrido una corrupción. Afortunadamente, tienes un backup de todo el directorio `/var/lib/mysql` comprimido.

**Misión:**
1.  Supón que ya creaste el backup completo así: 
    `tar -czf laboratorio02/var/backups/archivos/db_full.tar.gz laboratorio02/var/lib/mysql/`
2.  El motor de la base de datos funciona, el único archivo que se corrompió fue el de la tabla de usuarios: `empresa_db/users.ibd`.
3.  No tienes espacio en el disco para extraer el backup completo de 50GB.

**¿Qué comando exacto usarías para buscar y extraer ÚNICAMENTE el archivo `users.ibd` directamente en la ruta `laboratorio02/var/lib/mysql/empresa_db/` (o en una carpeta temporal) sin extraer el resto del `.tar.gz`?**

*(Pista: Revisa el comando del Nivel 3. Necesitarás especificar la ruta exacta del archivo tal como se guardó dentro del tar).*
