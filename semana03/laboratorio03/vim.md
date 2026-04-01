# Guía de Operación y Configuración de Vim en Ubuntu

### `sudo apt update && sudo apt install vim`
**Contexto:** Muchas instalaciones de Ubuntu Server incluyen por defecto `vim-tiny`, una versión limitada que carece de funciones críticas. Al instalar la versión completa, habilitas el motor de coloreado de sintaxis y el soporte de comandos avanzados, lo cual es vital para no cometer errores visuales al editar archivos de configuración de red o de servicios donde un error de escritura puede deshabilitar el acceso al servidor.
**Reto:** Ejecuta el comando `vim --version`. En el bloque de texto que aparece, busca si las opciones `+syntax` y `+autocmd` están presentes. Si aparecen con un signo de menos (`-`), significa que tu versión es limitada. Instala la versión completa y verifica nuevamente. ¿Qué impacto crees que tiene para la seguridad operativa editar un archivo con cientos de líneas sin tener resaltado de sintaxis para diferenciar comentarios de comandos activos?

### `:help`, `CTRL-]`, `CTRL-T`
**Contexto:** En la administración remota de servidores por SSH, el manual interno de Vim es la fuente de consulta primaria cuando no hay acceso a buscadores externos. El comando `:help` abre la documentación oficial; `CTRL-]` permite saltar a términos específicos dentro del manual (hipervínculos) y `CTRL-T` regresa al punto anterior. Esta capacidad de consulta recursiva permite resolver dudas técnicas complejas sin abandonar la terminal.
**Reto:** Abre el archivo **/home/alumno/laboratorio03/etc/ssh/sshd_config**. Una vez dentro, usa el comando `:help syntax` para entender cómo Vim gestiona el coloreado de texto. Navega por la ayuda usando los saltos de hipervínculo y regresa. ¿Por qué es una ventaja estratégica dominar el sistema de ayuda interno en lugar de depender de tutoriales externos durante una incidencia en un servidor aislado?

### `i`, `ESC`, `:`
**Contexto:** Vim utiliza un diseño modal para priorizar la seguridad del archivo. El **Modo Normal** (estado inicial) actúa como un escudo que evita ediciones accidentales; el **Modo Insertar** (`i`) se usa exclusivamente para la entrada de texto; y el **Modo Línea de Comandos** (`:`) permite ejecutar tareas administrativas de Ubuntu, como guardar cambios o buscar patrones de texto. Esta separación de funciones es clave para mantener la integridad de los archivos del sistema.
**Reto:** Abre el archivo **/home/alumno/laboratorio03/etc/fstab**. Intenta moverte por el archivo y, solo cuando estés en la última línea, presiona `i` para insertar un comentario que diga `# Backup de montaje`. Luego, presiona `ESC` para volver al modo seguro. ¿De qué manera este diseño "modal" previene el error común de borrar o escribir caracteres accidentalmente al navegar por un archivo crítico del sistema operativo?

### `d`, `y`, `p`, `u`
**Contexto:** Estos comandos funcionan como verbos de acción directa y mnemotécnica. En Ubuntu, la rapidez de respuesta es fundamental: `dd` elimina líneas de configuración erróneas, `yy` copia parámetros funcionales y `p` los pega donde se requieran. Si una modificación manual en un archivo de red falla, el comando `u` (undo) permite una reversión inmediata al estado operativo anterior.
**Reto:** Abre el archivo **/home/alumno/laboratorio03/etc/hosts**. Ubica la línea que contiene `127.0.0.1`. Cópiala con `yy`, desplázate al final del archivo y pégala con `p`. Luego, borra ese duplicado con `dd` y finalmente recupéralo con `u`. En una conexión SSH con alta latencia (lag), ¿por qué usar comandos de teclado de una sola letra es más fiable y produce menos errores que intentar seleccionar y copiar texto con el mouse?

