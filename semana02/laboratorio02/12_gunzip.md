El comando **`gunzip`** (GNU Unzip) es la otra cara de la moneda de `gzip`. Mientras que `gzip` comprime y oculta, `gunzip` expande y revela. En el día a día de un SysAdmin, pasarás mucho más tiempo extrayendo archivos (para restaurar bases de datos, analizar logs viejos o instalar software compilado) que comprimiéndolos.

Aquí tienes la guía de **`gunzip`** para tu **`laboratorio02`**, desde la extracción más simple hasta la recuperación de servidores caídos.

---

### Preparación del Escenario
Necesitamos archivos comprimidos con diferentes características para que `gunzip` pueda trabajar. Ejecuta este bloque para generar el material de pruebas:

```bash
mkdir -p laboratorio02/var/backups/gunzip_test

# 1. Un log rotado normal (como los que genera logrotate)
echo "Error de conexión a las 03:00 AM" > laboratorio02/var/backups/gunzip_test/syslog.1
gzip laboratorio02/var/backups/gunzip_test/syslog.1

# 2. Un volcado de base de datos crítico
echo "CREATE TABLE usuarios (id INT);" > laboratorio02/var/backups/gunzip_test/db_clientes.sql
gzip laboratorio02/var/backups/gunzip_test/db_clientes.sql

# 3. Un archivo de configuración que no queremos borrar al descomprimir
echo "PermitRootLogin no" > laboratorio02/var/backups/gunzip_test/sshd_config.bak
gzip laboratorio02/var/backups/gunzip_test/sshd_config.bak

# 4. Un archivo corrupto (simulando una descarga fallida)
echo "Esto no es un archivo gzip" > laboratorio02/var/backups/gunzip_test/archivo_falso.gz

echo "Archivos comprimidos listos. Verifica con: ls -l laboratorio02/var/backups/gunzip_test/"
```

---

### Nivel 1: El Junior (Extracción Directa)

La regla básica de `gunzip` es idéntica a la de `gzip`: **descomprime el archivo y elimina la versión `.gz` original**.

**1. Descomprimir un archivo simple:**
```bash
gunzip laboratorio02/var/backups/gunzip_test/syslog.1.gz
```
*   **Qué hace:** Extrae el contenido, crea el archivo `syslog.1` original y borra el `.gz`.
*   **Uso real:** Quieres abrir un log de ayer con `nano` o `vim` para leerlo cómodamente.

**2. Descomprimir múltiples archivos a la vez:**
```bash
# Primero volvemos a comprimir el log para la prueba
gzip laboratorio02/var/backups/gunzip_test/syslog.1

# Ahora descomprimimos todo lo que termine en .gz en esa carpeta
gunzip laboratorio02/var/backups/gunzip_test/*.gz
```
*   **Qué hace:** Extrae todos los archivos de golpe.
*   **Uso real:** Restaurar una carpeta completa de backups (ej. 30 días de logs diarios) para hacer un análisis estadístico global.
*   *Nota: Si ejecutas esto, el archivo corrupto (`archivo_falso.gz`) lanzará un error advirtiendo que no está en formato gzip, pero los demás se extraerán correctamente.*

---

### Nivel 2: El Administrador Intermedio (Extracción Segura)

A menudo, los archivos `.gz` son tu única copia de seguridad. ¡No quieres que `gunzip` los borre al extraerlos!

**3. Mantener el archivo comprimido original (`-k` de keep):**
```bash
# Volvemos a comprimir la base de datos
gzip laboratorio02/var/backups/gunzip_test/db_clientes.sql

# Extraemos pero conservando el backup intacto
gunzip -k laboratorio02/var/backups/gunzip_test/db_clientes.sql.gz
```
*   **Qué hace:** Extrae el `.sql`, pero el `.sql.gz` sigue ahí en el disco.
*   **Uso real:** **Protocolo de Restauración Segura**. Vas a importar un volcado de base de datos enorme. Si la importación falla a la mitad y el archivo `.sql` se corrompe, aún tienes el `.gz` original como salvavidas.

