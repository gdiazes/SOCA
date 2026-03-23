El comando **`gzip` (GNU zip)** es el estándar absoluto de compresión en el ecosistema Linux. A diferencia de `tar` (que empaqueta muchos archivos en uno solo), `gzip` fue diseñado para **comprimir archivos individuales** y reemplazar el archivo original por su versión `.gz`.

Para un SysAdmin, `gzip` no es solo para ahorrar espacio; es la herramienta que permite rotar logs, transferir bases de datos masivas por red y optimizar servidores web (comprimiendo HTML/CSS al vuelo).

Aquí tienes la guía de **`gzip`** para tu **`laboratorio02`**:

---

### Preparación del Escenario
Vamos a generar archivos pesados reales para que `gzip` tenga algo que comprimir y puedas medir su impacto.

```bash
mkdir -p laboratorio02/var/backups/gzip_test

# 1. Archivo gigante de texto (simulando un log de Apache)
# Usamos 'seq' para escribir 500,000 líneas rápidamente
seq 1 500000 > laboratorio02/var/backups/gzip_test/access_masivo.log

# 2. Archivo de Base de Datos (simulando un volcado SQL)
echo "INSERT INTO users VALUES (1, 'admin');" > laboratorio02/var/backups/gzip_test/backup_db.sql
# Lo hacemos crecer copiándolo sobre sí mismo varias veces
for i in {1..10}; do cat laboratorio02/var/backups/gzip_test/backup_db.sql >> laboratorio02/var/backups/gzip_test/backup_db_temp.sql; mv laboratorio02/var/backups/gzip_test/backup_db_temp.sql laboratorio02/var/backups/gzip_test/backup_db.sql; done

# 3. Un archivo binario (simulando un ejecutable o imagen)
dd if=/dev/urandom of=laboratorio02/var/backups/gzip_test/datos_aleatorios.bin bs=1M count=2 2>/dev/null

echo "Archivos listos. ¡Mira sus tamaños originales con 'ls -lh'!"
ls -lh laboratorio02/var/backups/gzip_test/
```

---

### Nivel 1: El Junior (Compresión Básica)

La regla fundamental de `gzip`: **destruye el archivo original** y lo reemplaza por el `.gz`.

**1. Comprimir un archivo:**
```bash
gzip laboratorio02/var/backups/gzip_test/access_masivo.log
```
*   **Qué hace:** Comprime el log y crea `access_masivo.log.gz`. El archivo `.log` desaparece del disco.
*   **Uso real:** Rotación manual de logs. Cuando un log llega a 1GB, lo comprimes en segundos para liberar espacio crítico.

**2. Comprimir múltiples archivos:**
```bash
gzip laboratorio02/var/backups/gzip_test/*.sql
```
*   **Qué hace:** Comprime todos los archivos SQL de la carpeta, creando un `.gz` **por cada archivo** de forma independiente.
*   **Uso real:** Respaldar rápidamente todos los volcados de bases de datos de un directorio al final del día.

---

### Nivel 2: El Administrador Intermedio (Control Total)

A veces no quieres que `gzip` borre tu archivo original (por ejemplo, si la base de datos sigue en uso).

**3. Mantener el archivo original (`-k` de keep):**
```bash
# Primero descomprimimos el log para la prueba
gunzip laboratorio02/var/backups/gzip_test/access_masivo.log.gz

# Ahora lo comprimimos pero MANTENEMOS el original
gzip -k laboratorio02/var/backups/gzip_test/access_masivo.log
```
*   **Qué hace:** Crea el `.gz` pero deja el `.log` intacto.
*   **Uso real:** Comprimir un archivo de configuración crítico para enviarlo por correo o SCP, sin alterar el archivo que el servidor está leyendo en ese momento.

**4. Ver estadísticas de compresión (`-v` de verbose):**
```bash
gzip -vk laboratorio02/var/backups/gzip_test/backup_db.sql
```
*   **Qué hace:** Te muestra en pantalla el porcentaje exacto de espacio que ahorraste (ej. `98.5%`).
*   **Uso real:** Auditar la eficiencia de tus backups. El texto plano (logs, SQL) se comprime un 90%+, pero los binarios (imágenes, videos) apenas se comprimen. Esto te ayuda a decidir si vale la pena gastar CPU en comprimir ciertas carpetas.