### `:x`, `ZZ`, `:q!`
**Contexto:** El cierre correcto de un archivo protege la auditoría y la estampa de tiempo del sistema. En Ubuntu, archivos como los de configuración de SSH no deben actualizar su fecha de modificación si no se han realizado cambios reales. Los comandos `:x` y `ZZ` graban el archivo solo si detectan cambios, mientras que `:q!` es la "salida de emergencia" obligatoria para abandonar una edición accidental sin alterar el archivo original.
**Reto:** Realiza una edición mínima en el archivo **/home/alumno/laboratorio03/etc/ssh/sshd_config** y sal usando `:x`. Luego, abre el mismo archivo, no realices ningún cambio y sal usando `:wq`. Ejecuta en la terminal el comando `ls -l /home/alumno/laboratorio03/etc/ssh/sshd_config` y observa la hora de modificación. ¿Por qué un administrador debe preferir `:x` sobre `:wq` para evitar falsos positivos en los sistemas de monitoreo de integridad de archivos?


Para continuar con el entrenamiento, es necesario ampliar el laboratorio. Ejecuta estos comandos para tener un set de archivos completo para los retos de administración:

```bash
# Ampliación del laboratorio 03
mkdir -p /home/alumno/laboratorio03/var/log
mkdir -p /home/alumno/laboratorio03/etc/network
cp /etc/services /home/alumno/laboratorio03/etc/services
cp /etc/passwd /home/alumno/laboratorio03/etc/passwd
cp /etc/group /home/alumno/laboratorio03/etc/group
# Simulamos un log para prácticas de búsqueda
journalctl -n 100 > /home/alumno/laboratorio03/var/log/syslog_sim
```

# Bloque 2: Movimiento y Navegación de Archivos

### `h`, `j`, `k`, `l`, `w`, `b`, `e`, `ge`
**Contexto:** Navegar por archivos extensos como **/etc/services** requiere precisión. Las flechas te obligan a mover la mano fuera del centro del teclado; `h-j-k-l` te mantienen en la "fila de inicio". `w` (word) y `b` (back) te permiten saltar entre palabras (nombres de servicios o números de puerto) instantáneamente.
**Reto:** Abre **/home/alumno/laboratorio03/etc/services**. Usa `w` para saltar de un nombre de protocolo a su puerto. ¿Por qué moverte por "palabras" es más eficiente que usar flechas laterales para llegar a un valor en una línea larga?

### `CTRL-G`
**Contexto:** Al auditar archivos de configuración largos, necesitas saber tu ubicación exacta para reportar fallos o documentar cambios. `CTRL-G` muestra en la barra inferior el nombre del archivo, el estado (modificado o no) y el porcentaje de avance.
**Reto:** Abre **/home/alumno/laboratorio03/etc/services**, desplázate hasta la mitad y presiona `CTRL-G`. ¿En qué situaciones de emergencia te serviría saber rápidamente el número de línea exacto de un error?

### `m<letra>`, `'<letra>`
**Contexto:** Imagina que estás comparando dos secciones distantes de **/etc/passwd**. Con `ma` creas una marca en la línea actual; tras navegar a otro lugar, presionar `'a` (comilla simple y la letra) te teletransporta de vuelta. Esto es vital para "mantener el dedo" sobre una línea crítica mientras investigas el resto del archivo.
**Reto:** En el archivo **/home/alumno/laboratorio03/etc/passwd**, marca la línea del usuario `root` con `mr`. Ve al final del archivo y luego regresa instantáneamente con `'r`. ¿Cómo mejora esto tu flujo de trabajo al verificar dependencias entre usuarios y grupos?

### ` `` ` (Doble comilla invertida)
**Contexto:** Vim recuerda automáticamente de dónde vienes. Si haces un salto largo (por ejemplo, al final del archivo con `G`), presionar ` `` ` te devuelve exactamente al lugar donde estabas antes del salto.
**Reto:** Abre **/home/alumno/laboratorio03/etc/services**, presiona `G` para ir al final y luego ` `` ` para volver. Si usaste una búsqueda para encontrar un error, ¿qué utilidad tiene este comando tras realizar la corrección?

