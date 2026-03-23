El **File Globbing** (o simplemente *Globbing*) no es un comando en sí mismo, sino una característica fundamental del intérprete de comandos (Bash, Zsh, etc.). Es la capacidad de usar **comodines (wildcards)** para seleccionar múltiples nombres de archivos o directorios basándose en patrones, sin tener que escribir cada nombre individualmente.

Para un SysAdmin, dominar el globbing es la diferencia entre pasar 10 minutos borrando logs uno por uno o limpiarlos todos en un milisegundo.

Aquí tienes la guía de **File Globbing** para tu **`laboratorio02`**, desde el asterisco básico hasta los patrones extendidos de Bash.

---

### Preparación del Escenario
Necesitamos una carpeta con un caos organizado de archivos para que los patrones de globbing puedan brillar. Ejecuta este bloque:

```bash
mkdir -p laboratorio02/var/log/globbing_test

# 1. Creamos una docena de logs de diferentes servicios y fechas
touch laboratorio02/var/log/globbing_test/{syslog,auth,kern,mail}.log
touch laboratorio02/var/log/globbing_test/syslog.{1..5}.gz
touch laboratorio02/var/log/globbing_test/auth.log.{old,bak}
touch laboratorio02/var/log/globbing_test/error_2023-10-{01..15}.log

# 2. Creamos archivos de configuración con variaciones de nombre
touch laboratorio02/var/log/globbing_test/config_{a,b,c}.ini
touch laboratorio02/var/log/globbing_test/config_{A,B,C}.ini

# 3. Creamos un archivo oculto
touch laboratorio02/var/log/globbing_test/.secret_history

echo "Caos de archivos generado. ¡Usa 'ls' para verlo todo mezclado!"
ls laboratorio02/var/log/globbing_test/
```

---

### Nivel 1: El Junior (El Asterisco y el Símbolo de Interrogación)

**1. El Asterisco (`*`): "Cero o más caracteres"**
```bash
ls -l laboratorio02/var/log/globbing_test/*.log
```
*   **Qué hace:** Lista cualquier archivo que termine exactamente en `.log`, sin importar lo que haya antes del punto.
*   **Uso real:** La operación más común en Linux. Borrar, mover o listar todos los archivos de un tipo específico (`rm *.tmp`, `cp *.conf /backup`).

**2. El Símbolo de Interrogación (`?`): "Exactamente un carácter"**
```bash
ls -l laboratorio02/var/log/globbing_test/config_?.ini
```
*   **Qué hace:** Lista `config_a.ini`, `config_b.ini`, `config_A.ini`, etc. Pero **no** listaría `config_ab.ini` si existiera, porque `?` solo cubre una sola letra o número.
*   **Uso real:** Tienes logs rotados diarios (`log.1`, `log.2`... `log.10`). Si usas `rm log.*` borrarías todos. Si usas `rm log.?` borrarías del 1 al 9, pero conservarías el 10, 11, etc.

---

### Nivel 2: El Administrador Intermedio (Clases de Caracteres)

**3. Los Corchetes (`[]`): "Cualquiera de estos caracteres"**
```bash
ls -l laboratorio02/var/log/globbing_test/syslog.[135].gz
```
*   **Qué hace:** Lista **solamente** `syslog.1.gz`, `syslog.3.gz` y `syslog.5.gz`. Ignora el 2 y el 4.
*   **Uso real:** Seleccionar archivos muy específicos sin escribir el nombre completo de cada uno. Útil cuando necesitas revisar los logs de los servidores web impares (ej. `web[135].empresa.com`).

**4. Rangos dentro de corchetes (`[a-z]`, `[0-9]`):**
```bash
ls -l laboratorio02/var/log/globbing_test/error_2023-10-0[1-5].log
```
*   **Qué hace:** Lista los logs de error desde el día 01 hasta el 05.
*   **Uso real:** Auditar incidentes en un rango de fechas exacto. Imagina que el ataque ocurrió la primera semana del mes; este comando filtra solo esos días al instante.