---

### Nivel 3: El SysAdmin Senior (Fuerza Bruta vs Velocidad)

`gzip` te permite elegir entre ser rápido (nivel 1) o comprimir al máximo (nivel 9). El valor por defecto es 6.

**5. Compresión Ultra Rápida (`-1`):**
```bash
gzip -1 -c laboratorio02/var/backups/gzip_test/access_masivo.log > laboratorio02/var/backups/gzip_test/rapido.log.gz
```
*   **Qué hace:** El `-1` prioriza la velocidad de la CPU sobre el tamaño del archivo. El `-c` envía el resultado a la salida estándar para guardarlo en otro archivo.
*   **Uso real:** Servidores con mucha carga de CPU. Si estás volcando una base de datos de 500GB en vivo, no quieres que `gzip` sature los procesadores del servidor durante horas. Usas `-1` para comprimir "lo justo y necesario" a máxima velocidad.

**6. Compresión Máxima (`-9` o `--best`):**
```bash
gzip -9 -c laboratorio02/var/backups/gzip_test/access_masivo.log > laboratorio02/var/backups/gzip_test/mejor.log.gz
```
*   **Qué hace:** Usa la máxima capacidad de cálculo para reducir el archivo al tamaño más pequeño posible (tarda más tiempo).
*   **Uso real:** **Almacenamiento a largo plazo (Cold Storage)**. Archivos que se van a guardar en Amazon S3 Glacier o cintas magnéticas donde cada megabyte cuesta dinero y la velocidad de creación no importa.

---

### Nivel 4: El "Gurú" del Sistema (Pipes y Búsquedas en Caliente)

Los Gurús rara vez usan `gzip` solo. Lo usan como filtro.

**7. Comprimir al vuelo desde otro comando (Tar Pipe):**
En lugar de crear un volcado SQL de 50GB en el disco y luego comprimirlo (lo que requeriría 50GB de espacio libre), lo comprimes **en la RAM** antes de tocar el disco.
```bash
# Simulamos un comando que escupe texto (como mysqldump)
cat laboratorio02/var/backups/gzip_test/access_masivo.log | gzip -9 > laboratorio02/var/backups/gzip_test/volcado_directo.sql.gz
```
*   **Qué hace:** La salida del primer comando no toca el disco; entra a `gzip` por el pipe (`|`) y sale comprimida.
*   **Uso real:** Backups de bases de datos sin llenar el disco del servidor.

**8. Buscar dentro de un archivo comprimido (`zgrep` y `zcat`):**
Imagina que necesitas buscar un error en un log que rotaste hace un año y está comprimido. No necesitas descomprimirlo.
```bash
zgrep "50000" laboratorio02/var/backups/gzip_test/mejor.log.gz
```
*   **Qué hace:** `zgrep` descomprime el archivo en la memoria RAM, busca el patrón "50000" y te muestra la línea. El archivo original en disco sigue comprimido.
*   **Uso real:** **Auditoría Forense**. Buscar IPs de atacantes o errores críticos en terabytes de logs históricos sin gastar un solo byte de espacio en disco temporal.

---

### 🔥 Tu Reto de SysAdmin con `gzip`

Un desarrollador subió un archivo binario llamado `datos_aleatorios.bin` a tu servidor. Te pide que lo comprimas con la **máxima potencia** posible (`-9`) para ahorrar espacio, pero quiere que el comando le avise **cuánto porcentaje de espacio se ahorró** (`-v`).

Además, tú como SysAdmin sospechas que comprimir archivos binarios (como imágenes o datos aleatorios) es una pérdida de CPU porque no reducen su tamaño.

**Misión:**
1.  Usa `gzip` para comprimir `laboratorio02/var/backups/gzip_test/datos_aleatorios.bin`.
2.  Aplica la máxima compresión.
3.  Activa el modo de reporte para ver el porcentaje.
4.  Mantén el archivo original intacto (por si acaso).

**¿Qué comando usarías para demostrarle al desarrollador que comprimir ese archivo binario apenas ahorra un 0.0% de espacio?**