### `I`, `A`, `o`, `O`
**Contexto:** La eficiencia al editar archivos como **/etc/fstab** depende de entrar al modo insertar en el lugar correcto. `I` inserta al inicio de la línea (ideal para comentar líneas con `#`), `A` al final (para añadir parámetros), `o` abre una línea nueva debajo y `O` arriba.
**Reto:** En **/home/alumno/laboratorio03/etc/fstab**, usa `I` para comentar una línea y `o` para añadir una nueva debajo. ¿Por qué usar estas variantes es mejor que presionar `i` y luego moverse con las flechas?


# Bloque 3: Repetición y Precisión de Búsqueda 

### `[número][comando]` (Repetición numérica)
**Contexto:** Un SysAdmin a menudo debe realizar acciones repetitivas, como borrar 10 líneas de un log o saltar 5 palabras. Anteponer un número a cualquier comando (ej: `10dd`) ejecuta la acción esa cantidad de veces.
**Reto:** En **/home/alumno/laboratorio03/etc/services**, intenta borrar 5 líneas de un solo golpe usando `5dd`. ¿Cómo ayuda esta técnica a prevenir el error de "borrar de más" por mantener presionada una tecla?

### `:set backspace=indent,eol,start`
**Contexto:** En algunas versiones de Ubuntu, la tecla Retroceso (Backspace) no se comporta como esperas en modo insertar. Configurar esta opción en tu entorno permite que puedas borrar sobre sangrías, saltos de línea y el punto donde iniciaste la inserción.
**Reto:** Entra a Vim, activa la opción con `:set backspace=indent,eol,start` y trata de borrar un salto de línea en modo insertar dentro de **/home/alumno/laboratorio03/etc/hosts**. ¿Por qué es fundamental que un SysAdmin configure su entorno para que el teclado responda de forma predecible?

### `CTRL-Y`, `CTRL-E` (En modo insertar)
**Contexto:** Al crear archivos de configuración con líneas muy similares (como una lista de puertos), estos comandos copian el carácter de la línea superior (`CTRL-Y`) o inferior (`CTRL-E`) sin salir del modo insertar.
**Reto:** En **/home/alumno/laboratorio03/etc/hosts**, abre una línea nueva con `o` y usa `CTRL-Y` repetidamente para clonar la dirección IP de la línea de arriba. ¿En qué escenario de configuración masiva de red ahorraría esto tiempo?

### `/`, `?`, `n`, `N`
**Contexto:** Localizar errores en un archivo de log como **/home/alumno/laboratorio03/var/log/syslog_sim** es una tarea diaria. `/` busca hacia adelante, `?` hacia atrás, `n` va a la siguiente coincidencia y `N` a la anterior.
**Reto:** Busca la palabra "error" en el log simulado usando `/error`. Usa `n` para navegar por todas las menciones. ¿Por qué buscar hacia atrás con `?` sería útil tras llegar al final de un log de sistema?

### `d/patrón`, `y/patrón`
**Contexto:** Los comandos de búsqueda también funcionan como "movimientos" para otros operadores. `d/error` borrará todo desde la posición actual hasta la próxima palabra "error".
**Reto:** En **/home/alumno/laboratorio03/etc/services**, colócate al inicio de una sección y usa `d/http`. ¿Qué precaución debe tener un administrador al usar una búsqueda para definir qué se va a borrar?

# Bloque 4: Optimización de Búsqueda y Sustitución

### `:set incsearch`
**Contexto:** Esta opción resalta la coincidencia mientras vas escribiendo la búsqueda. Es una ayuda visual crítica para confirmar que tu patrón es correcto antes de presionar Enter.
**Reto:** Activa la opción con `:set incsearch` y busca un puerto en **/home/alumno/laboratorio03/etc/services**. ¿Cómo ayuda el "resaltado en tiempo real" a evitar búsquedas fallidas en archivos grandes?

### `:set hlsearch`, `:nohlsearch`
**Contexto:** Al analizar un archivo de configuración, es útil mantener todas las coincidencias resaltadas para ver un patrón (ej: ver todas las IPs de una subred). Sin embargo, una vez terminado, el resaltado estorba; `:nohlsearch` lo limpia temporalmente.
**Reto:** Busca "ssh" en **/home/alumno/laboratorio03/etc/services** con el resaltado activo. Luego límpialo con `:noh`. ¿Por qué es importante para un SysAdmin saber limpiar el resaltado tras una búsqueda?

