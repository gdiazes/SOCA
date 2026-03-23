El comando **`rmdir` (remove directory)** es el hermano "seguro" de `rm -r`. A diferencia de su pariente peligroso, `rmdir` tiene una regla de hierro: **solo borra directorios que estén completamente vacíos**. Para un SysAdmin, esto no es una limitación, sino una **medida de seguridad** para limpiar estructuras de carpetas sin riesgo de borrar datos por accidente.

Aquí tienes la guía de **`rmdir`** para tu **`laboratorio02`**, estructurada por niveles:

---

### Nivel 1: El Junior (Borrado Seguro)

**1. Borrar una carpeta vacía:**
```bash
# Primero vaciamos una carpeta para probar (ej. los logs de dhcp)
rm laboratorio02/var/log/dhcp/* 2>/dev/null
# Ahora la borramos
rmdir laboratorio02/var/log/dhcp/
```
*   **Qué hace:** Elimina la carpeta únicamente si no contiene ningún archivo o subdirectorio.
*   **Uso real:** Limpieza de carpetas temporales después de una instalación. Si el comando falla, el SysAdmin sabe inmediatamente que **quedó algo importante** dentro que debe revisar.

---

### Nivel 2: El Administrador Intermedio (Limpieza de Estructuras)

**2. Modo Verbose (`-v`):**
```bash
rmdir -v laboratorio02/var/backups/mysql/
```
*   **Qué hace:** Reporta en pantalla cada directorio que ha sido eliminado: `rmdir: removing directory, '...'`.
*   **Uso real:** Auditoría en vivo. Cuando ejecutas tareas de mantenimiento manual, el flag `-v` te da la tranquilidad visual de que la carpeta desapareció del sistema.

**3. Ignorar errores por carpetas no vacías:**
```bash
rmdir --ignore-fail-on-non-empty laboratorio02/var/log/apache2/
```
*   **Qué hace:** Si la carpeta tiene archivos (como `access.log`), el comando no la borrará, pero tampoco lanzará un mensaje de error que detenga la ejecución de un script.
*   **Uso real:** **Uso en Scripts de Bash**. Permite intentar limpiar directorios al final de un proceso sin que el script se "rompa" si el usuario dejó algún archivo guardado.

---

### Nivel 3: El SysAdmin Senior (Borrado en Cascada)

**4. Borrado recursivo de padres (`-p` de parents):**
```bash
# Imagina esta ruta profunda y vacía:
mkdir -p laboratorio02/tmp/a/b/c
# Borramos toda la cadena de un solo golpe:
rmdir -p laboratorio02/tmp/a/b/c
```
*   **Qué hace:** Borra `c`. Si al borrar `c`, la carpeta `b` queda vacía, también la borra, y así sucesivamente hacia atrás por toda la ruta especificada.
*   **Uso real:** Limpieza de rutas de despliegue. Tras mover una aplicación de una ruta profunda, usas `-p` para no dejar "carpetas fantasma" vacías en el servidor.

---

### Nivel 4: El "Gurú" del Sistema (Auditoría de Residuos)

**5. Combinación de Potencia y Seguridad (`-pv`):**
```bash
rmdir -pv laboratorio02/etc/nginx/sites-enabled/
```
*   **Qué hace:** Intenta borrar la ruta completa hacia atrás y te va informando paso a paso qué niveles de la jerarquía logró limpiar y cuáles no (porque no estaban vacíos).
*   **Uso real:** Desinstalación manual de servicios. Te permite ver hasta qué punto la estructura del software fue eliminada, dándote pistas de si quedaron archivos de configuración residuales en las carpetas superiores.

**6. El truco del SysAdmin: `find` + `rmdir`**
Cuando un servidor tiene miles de carpetas vacías que ralentizan el sistema:
```bash
find laboratorio02 -type d -empty -exec rmdir -v {} +
```
*   **Uso real:** **Mantenimiento Masivo**. Rastrea todo el laboratorio, identifica qué carpetas están vacías y las elimina todas de una vez de forma segura. Es mucho más seguro que usar `rm -rf`.

---

### 🔥 Tu Reto de SysAdmin con `rmdir`

Un desarrollador ha creado una estructura de pruebas en `laboratorio02/var/www/html/test/dev/alpha/` pero ya no la necesita.

**Misión:**
1.  Asegúrate de que no haya archivos en esa ruta (puedes usar `rm` si es necesario).
2.  Usa un **solo comando `rmdir`** para borrar toda la ruta (`test`, `dev` y `alpha`) de forma recursiva hacia atrás.
3.  Activa el modo **verbose** para ver la confirmación de la limpieza de cada nivel.

**¿Qué comando usarías para limpiar esa "basura" estructural sin afectar otros archivos de la carpeta `html`?**

*(Pista: El flag `-p` es la clave).*
