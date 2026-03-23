El comando **`find`** es la herramienta de búsqueda definitiva. Mientras que `ls` es para mirar, `find` es para **auditar y actuar**. En un servidor con miles de archivos, es tu única forma de encontrar "agujas en un pajar".

Aquí tienes la guía de `find` aplicada a tu `laboratorio02`, estructurada por niveles de experiencia:

---

### Nivel 1: El Junior (Búsqueda por Identidad)

**1. Búsqueda por nombre exacto (`-name`):**
```bash
find laboratorio02/etc -name "apache2.conf"
```
*   **Qué hace:** Rastrea recursivamente la carpeta `/etc` buscando el archivo con ese nombre exacto.
*   **Uso real:** Localizar rápidamente dónde está el archivo de configuración de un servicio cuando no conoces la ruta exacta de la distribución.

**2. Búsqueda insensible a mayúsculas (`-iname`):**
```bash
find laboratorio02 -iname "MYSQL*"
```
*   **Qué hace:** Busca archivos que empiecen por "mysql", "MySQL" o "MYSQL".
*   **Uso real:** Útil cuando trabajas en entornos mixtos o con desarrolladores que no siguen una convención de nombres estricta.

---

### Nivel 2: El Administrador Intermedio (Filtros de Sistema)

**3. Filtrar por tipo de objeto (`-type`):**
```bash
find laboratorio02/var/log -type d
```
*   **Qué hace:** Muestra únicamente los **directorios** (`d`). Usa `-type f` para archivos normales.
*   **Uso real:** Generar una lista de carpetas de logs para aplicar cambios de permisos masivos sin afectar a los archivos internos.

**4. El "Limpiador" por tiempo de modificación (`-mtime`):**
```bash
find laboratorio02/var/log -name "*.log" -mtime +30
```
*   **Qué hace:** Busca archivos `.log` que no hayan sido modificados en los últimos 30 días.
*   **Uso real:** Identificar logs antiguos que están ocupando espacio innecesario y que ya pueden ser comprimidos o eliminados.

---

### Nivel 3: El SysAdmin Senior (Auditoría de Recursos)

**5. Cacería de archivos pesados (`-size`):**
```bash
find laboratorio02 -size +5M
```
*   **Qué hace:** Busca cualquier archivo que pese más de 5 Megabytes en todo el laboratorio.
*   **Uso real:** Diagnóstico de emergencia ante una alerta de **"Disco Lleno"**. Te permite encontrar en segundos al culpable (usualmente un log descontrolado o un backup olvidado).

**6. Auditoría de Seguridad por permisos (`-perm`):**
```bash
find laboratorio02/var/www/html -perm 777
```
*   **Qué hace:** Localiza archivos con permisos de lectura/escritura/ejecución para **todo el mundo**.
*   **Uso real:** **Escaneo de vulnerabilidades**. En un entorno web, un archivo 777 es una puerta abierta para que un hacker suba un script malicioso. Deberías encontrar `index.php`.

---

### Nivel 4: El "Gurú" del Sistema (Automatización y Estado)

**7. Ejecución de comandos encadenados (`-exec`):**
```bash
find laboratorio02/var/log -name "*.log" -size +1M -exec ls -lh {} \;
```
*   **Qué hace:** Busca archivos `.log` mayores a 1MB y, por cada uno que encuentra, ejecuta el comando `ls -lh`.
*   **Uso real:** No solo buscas, sino que obtienes un reporte detallado al instante. `{}` representa el archivo encontrado y `\;` cierra el comando ejecutado.

**8. Detección de Enlaces Rotos (`-xtype l`):**
```bash
find laboratorio02 -xtype l
```
*   **Qué hace:** Encuentra enlaces simbólicos (accesos directos) cuyo archivo original ha sido borrado o movido.
*   **Uso real:** Mantenimiento de integridad. Después de mover una base de datos o una carpeta de configuración, usas esto para saber qué accesos directos de los usuarios se han roto.

---

### 🔥 Tu Reto Final de SysAdmin con `find`

El servidor está lento y sospechas que hay archivos de sesión temporales muy viejos en la carpeta de logs de Apache.

**Misión:** Encuentra todos los **archivos** (`-type f`) dentro de `laboratorio02/var/log/apache2/` que tengan **más de 7 días** de antigüedad y que pesen **menos de 1k**.

**¿Qué comando usarías para ver la lista detallada de esos archivos antes de borrarlos?**

*(Pista: Combina `-type f`, `-mtime +7`, `-size -1k` y `-exec ls -l {} \;`)*.
