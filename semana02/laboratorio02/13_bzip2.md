El comando **`bzip2`** es el "hermano mayor y musculoso" de `gzip`. Mientras que `gzip` prioriza la velocidad (ideal para comprimir logs al vuelo), `bzip2` sacrifica velocidad de CPU a cambio de **tasas de compresión muchísimo más altas** (usando el algoritmo de ordenación de bloques de Burrows-Wheeler).

Para un SysAdmin, `bzip2` es la herramienta elegida cuando se trata de **Cold Storage** (almacenamiento a largo plazo), transferencias por redes muy lentas, o backups masivos de bases de datos que no necesitan ser restaurados inmediatamente.

Aquí tienes la guía de **`bzip2`** para tu **`laboratorio02`**, desde la compresión implacable hasta la recuperación de archivos dañados.

---

### Preparación del Escenario
Vamos a generar archivos que `bzip2` adore comprimir (texto repetitivo, como logs o volcados SQL) para que veas su verdadera fuerza.

```bash
mkdir -p laboratorio02/var/backups/bzip2_test

# 1. Creamos un volcado de base de datos enorme (simulado)
echo "INSERT INTO logs (fecha, ip, mensaje) VALUES ('2023-10-27', '192.168.1.100', 'Acceso denegado');" > laboratorio02/var/backups/bzip2_test/auditoria_db.sql
# Lo multiplicamos para que tenga peso real (magia de bash)
for i in {1..14}; do cat laboratorio02/var/backups/bzip2_test/auditoria_db.sql >> laboratorio02/var/backups/bzip2_test/auditoria_db_temp.sql; mv laboratorio02/var/backups/bzip2_test/auditoria_db_temp.sql laboratorio02/var/backups/bzip2_test/auditoria_db.sql; done

# 2. Creamos un archivo de configuración crítico
echo "max_connections = 1000" > laboratorio02/var/backups/bzip2_test/mysql_tune.cnf

# 3. Creamos un log viejo
dd if=/dev/zero of=laboratorio02/var/backups/bzip2_test/auth.log.old bs=1M count=10 2>/dev/null

echo "Archivos listos. ¡Mira sus tamaños originales con 'ls -lh'!"
ls -lh laboratorio02/var/backups/bzip2_test/
```

---

### Nivel 1: El Junior (Compresión de Fuerza Bruta)

Al igual que `gzip`, el comportamiento por defecto de `bzip2` es **comprimir el archivo y eliminar el original**, añadiendo la extensión `.bz2`.

**1. Comprimir un archivo:**
```bash
bzip2 laboratorio02/var/backups/bzip2_test/auth.log.old
```
*   **Qué hace:** Crea `auth.log.old.bz2` y borra el archivo de 10MB original. Si miras el tamaño ahora, verás que `bzip2` redujo 10MB de ceros a unos pocos *bytes*. ¡Esa es su magia!
*   **Uso real:** Archivar logs del año pasado que por ley debes conservar, pero que probablemente nunca volverás a abrir.

**2. Descomprimir un archivo (`-d` de decompress o `bunzip2`):**
```bash
bzip2 -d laboratorio02/var/backups/bzip2_test/auth.log.old.bz2
# O también puedes usar: bunzip2 laboratorio02/var/backups/bzip2_test/auth.log.old.bz2
```
*   **Qué hace:** Restaura el archivo original y borra el `.bz2`.
*   **Uso real:** Necesitas enviar el log al auditor de seguridad. Lo descomprimes temporalmente.

---

### Nivel 2: El Administrador Intermedio (Control y Auditoría)

**3. Mantener el archivo original (`-k` de keep):**
```bash
bzip2 -k laboratorio02/var/backups/bzip2_test/mysql_tune.cnf
```
*   **Qué hace:** Comprime el archivo de configuración, pero **no lo borra**.
*   **Uso real:** Quieres enviar por correo tu configuración de MySQL optimizada a otro servidor, pero obviamente no quieres que el servicio de MySQL local se caiga porque el archivo de configuración desapareció.

**4. Ver el porcentaje de compresión (`-v` de verbose):**
```bash
bzip2 -vk laboratorio02/var/backups/bzip2_test/auditoria_db.sql
```
*   **Qué hace:** Mientras comprime (y mantiene el original con `-k`), te muestra estadísticas detalladas: el tamaño de entrada, el de salida, y el ratio (ej. `2.503:1, 3.196 bits/byte, 60.05% saved`).
*   **Uso real:** **Planificación de Backups Mensuales**. Si el reporte dice que ahorraste un 85% de espacio en la base de datos de auditoría, sabes que puedes guardar 5 años de historia en un disco pequeño.

