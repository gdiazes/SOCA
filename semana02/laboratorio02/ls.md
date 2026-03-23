### Nivel 1: El Junior (Visualización Básica)

El error de novato es usar solo `ls`. En servidores, necesitas detalles.

**1. El estándar de oro: `ls -l` (Long format)**
```bash
ls -l laboratorio02/etc/apache2/
```
*   **Qué hace:** Muestra permisos (`-rw-r--r--`), dueño (`root`), grupo (`root`), tamaño en bytes, fecha de modificación y nombre del archivo (`apache2.conf`).
*   **Uso real:** Verificar si Apache tiene permisos para leer su propio archivo de configuración.

**2. Formato humano: `ls -lh` (Human-readable)**
```bash
ls -lh laboratorio02/var/lib/mysql/
```
*   **Qué hace:** Agrega la `h`. En lugar de mostrar que `ibdata1` pesa `12582912` bytes, te dirá `12M`.
*   **Uso real:** Indispensable cuando revisas bases de datos o logs pesados.

---

### Nivel 2: El Administrador Intermedio (Troubleshooting)

Aquí es donde `ls` se convierte en una herramienta para apagar incendios.

**3. "Alguien rompió el servidor hace 5 minutos": `ls -lt` (Time sort)**
```bash
ls -lt laboratorio02/etc/
```
*   **Qué hace:** Ordena los archivos por **fecha de modificación**, los más recientes arriba.
*   **Uso real:** Falla el servidor de correos (Exim4) o el DNS. Entras a `/etc` y ejecutas esto para ver qué archivo de configuración modificó tu compañero por error hace unos instantes.

**4. El favorito del SysAdmin: `ls -ltr` (Time sort reversed)**
```bash
ls -ltr laboratorio02/var/log/
```
*   **Qué hace:** Igual que el anterior, pero la `r` (reverse) pone los más recientes **al final** (junto al prompt de tu terminal).
*   **Uso real:** Cuando tienes 500 logs, no quieres hacer *scroll* hacia arriba. Quieres ver el log modificado hace 1 segundo justo donde vas a escribir tu próximo comando.

**5. "El disco está al 100%": `ls -lSh` (Size sort)**
```bash
ls -lSh laboratorio02/var/log/
```
*   **Qué hace:** Ordena por **tamaño de mayor a menor** (`S` mayúscula).
*   **Uso real:** Te salta la alarma de disco lleno. Ejecutas esto en `/var/log` para descubrir inmediatamente si el `access.log` de Apache o el `mainlog` de Exim4 se comió el disco.

---

### Nivel 3: El SysAdmin Senior (Auditoría Rápida)

A este nivel, la velocidad mental lo es todo.

**6. Escaneo visual rápido: `ls -F` (Classify)**
```bash
ls -F laboratorio02/var/
```
*   **Qué hace:** Añade un símbolo al final de cada nombre: `/` para carpetas, `*` para ejecutables, `@` para enlaces simbólicos.
*   **Uso real:** Diferenciar instantáneamente carpetas de archivos sin tener que leer todo el bloque de texto del `ls -l`. (Ej: verás `backups/`, `lib/`, `log/`).

**7. El mapa completo: `ls -R` (Recursive)**
```bash
ls -R laboratorio02/var/lib/
```
*   **Qué hace:** Entra automáticamente en todas las subcarpetas y lista su contenido.
*   **Uso real:** Cuando el comando `tree` no está instalado (muy común en servidores de producción minimalistas), esta es la única forma nativa de ver el árbol de archivos.

**8. Auditoría de seguridad: `ls -la` (All)**
```bash
ls -la laboratorio02/var/www/html/ 
# (Supongamos que existe esta ruta web)
```
*   **Qué hace:** La `a` muestra archivos ocultos (los que empiezan por punto `.`).
*   **Uso real:** Buscar archivos `.htaccess` mal configurados, claves `.ssh` perdidas, o backdoors (los hackers adoran esconder malware llamándolo `.hidden_script`).

---

### Nivel 4: El "Gurú" del Sistema (Bajo Nivel y Scripting)

**9. "No hay espacio, pero el disco está vacío": `ls -li` (Inodes)**
```bash
ls -li laboratorio02/var/lib/mysql/
```
*   **Qué hace:** La `i` muestra el **número de inodo** (el identificador real del archivo en el hardware del disco).
*   **Uso real:** A veces el disco tiene espacio, pero te quedas sin "inodos" (no puedes crear más archivos). O para saber si dos archivos son en realidad el mismo (Hard Links) porque comparten el mismo número de inodo.

**10. Automatización Pura: `ls -1` (Formato de una columna)**
```bash
ls -1 laboratorio02/etc/cron.d/
```
*   **Qué hace:** Lista los archivos en una sola columna limpia, sin detalles, sin colores, solo el nombre exacto (`db_backup`, `log_backup`). (Atención: es un número uno `1`, no una L minúscula).
*   **Uso real:** ¡Scripts de Bash! Si quieres hacer un bucle que lea cada archivo de Cron, necesitas que la salida sea perfectamente limpia para que la terminal la procese, sin la basura visual de fechas o tamaños.

¿Qué comando de la lista usarías para **ver todos los archivos (incluidos los ocultos), con tamaño legible, y ordenados para que el más reciente (o el más pesado) aparezca de último**? 

*(Pista: Puedes combinar varias letras de los niveles anteriores: Ej: `ls -l... laboratorio02/etc/bind/`)*.