---

### Nivel 3: El SysAdmin Senior (Negación y Mayúsculas/Minúsculas)

**5. Negación con el signo de exclamación o acento circunflejo (`[!...]` o `[^...]`):**
```bash
ls -l laboratorio02/var/log/globbing_test/config_[!a-z].ini
```
*   **Qué hace:** Lista los archivos `config_A.ini`, `B` y `C`, pero **ignora** los que tienen letras minúsculas. (Nota: En Bash, la forma estándar POSIX es `!`, pero `^` suele funcionar también).
*   **Uso real:** "Dame todos los archivos que NO empiecen por un número" (`rm [!0-9]*`). Vital para limpiar basuras generadas por scripts defectuosos sin tocar los archivos de sistema bien nombrados.

**6. El problema de los archivos ocultos (Dotglob):**
Por defecto, el asterisco `*` **no atrapa** archivos que empiezan con un punto (`.`).
```bash
# Esto NO listará .secret_history
ls -ld laboratorio02/var/log/globbing_test/*

# Para forzar a Bash a que el asterisco incluya archivos ocultos (Nivel Gurú):
shopt -s dotglob
ls -ld laboratorio02/var/log/globbing_test/*
shopt -u dotglob # Desactivamos para no romper el comportamiento normal
```
*   **Uso real:** **Migraciones completas**. Muchos SysAdmins novatos hacen `cp -r /var/www/html/* /nuevo_server/` y luego se preguntan por qué el sitio web se rompió (el `*` ignoró el archivo `.htaccess`).

---

### Nivel 4: El "Gurú" del Sistema (Globbing Extendido - Extglob)

Bash tiene "superpoderes" ocultos que debes activar con el comando `shopt -s extglob`. Esto permite hacer patrones lógicos (`OR`, `NOT`) súper complejos.

**7. Múltiples patrones a la vez (`@(...)` o `+(...)`):**
Asegúrate de activar extglob primero:
```bash
shopt -s extglob
ls -l laboratorio02/var/log/globbing_test/@(*.log|*.gz)
```
*   **Qué hace:** Lista cualquier archivo que termine en `.log` **O** en `.gz` en un solo comando.
*   **Uso real:** Agrupar tareas. "Comprime todo lo que sea un log de texto plano, pero ignora los que ya son .gz o .bak".

**8. La exclusión suprema (`!(...)`):**
```bash
ls -l laboratorio02/var/log/globbing_test/!(syslog*|*.gz)
```
*   **Qué hace:** Lista **todo** el contenido de la carpeta, **EXCEPTO** los archivos que empiezan por "syslog" y los que terminan en ".gz".
*   **Uso real:** **Limpiezas hiper-peligrosas**. "Borra todos los archivos de esta carpeta, excepto el archivo de configuración y el binario principal". (`rm !(*.conf|*.bin)`). ¡Usar con extrema precaución!

---

### 🔥 Tu Reto de SysAdmin con File Globbing

Un script de rotación de logs falló y llenó la carpeta `/var/log/globbing_test/` con archivos `.bak` y `.old` del servicio `auth`.

**Misión:**
1.  Debes listar (`ls -l`) **solamente** los archivos que pertenezcan al servicio `auth`.
2.  De esos archivos `auth`, solo debes listar los que tengan extensión **`.bak` o `.old`**.
3.  **No puedes** usar `extglob` (los superpoderes del nivel 4), debes hacerlo usando solo las herramientas del Nivel 1 y 2 (Corchetes y Asteriscos).
4.  Debes hacerlo en un solo comando corto y elegante.

**¿Qué comando de globbing usarías para visualizar exactamente esa "basura" antes de borrarla con `rm`?**

*(Pista: Intenta combinar la palabra "auth", un comodín, y luego agrupa las extensiones que te interesan o usa la expansión de llaves que vimos en comandos anteriores).*