**4. Ver información sin extraer (`-l` de list):**
```bash
# Comprimimos de nuevo el archivo de configuración
gzip laboratorio02/var/backups/gunzip_test/sshd_config.bak

# Vemos cuánto pesa el archivo real por dentro
gunzip -l laboratorio02/var/backups/gunzip_test/sshd_config.bak.gz
```
*   **Qué hace:** Te muestra el tamaño comprimido, el tamaño descomprimido (uncompressed size), el ratio de compresión y el nombre original del archivo.
*   **Uso real:** **Planificación de capacidad**. Tienes un backup de base de datos de 5GB (`.gz`). Antes de extraerlo a lo ciego, usas `-l` para descubrir que descomprimido pesa 60GB. Si tu disco solo tiene 20GB libres, acabas de evitar tumbar el servidor por falta de espacio.

---

### Nivel 3: El SysAdmin Senior (Redirección y Extracción a Otra Ruta)

Por defecto, `gunzip` extrae el archivo en la misma carpeta donde está el `.gz`. Pero en producción, los backups suelen estar en un disco de red (NFS) de solo lectura, o en una ruta donde tu usuario no tiene permisos de escritura.

**5. Extraer a la salida estándar y redirigir (`-c` de stdout):**
```bash
# Extraemos el log hacia la pantalla (stdout)
gunzip -c laboratorio02/var/backups/gunzip_test/syslog.1.gz

# Extraemos el log y lo guardamos en OTRA carpeta con OTRO nombre
gunzip -c laboratorio02/var/backups/gunzip_test/syslog.1.gz > laboratorio02/tmp/log_restaurado.txt
```
*   **Qué hace:** El flag `-c` le dice a `gunzip` "no crees el archivo, escupe el texto por la pantalla". El símbolo `>` atrapa ese texto y lo guarda donde tú le digas. El `.gz` original **no se borra**.
*   **Uso real:** **Restauraciones Forenses**. Extraes un log desde una unidad de backup de solo lectura (`/mnt/backups/`) directamente a tu carpeta temporal (`/tmp/`) para analizarlo sin tocar los archivos de la empresa.

---

### Nivel 4: El "Gurú" del Sistema (Pipes de Restauración en Caliente)

Los verdaderos Gurús no guardan los archivos descomprimidos en el disco; los inyectan directamente en los servicios en tiempo real.

**6. Restaurar una base de datos al vuelo (Gunzip Pipe):**
Imagina que `db_clientes.sql.gz` pesa 100GB. No tienes 100GB libres en el disco para extraer el `.sql` antes de importarlo a MySQL.
```bash
# Comando simulado (no lo ejecutes si no tienes MySQL instalado)
# gunzip -c laboratorio02/var/backups/gunzip_test/db_clientes.sql.gz | mysql -u root -p empresa_db
```
*   **Qué hace:** `gunzip` lee el archivo comprimido, lo descomprime en la memoria RAM y se lo envía "por el tubo" (`|`) directamente al comando `mysql`.
*   **Uso real:** **Restauración de bases de datos masivas**. Ahorras horas de tiempo y cientos de gigabytes de disco al no crear el archivo `.sql` intermedio.

**7. Forzar la extracción de archivos testarudos (`-f` de force):**
```bash
# gunzip se negará a extraer si el archivo destino ya existe.
echo "Datos viejos" > laboratorio02/var/backups/gunzip_test/sshd_config.bak
gunzip -f laboratorio02/var/backups/gunzip_test/sshd_config.bak.gz
```
*   **Qué hace:** Sobrescribe el archivo de destino sin preguntar. También ignora si el archivo tiene múltiples "enlaces duros" (hard links).
*   **Uso real:** Scripts de despliegue automatizado donde estás 100% seguro de que quieres pisar la versión vieja con el backup fresco.

---

### 🔥 Tu Reto de SysAdmin con `gunzip`

Un desarrollador te pide que le restaures urgentemente un backup de código fuente llamado `codigo_fuente.tar.gz`. Sin embargo, el disco del servidor está casi lleno y tú sospechas que el archivo descomprimido podría colapsar el sistema.

**Misión:**
1.  Supón que el archivo es `laboratorio02/var/backups/gunzip_test/db_clientes.sql.gz` (usaremos este para la prueba).
2.  Antes de extraer nada, debes averiguar **exactamente cuántos bytes pesará el archivo una vez descomprimido**.
3.  El comando no debe extraer el archivo, solo darte la información.

**¿Qué comando usarías para auditar el tamaño real del backup antes de cometer el error de extraerlo a ciegas?**

*(Pista: Revisa el Nivel 2 y la bandera que te muestra una "lista" de estadísticas).*