---

### Nivel 3: El SysAdmin Senior (Optimización de Bloques)

`bzip2` no usa niveles de 1 a 9 como "esfuerzo" genérico; usa niveles del 1 al 9 para definir el **tamaño del bloque de memoria** que usará para comprimir (de 100k a 900k).

**5. Compresión Rápida (Menos RAM) (`-1`):**
```bash
bzip2 -1 -k -f laboratorio02/var/backups/bzip2_test/auditoria_db.sql
```
*   **Qué hace:** Usa bloques de 100KB. Comprime más rápido y usa muy poca memoria RAM, pero el archivo final será ligeramente más grande. (`-f` fuerza sobrescribir si ya existe el `.bz2`).
*   **Uso real:** Servidores con poca RAM (ej. VPS de 512MB) que necesitan hacer un backup pesado sin colapsar el sistema por falta de memoria (OOM Killer).

**6. Compresión Extrema (Más RAM) (`-9` o por defecto):**
```bash
bzip2 -9 -k -f laboratorio02/var/backups/bzip2_test/auditoria_db.sql
```
*   **Qué hace:** Usa bloques de 900KB. Es el método más lento, pero garantiza el archivo más minúsculo posible.
*   **Uso real:** **Transferencias por Satélite o Redes 3G**. Si estás administrando servidores en zonas remotas, cada KB transferido cuesta dinero o tiempo. Usas `-9` para que la subida del backup a la nube tarde horas en lugar de días.

---

### Nivel 4: El "Gurú" del Sistema (Resiliencia de Datos)

El verdadero superpoder oculto de `bzip2` es su robustez. Si un archivo `.gz` o `.zip` se corrompe a la mitad por un fallo de disco, pierdes **todo** el archivo. Si un `.bz2` se corrompe, `bzip2` puede recuperar los datos de los bloques que no sufrieron daños.

**7. Recuperar un archivo BZIP2 dañado (`bzip2recover`):**
Imagina que un sector defectuoso del disco dañó tu backup crítico de 50GB.
```bash
# Comando de concepto (no ejecutable en el lab sin corromper intencionalmente a nivel hexadecimal):
# bzip2recover /mnt/discos_rotos/backup_critico.sql.bz2
```
*   **Qué hace:** `bzip2recover` escanea todo el archivo corrupto buscando los "bloques mágicos" que sobrevivieron, y extrae cada bloque sano en un archivo `.bz2` individual (`rec00001backup.bz2`, `rec00002...`).
*   **Uso real:** **Rescate de Desastres**. Luego de usar la herramienta, el SysAdmin usa un script para descomprimir y unir todos los bloques rescatados, recuperando el 95% de la base de datos de un disco que estaba a punto de morir.

**8. Leer un archivo BZ2 al vuelo (`bzcat` o `bzless`):**
```bash
bzcat laboratorio02/var/backups/bzip2_test/mysql_tune.cnf.bz2
```
*   **Qué hace:** Descomprime el archivo directo a la pantalla sin escribir nada en el disco.
*   **Uso real:** Revisar configuraciones de servidores antiguos archivados sin tener que llenar el disco descomprimiendo todo el tarball de configuraciones.

---

### 🔥 Tu Reto de SysAdmin con `bzip2`

El servidor está al límite de disco y necesitas archivar urgentemente el log gigante de auditoría (`auditoria_db.sql`). Sin embargo, el servidor también está bajo un ataque DDoS, por lo que la CPU y la RAM están saturadas al 99%. Si usas la compresión máxima (`-9`), el servidor se colgará por completo. Además, no quieres arriesgarte a que `bzip2` borre el archivo original hasta que no estés seguro de que el `.bz2` se creó correctamente.

**Misión:**
1.  Usa `bzip2` sobre `laboratorio02/var/backups/bzip2_test/auditoria_db.sql`.
2.  Configura la compresión para que use la **menor cantidad de memoria RAM posible** (la compresión más "ligera").
3.  Asegúrate de que el comando **conserve el archivo original** (no lo borre).
4.  Activa el reporte para ver qué porcentaje lograste comprimir bajo esas condiciones limitadas.

**¿Qué comando de 3 banderas combinadas usarías para realizar este salvamento crítico de disco sin tumbar el servidor?**