### `:s/antiguo/nuevo/g`
**Contexto:** Sustituir valores es una tarea común (ej: cambiar una IP vieja por una nueva en todo un archivo). El comando `:s` actúa sobre la línea actual, pero añadir `%` al inicio (`:%s/...`) actúa sobre todo el archivo.
**Reto:** En **/home/alumno/laboratorio03/etc/hosts**, cambia todas las menciones de `localhost` por `equipo-local` usando `:%s/localhost/equipo-local/g`. ¿Qué significa la `g` al final del comando?

### `yy`, `p` (Copia profunda)
**Contexto:** A diferencia del portapapeles de Windows/Mac, Vim maneja sus propios registros. `yy` copia la línea completa incluyendo el salto de línea, lo que garantiza que al pegar con `p` la estructura del archivo de configuración se mantenga perfecta.
**Reto:** Copia una línea de usuario en **/home/alumno/laboratorio03/etc/passwd** y pégala al final. ¿Qué sucede con el formato de la línea pegada?

### `"a`, `"b` (Registros numerados/nombrados)
**Contexto:** Por defecto, Vim sobrescribe lo que copiaste con lo último que borraste. Para evitar esto, puedes usar registros. `"ayw` copia una palabra en el registro 'a'. Luego puedes usarlo con `"ap`.
**Reto:** Copia el nombre de un servicio en el registro `"s` y su puerto en el registro `"p` en **/home/alumno/laboratorio03/etc/services**. ¿En qué caso un SysAdmin necesitaría mantener varios elementos copiados simultáneamente?


# Bloque 5: Viaje en el tiempo y Gestión de archivos

### `u`, `CTRL-R`, `g-`, `g+` (Undo/Redo ramificado)
**Contexto:** Vim no solo deshace cambios en línea recta, sino que guarda un historial de "ramas". Si deshaces algo, haces un cambio nuevo y te arrepientes, puedes volver a la "historia alterna" con `g-`.
**Reto:** Haz un cambio en **/home/alumno/laboratorio03/etc/hosts**, desházlo con `u`, haz un cambio distinto y usa `g-`. ¿Por qué el deshacer ramificado es un salvavidas frente a editores que pierden el historial al empezar una nueva edición tras un undo?

### `:edit`, `:next`, `gf`
**Contexto:** Un administrador a menudo debe saltar entre archivos. `:e` abre un archivo nuevo; `:next` va al siguiente en una lista. `gf` (go to file) es mágico: si el cursor está sobre una ruta de archivo dentro de un texto, abre ese archivo automáticamente.
**Reto:** En un archivo nuevo, escribe la ruta `/home/alumno/laboratorio03/etc/hosts`. Pon el cursor encima y presiona `gf`. ¿Cómo acelera esto la navegación cuando un archivo de configuración menciona a otro (como los archivos de sitios disponibles en NGINX)?

### `!sort`, `!!sort`
**Contexto:** Puedes enviar texto de Vim a un comando de Linux y recibir el resultado de vuelta. `!!sort` envía la línea actual al comando `sort` de Ubuntu.
**Reto:** En **/home/alumno/laboratorio03/etc/group**, selecciona visualmente unas líneas y usa `:!sort`. ¿Cuál es la ventaja de usar las herramientas del sistema operativo desde dentro de Vim?

### `:sort` (Interno)
**Contexto:** Vim tiene su propio motor de ordenamiento. Es más rápido que el externo para archivos grandes y permite opciones como `:sort u` para eliminar duplicados (unique).
**Reto:** Usa `:sort u` en **/home/alumno/laboratorio03/etc/hosts** tras haber duplicado líneas en retos anteriores. ¿Por qué es vital para un administrador limpiar líneas duplicadas en archivos como `hosts` o `authorized_keys`?

