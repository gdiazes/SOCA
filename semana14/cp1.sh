#!/bin/bash
# ==========================================
# Autor: Instructor Sysadmin / Antigravity IDE
# Fecha: 2026-06-15
# Tema: Guía Docente - Fundamentos de Bash con Ganchos de Aprendizaje
# Versión: 3.0
# Uso: Copiar y pegar cada bloque en la terminal. Usar las preguntas
#      predefinidas ANTES de ejecutar el código para fomentar la deducción.
# ==========================================

# ---------------------------------------------------------
# DEMO 1: VERSIÓN Y ENTORNO DE BASH
# ---------------------------------------------------------

# OBJETIVO: Mostrar a los alumnos cómo identificar la versión del intérprete.
# ESPERADO: Imprime la versión exacta de Bash (ej. 5.1.16).
# PREGUNTA: "Si descargan un script de internet que funciona en el tutorial pero falla en nuestro servidor, ¿por qué ejecutar esto es el primer paso de un buen Sysadmin?"
echo "Versión de Bash actual: $BASH_VERSION"


# ---------------------------------------------------------
# DEMO 2: JERARQUÍA DE COMANDOS (TYPE)
# ---------------------------------------------------------

# OBJETIVO: Demostrar que los comandos pueden ser 'built-in', 'alias' o 'file'.
# ESPERADO: Mostrará 'builtin' para pwd y la ruta o 'alias' para ls.
# PREGUNTA: "Si ustedes crean su propio binario llamado 'ls' para hackear el sistema, ¿por qué Bash seguirá ejecutando el 'ls' original del sistema? ¿Quién tiene prioridad en la memoria?"
type -t pwd
type -a ls


# ---------------------------------------------------------
# DEMO 3: CÓDIGOS DE SALIDA (EXIT STATUS) Y LÓGICA (||, &&)
# ---------------------------------------------------------

# OBJETIVO: Forzar un error para visualizar cómo Bash reporta el fracaso (Exit != 0).
# ESPERADO: El ls fallará en silencio. Se ejecuta la segunda parte del OR (||).
# PREGUNTA: "Si el comando de la izquierda fuera 'conectar_base_datos', ¿qué operador usaríamos para enviar una alerta de caída a nuestro Telegram SOLO si falla la conexión?"
ls /directorio_que_no_existe > /dev/null 2>&1 || echo "Fallo capturado. El comando anterior no fue exitoso."

# OBJETIVO: Leer explícitamente el código numérico del error anterior.
# ESPERADO: Mostrará un '2' (o un número mayor a 0).
echo "El código de salida (Exit Status) del fallo fue: $?"

# OBJETIVO: Usar el operador AND (&&) para comandos dependientes del éxito (Exit == 0).
# ESPERADO: Imprime el mensaje solo porque 'pwd' es exitoso.
# PREGUNTA: "Si estamos haciendo un script de respaldo, ¿por qué es crítico usar '&&' entre el comando 'crear_zip' y el comando 'borrar_archivos_originales'?"
pwd > /dev/null && echo "Comando exitoso. Todo en orden (Exit: $?)"


# ---------------------------------------------------------
# DEMO 4: EL PODER DE LAS COMILLAS (QUOTING)
# ---------------------------------------------------------

# OBJETIVO: Contrastar la expansión de variables ("") vs. caracteres literales ('').
# ESPERADO: El primero expande $USER (ej. root), el segundo imprime la palabra '$USER'.
# PREGUNTA: "Si la contraseña de base de datos de un cliente es 'M1P@$$w0rd', ¿qué tipo de comillas deben usar en el script para evitar que Bash intente ejecutar la variable vacía '$w0rd' y rompa el acceso?"
echo "Con comillas dobles (Expansión): Bienvenido, $USER"
echo 'Con comillas simples (Literal): Bienvenido, $USER'


# ---------------------------------------------------------
# DEMO 5: ARGUMENTOS POSICIONALES (INYECCIÓN EN VIVO)
# ---------------------------------------------------------

# OBJETIVO: Simular la inyección de argumentos en la sesión sin crear un archivo extra.
# ESPERADO: Carga silenciosamente "Servidor_Web" y "Base_Datos" en $1 y $2.
# PREGUNTA: "Si estamos programando una herramienta de automatización, ¿cómo le indicaría el usuario a nuestro script que quiere reiniciar 'apache2' usando solo argumentos posicionales en la terminal?"
set -- "Servidor_Web" "Base_Datos"

# OBJETIVO: Mostrar cómo Bash procesa los parámetros simulados.
# ESPERADO: Imprimirá los valores inyectados y el conteo total (2).
echo "Primer argumento (\$1): $1"
echo "Segundo argumento (\$2): $2"
echo "Total de argumentos (\$#): $#"


# ---------------------------------------------------------
# DEMO 6: DEPURACIÓN DE CÓDIGO (DEBUGGING CON -x)
# ---------------------------------------------------------

# OBJETIVO: Activar el modo trazado de Bash para inspeccionar flujos de ejecución.
# ESPERADO: Cada comando ejecutado mostrará primero un '+' antes de arrojar su salida.
# PREGUNTA: "Tienen un script de 500 líneas que de repente se detiene y no arroja ningún mensaje de error en pantalla. ¿Cómo nos salva la vida activar el modo '-x' en este escenario?"
set -x
echo "Este comando se evaluará visiblemente en la terminal."
set +x