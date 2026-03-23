El comando **`mkdir` (make directory)** parece sencillo, pero en manos de un SysAdmin es la herramienta para construir arquitecturas de servidores en segundos. Un administrador nunca crea carpetas "una por una"; las proyecta y las despliega en masa con seguridad.

Aquí tienes la guía de `mkdir` para tu `laboratorio02`, estructurada por niveles de experiencia:

---

### Nivel 1: El Junior (Creación Básica)

**1. Creación de una carpeta simple:**
```bash
mkdir laboratorio02/etc/nginx
```
*   **Qué hace:** Crea un directorio llamado `nginx` dentro de `etc`.
*   **Uso real:** Preparar el espacio para instalar un nuevo servicio o aplicación.
*   **Peligro:** Si la carpeta padre (`etc`) no existe, el comando fallará con un error.

---

### Nivel 2: El Administrador Intermedio (Estructuras Profundas)

**2. Creación recursiva (`-p` de parents):**
```bash
mkdir -p laboratorio02/var/www/html/app/config/secret
```
*   **Qué hace:** Crea toda la ruta de carpetas de un solo golpe. Si los directorios intermedios no existen, los crea automáticamente sin dar error.
*   **Uso real:** Es el **comando favorito** de los SysAdmins. Se usa en scripts de despliegue automático para asegurar que la ruta de una base de datos o un sitio web exista antes de copiar los archivos.

---

### Nivel 3: El SysAdmin Senior (Despliegue Masivo)

**3. Expansión de llaves (`{}`) para múltiples carpetas:**
```bash
mkdir -p laboratorio02/var/log/apps/{frontend,backend,database,cache}
```
*   **Qué hace:** Crea 4 carpetas distintas bajo `apps` en una sola línea de comando.
*   **Uso real:** Organizar logs de microservicios. En lugar de ejecutar `mkdir` cuatro veces, proyectas la estructura completa. Ahorra tiempo y evita errores de tipeo.

---

### Nivel 4: El "Gurú" del Sistema (Seguridad y Confirmación)

**4. Definir permisos al crear (`-m` de mode):**
```bash
mkdir -m 700 laboratorio02/home/admin/.ssh
```
*   **Qué hace:** Crea la carpeta y le asigna inmediatamente permisos `700` (solo el dueño puede leer, escribir y entrar).
*   **Uso real:** **Seguridad Crítica**. Cuando creas carpetas sensibles (como las de llaves SSH o certificados SSL), no puedes dejar que existan ni un segundo con permisos públicos. Con `-m` garantizas la privacidad desde el nacimiento de la carpeta.

**5. Modo Verbose (`-v`):**
```bash
mkdir -pv laboratorio02/etc/ssl/{private,certs,csr}
```
*   **Qué hace:** Combina la recursividad (`-p`) con el reporte detallado (`-v`). El sistema te confirmará cada carpeta creada: `mkdir: created directory '...'`.
*   **Uso real:** Auditoría en scripts. Cuando ejecutas un script de instalación largo, el flag `-v` te permite ver en los logs exactamente qué carpetas se crearon y detectar si algo falló.

---

### 🔥 Tu Reto de SysAdmin con `mkdir`

Un nuevo cliente necesita una estructura de hosting para su sitio web.

**Misión:** Crea en una sola línea de comando la siguiente estructura dentro de `laboratorio02/var/www/`:
1.  Una carpeta llamada `cliente01`.
2.  Dentro de `cliente01`, tres subcarpetas: `public_html`, `logs` y `backups`.
3.  Asegúrate de que la carpeta `backups` tenga permisos **700** desde su creación.
4.  Activa el modo **verbose** para confirmar que todo se creó correctamente.

**¿Qué comando usarías para realizar este despliegue profesional?**

*(Pista: Puedes intentar combinar `{}` con las rutas, pero recuerda que el permiso `-m` se aplicaría a todas. Si quieres permisos diferentes, es mejor hacer la estructura general y luego la específica, o usar dos comandos encadenados con `&&`)*.