### `q:`, `q/`, `CTRL-F`
**Contexto:** A veces olvidas un comando complejo de búsqueda o sustitución que usaste hace 10 minutos. `q:` abre una pequeña ventana con el historial de comandos donde puedes editar y volver a ejecutar cualquiera de ellos.
**Reto:** Ejecuta varios comandos (búsquedas, sustituciones) y luego presiona `q:`. Selecciona uno, edítalo y presiona Enter. ¿Cómo ayuda esto a evitar errores de sintaxis en comandos largos de sustitución?

# Bloque 6: Automatización y Completado

### `<TAB>`, `CTRL-N`, `CTRL-P`
**Contexto:** Al editar archivos con nombres largos de variables o rutas en Ubuntu, escribir todo manualmente invita al error. `CTRL-N` busca la siguiente palabra que coincida con lo que has escrito basándose en el texto actual del archivo.
**Reto:** Abre **/home/alumno/laboratorio03/proyectos/check_status.sh**. En una línea nueva, escribe `SER` y presiona `CTRL-N`. ¿Cómo ayuda esto a mantener la consistencia en el nombre de las variables de un script?

### `CTRL-X CTRL-F`
**Contexto:** Un administrador a menudo necesita referenciar rutas de archivos. En modo insertar, esta combinación busca rutas reales en el sistema de archivos de Ubuntu y te permite autocompletarlas.
**Reto:** En **/home/alumno/laboratorio03/proyectos/check_status.sh**, intenta completar la ruta `/etc/ss` usando `CTRL-X CTRL-F`. ¿Por qué es más seguro usar el autocompletado de rutas que escribirlas de memoria?

### `netrw` (Editar directorios)
**Contexto:** Vim puede funcionar como un explorador de archivos. Si ejecutas `vim .` o abres una carpeta, entras en `netrw`. Desde aquí puedes navegar, renombrar (`R`) o borrar (`D`) archivos del sistema.
**Reto:** Ejecuta `vim /home/alumno/laboratorio03/etc/`. Navega por los archivos y presiona `i` para cambiar la vista. ¿Qué ventaja tiene explorar carpetas desde Vim frente al comando `ls` tradicional?

### `:set number` / `:set relativenumber`
**Contexto:** Las líneas de referencia son vitales al depurar errores reportados por el sistema (ej: "Error en línea 45"). El modo relativo ayuda a saber cuántas líneas arriba o abajo está un objetivo para comandos como `5jj`.
**Reto:** Abre **/home/alumno/laboratorio03/etc/services** y activa `:set number`. Luego prueba `:set relativenumber`. ¿En qué caso usarías el modo relativo para realizar una edición masiva?

### `:set textwidth=n`
**Contexto:** Al redactar documentación o comentarios en scripts, es una buena práctica limitar el ancho de línea (ej: 80 caracteres) para que sea legible en cualquier terminal de Ubuntu.
**Reto:** En el archivo **/home/alumno/laboratorio03/proyectos/check_status.sh**, activa `:set textwidth=40` y escribe un comentario largo. ¿Qué sucede cuando llegas al límite de caracteres?

# Bloque 7: Configuración y Persistencia

### `:set autowrite`
**Contexto:** Al administrar varios archivos, es fácil olvidar guardar antes de saltar al siguiente. Esta opción guarda automáticamente los cambios cuando cambias de buffer o sales de un archivo.
**Reto:** Activa `:set autowrite` en **/home/alumno/laboratorio03/etc/hosts**, haz un cambio y trata de abrir otro archivo con `:e /home/alumno/laboratorio03/etc/fstab`. ¿Cómo reduce esto el riesgo de pérdida de datos en una sesión de trabajo intensa?

### `.vimrc` (Configuración persistente)
**Contexto:** No es eficiente escribir tus preferencias cada vez que abres Vim. El archivo `.vimrc` en tu home de Ubuntu almacena estas órdenes para que se ejecuten automáticamente al iniciar.
**Reto:** Edita el archivo **/home/alumno/laboratorio03/.vimrc** y añade las líneas `set number` y `syntax on`. Cierra Vim y abre cualquier archivo. ¿Por qué el `.vimrc` es la herramienta de personalización más importante para un SysAdmin?

### `:options`
**Contexto:** Vim tiene cientos de parámetros configurables. El comando `:options` abre un panel interactivo donde puedes explorar y cambiar configuraciones agrupadas por categorías.
**Reto:** Ejecuta `:options` y busca la sección de "deleting text". ¿Cómo ayuda esta interfaz a un administrador novato a descubrir capacidades del editor?

### `:set expandtab` / `:set tabstop`
**Contexto:** En archivos `.yaml` (como Netplan en Ubuntu), el uso de tabuladores reales puede romper la configuración. `expandtab` convierte los tabuladores en espacios automáticamente.
**Reto:** Abre **/home/alumno/laboratorio03/etc/hosts**, activa `:set expandtab` y presiona la tecla TAB. Usa el comando `:set list` para ver los caracteres ocultos. ¿Por qué es crítico usar espacios en lugar de pestañas en configuraciones modernas de Linux?

### `:retab`
**Contexto:** Si heredas un archivo mal formateado con una mezcla de tabuladores y espacios, `:retab` redefine todo el archivo basándose en tus configuraciones actuales de `expandtab`.
**Reto:** En **/home/alumno/laboratorio03/etc/services**, cambia el valor de `:set tabstop=8` y ejecuta `:retab`. ¿Qué sucede con la alineación de las columnas de datos?

# Bloque 8: Recuperación y Bloques Visuales

### `vim -r` (Recuperación de crash)
**Contexto:** Si el servidor se apaga o pierdes la conexión SSH mientras editas, Vim guarda un archivo `.swp`. Al reconectar, puedes recuperar tu trabajo con este comando.
**Reto:** Abre **/home/alumno/laboratorio03/etc/fstab**, haz un cambio y cierra la terminal "matando" el proceso (no salgas de Vim). Intenta recuperar los cambios con `vim -r /home/alumno/laboratorio03/etc/fstab`. ¿Por qué es vital no borrar los archivos `.swp` inmediatamente tras un fallo?

### `:set backup`
**Contexto:** A diferencia del archivo swap, un backup es una copia del archivo original *antes* de tus cambios. Es una red de seguridad si decides que tu edición fue un error total.
**Reto:** Activa `:set backup` y edita **/home/alumno/laboratorio03/etc/hosts**. Revisa la carpeta y verás un archivo terminado en `~`. ¿En qué se diferencia esta protección de un simple "deshacer" (undo)?

### `v`, `V`, `CTRL-V` (Modos Visuales)
**Contexto:** El modo visual permite seleccionar texto. `v` es carácter por carácter, `V` es por líneas completas y `CTRL-V` es **bloque visual** (columnas).
**Reto:** En **/home/alumno/laboratorio03/etc/hosts**, usa `CTRL-V` para seleccionar solo la primera columna de direcciones IP. ¿Cómo facilita el modo bloque visual la edición de tablas o archivos con columnas fijas?

### `I` o `A` en Bloque Visual
**Contexto:** Una de las tareas más comunes es comentar un bloque de código. Con `CTRL-V` seleccionas el inicio de varias líneas, presionas `I`, escribes `# ` y presionas `ESC`.
**Reto:** Selecciona las primeras 3 líneas de **/home/alumno/laboratorio03/etc/services** con `CTRL-V` y coméntalas todas a la vez. ¿Por qué esta técnica es preferida por los administradores sobre editar línea por línea?

### `:abbreviate`
**Contexto:** Si escribes frecuentemente términos largos (ej: una dirección de correo o una ruta compleja), puedes crear una abreviatura que se expanda sola.
**Reto:** Ejecuta `:ab correo tunombre@empresa.com`. Entra en modo insertar en cualquier archivo y escribe `correo` seguido de un espacio. ¿Cómo ayuda esto a la estandarización de logs o comentarios en archivos de sistema?

# Bloque 9: Mapeo y Sintaxis 

### `:map`, `:nmap`, `:imap`
**Contexto:** Puedes asignar comandos complejos a una sola tecla. Por ejemplo, mapear una tecla para que guarde y ejecute un script de un solo golpe.
**Reto:** Ejecuta `:nmap <F2> :w<CR>`. Ahora presiona F2 en modo normal en **/home/alumno/laboratorio03/proyectos/check_status.sh**. ¿Qué significa el `<CR>` al final del mapeo?

### `:syntax enable` / `:syntax off`
**Contexto:** El resaltado de sintaxis ayuda a detectar errores, pero en archivos de texto plano masivos puede ralentizar la terminal.
**Reto:** Abre **/home/alumno/laboratorio03/etc/services** y prueba apagar y encender la sintaxis. ¿En qué escenario extremo un SysAdmin preferiría trabajar sin colores?

### `:make` (Quickfix)
**Contexto:** Vim puede integrar la salida de comandos externos para saltar directamente a los errores. Aunque se usa mucho en programación, un SysAdmin puede usarlo para validar scripts.
**Reto:** Ejecuta `:make` (necesitarás un archivo Makefile, pero observa cómo Vim intenta invocar un compilador externo). ¿Cómo ayuda la ventana "Quickfix" a gestionar múltiples errores?

### `:set autoindent`
**Contexto:** Al escribir scripts de Bash o archivos de configuración anidados, mantener la sangría es vital para la lógica. `autoindent` copia la sangría de la línea anterior a la nueva.
**Reto:** En **/home/alumno/laboratorio03/proyectos/check_status.sh**, añade un nuevo bloque `if` y observa cómo el cursor se alinea solo. ¿Por qué la sangría correcta no es solo estética sino funcional en administración?

### `:set smartindent`
**Contexto:** A diferencia de `autoindent`, `smartindent` entiende la lógica del lenguaje (como abrir una llave `{`) y aumenta la sangría automáticamente en la siguiente línea.
**Reto:** Activa `:set smartindent` y edita un archivo `.c` o un script con llaves. ¿Cómo reduce esto la carga mental del administrador al escribir código?

# Bloque 10: Herramientas del Sistema y Despedida

### `ctags` (Play tag)
**Contexto:** En proyectos con muchos archivos, `ctags` crea un índice de todas las funciones. Presionar `CTRL-]` sobre el nombre de una función te lleva a su definición, incluso en otro archivo.
**Reto:** (Si tienes instalado `universal-ctags`) ejecuta `ctags -R .` en tu carpeta de proyectos. Intenta navegar entre definiciones. ¿Cómo ayuda esto a entender scripts complejos de administración que llaman a múltiples librerías?

### `:autocmd`
**Contexto:** Puedes decirle a Vim que ejecute acciones basadas en eventos, como "cada vez que abra un archivo .sh, activa el resaltado de sintaxis".
**Reto:** Ejecuta `:autocmd BufNewFile *.sh 0read /home/alumno/laboratorio03/proyectos/check_status.sh`. Ahora crea un archivo nuevo llamado `test.sh`. ¿Qué sucede?

### `K` (Consultar el Manual)
**Contexto:** Es el comando definitivo. En modo normal, posiciona el cursor sobre cualquier comando de Linux (ej: `ls`, `ssh`, `mount`) y presiona `K`.
**Reto:** En **/home/alumno/laboratorio03/proyectos/check_status.sh**, pon el cursor sobre la palabra `systemctl` y presiona `K`. ¿Qué sucede?

### `:help tutor`
**Contexto:** Vim incluye un tutorial interactivo de 30 minutos diseñado para fijar todos los conocimientos básicos.
**Reto:** Ejecuta en tu terminal `vimtutor`. ¿Por qué incluso un administrador experimentado debería volver al tutor de vez en cuando?

### `less.sh` (Vim como visualizador)
**Contexto:** Puedes usar el motor de Vim para leer archivos (como logs) con colores pero sin riesgo de editarlos, usando el script `less.sh` que viene con el runtime de Vim.
**Reto:** Ejecuta `/usr/share/vim/vim*/macros/less.sh /home/alumno/laboratorio03/var/log/syslog_sim`. ¿Qué ventaja tiene este visualizador frente al `less` estándar?
